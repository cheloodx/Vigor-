import { motion } from 'framer-motion'
import { Zap, Target, Heart, Globe, Shield, Users, Award, Cpu } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import SectionTitle from '@/components/SectionTitle'
import StatsSection from '@/components/StatsSection'
import CTASection from '@/components/CTASection'

export default function About() {
  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">Despre Noi</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-6">
            Misiunea noastra: <span className="gradient-text-static">Diagnostic Auto Accesibil</span>
          </h1>
          <p className="text-lg text-slate-400 leading-relaxed">
            AutoDiag Pro a fost creat cu o viziune simpla: fiecare sofer si mecanic trebuie sa aiba acces la diagnostic auto inteligent, rapid si accesibil. Folosim cele mai avansate tehnologii AI pentru a democratiza diagnosticul auto in Europa.
          </p>
        </div>
      </section>

      <StatsSection />

      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Valorile Noastre" title="Ce ne defineste" />
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { icon: Target, title: 'Precizie', desc: 'Acuratete de 99.8% in diagnostic, bazata pe milioane de cazuri reale.', color: 'from-cyan-500/30 to-blue-600/20' },
              { icon: Heart, title: 'Pasiune', desc: 'Iubim masinile si tehnologia. Fiecare functie e facuta cu grija.', color: 'from-red-500/30 to-rose-600/20' },
              { icon: Globe, title: 'Accesibilitate', desc: 'Disponibil in 44 de tari europene, in limba locala.', color: 'from-emerald-500/30 to-green-600/20' },
              { icon: Shield, title: 'Incredere', desc: 'GDPR compliant, date criptate, confidentialitate maxima.', color: 'from-purple-500/30 to-indigo-600/20' },
            ].map((v, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass-card rounded-3xl p-6 text-center">
                <div className={`w-14 h-14 rounded-2xl bg-gradient-to-br ${v.color} flex items-center justify-center mx-auto mb-5`}>
                  <v.icon className="w-7 h-7 text-white" />
                </div>
                <h3 className="text-lg font-bold text-white mb-2">{v.title}</h3>
                <p className="text-sm text-slate-400 leading-relaxed">{v.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <SectionWrapper className="border-t border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Echipa" title="Facut de ingineri pasionati" subtitle="O echipa dedicata de ingineri AI, mecanici auto si designeri." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { name: 'Echipa AI', role: '5 ingineri ML/AI', icon: Cpu },
              { name: 'Echipa Auto', role: '3 mecanici certificati', icon: Zap },
              { name: 'Echipa Design', role: '2 UX/UI designeri', icon: Award },
              { name: 'Echipa Suport', role: 'Suport 24/7', icon: Users },
            ].map((m, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass-card rounded-3xl p-6 text-center">
                <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-cyan-500/10 to-blue-600/10 flex items-center justify-center mx-auto mb-4">
                  <m.icon className="w-8 h-8 text-cyan-400" />
                </div>
                <h3 className="font-bold text-white mb-1">{m.name}</h3>
                <p className="text-sm text-slate-500">{m.role}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
