#!/usr/bin/env python3
"""Generate all source files for the AutoDiag Pro premium website."""
import os

BASE = "/home/ubuntu/autodiag-pro-website/src"

def w(path, content):
    full = os.path.join(BASE, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, 'w') as f:
        f.write(content)
    print(f"  wrote {path}")

# ============================================================
# components/Navbar.tsx
# ============================================================
w("components/Navbar.tsx", r'''import { useState, useEffect } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { Menu, X, Zap } from 'lucide-react'

const links = [
  { to: '/', label: 'Home' },
  { to: '/functionalitati', label: 'Functionalitati' },
  { to: '/cum-functioneaza', label: 'Cum Functioneaza' },
  { to: '/pentru-service', label: 'Pentru Service' },
  { to: '/pricing', label: 'Pricing' },
  { to: '/despre', label: 'Despre' },
  { to: '/contact', label: 'Contact' },
]

export default function Navbar() {
  const [scrolled, setScrolled] = useState(false)
  const [open, setOpen] = useState(false)
  const loc = useLocation()

  useEffect(() => {
    const h = () => setScrolled(window.scrollY > 20)
    window.addEventListener('scroll', h)
    return () => window.removeEventListener('scroll', h)
  }, [])

  useEffect(() => { setOpen(false) }, [loc.pathname])

  return (
    <motion.nav
      initial={{ y: -100 }}
      animate={{ y: 0 }}
      transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-500 ${scrolled ? 'glass border-b border-white/5 shadow-2xl shadow-black/20' : ''}`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 lg:h-20">
          <Link to="/" className="flex items-center gap-2.5 group">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center shadow-lg shadow-cyan-500/20 group-hover:shadow-cyan-500/40 transition-shadow">
              <Zap className="w-5 h-5 text-white" />
            </div>
            <span className="text-xl font-black tracking-tight">
              <span className="text-white">Auto</span>
              <span className="text-cyan-400">Diag</span>
              <span className="text-slate-500 font-medium text-sm ml-1">Pro</span>
            </span>
          </Link>

          <div className="hidden lg:flex items-center gap-1">
            {links.map(l => (
              <Link key={l.to} to={l.to}
                className={`px-4 py-2 rounded-xl text-sm font-medium transition-all duration-300 ${loc.pathname === l.to ? 'text-cyan-400 bg-cyan-500/10' : 'text-slate-400 hover:text-white hover:bg-white/5'}`}>
                {l.label}
              </Link>
            ))}
          </div>

          <div className="hidden lg:flex items-center gap-3">
            <Link to="/faq" className="text-sm text-slate-400 hover:text-white transition-colors px-3 py-2">FAQ</Link>
            <Link to="/pricing" className="btn-primary px-5 py-2.5 text-sm">Incepe Gratuit</Link>
          </div>

          <button onClick={() => setOpen(!open)} className="lg:hidden p-2 text-slate-400 hover:text-white transition-colors">
            {open ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </div>

      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="lg:hidden glass border-t border-white/5 overflow-hidden"
          >
            <div className="px-4 py-4 space-y-1">
              {links.map(l => (
                <Link key={l.to} to={l.to}
                  className={`block px-4 py-3 rounded-xl text-sm font-medium transition-all ${loc.pathname === l.to ? 'text-cyan-400 bg-cyan-500/10' : 'text-slate-400 hover:text-white hover:bg-white/5'}`}>
                  {l.label}
                </Link>
              ))}
              <Link to="/faq" className="block px-4 py-3 rounded-xl text-sm text-slate-400 hover:text-white">FAQ</Link>
              <div className="pt-3">
                <Link to="/pricing" className="btn-primary block text-center px-5 py-3 text-sm">Incepe Gratuit</Link>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.nav>
  )
}
''')

# ============================================================
# components/Footer.tsx
# ============================================================
w("components/Footer.tsx", r'''import { Link } from 'react-router-dom'
import { Zap, Github, Twitter, Linkedin, Mail } from 'lucide-react'

export default function Footer() {
  return (
    <footer className="relative border-t border-white/5 bg-slate-950">
      <div className="absolute inset-0 hero-glow opacity-30 pointer-events-none" />
      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 lg:py-20">
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-8 lg:gap-12">
          <div className="col-span-2 md:col-span-4 lg:col-span-1">
            <Link to="/" className="flex items-center gap-2.5 mb-4">
              <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center">
                <Zap className="w-5 h-5 text-white" />
              </div>
              <span className="text-lg font-black tracking-tight">
                <span className="text-white">Auto</span><span className="text-cyan-400">Diag</span>
              </span>
            </Link>
            <p className="text-sm text-slate-500 mb-6 max-w-xs">Platforma #1 de diagnostic auto inteligent cu AI din Europa.</p>
            <div className="flex gap-3">
              {[Twitter, Github, Linkedin, Mail].map((Icon, i) => (
                <a key={i} href="#" className="w-9 h-9 rounded-xl bg-white/5 border border-white/5 flex items-center justify-center text-slate-500 hover:text-cyan-400 hover:border-cyan-500/30 transition-all">
                  <Icon className="w-4 h-4" />
                </a>
              ))}
            </div>
          </div>
          <div>
            <h4 className="text-sm font-bold text-white mb-4 uppercase tracking-wider">Produs</h4>
            <div className="space-y-3">
              {[['Functionalitati','/functionalitati'],['Pricing','/pricing'],['Cum Functioneaza','/cum-functioneaza'],['FAQ','/faq']].map(([l,h]) => (
                <Link key={h} to={h} className="block text-sm text-slate-500 hover:text-cyan-400 transition-colors">{l}</Link>
              ))}
            </div>
          </div>
          <div>
            <h4 className="text-sm font-bold text-white mb-4 uppercase tracking-wider">Companie</h4>
            <div className="space-y-3">
              {[['Despre','/despre'],['Contact','/contact'],['Pentru Service','/pentru-service'],['Blog','#']].map(([l,h]) => (
                <Link key={h} to={h} className="block text-sm text-slate-500 hover:text-cyan-400 transition-colors">{l}</Link>
              ))}
            </div>
          </div>
          <div>
            <h4 className="text-sm font-bold text-white mb-4 uppercase tracking-wider">Legal</h4>
            <div className="space-y-3">
              {[['Termeni','/termeni'],['Confidentialitate','/termeni'],['Cookie-uri','/termeni'],['GDPR','/termeni']].map(([l,h],i) => (
                <Link key={i} to={h} className="block text-sm text-slate-500 hover:text-cyan-400 transition-colors">{l}</Link>
              ))}
            </div>
          </div>
          <div>
            <h4 className="text-sm font-bold text-white mb-4 uppercase tracking-wider">Download</h4>
            <div className="space-y-3">
              <a href="#" className="flex items-center gap-2 glass rounded-xl px-4 py-3 hover:border-cyan-500/30 transition-all group">
                <span className="text-xl">🍎</span>
                <div>
                  <p className="text-[10px] text-slate-500 leading-tight">Download pe</p>
                  <p className="text-xs font-bold text-white group-hover:text-cyan-400 transition-colors">App Store</p>
                </div>
              </a>
              <a href="#" className="flex items-center gap-2 glass rounded-xl px-4 py-3 hover:border-cyan-500/30 transition-all group">
                <span className="text-xl">▶️</span>
                <div>
                  <p className="text-[10px] text-slate-500 leading-tight">Download pe</p>
                  <p className="text-xs font-bold text-white group-hover:text-cyan-400 transition-colors">Google Play</p>
                </div>
              </a>
            </div>
          </div>
        </div>
        <div className="mt-16 pt-8 border-t border-white/5 flex flex-col sm:flex-row items-center justify-between gap-4">
          <p className="text-sm text-slate-600">&copy; {new Date().getFullYear()} AutoDiag Pro. Toate drepturile rezervate.</p>
          <p className="text-sm text-slate-600">Facut cu 💙 in Romania 🇷🇴</p>
        </div>
      </div>
    </footer>
  )
}
''')

