import { useState } from 'react'
import { motion } from 'framer-motion'
import { Car, Search, Loader2, ArrowLeft, AlertCircle, MapPin, Fuel, Settings, Shield, Globe, Database, Cpu } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, VINResponse } from '@/lib/api'

export default function VINTool() {
  const [vin, setVin] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<VINResponse | null>(null)
  const [error, setError] = useState('')

  const decode = async () => {
    const v = vin.trim().toUpperCase()
    if (v.length < 7) { setError('VIN-ul trebuie sa aiba minim 7 caractere.'); return }
    if (v.length > 17) { setError('VIN-ul nu poate avea mai mult de 17 caractere.'); return }
    if (v.length !== 17 && v.length < 11) {
      setError('Introduceti un VIN complet (17 caractere) sau un numar de sasiu european scurt (minim 11 caractere).')
      return
    }
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.decodeVIN(v)
      setResult(res)
    } catch {
      setError('VIN invalid sau eroare server. Verificati formatul.')
    }
    setLoading(false)
  }

  const sourceBadge = (source: string) => {
    if (source === 'NHTSA') return { color: 'text-emerald-400 bg-emerald-500/10 border-emerald-500/30', icon: Database, label: 'NHTSA Verified' }
    if (source === 'Backend') return { color: 'text-blue-400 bg-blue-500/10 border-blue-500/30', icon: Globe, label: 'AutoDiag Backend' }
    return { color: 'text-amber-400 bg-amber-500/10 border-amber-500/30', icon: Cpu, label: 'AI Estimated' }
  }

  const confidenceColor = (c: string) => {
    if (c === 'High') return 'text-emerald-400'
    if (c === 'Medium') return 'text-blue-400'
    return 'text-amber-400'
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center"><Car className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">VIN Decoder</h1>
              <p className="text-xs text-slate-500">Decodifica seria de sasiu - Suport EU complet</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-2">Introdu VIN-ul</h2>
          <p className="text-xs text-slate-500 mb-4">Accepta VIN standard (17 caractere) si numere de sasiu europene scurte (11+ caractere)</p>
          <div className="flex gap-3">
            <input value={vin} onChange={e => setVin(e.target.value.toUpperCase())} onKeyDown={e => e.key === 'Enter' && decode()} placeholder="Ex: WVWZZZ3CZFE123456" maxLength={17} className="flex-1 bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-lg font-mono text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 uppercase tracking-wider" />
            <button onClick={decode} disabled={loading} className="btn-primary px-6 py-3.5 flex items-center gap-2 disabled:opacity-50">
              {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
              <span className="hidden sm:inline">Decodifica</span>
            </button>
          </div>
          <div className="flex items-center justify-between mt-2">
            <p className="text-xs text-slate-500">{vin.length}/17 caractere</p>
            {vin.length > 0 && vin.length < 17 && vin.length >= 11 && (
              <p className="text-xs text-amber-400">Numar de sasiu scurt - se va folosi AI Estimation</p>
            )}
          </div>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            {/* Source + Confidence + EU badges */}
            <div className="flex flex-wrap gap-2">
              {(() => { const b = sourceBadge(result.data_source); return (
                <span className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold border ${b.color}`}>
                  <b.icon className="w-3.5 h-3.5" />{b.label}
                </span>
              )})()}
              <span className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold border border-white/10 bg-white/5 ${confidenceColor(result.confidence)}`}>
                <Shield className="w-3.5 h-3.5" />Incredere: {result.confidence}
              </span>
              {result.is_european && (
                <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold border border-blue-500/30 text-blue-400 bg-blue-500/10">
                  <Globe className="w-3.5 h-3.5" />Vehicul European
                </span>
              )}
            </div>

            <div className="glass-card rounded-3xl p-8">
              <div className="text-center mb-6">
                <p className="text-xs text-cyan-400 font-mono mb-1">{result.vin}</p>
                <h3 className="text-3xl font-black text-white">{result.make} {result.model}</h3>
                <p className="text-lg text-slate-400">An fabricatie: {result.year}</p>
                {result.model.includes('Contact dealer') && (
                  <p className="text-sm text-amber-400 mt-1">Contacteaza dealer-ul pentru detalii complete despre model</p>
                )}
              </div>
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                {[
                  { icon: Fuel, label: 'Combustibil', val: result.fuel_type },
                  { icon: Settings, label: 'Motor', val: `${result.engine_type} ${result.engine_capacity}` },
                  { icon: Settings, label: 'Transmisie', val: result.transmission },
                  { icon: Car, label: 'Caroserie', val: result.body_type },
                  { icon: Settings, label: 'Tractiune', val: result.drive_type },
                  { icon: MapPin, label: 'Tara origine', val: result.country_of_origin },
                ].map((s, i) => (
                  <div key={i} className="glass rounded-2xl p-4 text-center">
                    <s.icon className="w-5 h-5 text-slate-500 mx-auto mb-2" />
                    <p className="text-[10px] text-slate-500 uppercase tracking-wider mb-1">{s.label}</p>
                    <p className="text-sm font-semibold text-white">{s.val || 'N/A'}</p>
                  </div>
                ))}
              </div>
            </div>

            <div className="grid sm:grid-cols-2 gap-4">
              <div className="glass-card rounded-3xl p-6">
                <h4 className="text-sm font-bold text-white mb-3">Producator</h4>
                <p className="text-sm text-slate-400">{result.manufacturer}</p>
                <p className="text-xs text-slate-500 mt-1">Fabrica: {result.plant}</p>
              </div>
              <div className="glass-card rounded-3xl p-6">
                <h4 className="text-sm font-bold text-white mb-3 flex items-center gap-2"><Shield className="w-4 h-4 text-red-400" />Recall-uri</h4>
                <p className="text-2xl font-black text-white">{result.recall_count}</p>
                <p className="text-xs text-slate-500">rechemari inregistrate</p>
              </div>
            </div>

            {(result.common_problems || []).length > 0 && (
              <div className="glass-card rounded-3xl p-8">
                <h4 className="text-sm font-bold text-white mb-4">Probleme Frecvente</h4>
                <div className="space-y-2">
                  {(result.common_problems || []).map((p, i) => (
                    <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                      <AlertCircle className="w-4 h-4 text-amber-400 shrink-0 mt-0.5" />
                      <span className="text-sm text-slate-300">{p}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {result.data_source === 'AI Estimated' && (
              <div className="glass rounded-2xl p-4 border border-amber-500/20">
                <p className="text-xs text-amber-400 flex items-center gap-2">
                  <Cpu className="w-4 h-4" />
                  Rezultatele sunt estimate de AI pe baza structurii VIN. Pentru date complete, contacteaza un dealer autorizat.
                </p>
              </div>
            )}
          </motion.div>
        )}
      </div>
    </div>
  )
}
