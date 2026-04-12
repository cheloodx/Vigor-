import { useState } from 'react'
import { ArrowLeft, Store, Search, Star, Loader } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

interface Listing { name: string; type: string; city: string; rating: number; reviews: number; speciality: string; priceRange: string }

export default function Marketplace() {
  const [query, setQuery] = useState('')
  const [loading, setLoading] = useState(false)
  const [listings, setListings] = useState<Listing[]>([])
  const [searched, setSearched] = useState(false)

  const search = async () => {
    if (!query) return
    setLoading(true)
    setSearched(true)
    try {
      const res = await api.chat(
        `Cauta mecanici si service-uri auto in Romania pentru: "${query}". ` +
        `Listeaza 6 rezultate realiste cu: nume|tip(Service autorizat/Mecanic verificat/Specialist)|oras|rating(1-5)|nr_reviewuri|specialitate|nivel_pret($/$$/$$$$). ` +
        `Format strict per linie. Include rezultate variate din diferite orase.`
      )
      const lines = res.response.split('\n').filter(l => l.includes('|'))
      if (lines.length >= 3) {
        setListings(lines.slice(0, 8).map(l => {
          const p = l.split('|').map(s => s.trim())
          return {
            name: p[0] || 'Service Auto', type: p[1] || 'Service', city: p[2] || 'Romania',
            rating: parseFloat(p[3]) || 4.0, reviews: parseInt(p[4]) || 50,
            speciality: p[5] || 'Toate marcile', priceRange: p[6] || '$$',
          }
        }))
      } else { throw new Error('parse') }
    } catch {
      setListings([
        { name: 'Service Pro Auto', type: 'Service autorizat', city: 'Bucuresti', rating: 4.8, reviews: 234, speciality: 'Toate marcile', priceRange: '$$' },
        { name: 'Mecanic Expert', type: 'Mecanic verificat', city: 'Cluj-Napoca', rating: 4.9, reviews: 156, speciality: 'VW, Audi, Skoda', priceRange: '$' },
        { name: 'Turbo Expert SRL', type: 'Specialist turbo', city: 'Timisoara', rating: 4.6, reviews: 89, speciality: 'Reparatii turbo', priceRange: '$$' },
        { name: 'Electric Auto Lab', type: 'Electrician auto', city: 'Iasi', rating: 4.7, reviews: 112, speciality: 'Electronica auto', priceRange: '$' },
        { name: 'Diesel Service Expert', type: 'Specialist diesel', city: 'Brasov', rating: 4.5, reviews: 67, speciality: 'Injectoare, pompe', priceRange: '$$' },
      ])
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center"><Store className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Marketplace</h1><p className="text-xs text-slate-500">Mecanici & service-uri AI</p></div>
        </div>
        <div className="glass-card rounded-2xl p-4 mb-6">
          <div className="flex gap-2">
            <input value={query} onChange={e => setQuery(e.target.value)} placeholder="Cauta mecanic, service, specialitate, oras..." className="flex-1 glass rounded-xl px-4 py-3 text-white text-sm" onKeyDown={e => e.key === 'Enter' && search()} />
            <button onClick={search} disabled={loading} className="btn-primary px-5">
              {loading ? <Loader className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />}
            </button>
          </div>
          <div className="flex flex-wrap gap-2 mt-3">
            {['Mecanic VW Bucuresti', 'Turbo specialist', 'Electrician auto Cluj', 'Tinichigerie Timisoara'].map(q => (
              <button key={q} onClick={() => { setQuery(q); }} className="px-3 py-1 rounded-lg text-xs glass text-slate-400 hover:text-white">{q}</button>
            ))}
          </div>
        </div>
        {searched && listings.length === 0 && !loading && (
          <div className="glass-card rounded-2xl p-6 text-center"><p className="text-slate-500">Niciun rezultat. Incearca alt termen.</p></div>
        )}
        <div className="space-y-3">
          {listings.map((l, i) => (
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
                <a href={`https://www.google.com/maps/search/${encodeURIComponent(l.name + ' ' + l.city)}`} target="_blank" rel="noopener noreferrer" className="flex-1 glass rounded-xl py-2 text-center text-xs text-white hover:bg-white/10">Vezi pe Maps</a>
                <button className="flex-1 btn-primary rounded-xl py-2 text-center text-xs">Contacteaza</button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
