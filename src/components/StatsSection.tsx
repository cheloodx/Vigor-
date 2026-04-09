import { motion } from 'framer-motion'

const stats = [
  { value: '50+', label: 'Functii AI', color: 'text-cyan-400' },
  { value: '44', label: 'Tari Europene', color: 'text-blue-400' },
  { value: '108', label: 'Marci Auto', color: 'text-emerald-400' },
  { value: '99.8%', label: 'Acuratete', color: 'text-purple-400' },
]

export default function StatsSection() {
  return (
    <section className="relative py-16 border-y border-white/5">
      <div className="absolute inset-0 hero-glow opacity-30" />
      <div className="relative max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
          {stats.map((s, i) => (
            <motion.div
              key={i}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: i * 0.1 }}
              className="text-center"
            >
              <p className={`text-4xl lg:text-5xl font-black ${s.color}`}>{s.value}</p>
              <p className="text-sm text-slate-500 mt-1 font-medium">{s.label}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
