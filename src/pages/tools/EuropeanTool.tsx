import { useState } from 'react'
import { motion } from 'framer-motion'
import { Globe, Search, Loader2, ArrowLeft, AlertCircle, BarChart3, TrendingUp, DollarSign } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, InsightsResponse } from '@/lib/api'

const countries = ['Romania','Germania','Franta','Italia','Spania','UK','Polonia','Olanda','Belgia','Austria','Suedia','Norvegia','Danemarca','Finlanda','Portugalia','Grecia','Cehia','Ungaria','Bulgaria','Croatia','Irlanda','Elvetia','Serbia','Ucraina']
const brands = ['BMW','Mercedes','Volkswagen','Audi','Toyota','Renault','Dacia','Ford','Opel','Skoda','Peugeot','Citroen','Fiat','Hyundai','Kia','Volvo','Nissan','Honda','Mazda','Suzuki','Seat','Porsche','Jaguar','Land Rover']

export default function EuropeanTool() {
  const [brand, setBrand] = useState('BMW')
  const [country, setCountry] = useState('Romania')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<InsightsResponse | null>(null)
  const [error, setError] = useState('')

  const search = async () => {
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.europeanInsights(brand, country)
      setResult(res)
    } catch (e) {
      setError('Eroare la obtinerea datelor.')
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-500 to-green-600 flex items-center justify-center"><Globe className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">AI European Insights</h1>
              <p className="text-xs text-slate-500">Statistici per marca si tara</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Selecteaza marca si tara</h2>
          <div className="grid grid-cols-2 gap-3 mb-4">
            <select value={brand} onChange={e => setBrand(e.target.value)} className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white focus:border-cyan-500/50 focus:outline-none">
              {brands.map(b => <option key={b} value={b} className="bg-slate-900">{b}</option>)}
            </select>
            <select value={country} onChange={e => setCountry(e.target.value)} className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white focus:border-cyan-500/50 focus:outline-none">
              {countries.map(c => <option key={c} value={c} className="bg-slate-900">{c}</option>)}
            </select>
          </div>
          <button onClick={search} disabled={loading} className="btn-primary w-full px-6 py-3.5 flex items-center justify-center gap-2 disabled:opacity-50">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
            Genereaza Insights
          </button>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-8 text-center">
              <h3 className="text-2xl font-black text-white mb-1">{result.brand}</h3>
              <p className="text-sm text-slate-400 mb-6">{result.country}</p>
              <div className="grid grid-cols-3 gap-4">
                <div className="glass rounded-2xl p-4">
                  <TrendingUp className="w-5 h-5 text-cyan-400 mx-auto mb-2" />
                  <p className="text-2xl font-black text-cyan-400">{result.fiabilitate}%</p>
                  <p className="text-xs text-slate-500">Fiabilitate</p>
                </div>
                <div className="glass rounded-2xl p-4">
                  <BarChart3 className="w-5 h-5 text-purple-400 mx-auto mb-2" />
                  <p className="text-2xl font-black text-purple-400">{result.popularitate}%</p>
                  <p className="text-xs text-slate-500">Popularitate</p>
                </div>
                <div className="glass rounded-2xl p-4">
                  <DollarSign className="w-5 h-5 text-emerald-400 mx-auto mb-2" />
                  <p className="text-2xl font-black text-emerald-400">{result.cost_mediu}</p>
                  <p className="text-xs text-slate-500">{result.currency}/an</p>
                </div>
              </div>
            </div>

            {(result.insights || []).length > 0 && (
              <div className="glass-card rounded-3xl p-8">
                <h4 className="text-sm font-bold text-white mb-4">Insights AI</h4>
                <div className="space-y-3">
                  {(result.insights || []).map((ins, i) => (
                    <motion.div key={i} initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: i * 0.08 }} className="glass rounded-2xl p-4">
                      <div className="flex items-start gap-3">
                        <span className="text-xl">{ins.icon}</span>
                        <div className="flex-1">
                          <div className="flex items-center gap-2 mb-1">
                            <span className="text-xs font-semibold text-cyan-400 uppercase tracking-wider">{ins.category}</span>
                          </div>
                          <h5 className="font-semibold text-white text-sm">{ins.title}</h5>
                          <p className="text-sm text-slate-400 mt-1">{ins.detail}</p>
                        </div>
                      </div>
                    </motion.div>
                  ))}
                </div>
              </div>
            )}
          </motion.div>
        )}
      </div>
    </div>
  )
}
