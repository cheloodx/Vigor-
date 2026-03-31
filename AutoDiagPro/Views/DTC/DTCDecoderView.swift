import SwiftUI

// MARK: - DTC Error Decoder View
// Decode OBD2 DTC codes with full explanation in Romanian
struct DTCDecoderView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var viewModel = DTCDecoderViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Input card
                    inputCard
                    
                    // Decoded result
                    if viewModel.isDecoding {
                        decodingCard
                    }
                    
                    if let error = viewModel.decodedError {
                        decodedCard(error)
                    }
                    
                    // Recent codes
                    if !viewModel.recentCodes.isEmpty {
                        recentCodesSection
                    }
                    
                    // Common codes reference
                    if viewModel.decodedError == nil && !viewModel.isDecoding {
                        commonCodesCard
                    }
                    
                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(Theme.gaugeYellow)
                        Text("Decodor Erori DTC")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var inputCard: some View {
        VStack(spacing: 12) {
            Text("Introdu codul de eroare OBD2")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            
            HStack(spacing: 8) {
                TextField("Ex: P0300", text: $viewModel.dtcInput)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(Theme.textPrimary)
                    .padding(12)
                    .background(Color(red: 0.06, green: 0.09, blue: 0.14))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
                    .autocapitalization(.allCharacters)
                
                Button(action: { viewModel.decodeDTC() }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Theme.primary)
                        .cornerRadius(10)
                }
                .disabled(viewModel.dtcInput.trimmingCharacters(in: .whitespaces).count < 5)
                .opacity(viewModel.dtcInput.trimmingCharacters(in: .whitespaces).count < 5 ? 0.5 : 1)
            }
            
            // Quick access codes
            HStack(spacing: 6) {
                Text("Rapid:")
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
                ForEach(["P0300", "P0171", "P0420", "P0442"], id: \.self) { code in
                    Button(action: { viewModel.selectCode(code) }) {
                        Text(code)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Theme.primary.opacity(0.1))
                            .foregroundColor(Theme.primary)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var decodingCard: some View {
        VStack(spacing: 10) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Theme.primary))
            Text("Decodare \(viewModel.dtcInput.uppercased())...")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func decodedCard(_ error: DTCError) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(error.code)
                    .font(.system(size: 22, weight: .black, design: .monospaced))
                    .foregroundColor(error.severity.color)
                
                Spacer()
                
                Text(error.severity.label)
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(error.severity.color.opacity(0.2))
                    .foregroundColor(error.severity.color)
                    .cornerRadius(6)
            }
            
            // System + category
            HStack(spacing: 12) {
                infoChip(icon: "gearshape.fill", text: error.system)
                infoChip(icon: "folder.fill", text: error.category)
            }
            
            Divider().background(Color(red: 0.12, green: 0.17, blue: 0.23))
            
            // Description
            VStack(alignment: .leading, spacing: 4) {
                Text("DESCRIERE")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1)
                Text(error.description)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textPrimary)
                    .lineSpacing(3)
            }
            
            // Causes
            VStack(alignment: .leading, spacing: 6) {
                Text("CAUZE POSIBILE")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1)
                ForEach(error.causes, id: \.self) { cause in
                    HStack(alignment: .top, spacing: 6) {
                        Text("•")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.primary)
                        Text(cause)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
            
            // Symptoms
            VStack(alignment: .leading, spacing: 6) {
                Text("SIMPTOME")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1)
                ForEach(error.symptoms, id: \.self) { symptom in
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 9))
                            .foregroundColor(Theme.gaugeYellow)
                            .padding(.top, 2)
                        Text(symptom)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
            
            // Fix
            VStack(alignment: .leading, spacing: 6) {
                Text("REPARATIE RECOMANDATA")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1)
                Text(error.fix)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(3)
            }
            
            // Cost & driving safety
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Cost Reparatie")
                        .font(.system(size: 9))
                        .foregroundColor(Theme.textMuted)
                    Text(error.costRange)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Condus Sigur?")
                        .font(.system(size: 9))
                        .foregroundColor(Theme.textMuted)
                    HStack(spacing: 4) {
                        Image(systemName: error.canDrive ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 12))
                        Text(error.canDrive ? "Da, cu atentie" : "Nu, oprit imediat!")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(error.canDrive ? Theme.gaugeYellow : Theme.gaugeRed)
                }
            }
            .padding(10)
            .background(Theme.surfaceBackground)
            .cornerRadius(8)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(error.severity.color.opacity(0.3), lineWidth: 1))
    }
    
    private var recentCodesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CODURI RECENTE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ForEach(viewModel.recentCodes) { code in
                Button(action: { viewModel.selectRecentCode(code) }) {
                    HStack {
                        Text(code.code)
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundColor(code.severity.color)
                        Text(code.shortDescription)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(10)
                    .background(Theme.surfaceBackground)
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private var commonCodesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CODURI FRECVENTE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            Text("Pxxxx = Motor | Bxxxx = Caroserie | Cxxxx = Sasiu | Uxxxx = Retea")
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
            
            ForEach(DTCError.commonCodes, id: \.code) { dtc in
                Button(action: { viewModel.selectCode(dtc.code) }) {
                    HStack {
                        Text(dtc.code)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(dtc.severity.color)
                            .frame(width: 55, alignment: .leading)
                        Text(dtc.shortDescription)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                        Spacer()
                    }
                    .padding(8)
                    .background(Theme.surfaceBackground)
                    .cornerRadius(6)
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func infoChip(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 9))
            Text(text)
                .font(.system(size: 10))
        }
        .foregroundColor(Theme.textMuted)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(red: 0.08, green: 0.12, blue: 0.18))
        .cornerRadius(6)
    }
    
}

