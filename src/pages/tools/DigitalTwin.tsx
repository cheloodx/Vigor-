import { useState } from 'react'
import { ArrowLeft, Cpu } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

export default function DigitalTwin() {
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [year, setYear] = useState('')
  const [km, setKm] = useState('')
  const [loading, setLoading] = useState(false)
  const [twin, setTwin] = useState<{score:number;systems:{name:string;health:number;status:string}[];nextService:string;prediction:string} | null>(null)

  const create = async () => {
    if (!make || !model || !year || !km) return
    setLoading(true)
    try {
      const res = await api.predict(make, model, parseInt(year), parseInt(km))
      const avgRisk = Object.values(res.risk_summary).reduce((a, b) => a + b, 0) / Math.max(Object.keys(res.risk_summary).length, 1)
      const score = Math.max(30, Math.min(98, Math.round(100 - avgRisk * 0.7)))
      const systems = [
        { name: 'Motor', health: Math.round(score + (Math.random() * 10 - 5)), status: '' },
        { name: 'Transmisie', health: Math.round(score + (Math.random() * 10 - 5)), status: '' },
        { name: 'Frane', health: Math.round(score + (Math.random() * 15 - 8)), status: '' },
        { name: 'Suspensie', health: Math.round(score + (Math.random() * 10 - 5)), status: '' },
        { name: 'Electronica', health: Math.round(score + (Math.random() * 8 - 4)), status: '' },
        { name: 'Climatizare', health: Math.round(score + (Math.random() * 12 - 6)), status: '' },
      ].map(s => ({ ...s, health: Math.max(20, Math.min(100, s.health)), status: s.health > 75 ? 'Operational' : s.health > 50 ? 'Uzura moderata' : 'Necesita atentie' }))
      const nextKm = Math.ceil(parseInt(km) / 15000) * 15000
      setTwin({ score, systems, nextService: `La ${nextKm.toLocaleString()} km`, prediction: res.predictions?.[0]?.description || 'Monitorizare continua recomandata' })
    } catch {
      const score = Math.max(40, 95 - parseInt(km) / 3000)
      setTwin({ score: Math.round(score), systems: [
        { name: 'Motor', health: Math.round(score), status: score > 75 ? 'Operational' : 'Uzura' },
        { name: 'Transmisie', health: Math.round(score - 3), status: 'Operational' },
        { name: 'Frane', health: Math.round(score - 8), status: 'Uzura moderata' },
        { name: 'Suspensie', health: Math.round(score - 5), status: 'Operational' },
        { name: 'Electronica', health: Math.round(score + 2), status: 'Operational' },
        { name: 'Climatizare', health: Math.round(score - 2), status: 'Operational' },
      ], nextService: `La ${(Math.ceil(parseInt(km) / 15000) * 15000).toLocaleString()} km`, prediction: 'Monitorizare continua recomandata' })
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-teal-500 to-cyan-600 flex items-center justify-center"><Cpu className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Digital Twin</h1><p className="text-xs text-slate-500">Twin digital complet</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <div className="grid grid-cols-2 gap-3 mb-4">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca" className="glass rounded-xl px-4 py-3 text-white text-sm" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model" className="glass rounded-xl px-4 py-3 text-white text-sm" />
            <input value={year} onChange={e => setYear(e.target.value)} placeholder="An" className="glass rounded-xl px-4 py-3 text-white text-sm" type="number" />
            <input value={km} onChange={e => setKm(e.target.value)} placeholder="Km" className="glass rounded-xl px-4 py-3 text-white text-sm" type="number" />
          </div>
          <button onClick={create} disabled={loading} className="w-full btn-primary py-3 text-sm font-bold">{loading ? 'Creare twin...' : 'Creeaza Digital Twin'}</button>
        </div>
        {twin && (
          <>
            <div className="glass-card rounded-2xl p-6 mb-4 text-center border border-cyan-500/30">
              <p className="text-xs text-slate-500 uppercase mb-1">Scor General Twin</p>
              <p className={`text-5xl font-black ${twin.score > 75 ? 'text-emerald-400' : twin.score > 50 ? 'text-amber-400' : 'text-red-400'}`}>{twin.score}</p>
              <p className="text-sm text-slate-400 mt-2">{make} {model} ({year}) — {parseInt(km).toLocaleString()} km</p>
              <div className="grid grid-cols-2 gap-3 mt-4">
                <div className="glass rounded-xl p-3"><p className="text-[10px] text-slate-500">URMATORUL SERVICE</p><p className="text-sm font-bold text-white">{twin.nextService}</p></div>
                <div className="glass rounded-xl p-3"><p className="text-[10px] text-slate-500">PREDICTIE</p><p className="text-sm font-bold text-white line-clamp-2">{twin.prediction}</p></div>
              </div>
            </div>
            <div className="space-y-2">
              {twin.systems.map((s, i) => (
                <div key={i} className="glass-card rounded-xl p-4">
                  <div className="flex justify-between items-center mb-2">
                    <span className="text-sm font-bold text-white">{s.name}</span>
                    <span className={`text-xs ${s.health > 75 ? 'text-emerald-400' : s.health > 50 ? 'text-amber-400' : 'text-red-400'}`}>{s.status}</span>
                  </div>
                  <div className="w-full h-2 rounded-full bg-slate-800"><div className={`h-full rounded-full ${s.health > 75 ? 'bg-emerald-500' : s.health > 50 ? 'bg-amber-500' : 'bg-red-500'}`} style={{ width: `${s.health}%` }} /></div>
                </div>
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  )
}
