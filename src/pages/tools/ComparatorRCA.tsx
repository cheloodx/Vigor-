import { useState } from 'react'
import { ArrowLeft, Shield, ArrowRight, Loader } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

export default function ComparatorRCA() {
  const [engine, setEngine] = useState('1600')
  const [age, setAge] = useState('5')
  const [city, setCity] = useState('Bucuresti')
  const [make, setMake] = useState('')
  const [loading, setLoading] = useState(false)
  const [results, setResults] = useState<{name:string;price:number;rating:number;tip:string}[]>([])
  const [aiNote, setAiNote] = useState('')

  const compare = async () => {
    setLoading(true)
    try {
      const res = await api.chat(
        `Compara oferte RCA pentru: motor ${engine}cc, vechime ${age} ani, oras ${city}, marca ${make || 'necunoscuta'}. ` +
        `Listeaza 6 companii reale de asigurari din Romania cu: nume|pret_estimat_RON|rating(1-5)|sfat_scurt. ` +
        `Preturile sa fie realiste pentru 2024. Format strict: Nume|pret|rating|sfat, cate o linie per companie.`,
        make
      )
      const lines = res.response.split('\n').filter(l => l.includes('|'))
      if (lines.length >= 3) {
        const parsed = lines.slice(0, 6).map(l => {
          const p = l.split('|').map(s => s.trim().replace(/[^\w\s.,%-]/g, ''))
          const price = parseInt(p[1]?.replace(/\D/g, '') || '0')
          return { name: p[0] || 'N/A', price: price || 800 + Math.round(Math.random() * 400), rating: parseFloat(p[2]) || 4.0, tip: p[3] || '' }
        }).sort((a, b) => a.price - b.price)
        setResults(parsed)
        setAiNote(res.response.split('\n').filter(l => !l.includes('|')).join(' ').trim().slice(0, 200))
      } else {
        throw new Error('parse')
      }
    } catch {
      const cc = parseInt(engine) || 1600
      const a = parseInt(age) || 5
      const m = (cc / 1600) * (1 + a * 0.03)
      const companies = [
        { name: 'Euroins', base: 800, rating: 3.5 }, { name: 'Groupama', base: 950, rating: 4.2 },
        { name: 'Allianz-Tiriac', base: 1100, rating: 4.5 }, { name: 'Omniasig', base: 900, rating: 3.8 },
        { name: 'Generali', base: 1050, rating: 4.3 }, { name: 'Uniqa', base: 1000, rating: 4.0 },
      ]
      setResults(companies.map(c => ({
        name: c.name, price: Math.round(c.base * m * (0.9 + Math.random() * 0.2)), rating: c.rating, tip: ''
      })).sort((a, b) => a.price - b.price))
      setAiNote('Estimare bazata pe calcul local. Preturile pot varia.')
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center"><Shield className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Comparator RCA</h1><p className="text-xs text-slate-500">Oferte asigurare AI</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <div className="space-y-3">
            <div><label className="text-xs text-slate-500">Marca masina</label><input value={make} onChange={e => setMake(e.target.value)} placeholder="ex: Volkswagen Golf" className="w-full glass rounded-xl px-4 py-3 text-white text-sm mt-1" /></div>
            <div><label className="text-xs text-slate-500">Capacitate motor (cc)</label><input value={engine} onChange={e => setEngine(e.target.value)} className="w-full glass rounded-xl px-4 py-3 text-white text-sm mt-1" type="number" /></div>
            <div><label className="text-xs text-slate-500">Vechime masina (ani)</label><input value={age} onChange={e => setAge(e.target.value)} className="w-full glass rounded-xl px-4 py-3 text-white text-sm mt-1" type="number" /></div>
            <div><label className="text-xs text-slate-500">Oras</label><input value={city} onChange={e => setCity(e.target.value)} className="w-full glass rounded-xl px-4 py-3 text-white text-sm mt-1" /></div>
          </div>
          <button onClick={compare} disabled={loading} className="w-full btn-primary py-3 text-sm font-bold mt-4 flex items-center justify-center gap-2">
            {loading ? <><Loader className="w-4 h-4 animate-spin" />Analizam oferte...</> : 'Compara Oferte RCA'}
          </button>
        </div>
        {aiNote && <p className="text-xs text-slate-500 mb-3 px-2">{aiNote}</p>}
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
                  {r.tip && <p className="text-xs text-slate-400 mt-1">{r.tip}</p>}
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
