import { useState } from 'react'
import { ArrowLeft, Scale, Loader } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

export default function ComparatorTool() {
  const [make, setMake] = useState('')
  const [operation, setOperation] = useState('')
  const [loading, setLoading] = useState(false)
  const [data, setData] = useState<{op:string;auth:string;ind:string;diff:string}[]>([])
  const [aiAdvice, setAiAdvice] = useState('')

  const compare = async () => {
    setLoading(true)
    try {
      const ops = operation || 'schimb ulei, placute frana, distributie, diagnoza, amortizoare, ambreiaj, AC, geometrie'
      const res = await api.chat(
        `Compara preturile service autorizat vs independent pentru ${make || 'masina generica'}: ${ops}. ` +
        `Listeaza fiecare operatiune cu: operatiune|pret_autorizat_RON|pret_independent_RON|economie_%. ` +
        `Format strict per linie. La final, adauga un sfat scurt.`,
        make
      )
      const lines = res.response.split('\n').filter(l => l.includes('|'))
      if (lines.length >= 3) {
        setData(lines.map(l => {
          const p = l.split('|').map(s => s.trim())
          return { op: p[0] || 'N/A', auth: p[1] || '?', ind: p[2] || '?', diff: p[3] || '~40%' }
        }))
        setAiAdvice(res.response.split('\n').filter(l => !l.includes('|') && l.trim().length > 10).join(' ').trim().slice(0, 300))
      } else {
        throw new Error('parse')
      }
    } catch {
      setData([
        { op: 'Schimb ulei + filtru', auth: '250-400', ind: '150-250', diff: '~40%' },
        { op: 'Placute frana fata', auth: '300-500', ind: '150-350', diff: '~35%' },
        { op: 'Kit distributie', auth: '800-1500', ind: '400-900', diff: '~45%' },
        { op: 'Diagnoza computerizata', auth: '100-200', ind: '50-100', diff: '~50%' },
        { op: 'Amortizoare fata (2buc)', auth: '500-900', ind: '300-600', diff: '~40%' },
        { op: 'Schimb ambreiaj', auth: '800-2000', ind: '400-1200', diff: '~40%' },
        { op: 'AC reincarcare', auth: '200-400', ind: '100-200', diff: '~50%' },
        { op: 'Geometrie roti', auth: '150-300', ind: '80-150', diff: '~45%' },
      ])
      setAiAdvice('Estimare generala. Preturile variaza in functie de marca si regiune.')
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-orange-500 to-red-600 flex items-center justify-center"><Scale className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Comparator Service</h1><p className="text-xs text-slate-500">Autorizat vs Independent</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-4">
          <input value={make} onChange={e => setMake(e.target.value)} placeholder="Marca + Model (ex: VW Golf 7)" className="w-full glass rounded-xl px-4 py-3 text-white text-sm mb-3" />
          <input value={operation} onChange={e => setOperation(e.target.value)} placeholder="Operatiuni specifice (optional)" className="w-full glass rounded-xl px-4 py-3 text-white text-sm mb-3" />
          <button onClick={compare} disabled={loading} className="w-full btn-primary py-3 text-sm font-bold flex items-center justify-center gap-2">
            {loading ? <><Loader className="w-4 h-4 animate-spin" />Analizam preturile...</> : 'Compara Preturi'}
          </button>
        </div>
        {data.length > 0 && (
          <>
            <div className="glass-card rounded-2xl p-4 mb-4">
              <div className="grid grid-cols-4 gap-2 text-xs font-bold text-slate-400 pb-2 border-b border-white/10">
                <span>Operatiune</span><span className="text-center">Autorizat</span><span className="text-center">Independent</span><span className="text-center">Economie</span>
              </div>
              {data.map((d, i) => (
                <div key={i} className="grid grid-cols-4 gap-2 py-3 border-b border-white/5 items-center">
                  <span className="text-sm text-white">{d.op}</span>
                  <span className="text-xs text-center text-amber-400">{d.auth} RON</span>
                  <span className="text-xs text-center text-emerald-400">{d.ind} RON</span>
                  <span className="text-xs text-center text-cyan-400 font-bold">{d.diff}</span>
                </div>
              ))}
            </div>
            {aiAdvice && (
              <div className="glass-card rounded-2xl p-4 border-l-4 border-cyan-500">
                <p className="text-xs text-cyan-400 font-bold mb-1">SFAT AI</p>
                <p className="text-sm text-slate-300">{aiAdvice}</p>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  )
}
