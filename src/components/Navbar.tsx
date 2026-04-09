import { useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { Menu, X, ChevronDown, Car, History, Settings, LogOut, Wrench } from 'lucide-react'
import { useAuth } from '@/lib/auth'

const links = [
  { to: '/', label: 'Home' },
  { to: '/features', label: 'Functionalitati' },
  { to: '/how-it-works', label: 'Cum Functioneaza' },
  { to: '/for-service', label: 'Pentru Service' },
  { to: '/pricing', label: 'Pricing' },
  { to: '/about', label: 'Despre' },
  { to: '/contact', label: 'Contact' },
  { to: '/faq', label: 'FAQ' },
]

const planBadge = (plan: string) => {
  if (plan === 'pro') return { label: 'PRO', color: 'bg-emerald-500 text-white' }
  if (plan === 'business') return { label: 'BUSINESS', color: 'bg-amber-500 text-black' }
  return { label: 'FREE', color: 'bg-slate-600 text-slate-300' }
}

export default function Navbar() {
  const [open, setOpen] = useState(false)
  const [userMenu, setUserMenu] = useState(false)
  const loc = useLocation()
  const { user, profile, signOut, remainingSearches } = useAuth()

  const badge = profile ? planBadge(profile.plan) : null
  const remaining = remainingSearches()

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 glass border-b border-white/5">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <Link to="/" className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-cyan-400 to-blue-600 flex items-center justify-center">
              <Wrench className="w-4 h-4 text-white" />
            </div>
            <span className="font-bold text-white">AutoDiag <span className="text-cyan-400">Pro</span></span>
          </Link>

          <div className="hidden lg:flex items-center gap-1">
            {links.map(l => (
              <Link key={l.to} to={l.to} className={`px-3 py-2 rounded-lg text-sm transition-colors ${loc.pathname === l.to ? 'text-cyan-400 bg-cyan-500/10' : 'text-slate-400 hover:text-white hover:bg-white/5'}`}>
                {l.label}
              </Link>
            ))}
          </div>

          <div className="flex items-center gap-3">
            {user && profile ? (
              <div className="relative">
                <button onClick={() => setUserMenu(!userMenu)} className="flex items-center gap-2 glass rounded-full pl-2 pr-3 py-1.5 hover:bg-white/10 transition-colors">
                  <div className="w-7 h-7 rounded-full bg-gradient-to-br from-cyan-400 to-blue-600 flex items-center justify-center text-xs font-bold text-white">
                    {profile.name?.[0]?.toUpperCase() || 'U'}
                  </div>
                  <span className="text-sm text-white hidden sm:inline">{profile.name?.split(' ')[0]}</span>
                  {badge && <span className={`text-[9px] font-bold px-1.5 py-0.5 rounded-full ${badge.color}`}>{badge.label}</span>}
                  {profile.plan === 'free' && remaining < Infinity && (
                    <span className="text-[10px] text-slate-500">{remaining}/5</span>
                  )}
                  <ChevronDown className="w-3.5 h-3.5 text-slate-400" />
                </button>

                {userMenu && (
                  <div className="absolute right-0 top-full mt-2 w-56 glass-bright rounded-2xl p-2 shadow-2xl border border-white/10" onMouseLeave={() => setUserMenu(false)}>
                    <div className="px-3 py-2 border-b border-white/10 mb-1">
                      <p className="text-sm font-bold text-white">{profile.name}</p>
                      <p className="text-xs text-slate-500">{profile.email}</p>
                    </div>
                    <Link to="/my-vehicles" onClick={() => setUserMenu(false)} className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm text-slate-300 hover:bg-white/10 transition-colors">
                      <Car className="w-4 h-4" />Vehiculele Mele
                    </Link>
                    <Link to="/tools" onClick={() => setUserMenu(false)} className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm text-slate-300 hover:bg-white/10 transition-colors">
                      <History className="w-4 h-4" />Istoric Diagnostice
                    </Link>
                    <Link to="/pricing" onClick={() => setUserMenu(false)} className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm text-slate-300 hover:bg-white/10 transition-colors">
                      <Settings className="w-4 h-4" />Setari & Plan
                    </Link>
                    <button onClick={() => { signOut(); setUserMenu(false) }} className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm text-red-400 hover:bg-red-500/10 transition-colors w-full">
                      <LogOut className="w-4 h-4" />Deconecteaza-te
                    </button>
                  </div>
                )}
              </div>
            ) : (
              <div className="flex items-center gap-2">
                <Link to="/login" className="px-4 py-2 rounded-xl text-sm text-slate-300 hover:text-white hover:bg-white/5 transition-colors hidden sm:block">Login</Link>
                <Link to="/tools" className="btn-primary px-4 py-2 text-sm flex items-center gap-2">
                  <Wrench className="w-4 h-4" />
                  <span>Unelte Live</span>
                </Link>
              </div>
            )}

            <button onClick={() => setOpen(!open)} className="lg:hidden p-2 glass rounded-xl hover:bg-white/10 transition-colors">
              {open ? <X className="w-5 h-5 text-white" /> : <Menu className="w-5 h-5 text-white" />}
            </button>
          </div>
        </div>
      </div>

      {open && (
        <div className="lg:hidden glass border-t border-white/5 px-4 py-4">
          {links.map(l => (
            <Link key={l.to} to={l.to} onClick={() => setOpen(false)} className={`block px-4 py-3 rounded-xl text-sm ${loc.pathname === l.to ? 'text-cyan-400 bg-cyan-500/10' : 'text-slate-400 hover:text-white hover:bg-white/5'}`}>
              {l.label}
            </Link>
          ))}
          {!user && (
            <>
              <Link to="/login" onClick={() => setOpen(false)} className="block px-4 py-3 rounded-xl text-sm text-slate-400 hover:text-white hover:bg-white/5">Login</Link>
              <Link to="/register" onClick={() => setOpen(false)} className="block px-4 py-3 rounded-xl text-sm text-cyan-400 hover:bg-cyan-500/10">Creeaza cont</Link>
            </>
          )}
        </div>
      )}
    </nav>
  )
}
