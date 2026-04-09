import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { Car, Plus, Trash2, ArrowLeft, Loader2, AlertCircle, History } from 'lucide-react'
import { Link } from 'react-router-dom'
import { useAuth } from '@/lib/auth'
import { supabase } from '@/lib/supabase'

interface SavedVehicle {
  id: string
  vin: string
  make: string
  model: string
  year: number
  created_at: string
}

export default function MyVehicles() {
  const { user, profile } = useAuth()
  const [vehicles, setVehicles] = useState<SavedVehicle[]>([])
  const [newVin, setNewVin] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const maxVehicles = profile?.plan === 'free' ? 3 : Infinity

  useEffect(() => {
    if (user) loadVehicles()
  }, [user])

  const loadVehicles = async () => {
    if (!user) return
    const { data } = await supabase.from('vehicles').select('*').eq('user_id', user.id).order('created_at', { ascending: false })
    if (data) setVehicles(data as SavedVehicle[])
  }

  const addVehicle = async () => {
    const v = newVin.trim().toUpperCase()
    if (v.length < 11) { setError('VIN-ul trebuie sa aiba minim 11 caractere.'); return }
    if (vehicles.length >= maxVehicles) { setError(`Limita de ${maxVehicles} vehicule pe planul Free. Upgradeaza la Pro!`); return }
    setLoading(true); setError('')
    try {
      const { api } = await import('@/lib/api')
      const decoded = await api.decodeVIN(v)
      const { error: insertErr } = await supabase.from('vehicles').insert({
        user_id: user?.id, vin: v, make: decoded.make, model: decoded.model, year: decoded.year,
      })
      if (insertErr) throw insertErr
      setNewVin('')
      loadVehicles()
    } catch {
      setError('Eroare la adaugarea vehiculului.')
    }
    setLoading(false)
  }

  const removeVehicle = async (id: string) => {
    await supabase.from('vehicles').delete().eq('id', id)
    setVehicles(vehicles.filter(v => v.id !== id))
  }

  if (!user) return (
    <div className="min-h-screen pt-20 flex items-center justify-center">
      <div className="text-center">
        <Car className="w-16 h-16 text-slate-600 mx-auto mb-4" />
        <h2 className="text-xl font-bold text-white mb-2">Autentificare necesara</h2>
        <p className="text-slate-400 mb-6">Conecteaza-te pentru a salva vehicule.</p>
        <Link to="/login" className="btn-primary px-6 py-3">Conecteaza-te</Link>
      </div>
    </div>
  )

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10 transition-colors"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div>
            <h1 className="text-xl font-bold text-white">Vehiculele Mele</h1>
            <p className="text-xs text-slate-500">{vehicles.length}{maxVehicles < Infinity ? `/${maxVehicles}` : ''} vehicule salvate</p>
          </div>
        </div>

        <div className="glass-bright rounded-3xl p-6 mb-6">
          <h3 className="text-sm font-bold text-white mb-3">Adauga vehicul nou</h3>
          <div className="flex gap-3">
            <input value={newVin} onChange={e => setNewVin(e.target.value.toUpperCase())} placeholder="Introdu VIN-ul" maxLength={17} className="flex-1 bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm font-mono text-white placeholder-slate-500 focus:border-cyan-500/50 focus:outline-none uppercase" />
            <button onClick={addVehicle} disabled={loading} className="btn-primary px-4 py-3 flex items-center gap-2 disabled:opacity-50">
              {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Plus className="w-4 h-4" />}
              Adauga
            </button>
          </div>
          {error && <p className="mt-2 text-xs text-red-400 flex items-center gap-2"><AlertCircle className="w-3 h-3" />{error}</p>}
        </div>

        <div className="space-y-3">
          {vehicles.map((v, i) => (
            <motion.div key={v.id} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.05 }} className="glass-card rounded-2xl p-5 flex items-center justify-between">
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center">
                  <Car className="w-6 h-6 text-white" />
                </div>
                <div>
                  <h4 className="font-bold text-white">{v.make} {v.model}</h4>
                  <p className="text-xs text-slate-500 font-mono">{v.vin}</p>
                  <p className="text-xs text-slate-600">An: {v.year}</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <Link to={`/tools/vin?vin=${v.vin}`} className="p-2 glass rounded-lg hover:bg-white/10 transition-colors">
                  <History className="w-4 h-4 text-cyan-400" />
                </Link>
                <button onClick={() => removeVehicle(v.id)} className="p-2 glass rounded-lg hover:bg-red-500/10 transition-colors">
                  <Trash2 className="w-4 h-4 text-red-400" />
                </button>
              </div>
            </motion.div>
          ))}
          {vehicles.length === 0 && (
            <div className="text-center py-12">
              <Car className="w-12 h-12 text-slate-700 mx-auto mb-3" />
              <p className="text-slate-500">Niciun vehicul salvat inca.</p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
