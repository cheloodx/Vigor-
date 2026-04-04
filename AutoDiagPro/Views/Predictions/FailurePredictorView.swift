import SwiftUI

// MARK: - AI Failure Predictor View
// Predicts what will break in the next 3-6 months based on vehicle data
struct FailurePredictorView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var viewModel = FailurePredictorViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Vehicle info header
                    vehicleHeader
                    
                    // Analysis button or progress
                    if !viewModel.analysisComplete {
                        if viewModel.isAnalyzing {
                            analysisProgressCard
                        } else {
                            startAnalysisButton
                        }
                    }
                    
                    // Predictions list
                    if viewModel.analysisComplete {
                        riskSummaryCard
                        
                        ForEach(viewModel.predictions) { prediction in
                            predictionCard(prediction)
                        }
                        
                        disclaimerCard
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
                        Image(systemName: "brain")
                            .foregroundColor(Theme.primary)
                        Text("Predictor Defectiuni AI")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var vehicleHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "car.fill")
                .font(.system(size: 24))
                .foregroundColor(Theme.primary)
                .frame(width: 44, height: 44)
                .background(Theme.primary.opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(vehicleManager.currentVehicle.displayName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Text("\(vehicleManager.currentVehicle.mileage) km")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var startAnalysisButton: some View {
        Button(action: { viewModel.startAnalysis(vehicle: vehicleManager.currentVehicle) }) {
            HStack(spacing: 10) {
                Image(systemName: "brain")
                    .font(.system(size: 18))
                Text("Analizeaza Predictii Defectiuni")
                    .font(.system(size: 15, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
    }
    
    private var analysisProgressCard: some View {
        VStack(spacing: 14) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Theme.primary))
                .scaleEffect(1.3)
            
            Text("Analiza AI in curs...")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.primaryGradient)
                        .frame(width: geo.size.width * viewModel.progress)
                }
            }
            .frame(height: 6)
            
            VStack(spacing: 4) {
                stepIndicator("Colectare date vehicul", done: viewModel.progress > 0.2)
                stepIndicator("Analiza pattern-uri uzura", done: viewModel.progress > 0.4)
                stepIndicator("Comparare cu flota similara", done: viewModel.progress > 0.6)
                stepIndicator("Calcul probabilitati", done: viewModel.progress > 0.8)
                stepIndicator("Generare predictii", done: viewModel.progress >= 1.0)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func stepIndicator(_ text: String, done: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 11))
                .foregroundColor(done ? Theme.gaugeGreen : Theme.textMuted)
            Text(text)
                .font(.system(size: 11))
                .foregroundColor(done ? Theme.textPrimary : Theme.textMuted)
            Spacer()
        }
    }
    
    private var riskSummaryCard: some View {
        let highRisk = viewModel.predictions.filter { $0.riskLevel == .high }.count
        let medRisk = viewModel.predictions.filter { $0.riskLevel == .medium }.count
        let lowRisk = viewModel.predictions.filter { $0.riskLevel == .low }.count
        
        return HStack(spacing: 16) {
            riskBadge(count: highRisk, label: "Risc Ridicat", color: Theme.gaugeRed)
            riskBadge(count: medRisk, label: "Risc Mediu", color: Theme.gaugeYellow)
            riskBadge(count: lowRisk, label: "Risc Scazut", color: Theme.gaugeGreen)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func riskBadge(count: Int, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(Theme.textMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func predictionCard(_ prediction: FailurePrediction) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(prediction.riskLevel.color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: prediction.icon)
                        .font(.system(size: 18))
                        .foregroundColor(prediction.riskLevel.color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(prediction.componentName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    Text("Probabilitate: \(prediction.probability)%")
                        .font(.system(size: 11))
                        .foregroundColor(prediction.riskLevel.color)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(prediction.riskLevel.label)
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(prediction.riskLevel.color.opacity(0.2))
                        .foregroundColor(prediction.riskLevel.color)
                        .cornerRadius(4)
                    Text(prediction.timeframe)
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)
                }
            }
            
            Text(prediction.description)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(3)
            
            // Probability bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                    RoundedRectangle(cornerRadius: 3)
                        .fill(prediction.riskLevel.color)
                        .frame(width: geo.size.width * CGFloat(prediction.probability) / 100.0)
                }
            }
            .frame(height: 5)
            
            if prediction.estimatedCost > 0 {
                HStack {
                    Text("Cost estimat reparatie:")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                    Text(String(format: "%.0f - %.0f RON", prediction.estimatedCost * 0.8, prediction.estimatedCost * 1.2))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.secondary)
                }
            }
            
            if !prediction.preventionTip.isEmpty {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.gaugeYellow)
                        .padding(.top, 2)
                    Text(prediction.preventionTip)
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(8)
                .background(Theme.gaugeYellow.opacity(0.08))
                .cornerRadius(8)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(prediction.riskLevel.color.opacity(0.2), lineWidth: 1))
    }
    
    private var disclaimerCard: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(Theme.primary)
            Text("Predictiile sunt bazate pe date statistice si pattern-uri comune pentru acest tip de vehicul. Consultati un mecanic pentru diagnostic precis.")
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
                .lineSpacing(2)
        }
        .padding(10)
        .background(Theme.primary.opacity(0.05))
        .cornerRadius(8)
    }
    
}

