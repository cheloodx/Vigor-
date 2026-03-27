import Foundation
import SwiftUI

struct ChatMessage: Identifiable, Codable {
    var id = UUID()
    var text: String
    var isUser: Bool
    var timestamp: Date = Date()
    var isTyping: Bool = false

    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp)
    }
}

struct QuickSuggestion: Identifiable {
    let id = UUID()
    let text: String
    let icon: String
}

// MARK: - Predefined Suggestions
extension QuickSuggestion {
    static let defaultSuggestions: [QuickSuggestion] = [
        QuickSuggestion(text: "Ce ulei recomandati?", icon: "drop.fill"),
        QuickSuggestion(text: "Cand schimb distributia?", icon: "gearshape.2.fill"),
        QuickSuggestion(text: "Motor face zgomot", icon: "speaker.wave.3.fill"),
        QuickSuggestion(text: "Check engine aprins", icon: "exclamationmark.triangle.fill"),
        QuickSuggestion(text: "Frana trepideaza", icon: "circle.circle.fill"),
        QuickSuggestion(text: "Consum mare combustibil", icon: "fuelpump.fill"),
    ]
}

// MARK: - AI Response Generator
struct MechanicAI {
    static func generateResponse(for query: String, vehicle: Vehicle) -> String {
        let lowerQuery = query.lowercased()

        if lowerQuery.contains("ulei") {
            return """
            Pentru \(vehicle.displayName) cu motor \(vehicle.engineType), recomand:

            🛢️ **Ulei recomandat:** 5W-30 LongLife III (VW 504.00/507.00)
            📏 **Cantitate:** ~4.7 litri
            🔄 **Interval schimb:** la fiecare 15.000 km sau 12 luni

            **Marci recomandate:**
            • Castrol EDGE 5W-30 LL
            • Mobil 1 ESP 5W-30
            • Shell Helix Ultra ECT C3 5W-30

            💡 Nu uitati sa schimbati si filtrul de ulei la fiecare schimb!

            💰 Cost estimat: 280-400 RON (ulei + filtru + manopera)
            """
        }

        if lowerQuery.contains("distribut") {
            return """
            Pentru \(vehicle.displayName):

            ⏰ **Interval curea distributie:** 120.000 km sau 5 ani
            📊 **Kilometraj actual:** \(vehicle.mileage) km

            **Kit complet include:**
            • Curea distributie
            • Role intindere (2-3 buc)
            • Pompa apa (recomandat sa se schimbe impreuna)

            ⚠️ **IMPORTANT:** La motorul \(vehicle.engineType), ruperea curelei cauzeaza deteriorarea supapelor!

            💰 Cost estimat: 1.500-2.200 RON (kit complet + manopera)
            """
        }

        if lowerQuery.contains("zgomot") || lowerQuery.contains("bate") {
            return """
            Zgomotele motorului pot avea mai multe cauze. Pentru \(vehicle.displayName):

            🔍 **Cauze posibile:**
            1. **Hidrotapeti/tacheti** - Zgomot la pornire rece, dispare dupa incalzire
            2. **Curea accesorii** - Scartait, mai ales la pornire
            3. **Injectoare** - Batai specifice diesel, mai puternice cand sunt uzate
            4. **Turbo** - Suierat anormal sau zgomot metalic
            5. **Volanta masa dubla** - Zgomot la relanti in neutral

            🎯 **Recomandare:** Veniti la un diagnostic complet. Folositi functia **Scan** pentru o prima evaluare vizuala!

            ⏱️ Diagnosticul dureaza ~30 minute
            """
        }

        if lowerQuery.contains("check engine") || lowerQuery.contains("eroare") {
            return """
            ⚠️ Lampa Check Engine poate indica multiple probleme:

            **Cauze frecvente la \(vehicle.engineType):**
            1. **Sonda lambda** - cea mai comuna cauza
            2. **EGR** - supapa blocat/murdar
            3. **DPF** - filtru particule colmatat
            4. **MAF** - senzor debit aer defect
            5. **Catalizator** - eficienta sub prag

            🔌 **Recomandare:** Conectati un scanner OBD2 pentru a citi codul exact de eroare (DTC).

            💡 Folositi tab-ul **Live** pentru a vedea parametrii motorului in timp real!

            ❓ Aveti un cod de eroare specific? (ex: P0420, P0171)
            """
        }

        if lowerQuery.contains("frana") || lowerQuery.contains("frin") {
            return """
            Informatii frane pentru \(vehicle.displayName):

            🔧 **Verificare necesara:**
            • Grosime placute fata: minim 3mm
            • Grosime discuri: verificati limita gravata pe disc
            • Lichid frana: schimb la 2 ani (DOT4)

            **Trepidatii la franare = discuri deformate**
            - Cauza: supraincalzire (franare prelungita pe munte)
            - Solutie: rectificare sau inlocuire discuri

            💰 **Costuri estimate:**
            • Placute fata: 220-370 RON
            • Discuri fata: 350-650 RON
            • Lichid frana: 120-180 RON

            📅 Verificati tab-ul **Service** pentru intervalele de mentenanta!
            """
        }

        if lowerQuery.contains("consum") {
            return """
            Consum ridicat la \(vehicle.displayName) (\(vehicle.engineType)):

            📊 **Consum normal:**
            • Oras: 6.5-8.5 l/100km
            • Extraurban: 4.5-5.5 l/100km
            • Mixt: 5.5-6.5 l/100km

            🔍 **Cauze consum marit:**
            1. Filtru aer murdar (+10-15%)
            2. Presiune pneuri scazuta (+5-10%)
            3. Sonda lambda defecta
            4. Injectoare uzate/murdate
            5. Turbo cu probleme
            6. EGR blocat
            7. Stil de condus agresiv

            ✅ **Pasi recomandati:**
            1. Verificati presiunea pneurilor
            2. Schimbati filtrul de aer
            3. Faceti o curatare injectoare
            4. Verificati DPF-ul

            💡 Monitorizati consumul cu tab-ul **Live**!
            """
        }

        if lowerQuery.contains("vibre") || lowerQuery.contains("vibra") {
            return """
            Vibratii la \(vehicle.displayName):

            🔍 **Cauze posibile in functie de situatie:**

            **La mers / viteza mare (>80 km/h):**
            • Roti neechilibrate
            • Jante deformate
            • Cardane uzate (tractiune fata)
            • Rulmenti roti defecti

            **La relanti / stationare:**
            • Suporti motor uzati/rupti
            • Volanta masa dubla defecta
            • Injectoare dezechilibrate
            • Bujii uzate (benzina)

            **La franare:**
            • Discuri frana deformate
            • Placute uzate neuniform
            • Etrier blocat

            💡 Faceti un test: vibratia se simte in volan, in scaun sau in tot corpul? Asta ajuta la localizare!

            💰 Echilibrare roti: 80-120 RON | Suport motor: 200-500 RON
            """
        }

        if lowerQuery.contains("turbo") {
            return """
            Probleme turbo la \(vehicle.displayName) (\(vehicle.engineType)):

            ⚠️ **Simptome turbo defect:**
            • Pierdere putere (masina "nu mai trage")
            • Fum albastru/gri la esapament
            • Suierat anormal sau zgomot metalic
            • Consum ulei crescut
            • Check engine aprins

            🔧 **Verificari:**
            1. Verificati furtunurile de intercooler (fisuri, deconectari)
            2. Joc axial pe axul turbinei
            3. Geometrie variabila blocata (la VNT/VGT)
            4. Actuator turbo electronic

            💰 **Costuri estimate:**
            • Reconditionare turbo: 800-1.500 RON
            • Turbo nou aftermarket: 1.500-3.000 RON
            • Turbo original: 3.000-6.000 RON
            • Manopera: 400-800 RON
            """
        }

        if lowerQuery.contains("baterie") || lowerQuery.contains("acumulator") || lowerQuery.contains("pornire") {
            return """
            Probleme electrice / baterie la \(vehicle.displayName):

            🔋 **Diagnosticare baterie:**
            • Tensiune la repaus: >12.4V = OK, <12.0V = Slaba
            • Tensiune la pornire: >10.5V
            • Tensiune cu motor pornit: 13.5-14.5V (alternator)

            💡 Verificati in tab-ul **Live** tensiunea in timp real!

            **Cauze pornire dificila:**
            1. Baterie descarcata/uzata (durata viata: 4-6 ani)
            2. Alternator defect (nu incarca)
            3. Electromotor uzat
            4. Bujii incandescente (diesel, la rece)
            5. Conexiuni oxidate pe borne

            ✅ **Recomandare:** Verificati bateria cu un tester profesional la orice service auto.

            💰 Baterie noua: 300-600 RON | Alternator: 500-1.200 RON
            """
        }

        if lowerQuery.contains("dpf") || lowerQuery.contains("particule") || lowerQuery.contains("fap") {
            return """
            Probleme DPF/FAP la \(vehicle.displayName) (\(vehicle.engineType)):

            🔍 **Ce este DPF-ul?**
            Filtrul de particule retine funinginea din gazele de esapament (diesel).

            ⚠️ **Simptome DPF colmatat:**
            • Lampa DPF aprinsa pe bord
            • Pierdere putere
            • Turatie instabila
            • Regenerari frecvente (consum crescut)
            • Miros de ars

            🔧 **Solutii:**
            1. **Regenerare fortata** cu diagnoza (80-150 RON)
            2. **Curatare chimica** cu aditiv (200-400 RON)
            3. **Curatare profesionala** ultrasonete (500-800 RON)
            4. **Inlocuire DPF** (1.500-4.000 RON)

            💡 **Preventie:** Condus pe autostrada 30min la 3000+ RPM lunar, folositi combustibil de calitate.
            """
        }

        if lowerQuery.contains("directie") || lowerQuery.contains("volan") {
            return """
            Probleme directie la \(vehicle.displayName):

            🔍 **Simptome frecvente:**
            • Volan greu la parcare → pompa servodirectie sau lichid scazut
            • Volan vibreaza la viteza → echilibrare roti
            • Masina trage intr-o parte → geometrie gresita sau presiune pneuri diferita
            • Zgomot la rotirea volanului → planetare sau bieleta directie

            🔧 **Verificari recomandate:**
            1. Nivel lichid servodirectie
            2. Bieleta directie (joc)
            3. Cap bara directie
            4. Geometrie roti (toe, camber, caster)
            5. Planetare (burduf rupt = inlocuire urgenta)

            💰 **Costuri estimate:**
            • Geometrie: 100-200 RON
            • Bieleta directie: 80-200 RON
            • Planetara: 300-600 RON
            • Pompa servodirectie: 500-1.200 RON
            """
        }

        if lowerQuery.contains("ac ") || lowerQuery.contains("clima") || lowerQuery.contains("aer conditionat") {
            return """
            Climatizare la \(vehicle.displayName):

            ❄️ **Probleme frecvente AC:**
            1. Nu raceste → freon scazut sau compresor defect
            2. Miros neplacut → filtru habitaclu murdar sau evaporator cu mucegai
            3. Zgomot la pornire AC → compresor sau curea
            4. Clima functioneaza intermitent → senzor presiune sau releu

            🔧 **Mentenanta recomandata:**
            • Incarcare freon: anual sau cand nu mai raceste
            • Filtru habitaclu: la 15.000 km
            • Dezinfectie circuit: anual (primavara)

            💰 **Costuri:**
            • Incarcare freon R134a: 150-250 RON
            • Filtru habitaclu: 40-80 RON
            • Compresor AC: 1.000-2.500 RON
            • Dezinfectie: 80-150 RON

            📅 Verificati tab-ul **Service** pentru intervalul filtrului de habitaclu!
            """
        }

        if lowerQuery.contains("itp") || lowerQuery.contains("inspectie") || lowerQuery.contains("tehnic") {
            return """
            Pregatire ITP pentru \(vehicle.displayName):

            📋 **Puncte verificate la ITP:**
            1. ✅ Frane (eficienta, echilibru)
            2. ✅ Directie (jocuri)
            3. ✅ Suspensie (amortizoare, articulatii)
            4. ✅ Lumini (toate functionale + reglaj faruri)
            5. ✅ Emisii (CO, opacitate diesel)
            6. ✅ Anvelope (min 1.6mm, fara taieturi)
            7. ✅ Parbriz (fara fisuri in zona soferului)
            8. ✅ Caroserie (fara rugina perforanta)

            ⚠️ **Motive frecvente de respingere:**
            • Jocuri la directie/suspensie
            • Faruri dezreglate
            • Emisii peste limita (DPF/catalizator)
            • Frane dezechilibrate

            💰 Taxa ITP: ~150 RON | Pregatire: 200-500 RON
            """
        }

        // Default response
        return """
        Multumesc pentru intrebare! 🔧

        Pentru \(vehicle.displayName) cu motor \(vehicle.engineType) si \(vehicle.mileage) km:

        Am inteles problema ta. Iti recomand sa:

        1. **Folosesti functia Scan** - Fa o poza zonei cu probleme pentru un diagnostic vizual AI
        2. **Verifica Live** - Conecteaza OBD2 pentru parametrii in timp real
        3. **Calendar Service** - Verifica daca ai interventii restante

        Poti sa imi dai mai multe detalii? De exemplu:
        • Cand apare problema? (la rece/la cald)
        • Este constant sau intermitent?
        • Se agraveaza la accelerare?

        Sunt aici sa te ajut! 💪
        """
    }
}