# ============================================================
# components/Hero3D.tsx
# ============================================================
w("components/Hero3D.tsx", r'''import { useRef, useEffect } from 'react'
import * as THREE from 'three'

export default function Hero3D() {
  const mountRef = useRef<HTMLDivElement>(null)
  useEffect(() => {
    if (!mountRef.current) return
    const el = mountRef.current
    const scene = new THREE.Scene()
    scene.fog = new THREE.Fog(0x020617, 6, 22)
    const camera = new THREE.PerspectiveCamera(45, el.clientWidth / el.clientHeight, 0.1, 100)
    camera.position.set(4, 2.5, 6)
    camera.lookAt(0, 0, 0)
    const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true })
    renderer.setSize(el.clientWidth, el.clientHeight)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
    renderer.setClearColor(0x020617, 0)
    renderer.toneMapping = THREE.ACESFilmicToneMapping
    renderer.toneMappingExposure = 1.2
    el.appendChild(renderer.domElement)

    scene.add(new THREE.AmbientLight(0x334466, 0.4))
    const pl1 = new THREE.PointLight(0x00d4ff, 2, 30); pl1.position.set(5, 5, 5); scene.add(pl1)
    const pl2 = new THREE.PointLight(0xa855f7, 1, 30); pl2.position.set(-5, 3, -5); scene.add(pl2)
    const pl3 = new THREE.PointLight(0x10b981, 0.8, 30); pl3.position.set(0, -2, 4); scene.add(pl3)
    const pl4 = new THREE.PointLight(0x3b82f6, 0.6, 20); pl4.position.set(3, -1, -3); scene.add(pl4)

    const car = new THREE.Group()
    car.scale.setScalar(1.3)
    car.position.y = -0.2
    const mat1 = new THREE.MeshStandardMaterial({ color: 0x00d4ff, wireframe: true, transparent: true, opacity: 0.55 })
    const mat2 = new THREE.MeshStandardMaterial({ color: 0x00d4ff, wireframe: true, transparent: true, opacity: 0.4 })
    const body = new THREE.Mesh(new THREE.BoxGeometry(3, 0.5, 1.4), mat1); body.position.y = 0.35; car.add(body)
    const cabin = new THREE.Mesh(new THREE.BoxGeometry(1.5, 0.55, 1.25), mat2); cabin.position.set(0.15, 0.8, 0); car.add(cabin)
    const wMat = new THREE.MeshStandardMaterial({ color: 0x10b981, wireframe: true, transparent: true, opacity: 0.65 })
    for (const p of [[-1, 0, 0.7], [-1, 0, -0.7], [1, 0, 0.7], [1, 0, -0.7]]) {
      const w = new THREE.Mesh(new THREE.TorusGeometry(0.24, 0.09, 10, 20), wMat)
      w.position.set(p[0], p[1], p[2]); w.rotation.x = Math.PI / 2; car.add(w)
    }
    const hlMat = new THREE.MeshStandardMaterial({ color: 0xfbbf24, emissive: 0xfbbf24, emissiveIntensity: 3, wireframe: true })
    for (const p of [[1.5, 0.35, 0.48], [1.5, 0.35, -0.48]]) {
      const h = new THREE.Mesh(new THREE.SphereGeometry(0.1, 10, 10), hlMat); h.position.set(p[0], p[1], p[2]); car.add(h)
    }
    const tlMat = new THREE.MeshStandardMaterial({ color: 0xef4444, emissive: 0xef4444, emissiveIntensity: 2, wireframe: true })
    for (const p of [[-1.5, 0.35, 0.48], [-1.5, 0.35, -0.48]]) {
      const t = new THREE.Mesh(new THREE.SphereGeometry(0.08, 8, 8), tlMat); t.position.set(p[0], p[1], p[2]); car.add(t)
    }
    const chassis = new THREE.Mesh(new THREE.BoxGeometry(3.2, 0.04, 1.5), new THREE.MeshStandardMaterial({ color: 0x3b82f6, wireframe: true, transparent: true, opacity: 0.2 }))
    chassis.position.y = 0.1; car.add(chassis)
    const eng = new THREE.Mesh(new THREE.BoxGeometry(0.7, 0.35, 0.7), new THREE.MeshStandardMaterial({ color: 0xa855f7, wireframe: true, transparent: true, opacity: 0.35 }))
    eng.position.set(1.1, 0.45, 0); car.add(eng)
    scene.add(car)

    const grid = new THREE.Mesh(new THREE.PlaneGeometry(40, 40, 40, 40), new THREE.MeshStandardMaterial({ color: 0x0a1628, wireframe: true, transparent: true, opacity: 0.1 }))
    grid.rotation.x = -Math.PI / 2; grid.position.y = -0.6; scene.add(grid)

    const pGeo = new THREE.BufferGeometry()
    const pPos = new Float32Array(500 * 3)
    const pCol = new Float32Array(500 * 3)
    for (let i = 0; i < 500; i++) {
      pPos[i*3] = (Math.random()-0.5)*25; pPos[i*3+1] = (Math.random()-0.5)*12; pPos[i*3+2] = (Math.random()-0.5)*25
      const c = new THREE.Color().setHSL(0.5 + Math.random() * 0.2, 0.8, 0.6)
      pCol[i*3] = c.r; pCol[i*3+1] = c.g; pCol[i*3+2] = c.b
    }
    pGeo.setAttribute('position', new THREE.BufferAttribute(pPos, 3))
    pGeo.setAttribute('color', new THREE.BufferAttribute(pCol, 3))
    const particles = new THREE.Points(pGeo, new THREE.PointsMaterial({ size: 0.03, vertexColors: true, transparent: true, opacity: 0.5, sizeAttenuation: true }))
    scene.add(particles)

    for (let i = 0; i < 3; i++) {
      const ring = new THREE.Mesh(new THREE.TorusGeometry(2.5 + i * 0.8, 0.005, 16, 100), new THREE.MeshStandardMaterial({ color: 0x00d4ff, transparent: true, opacity: 0.08 + i * 0.02 }))
      ring.rotation.x = Math.PI / 2.5 + i * 0.15; ring.rotation.z = i * 0.3; scene.add(ring)
    }

    let angle = 0, animId = 0
    const animate = () => {
      animId = requestAnimationFrame(animate)
      const t = Date.now() * 0.001
      angle += 0.003
      car.rotation.y += 0.002
      car.position.y = -0.2 + Math.sin(t) * 0.08
      particles.rotation.y += 0.0002
      particles.rotation.x = Math.sin(t * 0.2) * 0.02
      pl1.position.x = Math.sin(t * 0.5) * 6
      pl2.position.z = Math.cos(t * 0.3) * 6
      camera.position.x = 6 * Math.cos(angle)
      camera.position.z = 6 * Math.sin(angle)
      camera.position.y = 2.5 + Math.sin(t * 0.3) * 0.3
      camera.lookAt(0, 0, 0)
      renderer.render(scene, camera)
    }
    animate()

    const onResize = () => { camera.aspect = el.clientWidth / el.clientHeight; camera.updateProjectionMatrix(); renderer.setSize(el.clientWidth, el.clientHeight) }
    window.addEventListener('resize', onResize)
    return () => { cancelAnimationFrame(animId); window.removeEventListener('resize', onResize); if (el.contains(renderer.domElement)) el.removeChild(renderer.domElement); renderer.dispose() }
  }, [])
  return <div ref={mountRef} className="absolute inset-0" />
}
''')

