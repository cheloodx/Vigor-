#!/usr/bin/env python3
"""Generate all functional tool pages for AutoDiag Pro website."""
import os

BASE = "/home/ubuntu/autodiag-pro-website/src"

def w(path, content):
    full = os.path.join(BASE, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, 'w') as f:
        f.write(content)
    print(f"  wrote {path}")

# ============================================================
# lib/api.ts — API client
# ============================================================
w("lib/api.ts", r'''const API = 'https://agenticmax.co.uk/autodiag'

async function post<T>(path: string, body: Record<string, unknown>): Promise<T> {
  const res = await fetch(`${API}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`API error ${res.status}: ${err}`)
  }
  return res.json()
}

export interface ChatResponse { response: string; context_used: boolean }
export interface DTCResponse { code: string; description: string; severity: string; system: string; possible_causes: string[]; solutions: string[]; estimated_cost: string }
export interface VINResponse { vin: string; make: string; model: string; year: number; engine_type: string; engine_capacity: string; fuel_type: string; transmission: string; body_type: string; drive_type: string; country_of_origin: string; manufacturer: string; plant: string; common_problems: string[]; recall_count: number }
export interface ScanResponse { diagnosis: string; confidence: number; severity: string; affected_system: string; possible_causes: string[]; recommendations: string[]; estimated_cost: string }
export interface PredictionItem { component_name: string; icon: string; probability: number; risk_level: string; timeframe: string; description: string; estimated_cost: number; prevention_tip: string }
export interface PredictionResponse { vehicle: string; mileage: number; predictions: PredictionItem[]; risk_summary: Record<string, number> }
export interface DetectedSound { sound_type: string; severity: string; frequency_range: string; description: string; confidence: number }
export interface SoundResponse { overall_status: string; confidence_score: number; status_icon: string; status_color: string; detected_sounds: DetectedSound[]; recommendations: string[] }
export interface RecallItem { title: string; description: string; date: string; severity: string; affected_parts: string; status: string }
export interface RecallResponse { vehicle: string; total_recalls: number; active_recalls: number; recalls: RecallItem[] }
export interface InsightItem { category: string; title: string; detail: string; icon: string }
export interface InsightsResponse { brand: string; country: string; fiabilitate: number; popularitate: number; cost_mediu: number; currency: string; insights: InsightItem[] }

export const api = {
  chat: (message: string, make?: string, model?: string) =>
    post<ChatResponse>('/chat/message', { message, vehicle_make: make || '', vehicle_model: model || '' }),

  decodeDTC: (code: string) =>
    post<DTCResponse>('/dtc/decode', { code }),

  decodeVIN: (vin: string) =>
    post<VINResponse>('/vin/decode', { vin }),

  scanImage: (desc: string, make?: string, model?: string, symptom?: string) =>
    post<ScanResponse>('/scan/analyze', { image_description: desc, vehicle_make: make || '', vehicle_model: model || '', symptom: symptom || '' }),

  predict: (make: string, model: string, year: number, mileage: number, fuel?: string) =>
    post<PredictionResponse>('/predictions/failure', { make, model, year, mileage, fuel_type: fuel || 'Diesel' }),

  analyzeSound: (duration?: number, avgDb?: number, peakDb?: number) =>
    post<SoundResponse>('/sound/analyze', { duration: duration || 5, avg_db: avgDb || 55, peak_db: peakDb || 75, frequencies: [] }),

  checkRecalls: (make: string, model?: string, year?: number) =>
    post<RecallResponse>('/recalls/check', { make, model: model || '', year: year || 0 }),

  europeanInsights: (brand: string, country?: string) =>
    post<InsightsResponse>('/ai/european-insights', { brand, country: country || 'Romania' }),
}
''')

