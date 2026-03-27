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
