import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { ArrowRight, Smartphone } from 'lucide-react'

export default function CTASection() {
  return (
    <section className="relative py-20 lg:py-28 overflow-hidden">
      <div className="absolute inset-0 hero-glow" />
      <div className="absolute inset-0 grid-bg opacity-50" />
      <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.7 }}
        >
          <div className="glass-bright rounded-[2rem] p-10 lg:p-16 glow-cyan">
            <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-cyan-500/20 to-blue-600/20 flex items-center justify-center mx-auto mb-6">
              <Smartphone className="w-8 h-8 text-cyan-400" />
            </div>
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-white mb-4">
              Incepe Diagnosticul <span className="gradient-text-static">Inteligent</span>
            </h2>
            <p className="text-lg text-slate-400 mb-8 max-w-xl mx-auto">
              Descarca aplicatia si descopera puterea AI-ului in diagnosticarea auto. Gratuit pentru totdeauna.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link to="/pricing" className="btn-primary px-8 py-4 text-base flex items-center gap-2">
                Incepe Gratuit <ArrowRight className="w-5 h-5" />
              </Link>
              <a href="#" className="btn-secondary px-8 py-4 text-base flex items-center gap-2">
                🍎 App Store
              </a>
              <a href="#" className="btn-secondary px-8 py-4 text-base flex items-center gap-2">
                ▶️ Google Play
              </a>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