# ============================================================
# pages/tools/ToolsHub.tsx — Main tools dashboard
# ============================================================
w("pages/tools/ToolsHub.tsx", r'''import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Brain, Camera, AlertTriangle, Car, Gauge, Mic, Globe, Shield, ArrowRight } from 'lucide-react'

const tools = [
  { icon: Brain, title: 'Mecanic AI', desc: 'Chat cu mecanicul AI — intreaba orice despre masina ta.', to: '/tools/chat', color: 'from-cyan-500 to-blue-600', live: true },
  { icon: Camera, title: 'Foto Diagnostic', desc: 'Descrie problema vizuala si primesti diagnostic AI instant.', to: '/tools/scan', color: 'from-purple-500 to-pink-600', live: true },
  { icon: AlertTriangle, title: 'Decodor DTC', desc: 'Introdu codul de eroare OBD2 si afla cauza si solutia.', to: '/tools/dtc', color: 'from-amber-500 to-orange-600', live: true },
  { icon: Car, title: 'VIN Decoder', desc: 'Decodifica seria de sasiu si afla specificatii complete.', to: '/tools/vin', color: 'from-blue-500 to-indigo-600', live: true },
  { icon: Gauge, title: 'Predictor AI', desc: 'Afla ce componente se pot strica in urmatoarele luni.', to: '/tools/predictor', color: 'from-red-500 to-rose-600', live: true },
  { icon: Mic, title: 'Analiza Sunet', desc: 'Analizeaza sunetul motorului si detecteaza anomalii.', to: '/tools/sound', color: 'from-teal-500 to-emerald-600', live: true },
  { icon: Globe, title: 'AI European', desc: 'Insights si statistici per marca si tara europeana.', to: '/tools/european', color: 'from-emerald-500 to-green-600', live: true },
  { icon: Shield, title: 'Recall Check', desc: 'Verifica campaniile de rechemare active.', to: '/tools/recalls', color: 'from-red-500 to-rose-600', live: true },
]

export default function ToolsHub() {
  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="absolute inset-0 grid-bg pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-emerald-400 tracking-widest uppercase">Live & Functional</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-4">
            Unelte <span className="gradient-text-static">AI Live</span>
          </h1>
          <p className="text-lg text-slate-400 max-w-2xl mx-auto">Toate functiile AutoDiag Pro — functionale in timp real, conectate la backend-ul AI.</p>
        </div>
      </section>

      <section className="pb-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-5">
            {tools.map((t, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.06 }}
              >
                <Link to={t.to} className="block glass-card rounded-3xl p-6 h-full group relative overflow-hidden">
                  <div className="absolute top-3 right-3 flex items-center gap-1.5">
                    <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" />
                    <span className="text-[10px] text-emerald-400 font-semibold uppercase tracking-wider">Live</span>
                  </div>
                  <div className={`w-14 h-14 rounded-2xl bg-gradient-to-br ${t.color} flex items-center justify-center mb-5 group-hover:scale-110 transition-transform`}>
                    <t.icon className="w-7 h-7 text-white" />
                  </div>
                  <h3 className="text-lg font-bold text-white mb-2 group-hover:text-cyan-400 transition-colors">{t.title}</h3>
                  <p className="text-sm text-slate-400 leading-relaxed mb-4">{t.desc}</p>
                  <span className="inline-flex items-center gap-1 text-xs font-semibold text-cyan-400 group-hover:gap-2 transition-all">
                    Deschide <ArrowRight className="w-3 h-3" />
                  </span>
                </Link>
              </motion.div>
            ))}
          </div>
        </div>
      </section>
    </>
  )
}
''')

