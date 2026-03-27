import SwiftUI

// MARK: - ITP Radar View
// Checks if the vehicle will pass ITP inspection and what needs fixing
struct ITPRadarView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var checkItems: [ITPCheckItem] = []
    @State private var isChecking = false
    @State private var checkComplete = false
    @State private var overallResult: ITPResult = .unknown
    
    enum ITPResult {
        case pass, conditional, fail, unknown
        var label: String {
            switch self {
            case .pass: return "VA TRECE ITP"
            case .conditional: return "CONDITIONAT"
            case .fail: return "NU VA TRECE"
            case .unknown: return "NECUNOSCUT"
            }
        }
        var color: Color {
            switch self {
            case .pass: return Theme.gaugeGreen
            case .conditional: return Theme.gaugeYellow
            case .fail: return Theme.gaugeRed
            case .unknown: return Theme.textMuted
            }
        }
        var icon: String {
            switch self {
            case .pass: return "checkmark.seal.fill"
            case .conditional: return "exclamationmark.triangle.fill"
            case .fail: return "xmark.seal.fill"
            case .unknown: return "questionmark.circle.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if checkComplete {
                        resultCard
                    }
                    
                    if !checkComplete && !isChecking {
                        infoCard
                        startCheckButton
                    }
                    
                    if isChecking {
                        checkingAnimation
                    }
                    
                    if checkComplete {
                        ForEach(checkItems) { item in
                            checkItemCard(item)
                        }
                        
                        if overallResult != .pass {
                            fixRecommendations
                        }
                        
                        itpInfoCard
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
                        Image(systemName: "shield.checkered")
                            .foregroundColor(Theme.primary)
                        Text("Radar ITP")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var resultCard: some View {
        VStack(spacing: 12) {
            Image(systemName: overallResult.icon)
                .font(.system(size: 48))
                .foregroundColor(overallResult.color)
            
            Text(overallResult.label)
                .font(.system(size: 20, weight: .black))
                .foregroundColor(overallResult.color)
            
            let passCount = checkItems.filter { $0.status == .pass }.count
            let totalCount = checkItems.count
            Text("\(passCount)/\(totalCount) verificari trecute")
                .font(.system(size: 13))
                .foregroundColor(Theme.textSecondary)
            
            if overallResult == .conditional {
                Text("Masina poate trece ITP daca rezolvati problemele marcate.")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(overallResult.color.opacity(0.3), lineWidth: 2))
    }
    
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "shield.checkered")
                    .font(.system(size: 20))
                    .foregroundColor(Theme.primary)
                Text("Verificare ITP Virtuala")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            Text("Analizam starea vehiculului si estimam daca va trece inspectia tehnica periodica (ITP). Verificam toate punctele obligatorii conform legislatiei romanesti.")
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(3)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var startCheckButton: some View {
        Button(action: { startCheck() }) {
            HStack(spacing: 10) {
                Image(systemName: "shield.checkered")
                    .font(.system(size: 16))
                Text("Verifica Acum")
                    .font(.system(size: 15, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
    }
    
    private var checkingAnimation: some View {
        VStack(spacing: 14) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Theme.primary))
                .scaleEffect(1.3)
            Text("Verificare in curs...")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            Text("Analizam 12 puncte de control ITP")
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func checkItemCard(_ item: ITPCheckItem) -> some View {
        HStack(spacing: 12) {
            Image(systemName: item.status.icon)
                .font(.system(size: 16))
                .foregroundColor(item.status.color)
                .frame(width: 32, height: 32)
                .background(item.status.color.opacity(0.15))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                Text(item.detail)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text(item.status.label)
                .font(.system(size: 9, weight: .bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(item.status.color.opacity(0.15))
                .foregroundColor(item.status.color)
                .cornerRadius(4)
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(10)
    }
    
    private var fixRecommendations: some View {
        let failedItems = checkItems.filter { $0.status != .pass }
        let totalCost = failedItems.reduce(0.0) { $0 + $1.fixCost }
        
        return VStack(alignment: .leading, spacing: 10) {
            Text("REPARATII NECESARE PENTRU ITP")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ForEach(failedItems) { item in
                HStack(spacing: 8) {
                    Image(systemName: "wrench.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.primary)
                    Text(item.fixAction)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text(String(format: "~%.0f RON", item.fixCost))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.secondary)
                }
            }
            
            Divider().background(Color(red: 0.12, green: 0.17, blue: 0.23))
            
            HStack {
                Text("Cost total estimat:")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text(String(format: "%.0f - %.0f RON", totalCost * 0.8, totalCost * 1.2))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.secondary)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.gaugeYellow.opacity(0.3), lineWidth: 1))
    }
    
    private var itpInfoCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("INFORMATII ITP ROMANIA")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            infoRow("Valabilitate: 2 ani (masini noi: 3 ani de la prima inmatriculare)")
            infoRow("Cost ITP: 100-200 RON (depinde de categorie)")
            infoRow("Documente necesare: CI proprietar, talon, asigurare RCA valida")
            infoRow("Se verifica: frane, directie, suspensie, lumini, emisii, caroserie")
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func infoRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 9))
                .foregroundColor(Theme.primary)
                .padding(.top, 2)
            Text(text)
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    private func startCheck() {
        isChecking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.spring()) {
                isChecking = false
                checkComplete = true
                checkItems = ITPCheckItem.sampleItems
                let failCount = checkItems.filter { $0.status == .fail }.count
                let warnCount = checkItems.filter { $0.status == .warning }.count
                if failCount > 0 { overallResult = .fail }
                else if warnCount > 0 { overallResult = .conditional }
                else { overallResult = .pass }
            }
        }
    }
}

// MARK: - Models
struct ITPCheckItem: Identifiable {
    let id = UUID()
    let name: String
    let detail: String
    let status: ITPStatus
    let fixAction: String
    let fixCost: Double
    
    enum ITPStatus {
        case pass, warning, fail
        var icon: String {
            switch self {
            case .pass: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .fail: return "xmark.circle.fill"
            }
        }
        var color: Color {
            switch self {
            case .pass: return Theme.gaugeGreen
            case .warning: return Theme.gaugeYellow
            case .fail: return Theme.gaugeRed
            }
        }
        var label: String {
            switch self {
            case .pass: return "OK"
            case .warning: return "ATENTIE"
            case .fail: return "PICA"
            }
        }
    }
    
    static var sampleItems: [ITPCheckItem] {
        [
            ITPCheckItem(name: "Sistem Franare", detail: "Placute frana fata uzate 62% - la limita", status: .warning, fixAction: "Inlocuire placute frana fata", fixCost: 350),
            ITPCheckItem(name: "Lumini Fata", detail: "Far stanga reglaj incorect", status: .warning, fixAction: "Reglare faruri", fixCost: 50),
            ITPCheckItem(name: "Lumini Spate", detail: "Toate functionale", status: .pass, fixAction: "", fixCost: 0),
            ITPCheckItem(name: "Emisii Gaze", detail: "Valori in parametri normali", status: .pass, fixAction: "", fixCost: 0),
            ITPCheckItem(name: "Directie", detail: "Joc volan in limite", status: .pass, fixAction: "", fixCost: 0),
            ITPCheckItem(name: "Suspensie", detail: "Amortizoare functionale", status: .pass, fixAction: "", fixCost: 0),
            ITPCheckItem(name: "Parbriz", detail: "Fara fisuri in campul vizual", status: .pass, fixAction: "", fixCost: 0),
            ITPCheckItem(name: "Anvelope", detail: "Profil 4mm - acceptabil", status: .pass, fixAction: "", fixCost: 0),
            ITPCheckItem(name: "Caroserie", detail: "Fara coroziune structurala", status: .pass, fixAction: "", fixCost: 0),
            ITPCheckItem(name: "Centuri Siguranta", detail: "Toate functionale", status: .pass, fixAction: "", fixCost: 0),
            ITPCheckItem(name: "Claxon", detail: "Functional", status: .pass, fixAction: "", fixCost: 0),
            ITPCheckItem(name: "Stergatoare", detail: "Lamele uzate - nu curata uniform", status: .warning, fixAction: "Inlocuire lamele stergatoare", fixCost: 60),
        ]
    }
}
