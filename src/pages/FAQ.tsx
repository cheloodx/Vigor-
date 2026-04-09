import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { ChevronDown, HelpCircle } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import CTASection from '@/components/CTASection'

const faqs = [
  { q: 'Ce este AutoDiag Pro?', a: 'AutoDiag Pro este o platforma de diagnostic auto alimentata de inteligenta artificiala. Ofera peste 50 de functii, de la scanare foto si decodare VIN pana la predictii de defectiuni si chat cu un mecanic AI.' },
  { q: 'Cat costa aplicatia?', a: 'Planul Free este gratuit pentru totdeauna si include 5 scanari/luna, VIN decoder, decodor DTC si chat AI limitat. Planul PRO costa 9.99 EUR/luna si ofera acces nelimitat la toate functiile.' },
  { q: 'In ce tari este disponibil?', a: 'AutoDiag Pro este disponibil in 44 de tari europene, inclusiv Romania, Germania, Franta, Italia, Spania, UK, Polonia si multe altele. Suportam 108 marci auto.' },
  { q: 'Cum functioneaza diagnosticul foto?', a: 'Pur si simplu fotografiezi componenta sau problema vizibila. AI-ul nostru analizeaza imaginea si ofera diagnostic cu cauze posibile, severitate, cost estimat si recomandari de reparatie.' },
  { q: 'Am nevoie de un adaptor OBD2?', a: 'Nu este obligatoriu. Multe functii functioneaza fara adaptor (foto scan, VIN decoder, DTC, chat AI, predictii). Pentru date live in timp real, ai nevoie de un adaptor OBD2 Bluetooth.' },
  { q: 'Cat de precise sunt predictiile AI?', a: 'Motorul nostru AI are o acuratete de 99.8%, bazata pe analiza a milioane de cazuri reale. Predictiile sunt orientative si recomandam intotdeauna confirmarea la un mecanic certificat.' },
  { q: 'Este compatibil cu masina mea?', a: 'AutoDiag Pro suporta 108 marci auto, inclusiv toate marcile populare din Europa: Volkswagen, BMW, Mercedes, Audi, Toyota, Renault, Dacia, Ford, Opel, Skoda si multe altele.' },
  { q: 'Cum imi protejati datele?', a: 'Suntem GDPR compliant. Toate datele sunt criptate end-to-end, stocate in serverele securizate din UE. Nu vindem si nu partajam datele tale cu terti.' },
  { q: 'Pot folosi pentru service-ul meu auto?', a: 'Da! Avem planul Business dedicat service-urilor auto cu functii de gestionare flota, rapoarte cu branding propriu, API integration si suport 24/7.' },
  { q: 'Exista o versiune web?', a: 'Da! Pe langa aplicatia mobila (iOS si Android), avem si o versiune web completa accesibila din orice browser.' },
]

export default function FAQ() {
  const [openIdx, setOpenIdx] = useState<number | null>(null)

  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">FAQ</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-4">
            Intrebari <span className="gradient-text-static">Frecvente</span>
          </h1>
          <p className="text-lg text-slate-400">Gaseste raspunsuri la cele mai comune intrebari.</p>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="space-y-4">
            {faqs.map((f, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.4, delay: i * 0.05 }}
                className="glass-card rounded-2xl overflow-hidden"
              >
                <button onClick={() => setOpenIdx(openIdx === i ? null : i)} className="w-full flex items-center justify-between p-6 text-left">
                  <div className="flex items-center gap-3">
                    <HelpCircle className="w-5 h-5 text-cyan-400 shrink-0" />
                    <span className="font-semibold text-white">{f.q}</span>
                  </div>
                  <ChevronDown className={`w-5 h-5 text-slate-500 transition-transform duration-300 shrink-0 ml-4 ${openIdx === i ? 'rotate-180' : ''}`} />
                </button>
                <AnimatePresence>
                  {openIdx === i && (
                    <motion.div
                      initial={{ height: 0, opacity: 0 }}
                      animate={{ height: 'auto', opacity: 1 }}
                      exit={{ height: 0, opacity: 0 }}
                      transition={{ duration: 0.3 }}
                      className="overflow-hidden"
                    >
                      <div className="px-6 pb-6 pl-14">
                        <p className="text-sm text-slate-400 leading-relaxed">{f.a}</p>
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
