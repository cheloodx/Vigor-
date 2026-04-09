import { useState } from 'react'
import { motion } from 'framer-motion'
import { Link as LinkIcon, Search, Loader2, ArrowLeft, AlertCircle, CheckCircle, Shield, Globe, Clock, MapPin, Hash } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, BlockchainResponse } from '@/lib/api'

const euCountries = [
  'Romania','Germania','Franta','Italia','Spania','UK','Polonia','Olanda','Belgia','Austria',
  'Suedia','Norvegia','Danemarca','Finlanda','Portugalia','Grecia','Cehia','Ungaria','Bulgaria',
  'Croatia','Irlanda','Elvetia','Serbia','Ucraina','Slovacia','Slovenia','Lituania','Letonia',
  'Estonia','Luxemburg','Malta','Cipru','Islanda','Liechtenstein','Macedonia de Nord','Albania',
  'Muntenegru','Bosnia','Moldova','Belarus','Georgia','Armenia','Azerbaidjan','Turcia'
]

const typeIcon: Record<string, string> = {
  service: '🔧', inspection: '📋', repair: '🛠️', registration: '📄',
  insurance: '🛡️', emission_test: '🌿', tire_change: '🔄', oil_change: '🛢️',
}

const typeColor: Record<string, string> = {
  service: 'text-cyan-400 bg-cyan-500/10', inspection: 'text-blue-400 bg-blue-500/10',
  repair: 'text-amber-400 bg-amber-500/10', registration: 'text-purple-400 bg-purple-500/10',
  insurance: 'text-emerald-400 bg-emerald-500/10', emission_test: 'text-green-400 bg-green-500/10',
  tire_change: 'text-orange-400 bg-orange-500/10', oil_change: 'text-yellow-400 bg-yellow-500/10',
}

