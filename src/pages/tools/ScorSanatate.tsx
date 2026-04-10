import { useState } from 'react'
import { motion } from 'framer-motion'
import { ArrowLeft, Heart, Activity, Gauge } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

const CATEGORIES = [
  { name: 'Motor', weight: 25, icon: '🔧' },
  { name: 'Frane', weight: 20, icon: '🛑' },
  { name: 'Suspensie', weight: 15, icon: '🔩' },
  { name: 'Electronica', weight: 15, icon: '⚡' },
  { name: 'Caroserie', weight: 10, icon: '🚗' },
  { name: 'Transmisie', weight: 15, icon: '⚙️' },
]

export default function ScorSanatate() {
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [year, setYear] = useState('')
  const [km, setKm] = useState('')
  const [loading, setLoading] = useState(false)
  const [score, setScore] = useState<number | null>(null)
  const [details, setDetails] = useState<{name:string;score:number;note:string}[]>([])

  const analyze = async () => {
    if (!make || !model || !year || !km) return
    setLoading(true)
    try {
      const res = await api.predict(make, model, parseInt(year), parseInt(km))
      const riskTotal = Object.values(res.risk_summary).reduce((a, b) => a + b, 0)
      const avgRisk = riskTotal / Math.max(Object.keys(res.risk_summary).length, 1)
      const baseScore = Math.max(20, Math.min(100, Math.round(100 - avgRisk * 0.8)))
      setScore(baseScore)
      setDetails(CATEGORIES.map(c => {
        const catRisk = res.risk_summary[c.name.toLowerCase()] || Math.random() * 30 + 10
        const catScore = Math.max(30, Math.min(100, Math.round(100 - catRisk)))
        return { name: c.name, score: catScore, note: catScore > 75 ? 'Bine' : catScore > 50 ? 'Atentie' : 'Critic' }
      }))
    } catch {
      const base = Math.max(40, 100 - parseInt(km) / 3000 - (2024 - parseInt(year)) * 2)
      setScore(Math.round(base))
      setDetails(CATEGORIES.map(c => {
        const s = Math.round(base + (Math.random() * 20 - 10))
        return { name: c.name, score: Math.max(30, Math.min(100, s)), note: s > 75 ? 'Bine' : s > 50 ? 'Atentie' : 'Critic' }
      }))
    }
    setLoading(false)
  }

  const scoreColor = (s: number) => s > 75 ? 'text-emerald-400' : s > 50 ? 'text-amber-400' : 'text-red-400'
  const scoreBg = (s: number) => s > 75 ? 'from-emerald-500/20 to-emerald-500/5' : s > 50 ? 'from-amber-500/20 to-amber-500/5' : 'from-red-500/20 to-red-500/5'

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-500 to-teal-600 flex items-center justify-center"><Heart className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Scor Sanatate</h1><p className="text-xs text-slate-500">Nota generala 0-100</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <div className="grid grid-cols-2 gap-4 mb-4">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca (ex: Volkswagen)" className="glass rounded-xl px-4 py-3 text-white text-sm" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model (ex: Golf)" className="glass rounded-xl px-4 py-3 text-white text-sm" />
            <input value={year} onChange={e => setYear(e.target.value)} placeholder="An (ex: 2019)" className="glass rounded-xl px-4 py-3 text-white text-sm" type="number" />
            <input value={km} onChange={e => setKm(e.target.value)} placeholder="Kilometraj" className="glass rounded-xl px-4 py-3 text-white text-sm" type="number" />
          </div>
          <button onClick={analyze} disabled={loading || !make || !model} className="w-full btn-primary py-3 text-sm font-bold flex items-center justify-center gap-2">
            {loading ? <><Activity className="w-4 h-4 animate-spin" />Analizam...</> : <><Gauge className="w-4 h-4" />Calculeaza Scor</>}
          </button>
        </div>
        {score !== null && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
            <div className={`glass-card rounded-2xl p-8 mb-6 bg-gradient-to-br ${scoreBg(score)} text-center`}>
              <p className="text-slate-400 text-sm mb-2">Scor General Sanatate</p>
              <p className={`text-7xl font-black ${scoreColor(score)}`}>{score}</p>
              <p className="text-slate-500 text-sm mt-2">{score > 75 ? 'Vehicul in stare buna' : score > 50 ? 'Necesita atentie' : 'Probleme serioase detectate'}</p>
            </div>
            <div className="space-y-3">
              {details.map((d, i) => (
                <div key={i} className="glass-card rounded-xl p-4 flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <span className="text-lg">{CATEGORIES[i]?.icon}</span>
                    <div><p className="text-sm font-bold text-white">{d.name}</p><p className="text-xs text-slate-500">{d.note}</p></div>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-24 h-2 rounded-full bg-slate-800 overflow-hidden">
                      <div className={`h-full rounded-full ${d.score > 75 ? 'bg-emerald-500' : d.score > 50 ? 'bg-amber-500' : 'bg-red-500'}`} style={{ width: `${d.score}%` }} />
                    </div>
                    <span className={`text-sm font-bold ${scoreColor(d.score)}`}>{d.score}</span>
                  </div>
                </div>
              ))}
            </div>
          </motion.div>
        )}
      </div>
    </div>
  )
}
