import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { ArrowRight, Shield, Cpu, Scan, Wrench, Car, BarChart3, Globe, Mic, Camera, Brain, AlertTriangle, Gauge, Sparkles, Clock, CheckCircle } from 'lucide-react'
import Hero3D from '@/components/Hero3D'
import SectionWrapper from '@/components/SectionWrapper'
import SectionTitle from '@/components/SectionTitle'
import FeatureCard from '@/components/FeatureCard'
import TestimonialCard from '@/components/TestimonialCard'
import StatsSection from '@/components/StatsSection'
import CTASection from '@/components/CTASection'

export default function Home() {
  return (
    <>
      {/* HERO */}
      <section className="relative min-h-screen flex items-center overflow-hidden">
        <Hero3D />
        <div className="absolute inset-0 grid-bg pointer-events-none" />
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-32">
          <div className="max-w-3xl">
            <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.8, delay: 0.2 }}>
              <span className="inline-block mb-6 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">
                Platforma #1 in Europa
              </span>
            </motion.div>
            <motion.h1
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.3 }}
              className="text-5xl sm:text-6xl lg:text-7xl xl:text-8xl font-black tracking-tighter mb-6 text-glow"
            >
              <span className="gradient-text">Diagnostic Auto</span><br />
              <span className="text-white">cu Inteligenta</span><br />
              <span className="text-white">Artificiala</span>
            </motion.h1>
            <motion.p
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.4 }}
              className="text-lg sm:text-xl text-slate-400 mb-8 max-w-xl leading-relaxed"
            >
              Scaneaza, diagnosticheaza si repara masina ta folosind AI avansat. 50+ functii, 108 marci auto, disponibil in 44 tari.
            </motion.p>
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.5 }}
              className="flex flex-col sm:flex-row gap-4"
            >
              <Link to="/pricing" className="btn-primary px-8 py-4 text-base flex items-center justify-center gap-2">
                Incepe Gratuit <ArrowRight className="w-5 h-5" />
              </Link>
              <Link to="/cum-functioneaza" className="btn-secondary px-8 py-4 text-base flex items-center justify-center gap-2">
                Cum Functioneaza
              </Link>
            </motion.div>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.8, delay: 0.7 }}
              className="flex items-center gap-6 mt-8"
            >
              <div className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-emerald-400" /><span className="text-sm text-slate-500">Gratuit pentru totdeauna</span></div>
              <div className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-emerald-400" /><span className="text-sm text-slate-500">Fara card bancar</span></div>
              <div className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-emerald-400" /><span className="text-sm text-slate-500">GDPR compliant</span></div>
            </motion.div>
          </div>
        </div>
        <div className="absolute bottom-10 left-1/2 -translate-x-1/2 animate-bounce hidden lg:flex flex-col items-center gap-2 z-10">
          <span className="text-slate-600 text-xs tracking-widest uppercase font-medium">Descopera</span>
          <div className="w-6 h-10 border-2 border-slate-700 rounded-full flex justify-center pt-2"><div className="w-1.5 h-2.5 bg-cyan-500 rounded-full animate-pulse" /></div>
        </div>
      </section>

      <StatsSection />

      {/* FEATURES HIGHLIGHT */}
      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Functionalitati" title="Tot ce ai nevoie pentru masina ta" subtitle="De la diagnostic simplu la predictii AI avansate — totul intr-o singura aplicatie." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
            <FeatureCard icon={Scan} title="Foto Diagnostic" description="Fotografiaza componenta si primesti diagnostic instant cu AI." gradient="from-cyan-500/30 to-blue-600/20" delay={0} />
            <FeatureCard icon={Brain} title="Mecanic AI Pro" description="Chat inteligent cu context — intreaba orice despre masina ta." gradient="from-purple-500/30 to-pink-600/20" delay={0.05} />
            <FeatureCard icon={AlertTriangle} title="Decodor DTC" description="Introdu codul de eroare OBD2 si afla cauza si solutia." gradient="from-amber-500/30 to-orange-600/20" delay={0.1} />
            <FeatureCard icon={Gauge} title="Predictor AI" description="Afla ce se poate strica in urmatoarele 3-6 luni." gradient="from-red-500/30 to-rose-600/20" delay={0.15} />
            <FeatureCard icon={Mic} title="Analiza Sunet" description="Inregistreaza sunetul motorului si AI-ul detecteaza problemele." gradient="from-teal-500/30 to-emerald-600/20" delay={0.2} />
            <FeatureCard icon={Globe} title="AI European" description="Date si insights pentru 44 de tari europene si 108 marci." gradient="from-emerald-500/30 to-green-600/20" delay={0.25} />
            <FeatureCard icon={Shield} title="Recall Service" description="Verifica campaniile de rechemare active pentru masina ta." gradient="from-blue-500/30 to-indigo-600/20" delay={0.3} />
            <FeatureCard icon={Car} title="VIN Decoder" description="Decodifica seria de sasiu si afla istoricul complet." gradient="from-indigo-500/30 to-violet-600/20" delay={0.35} />
          </div>
          <div className="text-center mt-10">
            <Link to="/functionalitati" className="btn-secondary px-8 py-3.5 text-sm inline-flex items-center gap-2">
              Vezi Toate Functiile <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        </div>
      </SectionWrapper>

      {/* HOW IT WORKS */}
      <SectionWrapper className="border-t border-white/5">
        <div className="absolute inset-0 hero-glow opacity-30 pointer-events-none" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Simplu" title="Cum functioneaza?" subtitle="3 pasi simpli — de la scan la diagnostic complet." />
          <div className="grid md:grid-cols-3 gap-8">
            {[
              { step: '01', icon: Camera, title: 'Scaneaza', desc: 'Fotografiaza componenta, introdu VIN-ul sau codul de eroare.', color: 'from-cyan-500 to-blue-600' },
              { step: '02', icon: Cpu, title: 'Analizeaza', desc: 'AI-ul proceseaza datele si identifica problemele in secunde.', color: 'from-blue-500 to-purple-600' },
              { step: '03', icon: Wrench, title: 'Repara', desc: 'Primesti diagnosticul complet, costuri estimate si recomandari.', color: 'from-purple-500 to-pink-600' },
            ].map((s, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.15 }}
                className="relative glass-card rounded-3xl p-8 text-center"
              >
                <span className="absolute -top-4 left-6 text-6xl font-black text-white/[0.03]">{s.step}</span>
                <div className={`w-16 h-16 rounded-2xl bg-gradient-to-br ${s.color} flex items-center justify-center mx-auto mb-5`}>
                  <s.icon className="w-8 h-8 text-white" />
                </div>
                <h3 className="text-xl font-bold text-white mb-3">{s.title}</h3>
                <p className="text-sm text-slate-400 leading-relaxed">{s.desc}</p>
                {i < 2 && <div className="hidden md:block absolute top-1/2 -right-4 w-8 text-slate-700"><ArrowRight className="w-8 h-8" /></div>}
              </motion.div>
            ))}
          </div>
          <div className="text-center mt-10">
            <Link to="/cum-functioneaza" className="btn-secondary px-8 py-3.5 text-sm inline-flex items-center gap-2">
              Afla Mai Multe <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        </div>
      </SectionWrapper>

      {/* TESTIMONIALS */}
      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Testimoniale" title="Ce spun utilizatorii" subtitle="Peste 10,000 de soferi si mecanici folosesc AutoDiag Pro zilnic." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
            <TestimonialCard name="Mihai Popescu" role="Sofer, Bucuresti" text="Am detectat o problema la distributie inainte sa se strice. M-a salvat de o reparatie de 2000 EUR!" stars={5} delay={0} />
            <TestimonialCard name="Ana Gheorghe" role="Mecanic Auto, Cluj" text="Folosesc zilnic pentru clienti. Predictiile AI sunt incredibil de precise. Recomand!" stars={5} delay={0.1} />
            <TestimonialCard name="Radu Ionescu" role="Service Auto, Timisoara" text="Cea mai buna aplicatie de diagnostic pe care am folosit-o. Suportul pentru 44 de tari e genial." stars={5} delay={0.2} />
          </div>
        </div>
      </SectionWrapper>

      {/* FOR MECHANICS */}
      <SectionWrapper className="border-t border-white/5">
        <div className="absolute inset-0 hero-glow opacity-20 pointer-events-none" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-emerald-400 tracking-widest uppercase">
                Pentru Profesionisti
              </span>
              <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-white mb-6">
                Solutia pentru <span className="gradient-text-static">Service-uri Auto</span>
              </h2>
              <p className="text-lg text-slate-400 mb-8 leading-relaxed">
                Dashboard dedicat pentru mecanici si service-uri. Gestioneaza clienti, diagnostic AI in bulk, rapoarte profesionale si multe altele.
              </p>
              <div className="space-y-4 mb-8">
                {[
                  'Diagnostic AI pentru clienti in timp real',
                  'Rapoarte PDF profesionale cu branding propriu',
                  'Gestionare flota de vehicule',
                  'API integration pentru sisteme existente',
                ].map((t, i) => (
                  <div key={i} className="flex items-center gap-3">
                    <div className="w-6 h-6 rounded-full bg-emerald-500/20 flex items-center justify-center shrink-0">
                      <CheckCircle className="w-4 h-4 text-emerald-400" />
                    </div>
                    <span className="text-sm text-slate-300">{t}</span>
                  </div>
                ))}
              </div>
              <Link to="/pentru-service" className="btn-primary px-8 py-4 text-base inline-flex items-center gap-2">
                Afla Mai Multe <ArrowRight className="w-5 h-5" />
              </Link>
            </div>
            <div className="relative">
              <div className="glass-bright rounded-3xl p-8 glow-cyan">
                <div className="space-y-4">
                  {[
                    { icon: BarChart3, label: 'Diagnostic completat', val: '2,847', color: 'text-cyan-400' },
                    { icon: Clock, label: 'Timp mediu salvat', val: '45 min', color: 'text-emerald-400' },
                    { icon: Sparkles, label: 'Acuratete AI', val: '99.8%', color: 'text-purple-400' },
                    { icon: Car, label: 'Vehicule gestionate', val: '1,205', color: 'text-blue-400' },
                  ].map((s, i) => (
                    <motion.div
                      key={i}
                      initial={{ opacity: 0, x: 20 }}
                      whileInView={{ opacity: 1, x: 0 }}
                      viewport={{ once: true }}
                      transition={{ duration: 0.5, delay: i * 0.1 }}
                      className="glass rounded-2xl p-4 flex items-center justify-between"
                    >
                      <div className="flex items-center gap-3">
                        <s.icon className="w-5 h-5 text-slate-500" />
                        <span className="text-sm text-slate-400">{s.label}</span>
                      </div>
                      <span className={`text-lg font-black ${s.color}`}>{s.val}</span>
                    </motion.div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
