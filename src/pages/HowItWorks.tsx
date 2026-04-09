import { motion } from 'framer-motion'
import { Camera, Cpu, Wrench, ArrowDown, Scan, AlertTriangle, Brain, Mic, Car, Shield, Globe, CheckCircle } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import SectionTitle from '@/components/SectionTitle'
import CTASection from '@/components/CTASection'

const steps = [
  { step: '01', icon: Camera, title: 'Scaneaza sau Descrie', desc: 'Fotografiaza componenta, introdu VIN-ul, un cod de eroare DTC, sau pur si simplu descrie problema in chat-ul AI.', color: 'from-cyan-500 to-blue-600', items: ['Foto scan cu camera', 'VIN decoder automat', 'Cod eroare OBD2', 'Descriere vocala'] },
  { step: '02', icon: Cpu, title: 'AI Analizeaza', desc: 'Motorul nostru AI proceseaza datele in milisecunde, comparand cu baza de date de 108 marci auto si milioane de cazuri.', color: 'from-blue-500 to-purple-600', items: ['Machine Learning avansat', 'Baza de date 108 marci', '44 tari europene', 'Milioane de cazuri'] },
  { step: '03', icon: Wrench, title: 'Primesti Diagnostic', desc: 'Afli exact ce problema are masina, cauzele posibile, severitatea, costul estimat si pasii de reparatie.', color: 'from-purple-500 to-pink-600', items: ['Diagnostic detaliat', 'Cauze si solutii', 'Cost estimat', 'Ghid reparatie AR'] },
  { step: '04', icon: Shield, title: 'Actioneaza', desc: 'Gaseste mecanici verificati, compara preturi, programeaza service sau exporta raportul PDF.', color: 'from-emerald-500 to-teal-600', items: ['Mecanici verificati', 'Comparator preturi', 'Programare service', 'Export raport PDF'] },
]

const useCases = [
  { icon: Scan, title: 'Foto Scan', desc: 'Fotografiezi o pata de ulei sub motor. AI-ul identifica: scurgere carter ulei, severitate medie, cost 150-300 EUR.' },
  { icon: AlertTriangle, title: 'Cod Eroare', desc: 'Introdu P0300. AI-ul explica: rateu de aprindere multiplu, cauze: bujii, bobine, injectoare. Cost: 50-400 EUR.' },
  { icon: Brain, title: 'Chat AI', desc: 'Intrebi: "De ce trepideaza motorul?" AI-ul raspunde cu 5 cauze posibile in ordine, costuri si urgenta.' },
  { icon: Mic, title: 'Sunet Motor', desc: 'Inregistrezi 5 secunde. AI-ul detecteaza: bataie in motor zona superioara, posibil tacheti. Urgenta: medie.' },
  { icon: Car, title: 'VIN Check', desc: 'Introdu VIN-ul. Afli: marca, model, motor, transmisie, tara fabricatie, recall-uri active, probleme frecvente.' },
  { icon: Globe, title: 'Insights EU', desc: 'Selectezi BMW + Romania. Afli: fiabilitate 87%, cost mediu/an 1200 EUR, probleme frecvente, piese cele mai inlocuite.' },
]

export default function HowItWorks() {
  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">Simplu si Rapid</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-4">
            Cum <span className="gradient-text-static">Functioneaza</span>
          </h1>
          <p className="text-lg text-slate-400 max-w-2xl mx-auto">De la scan la diagnostic complet in cateva secunde. Iata procesul pas cu pas.</p>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="space-y-8">
            {steps.map((s, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.6, delay: i * 0.1 }}>
                <div className="glass-card rounded-3xl p-8 lg:p-10">
                  <div className="flex flex-col lg:flex-row gap-8 items-start">
                    <div className={`w-20 h-20 rounded-2xl bg-gradient-to-br ${s.color} flex items-center justify-center shrink-0`}>
                      <s.icon className="w-10 h-10 text-white" />
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-3">
                        <span className="text-xs font-bold text-cyan-400 tracking-widest uppercase">Pasul {s.step}</span>
                      </div>
                      <h3 className="text-2xl font-black text-white mb-3">{s.title}</h3>
                      <p className="text-slate-400 leading-relaxed mb-6">{s.desc}</p>
                      <div className="grid grid-cols-2 gap-3">
                        {s.items.map((item, j) => (
                          <div key={j} className="flex items-center gap-2">
                            <CheckCircle className="w-4 h-4 text-emerald-400 shrink-0" />
                            <span className="text-sm text-slate-300">{item}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
                {i < steps.length - 1 && (
                  <div className="flex justify-center py-4"><ArrowDown className="w-6 h-6 text-slate-700" /></div>
                )}
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <SectionWrapper className="border-t border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Exemple" title="Exemple Practice" subtitle="Iata cum folosesc oamenii AutoDiag Pro in viata reala." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {useCases.map((uc, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.08 }} className="glass-card rounded-3xl p-6 lg:p-8">
                <uc.icon className="w-8 h-8 text-cyan-400 mb-4" />
                <h3 className="text-lg font-bold text-white mb-2">{uc.title}</h3>
                <p className="text-sm text-slate-400 leading-relaxed">{uc.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
