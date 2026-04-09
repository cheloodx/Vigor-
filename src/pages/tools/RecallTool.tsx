import { useState } from 'react'
import { motion } from 'framer-motion'
import { Shield, Search, Loader2, ArrowLeft, AlertCircle, AlertTriangle, CheckCircle } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, RecallResponse } from '@/lib/api'

export default function RecallTool() {
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [year, setYear] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<RecallResponse | null>(null)
  const [error, setError] = useState('')

  const check = async () => {
    if (!make) { setError('Introdu cel putin marca.'); return }
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.checkRecalls(make, model, year ? parseInt(year) : undefined)
      setResult(res)
    } catch (e) {
      setError('Eroare la verificare.')
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-red-500 to-rose-600 flex items-center justify-center"><Shield className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Recall Check</h1>
              <p className="text-xs text-slate-500">Verifica campaniile de rechemare</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Detalii vehicul</h2>
          <div className="grid grid-cols-3 gap-3 mb-4">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca *" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={year} onChange={e => setYear(e.target.value)} type="number" placeholder="An" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
          </div>
          <button onClick={check} disabled={loading} className="btn-primary w-full px-6 py-3.5 flex items-center justify-center gap-2 disabled:opacity-50">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
            Verifica Recall-uri
          </button>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-8 text-center">
              <h3 className="text-lg font-bold text-white mb-4">{result.vehicle}</h3>
              <div className="grid grid-cols-2 gap-4">
                <div className="glass rounded-2xl p-4">
                  <p className="text-3xl font-black text-white">{result.total_recalls}</p>
                  <p className="text-xs text-slate-500">Total rechemari</p>
                </div>
                <div className="glass rounded-2xl p-4">
                  <p className={`text-3xl font-black ${result.active_recalls > 0 ? 'text-red-400' : 'text-emerald-400'}`}>{result.active_recalls}</p>
                  <p className="text-xs text-slate-500">Active acum</p>
                </div>
              </div>
            </div>

            {(result.recalls || []).map((r, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.08 }} className="glass-card rounded-3xl p-6">
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-2">
                    {r.status === 'active' ? <AlertTriangle className="w-5 h-5 text-red-400" /> : <CheckCircle className="w-5 h-5 text-emerald-400" />}
                    <h4 className="font-bold text-white">{r.title}</h4>
                  </div>
                  <span className={`px-2 py-0.5 rounded-full text-xs font-bold ${r.status === 'active' ? 'text-red-400 bg-red-500/10' : 'text-emerald-400 bg-emerald-500/10'}`}>{r.status}</span>
                </div>
                <p className="text-sm text-slate-400 mb-3">{r.description}</p>
                <div className="flex gap-4 text-xs text-slate-500">
                  <span>Data: {r.date}</span>
                  <span>Severitate: {r.severity}</span>
                  <span>Piese: {r.affected_parts}</span>
                </div>
              </motion.div>
            ))}
          </motion.div>
        )}
      </div>
    </div>
  )
}
