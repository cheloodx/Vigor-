import { motion } from 'framer-motion'
import { LucideIcon } from 'lucide-react'

interface Props {
  icon: LucideIcon
  title: string
  description: string
  gradient: string
  delay?: number
}

export default function FeatureCard({ icon: Icon, title, description, gradient, delay = 0 }: Props) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 30 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5, delay, ease: [0.16, 1, 0.3, 1] }}
      className="glass-card rounded-3xl p-6 lg:p-8 group"
    >
      <div className={`w-14 h-14 rounded-2xl bg-gradient-to-br ${gradient} flex items-center justify-center mb-5 group-hover:scale-110 transition-transform duration-300`}>
        <Icon className="w-7 h-7 text-white" />
      </div>
      <h3 className="text-lg font-bold text-white mb-2 group-hover:text-cyan-400 transition-colors">{title}</h3>
      <p className="text-sm text-slate-400 leading-relaxed">{description}</p>
    </motion.div>
  )
}
