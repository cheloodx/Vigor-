import { useState } from 'react'
import { motion } from 'framer-motion'
import { AlertTriangle, Search, Loader2, ArrowLeft, AlertCircle, CheckCircle, Wrench, DollarSign } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, DTCResponse } from '@/lib/api'

export default function DTCTool() {
  const [code, setCode] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<DTCResponse | null>(null)
  const [error, setError] = useState('')

  const decode = async () => {
    if (!code.trim()) return
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.decodeDTC(code.trim().toUpperCase())
      setResult(res)
    } catch (e) {
      setError('Cod invalid sau eroare server. Verifica formatul (ex: P0300).')
    }
    setLoading(false)
  }

  const severityColor = (s: string) => {
    const sl = s.toLowerCase()
    if (sl.includes('high') || sl.includes('critic') || sl.includes('major')) return 'text-red-400 bg-red-500/10 border-red-500/20'
    if (sl.includes('medium') || sl.includes('moderat')) return 'text-amber-400 bg-amber-500/10 border-amber-500/20'
    return 'text-emerald-400 bg-emerald-500/10 border-emerald-500/20'
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-500 to-orange-600 flex items-center justify-center"><AlertTriangle className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Decodor DTC</h1>
              <p className="text-xs text-slate-500">Decodifica coduri eroare OBD2</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Introdu codul de eroare</h2>
          <div className="flex gap-3">
            <input value={code} onChange={e => setCode(e.target.value)} onKeyDown={e => e.key === 'Enter' && decode()} placeholder="Ex: P0300, P0171, B1234..." className="flex-1 bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-lg font-mono text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 uppercase" />
            <button onClick={decode} disabled={loading || !code.trim()} className="btn-primary px-6 py-3.5 flex items-center gap-2 disabled:opacity-50">
              {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
              <span className="hidden sm:inline">Decodifica</span>
            </button>
          </div>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-8">
              <div className="flex items-start justify-between mb-4">
                <div>
                  <span className="text-sm text-cyan-400 font-mono font-bold">{result.code}</span>
                  <h3 className="text-xl font-bold text-white mt-1">{result.short_description}</h3>
                  <p className="text-sm text-slate-400 mt-1">{result.description}</p>
                </div>
                <span className={`px-3 py-1 rounded-full text-xs font-bold border ${severityColor(result.severity)}`}>{result.severity}</span>
              </div>
              <div className="grid grid-cols-2 gap-3 mb-4">
                <div className="glass rounded-2xl px-4 py-3">
                  <span className="text-xs text-slate-500 font-medium">Sistem</span>
                  <p className="text-sm text-white font-semibold">{result.system}</p>
                </div>
                <div className="glass rounded-2xl px-4 py-3">
                  <span className="text-xs text-slate-500 font-medium">Categorie</span>
                  <p className="text-sm text-white font-semibold">{result.category}</p>
                </div>
              </div>
              <div className={`glass rounded-2xl px-4 py-3 flex items-center gap-2 ${result.can_drive ? 'border border-emerald-500/20' : 'border border-red-500/20'}`}>
                <span className={`text-sm font-semibold ${result.can_drive ? 'text-emerald-400' : 'text-red-400'}`}>{result.can_drive ? 'Poti conduce cu precautie' : 'Nu conduce! Opreste masina.'}</span>
              </div>
            </div>

            <div className="glass-card rounded-3xl p-8">
              <h4 className="text-sm font-bold text-white mb-4 flex items-center gap-2"><AlertCircle className="w-4 h-4 text-amber-400" />Cauze Posibile</h4>
              <div className="space-y-2">
                {(result.causes || []).map((c, i) => (
                  <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                    <span className="w-6 h-6 rounded-full bg-amber-500/10 flex items-center justify-center text-xs font-bold text-amber-400 shrink-0">{i+1}</span>
                    <span className="text-sm text-slate-300">{c}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="glass-card rounded-3xl p-8">
              <h4 className="text-sm font-bold text-white mb-4 flex items-center gap-2"><Wrench className="w-4 h-4 text-emerald-400" />Solutie Recomandata</h4>
              <div className="glass rounded-xl p-4">
                <CheckCircle className="w-5 h-5 text-emerald-400 mb-2" />
                <p className="text-sm text-slate-300">{result.fix}</p>
              </div>
            </div>

            {(result.symptoms || []).length > 0 && (
              <div className="glass-card rounded-3xl p-8">
                <h4 className="text-sm font-bold text-white mb-4">Simptome</h4>
                <div className="space-y-2">
                  {(result.symptoms || []).map((s, i) => (
                    <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                      <span className="w-6 h-6 rounded-full bg-purple-500/10 flex items-center justify-center text-xs font-bold text-purple-400 shrink-0">{i+1}</span>
                      <span className="text-sm text-slate-300">{s}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}

            <div className="glass-card rounded-3xl p-6 flex items-center gap-4">
              <DollarSign className="w-8 h-8 text-emerald-400" />
              <div>
                <span className="text-xs text-slate-500">Cost estimat reparatie</span>
                <p className="text-xl font-black text-white">{result.cost_range}</p>
              </div>
            </div>
          </motion.div>
        )}
      </div>
    </div>
  )
}
