import SwiftUI

// MARK: - Real Fuel Consumption Calculator
struct FuelCalculatorView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var entries: [FuelEntry] = FuelEntry.sampleEntries
    @State private var showAddEntry = false
    @State private var newKm = ""
    @State private var newLiters = ""
    @State private var newPrice = ""
    
    private var averageConsumption: Double {
        guard entries.count >= 2 else { return 0 }
        let sorted = entries.sorted { $0.odometer < $1.odometer }
        let totalKm = sorted.last!.odometer - sorted.first!.odometer
        let totalLiters = sorted.dropFirst().reduce(0.0) { $0 + $1.liters }
        guard totalKm > 0 else { return 0 }
        return (totalLiters / Double(totalKm)) * 100
    }
    
    private var totalCost: Double { entries.reduce(0.0) { $0 + $1.totalCost } }
    private var totalLiters: Double { entries.reduce(0.0) { $0 + $1.liters } }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    statsCards
                    chartCard
                    addEntryCard
                    historySection
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
                        Image(systemName: "fuelpump.fill")
                            .foregroundColor(Theme.gaugeYellow)
                        Text("Calculator Consum")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var statsCards: some View {
        HStack(spacing: 10) {
            statCard(title: "Consum Mediu", value: String(format: "%.1f", averageConsumption), unit: "L/100km", color: Theme.primary)
            statCard(title: "Total Cheltuieli", value: String(format: "%.0f", totalCost), unit: "RON", color: Theme.secondary)
            statCard(title: "Total Litri", value: String(format: "%.0f", totalLiters), unit: "L", color: Theme.gaugeYellow)
        }
    }
    
    private func statCard(title: String, value: String, unit: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(Theme.textMuted)
            Text(value)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(color)
            Text(unit)
                .font(.system(size: 10))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("EVOLUTIE CONSUM")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            GeometryReader { geo in
                let consumptions = calculateConsumptions()
                let maxVal = consumptions.map { $0.1 }.max() ?? 10
                let minVal = max(0, (consumptions.map { $0.1 }.min() ?? 0) - 1)
                let range = maxVal - minVal
                
                ZStack {
                    // Grid lines
                    ForEach(0..<4, id: \.self) { i in
                        let y = geo.size.height * CGFloat(i) / 3.0
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geo.size.width, y: y))
                        }
                        .stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 0.5)
                    }
                    
                    // Line chart
                    if consumptions.count >= 2 {
                        Path { path in
                            let divisor = max(1, consumptions.count - 1)
                            for (i, entry) in consumptions.enumerated() {
                                let x = geo.size.width * CGFloat(i) / CGFloat(divisor)
                                let y = range > 0 ? geo.size.height * (1 - CGFloat(entry.1 - minVal) / CGFloat(range)) : geo.size.height * 0.5
                                if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                                else { path.addLine(to: CGPoint(x: x, y: y)) }
                            }
                        }
                        .stroke(Theme.primary, lineWidth: 2)
                        
                        // Dots
                        ForEach(0..<consumptions.count, id: \.self) { i in
                            let x = geo.size.width * CGFloat(i) / CGFloat(max(1, consumptions.count - 1))
                            let y = range > 0 ? geo.size.height * (1 - CGFloat(consumptions[i].1 - minVal) / CGFloat(range)) : geo.size.height * 0.5
                            Circle()
                                .fill(Theme.primary)
                                .frame(width: 6, height: 6)
                                .position(x: x, y: y)
                        }
                    }
                }
            }
            .frame(height: 120)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var addEntryCard: some View {
        VStack(spacing: 10) {
            Button(action: { withAnimation { showAddEntry.toggle() } }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Theme.primary)
                    Text("Adauga Alimentare")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.primary)
                    Spacer()
                    Image(systemName: showAddEntry ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)
                }
            }
            
            if showAddEntry {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        inputField(title: "Km bord", text: $newKm, placeholder: "125000")
                        inputField(title: "Litri", text: $newLiters, placeholder: "45.5")
                        inputField(title: "Pret/L", text: $newPrice, placeholder: "7.2")
                    }
                    
                    Button(action: { addEntry() }) {
                        Text("Salveaza")
                            .font(.system(size: 13, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Theme.primary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func inputField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(Theme.textMuted)
            TextField(placeholder, text: text)
                .font(.system(size: 13, design: .monospaced))
                .foregroundColor(Theme.textPrimary)
                .keyboardType(.decimalPad)
                .padding(8)
                .background(Color(red: 0.06, green: 0.09, blue: 0.14))
                .cornerRadius(6)
        }
    }
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ISTORIC ALIMENTARI")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ForEach(entries.sorted(by: { $0.date > $1.date })) { entry in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.dateFormatted)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Text("\(entry.odometer) km")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(Theme.textMuted)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(String(format: "%.1f L", entry.liters))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.primary)
                        Text(String(format: "%.0f RON", entry.totalCost))
                            .font(.system(size: 10))
                            .foregroundColor(Theme.secondary)
                    }
                }
                .padding(10)
                .background(Theme.surfaceBackground)
                .cornerRadius(8)
            }
        }
    }
    
    private func calculateConsumptions() -> [(String, Double)] {
        let sorted = entries.sorted { $0.odometer < $1.odometer }
        var result: [(String, Double)] = []
        for i in 1..<sorted.count {
            let km = Double(sorted[i].odometer - sorted[i-1].odometer)
            if km > 0 {
                let consumption = (sorted[i].liters / km) * 100
                result.append((sorted[i].dateFormatted, consumption))
            }
        }
        return result
    }
    
    private func addEntry() {
        guard let km = Int(newKm), let liters = Double(newLiters), let price = Double(newPrice) else { return }
        let entry = FuelEntry(date: Date(), odometer: km, liters: liters, pricePerLiter: price)
        entries.append(entry)
        newKm = ""; newLiters = ""; newPrice = ""
        withAnimation { showAddEntry = false }
    }
}

struct FuelEntry: Identifiable {
    let id = UUID()
    let date: Date
    let odometer: Int
    let liters: Double
    let pricePerLiter: Double
    
    var totalCost: Double { liters * pricePerLiter }
    var dateFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        return f.string(from: date)
    }
    
    static var sampleEntries: [FuelEntry] {
        let cal = Calendar.current
        let now = Date()
        return [
            FuelEntry(date: cal.date(byAdding: .day, value: -60, to: now)!, odometer: 120500, liters: 42.3, pricePerLiter: 7.15),
            FuelEntry(date: cal.date(byAdding: .day, value: -45, to: now)!, odometer: 121100, liters: 38.5, pricePerLiter: 7.20),
            FuelEntry(date: cal.date(byAdding: .day, value: -30, to: now)!, odometer: 121750, liters: 45.0, pricePerLiter: 7.10),
            FuelEntry(date: cal.date(byAdding: .day, value: -15, to: now)!, odometer: 122300, liters: 40.2, pricePerLiter: 7.25),
            FuelEntry(date: cal.date(byAdding: .day, value: -3, to: now)!, odometer: 122900, liters: 43.8, pricePerLiter: 7.18),
        ]
    }
}
