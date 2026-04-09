import { useState, useRef, useEffect } from 'react'
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
