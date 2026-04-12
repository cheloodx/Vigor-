import { useState } from 'react'
import { ArrowLeft, Receipt, Calculator } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

const OPERATIONS = [
  { name: 'Schimb ulei + filtru', range: '150-300' }, { name: 'Placute frana fata', range: '150-400' },
  { name: 'Discuri frana fata', range: '200-500' }, { name: 'Kit distributie', range: '400-1200' },
  { name: 'Amortizoare fata (2buc)', range: '300-800' }, { name: 'Schimb anvelope', range: '200-600' },
  { name: 'Diagnoza computerizata', range: '50-150' }, { name: 'ITP', range: '100-200' },
  { name: 'Schimb ambreiaj', range: '400-1500' }, { name: 'Reparatie turbo', range: '500-2000' },
]

export default function CosturiTool() {
  const [make, setMake] = useState('')
  const [selected, setSelected] = useState<string[]>([])
  const [loading, setLoading] = useState(false)
  const [estimate, setEstimate] = useState<{total:string;items:{name:string;cost:string}[]} | null>(null)

  const toggle = (name: string) => setSelected(s => s.includes(name) ? s.filter(x => x !== name) : [...s, name])

  const calc = async () => {
    if (selected.length === 0) return
    setLoading(true)
    try {
      const ops = selected.join(', ')
      const res = await api.chat(
        `Estimeaza costul pentru urmatoarele operatiuni la un ${make || 'masina generica'}: ${ops}. ` +
        `Listeaza fiecare operatiune cu pret estimat in RON. Format strict per linie: operatiune|pret_min-pret_max. ` +
        `La final, scrie TOTAL|suma_min-suma_max.`,
        make
      )
      const lines = res.response.split('\n').filter(l => l.includes('|'))
      const totalLine = lines.find(l => l.toUpperCase().includes('TOTAL'))
      const itemLines = lines.filter(l => !l.toUpperCase().includes('TOTAL'))
      if (itemLines.length >= 1) {
        const items = itemLines.map(l => {
          const p = l.split('|').map(s => s.trim())
          return { name: p[0] || 'Operatiune', cost: p[1]?.replace(/[^\d\-]/g, '') || '100-300' }
        })
        const totalStr = totalLine ? totalLine.split('|')[1]?.trim() || '' : ''
        const totalNums = totalStr.match(/\d+/g)
        let total = ''
        if (totalNums && totalNums.length >= 2) {
          total = `${totalNums[0]}-${totalNums[1]} RON`
        } else {
          const tMin = items.reduce((a, i) => a + parseInt(i.cost.split('-')[0] || '0'), 0)
          const tMax = items.reduce((a, i) => a + parseInt(i.cost.split('-')[1] || i.cost.split('-')[0] || '0'), 0)
          total = `${tMin}-${tMax} RON`
        }
        setEstimate({ total, items })
      } else {
        throw new Error('parse')
      }
    } catch {
      const items = selected.map(s => ({ name: s, cost: OPERATIONS.find(o => o.name === s)?.range || '100-300' }))
      const totalMin = items.reduce((a, i) => a + parseInt(i.cost.split('-')[0]), 0)
      const totalMax = items.reduce((a, i) => a + parseInt(i.cost.split('-')[1] || i.cost.split('-')[0]), 0)
      setEstimate({ total: `${totalMin}-${totalMax} RON`, items })
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-teal-500 to-green-600 flex items-center justify-center"><Receipt className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Estimator Costuri</h1><p className="text-xs text-slate-500">Estimator costuri reparatii</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6">
          <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca + Model (optional)" className="w-full glass rounded-xl px-4 py-3 text-white text-sm mb-4" />
          <p className="text-sm text-slate-400 mb-3">Selecteaza operatiunile:</p>
          <div className="space-y-2">
            {OPERATIONS.map(op => (
              <button key={op.name} onClick={() => toggle(op.name)} className={`w-full p-3 rounded-xl text-left flex justify-between items-center ${selected.includes(op.name) ? 'bg-cyan-500/20 border border-cyan-500/50' : 'glass hover:bg-white/5'}`}>
                <span className="text-sm text-white">{op.name}</span>
                <span className="text-xs text-slate-500">{op.range} RON</span>
              </button>
            ))}
          </div>
          <button onClick={calc} disabled={loading || selected.length === 0} className="w-full btn-primary py-3 text-sm font-bold mt-4 flex items-center justify-center gap-2">
            <Calculator className="w-4 h-4" />{loading ? 'Calculam...' : `Estimeaza Cost (${selected.length} operatiuni)`}
          </button>
        </div>
        {estimate && (
          <div className="glass-card rounded-2xl p-6">
            <div className="text-center mb-4 pb-4 border-b border-white/10">
              <p className="text-xs text-slate-500">COST TOTAL ESTIMAT</p>
              <p className="text-3xl font-black text-emerald-400">{estimate.total}</p>
            </div>
            {estimate.items.map((it, i) => (
              <div key={i} className="flex justify-between py-2 border-b border-white/5">
                <span className="text-sm text-slate-300">{it.name}</span>
                <span className="text-sm font-bold text-white">{it.cost} RON</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
