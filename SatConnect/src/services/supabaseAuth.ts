import 'react-native-url-polyfill/auto';

import AsyncStorage from '@react-native-async-storage/async-storage';
import { createClient, type Session as SupabaseSession, type User as SupabaseUser } from '@supabase/supabase-js';

import { hasSupabaseConfig, runtimeConfig } from './runtimeConfig';

export interface AuthUser {
  id: string;
  email: string;
  name: string;
  createdAt: string;
}

export interface AuthSession {
  user: AuthUser;
  token: string;
  expiresAt: string;
}

export interface AuthResult {
  success: boolean;
  session?: AuthSession;
  error?: string;
  message?: string;
  needsEmailConfirmation?: boolean;
}

const AUTH_SESSION_KEY = '@satconnect_auth_session';
const SYNC_QUEUE_KEY = '@satconnect_supabase_sync_queue';

const supabase = hasSupabaseConfig
  ? createClient(runtimeConfig.supabaseUrl!, runtimeConfig.supabaseAnonKey!, {
      auth: {
        storage: AsyncStorage,
        autoRefreshToken: true,
        persistSession: true,
        detectSessionInUrl: false,
      },
    })
  : null;

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function buildFallbackName(email: string): string {
  const localPart = email.split('@')[0] ?? 'Utilizator';
  return localPart.charAt(0).toUpperCase() + localPart.slice(1);
}

function mapSupabaseUser(user: SupabaseUser): AuthUser {
  const metadata = user.user_metadata as Record<string, unknown> | undefined;
  const fullName =
    typeof metadata?.full_name === 'string' && metadata.full_name.trim().length > 0
      ? metadata.full_name.trim()
      : typeof metadata?.name === 'string' && metadata.name.trim().length > 0
        ? metadata.name.trim()
        : buildFallbackName(user.email ?? 'utilizator@satconnect.app');

  return {
    id: user.id,
    email: user.email ?? '',
    name: fullName,
    createdAt: user.created_at ?? new Date().toISOString(),
  };
}

function mapSession(session: SupabaseSession): AuthSession {
  return {
    user: mapSupabaseUser(session.user),
    token: session.access_token,
    expiresAt: new Date(
      session.expires_at ? session.expires_at * 1000 : Date.now(),
    ).toISOString(),
  };
}

function normalizeAuthError(message: string): string {
  if (message.includes('Invalid login credentials')) {
    return 'Email sau parolă incorectă.';
  }
  if (message.includes('Email not confirmed')) {
    return 'Confirmă emailul înainte să te conectezi.';
  }
  if (message.includes('Password should be at least')) {
    return 'Parola trebuie să aibă cel puțin 6 caractere.';
  }
  if (message.includes('User already registered')) {
    return 'Există deja un cont cu acest email.';
  }
  return message;
}

async function persistSession(session: AuthSession | null): Promise<void> {
  if (session) {
    await AsyncStorage.setItem(AUTH_SESSION_KEY, JSON.stringify(session));
  } else {
    await AsyncStorage.removeItem(AUTH_SESSION_KEY);
  }
}

class SupabaseAuthService {
  private session: AuthSession | null = null;

  private async syncProfile(authSession: AuthSession): Promise<void> {
    if (!supabase) return;
    try {
      await supabase.from('profiles').upsert(
        {
          id: authSession.user.id,
          email: authSession.user.email,
          name: authSession.user.name,
          plan: 'basic',
          updated_at: new Date().toISOString(),
        },
        { onConflict: 'id' },
      );
    } catch {
      // Profile table may not exist yet — keep auth working regardless.
    }
  }

  async initialize(): Promise<AuthSession | null> {
    if (supabase) {
      const { data, error } = await supabase.auth.getSession();
      if (!error && data.session) {
        this.session = mapSession(data.session);
        await persistSession(this.session);
        await this.syncProfile(this.session);
        return this.session;
      }
    }

    const stored = await AsyncStorage.getItem(AUTH_SESSION_KEY);
    if (!stored) {
      this.session = null;
      return null;
    }

    const parsed = JSON.parse(stored) as AuthSession;
    if (new Date(parsed.expiresAt) <= new Date()) {
      await persistSession(null);
      this.session = null;
      return null;
    }

    this.session = parsed;
    return this.session;
  }

