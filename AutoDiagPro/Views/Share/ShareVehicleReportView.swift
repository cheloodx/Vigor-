import SwiftUI

// MARK: - Share Vehicle Report View
// "Scan a friend's car -> see full history and risks"
// Viral feature: share simple, used when buying cars
struct ShareVehicleReportView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedTab: ShareTab = .generate
    @State private var isGenerating = false
    @State private var reportGenerated = false
    @State private var shareLink = ""
    @State private var recipientName = ""
    @State private var includeHistory = true
    @State private var includeOBD = true
    @State private var includeCosts = true
    @State private var includePhotos = true
    @State private var reportScore: Int = 0
    
    enum ShareTab: String, CaseIterable {
        case generate = "Genereaza"
        case scan = "Scaneaza Masina"
        case received = "Primite"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    // Header
                    shareHeader
                    
                    // Tab selector
                    HStack(spacing: 4) {
                        ForEach(ShareTab.allCases, id: \.self) { tab in
                            Button(action: { withAnimation { selectedTab = tab } }) {
                                Text(tab.rawValue)
                                    .font(.system(size: 11, weight: selectedTab == tab ? .bold : .regular))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedTab == tab ? Theme.primary : Theme.surfaceBackground)
                                    .foregroundColor(selectedTab == tab ? .white : Theme.textSecondary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    switch selectedTab {
                    case .generate: generateContent
                    case .scan: scanContent
                    case .received: receivedContent
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
                        Image(systemName: "square.and.arrow.up.fill")
                            .foregroundColor(Theme.primary)
                        Text("Raport Vehicul")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Header
    private var shareHeader: some View {
        VStack(spacing: 8) {
            Image(systemName: "doc.richtext.fill")
                .font(.system(size: 36))
                .foregroundColor(Theme.primary)
            
            Text("Trimite sau Primeste Raport Auto")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Genereaza un raport complet al masinii tale si trimite-l unui cumparator, sau scaneaza masina cuiva pentru a vedea riscurile")
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Generate Content
    private var generateContent: some View {
        VStack(spacing: 12) {
            // Vehicle info
            HStack(spacing: 12) {
                Image(systemName: "car.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Theme.primary)
                    .frame(width: 40, height: 40)
                    .background(Theme.primary.opacity(0.15))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(vehicleManager.currentVehicle.displayName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    Text("\(vehicleManager.currentVehicle.mileage) km | \(vehicleManager.currentVehicle.engineType)")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textSecondary)
                }
                Spacer()
            }
            .padding(12)
            .background(Theme.cardBackground)
            .cornerRadius(10)
            
            // Include options
            VStack(alignment: .leading, spacing: 10) {
                Text("CE SA INCLUDA RAPORTUL")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                includeToggle(title: "Istoric complet reparatii", subtitle: "Toate reparatiile, reviziile, ITP-urile", icon: "clock.arrow.circlepath", isOn: $includeHistory)
                includeToggle(title: "Date OBD2 live", subtitle: "Starea actuala a motorului si senzorilor", icon: "antenna.radiowaves.left.and.right", isOn: $includeOBD)
                includeToggle(title: "Costuri intretinere", subtitle: "Total cheltuieli si costuri viitoare", icon: "creditcard.fill", isOn: $includeCosts)
                includeToggle(title: "Fotografii vehicul", subtitle: "Poze recente ale masinii", icon: "camera.fill", isOn: $includePhotos)
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            
            // Recipient
            VStack(alignment: .leading, spacing: 6) {
                Text("DESTINATAR (OPTIONAL)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                TextField("Nume cumparator sau mecanic", text: $recipientName)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textPrimary)
                    .padding(10)
                    .background(Theme.surfaceBackground)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.primary.opacity(0.2), lineWidth: 1))
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            
            // Generate button
            if reportGenerated {
                // Share options
                VStack(spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.gaugeGreen)
                        Text("Raport generat cu succes!")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.gaugeGreen)
                    }
                    
                    // Share link
                    HStack {
                        Text(shareLink)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(Theme.primary)
                            .lineLimit(1)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.primary)
                        }
                    }
                    .padding(10)
                    .background(Theme.surfaceBackground)
                    .cornerRadius(8)
                    
                    // Share buttons
                    HStack(spacing: 8) {
                        shareButton(icon: "square.and.arrow.up", text: "Trimite", color: Theme.primary)
                        shareButton(icon: "message.fill", text: "WhatsApp", color: Color(red: 0.15, green: 0.68, blue: 0.38))
                        shareButton(icon: "envelope.fill", text: "Email", color: Color(red: 0.2, green: 0.5, blue: 0.9))
                    }
                }
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
            } else {
                Button(action: generateReport) {
                    HStack(spacing: 8) {
                        if isGenerating {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.white)
                            Text("Se genereaza raportul...")
                                .font(.system(size: 14, weight: .bold))
                        } else {
                            Image(systemName: "doc.badge.plus")
                            Text("Genereaza Raport")
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.primaryGradient)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isGenerating)
            }
        }
    }
    
    private func includeToggle(title: String, subtitle: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Theme.primary)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .tint(Theme.primary)
        }
    }
    
    private func shareButton(icon: String, text: String, color: Color) -> some View {
        Button(action: {}) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(text)
                    .font(.system(size: 10, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(10)
        }
    }
    
    // MARK: - Scan Content
    private var scanContent: some View {
        VStack(spacing: 14) {
            // Scan explanation
            VStack(spacing: 12) {
                Image(systemName: "viewfinder")
                    .font(.system(size: 44))
                    .foregroundColor(Theme.primary.opacity(0.5))
                
                Text("Scaneaza Masina Cuiva")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                Text("Verifica istoricul si riscurile unei masini inainte de cumparare. Ai nevoie de VIN-ul sau numarul de inmatriculare.")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            
            // Scan options
            Button(action: {}) {
                HStack(spacing: 10) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 16))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Fotografiaza VIN-ul")
                            .font(.system(size: 13, weight: .bold))
                        Text("Scanez automat cu AI OCR")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(14)
                .background(Theme.primaryGradient)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            Button(action: {}) {
                HStack(spacing: 10) {
                    Image(systemName: "keyboard")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.primary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Introducere manuala VIN/Nr")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        Text("Tastezi codul VIN sau numarul")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.textMuted)
                }
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.primary.opacity(0.2), lineWidth: 1))
            }
            
            // What you get
            VStack(alignment: .leading, spacing: 8) {
                Text("CE AFLI DESPRE MASINA")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                scanFeatureRow(icon: "exclamationmark.triangle.fill", text: "Accidente si daune raportate", color: Theme.gaugeRed)
                scanFeatureRow(icon: "speedometer", text: "Verificare kilometraj (potentiale rulaje)", color: Theme.gaugeYellow)
                scanFeatureRow(icon: "wrench.fill", text: "Istoric service si reparatii", color: Theme.primary)
                scanFeatureRow(icon: "person.2.fill", text: "Numar proprietari anteriori", color: Color.purple)
                scanFeatureRow(icon: "shield.fill", text: "Status RCA si ITP", color: Theme.gaugeGreen)
                scanFeatureRow(icon: "banknote.fill", text: "Valoare estimata pe piata", color: Theme.secondary)
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
        }
    }
    
    private func scanFeatureRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(color)
                .frame(width: 20)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    // MARK: - Received Content
    private var receivedContent: some View {
        VStack(spacing: 12) {
            // Sample received reports
            ForEach(ReceivedReport.samples) { report in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(report.riskColor.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: report.riskIcon)
                            .font(.system(size: 18))
                            .foregroundColor(report.riskColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(report.vehicleName)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        Text("De la: \(report.senderName) | \(report.dateFormatted)")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                        HStack(spacing: 4) {
                            Text("Risc:")
                                .font(.system(size: 10))
                                .foregroundColor(Theme.textMuted)
                            Text(report.riskLevel)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(report.riskColor)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("\(report.score)")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(report.riskColor)
                        Text("/100")
                            .font(.system(size: 9))
                            .foregroundColor(Theme.textMuted)
                    }
                }
                .padding(12)
                .background(Theme.cardBackground)
                .cornerRadius(10)
            }
            
            if ReceivedReport.samples.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "tray")
                        .font(.system(size: 30))
                        .foregroundColor(Theme.textMuted.opacity(0.3))
                    Text("Nu ai primit rapoarte inca")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textMuted)
                }
                .padding(30)
            }
        }
    }
    
    // MARK: - Actions
    private func generateReport() {
        isGenerating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            reportScore = Int.random(in: 65...95)
            shareLink = "autodiag.pro/report/\(UUID().uuidString.prefix(8).lowercased())"
            isGenerating = false
            reportGenerated = true
        }
    }
}