# ============================================================
# pages/tools/ChatTool.tsx — Mechanic AI Chat
# ============================================================
w("pages/tools/ChatTool.tsx", r'''import { useState, useRef, useEffect } from 'react'
import { motion } from 'framer-motion'
import { Send, Bot, User, Loader2, Sparkles, ArrowLeft } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

interface Msg { role: 'user' | 'ai'; text: string }

export default function ChatTool() {
  const [msgs, setMsgs] = useState<Msg[]>([{ role: 'ai', text: 'Salut! Sunt mecanicul tau AI. Intreaba-ma orice despre masina ta — probleme, intretinere, costuri, piese. Sunt aici sa te ajut!' }])
  const [input, setInput] = useState('')
  const [loading, setLoading] = useState(false)
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const endRef = useRef<HTMLDivElement>(null)

  useEffect(() => { endRef.current?.scrollIntoView({ behavior: 'smooth' }) }, [msgs])

  const send = async () => {
    if (!input.trim() || loading) return
    const userMsg = input.trim()
    setInput('')
    setMsgs(p => [...p, { role: 'user', text: userMsg }])
    setLoading(true)
    try {
      const res = await api.chat(userMsg, make, model)
      setMsgs(p => [...p, { role: 'ai', text: res.response }])
    } catch (e) {
      setMsgs(p => [...p, { role: 'ai', text: 'Eroare la server. Incearca din nou.' }])
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-6">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center"><Bot className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Mecanic AI Pro</h1>
              <div className="flex items-center gap-1.5"><div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" /><span className="text-xs text-emerald-400">Online</span></div>
            </div>
          </div>
        </div>

        <div className="flex gap-3 mb-4">
          <input placeholder="Marca (ex: BMW)" value={make} onChange={e => setMake(e.target.value)} className="flex-1 bg-white/5 border border-white/10 rounded-xl px-3 py-2 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
          <input placeholder="Model (ex: 320d)" value={model} onChange={e => setModel(e.target.value)} className="flex-1 bg-white/5 border border-white/10 rounded-xl px-3 py-2 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
        </div>

        <div className="glass-bright rounded-3xl overflow-hidden glow-cyan" style={{ height: 'calc(100vh - 300px)', minHeight: 400 }}>
          <div className="h-full flex flex-col">
            <div className="flex-1 overflow-y-auto p-6 space-y-4">
              {msgs.map((m, i) => (
                <motion.div key={i} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className={`flex gap-3 ${m.role === 'user' ? 'flex-row-reverse' : ''}`}>
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center shrink-0 ${m.role === 'ai' ? 'bg-gradient-to-br from-cyan-500/20 to-blue-600/20' : 'bg-gradient-to-br from-purple-500/20 to-pink-600/20'}`}>
                    {m.role === 'ai' ? <Sparkles className="w-4 h-4 text-cyan-400" /> : <User className="w-4 h-4 text-purple-400" />}
                  </div>
                  <div className={`max-w-[80%] rounded-2xl px-4 py-3 text-sm leading-relaxed ${m.role === 'ai' ? 'glass text-slate-300' : 'bg-cyan-500/10 border border-cyan-500/20 text-white'}`}>
                    {m.text.split('\n').map((line, j) => <p key={j} className={j > 0 ? 'mt-2' : ''}>{line}</p>)}
                  </div>
                </motion.div>
              ))}
              {loading && (
                <div className="flex gap-3">
                  <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-cyan-500/20 to-blue-600/20 flex items-center justify-center"><Sparkles className="w-4 h-4 text-cyan-400" /></div>
                  <div className="glass rounded-2xl px-4 py-3"><Loader2 className="w-5 h-5 text-cyan-400 animate-spin" /></div>
                </div>
              )}
              <div ref={endRef} />
            </div>
            <div className="p-4 border-t border-white/5">
              <form onSubmit={e => { e.preventDefault(); send() }} className="flex gap-3">
                <input
                  value={input} onChange={e => setInput(e.target.value)}
                  placeholder="Intreaba mecanicul AI..."
                  className="flex-1 bg-white/5 border border-white/10 rounded-2xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20"
                />
                <button type="submit" disabled={loading || !input.trim()} className="btn-primary px-5 py-3 flex items-center gap-2 disabled:opacity-50">
                  <Send className="w-4 h-4" />
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
''')

