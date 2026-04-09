import { useState, useEffect } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { Menu, X, Zap } from 'lucide-react'

const links = [
  { to: '/', label: 'Home' },
  { to: '/functionalitati', label: 'Functionalitati' },
  { to: '/cum-functioneaza', label: 'Cum Functioneaza' },
  { to: '/pentru-service', label: 'Pentru Service' },
  { to: '/pricing', label: 'Pricing' },
  { to: '/tools', label: 'Unelte AI' },
  { to: '/despre', label: 'Despre' },
  { to: '/contact', label: 'Contact' },
]

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false)
  const [open, setOpen] = useState(false)
  const loc = useLocation()

  useEffect(() => {
    const h = () => setScrolled(window.scrollY > 20)
    window.addEventListener('scroll', h)
    return () => window.removeEventListener('scroll', h)
  }, [])

  useEffect(() => { setOpen(false) }, [loc.pathname])

  return (
    <motion.nav
      initial={{ y: -100 }}
      animate={{ y: 0 }}
      transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-500 ${scrolled ? 'glass border-b border-white/5 shadow-2xl shadow-black/20' : ''}`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 lg:h-20">
          <Link to="/" className="flex items-center gap-2.5 group">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center shadow-lg shadow-cyan-500/20 group-hover:shadow-cyan-500/40 transition-shadow">
              <Zap className="w-5 h-5 text-white" />
            </div>
            <span className="text-xl font-black tracking-tight">
              <span className="text-white">Auto</span>
              <span className="text-cyan-400">Diag</span>
              <span className="text-slate-500 font-medium text-sm ml-1">Pro</span>
            </span>
          </Link>

          <div className="hidden lg:flex items-center gap-1">
            {links.map(l => (
              <Link key={l.to} to={l.to}
                className={`px-4 py-2 rounded-xl text-sm font-medium transition-all duration-300 ${loc.pathname === l.to ? 'text-cyan-400 bg-cyan-500/10' : 'text-slate-400 hover:text-white hover:bg-white/5'}`}>
                {l.label}
              </Link>
            ))}
          </div>

          <div className="hidden lg:flex items-center gap-3">
            <Link to="/faq" className="text-sm text-slate-400 hover:text-white transition-colors px-3 py-2">FAQ</Link>
            <Link to="/tools" className="btn-primary px-5 py-2.5 text-sm flex items-center gap-1.5"><Zap className="w-3.5 h-3.5" />Unelte Live</Link>
          </div>

          <button onClick={() => setOpen(!open)} className="lg:hidden p-2 text-slate-400 hover:text-white transition-colors">
            {open ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </div>

      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="lg:hidden glass border-t border-white/5 overflow-hidden"
          >
            <div className="px-4 py-4 space-y-1">
              {links.map(l => (
                <Link key={l.to} to={l.to}
                  className={`block px-4 py-3 rounded-xl text-sm font-medium transition-all ${loc.pathname === l.to ? 'text-cyan-400 bg-cyan-500/10' : 'text-slate-400 hover:text-white hover:bg-white/5'}`}>
                  {l.label}
                </Link>
              ))}
              <Link to="/faq" className="block px-4 py-3 rounded-xl text-sm text-slate-400 hover:text-white">FAQ</Link>
              <div className="pt-3">
                <Link to="/pricing" className="btn-primary block text-center px-5 py-3 text-sm">Incepe Gratuit</Link>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.nav>
  )
}
