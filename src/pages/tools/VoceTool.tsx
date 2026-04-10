import { useState } from 'react'
import { ArrowLeft, Mic, MicOff } from 'lucide-react'
import { Link } from 'react-router-dom'
import { api } from '@/lib/api'

export default function VoceTool() {
  const [listening, setListening] = useState(false)
  const [transcript, setTranscript] = useState('')
  const [response, setResponse] = useState('')
  const [loading, setLoading] = useState(false)

  const startListening = () => {
    const SR = (window as unknown as Record<string, unknown>).SpeechRecognition || (window as unknown as Record<string, unknown>).webkitSpeechRecognition
    if (!SR) { setTranscript('Browserul nu suporta recunoastere vocala. Scrie manual problema.'); return }
    const recognition = new (SR as new () => { lang: string; continuous: boolean; interimResults: boolean; onstart: (() => void) | null; onresult: ((e: { results: { [index: number]: { [index: number]: { transcript: string } } } }) => void) | null; onerror: (() => void) | null; onend: (() => void) | null; start: () => void })()
    recognition.lang = 'ro-RO'
    recognition.continuous = false
    recognition.interimResults = false
    recognition.onstart = () => setListening(true)
    recognition.onresult = (e: { results: { [index: number]: { [index: number]: { transcript: string } } } }) => {
      const text = e.results[0][0].transcript
      setTranscript(text)
      setListening(false)
      diagnoseVoice(text)
    }
    recognition.onerror = () => { setListening(false); setTranscript('Eroare la recunoastere. Incearca din nou sau scrie manual.') }
    recognition.onend = () => setListening(false)
    recognition.start()
  }

  const diagnoseVoice = async (text: string) => {
    setLoading(true)
    try {
      const res = await api.chat(`Diagnostic vocal: Proprietarul descrie problema: "${text}". Ofera diagnostic posibil, cauze si recomandari. Raspunde in romana.`)
      setResponse(res.response)
    } catch {
      setResponse('Am inteles descrierea ta. Bazat pe simptomele descrise, recomand o vizita la service pentru o diagnoza completa. Problemele descrise pot avea cauze multiple care necesita inspectie fizica.')
    }
    setLoading(false)
  }

  return (
    <div className="min-h-screen pt-20">
      <div className="max-w-2xl mx-auto px-4 py-8">
        <div className="flex items-center gap-3 mb-8">
          <Link to="/tools" className="p-2 glass rounded-xl hover:bg-white/10"><ArrowLeft className="w-5 h-5 text-slate-400" /></Link>
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-pink-500 to-rose-600 flex items-center justify-center"><Mic className="w-5 h-5 text-white" /></div>
          <div><h1 className="text-xl font-bold text-white">Diagnostic Vocal</h1><p className="text-xs text-slate-500">Descrie problema cu vocea</p></div>
        </div>
        <div className="glass-card rounded-2xl p-8 mb-6 text-center">
          <button onClick={startListening} disabled={listening} className={`w-24 h-24 rounded-full flex items-center justify-center mx-auto mb-4 transition-all ${listening ? 'bg-red-500 animate-pulse' : 'bg-gradient-to-br from-cyan-500 to-blue-600 hover:scale-110'}`}>
            {listening ? <MicOff className="w-10 h-10 text-white" /> : <Mic className="w-10 h-10 text-white" />}
          </button>
          <p className="text-sm text-slate-400">{listening ? 'Ascult... Descrie problema masinii tale' : 'Apasa pentru a incepe diagnostic vocal'}</p>
        </div>
        {transcript && (
          <div className="glass-card rounded-2xl p-6 mb-4">
            <p className="text-xs text-slate-500 mb-1">TRANSCRIERE</p>
            <p className="text-sm text-white">{transcript}</p>
          </div>
        )}
        <div className="glass-card rounded-2xl p-6 mb-6">
          <p className="text-xs text-slate-500 mb-2">Sau scrie manual:</p>
          <div className="flex gap-2">
            <input value={transcript} onChange={e => setTranscript(e.target.value)} placeholder="Descrie problema..." className="flex-1 glass rounded-xl px-4 py-3 text-white text-sm" />
            <button onClick={() => diagnoseVoice(transcript)} disabled={loading || !transcript} className="btn-primary px-5 text-sm">{loading ? '...' : 'Trimite'}</button>
          </div>
        </div>
        {response && (
          <div className="glass-card rounded-2xl p-6 border-l-4 border-cyan-500">
            <h3 className="text-lg font-bold text-white mb-3">Diagnostic AI</h3>
            <p className="text-sm text-slate-300 whitespace-pre-line">{response}</p>
          </div>
        )}
      </div>
    </div>
  )
}
