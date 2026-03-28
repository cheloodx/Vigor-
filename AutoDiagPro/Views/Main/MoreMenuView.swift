import SwiftUI

struct MoreMenuView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @EnvironmentObject var appState: AppState
    @StateObject private var nightModeManager = NightModeManager()
    @State private var showExportPDF = false
    @State private var pdfData: Data?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Vehicle card
                    vehicleCard
                    
                    // Main features grid
                    featureSection(title: "DIAGNOSTIC", features: diagnosticFeatures)
                    featureSection(title: "AI & PREDICTII", features: aiFeatures)
                    featureSection(title: "VEHICUL", features: vehicleFeatures)
                    featureSection(title: "SERVICE & COSTURI", features: serviceFeatures)
                    featureSection(title: "INCREDERE & PARTAJARE", features: trustFeatures)
                    featureSection(title: "LEGAL & SIGURANTA", features: legalFeatures)
                    featureSection(title: "EUROPA & MARKETPLACE", features: europeFeatures)
                    featureSection(title: "SETARI", features: settingsFeatures)
                    
                    // Export PDF button
                    exportPDFButton
                    
                    // App version
                    VStack(spacing: 4) {
                        Text("AutoDiag Pro Ultimate")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                        Text("v3.0.0 - Europe Edition")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted.opacity(0.6))
                    }
                    .padding(.top, 8)
                    
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
                        Image(systemName: "square.grid.2x2.fill")
                            .foregroundColor(Theme.primary)
                        Text("Mai Multe")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { nightModeManager.toggleNightMode() }) {
                        Image(systemName: nightModeManager.isNightMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(nightModeManager.isNightMode ? Theme.gaugeYellow : Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showExportPDF) {
                if let data = pdfData {
                    PDFShareView(pdfData: data)
                }
            }
        }
    }
    
    // MARK: - Vehicle Card
    private var vehicleCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "car.fill")
                .font(.system(size: 28))
                .foregroundColor(Theme.primary)
                .frame(width: 50, height: 50)
                .background(Theme.primary.opacity(0.15))
                .cornerRadius(14)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicleManager.currentVehicle.displayName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Text("\(vehicleManager.currentVehicle.mileage) km")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            // Quick health score
            VStack(spacing: 2) {
                Text("78")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(Theme.gaugeGreen)
                Text("Scor")
                    .font(.system(size: 9))
                    .foregroundColor(Theme.textMuted)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.primary.opacity(0.2), lineWidth: 1))
    }
    
    // MARK: - Feature Section
    private func featureSection(title: String, features: [MoreFeature]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.5)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(features) { feature in
                    NavigationLink(destination: feature.destination) {
                        HStack(spacing: 10) {
                            Image(systemName: feature.icon)
                                .font(.system(size: 16))
                                .foregroundColor(feature.color)
                                .frame(width: 34, height: 34)
                                .background(feature.color.opacity(0.15))
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text(feature.name)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                    .lineLimit(1)
                                Text(feature.subtitle)
                                    .font(.system(size: 9))
                                    .foregroundColor(Theme.textMuted)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                        }
                        .padding(10)
                        .background(Theme.surfaceBackground)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
                    }
                }
            }
        }
    }
    
    // MARK: - Export PDF Button
    private var exportPDFButton: some View {
        Button(action: generatePDF) {
            HStack(spacing: 10) {
                Image(systemName: "doc.richtext.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Exporta Raport PDF")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Text("Raport complet diagnostic + intretinere")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "arrow.down.doc.fill")
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(14)
            .background(Theme.primaryGradient)
            .cornerRadius(Theme.cornerRadius)
        }
    }
    
    // MARK: - Feature Lists
    private var diagnosticFeatures: [MoreFeature] {
        [
            MoreFeature(name: "Scor Sanatate", subtitle: "Nota generala 0-100", icon: "heart.text.square.fill", color: Theme.gaugeGreen, destination: AnyView(HealthScoreView().environmentObject(vehicleManager))),
            MoreFeature(name: "Diagrama Auto", subtitle: "Componente vizuale", icon: "car.fill", color: Theme.primary, destination: AnyView(CarAnimationView().environmentObject(vehicleManager))),
            MoreFeature(name: "AR Piese", subtitle: "Vizualizare AR daune", icon: "viewfinder", color: Color(red: 0.0, green: 0.85, blue: 0.75), destination: AnyView(ARDiagnosticView().environmentObject(vehicleManager))),
            MoreFeature(name: "Scanner Piese", subtitle: "QR cod + alternative", icon: "qrcode.viewfinder", color: Color(red: 0.85, green: 0.55, blue: 0.0), destination: AnyView(QRPartScannerView().environmentObject(vehicleManager))),
            MoreFeature(name: "Decodor DTC", subtitle: "Erori OBD2 explicate", icon: "exclamationmark.triangle.fill", color: Theme.gaugeYellow, destination: AnyView(DTCDecoderView().environmentObject(vehicleManager))),
            MoreFeature(name: "Analiza Sunet", subtitle: "Inregistrare motor", icon: "waveform.circle.fill", color: Color(red: 0.95, green: 0.5, blue: 0.2), destination: AnyView(EngineSoundAnalysisView())),
            MoreFeature(name: "Diagnostic Rapid", subtitle: "Shake to diagnose", icon: "iphone.radiowaves.left.and.right", color: Color.purple, destination: AnyView(ShakeDiagnoseView().environmentObject(vehicleManager))),
            MoreFeature(name: "AR Ghid Reparatie", subtitle: "Pasi AR interactivi", icon: "wrench.and.screwdriver.fill", color: Theme.gaugeGreen, destination: AnyView(ARRepairGuideView().environmentObject(vehicleManager))),
            MoreFeature(name: "Widget iOS", subtitle: "Home screen widget", icon: "square.text.square.fill", color: Color(red: 0.0, green: 0.75, blue: 0.85), destination: AnyView(HealthWidgetPreview().environmentObject(vehicleManager))),
        ]
    }
    
    private var aiFeatures: [MoreFeature] {
        [
            MoreFeature(name: "Mecanic AI Pro", subtitle: "Chat AI context-aware", icon: "bubble.left.and.bubble.right.fill", color: Color(red: 0.0, green: 0.7, blue: 0.9), destination: AnyView(EnhancedAIChatView().environmentObject(vehicleManager))),
            MoreFeature(name: "Predictor AI", subtitle: "Ce se strica in 3-6 luni", icon: "brain.head.profile", color: Color(red: 0.6, green: 0.2, blue: 0.9), destination: AnyView(FailurePredictorView().environmentObject(vehicleManager))),
            MoreFeature(name: "Radar ITP", subtitle: "Trece ITP-ul?", icon: "shield.checkered", color: Theme.gaugeRed, destination: AnyView(ITPRadarView().environmentObject(vehicleManager))),
            MoreFeature(name: "Digital Twin", subtitle: "Twin digital complet", icon: "cube.transparent.fill", color: Theme.primary, destination: AnyView(CarDigitalTwinView().environmentObject(vehicleManager))),
            MoreFeature(name: "AI European", subtitle: "Date per marca/tara", icon: "brain.head.profile", color: Color(red: 0.0, green: 0.6, blue: 0.9), destination: AnyView(EuropeanAIDataView().environmentObject(vehicleManager))),
        ]
    }
    
    private var vehicleFeatures: [MoreFeature] {
        [
            MoreFeature(name: "CV Auto", subtitle: "Istoric complet vehicul", icon: "doc.text.fill", color: Color(red: 0.0, green: 0.7, blue: 0.5), destination: AnyView(CarCVView().environmentObject(vehicleManager))),
            MoreFeature(name: "OBD2 Avansat", subtitle: "Live data + consum real", icon: "antenna.radiowaves.left.and.right", color: Theme.primary, destination: AnyView(EnhancedOBDView().environmentObject(vehicleManager))),
            MoreFeature(name: "Istoric", subtitle: "Scanari anterioare", icon: "clock.arrow.circlepath", color: Theme.primary, destination: AnyView(DiagnosticHistoryView().environmentObject(vehicleManager))),
            MoreFeature(name: "Jurnal", subtitle: "Log vehicul complet", icon: "book.fill", color: Color(red: 0.22, green: 0.78, blue: 0.35), destination: AnyView(VehicleJournalView().environmentObject(vehicleManager))),
            MoreFeature(name: "Alarme", subtitle: "Notificari intretinere", icon: "bell.badge.fill", color: Theme.gaugeYellow, destination: AnyView(MaintenanceAlarmsView().environmentObject(vehicleManager))),
            MoreFeature(name: "Harta Service", subtitle: "Service-uri aproape", icon: "map.fill", color: Color(red: 0.0, green: 0.75, blue: 0.85), destination: AnyView(ServiceMapView())),
            MoreFeature(name: "VIN Auto Setup", subtitle: "Scan VIN → config auto", icon: "barcode.viewfinder", color: Color(red: 0.1, green: 0.7, blue: 0.4), destination: AnyView(VINAutoSetupView().environmentObject(vehicleManager))),
            MoreFeature(name: "Calculator Consum", subtitle: "Consum real L/100km", icon: "fuelpump.fill", color: Theme.gaugeYellow, destination: AnyView(FuelCalculatorView().environmentObject(vehicleManager))),
            MoreFeature(name: "Estimator Valoare", subtitle: "Pret masina pe piata", icon: "tag.fill", color: Theme.secondary, destination: AnyView(CarValuationView().environmentObject(vehicleManager))),
            MoreFeature(name: "Recall Service", subtitle: "Campanii rechemare", icon: "bell.badge.fill", color: Theme.gaugeRed, destination: AnyView(RecallCampaignsView().environmentObject(vehicleManager))),
        ]
    }
    
    private var serviceFeatures: [MoreFeature] {
        [
            MoreFeature(name: "Service", subtitle: "Calendar intretinere", icon: "calendar.badge.clock", color: Theme.primary, destination: AnyView(ServiceCalendarView().environmentObject(vehicleManager))),
            MoreFeature(name: "Costuri", subtitle: "Estimator costuri", icon: "creditcard.fill", color: Theme.secondary, destination: AnyView(CostEstimatorView().environmentObject(vehicleManager))),
            MoreFeature(name: "Voce", subtitle: "Diagnostic vocal", icon: "mic.fill", color: Color(red: 0.95, green: 0.3, blue: 0.5), destination: AnyView(VoiceDiagnosticView().environmentObject(vehicleManager))),
            MoreFeature(name: "Comparator", subtitle: "Autorizat vs Independent", icon: "arrow.left.arrow.right.circle.fill", color: Color.purple, destination: AnyView(CostComparatorView().environmentObject(vehicleManager))),
            MoreFeature(name: "Comparator RCA", subtitle: "Oferte asigurare", icon: "shield.fill", color: Color(red: 0.2, green: 0.5, blue: 0.9), destination: AnyView(RCAComparatorView().environmentObject(vehicleManager))),
        ]
    }
    
    private var trustFeatures: [MoreFeature] {
        [
            MoreFeature(name: "Mecanici Verificati", subtitle: "Rating + garantie lucrare", icon: "checkmark.shield.fill", color: Theme.gaugeGreen, destination: AnyView(MechanicTrustView().environmentObject(vehicleManager))),
            MoreFeature(name: "Raport Vehicul", subtitle: "Trimite/primeste raport", icon: "square.and.arrow.up.fill", color: Color(red: 0.0, green: 0.6, blue: 0.85), destination: AnyView(ShareVehicleReportView().environmentObject(vehicleManager))),
        ]
    }
    
    private var legalFeatures: [MoreFeature] {
        [
            MoreFeature(name: "Legal & Amenzi", subtitle: "Camere, reguli, amenzi", icon: "exclamationmark.triangle.fill", color: Theme.gaugeYellow, destination: AnyView(LegalRadarView().environmentObject(vehicleManager))),
        ]
    }
    
    private var europeFeatures: [MoreFeature] {
        [
            MoreFeature(name: "Configurare Tara", subtitle: "44 tari europene", icon: "globe.europe.africa.fill", color: Color(red: 0.0, green: 0.5, blue: 0.9), destination: AnyView(MultiCountryConfigView().environmentObject(vehicleManager))),
            MoreFeature(name: "Marketplace", subtitle: "Mecanici & service-uri", icon: "storefront.fill", color: Theme.secondary, destination: AnyView(ServiceMarketplaceView().environmentObject(vehicleManager))),
        ]
    }
    
    private var settingsFeatures: [MoreFeature] {
        [
            MoreFeature(name: "Mod Noapte", subtitle: nightModeManager.isAutoMode ? "Auto" : (nightModeManager.isNightMode ? "Activat" : "Dezactivat"), icon: nightModeManager.isNightMode ? "moon.fill" : "sun.max.fill", color: Theme.gaugeYellow, destination: AnyView(NightModeSettingsView(nightModeManager: nightModeManager))),
        ]
    }
    
    // MARK: - PDF Generation
    private func generatePDF() {
        let categories = HealthCategory.sampleCategories
        let avgScore = categories.reduce(0) { $0 + $1.score } / max(1, categories.count)
        
        pdfData = PDFExportManager.generateDiagnosticPDF(
            vehicleName: vehicleManager.currentVehicle.displayName,
            healthScore: avgScore,
            categories: categories,
            journalEntries: JournalEntry.sampleEntries,
            alarms: MaintenanceAlarm.sampleAlarms,
            currentMileage: vehicleManager.currentVehicle.mileage
        )
        showExportPDF = true
    }
}

