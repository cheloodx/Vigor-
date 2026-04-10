import { useState } from 'react'
import { ArrowLeft, MapPin, Phone, Star, Navigation } from 'lucide-react'
import { Link } from 'react-router-dom'

const MOCK_SERVICES = [
  { name: 'Auto Service Pro', address: 'Str. Mihai Eminescu 45, Bucuresti', phone: '021 234 5678', rating: 4.7, distance: '1.2 km', type: 'Autorizat', speciality: 'Toate marcile' },
  { name: 'Quick Fix Auto', address: 'Bd. Unirii 120, Bucuresti', phone: '021 345 6789', rating: 4.3, distance: '2.5 km', type: 'Independent', speciality: 'Volkswagen, Audi' },
  { name: 'EuroAuto Service', address: 'Str. Victoriei 78, Bucuresti', phone: '021 456 7890', rating: 4.5, distance: '3.1 km', type: 'Autorizat', speciality: 'BMW, Mercedes' },
  { name: 'Turbo Diagnostic', address: 'Calea Mosilor 200, Bucuresti', phone: '021 567 8901', rating: 4.1, distance: '4.0 km', type: 'Independent', speciality: 'Diagnoza + Turbo' },
  { name: 'Master Auto', address: 'Str. Dorobanti 55, Bucuresti', phone: '021 678 9012', rating: 4.8, distance: '5.5 km', type: 'Autorizat', speciality: 'Renault, Dacia' },
]

export default function HartaService() {
  const [city, setCity] = useState('Bucuresti')
  const [filter, setFilter] = useState<'all' | 'auth' | 'ind'>('all')
  const services = MOCK_SERVICES.filter(s => filter === 'all' || (filter === 'auth' ? s.type === 'Autorizat' : s.type === 'Independent'))

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-500 to-violet-600 flex items-center justify-center"><MapPin className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Harta Service</h1><p className="text-xs text-slate-500">Service-uri aproape</p></div>
        </div>
        <div className="glass-card rounded-2xl p-4 mb-4">
          <div className="flex gap-2 mb-3">
            <input value={city} onChange={e => setCity(e.target.value)} placeholder="Oras" className="flex-1 glass rounded-xl px-4 py-3 text-white text-sm" />
            <button className="btn-primary px-4"><Navigation className="w-4 h-4" /></button>
          </div>
          <div className="flex gap-2">
            {(['all', 'auth', 'ind'] as const).map(f => (
              <button key={f} onClick={() => setFilter(f)} className={`px-4 py-2 rounded-xl text-xs font-medium ${filter === f ? 'bg-cyan-500 text-white' : 'glass text-slate-400'}`}>
                {f === 'all' ? 'Toate' : f === 'auth' ? 'Autorizate' : 'Independente'}
              </button>
            ))}
          </div>
        </div>
        <div className="space-y-3">
          {services.map((s, i) => (
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
                <button className="glass rounded-xl px-4 py-2 text-xs text-white flex items-center gap-1"><Navigation className="w-3 h-3" />Navigheaza</button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
