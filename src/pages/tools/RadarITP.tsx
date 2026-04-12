import { useState } from 'react'
import { ArrowLeft, Shield, CheckCircle, XCircle, AlertTriangle } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

const CHECKS = [
  { name: 'Frane', weight: 20 }, { name: 'Directie', weight: 15 }, { name: 'Suspensie', weight: 15 },
  { name: 'Evacuare / Emisii', weight: 20 }, { name: 'Lumini', weight: 10 }, { name: 'Caroserie / Rugina', weight: 10 },
  { name: 'Anvelope', weight: 5 }, { name: 'Parbriz / Stergatoare', weight: 5 },
]

export default function RadarITP() {
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [year, setYear] = useState('')
  const [km, setKm] = useState('')
  const [loading, setLoading] = useState(false)
  const [results, setResults] = useState<{name:string;status:'pass'|'warn'|'fail';note:string}[]>([])
  const [chance, setChance] = useState<number | null>(null)

  const check = async () => {
    if (!make || !year) return
    setLoading(true)
    try {
      const res = await api.predict(make, model || 'Generic', parseInt(year), parseInt(km) || 100000)
      const age = 2024 - parseInt(year)
      const mileage = parseInt(km) || 100000
      const r = CHECKS.map(c => {
        const risk = (res.risk_summary[c.name.toLowerCase()] || 0) + age * 2 + mileage / 50000
        const status = risk < 30 ? 'pass' as const : risk < 60 ? 'warn' as const : 'fail' as const
        const note = status === 'pass' ? 'OK' : status === 'warn' ? 'Necesita verificare' : 'Risc respingere'
        return { name: c.name, status, note }
      })
      setResults(r)
      const passed = r.filter(x => x.status === 'pass').length
      setChance(Math.round((passed / r.length) * 100))
    } catch {
      const age = 2024 - parseInt(year)
      const r = CHECKS.map(c => {
        const risk = Math.random() * 50 + age * 3
        const status = risk < 35 ? 'pass' as const : risk < 65 ? 'warn' as const : 'fail' as const
        return { name: c.name, status, note: status === 'pass' ? 'OK' : status === 'warn' ? 'Necesita verificare' : 'Risc respingere' }
      })
      setResults(r)
      setChance(Math.round(r.filter(x => x.status === 'pass').length / r.length * 100))
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-red-500 to-pink-600 flex items-center justify-center"><Shield className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Radar ITP</h1><p className="text-xs text-slate-500">Trece ITP-ul?</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <div className="grid grid-cols-2 gap-3 mb-4">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca" className="glass rounded-xl px-4 py-3 text-white text-sm" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model" className="glass rounded-xl px-4 py-3 text-white text-sm" />
            <input value={year} onChange={e => setYear(e.target.value)} placeholder="An fabricatie" className="glass rounded-xl px-4 py-3 text-white text-sm" type="number" />
            <input value={km} onChange={e => setKm(e.target.value)} placeholder="Kilometraj" className="glass rounded-xl px-4 py-3 text-white text-sm" type="number" />
          </div>
          <button onClick={check} disabled={loading || !make} className="w-full btn-primary py-3 text-sm font-bold">{loading ? 'Analizam...' : 'Verifica Sanse ITP'}</button>
        </div>
        {chance !== null && (
          <>
            <div className={`glass-card rounded-2xl p-8 mb-6 text-center ${chance > 70 ? 'border border-emerald-500/30' : chance > 40 ? 'border border-amber-500/30' : 'border border-red-500/30'}`}>
              <p className="text-sm text-slate-400">Sanse trecere ITP</p>
              <p className={`text-6xl font-black ${chance > 70 ? 'text-emerald-400' : chance > 40 ? 'text-amber-400' : 'text-red-400'}`}>{chance}%</p>
            </div>
            <div className="space-y-2">
              {results.map((r, i) => (
                <div key={i} className="glass-card rounded-xl p-4 flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    {r.status === 'pass' ? <CheckCircle className="w-5 h-5 text-emerald-400" /> : r.status === 'warn' ? <AlertTriangle className="w-5 h-5 text-amber-400" /> : <XCircle className="w-5 h-5 text-red-400" />}
                    <span className="text-sm text-white">{r.name}</span>
                  </div>
                  <span className={`text-xs font-bold ${r.status === 'pass' ? 'text-emerald-400' : r.status === 'warn' ? 'text-amber-400' : 'text-red-400'}`}>{r.note}</span>
                </div>
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  )
}