// MARK: - Models
struct FailurePrediction: Identifiable {
    let id = UUID()
    let componentName: String
    let icon: String
    let probability: Int
    let riskLevel: RiskLevel
    let timeframe: String
    let description: String
    let estimatedCost: Double
    let preventionTip: String
    
    enum RiskLevel {
        case high, medium, low
        var color: Color {
            switch self {
            case .high: return Theme.gaugeRed
            case .medium: return Theme.gaugeYellow
            case .low: return Theme.gaugeGreen
            }
        }
        var label: String {
            switch self {
            case .high: return "RIDICAT"
            case .medium: return "MEDIU"
            case .low: return "SCAZUT"
            }
        }
    }
    
    static var samplePredictions: [FailurePrediction] {
        [
            FailurePrediction(componentName: "Placute Frana Fata", icon: "circle.circle", probability: 85, riskLevel: .high, timeframe: "1-2 luni", description: "Bazat pe km parcursi (45.000 km de la ultima schimbare), placutele de frana fata au probabilitate ridicata de uzura critica. Media de viata pentru acest model este 50.000 km.", estimatedCost: 450, preventionTip: "Programeaza verificare frane in urmatoarele 2 saptamani."),
            FailurePrediction(componentName: "Baterie Auto", icon: "battery.100percent", probability: 72, riskLevel: .high, timeframe: "2-4 luni", description: "Bateria are aprox. 4 ani vechime. Statisticile arata ca 70% din baterii cedeaza intre 3-5 ani. Tensiunea la pornire a scazut progresiv.", estimatedCost: 400, preventionTip: "Testeaza capacitatea bateriei la un service autorizat."),
            FailurePrediction(componentName: "Curea Distributie", icon: "gearshape.2.fill", probability: 45, riskLevel: .medium, timeframe: "3-6 luni", description: "Intervalul recomandat de schimb este 120.000 km. Kilometrajul actual se apropie de acest prag. Ruperea cureii poate distruge motorul.", estimatedCost: 1500, preventionTip: "Nu depasi intervalul de schimb recomandat de producator!"),
            FailurePrediction(componentName: "Amortizoare Fata", icon: "arrow.up.arrow.down", probability: 38, riskLevel: .medium, timeframe: "4-6 luni", description: "Amortizoarele au peste 80.000 km. Eficienta de amortizare scade progresiv dupa 60.000 km. Pot aparea zgomote si instabilitate.", estimatedCost: 800, preventionTip: "Verificare vizuala pentru scurgeri de ulei la amortizoare."),
            FailurePrediction(componentName: "Filtru Particule DPF", icon: "wind", probability: 30, riskLevel: .medium, timeframe: "3-6 luni", description: "Conducerea predominant in oras creste riscul de blocare DPF. Regenerarile active au devenit mai frecvente.", estimatedCost: 1200, preventionTip: "Fa o cursa lunga pe autostrada (min 30 min, > 2500 RPM) lunar."),
            FailurePrediction(componentName: "Alternator", icon: "bolt.fill", probability: 15, riskLevel: .low, timeframe: "6+ luni", description: "Alternatorul functioneaza in parametri normali. Riscul de defectiune creste dupa 150.000 km.", estimatedCost: 600, preventionTip: "Monitorizare tensiune baterie in dashboard Live."),
        ]
    }
}
