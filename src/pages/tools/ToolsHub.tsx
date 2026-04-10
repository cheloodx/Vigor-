import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Brain, Camera, AlertTriangle, Car, Gauge, Mic, Globe, Shield, ArrowRight, Link as LinkIcon, Heart, Zap, Package, FileText, Cpu, Wifi, Fuel, TrendingUp, Calendar, Receipt, Scale, MapPin, Store, AlertCircle } from 'lucide-react'

const sections = [
  {
    title: 'DIAGNOSTIC',
    tools: [
      { icon: Heart, title: 'Scor Sanatate', desc: 'Nota generala 0-100', to: '/tools/scor-sanatate', color: 'from-emerald-500 to-teal-600' },
      { icon: Car, title: 'Diagrama Auto', desc: 'Componente vizuale', to: '/tools/diagrama', color: 'from-blue-500 to-indigo-600' },
      { icon: Camera, title: 'Foto Diagnostic', desc: 'Analiza foto AI', to: '/tools/scan', color: 'from-purple-500 to-pink-600' },
      { icon: Package, title: 'Scanner Piese', desc: 'QR cod + alternative', to: '/tools/scanner-piese', color: 'from-orange-500 to-red-600' },
      { icon: AlertTriangle, title: 'Decodor DTC', desc: 'Erori OBD2 explicate', to: '/tools/dtc', color: 'from-amber-500 to-orange-600' },
      { icon: Mic, title: 'Analiza Sunet', desc: 'Inregistrare motor', to: '/tools/sound', color: 'from-teal-500 to-emerald-600' },
      { icon: Zap, title: 'Diagnostic Rapid', desc: 'Selecteaza simptomele', to: '/tools/diagnostic-rapid', color: 'from-yellow-500 to-orange-600' },
    ],
  },
  {
    title: 'AI & PREDICTII',
    tools: [
      { icon: Brain, title: 'Mecanic AI Pro', desc: 'Chat AI context-aware', to: '/tools/chat', color: 'from-cyan-500 to-blue-600' },
      { icon: Gauge, title: 'Predictor AI', desc: 'Ce se strica in 3-6 luni', to: '/tools/predictor', color: 'from-red-500 to-rose-600' },
      { icon: Shield, title: 'Radar ITP', desc: 'Trece ITP-ul?', to: '/tools/radar-itp', color: 'from-red-500 to-pink-600' },
      { icon: Cpu, title: 'Digital Twin', desc: 'Twin digital complet', to: '/tools/digital-twin', color: 'from-teal-500 to-cyan-600' },
      { icon: Globe, title: 'AI European', desc: 'Date per marca/tara', to: '/tools/european', color: 'from-emerald-500 to-green-600' },
    ],
  },
  {
    title: 'VEHICUL',
    tools: [
      { icon: FileText, title: 'CV Auto', desc: 'Istoric complet vehicul', to: '/tools/cv-auto', color: 'from-indigo-500 to-purple-600' },
      { icon: Car, title: 'VIN Decoder', desc: 'Decodifica seria de sasiu', to: '/tools/vin', color: 'from-blue-500 to-indigo-600' },
      { icon: Wifi, title: 'OBD2 Avansat', desc: 'Live data + consum real', to: '/tools/obd2', color: 'from-cyan-500 to-blue-600' },
      { icon: Shield, title: 'Recall Check', desc: 'Campanii rechemare', to: '/tools/recall', color: 'from-red-500 to-rose-600' },
      { icon: LinkIcon, title: 'Blockchain Passport', desc: 'Istoric vehicul blockchain', to: '/tools/blockchain', color: 'from-violet-500 to-purple-600' },
    ],
  },
  {
    title: 'SERVICE & COSTURI',
    tools: [
      { icon: Calendar, title: 'Service Calendar', desc: 'Calendar intretinere', to: '/tools/service-calendar', color: 'from-blue-500 to-indigo-600' },
      { icon: Receipt, title: 'Costuri', desc: 'Estimator costuri', to: '/tools/costuri', color: 'from-teal-500 to-green-600' },
      { icon: Fuel, title: 'Calculator Consum', desc: 'Consum real L/100km', to: '/tools/calculator-consum', color: 'from-orange-500 to-amber-600' },
      { icon: TrendingUp, title: 'Estimator Valoare', desc: 'Pret masina pe piata', to: '/tools/estimator-valoare', color: 'from-green-500 to-emerald-600' },
      { icon: Mic, title: 'Voce', desc: 'Diagnostic vocal', to: '/tools/voce', color: 'from-pink-500 to-rose-600' },
      { icon: Scale, title: 'Comparator', desc: 'Autorizat vs Independent', to: '/tools/comparator', color: 'from-orange-500 to-red-600' },
      { icon: AlertCircle, title: 'Comparator RCA', desc: 'Oferte asigurare', to: '/tools/comparator-rca', color: 'from-blue-500 to-indigo-600' },
    ],
  },
  {
    title: 'EUROPA & MARKETPLACE',
    tools: [
      { icon: MapPin, title: 'Harta Service', desc: 'Service-uri aproape', to: '/tools/harta-service', color: 'from-purple-500 to-violet-600' },
      { icon: Store, title: 'Marketplace', desc: 'Mecanici & service-uri', to: '/tools/marketplace', color: 'from-indigo-500 to-purple-600' },
      { icon: AlertTriangle, title: 'Legal & Amenzi', desc: 'Camere, reguli, amenzi', to: '/tools/legal-amenzi', color: 'from-amber-500 to-orange-600' },
    ],
  },
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
          {sections.map((section, si) => (
            <div key={si} className="mb-12">
              <h2 className="text-sm font-bold text-cyan-400 tracking-widest uppercase mb-6 pl-1">{section.title}</h2>
              <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
                {section.tools.map((t, i) => (
                  <motion.div
                    key={i}
                    initial={{ opacity: 0, y: 20 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    transition={{ duration: 0.4, delay: i * 0.04 }}
                  >
                    <Link to={t.to} className="block glass-card rounded-2xl p-5 h-full group relative overflow-hidden hover:border-cyan-500/30 transition-all">
                      <div className="absolute top-3 right-3 flex items-center gap-1.5">
                        <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" />
                        <span className="text-[10px] text-emerald-400 font-semibold uppercase tracking-wider">Live</span>
                      </div>
                      <div className={`w-11 h-11 rounded-xl bg-gradient-to-br ${t.color} flex items-center justify-center mb-4 group-hover:scale-110 transition-transform`}>
                        <t.icon className="w-5 h-5 text-white" />
                      </div>
                      <h3 className="text-sm font-bold text-white mb-1 group-hover:text-cyan-400 transition-colors">{t.title}</h3>
                      <p className="text-xs text-slate-500 mb-3">{t.desc}</p>
                      <span className="inline-flex items-center gap-1 text-[10px] font-semibold text-cyan-400 group-hover:gap-2 transition-all">
                        Deschide <ArrowRight className="w-3 h-3" />
                      </span>
                    </Link>
                  </motion.div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </section>
    </>
  )
}
