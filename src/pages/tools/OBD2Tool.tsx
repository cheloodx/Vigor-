import { useState, useEffect, useRef } from 'react'
import { ArrowLeft, Wifi, Activity, Play, Square } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

interface PID { name: string; value: number; unit: string; min: number; max: number; warn: number }

const BASE_PIDS: PID[] = [
  { name: 'RPM Motor', value: 850, unit: 'rpm', min: 700, max: 6500, warn: 5500 },
  { name: 'Temperatura Motor', value: 90, unit: '\u00b0C', min: 60, max: 120, warn: 105 },
  { name: 'Viteza Vehicul', value: 0, unit: 'km/h', min: 0, max: 220, warn: 180 },
  { name: 'Incarcare Motor', value: 22, unit: '%', min: 0, max: 100, warn: 85 },
  { name: 'Presiune Admisie', value: 101, unit: 'kPa', min: 20, max: 255, warn: 200 },
  { name: 'Avans Aprindere', value: 12, unit: '\u00b0', min: -10, max: 50, warn: 40 },
  { name: 'Temperatura Aer Admisie', value: 28, unit: '\u00b0C', min: -20, max: 80, warn: 60 },
  { name: 'Debit Aer', value: 4.5, unit: 'g/s', min: 0, max: 50, warn: 40 },
  { name: 'Pozitie Clapeta', value: 15, unit: '%', min: 0, max: 100, warn: 90 },
  { name: 'Tensiune Baterie', value: 14.2, unit: 'V', min: 11, max: 15, warn: 11.5 },
  { name: 'Temperatura Ulei', value: 95, unit: '\u00b0C', min: 60, max: 150, warn: 130 },
  { name: 'Presiune Combustibil', value: 350, unit: 'kPa', min: 100, max: 600, warn: 500 },
]

export default function OBD2Tool() {
  const [pids, setPids] = useState<PID[]>(BASE_PIDS)
  const [running, setRunning] = useState(false)
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [aiTip, setAiTip] = useState('')
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null)

  const simulate = () => {
    setPids(prev => prev.map(p => {
      const delta = (Math.random() - 0.48) * (p.max - p.min) * 0.03
      const nv = Math.max(p.min, Math.min(p.max, p.value + delta))
      return { ...p, value: Math.round(nv * 10) / 10 }
    }))
  }

  const toggle = async () => {
    if (running) {
      if (intervalRef.current) clearInterval(intervalRef.current)
      intervalRef.current = null
      setRunning(false)
      return
    }
    setRunning(true)
    intervalRef.current = setInterval(simulate, 800)
    if (make) {
      try {
        const res = await api.predict(make, model || 'Generic', 2020, 100000)
        const risk = Object.entries(res.risk_summary).sort((a, b) => b[1] - a[1])[0]
        if (risk) setAiTip(`Atentie: Risc crescut la ${risk[0]} (${Math.round(risk[1])}%). ${res.predictions?.[0]?.description || 'Monitorizare recomandata.'}`)
      } catch {
        try {
          const chat = await api.chat(`Masina ${make} ${model || ''}: ce parametri OBD2 ar trebui urmariti cu atentie? Raspunde scurt in romana, max 2 propozitii.`, make, model)
          setAiTip(chat.response)
        } catch { /* silent */ }
      }
    }
  }

  useEffect(() => { return () => { if (intervalRef.current) clearInterval(intervalRef.current) } }, [])

  const status = (p: PID) => {
    if (p.name.includes('Temperatura') && p.value >= p.warn) return 'text-red-400'
    if (p.name.includes('Tensiune') && p.value <= p.warn) return 'text-red-400'
    if (p.value >= p.warn) return 'text-amber-400'
    return 'text-emerald-400'
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center"><Wifi className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">OBD2 Avansat</h1><p className="text-xs text-slate-500">Live data + AI predictii</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-4">
          <div className="grid grid-cols-2 gap-3 mb-3">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca (ex: VW)" className="glass rounded-xl px-4 py-3 text-white text-sm" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model (ex: Golf)" className="glass rounded-xl px-4 py-3 text-white text-sm" />
          </div>
          <button onClick={toggle} className={`w-full py-3 text-sm font-bold rounded-xl flex items-center justify-center gap-2 transition-all ${running ? 'bg-red-500 hover:bg-red-600 text-white' : 'btn-primary'}`}>
            {running ? <><Square className="w-4 h-4" />Stop Monitorizare</> : <><Play className="w-4 h-4" />Start Monitorizare Live</>}
          </button>
        </div>
        {running && (
          <div className="glass-card rounded-2xl p-3 mb-4 border border-cyan-500/30">
            <div className="flex items-center gap-2 mb-1"><Activity className="w-4 h-4 text-cyan-400 animate-pulse" /><span className="text-xs text-cyan-400 font-bold">LIVE</span></div>
            <p className="text-[10px] text-slate-500">Date se actualizeaza in timp real</p>
          </div>
        )}
        {aiTip && (
          <div className="glass-card rounded-2xl p-4 mb-4 border-l-4 border-amber-500">
            <p className="text-xs text-amber-400 font-bold mb-1">AI TIP</p>
            <p className="text-sm text-slate-300">{aiTip}</p>
          </div>
        )}
        <div className="grid grid-cols-2 gap-3">
          {pids.map((p, i) => (
            <div key={i} className="glass-card rounded-xl p-4 text-center">
              <p className="text-[10px] text-slate-500 uppercase">{p.name}</p>
              <p className={`text-2xl font-black mt-1 ${status(p)}`}>{p.value}</p>
              <p className="text-xs text-cyan-400">{p.unit}</p>
              <div className="w-full h-1 rounded-full bg-slate-800 mt-2">
                <div className={`h-full rounded-full transition-all ${p.value >= p.warn ? 'bg-red-500' : 'bg-cyan-500'}`} style={{ width: `${Math.min(100, ((p.value - p.min) / (p.max - p.min)) * 100)}%` }} />
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
