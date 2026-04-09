import { useState } from 'react'
import { motion } from 'framer-motion'
import { Mic, Loader2, ArrowLeft, AlertCircle, CheckCircle, Volume2 } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, SoundResponse } from '@/lib/api'

export default function SoundTool() {
  const [duration, setDuration] = useState('5')
  const [avgDb, setAvgDb] = useState('55')
  const [peakDb, setPeakDb] = useState('75')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<SoundResponse | null>(null)
  const [error, setError] = useState('')
  const [recording, setRecording] = useState(false)

  const analyze = async () => {
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.analyzeSound(parseFloat(duration), parseFloat(avgDb), parseFloat(peakDb))
      setResult(res)
    } catch (e) {
      setError('Eroare la analiza sunet.')
    }
    setLoading(false)
  }

  const simulateRecord = () => {
    setRecording(true)
    const d = parseFloat(duration) * 1000
    setAvgDb(String(Math.round(45 + Math.random() * 25)))
    setPeakDb(String(Math.round(65 + Math.random() * 30)))
    setTimeout(() => { setRecording(false); analyze() }, Math.min(d, 5000))
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-teal-500 to-emerald-600 flex items-center justify-center"><Mic className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Analiza Sunet Motor</h1>
              <p className="text-xs text-slate-500">Detecteaza anomalii sonore</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8 text-center">
          <div className={`w-24 h-24 rounded-full mx-auto mb-6 flex items-center justify-center transition-all duration-300 ${recording ? 'bg-red-500/20 border-2 border-red-500 animate-pulse scale-110' : 'bg-gradient-to-br from-teal-500/20 to-emerald-600/20 border border-white/10'}`}>
            {recording ? <Volume2 className="w-10 h-10 text-red-400 animate-pulse" /> : <Mic className="w-10 h-10 text-teal-400" />}
          </div>
          <h2 className="text-lg font-bold text-white mb-2">{recording ? 'Inregistrez...' : 'Apasa pentru a inregistra'}</h2>
          <p className="text-sm text-slate-400 mb-6">{recording ? 'Tine telefonul aproape de motor' : 'Sau seteaza parametrii manual mai jos'}</p>

          <button onClick={simulateRecord} disabled={loading || recording} className="btn-primary px-8 py-4 text-base flex items-center justify-center gap-2 mx-auto disabled:opacity-50 mb-6">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : recording ? <Volume2 className="w-5 h-5 animate-pulse" /> : <Mic className="w-5 h-5" />}
            {loading ? 'Analizez...' : recording ? 'Inregistrez...' : 'Inregistreaza & Analizeaza'}
          </button>

          <div className="grid grid-cols-3 gap-3">
            <div>
              <label className="text-xs text-slate-500 block mb-1">Durata (s)</label>
              <input value={duration} onChange={e => setDuration(e.target.value)} type="number" className="w-full bg-white/5 border border-white/10 rounded-xl px-3 py-2 text-sm text-white text-center focus:border-cyan-500/50 focus:outline-none" />
            </div>
            <div>
              <label className="text-xs text-slate-500 block mb-1">Avg dB</label>
              <input value={avgDb} onChange={e => setAvgDb(e.target.value)} type="number" className="w-full bg-white/5 border border-white/10 rounded-xl px-3 py-2 text-sm text-white text-center focus:border-cyan-500/50 focus:outline-none" />
            </div>
            <div>
              <label className="text-xs text-slate-500 block mb-1">Peak dB</label>
              <input value={peakDb} onChange={e => setPeakDb(e.target.value)} type="number" className="w-full bg-white/5 border border-white/10 rounded-xl px-3 py-2 text-sm text-white text-center focus:border-cyan-500/50 focus:outline-none" />
            </div>
          </div>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center justify-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-8 text-center">
              <span className="text-4xl mb-3 block">{result.status_color === 'green' ? '✅' : result.status_color === 'red' ? '🔴' : '🟡'}</span>
              <h3 className="text-2xl font-black text-white mb-1">{result.overall_status}</h3>
              <p className="text-4xl font-black text-cyan-400 mb-2">{result.confidence_score}%</p>
              <p className="text-sm text-slate-500">scor incredere</p>
            </div>

            {(result.detected_sounds || []).length > 0 && (
              <div className="glass-card rounded-3xl p-8">
                <h4 className="text-sm font-bold text-white mb-4">Sunete Detectate</h4>
                <div className="space-y-3">
                  {(result.detected_sounds || []).map((s, i) => (
                    <div key={i} className="glass rounded-2xl p-4">
                      <div className="flex items-center justify-between mb-2">
                        <span className="font-semibold text-white">{s.name || s.sound_type || 'Sunet'}</span>
                        <span className={`px-2 py-0.5 rounded-full text-xs font-bold ${s.severity === 'high' || s.severity === 'danger' ? 'text-red-400 bg-red-500/10' : s.severity === 'medium' || s.severity === 'warning' ? 'text-amber-400 bg-amber-500/10' : 'text-emerald-400 bg-emerald-500/10'}`}>{s.severity}</span>
                      </div>
                      <p className="text-sm text-slate-400">{s.description}</p>
                      <div className="flex justify-between mt-2 text-xs text-slate-500">
                        <span>Frecventa: {s.frequency || s.frequency_range || 'N/A'}</span>
                        {s.confidence != null && <span>Incredere: {s.confidence}%</span>}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {(result.recommendations || []).length > 0 && (
              <div className="glass-card rounded-3xl p-8">
                <h4 className="text-sm font-bold text-white mb-4">Recomandari</h4>
                <div className="space-y-2">
                  {(result.recommendations || []).map((r, i) => (
                    <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                      <CheckCircle className="w-5 h-5 text-emerald-400 shrink-0 mt-0.5" />
                      <span className="text-sm text-slate-300">{r}</span>
                    </div>
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