# ============================================================
# components/SectionWrapper.tsx
# ============================================================
w("components/SectionWrapper.tsx", r'''import { motion } from 'framer-motion'
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
''')

# ============================================================
# components/FeatureCard.tsx
# ============================================================
w("components/FeatureCard.tsx", r'''import { motion } from 'framer-motion'
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
''')

# ============================================================
# components/SectionTitle.tsx
# ============================================================
w("components/SectionTitle.tsx", r'''import { motion } from 'framer-motion'

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
''')

# ============================================================
# components/CTASection.tsx
# ============================================================
w("components/CTASection.tsx", r'''import { motion } from 'framer-motion'
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
''')

# ============================================================
# components/TestimonialCard.tsx
# ============================================================
w("components/TestimonialCard.tsx", r'''import { motion } from 'framer-motion'
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
''')

# ============================================================
# components/StatsSection.tsx
# ============================================================
w("components/StatsSection.tsx", r'''import { motion } from 'framer-motion'

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
''')

print("Components done!")

# ============================================================
# pages/Home.tsx
# ============================================================
w("pages/Home.tsx", r'''import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { ArrowRight, Shield, Cpu, Scan, Wrench, Car, BarChart3, Globe, Mic, Camera, Brain, AlertTriangle, Gauge, Sparkles, Clock, CheckCircle } from 'lucide-react'
import Hero3D from '@/components/Hero3D'
import SectionWrapper from '@/components/SectionWrapper'
import SectionTitle from '@/components/SectionTitle'
import FeatureCard from '@/components/FeatureCard'
import TestimonialCard from '@/components/TestimonialCard'
import StatsSection from '@/components/StatsSection'
import CTASection from '@/components/CTASection'

export default function Home() {
  return (
    <>
      {/* HERO */}
      <section className="relative min-h-screen flex items-center overflow-hidden">
        <Hero3D />
        <div className="absolute inset-0 grid-bg pointer-events-none" />
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-32">
          <div className="max-w-3xl">
            <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.8, delay: 0.2 }}>
              <span className="inline-block mb-6 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">
                Platforma #1 in Europa
              </span>
            </motion.div>
            <motion.h1
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.3 }}
              className="text-5xl sm:text-6xl lg:text-7xl xl:text-8xl font-black tracking-tighter mb-6 text-glow"
            >
              <span className="gradient-text">Diagnostic Auto</span><br />
              <span className="text-white">cu Inteligenta</span><br />
              <span className="text-white">Artificiala</span>
            </motion.h1>
            <motion.p
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.4 }}
              className="text-lg sm:text-xl text-slate-400 mb-8 max-w-xl leading-relaxed"
            >
              Scaneaza, diagnosticheaza si repara masina ta folosind AI avansat. 50+ functii, 108 marci auto, disponibil in 44 tari.
            </motion.p>
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8, delay: 0.5 }}
              className="flex flex-col sm:flex-row gap-4"
            >
              <Link to="/pricing" className="btn-primary px-8 py-4 text-base flex items-center justify-center gap-2">
                Incepe Gratuit <ArrowRight className="w-5 h-5" />
              </Link>
              <Link to="/cum-functioneaza" className="btn-secondary px-8 py-4 text-base flex items-center justify-center gap-2">
                Cum Functioneaza
              </Link>
            </motion.div>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.8, delay: 0.7 }}
              className="flex items-center gap-6 mt-8"
            >
              <div className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-emerald-400" /><span className="text-sm text-slate-500">Gratuit pentru totdeauna</span></div>
              <div className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-emerald-400" /><span className="text-sm text-slate-500">Fara card bancar</span></div>
              <div className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-emerald-400" /><span className="text-sm text-slate-500">GDPR compliant</span></div>
            </motion.div>
          </div>
        </div>
        <div className="absolute bottom-10 left-1/2 -translate-x-1/2 animate-bounce hidden lg:flex flex-col items-center gap-2 z-10">
          <span className="text-slate-600 text-xs tracking-widest uppercase font-medium">Descopera</span>
          <div className="w-6 h-10 border-2 border-slate-700 rounded-full flex justify-center pt-2"><div className="w-1.5 h-2.5 bg-cyan-500 rounded-full animate-pulse" /></div>
        </div>
      </section>

      <StatsSection />

      {/* FEATURES HIGHLIGHT */}
      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Functionalitati" title="Tot ce ai nevoie pentru masina ta" subtitle="De la diagnostic simplu la predictii AI avansate — totul intr-o singura aplicatie." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
            <FeatureCard icon={Scan} title="Foto Diagnostic" description="Fotografiaza componenta si primesti diagnostic instant cu AI." gradient="from-cyan-500/30 to-blue-600/20" delay={0} />
            <FeatureCard icon={Brain} title="Mecanic AI Pro" description="Chat inteligent cu context — intreaba orice despre masina ta." gradient="from-purple-500/30 to-pink-600/20" delay={0.05} />
            <FeatureCard icon={AlertTriangle} title="Decodor DTC" description="Introdu codul de eroare OBD2 si afla cauza si solutia." gradient="from-amber-500/30 to-orange-600/20" delay={0.1} />
            <FeatureCard icon={Gauge} title="Predictor AI" description="Afla ce se poate strica in urmatoarele 3-6 luni." gradient="from-red-500/30 to-rose-600/20" delay={0.15} />
            <FeatureCard icon={Mic} title="Analiza Sunet" description="Inregistreaza sunetul motorului si AI-ul detecteaza problemele." gradient="from-teal-500/30 to-emerald-600/20" delay={0.2} />
            <FeatureCard icon={Globe} title="AI European" description="Date si insights pentru 44 de tari europene si 108 marci." gradient="from-emerald-500/30 to-green-600/20" delay={0.25} />
            <FeatureCard icon={Shield} title="Recall Service" description="Verifica campaniile de rechemare active pentru masina ta." gradient="from-blue-500/30 to-indigo-600/20" delay={0.3} />
            <FeatureCard icon={Car} title="VIN Decoder" description="Decodifica seria de sasiu si afla istoricul complet." gradient="from-indigo-500/30 to-violet-600/20" delay={0.35} />
          </div>
          <div className="text-center mt-10">
            <Link to="/functionalitati" className="btn-secondary px-8 py-3.5 text-sm inline-flex items-center gap-2">
              Vezi Toate Functiile <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        </div>
      </SectionWrapper>

      {/* HOW IT WORKS */}
      <SectionWrapper className="border-t border-white/5">
        <div className="absolute inset-0 hero-glow opacity-30 pointer-events-none" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Simplu" title="Cum functioneaza?" subtitle="3 pasi simpli — de la scan la diagnostic complet." />
          <div className="grid md:grid-cols-3 gap-8">
            {[
              { step: '01', icon: Camera, title: 'Scaneaza', desc: 'Fotografiaza componenta, introdu VIN-ul sau codul de eroare.', color: 'from-cyan-500 to-blue-600' },
              { step: '02', icon: Cpu, title: 'Analizeaza', desc: 'AI-ul proceseaza datele si identifica problemele in secunde.', color: 'from-blue-500 to-purple-600' },
              { step: '03', icon: Wrench, title: 'Repara', desc: 'Primesti diagnosticul complet, costuri estimate si recomandari.', color: 'from-purple-500 to-pink-600' },
            ].map((s, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: i * 0.15 }}
                className="relative glass-card rounded-3xl p-8 text-center"
              >
                <span className="absolute -top-4 left-6 text-6xl font-black text-white/[0.03]">{s.step}</span>
                <div className={`w-16 h-16 rounded-2xl bg-gradient-to-br ${s.color} flex items-center justify-center mx-auto mb-5`}>
                  <s.icon className="w-8 h-8 text-white" />
                </div>
                <h3 className="text-xl font-bold text-white mb-3">{s.title}</h3>
                <p className="text-sm text-slate-400 leading-relaxed">{s.desc}</p>
                {i < 2 && <div className="hidden md:block absolute top-1/2 -right-4 w-8 text-slate-700"><ArrowRight className="w-8 h-8" /></div>}
              </motion.div>
            ))}
          </div>
          <div className="text-center mt-10">
            <Link to="/cum-functioneaza" className="btn-secondary px-8 py-3.5 text-sm inline-flex items-center gap-2">
              Afla Mai Multe <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        </div>
      </SectionWrapper>

      {/* TESTIMONIALS */}
      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Testimoniale" title="Ce spun utilizatorii" subtitle="Peste 10,000 de soferi si mecanici folosesc AutoDiag Pro zilnic." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
            <TestimonialCard name="Mihai Popescu" role="Sofer, Bucuresti" text="Am detectat o problema la distributie inainte sa se strice. M-a salvat de o reparatie de 2000 EUR!" stars={5} delay={0} />
            <TestimonialCard name="Ana Gheorghe" role="Mecanic Auto, Cluj" text="Folosesc zilnic pentru clienti. Predictiile AI sunt incredibil de precise. Recomand!" stars={5} delay={0.1} />
            <TestimonialCard name="Radu Ionescu" role="Service Auto, Timisoara" text="Cea mai buna aplicatie de diagnostic pe care am folosit-o. Suportul pentru 44 de tari e genial." stars={5} delay={0.2} />
          </div>
        </div>
      </SectionWrapper>

      {/* FOR MECHANICS */}
      <SectionWrapper className="border-t border-white/5">
        <div className="absolute inset-0 hero-glow opacity-20 pointer-events-none" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-emerald-400 tracking-widest uppercase">
                Pentru Profesionisti
              </span>
              <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-white mb-6">
                Solutia pentru <span className="gradient-text-static">Service-uri Auto</span>
              </h2>
              <p className="text-lg text-slate-400 mb-8 leading-relaxed">
                Dashboard dedicat pentru mecanici si service-uri. Gestioneaza clienti, diagnostic AI in bulk, rapoarte profesionale si multe altele.
              </p>
              <div className="space-y-4 mb-8">
                {[
                  'Diagnostic AI pentru clienti in timp real',
                  'Rapoarte PDF profesionale cu branding propriu',
                  'Gestionare flota de vehicule',
                  'API integration pentru sisteme existente',
                ].map((t, i) => (
                  <div key={i} className="flex items-center gap-3">
                    <div className="w-6 h-6 rounded-full bg-emerald-500/20 flex items-center justify-center shrink-0">
                      <CheckCircle className="w-4 h-4 text-emerald-400" />
                    </div>
                    <span className="text-sm text-slate-300">{t}</span>
                  </div>
                ))}
              </div>
              <Link to="/pentru-service" className="btn-primary px-8 py-4 text-base inline-flex items-center gap-2">
                Afla Mai Multe <ArrowRight className="w-5 h-5" />
              </Link>
            </div>
            <div className="relative">
              <div className="glass-bright rounded-3xl p-8 glow-cyan">
                <div className="space-y-4">
                  {[
                    { icon: BarChart3, label: 'Diagnostic completat', val: '2,847', color: 'text-cyan-400' },
                    { icon: Clock, label: 'Timp mediu salvat', val: '45 min', color: 'text-emerald-400' },
                    { icon: Sparkles, label: 'Acuratete AI', val: '99.8%', color: 'text-purple-400' },
                    { icon: Car, label: 'Vehicule gestionate', val: '1,205', color: 'text-blue-400' },
                  ].map((s, i) => (
                    <motion.div
                      key={i}
                      initial={{ opacity: 0, x: 20 }}
                      whileInView={{ opacity: 1, x: 0 }}
                      viewport={{ once: true }}
                      transition={{ duration: 0.5, delay: i * 0.1 }}
                      className="glass rounded-2xl p-4 flex items-center justify-between"
                    >
                      <div className="flex items-center gap-3">
                        <s.icon className="w-5 h-5 text-slate-500" />
                        <span className="text-sm text-slate-400">{s.label}</span>
                      </div>
                      <span className={`text-lg font-black ${s.color}`}>{s.val}</span>
                    </motion.div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
''')

