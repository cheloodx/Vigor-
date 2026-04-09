import { useState } from 'react'
import { motion } from 'framer-motion'
import { Camera, Search, Loader2, ArrowLeft, AlertCircle, CheckCircle, Wrench, DollarSign, Gauge } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, ScanResponse } from '@/lib/api'

export default function ScanTool() {
  const [desc, setDesc] = useState('')
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [symptom, setSymptom] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<ScanResponse | null>(null)
  const [error, setError] = useState('')

  const analyze = async () => {
    if (!desc.trim() && !symptom.trim()) { setError('Descrie problema vizuala sau simptomul.'); return }
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.scanImage(desc, make, model, symptom)
      setResult(res)
    } catch (e) {
      setError('Eroare la analiza. Incearca din nou.')
    }
    setLoading(false)
  }

  const sevColor = (s: string) => {
    const sl = s.toLowerCase()
    if (sl.includes('high') || sl.includes('critic') || sl.includes('sever')) return 'text-red-400'
    if (sl.includes('medium') || sl.includes('moder')) return 'text-amber-400'
    return 'text-emerald-400'
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-500 to-pink-600 flex items-center justify-center"><Camera className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Foto Diagnostic AI</h1>
              <p className="text-xs text-slate-500">Descrie problema si primesti diagnostic</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Descrie ce vezi</h2>
          <textarea value={desc} onChange={e => setDesc(e.target.value)} rows={3} placeholder="Ex: Pata de ulei sub motor, culoare maro inchis, pe partea stanga..." className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 resize-none mb-4" />
          <div className="grid grid-cols-3 gap-3 mb-4">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca" className="bg-white/5 border border-white/10 rounded-xl px-3 py-2.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model" className="bg-white/5 border border-white/10 rounded-xl px-3 py-2.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={symptom} onChange={e => setSymptom(e.target.value)} placeholder="Simptom" className="bg-white/5 border border-white/10 rounded-xl px-3 py-2.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
          </div>
          <button onClick={analyze} disabled={loading} className="btn-primary w-full px-6 py-3.5 flex items-center justify-center gap-2 disabled:opacity-50">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
            Analizeaza cu AI
          </button>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-8">
              <div className="flex items-center gap-4 mb-4">
                <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-cyan-500/20 to-blue-600/20 flex items-center justify-center">
                  <Gauge className="w-8 h-8 text-cyan-400" />
                </div>
                <div className="flex-1">
                  <h3 className="text-xl font-bold text-white">{result.diagnosis}</h3>
                  <p className="text-sm text-slate-400">Sistem: {result.affected_system}</p>
                </div>
                <div className="text-right">
                  <p className="text-3xl font-black text-cyan-400">{result.confidence}%</p>
                  <p className="text-xs text-slate-500">incredere</p>
                </div>
              </div>
              <div className="flex gap-3">
                <span className={`px-3 py-1 rounded-full text-xs font-bold ${sevColor(result.severity)} bg-white/5 border border-white/5`}>Severitate: {result.severity}</span>
              </div>
            </div>

            <div className="glass-card rounded-3xl p-8">
              <h4 className="text-sm font-bold text-white mb-4 flex items-center gap-2"><AlertCircle className="w-4 h-4 text-amber-400" />Cauze Posibile</h4>
              <div className="space-y-2">
                {(result.possible_causes || []).map((c, i) => (
                  <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                    <span className="w-6 h-6 rounded-full bg-amber-500/10 flex items-center justify-center text-xs font-bold text-amber-400 shrink-0">{i+1}</span>
                    <span className="text-sm text-slate-300">{c}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="glass-card rounded-3xl p-8">
              <h4 className="text-sm font-bold text-white mb-4 flex items-center gap-2"><Wrench className="w-4 h-4 text-emerald-400" />Recomandari</h4>
              <div className="space-y-2">
                {(result.recommendations || []).map((r, i) => (
                  <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                    <CheckCircle className="w-5 h-5 text-emerald-400 shrink-0 mt-0.5" />
                    <span className="text-sm text-slate-300">{r}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="glass-card rounded-3xl p-6 flex items-center gap-4">
              <DollarSign className="w-8 h-8 text-emerald-400" />
              <div>
                <span className="text-xs text-slate-500">Cost estimat reparatie</span>
                <p className="text-xl font-black text-white">{result.estimated_cost}</p>
              </div>
            </div>
          </motion.div>
        )}
      </div>
    </div>
  )
}
