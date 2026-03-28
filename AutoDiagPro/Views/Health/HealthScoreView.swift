import SwiftUI

// MARK: - Health Score View — LIVE real-time with OBD2 data
struct HealthScoreView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var obdManager = OBD2BluetoothManager()
    @State private var healthScore: HealthScore = .sample
    @State private var animateRing = false
    @State private var selectedCategory: HealthCategory?
    @State private var showShareSheet = false
    @State private var isLiveUpdating = false
    @State private var baselineCategories: [HealthCategory] = []
    private let liveTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Main score ring
                    scoreRingCard
                    
                    // Quick stats
                    quickStatsRow
                    
                    // Category breakdown
                    categoryBreakdown
                    
                    // Recommendations
                    recommendationsCard
                    
                    // Share button
                    shareButton
                    
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
                        Image(systemName: "heart.square.fill")
                            .foregroundColor(Theme.primary)
                        Text("Scor Sanatate")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .onAppear {
                calculateHealthScore()
            }
            .onReceive(liveTimer) { _ in
                if obdManager.isConnected {
                    isLiveUpdating = true
                    recalculateFromOBD()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { isLiveUpdating = false }
                }
            }
        }
    }
    
    // MARK: - Score Ring Card
    private var scoreRingCard: some View {
        VStack(spacing: 16) {
            // Live status
            HStack(spacing: 6) {
                Circle().fill(obdManager.isConnected ? Theme.gaugeGreen : Theme.gaugeYellow)
                    .frame(width: 8, height: 8)
                Text(obdManager.isConnected ? "LIVE \u2014 Date OBD2 reale" : "Estimare bazata pe kilometraj")
                    .font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textPrimary)
                Spacer()
                if isLiveUpdating {
                    ProgressView().scaleEffect(0.6)
                }
                Button(action: {
                    if obdManager.isConnected { obdManager.disconnect() }
                    else { obdManager.startScanning() }
                }) {
                    Text(obdManager.isConnected ? "Deconecteaza" : "Conecteaza OBD2")
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Theme.primary).foregroundColor(.white).cornerRadius(5)
                }
            }
            .padding(8).background(Theme.surfaceBackground).cornerRadius(6)
            
            Text(vehicleManager.currentVehicle.displayName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            
            ZStack {
                // Background ring
                Circle()
                    .stroke(Color(red: 0.1, green: 0.15, blue: 0.2), lineWidth: 20)
                    .frame(width: 180, height: 180)
                
                // Score ring
                Circle()
                    .trim(from: 0, to: animateRing ? CGFloat(healthScore.overallScore) / 100.0 : 0)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [healthScore.scoreColor.opacity(0.6), healthScore.scoreColor]),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5), value: animateRing)
                
                // Score text
                VStack(spacing: 4) {
                    Text("\(healthScore.overallScore)")
                        .font(.system(size: 52, weight: .black, design: .rounded))
                        .foregroundColor(healthScore.scoreColor)
                    
                    Text(healthScore.scoreLabel)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(healthScore.scoreColor)
                    
                    Text("din 100")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
            }
            .padding(.vertical, 8)
            
            // Last updated
            HStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 10))
                Text("Actualizat: \(formattedDate(healthScore.lastUpdated))")
                    .font(.system(size: 11))
            }
            .foregroundColor(Theme.textMuted)
        }
        .padding(20)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(healthScore.scoreColor.opacity(0.3), lineWidth: 1))
    }
    
    // MARK: - Quick Stats
    private var quickStatsRow: some View {
        HStack(spacing: 8) {
            statBox(title: "Probleme", value: "\(healthScore.categories.filter { $0.score < 70 }.count)", icon: "exclamationmark.triangle.fill", color: Theme.gaugeYellow)
            statBox(title: "OK", value: "\(healthScore.categories.filter { $0.score >= 70 }.count)", icon: "checkmark.circle.fill", color: Theme.gaugeGreen)
            statBox(title: "Critice", value: "\(healthScore.categories.filter { $0.score < 50 }.count)", icon: "xmark.circle.fill", color: Theme.gaugeRed)
        }
    }
    
    private func statBox(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Theme.cardBackground)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.2), lineWidth: 1))
    }
    
    // MARK: - Category Breakdown
    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("DETALII PE CATEGORII")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.5)
            
            ForEach(healthScore.categories) { category in
                Button(action: { withAnimation { selectedCategory = selectedCategory?.id == category.id ? nil : category } }) {
                    VStack(spacing: 0) {
                        HStack(spacing: 12) {
                            Image(systemName: category.icon)
                                .font(.system(size: 16))
                                .foregroundColor(category.scoreColor)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(category.name)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.textPrimary)
                                Text(category.details)
                                    .font(.system(size: 11))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            
                            Spacer()
                            
                            // Score bar
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                                    .frame(width: 60, height: 6)
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(category.scoreColor)
                                    .frame(width: CGFloat(category.score) / 100 * 60, height: 6)
                            }
                            
                            Text("\(category.score)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(category.scoreColor)
                                .frame(width: 30)
                        }
                        .padding(12)
                        
                        // Expanded recommendations
                        if selectedCategory?.id == category.id {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(category.recommendations, id: \.self) { rec in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "arrow.right.circle.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(Theme.primary)
                                            .padding(.top, 2)
                                        Text(rec)
                                            .font(.system(size: 12))
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom, 12)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }
                .background(Theme.surfaceBackground)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
            }
        }
    }
    
    // MARK: - Recommendations
    private var recommendationsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.gaugeYellow)
                Text("RECOMANDARI PRIORITARE")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.5)
            }
            
            let urgentCategories = healthScore.categories.filter { $0.score < 75 }.sorted { $0.score < $1.score }
            
            ForEach(urgentCategories) { cat in
                ForEach(cat.recommendations, id: \.self) { rec in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(cat.scoreColor)
                            .frame(width: 8, height: 8)
                        Text(rec)
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textPrimary)
                        Spacer()
                    }
                    .padding(10)
                    .background(cat.scoreColor.opacity(0.08))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Share Button
    private var shareButton: some View {
        Button(action: { showShareSheet = true }) {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                Text("Partajeaza Raportul")
                    .font(.system(size: 14, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [generateShareText()])
        }
    }
    
    // MARK: - Helpers
    private func calculateHealthScore() {
        // Calculate from vehicle data
        let vehicle = vehicleManager.currentVehicle
        var categories = HealthCategory.sampleCategories
        
        // Adjust based on mileage
        if vehicle.mileage > 150000 {
            for i in categories.indices {
                categories[i].score = max(30, categories[i].score - 15)
            }
        } else if vehicle.mileage > 100000 {
            for i in categories.indices {
                categories[i].score = max(40, categories[i].score - 8)
            }
        }
        
        // Store baseline BEFORE OBD adjustments for future recalculations
        baselineCategories = categories
        
        // If OBD2 connected, use real data
        if obdManager.isConnected {
            adjustCategoriesFromOBD(&categories)
        }
        
        let avgScore = categories.reduce(0) { $0 + $1.score } / max(1, categories.count)
        
        healthScore = HealthScore(
            overallScore: avgScore,
            categories: categories,
            lastUpdated: Date(),
            vehicleId: vehicle.id
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateRing = true
        }
    }
    
    private func recalculateFromOBD() {
        // Start from baseline categories (before OBD adjustments) to avoid cumulative inflation
        var categories = baselineCategories.isEmpty ? healthScore.categories : baselineCategories
        adjustCategoriesFromOBD(&categories)
        let avgScore = categories.reduce(0) { $0 + $1.score } / max(1, categories.count)
        withAnimation(.easeInOut(duration: 0.5)) {
            healthScore = HealthScore(
                overallScore: avgScore,
                categories: categories,
                lastUpdated: Date(),
                vehicleId: vehicleManager.currentVehicle.id
            )
        }
    }
    
    private func adjustCategoriesFromOBD(_ categories: inout [HealthCategory]) {
        let data = obdManager.liveData
        // Engine temp check
        if data.engineTemp > 105 {
            if let idx = categories.firstIndex(where: { $0.name.contains("Motor") }) {
                categories[idx].score = max(20, categories[idx].score - 25)
                categories[idx].details = "Temperatura ridicata: \(Int(data.engineTemp))\u00b0C"
            }
        } else if data.engineTemp > 60 && data.engineTemp < 100 {
            if let idx = categories.firstIndex(where: { $0.name.contains("Motor") }) {
                categories[idx].score = min(100, categories[idx].score + 5)
            }
        }
        // Battery check
        if data.batteryVoltage < 11.8 {
            if let idx = categories.firstIndex(where: { $0.name.contains("Electric") }) {
                categories[idx].score = max(30, categories[idx].score - 20)
                categories[idx].details = "Tensiune baterie scazuta: \(String(format: "%.1f", data.batteryVoltage))V"
            }
        }
        // RPM idle check
        if data.rpm > 0 && data.rpm < 600 {
            if let idx = categories.firstIndex(where: { $0.name.contains("Motor") }) {
                categories[idx].score = max(40, categories[idx].score - 10)
                categories[idx].recommendations.append("Turatie ralanti scazuta - verificati injectoarele")
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "ro_RO")
        return formatter.string(from: date)
    }
    
    private func generateShareText() -> String {
        """
        🚗 AutoDiag Pro - Raport Sanatate
        Vehicul: \(vehicleManager.currentVehicle.displayName)
        Scor: \(healthScore.overallScore)/100 - \(healthScore.scoreLabel)
        
        \(healthScore.categories.map { "• \($0.name): \($0.score)/100" }.joined(separator: "\n"))
        
        Generat cu AutoDiag Pro Ultimate
        """
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
