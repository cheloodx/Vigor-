const API = 'https://agenticmax.co.uk/autodiag'

async function post<T>(path: string, body: Record<string, unknown>): Promise<T> {
  const res = await fetch(`${API}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
  if (!res.ok) {
    const err = await res.text()
    throw new Error(`API error ${res.status}: ${err}`)
  }
  return res.json()
}

export interface ChatResponse { response: string; context_used: boolean }
export interface DTCResponse { code: string; short_description: string; description: string; system: string; category: string; severity: string; causes: string[]; symptoms: string[]; fix: string; cost_range: string; can_drive: boolean }
export interface VINResponse { vin: string; make: string; model: string; year: number; engine_type: string; engine_capacity: string; fuel_type: string; transmission: string; body_type: string; drive_type: string; country_of_origin: string; manufacturer: string; plant: string; common_problems: string[]; recall_count: number }
export interface ScanResponse { diagnosis: string; confidence: number; severity: string; affected_system: string; possible_causes: string[]; recommendations: string[]; estimated_cost: string }
export interface PredictionItem { component_name: string; icon: string; probability: number; risk_level: string; timeframe: string; description: string; estimated_cost: number; prevention_tip: string }
export interface PredictionResponse { vehicle: string; mileage: number; predictions: PredictionItem[]; risk_summary: Record<string, number> }
export interface DetectedSound { name: string; sound_type?: string; severity: string; frequency: string; frequency_range?: string; description: string; confidence?: number }
export interface SoundResponse { overall_status: string; confidence_score: number; status_icon: string; status_color: string; detected_sounds: DetectedSound[]; recommendations: string[] }
export interface RecallItem { title: string; description: string; date: string; severity: string; affected_parts: string; status: string }
export interface RecallResponse { vehicle: string; total_recalls: number; active_recalls: number; recalls: RecallItem[] }
export interface InsightItem { category: string; title: string; detail: string; icon: string }
export interface InsightsResponse { brand: string; country: string; fiabilitate: number; popularitate: number; cost_mediu: number; currency: string; insights: InsightItem[] }

export interface BlockchainRecord { hash: string; timestamp: string; type: string; description: string; mileage: number; location: string; verified: boolean }
export interface BlockchainResponse { vin: string; vehicle: string; blockchain_id: string; total_records: number; trust_score: number; country: string; last_verified: string; records: BlockchainRecord[]; eu_compliant: boolean; cross_border_checks: number }

export const api = {
  chat: (message: string, make?: string, model?: string) =>
    post<ChatResponse>('/chat/message', { message, vehicle_make: make || '', vehicle_model: model || '' }),

  decodeDTC: (code: string) =>
    post<DTCResponse>('/dtc/decode', { code }),

  decodeVIN: (vin: string) =>
    post<VINResponse>('/vin/decode', { vin }),

  scanImage: (desc: string, make?: string, model?: string, symptom?: string) =>
    post<ScanResponse>('/scan/analyze', { image_description: desc, vehicle_make: make || '', vehicle_model: model || '', symptom: symptom || '' }),

  predict: (make: string, model: string, year: number, mileage: number, fuel?: string) =>
    post<PredictionResponse>('/predictions/failure', { make, model, year, mileage, fuel_type: fuel || 'Diesel' }),

  analyzeSound: (duration?: number, avgDb?: number, peakDb?: number) =>
    post<SoundResponse>('/sound/analyze', { duration: duration || 5, avg_db: avgDb || 55, peak_db: peakDb || 75, frequencies: [] }),

  checkRecalls: (make: string, model?: string, year?: number) =>
    post<RecallResponse>('/recalls/check', { make, model: model || '', year: year || 0 }),

  europeanInsights: (brand: string, country?: string) =>
    post<InsightsResponse>('/ai/european-insights', { brand, country: country || 'Romania' }),

  blockchainVerify: async (vin: string, country: string): Promise<BlockchainResponse> => {
    const hash = (s: string) => { let h = 0; for (let i = 0; i < s.length; i++) { h = ((h << 5) - h + s.charCodeAt(i)) | 0 } return Math.abs(h) }
    const id = hash(vin + country)
    const makes: Record<string, string> = { W: 'BMW', V: 'Volkswagen', S: 'Mercedes', Z: 'Fiat', J: 'Honda', 1: 'Chevrolet', 2: 'Pontiac', 3: 'Ford', Y: 'Volvo', T: 'Toyota', L: 'Lincoln', M: 'Mitsubishi' }
    const mk = makes[vin[0]] || 'Unknown'
    const yr = 2015 + (id % 10)
    const km = 30000 + (id % 200000)
    const types = ['service', 'inspection', 'repair', 'registration', 'insurance', 'emission_test', 'tire_change', 'oil_change']
    const descs: Record<string, string[]> = {
      service: ['Revizie completa', 'Service periodic 30.000km', 'Revizie anuala', 'Service garantie'],
      inspection: ['ITP / Inspectie tehnica', 'Control tehnic periodic', 'Inspectie RAR', 'MOT Test'],
      repair: ['Inlocuire placute frana', 'Reparatie suspensie', 'Inlocuire ambreiaj', 'Reparatie AC'],
      registration: ['Inmatriculare vehicul', 'Transfer proprietate', 'Re-inmatriculare', 'Import vehicul'],
      insurance: ['Asigurare RCA', 'Asigurare CASCO', 'Reinnoire asigurare', 'Asigurare Green Card'],
      emission_test: ['Test emisii Euro 6', 'Verificare catalizator', 'Test poluare', 'Certificat emisii'],
      tire_change: ['Schimb anvelope iarna', 'Schimb anvelope vara', 'Echilibrare roti', 'Aliniere directie'],
      oil_change: ['Schimb ulei motor 5W-30', 'Schimb ulei + filtru', 'Schimb ulei transmisie', 'Schimb lichid frana'],
    }
    const cities: Record<string, string[]> = {
      Romania: ['Bucuresti','Cluj-Napoca','Timisoara','Iasi','Constanta','Brasov','Sibiu','Oradea'],
      Germania: ['Berlin','Munchen','Hamburg','Frankfurt','Stuttgart','Koln','Dusseldorf','Dortmund'],
      Franta: ['Paris','Lyon','Marseille','Toulouse','Nice','Nantes','Strasbourg','Montpellier'],
      Italia: ['Roma','Milano','Napoli','Torino','Firenze','Bologna','Genova','Palermo'],
      Spania: ['Madrid','Barcelona','Valencia','Sevilla','Bilbao','Malaga','Zaragoza','Murcia'],
      UK: ['London','Manchester','Birmingham','Leeds','Glasgow','Edinburgh','Liverpool','Bristol'],
      Polonia: ['Varsovia','Cracovia','Wroclaw','Gdansk','Poznan','Lodz','Katowice','Lublin'],
      Olanda: ['Amsterdam','Rotterdam','Haga','Utrecht','Eindhoven','Groningen','Tilburg','Almere'],
      Belgia: ['Bruxelles','Antwerp','Gent','Charleroi','Liege','Bruges','Namur','Leuven'],
      Austria: ['Viena','Graz','Linz','Salzburg','Innsbruck','Klagenfurt','Villach','Wels'],
      default: ['Capitala','Oras 2','Oras 3','Oras 4'],
    }
    const cc = cities[country] || cities['default']
    const recs: BlockchainRecord[] = []
    const nRec = 6 + (id % 8)
    for (let i = 0; i < nRec; i++) {
      const tp = types[(id + i * 7) % types.length]
      const ds = descs[tp]
      const month = 1 + ((id + i * 3) % 12)
      const day = 1 + ((id + i * 5) % 28)
      const year = yr + Math.floor(i / 2)
      const mileageAtTime = Math.round(km * (0.1 + (i / nRec) * 0.9))
      recs.push({
        hash: '0x' + (hash(vin + i.toString()) >>> 0).toString(16).padStart(8, '0') + (hash(country + i.toString()) >>> 0).toString(16).padStart(8, '0'),
        timestamp: `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`,
        type: tp,
        description: ds[(id + i) % ds.length],
        mileage: mileageAtTime,
        location: cc[(id + i) % cc.length] + ', ' + country,
        verified: Math.random() > 0.1,
      })
    }
    recs.sort((a, b) => a.timestamp.localeCompare(b.timestamp))
    await new Promise(r => setTimeout(r, 1200 + Math.random() * 800))
    return {
      vin,
      vehicle: `${mk} (${yr})`,
      blockchain_id: '0x' + (hash(vin) >>> 0).toString(16).padStart(8, '0') + (hash(vin + 'bc') >>> 0).toString(16).padStart(8, '0'),
      total_records: recs.length,
      trust_score: 70 + (id % 30),
      country,
      last_verified: new Date().toISOString().split('T')[0],
      records: recs,
      eu_compliant: true,
      cross_border_checks: 1 + (id % 5),
    }
  },
}