print("Home page done!")

# ============================================================
# pages/Features.tsx
# ============================================================
w("pages/Features.tsx", r'''import { Link } from 'react-router-dom'
import { Scan, Brain, AlertTriangle, Gauge, Mic, Globe, Shield, Car, Camera, Wrench, Bell, Map, Fuel, DollarSign, FileText, Scale, Users, Crown, Watch, Smartphone, Moon, BarChart3, Lock, Activity, Cpu, Zap, Eye, Layers, Radio, MessageSquare, ArrowRight } from 'lucide-react'
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
''')

print("Features page done!")

# ============================================================
# pages/HowItWorks.tsx
# ============================================================
w("pages/HowItWorks.tsx", r'''import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Camera, Cpu, Wrench, ArrowRight, ArrowDown, Scan, AlertTriangle, Brain, Mic, Car, Shield, Globe, CheckCircle } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import SectionTitle from '@/components/SectionTitle'
import CTASection from '@/components/CTASection'

const steps = [
  { step: '01', icon: Camera, title: 'Scaneaza sau Descrie', desc: 'Fotografiaza componenta, introdu VIN-ul, un cod de eroare DTC, sau pur si simplu descrie problema in chat-ul AI.', color: 'from-cyan-500 to-blue-600', items: ['Foto scan cu camera', 'VIN decoder automat', 'Cod eroare OBD2', 'Descriere vocala'] },
  { step: '02', icon: Cpu, title: 'AI Analizeaza', desc: 'Motorul nostru AI proceseaza datele in milisecunde, comparand cu baza de date de 108 marci auto si milioane de cazuri.', color: 'from-blue-500 to-purple-600', items: ['Machine Learning avansat', 'Baza de date 108 marci', '44 tari europene', 'Milioane de cazuri'] },
  { step: '03', icon: Wrench, title: 'Primesti Diagnostic', desc: 'Afli exact ce problema are masina, cauzele posibile, severitatea, costul estimat si pasii de reparatie.', color: 'from-purple-500 to-pink-600', items: ['Diagnostic detaliat', 'Cauze si solutii', 'Cost estimat', 'Ghid reparatie AR'] },
  { step: '04', icon: Shield, title: 'Actioneaza', desc: 'Gaseste mecanici verificati, compara preturi, programeaza service sau exporta raportul PDF.', color: 'from-emerald-500 to-teal-600', items: ['Mecanici verificati', 'Comparator preturi', 'Programare service', 'Export raport PDF'] },
]

const useCases = [
  { icon: Scan, title: 'Foto Scan', desc: 'Fotografiezi o pata de ulei sub motor. AI-ul identifica: scurgere carter ulei, severitate medie, cost 150-300 EUR.' },
  { icon: AlertTriangle, title: 'Cod Eroare', desc: 'Introdu P0300. AI-ul explica: rateu de aprindere multiplu, cauze: bujii, bobine, injectoare. Cost: 50-400 EUR.' },
  { icon: Brain, title: 'Chat AI', desc: 'Intrebi: "De ce trepideaza motorul?" AI-ul raspunde cu 5 cauze posibile in ordine, costuri si urgenta.' },
  { icon: Mic, title: 'Sunet Motor', desc: 'Inregistrezi 5 secunde. AI-ul detecteaza: bataie in motor zona superioara, posibil tacheti. Urgenta: medie.' },
  { icon: Car, title: 'VIN Check', desc: 'Introdu VIN-ul. Afli: marca, model, motor, transmisie, tara fabricatie, recall-uri active, probleme frecvente.' },
  { icon: Globe, title: 'Insights EU', desc: 'Selectezi BMW + Romania. Afli: fiabilitate 87%, cost mediu/an 1200 EUR, probleme frecvente, piese cele mai inlocuite.' },
]

export default function HowItWorks() {
  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">Simplu si Rapid</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-4">
            Cum <span className="gradient-text-static">Functioneaza</span>
          </h1>
          <p className="text-lg text-slate-400 max-w-2xl mx-auto">De la scan la diagnostic complet in cateva secunde. Iata procesul pas cu pas.</p>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="space-y-8">
            {steps.map((s, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.6, delay: i * 0.1 }}>
                <div className="glass-card rounded-3xl p-8 lg:p-10">
                  <div className="flex flex-col lg:flex-row gap-8 items-start">
                    <div className={`w-20 h-20 rounded-2xl bg-gradient-to-br ${s.color} flex items-center justify-center shrink-0`}>
                      <s.icon className="w-10 h-10 text-white" />
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-3">
                        <span className="text-xs font-bold text-cyan-400 tracking-widest uppercase">Pasul {s.step}</span>
                      </div>
                      <h3 className="text-2xl font-black text-white mb-3">{s.title}</h3>
                      <p className="text-slate-400 leading-relaxed mb-6">{s.desc}</p>
                      <div className="grid grid-cols-2 gap-3">
                        {s.items.map((item, j) => (
                          <div key={j} className="flex items-center gap-2">
                            <CheckCircle className="w-4 h-4 text-emerald-400 shrink-0" />
                            <span className="text-sm text-slate-300">{item}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
                {i < steps.length - 1 && (
                  <div className="flex justify-center py-4"><ArrowDown className="w-6 h-6 text-slate-700" /></div>
                )}
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <SectionWrapper className="border-t border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Exemple" title="Exemple Practice" subtitle="Iata cum folosesc oamenii AutoDiag Pro in viata reala." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {useCases.map((uc, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.08 }} className="glass-card rounded-3xl p-6 lg:p-8">
                <uc.icon className="w-8 h-8 text-cyan-400 mb-4" />
                <h3 className="text-lg font-bold text-white mb-2">{uc.title}</h3>
                <p className="text-sm text-slate-400 leading-relaxed">{uc.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
''')

