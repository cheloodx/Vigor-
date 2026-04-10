import { useState } from 'react'
import { ArrowLeft, TrendingUp } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

export default function EstimatorValoare() {
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [year, setYear] = useState('')
  const [km, setKm] = useState('')
  const [fuel, setFuel] = useState('Diesel')
  const [loading, setLoading] = useState(false)
  const [val, setVal] = useState<{min:number;max:number;avg:number;depreciation:number;tip:string} | null>(null)

  const estimate = async () => {
    if (!make || !model || !year) return
    setLoading(true)
    try {
      const res = await api.chat(`Estimeaza pretul unei masini ${make} ${model} din ${year}, ${km || '100000'} km, ${fuel}. Raspunde DOAR cu: min|max|avg in EUR. Exemplu: 8000|12000|10000`, make, model)
      const nums = res.response.match(/\d+/g)
      if (nums && nums.length >= 3) {
        const [mn, mx, av] = [parseInt(nums[0]), parseInt(nums[1]), parseInt(nums[2])]
        const age = 2024 - parseInt(year)
        setVal({ min: mn, max: mx, avg: av, depreciation: Math.round(age * 8 + (parseInt(km) || 100000) / 5000), tip: age > 10 ? 'Masina necesita inspectie detaliata inainte de achizitie' : 'Pretul e competitiv pentru piata actuala' })
      } else {
        throw new Error('parse')
      }
    } catch {
      const base = 25000 - (2024 - parseInt(year)) * 1500 - (parseInt(km) || 100000) / 20
      const avg = Math.max(1500, Math.round(base))
      setVal({ min: Math.round(avg * 0.8), max: Math.round(avg * 1.2), avg, depreciation: Math.round((2024 - parseInt(year)) * 8), tip: 'Pretul variaza in functie de stare, dotari si locatie' })
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-green-500 to-emerald-600 flex items-center justify-center"><TrendingUp className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Estimator Valoare</h1><p className="text-xs text-slate-500">Pret masina pe piata</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <div className="grid grid-cols-2 gap-3 mb-3">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca" className="glass rounded-xl px-4 py-3 text-white text-sm" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model" className="glass rounded-xl px-4 py-3 text-white text-sm" />
            <input value={year} onChange={e => setYear(e.target.value)} placeholder="An" className="glass rounded-xl px-4 py-3 text-white text-sm" type="number" />
            <input value={km} onChange={e => setKm(e.target.value)} placeholder="Km" className="glass rounded-xl px-4 py-3 text-white text-sm" type="number" />
          </div>
          <select value={fuel} onChange={e => setFuel(e.target.value)} className="w-full glass rounded-xl px-4 py-3 text-white text-sm mb-3 bg-transparent">
            <option value="Diesel">Diesel</option><option value="Benzina">Benzina</option><option value="Hybrid">Hybrid</option><option value="Electric">Electric</option>
          </select>
          <button onClick={estimate} disabled={loading} className="w-full btn-primary py-3 text-sm font-bold">{loading ? 'Estimam...' : 'Estimeaza Valoare'}</button>
        </div>
        {val && (
          <div className="space-y-4">
            <div className="glass-card rounded-2xl p-6 text-center border border-emerald-500/30">
              <p className="text-xs text-slate-500 mb-1">VALOARE ESTIMATA</p>
              <p className="text-5xl font-black text-emerald-400">€{val.avg.toLocaleString()}</p>
              <p className="text-sm text-slate-400 mt-2">€{val.min.toLocaleString()} — €{val.max.toLocaleString()}</p>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div className="glass-card rounded-xl p-4 text-center"><p className="text-xs text-slate-500">DEPRECIERE</p><p className="text-xl font-bold text-amber-400">{val.depreciation}%</p></div>
              <div className="glass-card rounded-xl p-4 text-center"><p className="text-xs text-slate-500">TIP</p><p className="text-xs text-slate-300 mt-1">{val.tip}</p></div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
