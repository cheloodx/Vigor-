import { useState } from 'react'
import { ArrowLeft, Calendar, Plus, Trash2 } from 'lucide-react'
import { Link } from 'react-router-dom'

interface ServiceEntry { id: number; date: string; type: string; desc: string; km: string; done: boolean }

const TYPES = ['Revizie', 'Schimb ulei', 'Frane', 'Distributie', 'ITP', 'Anvelope', 'Altele']

export default function ServiceCalendar() {
  const [entries, setEntries] = useState<ServiceEntry[]>(() => {
    try { return JSON.parse(localStorage.getItem('service-calendar') || '[]') } catch { return [] }
  })
  const [showForm, setShowForm] = useState(false)
  const [form, setForm] = useState({ date: '', type: 'Revizie', desc: '', km: '' })

  const save = (e: ServiceEntry[]) => { setEntries(e); localStorage.setItem('service-calendar', JSON.stringify(e)) }
  const add = () => {
    if (!form.date) return
    save([...entries, { id: Date.now(), ...form, done: false }])
    setForm({ date: '', type: 'Revizie', desc: '', km: '' }); setShowForm(false)
  }
  const toggle = (id: number) => save(entries.map(e => e.id === id ? { ...e, done: !e.done } : e))
  const remove = (id: number) => save(entries.filter(e => e.id !== id))

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center"><Calendar className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Service Calendar</h1><p className="text-xs text-slate-500">Calendar intretinere</p></div>
        </div>
        <button onClick={() => setShowForm(!showForm)} className="w-full btn-primary py-3 text-sm font-bold mb-6 flex items-center justify-center gap-2"><Plus className="w-4 h-4" />Adauga Intrare</button>
        {showForm && (
          <div className="glass-card rounded-2xl p-6 mb-6">
            <div className="space-y-3">
              <input type="date" value={form.date} onChange={e => setForm({ ...form, date: e.target.value })} className="w-full glass rounded-xl px-4 py-3 text-white text-sm" />
              <select value={form.type} onChange={e => setForm({ ...form, type: e.target.value })} className="w-full glass rounded-xl px-4 py-3 text-white text-sm bg-transparent">
                {TYPES.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
              <input value={form.desc} onChange={e => setForm({ ...form, desc: e.target.value })} placeholder="Descriere" className="w-full glass rounded-xl px-4 py-3 text-white text-sm" />
              <input value={form.km} onChange={e => setForm({ ...form, km: e.target.value })} placeholder="Kilometraj" className="w-full glass rounded-xl px-4 py-3 text-white text-sm" type="number" />
            </div>
            <button onClick={add} className="w-full btn-primary py-3 text-sm font-bold mt-3">Salveaza</button>
          </div>
        )}
        {entries.length === 0 ? (
          <div className="glass-card rounded-2xl p-8 text-center"><p className="text-slate-500">Nicio intrare in calendar</p></div>
        ) : (
          <div className="space-y-3">
            {entries.sort((a, b) => b.date.localeCompare(a.date)).map(e => (
              <div key={e.id} className={`glass-card rounded-xl p-4 flex items-center justify-between ${e.done ? 'opacity-50' : ''}`}>
                <div className="flex items-center gap-3">
                  <input type="checkbox" checked={e.done} onChange={() => toggle(e.id)} className="w-5 h-5 rounded" />
                  <div>
                    <p className={`text-sm font-bold ${e.done ? 'line-through text-slate-500' : 'text-white'}`}>{e.type}</p>
                    <p className="text-xs text-slate-500">{e.date} {e.km && `| ${e.km} km`}</p>
                    {e.desc && <p className="text-xs text-slate-400">{e.desc}</p>}
                  </div>
                </div>
                <button onClick={() => remove(e.id)} className="p-2 hover:bg-red-500/10 rounded-lg"><Trash2 className="w-4 h-4 text-red-400" /></button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