# ============================================================
# pages/tools/DTCTool.tsx — DTC Decoder
# ============================================================
w("pages/tools/DTCTool.tsx", r'''import { useState } from 'react'
import { motion } from 'framer-motion'
import { AlertTriangle, Search, Loader2, ArrowLeft, AlertCircle, CheckCircle, Wrench, DollarSign } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, DTCResponse } from '@/lib/api'

export default function DTCTool() {
  const [code, setCode] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<DTCResponse | null>(null)
  const [error, setError] = useState('')

  const decode = async () => {
    if (!code.trim()) return
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.decodeDTC(code.trim().toUpperCase())
      setResult(res)
    } catch (e) {
      setError('Cod invalid sau eroare server. Verifica formatul (ex: P0300).')
    }
    setLoading(false)
  }

  const severityColor = (s: string) => {
    if (s.toLowerCase().includes('high') || s.toLowerCase().includes('critic')) return 'text-red-400 bg-red-500/10 border-red-500/20'
    if (s.toLowerCase().includes('medium') || s.toLowerCase().includes('moderat')) return 'text-amber-400 bg-amber-500/10 border-amber-500/20'
    return 'text-emerald-400 bg-emerald-500/10 border-emerald-500/20'
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-500 to-orange-600 flex items-center justify-center"><AlertTriangle className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Decodor DTC</h1>
              <p className="text-xs text-slate-500">Decodifica coduri eroare OBD2</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Introdu codul de eroare</h2>
          <div className="flex gap-3">
            <input value={code} onChange={e => setCode(e.target.value)} onKeyDown={e => e.key === 'Enter' && decode()} placeholder="Ex: P0300, P0171, B1234..." className="flex-1 bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-lg font-mono text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 uppercase" />
            <button onClick={decode} disabled={loading || !code.trim()} className="btn-primary px-6 py-3.5 flex items-center gap-2 disabled:opacity-50">
              {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
              <span className="hidden sm:inline">Decodifica</span>
            </button>
          </div>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-8">
              <div className="flex items-start justify-between mb-4">
                <div>
                  <span className="text-sm text-cyan-400 font-mono font-bold">{result.code}</span>
                  <h3 className="text-xl font-bold text-white mt-1">{result.description}</h3>
                </div>
                <span className={`px-3 py-1 rounded-full text-xs font-bold border ${severityColor(result.severity)}`}>{result.severity}</span>
              </div>
              <div className="glass rounded-2xl px-4 py-3 mb-4">
                <span className="text-xs text-slate-500 font-medium">Sistem afectat</span>
                <p className="text-sm text-white font-semibold">{result.system}</p>
              </div>
            </div>

            <div className="glass-card rounded-3xl p-8">
              <h4 className="text-sm font-bold text-white mb-4 flex items-center gap-2"><AlertCircle className="w-4 h-4 text-amber-400" />Cauze Posibile</h4>
              <div className="space-y-2">
                {result.possible_causes.map((c, i) => (
                  <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                    <span className="w-6 h-6 rounded-full bg-amber-500/10 flex items-center justify-center text-xs font-bold text-amber-400 shrink-0">{i+1}</span>
                    <span className="text-sm text-slate-300">{c}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="glass-card rounded-3xl p-8">
              <h4 className="text-sm font-bold text-white mb-4 flex items-center gap-2"><Wrench className="w-4 h-4 text-emerald-400" />Solutii Recomandate</h4>
              <div className="space-y-2">
                {result.solutions.map((s, i) => (
                  <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                    <CheckCircle className="w-5 h-5 text-emerald-400 shrink-0 mt-0.5" />
                    <span className="text-sm text-slate-300">{s}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="glass-card rounded-3xl p-6 flex items-center gap-4">
              <DollarSign className="w-8 h-8 text-emerald-400" />
              <div>
                <span className="text-xs text-slate-500">Cost estimat reparatie</span>
                <p className="text-xl font-black text-white">{result.estimated_cost}</p>
              </div>
            </div>
          </motion.div>
        )}
      </div>
    </div>
  )
}
''')

