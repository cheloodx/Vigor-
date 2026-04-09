import { useState } from 'react'
import { motion } from 'framer-motion'
import { Mail, Loader2, ArrowLeft, AlertCircle, CheckCircle } from 'lucide-react'
import { Link } from 'react-router-dom'
import { useAuth } from '@/lib/auth'

export default function ForgotPassword() {
  const [email, setEmail] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [sent, setSent] = useState(false)
  const { resetPassword } = useAuth()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!email) { setError('Introduceti adresa de email.'); return }
    setLoading(true); setError('')
    const { error: err } = await resetPassword(email)
    if (err) { setError(err); setLoading(false) }
    else { setSent(true); setLoading(false) }
  }

  return (
    <div className="min-h-screen pt-20 flex items-center justify-center">
      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="w-full max-w-md px-4">
        <div className="glass-bright rounded-3xl p-8 glow-cyan">
          <div className="flex items-center gap-3 mb-8">
            <Link to="/login" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
            <div>
              <h1 className="text-2xl font-bold text-white">Resetare parola</h1>
              <p className="text-xs text-slate-500">Trimitem un link de resetare pe email</p>
            </div>
          </div>

          {sent ? (
            <div className="text-center py-8">
              <CheckCircle className="w-16 h-16 text-emerald-400 mx-auto mb-4" />
              <h3 className="text-lg font-bold text-white mb-2">Email trimis!</h3>
              <p className="text-sm text-slate-400 mb-6">Verifica inbox-ul pentru linkul de resetare.</p>
              <Link to="/login" className="btn-primary px-6 py-3 inline-flex">Inapoi la login</Link>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="relative">
                <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
                <input type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="Adresa de email" className="w-full bg-white/5 border border-white/10 rounded-2xl pl-12 pr-4 py-3.5 text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
              </div>
              {error && <p className="text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
              <button type="submit" disabled={loading} className="btn-primary w-full px-6 py-3.5 flex items-center justify-center gap-2 disabled:opacity-50">
                {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : 'Trimite link de resetare'}
              </button>
            </form>
          )}
        </div>
      </motion.div>
    </div>
  )
}
