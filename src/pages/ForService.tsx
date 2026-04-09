import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { ArrowRight, BarChart3, Users, FileText, Zap, Shield, Clock, Car, Cpu, Globe, DollarSign, Layers } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import SectionTitle from '@/components/SectionTitle'
import FeatureCard from '@/components/FeatureCard'
import CTASection from '@/components/CTASection'

export default function ForService() {
  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-emerald-400 tracking-widest uppercase">
                Pentru Profesionisti
              </span>
              <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-6">
                Diagnostic AI pentru <span className="gradient-text-static">Service-uri Auto</span>
              </h1>
              <p className="text-lg text-slate-400 mb-8 leading-relaxed">
                Creste-ti productivitatea cu 300%. Diagnostic AI in timp real, rapoarte profesionale si gestionare completa a flotei de vehicule.
              </p>
              <div className="flex flex-col sm:flex-row gap-4">
                <Link to="/contact" className="btn-primary px-8 py-4 text-base flex items-center justify-center gap-2">
                  Cere Demo Gratuit <ArrowRight className="w-5 h-5" />
                </Link>
                <Link to="/pricing" className="btn-secondary px-8 py-4 text-base flex items-center justify-center gap-2">
                  Vezi Planurile PRO
                </Link>
              </div>
            </div>
            <div className="glass-bright rounded-3xl p-8 glow-cyan">
              <div className="grid grid-cols-2 gap-4">
                {[
                  { icon: BarChart3, val: '+300%', label: 'Productivitate', color: 'text-cyan-400' },
                  { icon: Clock, val: '-45 min', label: 'Timp/diagnostic', color: 'text-emerald-400' },
                  { icon: DollarSign, val: '+40%', label: 'Revenue', color: 'text-purple-400' },
                  { icon: Users, val: '10,000+', label: 'Mecanici activi', color: 'text-blue-400' },
                ].map((s, i) => (
                  <motion.div key={i} initial={{ opacity: 0, scale: 0.9 }} whileInView={{ opacity: 1, scale: 1 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass rounded-2xl p-5 text-center">
                    <s.icon className="w-6 h-6 text-slate-500 mx-auto mb-2" />
                    <p className={`text-2xl font-black ${s.color}`}>{s.val}</p>
                    <p className="text-xs text-slate-500 mt-1">{s.label}</p>
                  </motion.div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Functii PRO" title="Tot ce ai nevoie ca profesionist" subtitle="Unelte dedicate pentru service-uri auto, mecanici independenti si flote de vehicule." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
            <FeatureCard icon={Cpu} title="Diagnostic AI Bulk" description="Diagnosticheaza multiple vehicule simultan cu AI avansat." gradient="from-cyan-500/30 to-blue-600/20" delay={0} />
            <FeatureCard icon={FileText} title="Rapoarte PDF PRO" description="Genereaza rapoarte profesionale cu branding-ul tau propriu." gradient="from-blue-500/30 to-indigo-600/20" delay={0.05} />
            <FeatureCard icon={Car} title="Gestionare Flota" description="Dashboard complet pentru monitorizarea flotei de vehicule." gradient="from-emerald-500/30 to-green-600/20" delay={0.1} />
            <FeatureCard icon={Layers} title="API Integration" description="Integreaza AutoDiag Pro in sistemele tale existente via API." gradient="from-purple-500/30 to-pink-600/20" delay={0.15} />
            <FeatureCard icon={Globe} title="Multi-Tara" description="Suport pentru 44 de tari europene cu legislatie specifica." gradient="from-teal-500/30 to-emerald-600/20" delay={0.2} />
            <FeatureCard icon={Shield} title="Prioritate Suport" description="Suport tehnic prioritar 24/7 cu timp de raspuns sub 1 ora." gradient="from-amber-500/30 to-orange-600/20" delay={0.25} />
          </div>
        </div>
      </SectionWrapper>

      <SectionWrapper className="border-t border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Workflow" title="Cum functioneaza pentru tine" />
          <div className="grid md:grid-cols-4 gap-6">
            {[
              { step: '1', title: 'Clientul vine', desc: 'Clientul aduce masina cu o problema.', icon: Car },
              { step: '2', title: 'Scan AI', desc: 'Scanezi cu AutoDiag Pro in 30 secunde.', icon: Zap },
              { step: '3', title: 'Diagnostic', desc: 'AI-ul genereaza diagnostic complet cu cauze si costuri.', icon: Cpu },
              { step: '4', title: 'Raport PRO', desc: 'Trimiti raportul profesional clientului.', icon: FileText },
            ].map((s, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass-card rounded-3xl p-6 text-center">
                <div className="w-12 h-12 rounded-full bg-gradient-to-br from-cyan-500/20 to-blue-600/20 flex items-center justify-center mx-auto mb-4">
                  <span className="text-lg font-black text-cyan-400">{s.step}</span>
                </div>
                <s.icon className="w-6 h-6 text-slate-500 mx-auto mb-3" />
                <h3 className="font-bold text-white mb-2">{s.title}</h3>
                <p className="text-sm text-slate-400">{s.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