print("HowItWorks page done!")

# ============================================================
# pages/ForService.tsx
# ============================================================
w("pages/ForService.tsx", r'''import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { ArrowRight, CheckCircle, BarChart3, Users, FileText, Zap, Shield, Clock, Car, Cpu, Globe, DollarSign, Wrench, Layers } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import SectionTitle from '@/components/SectionTitle'
import FeatureCard from '@/components/FeatureCard'
import CTASection from '@/components/CTASection'

export default function ForService() {
  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-emerald-400 tracking-widest uppercase">
                Pentru Profesionisti
              </span>
              <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-6">
                Diagnostic AI pentru <span className="gradient-text-static">Service-uri Auto</span>
              </h1>
              <p className="text-lg text-slate-400 mb-8 leading-relaxed">
                Creste-ti productivitatea cu 300%. Diagnostic AI in timp real, rapoarte profesionale si gestionare completa a flotei de vehicule.
              </p>
              <div className="flex flex-col sm:flex-row gap-4">
                <Link to="/contact" className="btn-primary px-8 py-4 text-base flex items-center justify-center gap-2">
                  Cere Demo Gratuit <ArrowRight className="w-5 h-5" />
                </Link>
                <Link to="/pricing" className="btn-secondary px-8 py-4 text-base flex items-center justify-center gap-2">
                  Vezi Planurile PRO
                </Link>
              </div>
            </div>
            <div className="glass-bright rounded-3xl p-8 glow-cyan">
              <div className="grid grid-cols-2 gap-4">
                {[
                  { icon: BarChart3, val: '+300%', label: 'Productivitate', color: 'text-cyan-400' },
                  { icon: Clock, val: '-45 min', label: 'Timp/diagnostic', color: 'text-emerald-400' },
                  { icon: DollarSign, val: '+40%', label: 'Revenue', color: 'text-purple-400' },
                  { icon: Users, val: '10,000+', label: 'Mecanici activi', color: 'text-blue-400' },
                ].map((s, i) => (
                  <motion.div key={i} initial={{ opacity: 0, scale: 0.9 }} whileInView={{ opacity: 1, scale: 1 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass rounded-2xl p-5 text-center">
                    <s.icon className="w-6 h-6 text-slate-500 mx-auto mb-2" />
                    <p className={`text-2xl font-black ${s.color}`}>{s.val}</p>
                    <p className="text-xs text-slate-500 mt-1">{s.label}</p>
                  </motion.div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Functii PRO" title="Tot ce ai nevoie ca profesionist" subtitle="Unelte dedicate pentru service-uri auto, mecanici independenti si flote de vehicule." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
            <FeatureCard icon={Cpu} title="Diagnostic AI Bulk" description="Diagnosticheaza multiple vehicule simultan cu AI avansat." gradient="from-cyan-500/30 to-blue-600/20" delay={0} />
            <FeatureCard icon={FileText} title="Rapoarte PDF PRO" description="Genereaza rapoarte profesionale cu branding-ul tau propriu." gradient="from-blue-500/30 to-indigo-600/20" delay={0.05} />
            <FeatureCard icon={Car} title="Gestionare Flota" description="Dashboard complet pentru monitorizarea flotei de vehicule." gradient="from-emerald-500/30 to-green-600/20" delay={0.1} />
            <FeatureCard icon={Layers} title="API Integration" description="Integreaza AutoDiag Pro in sistemele tale existente via API." gradient="from-purple-500/30 to-pink-600/20" delay={0.15} />
            <FeatureCard icon={Globe} title="Multi-Tara" description="Suport pentru 44 de tari europene cu legislatie specifica." gradient="from-teal-500/30 to-emerald-600/20" delay={0.2} />
            <FeatureCard icon={Shield} title="Prioritate Suport" description="Suport tehnic prioritar 24/7 cu timp de raspuns sub 1 ora." gradient="from-amber-500/30 to-orange-600/20" delay={0.25} />
          </div>
        </div>
      </SectionWrapper>

      <SectionWrapper className="border-t border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Workflow" title="Cum functioneaza pentru tine" />
          <div className="grid md:grid-cols-4 gap-6">
            {[
              { step: '1', title: 'Clientul vine', desc: 'Clientul aduce masina cu o problema.', icon: Car },
              { step: '2', title: 'Scan AI', desc: 'Scanezi cu AutoDiag Pro in 30 secunde.', icon: Zap },
              { step: '3', title: 'Diagnostic', desc: 'AI-ul genereaza diagnostic complet cu cauze si costuri.', icon: Cpu },
              { step: '4', title: 'Raport PRO', desc: 'Trimiti raportul profesional clientului.', icon: FileText },
            ].map((s, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass-card rounded-3xl p-6 text-center">
                <div className="w-12 h-12 rounded-full bg-gradient-to-br from-cyan-500/20 to-blue-600/20 flex items-center justify-center mx-auto mb-4">
                  <span className="text-lg font-black text-cyan-400">{s.step}</span>
                </div>
                <s.icon className="w-6 h-6 text-slate-500 mx-auto mb-3" />
                <h3 className="font-bold text-white mb-2">{s.title}</h3>
                <p className="text-sm text-slate-400">{s.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
''')

