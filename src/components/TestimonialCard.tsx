import { motion } from 'framer-motion'
import { Star } from 'lucide-react'

interface Props {
  name: string
  role: string
  text: string
  stars: number
  delay?: number
}

export default function TestimonialCard({ name, role, text, stars, delay = 0 }: Props) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 30 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5, delay }}
      className="glass-card rounded-3xl p-6 lg:p-8"
    >
      <div className="flex gap-1 mb-4">
        {Array.from({ length: stars }).map((_, i) => (
          <Star key={i} className="w-4 h-4 text-amber-400 fill-amber-400" />
        ))}
      </div>
      <p className="text-sm text-slate-300 leading-relaxed mb-6 italic">"{text}"</p>
      <div className="flex items-center gap-3">
        <div className="w-10 h-10 rounded-full bg-gradient-to-br from-cyan-500/30 to-blue-600/30 flex items-center justify-center text-sm font-bold text-cyan-400">
          {name.charAt(0)}
        </div>
        <div>
          <p className="text-sm font-semibold text-white">{name}</p>
          <p className="text-xs text-slate-500">{role}</p>
        </div>
      </div>
    </motion.div>
  )
}
