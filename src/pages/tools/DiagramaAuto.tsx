import { useState } from 'react'
import { ArrowLeft, Car } from 'lucide-react'
import { Link } from 'react-router-dom'

const PARTS = [
  { id: 'motor', name: 'Motor', x: 50, y: 25, color: '#10b981' },
  { id: 'transmisie', name: 'Transmisie', x: 50, y: 40, color: '#3b82f6' },
  { id: 'frane-fata', name: 'Frane Fata', x: 20, y: 20, color: '#f59e0b' },
  { id: 'frane-spate', name: 'Frane Spate', x: 80, y: 20, color: '#f59e0b' },
  { id: 'suspensie-fata', name: 'Suspensie Fata', x: 20, y: 35, color: '#8b5cf6' },
  { id: 'suspensie-spate', name: 'Suspensie Spate', x: 80, y: 35, color: '#8b5cf6' },
  { id: 'baterie', name: 'Baterie', x: 30, y: 25, color: '#ef4444' },
  { id: 'radiator', name: 'Radiator', x: 50, y: 15, color: '#06b6d4' },
  { id: 'evacuare', name: 'Evacuare', x: 50, y: 55, color: '#6b7280' },
  { id: 'directie', name: 'Directie', x: 35, y: 30, color: '#ec4899' },
  { id: 'turbo', name: 'Turbo', x: 60, y: 25, color: '#f97316' },
  { id: 'climatizare', name: 'Climatizare', x: 40, y: 45, color: '#0ea5e9' },
]

export default function DiagramaAuto() {
  const [selected, setSelected] = useState<string | null>(null)
  const info: Record<string, { desc: string; check: string; cost: string }> = {
    motor: { desc: 'Motorul este inima vehiculului. Verifica ulei, filtru si distributie regulat.', check: 'La fiecare 15.000 km', cost: '200-2000 EUR' },
    transmisie: { desc: 'Cutia de viteze transfera puterea la roti. Verifica ulei si ambreiaj.', check: 'La fiecare 60.000 km', cost: '300-3000 EUR' },
    'frane-fata': { desc: 'Franele din fata asigura 70% din forta de franare.', check: 'La fiecare 30.000 km', cost: '150-400 EUR' },
    'frane-spate': { desc: 'Franele din spate completeaza sistemul de franare.', check: 'La fiecare 50.000 km', cost: '100-300 EUR' },
    'suspensie-fata': { desc: 'Suspensia fata controleaza confortul si stabilitatea.', check: 'La fiecare 80.000 km', cost: '200-800 EUR' },
    'suspensie-spate': { desc: 'Suspensia spate mentine stabilitatea la spate.', check: 'La fiecare 100.000 km', cost: '150-600 EUR' },
    baterie: { desc: 'Bateria alimenteaza sistemul electric. Durata medie: 4-5 ani.', check: 'Anual', cost: '80-200 EUR' },
    radiator: { desc: 'Radiatorul raceste lichidul de racire al motorului.', check: 'La fiecare 100.000 km', cost: '200-500 EUR' },
    evacuare: { desc: 'Sistemul de evacuare elimina gazele arse si reduce zgomotul.', check: 'La fiecare ITP', cost: '100-800 EUR' },
    directie: { desc: 'Directia controleaza miscarea rotilor directoare.', check: 'La fiecare 60.000 km', cost: '150-600 EUR' },
    turbo: { desc: 'Turbina creste puterea motorului prin compresie aer.', check: 'La fiecare 100.000 km', cost: '500-2000 EUR' },
    climatizare: { desc: 'Sistemul AC raceste/incalzeste habitaclul.', check: 'Anual', cost: '50-500 EUR' },
  }
  const sel = selected ? info[selected] : null

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center"><Car className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Diagrama Auto</h1><p className="text-xs text-slate-500">Componente vizuale</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <p className="text-sm text-slate-400 mb-4">Apasa pe o componenta pentru detalii:</p>
          <div className="relative w-full aspect-[2/1] bg-gradient-to-b from-slate-800/50 to-slate-900/50 rounded-xl overflow-hidden border border-slate-700/50">
            <div className="absolute inset-0 flex items-center justify-center opacity-10">
              <Car className="w-48 h-48 text-white" />
            </div>
            {PARTS.map(p => (
              <button key={p.id} onClick={() => setSelected(p.id)} className={`absolute w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold transition-all hover:scale-125 ${selected === p.id ? 'ring-2 ring-white scale-125' : ''}`}
                style={{ left: `${p.x}%`, top: `${p.y}%`, transform: 'translate(-50%,-50%)', backgroundColor: p.color }}>
                <span className="text-white text-[10px]">{p.name.charAt(0)}</span>
              </button>
            ))}
          </div>
          <div className="flex flex-wrap gap-2 mt-4">
            {PARTS.map(p => (
              <button key={p.id} onClick={() => setSelected(p.id)} className={`px-3 py-1.5 rounded-lg text-xs font-medium transition-all ${selected === p.id ? 'bg-white/20 text-white' : 'glass text-slate-400 hover:text-white'}`}>
                {p.name}
              </button>
            ))}
          </div>
        </div>
        {sel && selected && (
          <div className="glass-card rounded-2xl p-6 border-l-4" style={{ borderColor: PARTS.find(p => p.id === selected)?.color }}>
            <h3 className="text-lg font-bold text-white mb-2">{PARTS.find(p => p.id === selected)?.name}</h3>
            <p className="text-sm text-slate-300 mb-4">{sel.desc}</p>
            <div className="grid grid-cols-2 gap-4">
              <div className="glass rounded-xl p-3"><p className="text-[10px] text-slate-500 uppercase">Interval verificare</p><p className="text-sm font-bold text-white">{sel.check}</p></div>
              <div className="glass rounded-xl p-3"><p className="text-[10px] text-slate-500 uppercase">Cost estimat reparatie</p><p className="text-sm font-bold text-white">{sel.cost}</p></div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