# ============================================================
# pages/tools/VINTool.tsx — VIN Decoder
# ============================================================
w("pages/tools/VINTool.tsx", r'''import { useState } from 'react'
import { motion } from 'framer-motion'
import { Car, Search, Loader2, ArrowLeft, AlertCircle, MapPin, Fuel, Settings, Shield } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, VINResponse } from '@/lib/api'

export default function VINTool() {
  const [vin, setVin] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<VINResponse | null>(null)
  const [error, setError] = useState('')

  const decode = async () => {
    const v = vin.trim().toUpperCase()
    if (v.length !== 17) { setError('VIN-ul trebuie sa aiba exact 17 caractere.'); return }
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.decodeVIN(v)
      setResult(res)
    } catch (e) {
      setError('VIN invalid sau eroare server.')
    }
    setLoading(false)
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
              <p className="text-xs text-slate-500">Decodifica seria de sasiu</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Introdu VIN-ul (17 caractere)</h2>
          <div className="flex gap-3">
            <input value={vin} onChange={e => setVin(e.target.value)} onKeyDown={e => e.key === 'Enter' && decode()} placeholder="Ex: WBAPH5C55BA286736" maxLength={17} className="flex-1 bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-lg font-mono text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 uppercase tracking-wider" />
            <button onClick={decode} disabled={loading} className="btn-primary px-6 py-3.5 flex items-center gap-2 disabled:opacity-50">
              {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
              <span className="hidden sm:inline">Decodifica</span>
            </button>
          </div>
          <p className="mt-2 text-xs text-slate-500">{vin.length}/17 caractere</p>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-8">
              <div className="text-center mb-6">
                <p className="text-xs text-cyan-400 font-mono mb-1">{result.vin}</p>
                <h3 className="text-3xl font-black text-white">{result.make} {result.model}</h3>
                <p className="text-lg text-slate-400">An fabricatie: {result.year}</p>
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
                    <p className="text-sm font-semibold text-white">{s.val}</p>
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

            {result.common_problems.length > 0 && (
              <div className="glass-card rounded-3xl p-8">
                <h4 className="text-sm font-bold text-white mb-4">Probleme Frecvente</h4>
                <div className="space-y-2">
                  {result.common_problems.map((p, i) => (
                    <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                      <AlertCircle className="w-4 h-4 text-amber-400 shrink-0 mt-0.5" />
                      <span className="text-sm text-slate-300">{p}</span>
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
''')

# ============================================================
# pages/tools/ScanTool.tsx — Foto Diagnostic
# ============================================================
w("pages/tools/ScanTool.tsx", r'''import { useState } from 'react'
import { motion } from 'framer-motion'
import { Camera, Search, Loader2, ArrowLeft, AlertCircle, CheckCircle, Wrench, DollarSign, Gauge } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, ScanResponse } from '@/lib/api'

export default function ScanTool() {
  const [desc, setDesc] = useState('')
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [symptom, setSymptom] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<ScanResponse | null>(null)
  const [error, setError] = useState('')

  const analyze = async () => {
    if (!desc.trim() && !symptom.trim()) { setError('Descrie problema vizuala sau simptomul.'); return }
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.scanImage(desc, make, model, symptom)
      setResult(res)
    } catch (e) {
      setError('Eroare la analiza. Incearca din nou.')
    }
    setLoading(false)
  }

  const sevColor = (s: string) => {
    const sl = s.toLowerCase()
    if (sl.includes('high') || sl.includes('critic') || sl.includes('sever')) return 'text-red-400'
    if (sl.includes('medium') || sl.includes('moder')) return 'text-amber-400'
    return 'text-emerald-400'
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-500 to-pink-600 flex items-center justify-center"><Camera className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Foto Diagnostic AI</h1>
              <p className="text-xs text-slate-500">Descrie problema si primesti diagnostic</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Descrie ce vezi</h2>
          <textarea value={desc} onChange={e => setDesc(e.target.value)} rows={3} placeholder="Ex: Pata de ulei sub motor, culoare maro inchis, pe partea stanga..." className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 resize-none mb-4" />
          <div className="grid grid-cols-3 gap-3 mb-4">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca" className="bg-white/5 border border-white/10 rounded-xl px-3 py-2.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model" className="bg-white/5 border border-white/10 rounded-xl px-3 py-2.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={symptom} onChange={e => setSymptom(e.target.value)} placeholder="Simptom" className="bg-white/5 border border-white/10 rounded-xl px-3 py-2.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
          </div>
          <button onClick={analyze} disabled={loading} className="btn-primary w-full px-6 py-3.5 flex items-center justify-center gap-2 disabled:opacity-50">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
            Analizeaza cu AI
          </button>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-8">
              <div className="flex items-center gap-4 mb-4">
                <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-cyan-500/20 to-blue-600/20 flex items-center justify-center">
                  <Gauge className="w-8 h-8 text-cyan-400" />
                </div>
                <div className="flex-1">
                  <h3 className="text-xl font-bold text-white">{result.diagnosis}</h3>
                  <p className="text-sm text-slate-400">Sistem: {result.affected_system}</p>
                </div>
                <div className="text-right">
                  <p className="text-3xl font-black text-cyan-400">{result.confidence}%</p>
                  <p className="text-xs text-slate-500">incredere</p>
                </div>
              </div>
              <div className="flex gap-3">
                <span className={`px-3 py-1 rounded-full text-xs font-bold ${sevColor(result.severity)} bg-white/5 border border-white/5`}>Severitate: {result.severity}</span>
              </div>
            </div>

            <div className="glass-card rounded-3xl p-8">
              <h4 className="text-sm font-bold text-white mb-4 flex items-center gap-2"><AlertCircle className="w-4 h-4 text-amber-400" />Cauze Posibile</h4>
              <div className="space-y-2">
                {result.possible_causes.map((c, i) => (
                  <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                    <span className="w-6 h-6 rounded-full bg-amber-500/10 flex items-center justify-center text-xs font-bold text-amber-400 shrink-0">{i+1}</span>
                    <span className="text-sm text-slate-300">{c}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="glass-card rounded-3xl p-8">
              <h4 className="text-sm font-bold text-white mb-4 flex items-center gap-2"><Wrench className="w-4 h-4 text-emerald-400" />Recomandari</h4>
              <div className="space-y-2">
                {result.recommendations.map((r, i) => (
                  <div key={i} className="flex items-start gap-3 glass rounded-xl p-3">
                    <CheckCircle className="w-5 h-5 text-emerald-400 shrink-0 mt-0.5" />
                    <span className="text-sm text-slate-300">{r}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="glass-card rounded-3xl p-6 flex items-center gap-4">
              <DollarSign className="w-8 h-8 text-emerald-400" />
              <div>
                <span className="text-xs text-slate-500">Cost estimat reparatie</span>
                <p className="text-xl font-black text-white">{result.estimated_cost}</p>
              </div>
            </div>
          </motion.div>
        )}
      </div>
    </div>
  )
}
''')

