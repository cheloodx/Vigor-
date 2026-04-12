import { useState } from 'react'
import { ArrowLeft, MapPin, Phone, Star, Navigation, Loader } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

interface ServiceItem { name: string; address: string; phone: string; rating: number; distance: string; type: string; speciality: string }

export default function HartaService() {
  const [city, setCity] = useState('Bucuresti')
  const [make, setMake] = useState('')
  const [filter, setFilter] = useState<'all' | 'auth' | 'ind'>('all')
  const [loading, setLoading] = useState(false)
  const [services, setServices] = useState<ServiceItem[]>([])
  const [searched, setSearched] = useState(false)

  const search = async () => {
    setLoading(true)
    setSearched(true)
    try {
      const res = await api.chat(
        `Recomanda 6 service-uri auto reale sau realiste in ${city}${make ? ' specializate pe ' + make : ''}. ` +
        `Format strict per linie: nume|adresa|telefon|rating(1-5)|distanta_km|tip(Autorizat/Independent)|specialitate. ` +
        `Include service-uri reale din Romania daca le cunosti.`,
        make
      )
      const lines = res.response.split('\n').filter(l => l.includes('|'))
      if (lines.length >= 3) {
        setServices(lines.slice(0, 8).map(l => {
          const p = l.split('|').map(s => s.trim())
          return {
            name: p[0] || 'Service Auto', address: p[1] || city,
            phone: p[2] || '0700 000 000', rating: parseFloat(p[3]) || 4.0,
            distance: p[4] || '2 km', type: p[5] || 'Independent', speciality: p[6] || 'Toate marcile',
          }
        }))
      } else { throw new Error('parse') }
    } catch {
      setServices([
        { name: 'Auto Service Pro', address: `Str. Principala 45, ${city}`, phone: '021 234 5678', rating: 4.7, distance: '1.2 km', type: 'Autorizat', speciality: make || 'Toate marcile' },
        { name: 'Quick Fix Auto', address: `Bd. Central 120, ${city}`, phone: '021 345 6789', rating: 4.3, distance: '2.5 km', type: 'Independent', speciality: 'VW, Audi, Skoda' },
        { name: 'EuroAuto Service', address: `Str. Victoriei 78, ${city}`, phone: '021 456 7890', rating: 4.5, distance: '3.1 km', type: 'Autorizat', speciality: 'BMW, Mercedes' },
        { name: 'Turbo Diagnostic', address: `Calea Mare 200, ${city}`, phone: '021 567 8901', rating: 4.1, distance: '4.0 km', type: 'Independent', speciality: 'Diagnoza + Turbo' },
        { name: 'Master Auto', address: `Str. Noua 55, ${city}`, phone: '021 678 9012', rating: 4.8, distance: '5.5 km', type: 'Autorizat', speciality: 'Renault, Dacia' },
      ])
    }
    setLoading(false)
  }

  const filtered = services.filter(s => filter === 'all' || (filter === 'auth' ? s.type === 'Autorizat' : s.type === 'Independent'))

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-500 to-violet-600 flex items-center justify-center"><MapPin className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Harta Service</h1><p className="text-xs text-slate-500">Service-uri AI recomandate</p></div>
        </div>
        <div className="glass-card rounded-2xl p-4 mb-4">
          <div className="flex gap-2 mb-3">
            <input value={city} onChange={e => setCity(e.target.value)} placeholder="Oras (ex: Bucuresti)" className="flex-1 glass rounded-xl px-4 py-3 text-white text-sm" />
          </div>
          <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca masina (optional)" className="w-full glass rounded-xl px-4 py-3 text-white text-sm mb-3" />
          <button onClick={search} disabled={loading} className="w-full btn-primary py-3 text-sm font-bold flex items-center justify-center gap-2 mb-3">
            {loading ? <><Loader className="w-4 h-4 animate-spin" />Cautam service-uri...</> : <><Navigation className="w-4 h-4" />Cauta Service-uri</>}
          </button>
          <div className="flex gap-2">
            {(['all', 'auth', 'ind'] as const).map(f => (
              <button key={f} onClick={() => setFilter(f)} className={`px-4 py-2 rounded-xl text-xs font-medium ${filter === f ? 'bg-cyan-500 text-white' : 'glass text-slate-400'}`}>
                {f === 'all' ? 'Toate' : f === 'auth' ? 'Autorizate' : 'Independente'}
              </button>
            ))}
          </div>
        </div>
        {searched && filtered.length === 0 && !loading && (
          <div className="glass-card rounded-2xl p-6 text-center"><p className="text-slate-500">Niciun rezultat. Incearca alt oras sau filtru.</p></div>
        )}
        <div className="space-y-3">
          {filtered.map((s, i) => (
            <div key={i} className="glass-card rounded-xl p-4">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-sm font-bold text-white">{s.name}</h3>
                  <p className="text-xs text-slate-400 mt-1">{s.address}</p>
                  <div className="flex items-center gap-2 mt-2">
                    <span className={`text-[10px] px-2 py-0.5 rounded-full ${s.type === 'Autorizat' ? 'bg-amber-500/20 text-amber-400' : 'bg-emerald-500/20 text-emerald-400'}`}>{s.type}</span>
                    <span className="text-[10px] text-slate-500">{s.speciality}</span>
                  </div>
                </div>
                <div className="text-right">
                  <div className="flex items-center gap-1"><Star className="w-3 h-3 text-amber-400" /><span className="text-sm font-bold text-white">{s.rating}</span></div>
                  <span className="text-xs text-slate-500">{s.distance}</span>
                </div>
              </div>
              <div className="flex gap-2 mt-3">
                <a href={`tel:${s.phone}`} className="flex-1 glass rounded-xl py-2 text-center text-xs text-cyan-400 flex items-center justify-center gap-1"><Phone className="w-3 h-3" />{s.phone}</a>
                <a href={`https://www.google.com/maps/search/${encodeURIComponent(s.name + ' ' + s.address)}`} target="_blank" rel="noopener noreferrer" className="glass rounded-xl px-4 py-2 text-xs text-white flex items-center gap-1"><Navigation className="w-3 h-3" />Maps</a>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