// MARK: - More Feature Model
struct MoreFeature: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let icon: String
    let color: Color
    let destination: AnyView
}

// MARK: - PDF Share View
struct PDFShareView: UIViewControllerRepresentable {
    let pdfData: Data
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("AutoDiagPro_Raport.pdf")
        try? pdfData.write(to: tempURL)
        return UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Night Mode Settings View
struct NightModeSettingsView: View {
    @ObservedObject var nightModeManager: NightModeManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Night mode toggle
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(nightModeManager.isNightMode ? Theme.gaugeYellow.opacity(0.15) : Theme.primary.opacity(0.15))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: nightModeManager.isNightMode ? "moon.stars.fill" : "sun.max.fill")
                            .font(.system(size: 44))
                            .foregroundColor(nightModeManager.isNightMode ? Theme.gaugeYellow : Theme.primary)
                    }
                    
                    Text(nightModeManager.isNightMode ? "Mod Noapte Activ" : "Mod Zi Activ")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Luminozitate ecran: \(Int(nightModeManager.brightness * 100))%")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
                // Auto mode toggle
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mod Automat")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Text("Se adapteaza la luminozitatea ambientala si ora")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { nightModeManager.isAutoMode },
                        set: { newValue in
                            if newValue {
                                nightModeManager.enableAutoMode()
                            } else {
                                nightModeManager.isAutoMode = false
                            }
                        }
                    ))
                    .tint(Theme.primary)
                }
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
                // Manual toggle
                if !nightModeManager.isAutoMode {
                    Button(action: { nightModeManager.toggleNightMode() }) {
                        HStack(spacing: 8) {
                            Image(systemName: nightModeManager.isNightMode ? "sun.max.fill" : "moon.fill")
                            Text(nightModeManager.isNightMode ? "Comuta la Mod Zi" : "Comuta la Mod Noapte")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.primaryGradient)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                
                // Info card
                VStack(alignment: .leading, spacing: 8) {
                    Text("CUM FUNCTIONEAZA")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1.2)
                    
                    infoRow(icon: "clock.fill", text: "Dupa ora 20:00 se activeaza automat modul noapte")
                    infoRow(icon: "sun.min.fill", text: "Luminozitate scazuta (<30%) activeaza modul noapte")
                    infoRow(icon: "eye.fill", text: "Reducere luminozitate interfata pentru confort vizual")
                    infoRow(icon: "battery.50", text: "Mod noapte reduce consumul de baterie pe OLED")
                }
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Theme.background)
        .navigationTitle("Mod Noapte")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func infoRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(Theme.primary)
                .frame(width: 16)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
    }
}