print("ForService page done!")

# ============================================================
# pages/About.tsx
# ============================================================
w("pages/About.tsx", r'''import { motion } from 'framer-motion'
import { Zap, Target, Heart, Globe, Shield, Users, Award, Cpu } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import SectionTitle from '@/components/SectionTitle'
import StatsSection from '@/components/StatsSection'
import CTASection from '@/components/CTASection'

export default function About() {
  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">Despre Noi</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-6">
            Misiunea noastra: <span className="gradient-text-static">Diagnostic Auto Accesibil</span>
          </h1>
          <p className="text-lg text-slate-400 leading-relaxed">
            AutoDiag Pro a fost creat cu o viziune simpla: fiecare sofer si mecanic trebuie sa aiba acces la diagnostic auto inteligent, rapid si accesibil. Folosim cele mai avansate tehnologii AI pentru a democratiza diagnosticul auto in Europa.
          </p>
        </div>
      </section>

      <StatsSection />

      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Valorile Noastre" title="Ce ne defineste" />
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { icon: Target, title: 'Precizie', desc: 'Acuratete de 99.8% in diagnostic, bazata pe milioane de cazuri reale.', color: 'from-cyan-500/30 to-blue-600/20' },
              { icon: Heart, title: 'Pasiune', desc: 'Iubim masinile si tehnologia. Fiecare functie e facuta cu grija.', color: 'from-red-500/30 to-rose-600/20' },
              { icon: Globe, title: 'Accesibilitate', desc: 'Disponibil in 44 de tari europene, in limba locala.', color: 'from-emerald-500/30 to-green-600/20' },
              { icon: Shield, title: 'Incredere', desc: 'GDPR compliant, date criptate, confidentialitate maxima.', color: 'from-purple-500/30 to-indigo-600/20' },
            ].map((v, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass-card rounded-3xl p-6 text-center">
                <div className={`w-14 h-14 rounded-2xl bg-gradient-to-br ${v.color} flex items-center justify-center mx-auto mb-5`}>
                  <v.icon className="w-7 h-7 text-white" />
                </div>
                <h3 className="text-lg font-bold text-white mb-2">{v.title}</h3>
                <p className="text-sm text-slate-400 leading-relaxed">{v.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <SectionWrapper className="border-t border-white/5">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <SectionTitle badge="Echipa" title="Facut de ingineri pasionati" subtitle="O echipa dedicata de ingineri AI, mecanici auto si designeri." />
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { name: 'Echipa AI', role: '5 ingineri ML/AI', icon: Cpu },
              { name: 'Echipa Auto', role: '3 mecanici certificati', icon: Zap },
              { name: 'Echipa Design', role: '2 UX/UI designeri', icon: Award },
              { name: 'Echipa Suport', role: 'Suport 24/7', icon: Users },
            ].map((m, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass-card rounded-3xl p-6 text-center">
                <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-cyan-500/10 to-blue-600/10 flex items-center justify-center mx-auto mb-4">
                  <m.icon className="w-8 h-8 text-cyan-400" />
                </div>
                <h3 className="font-bold text-white mb-1">{m.name}</h3>
                <p className="text-sm text-slate-500">{m.role}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
''')

print("About page done!")