// MARK: - DTC Error Model
struct DTCError: Identifiable {
    let id = UUID()
    let code: String
    let shortDescription: String
    let description: String
    let system: String
    let category: String
    let severity: DTCSeverity
    let causes: [String]
    let symptoms: [String]
    let fix: String
    let costRange: String
    let canDrive: Bool
    
    enum DTCSeverity {
        case critical, major, minor
        var color: Color {
            switch self {
            case .critical: return Theme.gaugeRed
            case .major: return Theme.gaugeYellow
            case .minor: return Theme.gaugeGreen
            }
        }
        var label: String {
            switch self {
            case .critical: return "CRITIC"
            case .major: return "MAJOR"
            case .minor: return "MINOR"
            }
        }
    }
    
    static func decode(_ code: String) -> DTCError {
        if let known = dtcDatabase[code] { return known }
        
        let system: String
        let prefix = code.prefix(1)
        switch prefix {
        case "P": system = "Motor / Transmisie"
        case "B": system = "Caroserie"
        case "C": system = "Sasiu"
        case "U": system = "Retea Comunicatie"
        default: system = "Necunoscut"
        }
        
        return DTCError(code: code, shortDescription: "Cod necunoscut", description: "Codul \(code) nu a fost gasit in baza de date. Consultati un mecanic autorizat cu echipament de diagnoza profesional pentru interpretarea acestui cod.", system: system, category: "General", severity: .minor, causes: ["Cod specific producatorului", "Poate necesita software de diagnoza marca"], symptoms: ["Verificati lampa Check Engine"], fix: "Consultati un mecanic autorizat cu echipament de diagnoza pentru marca vehiculului.", costRange: "Variabil", canDrive: true)
    }
    
    static let commonCodes: [DTCError] = [
        dtcDatabase["P0300"]!, dtcDatabase["P0171"]!, dtcDatabase["P0420"]!,
        dtcDatabase["P0442"]!, dtcDatabase["P0128"]!, dtcDatabase["P0401"]!,
    ]
    
