import { createContext, useContext, useEffect, useState, ReactNode } from 'react'
import { supabase } from './supabase'
import type { User, Session } from '@supabase/supabase-js'

export type Plan = 'free' | 'pro' | 'business'

interface Profile {
  id: string
  email: string
  name: string
  plan: Plan
  daily_searches: number
  last_search_date: string
}

interface AuthState {
  user: User | null
  session: Session | null
  profile: Profile | null
  loading: boolean
  signIn: (email: string, password: string) => Promise<{ error: string | null }>
  signUp: (email: string, password: string, name: string) => Promise<{ error: string | null }>
  signOut: () => Promise<void>
  resetPassword: (email: string) => Promise<{ error: string | null }>
  signInWithGoogle: () => Promise<void>
  canSearch: () => boolean
  incrementSearch: () => void
  remainingSearches: () => number
}

const AuthContext = createContext<AuthState>({} as AuthState)

const FREE_DAILY_LIMIT = 5

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [session, setSession] = useState<Session | null>(null)
  const [profile, setProfile] = useState<Profile | null>(null)
  const [loading, setLoading] = useState(true)

  const loadProfile = async (u: User) => {
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', u.id)
      .single()

    if (data) {
      setProfile(data as Profile)
    } else {
      const newProfile: Partial<Profile> = {
        id: u.id,
        email: u.email || '',
        name: u.user_metadata?.name || u.email?.split('@')[0] || '',
        plan: 'free',
        daily_searches: 0,
        last_search_date: new Date().toISOString().split('T')[0],
      }
      await supabase.from('profiles').upsert(newProfile)
      setProfile(newProfile as Profile)
    }
  }

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session: s } }) => {
      setSession(s)
      setUser(s?.user ?? null)
      if (s?.user) loadProfile(s.user)
      setLoading(false)
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, s) => {
      setSession(s)
      setUser(s?.user ?? null)
      if (s?.user) loadProfile(s.user)
      else setProfile(null)
    })

    return () => subscription.unsubscribe()
  }, [])

  const signIn = async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    return { error: error?.message ?? null }
  }

  const signUp = async (email: string, password: string, name: string) => {
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { name } },
    })
    return { error: error?.message ?? null }
  }

  const signOut = async () => {
    await supabase.auth.signOut()
    setProfile(null)
  }

  const resetPassword = async (email: string) => {
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${import.meta.env.VITE_APP_URL || window.location.origin}/login`,
    })
    return { error: error?.message ?? null }
  }

  const signInWithGoogle = async () => {
    await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: `${import.meta.env.VITE_APP_URL || window.location.origin}/tools` },
    })
  }

  const canSearch = () => {
    if (!profile) return true // not logged in = allow (will prompt login)
    if (profile.plan !== 'free') return true
    const today = new Date().toISOString().split('T')[0]
    if (profile.last_search_date !== today) return true
    return profile.daily_searches < FREE_DAILY_LIMIT
  }

  const remainingSearches = () => {
    if (!profile || profile.plan !== 'free') return Infinity
    const today = new Date().toISOString().split('T')[0]
    if (profile.last_search_date !== today) return FREE_DAILY_LIMIT
    return Math.max(0, FREE_DAILY_LIMIT - profile.daily_searches)
  }

  const incrementSearch = async () => {
    if (!profile) return
    const today = new Date().toISOString().split('T')[0]
    const newCount = profile.last_search_date === today ? profile.daily_searches + 1 : 1
    const updated = { ...profile, daily_searches: newCount, last_search_date: today }
    setProfile(updated)
    await supabase.from('profiles').update({ daily_searches: newCount, last_search_date: today }).eq('id', profile.id)
  }

  return (
    <AuthContext.Provider value={{ user, session, profile, loading, signIn, signUp, signOut, resetPassword, signInWithGoogle, canSearch, incrementSearch, remainingSearches }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext)
