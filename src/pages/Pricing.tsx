import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { CheckCircle, X, Crown, Zap, Building2 } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import CTASection from '@/components/CTASection'

const plans = [
  {
    name: 'Free',
    price: '0',
    period: 'pentru totdeauna',
    desc: 'Perfect pentru utilizare personala.',
    icon: Zap,
    color: 'from-slate-500/30 to-slate-600/20',
    border: 'border-white/5',
    features: [
      [true, '5 scanari/luna'],
      [true, 'VIN Decoder'],
      [true, 'Decodor DTC'],
      [true, 'Chat AI (10 msg/zi)'],
      [true, 'Scor Sanatate'],
      [false, 'Predictor AI'],
      [false, 'Analiza Sunet'],
      [false, 'Rapoarte PDF'],
      [false, 'API Access'],
      [false, 'Suport prioritar'],
    ],
    cta: 'Incepe Gratuit',
    ctaClass: 'btn-secondary',
  },
  {
    name: 'PRO',
    price: '9.99',
    period: '/luna',
    desc: 'Pentru soferi care vor totul.',
    icon: Crown,
    color: 'from-cyan-500/30 to-blue-600/20',
    border: 'border-cyan-500/20',
    popular: true,
    features: [
      [true, 'Scanari nelimitate'],
      [true, 'VIN Decoder'],
      [true, 'Decodor DTC'],
      [true, 'Chat AI nelimitat'],
      [true, 'Scor Sanatate'],
      [true, 'Predictor AI'],
      [true, 'Analiza Sunet'],
      [true, 'Rapoarte PDF'],
      [false, 'API Access'],
      [true, 'Suport prioritar'],
    ],
    cta: 'Alege PRO',
    ctaClass: 'btn-primary',
  },
  {
    name: 'Business',
    price: '49.99',
    period: '/luna',
    desc: 'Pentru service-uri si flote.',
    icon: Building2,
    color: 'from-purple-500/30 to-pink-600/20',
    border: 'border-purple-500/20',
    features: [
      [true, 'Totul din PRO'],
      [true, 'Multi-utilizator (10)'],
      [true, 'Gestionare flota'],
      [true, 'Rapoarte cu branding'],
      [true, 'Dashboard analytics'],
      [true, 'Predictor AI avansat'],
      [true, 'Analiza Sunet PRO'],
      [true, 'Rapoarte PDF PRO'],
      [true, 'API Access complet'],
      [true, 'Suport 24/7 dedicat'],
    ],
    cta: 'Contacteaza-ne',
    ctaClass: 'btn-secondary',
  },
]

export default function Pricing() {
  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">Pricing</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-4">
            Planuri pentru <span className="gradient-text-static">Toti</span>
          </h1>
          <p className="text-lg text-slate-400">Incepe gratuit. Upgradeaza cand esti pregatit.</p>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-3 gap-6">
            {plans.map((p, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.1 }}
                className={`relative glass-card rounded-3xl p-8 ${p.border} ${p.popular ? 'glow-cyan ring-1 ring-cyan-500/20' : ''}`}
              >
                {p.popular && (
                  <div className="absolute -top-3 left-1/2 -translate-x-1/2 px-4 py-1 rounded-full bg-gradient-to-r from-cyan-500 to-blue-600 text-xs font-bold text-white">
                    Popular
                  </div>
                )}
                <div className={`w-12 h-12 rounded-2xl bg-gradient-to-br ${p.color} flex items-center justify-center mb-5`}>
                  <p.icon className="w-6 h-6 text-white" />
                </div>
                <h3 className="text-xl font-bold text-white mb-1">{p.name}</h3>
                <p className="text-sm text-slate-500 mb-5">{p.desc}</p>
                <div className="mb-6">
                  <span className="text-4xl font-black text-white">{p.price === '0' ? 'Gratuit' : `€${p.price}`}</span>
                  {p.price !== '0' && <span className="text-sm text-slate-500 ml-1">{p.period}</span>}
                </div>
                <div className="space-y-3 mb-8">
                  {p.features.map(([ok, text], j) => (
                    <div key={j} className="flex items-center gap-2.5">
                      {ok ? <CheckCircle className="w-4 h-4 text-emerald-400 shrink-0" /> : <X className="w-4 h-4 text-slate-600 shrink-0" />}
                      <span className={`text-sm ${ok ? 'text-slate-300' : 'text-slate-600'}`}>{text as string}</span>
                    </div>
                  ))}
                </div>
                <Link to={p.name === 'Business' ? '/contact' : '/pricing'} className={`${p.ctaClass} block text-center w-full px-6 py-3.5 text-sm`}>
                  {p.cta}
                </Link>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
