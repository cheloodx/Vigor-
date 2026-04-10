import { ArrowLeft, Scale } from 'lucide-react'
import { Link } from 'react-router-dom'

const DATA = [
  { op: 'Schimb ulei + filtru', auth: '250-400', ind: '150-250', diff: '40%' },
  { op: 'Placute frana fata', auth: '300-500', ind: '150-350', diff: '35%' },
  { op: 'Distributie kit', auth: '800-1500', ind: '400-900', diff: '45%' },
  { op: 'Diagnoza computerizata', auth: '100-200', ind: '50-100', diff: '50%' },
  { op: 'Amortizoare fata (2buc)', auth: '500-900', ind: '300-600', diff: '40%' },
  { op: 'Schimb ambreiaj', auth: '800-2000', ind: '400-1200', diff: '40%' },
  { op: 'AC reincarcare', auth: '200-400', ind: '100-200', diff: '50%' },
  { op: 'Geometrie roti', auth: '150-300', ind: '80-150', diff: '45%' },
]

export default function ComparatorTool() {
  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-orange-500 to-red-600 flex items-center justify-center"><Scale className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Comparator Service</h1><p className="text-xs text-slate-500">Autorizat vs Independent</p></div>
        </div>
        <div className="glass-card rounded-2xl p-4 mb-4">
          <div className="grid grid-cols-4 gap-2 text-xs font-bold text-slate-400 pb-2 border-b border-white/10">
            <span>Operatiune</span><span className="text-center">Autorizat</span><span className="text-center">Independent</span><span className="text-center">Economie</span>
          </div>
          {DATA.map((d, i) => (
            <div key={i} className="grid grid-cols-4 gap-2 py-3 border-b border-white/5 items-center">
              <span className="text-sm text-white">{d.op}</span>
              <span className="text-xs text-center text-amber-400">{d.auth} RON</span>
              <span className="text-xs text-center text-emerald-400">{d.ind} RON</span>
              <span className="text-xs text-center text-cyan-400 font-bold">~{d.diff}</span>
            </div>
          ))}
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div className="glass-card rounded-2xl p-4">
            <h3 className="text-sm font-bold text-amber-400 mb-2">Service Autorizat</h3>
            <ul className="text-xs text-slate-400 space-y-1">
              <li>+ Garantie producator mentinuta</li>
              <li>+ Piese originale</li>
              <li>+ Personal certificat</li>
              <li>- Preturi mai mari</li>
              <li>- Timp asteptare mai lung</li>
            </ul>
          </div>
          <div className="glass-card rounded-2xl p-4">
            <h3 className="text-sm font-bold text-emerald-400 mb-2">Service Independent</h3>
            <ul className="text-xs text-slate-400 space-y-1">
              <li>+ Preturi mai mici 30-50%</li>
              <li>+ Flexibilitate program</li>
              <li>+ Piese aftermarket calitate</li>
              <li>- Garantie producator afectata</li>
              <li>- Calitate variabila</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}
