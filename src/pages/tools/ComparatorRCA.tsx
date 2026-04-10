import { useState } from 'react'
import { ArrowLeft, Shield, ArrowRight } from 'lucide-react'
import { Link } from 'react-router-dom'

const COMPANIES = [
  { name: 'Euroins', base: 800, rating: 3.5 },
  { name: 'Groupama', base: 950, rating: 4.2 },
  { name: 'Allianz-Tiriac', base: 1100, rating: 4.5 },
  { name: 'Omniasig', base: 900, rating: 3.8 },
  { name: 'Generali', base: 1050, rating: 4.3 },
  { name: 'Uniqa', base: 1000, rating: 4.0 },
]

export default function ComparatorRCA() {
  const [engine, setEngine] = useState('1600')
  const [age, setAge] = useState('5')
  const [city, setCity] = useState('Bucuresti')
  const [results, setResults] = useState<{name:string;price:number;rating:number}[]>([])

  const compare = () => {
    const cc = parseInt(engine) || 1600
    const a = parseInt(age) || 5
    const multiplier = (cc / 1600) * (1 + a * 0.03)
    const r = COMPANIES.map(c => ({
      name: c.name, price: Math.round(c.base * multiplier * (0.9 + Math.random() * 0.2)), rating: c.rating,
    })).sort((a, b) => a.price - b.price)
    setResults(r)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center"><Shield className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Comparator RCA</h1><p className="text-xs text-slate-500">Oferte asigurare</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <div className="space-y-3">
            <div><label className="text-xs text-slate-500">Capacitate motor (cc)</label><input value={engine} onChange={e => setEngine(e.target.value)} className="w-full glass rounded-xl px-4 py-3 text-white text-sm mt-1" type="number" /></div>
            <div><label className="text-xs text-slate-500">Vechime masina (ani)</label><input value={age} onChange={e => setAge(e.target.value)} className="w-full glass rounded-xl px-4 py-3 text-white text-sm mt-1" type="number" /></div>
            <div><label className="text-xs text-slate-500">Oras</label><input value={city} onChange={e => setCity(e.target.value)} className="w-full glass rounded-xl px-4 py-3 text-white text-sm mt-1" /></div>
          </div>
          <button onClick={compare} className="w-full btn-primary py-3 text-sm font-bold mt-4">Compara Oferte RCA</button>
        </div>
        {results.length > 0 && (
          <div className="space-y-3">
            {results.map((r, i) => (
              <div key={i} className={`glass-card rounded-xl p-4 flex items-center justify-between ${i === 0 ? 'border border-emerald-500/30' : ''}`}>
                <div>
                  <div className="flex items-center gap-2">
                    <p className="text-sm font-bold text-white">{r.name}</p>
                    {i === 0 && <span className="text-[10px] bg-emerald-500 text-white px-2 py-0.5 rounded-full">CEL MAI IEFTIN</span>}
                  </div>
                  <div className="flex items-center gap-1 mt-1">{'★'.repeat(Math.round(r.rating))}<span className="text-xs text-slate-500">{r.rating}</span></div>
                </div>
                <div className="text-right">
                  <p className="text-lg font-black text-cyan-400">{r.price} RON</p>
                  <button className="text-xs text-slate-500 hover:text-white flex items-center gap-1"><ArrowRight className="w-3 h-3" />Detalii</button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