  async signUp(email: string, password: string, name: string): Promise<AuthResult> {
    if (!email.includes('@')) {
      return { success: false, error: 'Email invalid.' };
    }
    if (password.length < 6) {
      return { success: false, error: 'Parola trebuie să aibă cel puțin 6 caractere.' };
    }

    if (!hasSupabaseConfig || !supabase) {
      await delay(1200);
      const session: AuthSession = {
        user: { id: `user_${Date.now()}`, email, name, createdAt: new Date().toISOString() },
        token: `mock_token_${Date.now()}`,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
      };
      this.session = session;
      await persistSession(session);
      return { success: true, session, message: 'Cont demo creat. Configurează Supabase pentru conturi reale.' };
    }

    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: name, name, plan: 'basic' } },
    });

    if (error) return { success: false, error: normalizeAuthError(error.message) };

    if (data.session) {
      const session = mapSession(data.session);
      this.session = session;
      await persistSession(session);
      await this.syncProfile(session);
      return { success: true, session, message: 'Cont creat cu succes.' };
    }

    if (data.user) {
      return {
        success: true,
        message: 'Cont creat. Verifică emailul pentru confirmare, apoi conectează-te.',
        needsEmailConfirmation: true,
      };
    }

    return { success: false, error: 'Nu am putut crea contul.' };
  }

  async signIn(email: string, password: string): Promise<AuthResult> {
    if (!email.includes('@')) {
      return { success: false, error: 'Email invalid.' };
    }

    if (!hasSupabaseConfig || !supabase) {
      await delay(900);
      const session: AuthSession = {
        user: { id: `user_${Date.now()}`, email, name: buildFallbackName(email), createdAt: new Date().toISOString() },
        token: `mock_token_${Date.now()}`,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
      };
      this.session = session;
      await persistSession(session);
      return { success: true, session, message: 'Conectare demo. Configurează Supabase pentru autentificare reală.' };
    }

    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) return { success: false, error: normalizeAuthError(error.message) };
    if (!data.session) return { success: false, error: 'Nu am primit sesiunea.' };

    const session = mapSession(data.session);
    this.session = session;
    await persistSession(session);
    await this.syncProfile(session);
    return { success: true, session };
  }

  async signOut(): Promise<void> {
    if (supabase) {
      await supabase.auth.signOut();
    }
    this.session = null;
    await persistSession(null);
  }

  async resetPassword(email: string): Promise<{ success: boolean; error?: string; message?: string }> {
    if (!email.includes('@')) {
      return { success: false, error: 'Email invalid.' };
    }

    if (!hasSupabaseConfig || !supabase) {
      await delay(1200);
      return { success: true, message: 'Link demo de reset simulat. Configurează Supabase pentru email real.' };
    }

    const { error } = await supabase.auth.resetPasswordForEmail(email);
    if (error) return { success: false, error: normalizeAuthError(error.message) };
    return { success: true, message: 'Linkul de resetare a fost trimis pe email.' };
  }

  getSession(): AuthSession | null {
    return this.session;
  }

  getUser(): AuthUser | null {
    return this.session?.user ?? null;
  }

  isAuthenticated(): boolean {
    if (!this.session) return false;
    return new Date(this.session.expiresAt) > new Date();
  }

  isUsingRealBackend(): boolean {
    return hasSupabaseConfig;
  }
}

// ---------------------------------------------------------------------------
// Data-sync service (offline queue)
// ---------------------------------------------------------------------------

export interface SyncOperation {
  id: string;
  type: 'message' | 'location' | 'contact' | 'preference';
  action: 'create' | 'update' | 'delete';
  data: Record<string, unknown>;
  timestamp: string;
  synced: boolean;
}

class DataSyncService {
  private queue: SyncOperation[] = [];

  async loadQueue(): Promise<void> {
    const stored = await AsyncStorage.getItem(SYNC_QUEUE_KEY);
    if (stored) {
      this.queue = JSON.parse(stored) as SyncOperation[];
    }
  }

  async addToQueue(operation: Omit<SyncOperation, 'id' | 'timestamp' | 'synced'>): Promise<void> {
    const op: SyncOperation = {
      ...operation,
      id: `sync_${Date.now()}_${Math.random().toString(36).substring(2, 8)}`,
      timestamp: new Date().toISOString(),
      synced: false,
    };
    this.queue.push(op);
    await AsyncStorage.setItem(SYNC_QUEUE_KEY, JSON.stringify(this.queue));
  }

  async syncAll(): Promise<{ synced: number; failed: number }> {
    await delay(1500);
    let synced = 0;
    let failed = 0;
    for (const op of this.queue) {
      if (!op.synced) {
        if (Math.random() > 0.05) {
          op.synced = true;
          synced++;
        } else {
          failed++;
        }
      }
    }
    this.queue = this.queue.filter((op) => !op.synced);
    await AsyncStorage.setItem(SYNC_QUEUE_KEY, JSON.stringify(this.queue));
    return { synced, failed };
  }

  getPendingCount(): number {
    return this.queue.filter((op) => !op.synced).length;
  }

  getQueue(): SyncOperation[] {
    return [...this.queue];
  }
}

export const supabaseAuth = new SupabaseAuthService();
export const dataSync = new DataSyncService();

/**
 * SQL to run once in the Supabase SQL editor to create the profiles table:
 *
 * create table if not exists public.profiles (
 *   id uuid primary key,
 *   email text unique not null,
 *   name text not null,
 *   plan text not null default 'basic',
 *   created_at timestamptz not null default now(),
 *   updated_at timestamptz not null default now()
 * );
 * alter table public.profiles enable row level security;
 * create policy "Users can read own profile" on public.profiles for select using (auth.uid() = id);
 * create policy "Users can insert own profile" on public.profiles for insert with check (auth.uid() = id);
 * create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);
 */