# ============================================================
# pages/tools/PredictorTool.tsx
# ============================================================
w("pages/tools/PredictorTool.tsx", r'''import { useState } from 'react'
import { motion } from 'framer-motion'
import { Gauge, Search, Loader2, ArrowLeft, AlertCircle, Shield } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, PredictionResponse } from '@/lib/api'

export default function PredictorTool() {
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [year, setYear] = useState('')
  const [mileage, setMileage] = useState('')
  const [fuel, setFuel] = useState('Diesel')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<PredictionResponse | null>(null)
  const [error, setError] = useState('')

  const predict = async () => {
    if (!make || !model || !year || !mileage) { setError('Completeaza toate campurile.'); return }
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.predict(make, model, parseInt(year), parseInt(mileage), fuel)
      setResult(res)
    } catch (e) {
      setError('Eroare la predictie. Verifica datele.')
    }
    setLoading(false)
  }

  const riskColor = (r: string) => {
    if (r === 'high') return 'text-red-400 bg-red-500/10 border-red-500/20'
    if (r === 'medium') return 'text-amber-400 bg-amber-500/10 border-amber-500/20'
    return 'text-emerald-400 bg-emerald-500/10 border-emerald-500/20'
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-red-500 to-rose-600 flex items-center justify-center"><Gauge className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Predictor AI</h1>
              <p className="text-xs text-slate-500">Predictii defectiuni viitoare</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Detalii vehicul</h2>
          <div className="grid grid-cols-2 gap-3 mb-3">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca (BMW, VW...)" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model (320d, Golf...)" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
          </div>
          <div className="grid grid-cols-3 gap-3 mb-4">
            <input value={year} onChange={e => setYear(e.target.value)} type="number" placeholder="An (2019)" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={mileage} onChange={e => setMileage(e.target.value)} type="number" placeholder="Km (150000)" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <select value={fuel} onChange={e => setFuel(e.target.value)} className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white focus:border-cyan-500/50 focus:outline-none">
              <option value="Diesel" className="bg-slate-900">Diesel</option>
              <option value="Benzina" className="bg-slate-900">Benzina</option>
              <option value="Hybrid" className="bg-slate-900">Hybrid</option>
              <option value="Electric" className="bg-slate-900">Electric</option>
            </select>
          </div>
          <button onClick={predict} disabled={loading} className="btn-primary w-full px-6 py-3.5 flex items-center justify-center gap-2 disabled:opacity-50">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Gauge className="w-5 h-5" />}
            Genereaza Predictii
          </button>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-6">
              <h3 className="text-lg font-bold text-white mb-1">{result.vehicle}</h3>
              <p className="text-sm text-slate-500">{result.mileage.toLocaleString()} km</p>
              {result.risk_summary && (
                <div className="flex gap-4 mt-4">
                  {Object.entries(result.risk_summary).map(([k, v]) => (
                    <div key={k} className="flex items-center gap-2">
                      <span className={`w-3 h-3 rounded-full ${k === 'high' ? 'bg-red-500' : k === 'medium' ? 'bg-amber-500' : 'bg-emerald-500'}`} />
                      <span className="text-xs text-slate-400 capitalize">{k}: <strong className="text-white">{v}</strong></span>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {result.predictions.map((p, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.08 }} className="glass-card rounded-3xl p-6">
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-3">
                    <span className="text-2xl">{p.icon}</span>
                    <div>
                      <h4 className="font-bold text-white">{p.component_name}</h4>
                      <p className="text-xs text-slate-500">{p.timeframe}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <span className={`px-3 py-1 rounded-full text-xs font-bold border ${riskColor(p.risk_level)}`}>{p.probability}%</span>
                  </div>
                </div>
                <p className="text-sm text-slate-400 mb-3">{p.description}</p>
                <div className="flex items-center justify-between glass rounded-xl p-3">
                  <div className="flex items-center gap-2"><Shield className="w-4 h-4 text-cyan-400" /><span className="text-xs text-slate-400">{p.prevention_tip}</span></div>
                  <span className="text-sm font-bold text-emerald-400">~{p.estimated_cost} EUR</span>
                </div>
              </motion.div>
            ))}
          </motion.div>
        )}
      </div>
    </div>
  )
}
''')

