import { ArrowLeft, Wifi, Activity } from 'lucide-react'
import { Link } from 'react-router-dom'

const PIDS = [
  { name: 'RPM Motor', value: '850', unit: 'rpm', status: 'normal' },
  { name: 'Temperatura Motor', value: '92', unit: '°C', status: 'normal' },
  { name: 'Viteza Vehicul', value: '0', unit: 'km/h', status: 'normal' },
  { name: 'Incarcare Motor', value: '23', unit: '%', status: 'normal' },
  { name: 'Presiune Admisie', value: '101', unit: 'kPa', status: 'normal' },
  { name: 'Avans Aprindere', value: '12', unit: '°', status: 'normal' },
  { name: 'Temperatura Aer Admisie', value: '28', unit: '°C', status: 'normal' },
  { name: 'Debit Aer', value: '4.5', unit: 'g/s', status: 'normal' },
  { name: 'Pozitie Clapeta', value: '15', unit: '%', status: 'normal' },
  { name: 'Tensiune Baterie', value: '14.2', unit: 'V', status: 'normal' },
  { name: 'Temperatura Ulei', value: '95', unit: '°C', status: 'normal' },
  { name: 'Presiune Combustibil', value: '350', unit: 'kPa', status: 'normal' },
]

export default function OBD2Tool() {
  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center"><Wifi className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">OBD2 Avansat</h1><p className="text-xs text-slate-500">Live data + consum real</p></div>
        </div>
        <div className="glass-card rounded-2xl p-6 mb-6 text-center border border-cyan-500/30">
          <Activity className="w-12 h-12 text-cyan-400 mx-auto mb-3" />
          <h3 className="text-lg font-bold text-white mb-2">Date Live OBD2</h3>
          <p className="text-sm text-slate-400">Conecteaza un adaptor OBD2 Bluetooth pentru date in timp real</p>
          <p className="text-xs text-slate-500 mt-2">Mai jos: date demonstrative</p>
        </div>
        <div className="grid grid-cols-2 gap-3">
          {PIDS.map((p, i) => (
            <div key={i} className="glass-card rounded-xl p-4 text-center">
              <p className="text-[10px] text-slate-500 uppercase">{p.name}</p>
              <p className="text-2xl font-black text-white mt-1">{p.value}</p>
              <p className="text-xs text-cyan-400">{p.unit}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
