import { motion } from 'framer-motion'

interface Props {
  badge?: string
  title: string
  subtitle?: string
  center?: boolean
}

export default function SectionTitle({ badge, title, subtitle, center = true }: Props) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.6 }}
      className={`mb-12 lg:mb-16 ${center ? 'text-center' : ''}`}
    >
      {badge && (
        <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">
          {badge}
        </span>
      )}
      <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-white mb-4">
        {title}
      </h2>
      {subtitle && <p className="text-lg text-slate-400 max-w-2xl mx-auto">{subtitle}</p>}
    </motion.div>
  )
}
