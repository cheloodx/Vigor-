import { useState } from 'react'
import { motion } from 'framer-motion'
import { Gauge, Loader2, ArrowLeft, AlertCircle, Shield } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, PredictionResponse } from '@/lib/api'

const sfToEmoji: Record<string, string> = {
  'circle.circle': '🔧', 'exclamationmark.triangle': '⚠️', 'car.fill': '🚗',
  'bolt.fill': '⚡', 'drop.fill': '💧', 'gear': '⚙️', 'wrench.fill': '🔩',
  'thermometer': '🌡️', 'battery.100': '🔋', 'flame.fill': '🔥',
}
const mapIcon = (icon: string) => sfToEmoji[icon] || '🔧'

export default function PredictorTool() {
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [year, setYear] = useState('')
  const [mileage, setMileage] = useState('')
  const [fuel, setFuel] = useState('Diesel')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<PredictionResponse | null>(null)
  const [error, setError] = useState('')

  const predict = async () => {
    if (!make || !model || !year || !mileage) { setError('Completeaza toate campurile.'); return }
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.predict(make, model, parseInt(year), parseInt(mileage), fuel)
      setResult(res)
    } catch (e) {
      setError('Eroare la predictie. Verifica datele.')
    }
    setLoading(false)
  }

  const riskColor = (r: string) => {
    if (r === 'high') return 'text-red-400 bg-red-500/10 border-red-500/20'
    if (r === 'medium') return 'text-amber-400 bg-amber-500/10 border-amber-500/20'
    return 'text-emerald-400 bg-emerald-500/10 border-emerald-500/20'
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-red-500 to-rose-600 flex items-center justify-center"><Gauge className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Predictor AI</h1>
              <p className="text-xs text-slate-500">Predictii defectiuni viitoare</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Detalii vehicul</h2>
          <div className="grid grid-cols-2 gap-3 mb-3">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca (BMW, VW...)" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model (320d, Golf...)" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
          </div>
          <div className="grid grid-cols-3 gap-3 mb-4">
            <input value={year} onChange={e => setYear(e.target.value)} type="number" placeholder="An (2019)" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={mileage} onChange={e => setMileage(e.target.value)} type="number" placeholder="Km (150000)" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <select value={fuel} onChange={e => setFuel(e.target.value)} className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white focus:border-cyan-500/50 focus:outline-none">
              <option value="Diesel" className="bg-slate-900">Diesel</option>
              <option value="Benzina" className="bg-slate-900">Benzina</option>
              <option value="Hybrid" className="bg-slate-900">Hybrid</option>
              <option value="Electric" className="bg-slate-900">Electric</option>
            </select>
          </div>
          <button onClick={predict} disabled={loading} className="btn-primary w-full px-6 py-3.5 flex items-center justify-center gap-2 disabled:opacity-50">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Gauge className="w-5 h-5" />}
            Genereaza Predictii
          </button>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-6">
              <h3 className="text-lg font-bold text-white mb-1">{result.vehicle}</h3>
              <p className="text-sm text-slate-500">{result.mileage.toLocaleString()} km</p>
              {result.risk_summary && (
                <div className="flex gap-4 mt-4">
                  {Object.entries(result.risk_summary).map(([k, v]) => (
                    <div key={k} className="flex items-center gap-2">
                      <span className={`w-3 h-3 rounded-full ${k === 'high' ? 'bg-red-500' : k === 'medium' ? 'bg-amber-500' : 'bg-emerald-500'}`} />
                      <span className="text-xs text-slate-400 capitalize">{k}: <strong className="text-white">{v}</strong></span>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {(result.predictions || []).map((p, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.08 }} className="glass-card rounded-3xl p-6">
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-3">
                    <span className="text-2xl">{mapIcon(p.icon)}</span>
                    <div>
                      <h4 className="font-bold text-white">{p.component_name}</h4>
                      <p className="text-xs text-slate-500">{p.timeframe}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <span className={`px-3 py-1 rounded-full text-xs font-bold border ${riskColor(p.risk_level)}`}>{p.probability}%</span>
                  </div>
                </div>
                <p className="text-sm text-slate-400 mb-3">{p.description}</p>
                <div className="flex items-center justify-between glass rounded-xl p-3">
                  <div className="flex items-center gap-2"><Shield className="w-4 h-4 text-cyan-400" /><span className="text-xs text-slate-400">{p.prevention_tip}</span></div>
                  <span className="text-sm font-bold text-emerald-400">~{p.estimated_cost} EUR</span>
                </div>
              </motion.div>
            ))}
          </motion.div>
        )}
      </div>
    </div>
  )
}