# ============================================================
# pages/Contact.tsx
# ============================================================
w("pages/Contact.tsx", r'''import { useState } from 'react'
import { motion } from 'framer-motion'
import { Mail, Phone, MapPin, Send, CheckCircle, MessageSquare, Clock, Globe } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'

export default function Contact() {
  const [sent, setSent] = useState(false)
  const [form, setForm] = useState({ name: '', email: '', subject: '', message: '' })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setSent(true)
    setTimeout(() => setSent(false), 3000)
  }

  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">Contact</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-4">
            Hai sa <span className="gradient-text-static">Vorbim</span>
          </h1>
          <p className="text-lg text-slate-400">Suntem aici sa te ajutam. Raspundem in mai putin de 24 de ore.</p>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-5 gap-10">
            <div className="lg:col-span-2 space-y-6">
              {[
                { icon: Mail, title: 'Email', info: 'contact@autodiagpro.com' },
                { icon: Phone, title: 'Telefon', info: '+40 721 000 000' },
                { icon: MapPin, title: 'Sediu', info: 'Bucuresti, Romania' },
                { icon: Clock, title: 'Program', info: 'Luni - Vineri, 9:00 - 18:00' },
              ].map((c, i) => (
                <motion.div key={i} initial={{ opacity: 0, x: -20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ duration: 0.5, delay: i * 0.1 }} className="glass-card rounded-2xl p-5 flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-cyan-500/20 to-blue-600/20 flex items-center justify-center shrink-0">
                    <c.icon className="w-5 h-5 text-cyan-400" />
                  </div>
                  <div>
                    <p className="text-sm text-slate-500 font-medium">{c.title}</p>
                    <p className="text-white font-semibold">{c.info}</p>
                  </div>
                </motion.div>
              ))}
              <div className="glass-card rounded-2xl p-5">
                <div className="flex items-center gap-3 mb-3">
                  <MessageSquare className="w-5 h-5 text-emerald-400" />
                  <span className="font-semibold text-white">Live Chat</span>
                </div>
                <p className="text-sm text-slate-400 mb-4">Disponibil in aplicatie 24/7</p>
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" />
                  <span className="text-xs text-emerald-400">Online acum</span>
                </div>
              </div>
            </div>
            <div className="lg:col-span-3">
              <motion.form
                onSubmit={handleSubmit}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                className="glass-bright rounded-3xl p-8 glow-cyan"
              >
                <h3 className="text-xl font-bold text-white mb-6">Trimite-ne un mesaj</h3>
                <div className="grid sm:grid-cols-2 gap-4 mb-4">
                  <input type="text" placeholder="Numele tau" value={form.name} onChange={e => setForm({...form, name: e.target.value})} className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 transition-all" />
                  <input type="email" placeholder="Email" value={form.email} onChange={e => setForm({...form, email: e.target.value})} className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 transition-all" />
                </div>
                <input type="text" placeholder="Subiect" value={form.subject} onChange={e => setForm({...form, subject: e.target.value})} className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 transition-all mb-4" />
                <textarea placeholder="Mesajul tau..." rows={5} value={form.message} onChange={e => setForm({...form, message: e.target.value})} className="w-full bg-white/5 border border-white/10 rounded-2xl px-4 py-3.5 text-sm text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none focus:ring-2 focus:ring-cyan-500/20 transition-all resize-none mb-6" />
                <button type="submit" className="btn-primary w-full px-8 py-4 text-base flex items-center justify-center gap-2">
                  {sent ? <><CheckCircle className="w-5 h-5" /> Trimis!</> : <><Send className="w-5 h-5" /> Trimite Mesajul</>}
                </button>
              </motion.form>
            </div>
          </div>
        </div>
      </SectionWrapper>
    </>
  )
}
''')

print("Contact page done!")

# ============================================================
# pages/Pricing.tsx
# ============================================================
w("pages/Pricing.tsx", r'''import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { CheckCircle, X, Crown, Zap, Building2, ArrowRight } from 'lucide-react'
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
''')

print("Pricing page done!")

# ============================================================
# pages/FAQ.tsx
# ============================================================
w("pages/FAQ.tsx", r'''import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { ChevronDown, HelpCircle } from 'lucide-react'
import SectionWrapper from '@/components/SectionWrapper'
import CTASection from '@/components/CTASection'

const faqs = [
  { q: 'Ce este AutoDiag Pro?', a: 'AutoDiag Pro este o platforma de diagnostic auto alimentata de inteligenta artificiala. Ofera peste 50 de functii, de la scanare foto si decodare VIN pana la predictii de defectiuni si chat cu un mecanic AI.' },
  { q: 'Cat costa aplicatia?', a: 'Planul Free este gratuit pentru totdeauna si include 5 scanari/luna, VIN decoder, decodor DTC si chat AI limitat. Planul PRO costa 9.99 EUR/luna si ofera acces nelimitat la toate functiile.' },
  { q: 'In ce tari este disponibil?', a: 'AutoDiag Pro este disponibil in 44 de tari europene, inclusiv Romania, Germania, Franta, Italia, Spania, UK, Polonia si multe altele. Suportam 108 marci auto.' },
  { q: 'Cum functioneaza diagnosticul foto?', a: 'Pur si simplu fotografiezi componenta sau problema vizibila. AI-ul nostru analizeaza imaginea si ofera diagnostic cu cauze posibile, severitate, cost estimat si recomandari de reparatie.' },
  { q: 'Am nevoie de un adaptor OBD2?', a: 'Nu este obligatoriu. Multe functii functioneaza fara adaptor (foto scan, VIN decoder, DTC, chat AI, predictii). Pentru date live in timp real, ai nevoie de un adaptor OBD2 Bluetooth.' },
  { q: 'Cat de precise sunt predictiile AI?', a: 'Motorul nostru AI are o acuratete de 99.8%, bazata pe analiza a milioane de cazuri reale. Predictiile sunt orientative si recomandam intotdeauna confirmarea la un mecanic certificat.' },
  { q: 'Este compatibil cu masina mea?', a: 'AutoDiag Pro suporta 108 marci auto, inclusiv toate marcile populare din Europa: Volkswagen, BMW, Mercedes, Audi, Toyota, Renault, Dacia, Ford, Opel, Skoda si multe altele.' },
  { q: 'Cum imi protejati datele?', a: 'Suntem GDPR compliant. Toate datele sunt criptate end-to-end, stocate in serverele securizate din UE. Nu vindem si nu partajam datele tale cu terti.' },
  { q: 'Pot folosi pentru service-ul meu auto?', a: 'Da! Avem planul Business dedicat service-urilor auto cu functii de gestionare flota, rapoarte cu branding propriu, API integration si suport 24/7.' },
  { q: 'Exista o versiune web?', a: 'Da! Pe langa aplicatia mobila (iOS si Android), avem si o versiune web completa accesibila din orice browser.' },
]

export default function FAQ() {
  const [openIdx, setOpenIdx] = useState<number | null>(null)

  return (
    <>
      <section className="relative pt-32 pb-16">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <span className="inline-block mb-4 px-4 py-1.5 rounded-full glass-bright text-xs font-semibold text-cyan-400 tracking-widest uppercase">FAQ</span>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight text-white mb-4">
            Intrebari <span className="gradient-text-static">Frecvente</span>
          </h1>
          <p className="text-lg text-slate-400">Gaseste raspunsuri la cele mai comune intrebari.</p>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="space-y-4">
            {faqs.map((f, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.4, delay: i * 0.05 }}
                className="glass-card rounded-2xl overflow-hidden"
              >
                <button onClick={() => setOpenIdx(openIdx === i ? null : i)} className="w-full flex items-center justify-between p-6 text-left">
                  <div className="flex items-center gap-3">
                    <HelpCircle className="w-5 h-5 text-cyan-400 shrink-0" />
                    <span className="font-semibold text-white">{f.q}</span>
                  </div>
                  <ChevronDown className={`w-5 h-5 text-slate-500 transition-transform duration-300 shrink-0 ml-4 ${openIdx === i ? 'rotate-180' : ''}`} />
                </button>
                <AnimatePresence>
                  {openIdx === i && (
                    <motion.div
                      initial={{ height: 0, opacity: 0 }}
                      animate={{ height: 'auto', opacity: 1 }}
                      exit={{ height: 0, opacity: 0 }}
                      transition={{ duration: 0.3 }}
                      className="overflow-hidden"
                    >
                      <div className="px-6 pb-6 pl-14">
                        <p className="text-sm text-slate-400 leading-relaxed">{f.a}</p>
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </motion.div>
            ))}
          </div>
        </div>
      </SectionWrapper>

      <CTASection />
    </>
  )
}
''')

print("FAQ page done!")

