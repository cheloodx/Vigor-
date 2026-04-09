import { useState } from 'react'
import { motion } from 'framer-motion'
import { Mail, Phone, MapPin, Send, CheckCircle, MessageSquare, Clock } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'

export default function Contact() {
  const [sent, setSent] = useState(false)
  const [form, setForm] = useState({ name: '', email: '', subject: '', message: '' })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setSent(true)
    setTimeout(() => setSent(false), 3000)
  }

  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">Contact</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-4">
            Hai sa <span className="gradient-text-static">Vorbim</span>
          </h1>
          <p className="text-lg text-slate-400">Suntem aici sa te ajutam. Raspundem in mai putin de 24 de ore.</p>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-5 gap-10">
            <div className="lg:col-span-2 space-y-6">
              {[
                { icon: Mail, title: 'Email', info: 'contact@autodiagpro.com' },
                { icon: Phone, title: 'Telefon', info: '+40 721 000 000' },
                { icon: MapPin, title: 'Sediu', info: 'Bucuresti, Romania' },
                { icon: Clock, title: 'Program', info: 'Luni - Vineri, 9:00 - 18:00' },
              ].map((c, i) => (
                <motion.div key={i} initial={{ opacity: 0, x: -20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass-card rounded-2xl p-5 flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-cyan-500/20 to-blue-600/20 flex items-center justify-center shrink-0">
                    <c.icon className="w-5 h-5 text-cyan-400" />
                  </div>
                  <div>
                    <p className="text-sm text-slate-500 font-medium">{c.title}</p>
                    <p className="text-white font-semibold">{c.info}</p>
                  </div>
                </motion.div>
              ))}
              <div className="glass-card rounded-2xl p-5">
                <div className="flex items-center gap-3 mb-3">
                  <MessageSquare className="w-5 h-5 text-emerald-400" />
                  <span className="font-semibold text-white">Live Chat</span>
                </div>
                <p className="text-sm text-slate-400 mb-4">Disponibil in aplicatie 24/7</p>
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" />
                  <span className="text-xs text-emerald-400">Online acum</span>
                </div>
              </div>
            </div>
            <div className="lg:col-span-3">
              <motion.form
                onSubmit={handleSubmit}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                className="glass-bright rounded-3xl p-8 glow-cyan"
              >
                <h3 className="text-xl font-bold text-white mb-6">Trimite-ne un mesaj</h3>
                <div className="grid sm:grid-cols-2 gap-4 mb-4">
                  <input type="text" placeholder="Numele tau" value={form.name} onChange={e => setForm({...form, name: e.target.value})} className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 transition-all" />
                  <input type="email" placeholder="Email" value={form.email} onChange={e => setForm({...form, email: e.target.value})} className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 transition-all" />
                </div>
                <input type="text" placeholder="Subiect" value={form.subject} onChange={e => setForm({...form, subject: e.target.value})} className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 transition-all mb-4" />
                <textarea placeholder="Mesajul tau..." rows={5} value={form.message} onChange={e => setForm({...form, message: e.target.value})} className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 transition-all resize-none mb-6" />
                <button type="submit" className="btn-primary w-full px-8 py-4 text-base flex items-center justify-center gap-2">
                  {sent ? <><CheckCircle className="w-5 h-5" /> Trimis!</> : <><Send className="w-5 h-5" /> Trimite Mesajul</>}
                </button>
              </motion.form>
            </div>
          </div>
        </div>
      </SectionWrapper>
    </>
  )
}
