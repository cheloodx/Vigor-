import { Link } from 'react-router-dom'
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
