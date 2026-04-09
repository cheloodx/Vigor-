import { motion } from 'framer-motion'
import { ReactNode } from 'react'

interface Props {
  children: ReactNode
  className?: string
  id?: string
}

export default function SectionWrapper({ children, className = '', id }: Props) {
  return (
    <motion.section
      id={id}
      initial={{ opacity: 0, y: 40 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: '-80px' }}
      transition={{ duration: 0.7, ease: [0.16, 1, 0.3, 1] }}
      className={`relative py-20 lg:py-28 ${className}`}
    >
      {children}
    </motion.section>
  )
}
