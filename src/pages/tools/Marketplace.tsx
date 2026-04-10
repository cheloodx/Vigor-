import { useState } from 'react'
import { ArrowLeft, Store, Search, Star } from 'lucide-react'
import { Link } from 'react-router-dom'

const LISTINGS = [
  { name: 'Service Pro Auto', type: 'Service autorizat', city: 'Bucuresti', rating: 4.8, reviews: 234, speciality: 'Toate marcile', priceRange: '$$' },
  { name: 'Mecanic Ion Popescu', type: 'Mecanic verificat', city: 'Cluj-Napoca', rating: 4.9, reviews: 156, speciality: 'VW, Audi, Skoda', priceRange: '$' },
  { name: 'Turbo Expert SRL', type: 'Specialist turbo', city: 'Timisoara', rating: 4.6, reviews: 89, speciality: 'Reparatii turbo', priceRange: '$$' },
  { name: 'Electric Auto Lab', type: 'Electrician auto', city: 'Iasi', rating: 4.7, reviews: 112, speciality: 'Electronica auto', priceRange: '$' },
  { name: 'Diesel Service Expert', type: 'Specialist diesel', city: 'Brasov', rating: 4.5, reviews: 67, speciality: 'Injectoare, pompe', priceRange: '$$' },
  { name: 'Vopsitorie Profesional', type: 'Tinichigerie', city: 'Constanta', rating: 4.4, reviews: 45, speciality: 'Vopsitorie, tabla', priceRange: '$$$' },
]

export default function Marketplace() {
  const [query, setQuery] = useState('')
  const filtered = LISTINGS.filter(l => !query || l.name.toLowerCase().includes(query.toLowerCase()) || l.speciality.toLowerCase().includes(query.toLowerCase()) || l.city.toLowerCase().includes(query.toLowerCase()))

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center"><Store className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Marketplace</h1><p className="text-xs text-slate-500">Mecanici & service-uri</p></div>
        </div>
        <div className="glass-card rounded-2xl p-4 mb-6">
          <div className="flex gap-2">
            <Search className="w-5 h-5 text-slate-500 mt-3 ml-3" />
            <input value={query} onChange={e => setQuery(e.target.value)} placeholder="Cauta mecanic, service, specialitate, oras..." className="flex-1 glass rounded-xl px-4 py-3 text-white text-sm" />
          </div>
        </div>
        <div className="space-y-3">
          {filtered.map((l, i) => (
            <div key={i} className="glass-card rounded-xl p-4">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="text-sm font-bold text-white">{l.name}</h3>
                  <p className="text-xs text-cyan-400">{l.type}</p>
                  <p className="text-xs text-slate-500 mt-1">{l.city} • {l.speciality}</p>
                </div>
                <div className="text-right">
                  <div className="flex items-center gap-1"><Star className="w-3 h-3 text-amber-400" /><span className="text-sm font-bold text-white">{l.rating}</span></div>
                  <span className="text-[10px] text-slate-500">{l.reviews} review-uri</span>
                  <p className="text-xs text-emerald-400 mt-1">{l.priceRange}</p>
                </div>
              </div>
              <div className="flex gap-2 mt-3">
                <button className="flex-1 glass rounded-xl py-2 text-center text-xs text-white hover:bg-white/10">Profil</button>
                <button className="flex-1 btn-primary rounded-xl py-2 text-center text-xs">Contacteaza</button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