// MARK: - Received Report Model
struct ReceivedReport: Identifiable {
    let id = UUID()
    let vehicleName: String
    let senderName: String
    let date: Date
    let score: Int
    let riskLevel: String
    
    var dateFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yy"
        return f.string(from: date)
    }
    
    var riskColor: Color {
        score >= 80 ? Theme.gaugeGreen : (score >= 50 ? Theme.gaugeYellow : Theme.gaugeRed)
    }
    
    var riskIcon: String {
        score >= 80 ? "checkmark.shield.fill" : (score >= 50 ? "exclamationmark.triangle.fill" : "xmark.shield.fill")
    }
    
    static var samples: [ReceivedReport] {
        [
            ReceivedReport(vehicleName: "BMW 320d F30 2017", senderName: "Andrei M.", date: Date().addingTimeInterval(-86400 * 2), score: 72, riskLevel: "Mediu"),
            ReceivedReport(vehicleName: "VW Golf 7 2019", senderName: "Maria P.", date: Date().addingTimeInterval(-86400 * 7), score: 88, riskLevel: "Scazut"),
            ReceivedReport(vehicleName: "Audi A4 B9 2018", senderName: "Dealer AutoPlus", date: Date().addingTimeInterval(-86400 * 15), score: 45, riskLevel: "RIDICAT"),
        ]
    }
}
