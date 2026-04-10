import { useState } from 'react'
import { ArrowLeft, AlertTriangle, ChevronDown, ChevronUp } from 'lucide-react'
import { Link } from 'react-router-dom'

const CATEGORIES = [
  { title: 'Viteza', items: [
    { name: 'Depasire 10-20 km/h in localitate', fine: '580-725 RON', points: '2' },
    { name: 'Depasire 21-30 km/h in localitate', fine: '725-870 RON', points: '3' },
    { name: 'Depasire 31-40 km/h in localitate', fine: '870-1160 RON', points: '4' },
    { name: 'Depasire >50 km/h', fine: '1305-2900 RON + suspendare', points: '6' },
  ]},
  { title: 'Alcool & Substante', items: [
    { name: 'Alcoolemie 0.40-0.80 mg/l', fine: 'Amenda + suspendare 90 zile', points: '6' },
    { name: 'Alcoolemie >0.80 mg/l', fine: 'Dosar penal', points: 'Suspendare' },
    { name: 'Refuz testare alcool', fine: 'Dosar penal', points: 'Suspendare' },
  ]},
  { title: 'Parcare & Oprire', items: [
    { name: 'Parcare interzisa', fine: '290-435 RON', points: '2' },
    { name: 'Parcare pe trotuar', fine: '290-580 RON', points: '2' },
    { name: 'Oprire in intersectie', fine: '435-580 RON', points: '3' },
  ]},
  { title: 'Documente & ITP', items: [
    { name: 'ITP expirat', fine: '870-1740 RON', points: '3' },
    { name: 'Lipsa asigurare RCA', fine: '1000-2000 RON', points: '0' },
    { name: 'Fara permis la purtator', fine: '290-435 RON', points: '0' },
  ]},
  { title: 'Siguranta', items: [
    { name: 'Fara centura de siguranta', fine: '580-725 RON', points: '2' },
    { name: 'Telefon la volan', fine: '580-725 RON', points: '3' },
    { name: 'Fara scaun copil', fine: '580-725 RON', points: '3' },
  ]},
]

export default function LegalAmenzi() {
  const [expanded, setExpanded] = useState<number | null>(0)

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-500 to-orange-600 flex items-center justify-center"><AlertTriangle className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Legal & Amenzi</h1><p className="text-xs text-slate-500">Camere, reguli, amenzi Romania</p></div>
        </div>
        <div className="space-y-3">
          {CATEGORIES.map((cat, i) => (
            <div key={i} className="glass-card rounded-2xl overflow-hidden">
              <button onClick={() => setExpanded(expanded === i ? null : i)} className="w-full p-4 flex items-center justify-between hover:bg-white/5">
                <span className="text-sm font-bold text-white">{cat.title}</span>
                {expanded === i ? <ChevronUp className="w-4 h-4 text-slate-400" /> : <ChevronDown className="w-4 h-4 text-slate-400" />}
              </button>
              {expanded === i && (
                <div className="px-4 pb-4 space-y-2">
                  {cat.items.map((item, j) => (
                    <div key={j} className="glass rounded-xl p-3 flex items-center justify-between">
                      <div><p className="text-sm text-white">{item.name}</p><p className="text-xs text-slate-500">{item.points} puncte penalizare</p></div>
                      <span className="text-xs font-bold text-amber-400 text-right max-w-[120px]">{item.fine}</span>
                    </div>
                  ))}
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
