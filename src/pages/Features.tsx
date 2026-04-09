import { Scan, Brain, AlertTriangle, Gauge, Mic, Globe, Shield, Car, Camera, Wrench, Bell, Map, Fuel, DollarSign, FileText, Scale, Users, Crown, Watch, Smartphone, Activity, Cpu, Zap, Eye, Layers, Radio, MessageSquare } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import SectionTitle from '@/components/SectionTitle'
import FeatureCard from '@/components/FeatureCard'
import CTASection from '@/components/CTASection'

const sections = [
  {
    title: 'Diagnostic AI',
    badge: 'Core',
    features: [
      { icon: Camera, title: 'Foto Diagnostic', desc: 'Fotografiaza si primesti diagnostic AI instant cu cauze, solutii si costuri estimate.', g: 'from-cyan-500/30 to-blue-600/20' },
      { icon: AlertTriangle, title: 'Decodor DTC', desc: 'Introdu orice cod eroare OBD2 si afla explicatia completa cu solutii.', g: 'from-amber-500/30 to-orange-600/20' },
      { icon: Mic, title: 'Analiza Sunet Motor', desc: 'Inregistreaza sunetul si AI-ul detecteaza anomalii sonore.', g: 'from-teal-500/30 to-emerald-600/20' },
      { icon: Zap, title: 'Diagnostic Rapid', desc: 'Shake to diagnose — diagnostic instantaneu cu gestul telefonului.', g: 'from-violet-500/30 to-purple-600/20' },
      { icon: Eye, title: 'AR Piese', desc: 'Vizualizare in realitate augmentata a componentelor si daunelor.', g: 'from-slate-500/30 to-slate-600/20' },
      { icon: Wrench, title: 'AR Ghid Reparatie', desc: 'Pasi de reparatie interactivi in realitate augmentata.', g: 'from-red-500/30 to-rose-600/20' },
      { icon: Scan, title: 'Scanner Piese', desc: 'Scaneaza QR cod si gaseste piese compatibile si alternative.', g: 'from-teal-500/30 to-cyan-600/20' },
      { icon: Activity, title: 'Scor Sanatate', desc: 'Nota generala 0-100 calculata din toate datele vehiculului.', g: 'from-emerald-500/30 to-green-600/20' },
      { icon: Layers, title: 'Diagrama Auto', desc: 'Vizualizare interactiva a componentelor vehiculului.', g: 'from-blue-500/30 to-indigo-600/20' },
    ]
  },
  {
    title: 'AI & Predictii',
    badge: 'Smart',
    features: [
      { icon: Brain, title: 'Mecanic AI Pro', desc: 'Chat AI context-aware cu cunostinte tehnice complete.', g: 'from-cyan-500/30 to-blue-600/20' },
      { icon: Gauge, title: 'Predictor AI', desc: 'Predictii bazate pe ML — afla ce se strica in 3-6 luni.', g: 'from-pink-500/30 to-rose-600/20' },
      { icon: Shield, title: 'Radar ITP', desc: 'Verifica daca masina ta trece inspectia tehnica.', g: 'from-red-500/30 to-rose-600/20' },
      { icon: Cpu, title: 'Digital Twin', desc: 'Replica digitala completa a vehiculului tau.', g: 'from-teal-500/30 to-cyan-600/20' },
      { icon: Globe, title: 'AI European', desc: 'Date si insights per marca si tara pentru 44 tari.', g: 'from-emerald-500/30 to-green-600/20' },
    ]
  },
  {
    title: 'Vehicul & Date',
    badge: 'Data',
    features: [
      { icon: Car, title: 'VIN Decoder', desc: 'Decodifica VIN si afla specificatiile complete.', g: 'from-blue-500/30 to-indigo-600/20' },
      { icon: Radio, title: 'OBD2 Avansat', desc: 'Live data de la senzori + consum real in timp real.', g: 'from-indigo-500/30 to-violet-600/20' },
      { icon: FileText, title: 'CV Auto', desc: 'Istoric complet al vehiculului cu toate interventiile.', g: 'from-blue-500/30 to-cyan-600/20' },
      { icon: Bell, title: 'Alarme Intretinere', desc: 'Notificari push pentru service si intretinere.', g: 'from-amber-500/30 to-yellow-600/20' },
      { icon: Map, title: 'Harta Service', desc: 'Gaseste service-uri si mecanici aproape de tine.', g: 'from-blue-500/30 to-cyan-600/20' },
      { icon: Fuel, title: 'Calculator Consum', desc: 'Calculeaza consumul real L/100km.', g: 'from-orange-500/30 to-amber-600/20' },
      { icon: DollarSign, title: 'Estimator Valoare', desc: 'Afla pretul masinii tale pe piata.', g: 'from-green-500/30 to-emerald-600/20' },
      { icon: Shield, title: 'Recall Service', desc: 'Verifica campaniile de rechemare active.', g: 'from-red-500/30 to-rose-600/20' },
    ]
  },
  {
    title: 'Service & Costuri',
    badge: 'Business',
    features: [
      { icon: DollarSign, title: 'Estimator Costuri', desc: 'Afla cat costa reparatia inainte sa mergi la service.', g: 'from-green-500/30 to-emerald-600/20' },
      { icon: Scale, title: 'Comparator Service', desc: 'Compara preturi intre service autorizat si independent.', g: 'from-orange-500/30 to-amber-600/20' },
      { icon: Shield, title: 'Comparator RCA', desc: 'Gaseste cea mai buna oferta de asigurare.', g: 'from-blue-500/30 to-indigo-600/20' },
      { icon: Users, title: 'Mecanici Verificati', desc: 'Rating + garantie lucrare de la mecanici verificati.', g: 'from-green-500/30 to-emerald-600/20' },
      { icon: MessageSquare, title: 'Diagnostic Vocal', desc: 'Descrie problema cu vocea si primesti diagnostic.', g: 'from-pink-500/30 to-rose-600/20' },
    ]
  },
  {
    title: 'Dispozitive & Integrari',
    badge: 'Ecosystem',
    features: [
      { icon: Watch, title: 'Apple Watch', desc: 'Companion app cu alerte si scor sanatate pe ceas.', g: 'from-indigo-500/30 to-violet-600/20' },
      { icon: Car, title: 'CarPlay', desc: 'Dashboard complet pe ecranul masinii.', g: 'from-slate-500/30 to-gray-600/20' },
      { icon: Smartphone, title: 'Widget iOS', desc: 'Scor sanatate direct pe home screen.', g: 'from-cyan-500/30 to-blue-600/20' },
      { icon: Crown, title: 'PRO Premium', desc: 'Functii avansate, fara limite, prioritate suport.', g: 'from-amber-500/30 to-yellow-600/20' },
    ]
  },
]

export default function Features() {
  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">50+ Functii</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-4">
            Toate <span className="gradient-text-static">Functiile</span>
          </h1>
          <p className="text-lg text-slate-400 max-w-2xl mx-auto">Descopera tot ce poate face AutoDiag Pro pentru tine si masina ta.</p>
        </div>
      </section>

      {sections.map((sec, si) => (
        <SectionWrapper key={si} className={si % 2 === 0 ? '' : 'border-t border-b border-white/5'}>
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <SectionTitle badge={sec.badge} title={sec.title} />
            <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
              {sec.features.map((f, fi) => (
                <FeatureCard key={fi} icon={f.icon} title={f.title} description={f.desc} gradient={f.g} delay={fi * 0.05} />
              ))}
            </div>
          </div>
        </SectionWrapper>
      ))}

      <CTASection />
    </>
  )
}