# ============================================================
# pages/tools/SoundTool.tsx
# ============================================================
w("pages/tools/SoundTool.tsx", r'''import { useState } from 'react'
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
              <span className="text-4xl mb-3 block">{result.status_icon}</span>
              <h3 className="text-2xl font-black text-white mb-1">{result.overall_status}</h3>
              <p className="text-4xl font-black text-cyan-400 mb-2">{result.confidence_score}%</p>
              <p className="text-sm text-slate-500">scor incredere</p>
            </div>

            {result.detected_sounds.length > 0 && (
              <div className="glass-card rounded-3xl p-8">
                <h4 className="text-sm font-bold text-white mb-4">Sunete Detectate</h4>
                <div className="space-y-3">
                  {result.detected_sounds.map((s, i) => (
                    <div key={i} className="glass rounded-2xl p-4">
                      <div className="flex items-center justify-between mb-2">
                        <span className="font-semibold text-white">{s.sound_type}</span>
                        <span className={`px-2 py-0.5 rounded-full text-xs font-bold ${s.severity === 'high' ? 'text-red-400 bg-red-500/10' : s.severity === 'medium' ? 'text-amber-400 bg-amber-500/10' : 'text-emerald-400 bg-emerald-500/10'}`}>{s.severity}</span>
                      </div>
                      <p className="text-sm text-slate-400">{s.description}</p>
                      <div className="flex justify-between mt-2 text-xs text-slate-500">
                        <span>Frecventa: {s.frequency_range}</span>
                        <span>Incredere: {s.confidence}%</span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {result.recommendations.length > 0 && (
              <div className="glass-card rounded-3xl p-8">
                <h4 className="text-sm font-bold text-white mb-4">Recomandari</h4>
                <div className="space-y-2">
                  {result.recommendations.map((r, i) => (
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
''')

