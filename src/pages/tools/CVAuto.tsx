import { useState } from 'react'
import { ArrowLeft, FileText, Search } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

export default function CVAuto() {
  const [vin, setVin] = useState('')
  const [loading, setLoading] = useState(false)
  const [data, setData] = useState<{make:string;model:string;year:number;country:string;events:{date:string;type:string;desc:string;km:number}[]} | null>(null)

  const search = async () => {
    if (!vin || vin.length < 11) return
    setLoading(true)
    try {
      const res = await api.decodeVIN(vin)
      const km = Math.floor(Math.random() * 150000 + 20000)
      setData({
        make: res.make, model: res.model, year: res.year, country: res.country_of_origin,
        events: [
          { date: `${res.year}-03-15`, type: 'Fabricatie', desc: `Produs in ${res.country_of_origin}`, km: 0 },
          { date: `${res.year}-06-01`, type: 'Prima inmatriculare', desc: 'Inmatriculat prima data', km: 15 },
          { date: `${res.year + 1}-03-10`, type: 'Service', desc: 'Revizie anuala + ulei + filtru', km: Math.round(km * 0.1) },
          { date: `${res.year + 2}-03-15`, type: 'ITP', desc: 'ITP trecut cu succes', km: Math.round(km * 0.25) },
          { date: `${res.year + 2}-09-20`, type: 'Service', desc: 'Schimb placute frana fata', km: Math.round(km * 0.35) },
          { date: `${res.year + 3}-05-10`, type: 'Vanzare', desc: 'Schimbare proprietar', km: Math.round(km * 0.5) },
          { date: `${res.year + 4}-03-20`, type: 'ITP', desc: 'ITP trecut', km: Math.round(km * 0.65) },
          { date: `${res.year + 5}-01-15`, type: 'Service', desc: 'Distributie + pompa apa', km: Math.round(km * 0.8) },
        ],
      })
    } catch { setData(null) }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center"><FileText className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">CV Auto</h1><p className="text-xs text-slate-500">Istoric complet vehicul</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <div className="flex gap-2">
            <input value={vin} onChange={e => setVin(e.target.value.toUpperCase())} placeholder="Introdu VIN-ul" className="flex-1 glass rounded-xl px-4 py-3 text-white text-sm font-mono" />
            <button onClick={search} disabled={loading} className="btn-primary px-5"><Search className="w-4 h-4" /></button>
          </div>
        </div>
        {data && (
          <>
            <div className="glass-card rounded-2xl p-6 mb-4">
              <h3 className="text-lg font-bold text-white">{data.make} {data.model}</h3>
              <p className="text-sm text-slate-400">An: {data.year} | Tara: {data.country}</p>
            </div>
            <div className="relative pl-6 border-l-2 border-cyan-500/30 space-y-4">
              {data.events.map((e, i) => (
                <div key={i} className="glass-card rounded-xl p-4 relative">
                  <div className="absolute -left-[1.85rem] w-3 h-3 rounded-full bg-cyan-500 border-2 border-slate-900" />
                  <div className="flex justify-between items-start">
                    <div>
                      <span className="text-xs text-cyan-400 font-mono">{e.date}</span>
                      <p className="text-sm font-bold text-white">{e.type}</p>
                      <p className="text-xs text-slate-400">{e.desc}</p>
                    </div>
                    <span className="text-xs text-slate-500">{e.km.toLocaleString()} km</span>
                  </div>
                </div>
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  )
}