    static let dtcDatabase: [String: DTCError] = [
        "P0300": DTCError(code: "P0300", shortDescription: "Rateu aprindere aleator", description: "S-au detectat rateuri de aprindere aleatorii pe mai multi cilindri simultan. Motorul nu functioneaza uniform, ceea ce afecteaza performanta si consumul.", system: "Motor", category: "Aprindere", severity: .major, causes: ["Bujii uzate sau defecte", "Bobine de inductie defecte", "Injectoare murdate sau blocate", "Compresie scazuta pe cilindri", "Senzor pozitie arbore cotit defect"], symptoms: ["Motor care trepideaza la relanti", "Pierdere de putere in accelerare", "Consum crescut de combustibil", "Lampa Check Engine aprinsa"], fix: "Verificati si inlocuiti bujiile si bobinele de inductie. Testati injectoarele. Daca persista, verificati compresia pe fiecare cilindru.", costRange: "200 - 800 RON", canDrive: true),
        "P0171": DTCError(code: "P0171", shortDescription: "Amestec prea slab (Bancul 1)", description: "ECU-ul a detectat ca amestecul aer-combustibil este prea slab (prea mult aer sau prea putin combustibil) pe bancul 1 al motorului.", system: "Motor", category: "Alimentare", severity: .major, causes: ["Senzor MAF murdar sau defect", "Scurgeri la galeria de admisie", "Pompa de combustibil slaba", "Filtru combustibil infundat", "Sonda lambda defecta"], symptoms: ["Motor care se opreste la relanti", "Pierdere de putere", "Trepidatii motor", "Pornire dificila"], fix: "Curatati sau inlocuiti senzorul MAF. Verificati scurgerile de vacuum la galeria de admisie. Testati presiunea combustibilului.", costRange: "150 - 600 RON", canDrive: true),
        "P0420": DTCError(code: "P0420", shortDescription: "Eficienta catalizator sub prag", description: "Catalizatorul de pe bancul 1 nu mai functioneaza la eficienta necesara pentru a reduce emisiile poluante conform normelor.", system: "Motor", category: "Emisii", severity: .major, causes: ["Catalizator uzat sau deteriorat", "Sonde lambda defecte", "Scurgeri la evacuare", "Amestec incorect aer-combustibil prelungit"], symptoms: ["Lampa Check Engine aprinsa", "Miros de oua clocite la evacuare", "Posibil consum crescut", "Nu va trece ITP la emisii"], fix: "Verificati sondele lambda inainte de inlocuirea catalizatorului. Un catalizator nou este scump - asigurati-va ca e necesar.", costRange: "500 - 3500 RON", canDrive: true),
        "P0442": DTCError(code: "P0442", shortDescription: "Scurgere mica EVAP", description: "Sistemul de control al emisiilor evaporative (EVAP) a detectat o scurgere mica in circuitul de vapori de combustibil.", system: "Motor", category: "Emisii", severity: .minor, causes: ["Capacul de combustibil nu e bine inchis", "Capacul de combustibil uzat/crapat", "Furtun EVAP fisurat", "Valve EVAP defecte"], symptoms: ["Lampa Check Engine aprinsa", "Posibil miros de benzina"], fix: "Verificati mai intai capacul de combustibil - inchideti-l bine sau inlocuiti-l. Daca eroarea persista, verificati furtunurile EVAP.", costRange: "20 - 300 RON", canDrive: true),
        "P0128": DTCError(code: "P0128", shortDescription: "Termostat sub temperatura", description: "Termostatul nu permite motorului sa atinga temperatura optima de functionare in timpul stabilit. Motorul ramane prea rece.", system: "Motor", category: "Racire", severity: .minor, causes: ["Termostat blocat in pozitia deschis", "Senzor temperatura lichid racire defect", "Nivel scazut lichid racire"], symptoms: ["Motor care se incalzeste foarte greu", "Caldura slaba in habitaclu", "Consum usor crescut"], fix: "Inlocuiti termostatul. Este o reparatie relativ simpla si ieftina. Verificati si lichidul de racire.", costRange: "100 - 250 RON", canDrive: true),
        "P0401": DTCError(code: "P0401", shortDescription: "Debit insuficient EGR", description: "Valva EGR (recirculare gaze evacuare) nu permite suficiente gaze de evacuare sa recirculeze. Creste emisiile de NOx.", system: "Motor", category: "Emisii", severity: .minor, causes: ["Valva EGR blocata cu depuneri de carbon", "Conducte EGR infundate", "Senzor diferential presiune EGR defect", "Vacuum insuficient la valva EGR"], symptoms: ["Lampa Check Engine aprinsa", "Posibil sughit la relanti", "Emisii NOx crescute la ITP"], fix: "Curatati valva EGR si conductele de depuneri de carbon. Daca e prea blocata, inlocuiti valva EGR.", costRange: "200 - 600 RON", canDrive: true),
    ]
}