# ============================================================
# pages/tools/EuropeanTool.tsx
# ============================================================
w("pages/tools/EuropeanTool.tsx", r'''import { useState } from 'react'
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

            {result.insights.length > 0 && (
              <div className="glass-card rounded-3xl p-8">
                <h4 className="text-sm font-bold text-white mb-4">Insights AI</h4>
                <div className="space-y-3">
                  {result.insights.map((ins, i) => (
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
''')

# ============================================================
# pages/tools/RecallTool.tsx
# ============================================================
w("pages/tools/RecallTool.tsx", r'''import { useState } from 'react'
import { motion } from 'framer-motion'
import { Shield, Search, Loader2, ArrowLeft, AlertCircle, AlertTriangle, CheckCircle } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api, RecallResponse } from '@/lib/api'

export default function RecallTool() {
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [year, setYear] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState<RecallResponse | null>(null)
  const [error, setError] = useState('')

  const check = async () => {
    if (!make) { setError('Introdu cel putin marca.'); return }
    setLoading(true); setError(''); setResult(null)
    try {
      const res = await api.checkRecalls(make, model, year ? parseInt(year) : undefined)
      setResult(res)
    } catch (e) {
      setError('Eroare la verificare.')
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-red-500 to-rose-600 flex items-center justify-center"><Shield className="w-5 h-5 text-white" /></div>
            <div>
              <h1 className="text-xl font-bold text-white">Recall Check</h1>
              <p className="text-xs text-slate-500">Verifica campaniile de rechemare</p>
            </div>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-8 glow-cyan mb-8">
          <h2 className="text-lg font-bold text-white mb-4">Detalii vehicul</h2>
          <div className="grid grid-cols-3 gap-3 mb-4">
            <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca *" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
            <input value={year} onChange={e => setYear(e.target.value)} type="number" placeholder="An" className="bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none" />
          </div>
          <button onClick={check} disabled={loading} className="btn-primary w-full px-6 py-3.5 flex items-center justify-center gap-2 disabled:opacity-50">
            {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Search className="w-5 h-5" />}
            Verifica Recall-uri
          </button>
          {error && <p className="mt-3 text-sm text-red-400 flex items-center gap-2"><AlertCircle className="w-4 h-4" />{error}</p>}
        </div>

        {result && (
          <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="space-y-4">
            <div className="glass-card rounded-3xl p-8 text-center">
              <h3 className="text-lg font-bold text-white mb-4">{result.vehicle}</h3>
              <div className="grid grid-cols-2 gap-4">
                <div className="glass rounded-2xl p-4">
                  <p className="text-3xl font-black text-white">{result.total_recalls}</p>
                  <p className="text-xs text-slate-500">Total rechemari</p>
                </div>
                <div className="glass rounded-2xl p-4">
                  <p className={`text-3xl font-black ${result.active_recalls > 0 ? 'text-red-400' : 'text-emerald-400'}`}>{result.active_recalls}</p>
                  <p className="text-xs text-slate-500">Active acum</p>
                </div>
              </div>
            </div>

            {result.recalls.map((r, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.08 }} className="glass-card rounded-3xl p-6">
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-2">
                    {r.status === 'active' ? <AlertTriangle className="w-5 h-5 text-red-400" /> : <CheckCircle className="w-5 h-5 text-emerald-400" />}
                    <h4 className="font-bold text-white">{r.title}</h4>
                  </div>
                  <span className={`px-2 py-0.5 rounded-full text-xs font-bold ${r.status === 'active' ? 'text-red-400 bg-red-500/10' : 'text-emerald-400 bg-emerald-500/10'}`}>{r.status}</span>
                </div>
                <p className="text-sm text-slate-400 mb-3">{r.description}</p>
                <div className="flex gap-4 text-xs text-slate-500">
                  <span>Data: {r.date}</span>
                  <span>Severitate: {r.severity}</span>
                  <span>Piese: {r.affected_parts}</span>
                </div>
              </motion.div>
            ))}
          </motion.div>
        )}
      </div>
    </div>
  )
}
''')

print("\n=== ALL TOOL PAGES WRITTEN ===")
