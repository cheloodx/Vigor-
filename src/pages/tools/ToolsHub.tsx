import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Brain, Camera, AlertTriangle, Car, Gauge, Mic, Globe, Shield, ArrowRight, Link as LinkIcon } from 'lucide-react'

const tools = [
  { icon: Brain, title: 'Mecanic AI', desc: 'Chat cu mecanicul AI — intreaba orice despre masina ta.', to: '/tools/chat', color: 'from-cyan-500 to-blue-600', live: true },
  { icon: Camera, title: 'Foto Diagnostic', desc: 'Descrie problema vizuala si primesti diagnostic AI instant.', to: '/tools/scan', color: 'from-purple-500 to-pink-600', live: true },
  { icon: AlertTriangle, title: 'Decodor DTC', desc: 'Introdu codul de eroare OBD2 si afla cauza si solutia.', to: '/tools/dtc', color: 'from-amber-500 to-orange-600', live: true },
  { icon: Car, title: 'VIN Decoder', desc: 'Decodifica seria de sasiu si afla specificatii complete.', to: '/tools/vin', color: 'from-blue-500 to-indigo-600', live: true },
  { icon: Gauge, title: 'Predictor AI', desc: 'Afla ce componente se pot strica in urmatoarele luni.', to: '/tools/predictor', color: 'from-red-500 to-rose-600', live: true },
  { icon: Mic, title: 'Analiza Sunet', desc: 'Analizeaza sunetul motorului si detecteaza anomalii.', to: '/tools/sound', color: 'from-teal-500 to-emerald-600', live: true },
  { icon: Globe, title: 'AI European', desc: 'Insights si statistici per marca si tara europeana.', to: '/tools/european', color: 'from-emerald-500 to-green-600', live: true },
  { icon: Shield, title: 'Recall Check', desc: 'Verifica campaniile de rechemare active.', to: '/tools/recalls', color: 'from-red-500 to-rose-600', live: true },
  { icon: LinkIcon, title: 'Blockchain Passport', desc: 'Istoric vehicul verificat pe blockchain — 44 tari europene.', to: '/tools/blockchain', color: 'from-violet-500 to-purple-600', live: true },
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
