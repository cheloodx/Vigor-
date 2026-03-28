import SwiftUI

// MARK: - Car CV View (Complete Vehicle History / "Car Passport")
// Full vehicle history: repairs, scanned invoices, services, owners
// When selling the car -> increases value
struct CarCVView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedTab: CVTab = .overview
    @State private var owners: [CarOwner] = CarOwner.sampleOwners
    @State private var repairs: [RepairRecord] = RepairRecord.sampleRepairs
    @State private var invoices: [ScannedInvoice] = ScannedInvoice.sampleInvoices
    @State private var showShareSheet = false
    @State private var showAddRecord = false
    @State private var cvScore: Int = 82
    
    enum CVTab: String, CaseIterable {
        case overview = "Sumar"
        case repairs = "Reparatii"
        case invoices = "Facturi"
        case owners = "Proprietari"
        case timeline = "Timeline"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    // Vehicle header
                    vehicleHeader
                    
                    // CV Score card
                    cvScoreCard
                    
                    // Tab selector
                    tabSelector
                    
                    // Content based on tab
                    switch selectedTab {
                    case .overview: overviewContent
                    case .repairs: repairsContent
                    case .invoices: invoicesContent
                    case .owners: ownersContent
                    case .timeline: timelineContent
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
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(Theme.primary)
                        Text("CV Auto")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Theme.primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Vehicle Header
    private var vehicleHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Theme.primary.opacity(0.15))
                    .frame(width: 60, height: 60)
                Image(systemName: "car.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Theme.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicleManager.currentVehicle.displayName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Text("VIN: \(vehicleManager.currentVehicle.vin.isEmpty ? "N/A" : vehicleManager.currentVehicle.vin)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Theme.textMuted)
                Text("\(vehicleManager.currentVehicle.mileage) km | \(vehicleManager.currentVehicle.fuelType.rawValue)")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - CV Score
    private var cvScoreCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SCOR CV AUTO")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1.2)
                    Text("Valoare crescuta la vanzare")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color(red: 0.1, green: 0.15, blue: 0.2), lineWidth: 6)
                        .frame(width: 60, height: 60)
                    Circle()
                        .trim(from: 0, to: Double(cvScore) / 100.0)
                        .stroke(cvScore >= 80 ? Theme.gaugeGreen : (cvScore >= 50 ? Theme.gaugeYellow : Theme.gaugeRed), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    Text("\(cvScore)")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(cvScore >= 80 ? Theme.gaugeGreen : (cvScore >= 50 ? Theme.gaugeYellow : Theme.gaugeRed))
                }
            }
            
            // Stats
            HStack(spacing: 0) {
                cvStat(label: "Reparatii", value: "\(repairs.count)", icon: "wrench.fill")
                cvStat(label: "Facturi", value: "\(invoices.count)", icon: "doc.fill")
                cvStat(label: "Proprietari", value: "\(owners.count)", icon: "person.fill")
                cvStat(label: "Ani", value: "\(Calendar.current.component(.year, from: Date()) - vehicleManager.currentVehicle.year)", icon: "calendar")
            }
        }
        .padding(14)
        .background(
            LinearGradient(colors: [Color(red: 0.02, green: 0.08, blue: 0.12), Color(red: 0.04, green: 0.12, blue: 0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.gaugeGreen.opacity(0.2), lineWidth: 1))
    }
    
    private func cvStat(label: String, value: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Theme.primary)
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(CVTab.allCases, id: \.self) { tab in
                    Button(action: { withAnimation { selectedTab = tab } }) {
                        Text(tab.rawValue)
                            .font(.system(size: 12, weight: selectedTab == tab ? .bold : .regular))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedTab == tab ? Theme.primary : Theme.surfaceBackground)
                            .foregroundColor(selectedTab == tab ? .white : Theme.textSecondary)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    // MARK: - Overview Content
    private var overviewContent: some View {
        VStack(spacing: 12) {
            // Key facts
            VStack(alignment: .leading, spacing: 10) {
                Text("INFORMATII CHEIE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                keyFactRow(icon: "speedometer", label: "Kilometraj verificat", value: "\(vehicleManager.currentVehicle.mileage) km", status: "verified")
                keyFactRow(icon: "wrench.fill", label: "Ultima revizie", value: "15.03.2024 la 120.000 km", status: "ok")
                keyFactRow(icon: "checkmark.seal.fill", label: "ITP valid pana la", value: "22.08.2025", status: "ok")
                keyFactRow(icon: "shield.fill", label: "RCA activ", value: "Euroins pana 15.01.2026", status: "ok")
                keyFactRow(icon: "exclamationmark.triangle.fill", label: "Accidente raportate", value: "1 minor (parcare)", status: "warning")
                keyFactRow(icon: "person.2.fill", label: "Numar proprietari", value: "\(owners.count)", status: "ok")
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            
            // Total costs
            VStack(alignment: .leading, spacing: 8) {
                Text("COSTURI TOTALE INTRETINERE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                let totalCost = repairs.reduce(0.0) { $0 + $1.cost }
                Text(String(format: "%.0f RON", totalCost))
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(Theme.primary)
                
                Text("in ultimii \(Calendar.current.component(.year, from: Date()) - vehicleManager.currentVehicle.year) ani")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
        }
    }
    
    private func keyFactRow(icon: String, label: String, value: String, status: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(status == "warning" ? Theme.gaugeYellow : Theme.primary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
                Text(value)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            Spacer()
            
            if status == "verified" {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.gaugeGreen)
            }
        }
        .padding(8)
        .background(Theme.surfaceBackground)
        .cornerRadius(6)
    }
    
    // MARK: - Repairs Content
    private var repairsContent: some View {
        VStack(spacing: 8) {
            ForEach(repairs) { repair in
                HStack(spacing: 12) {
                    VStack(spacing: 2) {
                        Text(repair.dateFormatted)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Theme.primary)
                        Text("\(repair.mileage) km")
                            .font(.system(size: 9))
                            .foregroundColor(Theme.textMuted)
                    }
                    .frame(width: 70)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(repair.title)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        Text(repair.details)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                            .lineLimit(2)
                        Text(repair.serviceName)
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.0f RON", repair.cost))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.secondary)
                }
                .padding(12)
                .background(Theme.cardBackground)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Invoices Content
    private var invoicesContent: some View {
        VStack(spacing: 8) {
            // Add invoice button
            Button(action: { showAddRecord = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 16))
                    Text("Adauga Factura (Foto)")
                        .font(.system(size: 13, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.primary.opacity(0.15))
                .foregroundColor(Theme.primary)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
            }
            
            ForEach(invoices) { invoice in
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Theme.surfaceBackground)
                            .frame(width: 44, height: 56)
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Theme.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(invoice.title)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        Text(invoice.provider)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                        Text(invoice.dateFormatted)
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(String(format: "%.0f RON", invoice.amount))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.secondary)
                        if invoice.isScanned {
                            Text("Scanata")
                                .font(.system(size: 9, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Theme.gaugeGreen.opacity(0.15))
                                .foregroundColor(Theme.gaugeGreen)
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(12)
                .background(Theme.cardBackground)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Owners Content
    private var ownersContent: some View {
        VStack(spacing: 8) {
            ForEach(Array(owners.enumerated()), id: \.element.id) { index, owner in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(index == 0 ? Theme.primary.opacity(0.2) : Theme.surfaceBackground)
                            .frame(width: 44, height: 44)
                        Text("#\(index + 1)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(index == 0 ? Theme.primary : Theme.textMuted)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text(owner.name)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.textPrimary)
                            if index == owners.count - 1 {
                                Text("ACTUAL")
                                    .font(.system(size: 8, weight: .bold))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Theme.gaugeGreen.opacity(0.15))
                                    .foregroundColor(Theme.gaugeGreen)
                                    .cornerRadius(4)
                            }
                        }
                        Text("\(owner.city) | \(owner.period)")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                        Text("\(owner.startKm) → \(owner.endKm) km (\(owner.endKm - owner.startKm) km parcursi)")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                    }
                    
                    Spacer()
                }
                .padding(12)
                .background(Theme.cardBackground)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Timeline Content
    private var timelineContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(repairs.enumerated()), id: \.element.id) { index, repair in
                HStack(alignment: .top, spacing: 12) {
                    // Timeline dot and line
                    VStack(spacing: 0) {
                        Circle()
                            .fill(Theme.primary)
                            .frame(width: 10, height: 10)
                        if index < repairs.count - 1 {
                            Rectangle()
                                .fill(Theme.primary.opacity(0.3))
                                .frame(width: 2, height: 60)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(repair.dateFormatted)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Theme.primary)
                        Text(repair.title)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Text("\(repair.mileage) km | \(String(format: "%.0f RON", repair.cost))")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
}

// MARK: - Models
struct CarOwner: Identifiable {
    let id = UUID()
    let name: String
    let city: String
    let period: String
    let startKm: Int
    let endKm: Int
    
    static var sampleOwners: [CarOwner] {
        [
            CarOwner(name: "Ion Marin", city: "Bucuresti", period: "2019-2022", startKm: 0, endKm: 45000),
            CarOwner(name: "Mihai Popa", city: "Cluj-Napoca", period: "2022-2024", startKm: 45000, endKm: 98000),
            CarOwner(name: "Proprietar actual", city: "Bucuresti", period: "2024-prezent", startKm: 98000, endKm: 125000),
        ]
    }
}

struct RepairRecord: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let details: String
    let cost: Double
    let mileage: Int
    let serviceName: String
    
    var dateFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yy"
        return f.string(from: date)
    }
    
    static var sampleRepairs: [RepairRecord] {
        [
            RepairRecord(date: Date().addingTimeInterval(-86400 * 15), title: "Schimb placute frana fata", details: "Placute Brembo P85113 + verificare discuri - uzura normala", cost: 450, mileage: 124800, serviceName: "AutoMaster Pro, Bucuresti"),
            RepairRecord(date: Date().addingTimeInterval(-86400 * 30), title: "Revizie 120.000 km", details: "Ulei Castrol 5W30 LL, filtru ulei, filtru aer, filtru habitaclu, bujii", cost: 680, mileage: 120000, serviceName: "AutoMaster Pro, Bucuresti"),
            RepairRecord(date: Date().addingTimeInterval(-86400 * 90), title: "Schimb curea distributie", details: "Kit distributie Gates + pompa apa + antigel G12", cost: 1800, mileage: 115000, serviceName: "Service VAG Specialist, Cluj"),
            RepairRecord(date: Date().addingTimeInterval(-86400 * 150), title: "Reparatie bara spate", details: "Lovitura parcare - indreptare + vopsire bara spate", cost: 800, mileage: 110000, serviceName: "Tinichigerie Auto Paint, Bucuresti"),
            RepairRecord(date: Date().addingTimeInterval(-86400 * 200), title: "Schimb amortizoare spate", details: "2x Bilstein B4 + flanse superioare + arcuri noi", cost: 1200, mileage: 105000, serviceName: "AutoMaster Pro, Bucuresti"),
            RepairRecord(date: Date().addingTimeInterval(-86400 * 300), title: "Revizie 90.000 km", details: "Ulei + filtre + verificare frane + verificare suspensie", cost: 520, mileage: 90000, serviceName: "Dealer VW, Bucuresti"),
        ]
    }
}

struct ScannedInvoice: Identifiable {
    let id = UUID()
    let title: String
    let provider: String
    let date: Date
    let amount: Double
    let isScanned: Bool
    
    var dateFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        return f.string(from: date)
    }
    
    static var sampleInvoices: [ScannedInvoice] {
        [
            ScannedInvoice(title: "Revizie 120.000 km", provider: "AutoMaster Pro", date: Date().addingTimeInterval(-86400 * 30), amount: 680, isScanned: true),
            ScannedInvoice(title: "Placute frana fata", provider: "AutoMaster Pro", date: Date().addingTimeInterval(-86400 * 15), amount: 450, isScanned: true),
            ScannedInvoice(title: "Kit distributie", provider: "Service VAG Cluj", date: Date().addingTimeInterval(-86400 * 90), amount: 1800, isScanned: false),
            ScannedInvoice(title: "Polita RCA", provider: "Euroins", date: Date().addingTimeInterval(-86400 * 60), amount: 1200, isScanned: true),
            ScannedInvoice(title: "ITP", provider: "RAR Bucuresti", date: Date().addingTimeInterval(-86400 * 60), amount: 150, isScanned: false),
        ]
    }
}
