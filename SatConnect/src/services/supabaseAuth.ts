/**
 * Supabase Auth Service Scaffold
 * 
 * This is a scaffold for real Supabase integration.
 * Replace the mock implementations with real Supabase client calls
 * when ready to connect to a real backend.
 * 
 * To activate:
 * 1. npm install @supabase/supabase-js
 * 2. Create a Supabase project at supabase.com
 * 3. Replace SUPABASE_URL and SUPABASE_ANON_KEY with real values
 * 4. Uncomment the real implementation sections
 */

import AsyncStorage from '@react-native-async-storage/async-storage';

// Supabase configuration (replace with real values)
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key';

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

interface AuthResult {
  success: boolean;
  session?: AuthSession;
  error?: string;
}

const AUTH_SESSION_KEY = '@satconnect_auth_session';

/**
 * Mock auth service that simulates Supabase behavior.
 * Replace with real Supabase client when ready.
 */
class SupabaseAuthService {
  private session: AuthSession | null = null;

  async initialize(): Promise<AuthSession | null> {
    const stored = await AsyncStorage.getItem(AUTH_SESSION_KEY);
    if (stored) {
      this.session = JSON.parse(stored);
      return this.session;
    }
    return null;
  }

  async signUp(email: string, password: string, name: string): Promise<AuthResult> {
    // Mock implementation - simulates network delay
    await new Promise((resolve) => setTimeout(resolve, 1500));

    // Simulate validation
    if (!email.includes('@')) {
      return { success: false, error: 'Email invalid' };
    }
    if (password.length < 6) {
      return { success: false, error: 'Parola trebuie să aibă cel puțin 6 caractere' };
    }

    const session: AuthSession = {
      user: {
        id: `user_${Date.now()}`,
        email,
        name,
        createdAt: new Date().toISOString(),
      },
      token: `mock_token_${Date.now()}`,
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
    };

    this.session = session;
    await AsyncStorage.setItem(AUTH_SESSION_KEY, JSON.stringify(session));

    return { success: true, session };
  }

  async signIn(email: string, password: string): Promise<AuthResult> {
    await new Promise((resolve) => setTimeout(resolve, 1000));

    if (!email.includes('@')) {
      return { success: false, error: 'Email invalid' };
    }

    const session: AuthSession = {
      user: {
        id: `user_${Date.now()}`,
        email,
        name: email.split('@')[0],
        createdAt: new Date().toISOString(),
      },
      token: `mock_token_${Date.now()}`,
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
    };

    this.session = session;
    await AsyncStorage.setItem(AUTH_SESSION_KEY, JSON.stringify(session));

    return { success: true, session };
  }

  async signOut(): Promise<void> {
    this.session = null;
    await AsyncStorage.removeItem(AUTH_SESSION_KEY);
  }

  async resetPassword(email: string): Promise<{ success: boolean; error?: string }> {
    await new Promise((resolve) => setTimeout(resolve, 1500));

    if (!email.includes('@')) {
      return { success: false, error: 'Email invalid' };
    }

    // In production, this would send a real email via Supabase
    return { success: true };
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
}

// Data sync scaffold
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
  private readonly SYNC_QUEUE_KEY = '@satconnect_sync_queue';

  async loadQueue(): Promise<void> {
    const stored = await AsyncStorage.getItem(this.SYNC_QUEUE_KEY);
    if (stored) {
      this.queue = JSON.parse(stored);
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
    await AsyncStorage.setItem(this.SYNC_QUEUE_KEY, JSON.stringify(this.queue));
  }

  async syncAll(): Promise<{ synced: number; failed: number }> {
    // Mock sync - in production, this would batch-send to Supabase
    await new Promise((resolve) => setTimeout(resolve, 2000));

    let synced = 0;
    let failed = 0;

    for (const op of this.queue) {
      if (!op.synced) {
        // Simulate 95% success rate
        if (Math.random() > 0.05) {
          op.synced = true;
          synced++;
        } else {
          failed++;
        }
      }
    }

    // Remove synced items
    this.queue = this.queue.filter((op) => !op.synced);
    await AsyncStorage.setItem(this.SYNC_QUEUE_KEY, JSON.stringify(this.queue));

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
