import { useState } from 'react'
import { motion } from 'framer-motion'
import { Check, Star, Zap, Crown, ArrowLeft } from 'lucide-react'
import { Link } from 'react-router-dom'
import { loadStripe } from '@stripe/stripe-js'
import { useAuth } from '@/lib/auth'

const stripeKey = import.meta.env.VITE_STRIPE_PUBLIC_KEY || ''

const plans = [
  {
    name: 'Free',
    price: 0,
    priceAnnual: 0,
    icon: Star,
    color: 'from-slate-500 to-slate-600',
    badge: '',
    features: [
      'Decodor DTC - 5 cautari/zi',
      'VIN Decoder - 5 cautari/zi',
      'Suport comunitate',
      'Istoric ultimele 20 diagnostice',
      'Salvare max 3 vehicule',
    ],
    excluded: [
      'Chat Mecanic AI',
      'Foto Diagnostic',
      'Predictor AI',
      'Analiza Sunet',
      'AI European',
      'Recall Check',
      'Blockchain Passport',
      'Export PDF',
      'Dashboard multi-vehicul',
      'Suport prioritar',
    ],
    cta: 'Incepe Gratuit',
    ctaStyle: 'glass hover:bg-white/10 text-white',
    priceId: '',
    priceIdAnnual: '',
  },
  {
    name: 'Pro',
    price: 9.99,
    priceAnnual: 99.90,
    icon: Zap,
    color: 'from-emerald-500 to-teal-600',
    badge: 'POPULAR',
    features: [
      'Toate 9 uneltele - nelimitat',
      'Blockchain Vehicle Passport',
      'Chat Mecanic AI nelimitat',
      'Foto Diagnostic AI',
      'Predictor AI defectiuni',
      'Analiza Sunet motor',
      'AI European insights',
      'Recall Check complet',
      'Salvare vehicule nelimitat',
      'Istoric complet diagnostice',
    ],
    excluded: [
      'Export PDF rapoarte',
      'Dashboard multi-vehicul',
      'Suport prioritar',
    ],
    cta: 'Aboneaza-te Pro',
    ctaStyle: 'bg-gradient-to-r from-emerald-500 to-teal-500 hover:from-emerald-600 hover:to-teal-600 text-white shadow-lg shadow-emerald-500/25',
    priceId: 'price_pro_monthly',
    priceIdAnnual: 'price_pro_annual',
  },
  {
    name: 'Business',
    price: 29.99,
    priceAnnual: 299.90,
    icon: Crown,
    color: 'from-amber-500 to-yellow-600',
    badge: 'COMPLET',
    features: [
      'Tot ce include Pro',
      'Export PDF rapoarte complete',
      'Dashboard multi-vehicul',
      'Suport prioritar 24/7',
      'API access pentru integrari',
      'Rapoarte personalizate',
      'White-label options',
      'Gestiune flota vehicule',
      'Statistici avansate',
      'Training & onboarding',
    ],
    excluded: [],
    cta: 'Aboneaza-te Business',
    ctaStyle: 'bg-gradient-to-r from-amber-500 to-yellow-500 hover:from-amber-600 hover:to-yellow-600 text-black font-bold shadow-lg shadow-amber-500/25',
    priceId: 'price_business_monthly',
    priceIdAnnual: 'price_business_annual',
  },
]

export default function Pricing() {
  const [annual, setAnnual] = useState(false)
  const { user } = useAuth()

  const handleSubscribe = async (priceId: string) => {
    if (!priceId) {
      window.location.href = user ? '/tools' : '/register'
      return
    }
    if (!stripeKey) {
      window.location.href = '/register'
      return
    }
    try {
      const stripe = await loadStripe(stripeKey)
      if (!stripe) return
      // In production, create checkout session via backend
      // For now, redirect to registration
      window.location.href = user ? '/tools' : '/register'
    } catch {
      window.location.href = '/register'
    }
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
        </div>

        <div className="text-center mb-12">
          <h1 className="text-4xl sm:text-5xl font-black text-white mb-4">
            Alege planul <span className="gradient-text">potrivit</span>
          </h1>
          <p className="text-lg text-slate-400 max-w-2xl mx-auto mb-8">
            De la diagnostice de baza pana la gestiunea completa a flotei
          </p>

          <div className="inline-flex items-center gap-3 glass rounded-full p-1">
            <button onClick={() => setAnnual(false)} className={`px-6 py-2 rounded-full text-sm font-medium transition-all ${!annual ? 'bg-cyan-500 text-white' : 'text-slate-400 hover:text-white'}`}>
              Lunar
            </button>
            <button onClick={() => setAnnual(true)} className={`px-6 py-2 rounded-full text-sm font-medium transition-all ${annual ? 'bg-cyan-500 text-white' : 'text-slate-400 hover:text-white'}`}>
              Anual <span className="text-xs opacity-75">(-2 luni gratuit)</span>
            </button>
          </div>
        </div>

        <div className="grid md:grid-cols-3 gap-6">
          {plans.map((plan, i) => (
            <motion.div key={plan.name} initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.1 }}
              className={`glass-card rounded-3xl p-8 relative ${i === 1 ? 'ring-2 ring-emerald-500/50 scale-105' : ''}`}>
              {plan.badge && (
                <span className={`absolute -top-3 left-1/2 -translate-x-1/2 px-4 py-1 rounded-full text-xs font-bold ${i === 1 ? 'bg-emerald-500 text-white' : 'bg-amber-500 text-black'}`}>
                  {plan.badge}
                </span>
              )}

              <div className={`w-14 h-14 rounded-2xl bg-gradient-to-br ${plan.color} flex items-center justify-center mb-4`}>
                <plan.icon className="w-7 h-7 text-white" />
              </div>

              <h3 className="text-2xl font-bold text-white mb-1">{plan.name}</h3>
              <div className="flex items-end gap-1 mb-6">
                <span className="text-4xl font-black text-white">
                  {plan.price === 0 ? 'Gratuit' : `€${annual ? (plan.priceAnnual / 12).toFixed(2) : plan.price}`}
                </span>
                {plan.price > 0 && <span className="text-slate-500 mb-1">/luna</span>}
              </div>
              {annual && plan.price > 0 && (
                <p className="text-xs text-emerald-400 -mt-4 mb-4">€{plan.priceAnnual}/an (economisesti €{((plan.price * 12) - plan.priceAnnual).toFixed(2)})</p>
              )}

              <button onClick={() => handleSubscribe(annual ? plan.priceIdAnnual : plan.priceId)}
                className={`w-full px-6 py-3.5 rounded-2xl text-sm font-bold transition-all ${plan.ctaStyle}`}>
                {plan.cta}
              </button>

              <div className="mt-6 space-y-3">
                {plan.features.map((f, j) => (
                  <div key={j} className="flex items-start gap-2">
                    <Check className={`w-4 h-4 shrink-0 mt-0.5 ${i === 0 ? 'text-slate-400' : i === 1 ? 'text-emerald-400' : 'text-amber-400'}`} />
                    <span className="text-sm text-slate-300">{f}</span>
                  </div>
                ))}
                {plan.excluded.map((f, j) => (
                  <div key={j} className="flex items-start gap-2 opacity-40">
                    <span className="w-4 h-4 shrink-0 mt-0.5 text-center text-slate-600">-</span>
                    <span className="text-sm text-slate-500 line-through">{f}</span>
                  </div>
                ))}
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  )
}