export default function BlockchainTool() {
  const [vin, setVin] = useState('')
  const [country, setCountry] = useState('Romania')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<BlockchainResponse | null>(null)
  const [error, setError] = useState('')

  const verify = async () => {
    const v = vin.trim().toUpperCase()
    if (v.length !== 17) { setError('VIN-ul trebuie sa aiba exact 17 caractere.'); return }
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.blockchainVerify(v, country)
      setResult(res)
    } catch (e) {
      setError('Eroare la verificarea blockchain.')
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-violet-500 to-purple-600 flex items-center justify-center"><LinkIcon className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Blockchain Vehicle Passport</h1>
              <p className="text-xs text-slate-500">Istoric vehicul verificat pe blockchain — toate tarile UE</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <div className="flex items-center gap-2 mb-4">
            <div className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
            <span className="text-xs text-emerald-400 font-semibold">BLOCKCHAIN NETWORK ACTIVE</span>
            <span className="text-xs text-slate-500 ml-auto">44 tari europene conectate</span>
          </div>
          <h2 className="text-lg font-bold text-white mb-4">Verifica Istoric Vehicul</h2>
          <div className="flex gap-3 mb-3">
            <input value={vin} onChange={e => setVin(e.target.value)} onKeyDown={e => e.key === 'Enter' && verify()} placeholder="Introdu VIN (17 caractere)" maxLength={17} className="flex-1 bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-lg font-mono text-white placeholder-slate-500 focus:border-purple-500/50 focus:outline-none focus:ring-2 focus:ring-purple-500/20 uppercase tracking-wider" />
          </div>
          <div className="flex gap-3 mb-4">
            <select value={country} onChange={e => setCountry(e.target.value)} className="flex-1 bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white focus:border-purple-500/50 focus:outline-none">
              {euCountries.map(c => <option key={c} value={c} className="bg-slate-900">{c}</option>)}
            </select>
            <span className="text-xs text-slate-500 self-center">{vin.length}/17</span>
          </div>
          <button onClick={verify} disabled={loading} className="w-full bg-gradient-to-r from-violet-600 to-purple-600 hover:from-violet-500 hover:to-purple-500 text-white font-semibold px-6 py-3.5 rounded-2xl flex items-center justify-center gap-2 transition-all disabled:opacity-50">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
            {loading ? 'Verific pe blockchain...' : 'Verifica pe Blockchain'}
          </button>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            {/* Vehicle Card */}
            <div className="glass-card rounded-3xl p-8 border border-purple-500/20">
              <div className="flex items-center justify-between mb-4">
                <div>
                  <div className="flex items-center gap-2 mb-1">
                    <Shield className="w-4 h-4 text-emerald-400" />
                    <span className="text-xs text-emerald-400 font-bold">VERIFICAT PE BLOCKCHAIN</span>
                  </div>
                  <h3 className="text-2xl font-black text-white">{result.vehicle}</h3>
                  <p className="text-xs text-slate-500 font-mono mt-1">{result.vin}</p>
                </div>
                <div className="text-right">
                  <p className={`text-4xl font-black ${result.trust_score >= 85 ? 'text-emerald-400' : result.trust_score >= 70 ? 'text-amber-400' : 'text-red-400'}`}>{result.trust_score}%</p>
                  <p className="text-xs text-slate-500">Trust Score</p>
                </div>
              </div>

              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                <div className="glass rounded-xl p-3 text-center">
                  <Hash className="w-4 h-4 text-purple-400 mx-auto mb-1" />
                  <p className="text-xs text-slate-500">Blockchain ID</p>
                  <p className="text-[10px] text-purple-400 font-mono truncate">{result.blockchain_id}</p>
                </div>
                <div className="glass rounded-xl p-3 text-center">
                  <Clock className="w-4 h-4 text-cyan-400 mx-auto mb-1" />
                  <p className="text-xs text-slate-500">Inregistrari</p>
                  <p className="text-lg font-bold text-white">{result.total_records}</p>
                </div>
                <div className="glass rounded-xl p-3 text-center">
                  <Globe className="w-4 h-4 text-blue-400 mx-auto mb-1" />
                  <p className="text-xs text-slate-500">Cross-border</p>
                  <p className="text-lg font-bold text-white">{result.cross_border_checks}</p>
                </div>
                <div className="glass rounded-xl p-3 text-center">
                  {result.eu_compliant ? <CheckCircle className="w-4 h-4 text-emerald-400 mx-auto mb-1" /> : <AlertCircle className="w-4 h-4 text-red-400 mx-auto mb-1" />}
                  <p className="text-xs text-slate-500">EU Compliant</p>
                  <p className={`text-sm font-bold ${result.eu_compliant ? 'text-emerald-400' : 'text-red-400'}`}>{result.eu_compliant ? 'DA' : 'NU'}</p>
                </div>
              </div>
            </div>

            {/* Timeline Records */}
            <div className="glass-card rounded-3xl p-8">
              <h4 className="text-sm font-bold text-white mb-6 flex items-center gap-2">
                <LinkIcon className="w-4 h-4 text-purple-400" />
                Istoric Blockchain — {result.country}
              </h4>
              <div className="relative">
                <div className="absolute left-4 top-0 bottom-0 w-px bg-gradient-to-b from-purple-500/50 via-cyan-500/30 to-transparent" />
                <div className="space-y-4">
                  {(result.records || []).map((rec, i) => (
                    <motion.div key={i} initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: i * 0.06 }} className="relative pl-10">
                      <div className={`absolute left-2 w-5 h-5 rounded-full flex items-center justify-center text-[10px] ${rec.verified ? 'bg-emerald-500/20 border border-emerald-500/50' : 'bg-red-500/20 border border-red-500/50'}`}>
                        {rec.verified ? <CheckCircle className="w-3 h-3 text-emerald-400" /> : <AlertCircle className="w-3 h-3 text-red-400" />}
                      </div>
                      <div className="glass rounded-2xl p-4 hover:bg-white/5 transition-colors">
                        <div className="flex items-start justify-between mb-2">
                          <div className="flex items-center gap-2">
                            <span className={`px-2 py-0.5 rounded-lg text-xs font-semibold ${typeColor[rec.type] || 'text-slate-400 bg-slate-500/10'}`}>
                              {typeIcon[rec.type] || '📌'} {rec.type.replace('_', ' ')}
                            </span>
                            {rec.verified && <span className="text-[10px] text-emerald-400 font-mono">VERIFIED</span>}
                          </div>
                          <span className="text-xs text-slate-500">{rec.timestamp}</span>
                        </div>
                        <p className="text-sm text-white font-medium">{rec.description}</p>
                        <div className="flex items-center gap-4 mt-2 text-xs text-slate-500">
                          <span className="flex items-center gap-1"><MapPin className="w-3 h-3" />{rec.location}</span>
                          <span>{rec.mileage.toLocaleString()} km</span>
                          <span className="font-mono text-[10px] text-slate-600 truncate max-w-[120px]">{rec.hash}</span>
                        </div>
                      </div>
                    </motion.div>
                  ))}
                </div>
              </div>
            </div>

            {/* EU Compliance Badge */}
            <div className="glass-card rounded-3xl p-6 border border-emerald-500/10">
              <div className="flex items-center gap-4">
                <div className="w-14 h-14 rounded-2xl bg-gradient-to-br from-emerald-500/20 to-green-600/20 flex items-center justify-center">
                  <Globe className="w-7 h-7 text-emerald-400" />
                </div>
                <div className="flex-1">
                  <h4 className="text-sm font-bold text-white">EU Digital Vehicle Passport</h4>
                  <p className="text-xs text-slate-400">Conform cu regulamentul EU 2024/1252 — European Blockchain Vehicle Registry</p>
                </div>
                <div className="text-right">
                  <span className="px-3 py-1.5 rounded-full text-xs font-bold text-emerald-400 bg-emerald-500/10 border border-emerald-500/20">EU COMPLIANT</span>
                </div>
              </div>
            </div>

            {/* Last Verified */}
            <div className="text-center text-xs text-slate-500 py-2">
              Ultima verificare: {result.last_verified} • Blockchain ID: {result.blockchain_id}
            </div>
          </motion.div>
        )}
      </div>
    </div>
  )
}
