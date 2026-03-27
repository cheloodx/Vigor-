import SwiftUI

struct CostComparatorView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedOperations: Set<String> = []
    @State private var showResults = false
    
    private let operations: [(category: String, items: [(name: String, authorizedMin: Double, authorizedMax: Double, independentMin: Double, independentMax: Double)])] = [
        ("Motor", [
            ("Schimb ulei + filtru", 250, 450, 150, 280),
            ("Schimb bujii", 200, 500, 120, 300),
            ("Schimb curea distributie", 1200, 2500, 700, 1500),
            ("Schimb pompa apa", 600, 1200, 350, 800),
            ("Curatare injectoare", 300, 600, 200, 400),
        ]),
        ("Frane", [
            ("Placute frana fata", 350, 700, 200, 400),
            ("Placute frana spate", 300, 600, 180, 350),
            ("Discuri frana fata", 500, 1000, 300, 600),
            ("Lichid frana complet", 200, 350, 100, 200),
        ]),
        ("Suspensie", [
            ("Amortizoare fata (set)", 800, 1600, 500, 1000),
            ("Amortizoare spate (set)", 600, 1200, 400, 800),
            ("Bielete stabilizator", 200, 400, 100, 250),
            ("Rulmenti roata", 400, 800, 250, 500),
        ]),
        ("Electrica", [
            ("Baterie noua", 400, 800, 350, 700),
            ("Alternator reconditionat", 500, 1000, 300, 600),
            ("Electromotor", 600, 1200, 350, 800),
        ]),
        ("Climatizare", [
            ("Incarcare freon", 200, 350, 120, 250),
            ("Compresor AC", 1500, 3000, 800, 1800),
            ("Filtru habitaclu", 80, 150, 50, 100),
        ]),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Header
                    headerCard
                    
                    if showResults {
                        // Results comparison
                        comparisonResults
                    } else {
                        // Operation selection
                        operationSelection
                    }
                    
                    // Action button
                    actionButton
                    
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
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                            .foregroundColor(Theme.primary)
                        Text("Comparator Costuri")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Header
    private var headerCard: some View {
        VStack(spacing: 8) {
            Text(vehicleManager.currentVehicle.displayName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color.purple)
                    Text("Service Autorizat")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color.purple)
                }
                
                Text("VS")
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(Theme.textMuted)
                
                VStack(spacing: 4) {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Theme.gaugeGreen)
                    Text("Service Independent")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.gaugeGreen)
                }
            }
            
            if !selectedOperations.isEmpty {
                Text("\(selectedOperations.count) operatii selectate")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.primary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Operation Selection
    private var operationSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SELECTATI OPERATIILE")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.5)
            
            ForEach(operations, id: \.category) { section in
                VStack(alignment: .leading, spacing: 6) {
                    Text(section.category.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.primary)
                        .tracking(1.2)
                    
                    ForEach(section.items, id: \.name) { item in
                        Button(action: {
                            if selectedOperations.contains(item.name) {
                                selectedOperations.remove(item.name)
                            } else {
                                selectedOperations.insert(item.name)
                            }
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: selectedOperations.contains(item.name) ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 16))
                                    .foregroundColor(selectedOperations.contains(item.name) ? Theme.primary : Theme.textMuted)
                                
                                Text(item.name)
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.textPrimary)
                                
                                Spacer()
                                
                                Text("\(Int(item.independentMin))-\(Int(item.authorizedMax)) RON")
                                    .font(.system(size: 11))
                                    .foregroundColor(Theme.textMuted)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(selectedOperations.contains(item.name) ? Theme.primary.opacity(0.08) : Color.clear)
                            .cornerRadius(6)
                        }
                    }
                }
                .padding(10)
                .background(Theme.surfaceBackground)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Comparison Results
    private var comparisonResults: some View {
        let selected = getSelectedItems()
        let totalAuthMin = selected.reduce(0.0) { $0 + $1.authorizedMin }
        let totalAuthMax = selected.reduce(0.0) { $0 + $1.authorizedMax }
        let totalIndMin = selected.reduce(0.0) { $0 + $1.independentMin }
        let totalIndMax = selected.reduce(0.0) { $0 + $1.independentMax }
        let savings = totalAuthMin - totalIndMin
        
        return VStack(alignment: .leading, spacing: 12) {
            // Total comparison
            HStack(spacing: 8) {
                VStack(spacing: 6) {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color.purple)
                    Text("Autorizat")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color.purple)
                    Text("\(Int(totalAuthMin))-\(Int(totalAuthMax))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    Text("RON")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.purple.opacity(0.08))
                .cornerRadius(10)
                
                VStack(spacing: 6) {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.gaugeGreen)
                    Text("Independent")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.gaugeGreen)
                    Text("\(Int(totalIndMin))-\(Int(totalIndMax))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    Text("RON")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.gaugeGreen.opacity(0.08))
                .cornerRadius(10)
            }
            
            // Savings
            if savings > 0 {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(Theme.gaugeGreen)
                    Text("Economie estimata:")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                    Text("\(Int(savings))+ RON")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Theme.gaugeGreen)
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Theme.gaugeGreen.opacity(0.08))
                .cornerRadius(8)
            }
            
            // Per-item breakdown
            Text("DETALII PER OPERATIE")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.5)
            
            ForEach(selected, id: \.name) { item in
                VStack(spacing: 6) {
                    HStack {
                        Text(item.name)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Spacer()
                    }
                    
                    HStack {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 6, height: 6)
                            Text("\(Int(item.authorizedMin))-\(Int(item.authorizedMax)) RON")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Theme.gaugeGreen)
                                .frame(width: 6, height: 6)
                            Text("\(Int(item.independentMin))-\(Int(item.independentMax)) RON")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    
                    // Visual bar comparison
                    GeometryReader { geo in
                        let maxVal = max(item.authorizedMax, item.independentMax)
                        VStack(spacing: 3) {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                                    .frame(height: 6)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.purple)
                                    .frame(width: geo.size.width * CGFloat(item.authorizedMax / maxVal), height: 6)
                            }
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                                    .frame(height: 6)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Theme.gaugeGreen)
                                    .frame(width: geo.size.width * CGFloat(item.independentMax / maxVal), height: 6)
                            }
                        }
                    }
                    .frame(height: 15)
                }
                .padding(10)
                .background(Theme.surfaceBackground)
                .cornerRadius(8)
            }
            
            // Back button
            Button(action: { withAnimation { showResults = false } }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.left")
                    Text("Modifica Selectia")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(Theme.primary)
            }
        }
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        Group {
            if !showResults && !selectedOperations.isEmpty {
                Button(action: { withAnimation { showResults = true } }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                        Text("Compara Preturile (\(selectedOperations.count) operatii)")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.primaryGradient)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func getSelectedItems() -> [(name: String, authorizedMin: Double, authorizedMax: Double, independentMin: Double, independentMax: Double)] {
        var result: [(name: String, authorizedMin: Double, authorizedMax: Double, independentMin: Double, independentMax: Double)] = []
        for section in operations {
            for item in section.items {
                if selectedOperations.contains(item.name) {
                    result.append(item)
                }
            }
        }
        return result
    }
}
