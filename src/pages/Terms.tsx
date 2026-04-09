import { useState } from 'react'
import SectionWrapper from '@/components/SectionWrapper'

export default function Terms() {
  const [tab, setTab] = useState<'termeni' | 'confidentialitate'>('termeni')

  return (
    <>
      <section className="relative pt-32 pb-8">
        <div className="absolute inset-0 hero-glow pointer-events-none" />
        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-4xl sm:text-5xl font-black tracking-tight text-white mb-6">
            {tab === 'termeni' ? 'Termeni si Conditii' : 'Politica de Confidentialitate'}
          </h1>
          <div className="flex justify-center gap-2 mb-8">
            <button onClick={() => setTab('termeni')} className={`px-6 py-2.5 rounded-xl text-sm font-semibold transition-all ${tab === 'termeni' ? 'btn-primary' : 'btn-secondary'}`}>Termeni</button>
            <button onClick={() => setTab('confidentialitate')} className={`px-6 py-2.5 rounded-xl text-sm font-semibold transition-all ${tab === 'confidentialitate' ? 'btn-primary' : 'btn-secondary'}`}>Confidentialitate</button>
          </div>
        </div>
      </section>

      <SectionWrapper>
        <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="glass-card rounded-3xl p-8 lg:p-12">
            {tab === 'termeni' ? (
              <div className="prose prose-invert prose-sm max-w-none space-y-6">
                <p className="text-slate-400 text-sm">Ultima actualizare: {new Date().toLocaleDateString('ro-RO')}</p>
                <h2 className="text-xl font-bold text-white">1. Acceptarea Termenilor</h2>
                <p className="text-slate-400 leading-relaxed">Prin utilizarea aplicatiei AutoDiag Pro, acceptati acesti termeni si conditii. Daca nu sunteti de acord, va rugam sa nu utilizati serviciul.</p>
                <h2 className="text-xl font-bold text-white">2. Descrierea Serviciului</h2>
                <p className="text-slate-400 leading-relaxed">AutoDiag Pro ofera servicii de diagnostic auto bazate pe inteligenta artificiala, incluzand dar fara a se limita la: scanare foto, decodare VIN, decodare coduri DTC, chat AI, predictii si analiza sunet motor.</p>
                <h2 className="text-xl font-bold text-white">3. Limitarea Responsabilitatii</h2>
                <p className="text-slate-400 leading-relaxed">Diagnosticele si recomandarile oferite de AutoDiag Pro sunt orientative si nu inlocuiesc consultarea unui mecanic profesionist. Nu ne asumam responsabilitatea pentru decizii luate exclusiv pe baza rezultatelor aplicatiei.</p>
                <h2 className="text-xl font-bold text-white">4. Proprietate Intelectuala</h2>
                <p className="text-slate-400 leading-relaxed">Tot continutul, designul, codul sursa si algoritmii sunt proprietatea AutoDiag Pro si sunt protejati de legile drepturilor de autor.</p>
                <h2 className="text-xl font-bold text-white">5. Conturi Utilizator</h2>
                <p className="text-slate-400 leading-relaxed">Sunteti responsabil pentru securitatea contului dumneavoastra si pentru toate activitatile desfasurate prin intermediul acestuia.</p>
                <h2 className="text-xl font-bold text-white">6. Modificari ale Termenilor</h2>
                <p className="text-slate-400 leading-relaxed">Ne rezervam dreptul de a modifica acesti termeni in orice moment. Modificarile vor fi notificate prin aplicatie si email.</p>
              </div>
            ) : (
              <div className="prose prose-invert prose-sm max-w-none space-y-6">
                <p className="text-slate-400 text-sm">Ultima actualizare: {new Date().toLocaleDateString('ro-RO')}</p>
                <h2 className="text-xl font-bold text-white">1. Date Colectate</h2>
                <p className="text-slate-400 leading-relaxed">Colectam: informatii despre vehicul (VIN, marca, model, an), date de diagnostic, fotografii (doar pentru analiza), date de utilizare anonimizate. Nu colectam date personale fara consimtamant explicit.</p>
                <h2 className="text-xl font-bold text-white">2. Scopul Prelucrarii</h2>
                <p className="text-slate-400 leading-relaxed">Datele sunt folosite exclusiv pentru: furnizarea serviciului de diagnostic, imbunatatirea algoritmilor AI, comunicari relevante despre serviciu, si suport tehnic.</p>
                <h2 className="text-xl font-bold text-white">3. GDPR Compliance</h2>
                <p className="text-slate-400 leading-relaxed">Respectam pe deplin Regulamentul General privind Protectia Datelor (GDPR). Aveti dreptul la: acces, rectificare, stergere, portabilitate si opozitie la prelucrarea datelor.</p>
                <h2 className="text-xl font-bold text-white">4. Securitatea Datelor</h2>
                <p className="text-slate-400 leading-relaxed">Toate datele sunt criptate end-to-end (AES-256) si stocate in servere securizate din Uniunea Europeana. Implementam masuri tehnice si organizatorice adecvate.</p>
                <h2 className="text-xl font-bold text-white">5. Cookie-uri</h2>
                <p className="text-slate-400 leading-relaxed">Folosim cookie-uri esentiale pentru functionarea serviciului si cookie-uri analitice (cu consimtamant) pentru imbunatatirea experientei.</p>
                <h2 className="text-xl font-bold text-white">6. Contact DPO</h2>
                <p className="text-slate-400 leading-relaxed">Pentru orice intrebari legate de protectia datelor, contactati Ofiterul nostru de Protectie a Datelor la: dpo@autodiagpro.com</p>
              </div>
            )}
          </div>
        </div>
      </SectionWrapper>
    </>
  )
}
