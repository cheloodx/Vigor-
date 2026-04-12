import { useState } from 'react'
import { ArrowLeft, Fuel, Calculator } from 'lucide-react'
import { Link } from 'react-router-dom'

export default function CalculatorConsum() {
  const [km, setKm] = useState('')
  const [litri, setLitri] = useState('')
  const [pret, setPret] = useState('7.50')
  const [result, setResult] = useState<{consum:number;cost100:number;costKm:number} | null>(null)

  const calc = () => {
    const d = parseFloat(km); const l = parseFloat(litri); const p = parseFloat(pret)
    if (!d || !l) return
    const consum = (l / d) * 100
    setResult({ consum: Math.round(consum * 100) / 100, cost100: Math.round(consum * p * 100) / 100, costKm: Math.round((l * p / d) * 1000) / 1000 })
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-orange-500 to-amber-600 flex items-center justify-center"><Fuel className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Calculator Consum</h1><p className="text-xs text-slate-500">Consum real L/100km</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <div className="space-y-3">
            <div><label className="text-xs text-slate-500 mb-1 block">Distanta parcursa (km)</label><input value={km} onChange={e => setKm(e.target.value)} placeholder="ex: 450" className="w-full glass rounded-xl px-4 py-3 text-white text-sm" type="number" /></div>
            <div><label className="text-xs text-slate-500 mb-1 block">Combustibil consumat (litri)</label><input value={litri} onChange={e => setLitri(e.target.value)} placeholder="ex: 35" className="w-full glass rounded-xl px-4 py-3 text-white text-sm" type="number" /></div>
            <div><label className="text-xs text-slate-500 mb-1 block">Pret combustibil (RON/litru)</label><input value={pret} onChange={e => setPret(e.target.value)} className="w-full glass rounded-xl px-4 py-3 text-white text-sm" type="number" step="0.01" /></div>
          </div>
          <button onClick={calc} className="w-full btn-primary py-3 text-sm font-bold mt-4 flex items-center justify-center gap-2"><Calculator className="w-4 h-4" />Calculeaza</button>
        </div>
        {result && (
          <div className="grid grid-cols-3 gap-3">
            <div className="glass-card rounded-2xl p-6 text-center">
              <p className="text-xs text-slate-500 mb-1">CONSUM</p>
              <p className="text-3xl font-black text-cyan-400">{result.consum}</p>
              <p className="text-xs text-slate-500">L/100km</p>
            </div>
            <div className="glass-card rounded-2xl p-6 text-center">
              <p className="text-xs text-slate-500 mb-1">COST/100KM</p>
              <p className="text-3xl font-black text-amber-400">{result.cost100}</p>
              <p className="text-xs text-slate-500">RON</p>
            </div>
            <div className="glass-card rounded-2xl p-6 text-center">
              <p className="text-xs text-slate-500 mb-1">COST/KM</p>
              <p className="text-3xl font-black text-emerald-400">{result.costKm}</p>
              <p className="text-xs text-slate-500">RON</p>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