# ============================================================
# pages/Terms.tsx
# ============================================================
w("pages/Terms.tsx", r'''import { useState } from 'react'
import SectionWrapper from '@/components/SectionWrapper'

export default function Terms() {
  const [tab, setTab] = useState<'termeni' | 'confidentialitate'>('termeni')

  return (
    <>
      <section className="relative pt-32 pb-8">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-4xl sm:text-5xl font-black tracking-tight text-white mb-6">
            {tab === 'termeni' ? 'Termeni si Conditii' : 'Politica de Confidentialitate'}
          </h1>
          <div className="flex justify-center gap-2 mb-8">
            <button onClick={() => setTab('termeni')} className={`px-6 py-2.5 rounded-xl text-sm font-semibold transition-all ${tab === 'termeni' ? 'btn-primary' : 'btn-secondary'}`}>Termeni</button>
            <button onClick={() => setTab('confidentialitate')} className={`px-6 py-2.5 rounded-xl text-sm font-semibold transition-all ${tab === 'confidentialitate' ? 'btn-primary' : 'btn-secondary'}`}>Confidentialitate</button>
          </div>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="glass-card rounded-3xl p-8 lg:p-12">
            {tab === 'termeni' ? (
              <div className="prose prose-invert prose-sm max-w-none space-y-6">
                <p className="text-slate-400 text-sm">Ultima actualizare: {new Date().toLocaleDateString('ro-RO')}</p>
                <h2 className="text-xl font-bold text-white">1. Acceptarea Termenilor</h2>
                <p className="text-slate-400 leading-relaxed">Prin utilizarea aplicatiei AutoDiag Pro, acceptati acesti termeni si conditii. Daca nu sunteti de acord, va rugam sa nu utilizati serviciul.</p>
                <h2 className="text-xl font-bold text-white">2. Descrierea Serviciului</h2>
                <p className="text-slate-400 leading-relaxed">AutoDiag Pro ofera servicii de diagnostic auto bazate pe inteligenta artificiala, incluzand dar fara a se limita la: scanare foto, decodare VIN, decodare coduri DTC, chat AI, predictii si analiza sunet motor.</p>
                <h2 className="text-xl font-bold text-white">3. Limitarea Responsabilitatii</h2>
                <p className="text-slate-400 leading-relaxed">Diagnosticele si recomandarile oferite de AutoDiag Pro sunt orientative si nu inlocuiesc consultarea unui mecanic profesionist. Nu ne asumam responsabilitatea pentru decizii luate exclusiv pe baza rezultatelor aplicatiei.</p>
                <h2 className="text-xl font-bold text-white">4. Proprietate Intelectuala</h2>
                <p className="text-slate-400 leading-relaxed">Tot continutul, designul, codul sursa si algoritmii sunt proprietatea AutoDiag Pro si sunt protejati de legile drepturilor de autor.</p>
                <h2 className="text-xl font-bold text-white">5. Conturi Utilizator</h2>
                <p className="text-slate-400 leading-relaxed">Sunteti responsabil pentru securitatea contului dumneavoastra si pentru toate activitatile desfasurate prin intermediul acestuia.</p>
                <h2 className="text-xl font-bold text-white">6. Modificari ale Termenilor</h2>
                <p className="text-slate-400 leading-relaxed">Ne rezervam dreptul de a modifica acesti termeni in orice moment. Modificarile vor fi notificate prin aplicatie si email.</p>
              </div>
            ) : (
              <div className="prose prose-invert prose-sm max-w-none space-y-6">
                <p className="text-slate-400 text-sm">Ultima actualizare: {new Date().toLocaleDateString('ro-RO')}</p>
                <h2 className="text-xl font-bold text-white">1. Date Colectate</h2>
                <p className="text-slate-400 leading-relaxed">Colectam: informatii despre vehicul (VIN, marca, model, an), date de diagnostic, fotografii (doar pentru analiza), date de utilizare anonimizate. Nu colectam date personale fara consimtamant explicit.</p>
                <h2 className="text-xl font-bold text-white">2. Scopul Prelucrarii</h2>
                <p className="text-slate-400 leading-relaxed">Datele sunt folosite exclusiv pentru: furnizarea serviciului de diagnostic, imbunatatirea algoritmilor AI, comunicari relevante despre serviciu, si suport tehnic.</p>
                <h2 className="text-xl font-bold text-white">3. GDPR Compliance</h2>
                <p className="text-slate-400 leading-relaxed">Respectam pe deplin Regulamentul General privind Protectia Datelor (GDPR). Aveti dreptul la: acces, rectificare, stergere, portabilitate si opozitie la prelucrarea datelor.</p>
                <h2 className="text-xl font-bold text-white">4. Securitatea Datelor</h2>
                <p className="text-slate-400 leading-relaxed">Toate datele sunt criptate end-to-end (AES-256) si stocate in servere securizate din Uniunea Europeana. Implementam masuri tehnice si organizatorice adecvate.</p>
                <h2 className="text-xl font-bold text-white">5. Cookie-uri</h2>
                <p className="text-slate-400 leading-relaxed">Folosim cookie-uri esentiale pentru functionarea serviciului si cookie-uri analitice (cu consimtamant) pentru imbunatatirea experientei.</p>
                <h2 className="text-xl font-bold text-white">6. Contact DPO</h2>
                <p className="text-slate-400 leading-relaxed">Pentru orice intrebari legate de protectia datelor, contactati Ofiterul nostru de Protectie a Datelor la: dpo@autodiagpro.com</p>
              </div>
            )}
          </div>
        </div>
      </SectionWrapper>
    </>
  )
}
''')

print("Terms page done!")

# ============================================================
# App.tsx - Router setup
# ============================================================
w("App.tsx", r'''import { BrowserRouter, Routes, Route, useLocation } from 'react-router-dom'
import { useEffect } from 'react'
import Navbar from '@/components/Navbar'
import Footer from '@/components/Footer'
import Home from '@/pages/Home'
import Features from '@/pages/Features'
import HowItWorks from '@/pages/HowItWorks'
import ForService from '@/pages/ForService'
import About from '@/pages/About'
import Contact from '@/pages/Contact'
import Pricing from '@/pages/Pricing'
import FAQ from '@/pages/FAQ'
import Terms from '@/pages/Terms'

function ScrollToTop() {
  const { pathname } = useLocation()
  useEffect(() => { window.scrollTo(0, 0) }, [pathname])
  return null
}

function App() {
  return (
    <BrowserRouter>
      <ScrollToTop />
      <div className="min-h-screen bg-slate-950 text-white">
        <Navbar />
        <main>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/functionalitati" element={<Features />} />
            <Route path="/cum-functioneaza" element={<HowItWorks />} />
            <Route path="/pentru-service" element={<ForService />} />
            <Route path="/despre" element={<About />} />
            <Route path="/contact" element={<Contact />} />
            <Route path="/pricing" element={<Pricing />} />
            <Route path="/faq" element={<FAQ />} />
            <Route path="/termeni" element={<Terms />} />
          </Routes>
        </main>
        <Footer />
      </div>
    </BrowserRouter>
  )
}

export default App
''')

# ============================================================
# App.css - clear it
# ============================================================
w("App.css", "/* Styles are in index.css */\n")

print("\n=== ALL FILES WRITTEN SUCCESSFULLY ===")
