import { useState } from 'react'
import { ArrowLeft, Zap, AlertCircle } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

const SYMPTOMS = [
  { id: 'zgomot-motor', label: 'Zgomot motor', icon: '🔊', desc: 'Bataie, ticaie, etc.' },
  { id: 'fum-evacuare', label: 'Fum evacuare', icon: '💨', desc: 'Alb, negru, albastru' },
  { id: 'vibratii', label: 'Vibratii', icon: '📳', desc: 'Volan, scaun, pedala' },
  { id: 'lumina-bord', label: 'Lumina pe bord', icon: '🔆', desc: 'Check engine, etc.' },
  { id: 'miros', label: 'Miros neobisnuit', icon: '👃', desc: 'Cauciuc ars, benzina' },
  { id: 'pornire', label: 'Probleme pornire', icon: '🔑', desc: 'Nu porneste, greu' },
  { id: 'frane', label: 'Probleme frane', icon: '🛑', desc: 'Scartaie, trage lateral' },
  { id: 'directie', label: 'Probleme directie', icon: '🔄', desc: 'Joc, greu, zgomot' },
]

export default function DiagnosticRapid() {
  const [selected, setSelected] = useState<string[]>([])
  const [make, setMake] = useState('')
  const [result, setResult] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  const toggle = (id: string) => setSelected(s => s.includes(id) ? s.filter(x => x !== id) : [...s, id])

  const diagnose = async () => {
    if (selected.length === 0) return
    setLoading(true)
    try {
      const symptoms = selected.map(id => SYMPTOMS.find(s => s.id === id)?.label).join(', ')
      const res = await api.chat(`Diagnostic rapid: simptome detectate: ${symptoms}. Masina: ${make || 'necunoscuta'}. Ofera un diagnostic scurt cu cauze posibile, gravitate si actiuni recomandate. Raspunde in romana.`, make)
      setResult(res.response)
    } catch {
      setResult('Bazat pe simptomele selectate, recomand verificarea la un service autorizat cat mai curand posibil. Simptomele indicate pot sugera probleme la nivelul motorului sau sistemului de frane care necesita atentie imediata.')
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-yellow-500 to-orange-600 flex items-center justify-center"><Zap className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Diagnostic Rapid</h1><p className="text-xs text-slate-500">Selecteaza simptomele</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca + Model (optional)" className="w-full glass rounded-xl px-4 py-3 text-white text-sm mb-4" />
          <p className="text-sm text-slate-400 mb-3">Ce simptome observi?</p>
          <div className="grid grid-cols-2 gap-3">
            {SYMPTOMS.map(s => (
              <button key={s.id} onClick={() => toggle(s.id)} className={`p-3 rounded-xl text-left transition-all ${selected.includes(s.id) ? 'bg-cyan-500/20 border border-cyan-500/50' : 'glass hover:bg-white/5'}`}>
                <span className="text-lg">{s.icon}</span>
                <p className="text-sm font-bold text-white mt-1">{s.label}</p>
                <p className="text-[10px] text-slate-500">{s.desc}</p>
              </button>
            ))}
          </div>
          <button onClick={diagnose} disabled={loading || selected.length === 0} className="w-full btn-primary py-3 text-sm font-bold mt-4 flex items-center justify-center gap-2">
            {loading ? 'Analizam...' : <><AlertCircle className="w-4 h-4" />Diagnostic Rapid ({selected.length} simptome)</>}
          </button>
        </div>
        {result && (
          <div className="glass-card rounded-2xl p-6 border-l-4 border-cyan-500">
            <h3 className="text-lg font-bold text-white mb-3">Rezultat Diagnostic</h3>
            <p className="text-sm text-slate-300 whitespace-pre-line">{result}</p>
          </div>
        )}
      </div>
    </div>
  )
}
