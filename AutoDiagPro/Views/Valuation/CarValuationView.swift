import SwiftUI

// MARK: - Car Valuation Estimator View
struct CarValuationView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var valuation: CarValuation?
    @State private var isCalculating = false
    @State private var condition: VehicleCondition = .good
    
    enum VehicleCondition: String, CaseIterable {
        case excellent = "Excelenta"
        case good = "Buna"
        case fair = "Acceptabila"
        case poor = "Slaba"
        
        var multiplier: Double {
            switch self {
            case .excellent: return 1.15
            case .good: return 1.0
            case .fair: return 0.85
            case .poor: return 0.7
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    vehicleCard
                    conditionSelector
                    
                    if !isCalculating && valuation == nil {
                        calculateButton
                    }
                    if isCalculating { calculatingCard }
                    if let v = valuation {
                        valuationResult(v)
                        priceFactors(v)
                        marketComparison(v)
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
                        Image(systemName: "tag.fill")
                            .foregroundColor(Theme.secondary)
                        Text("Estimator Valoare")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var vehicleCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "car.fill")
                .font(.system(size: 22))
                .foregroundColor(Theme.primary)
                .frame(width: 44, height: 44)
                .background(Theme.primary.opacity(0.15))
                .cornerRadius(12)
            VStack(alignment: .leading, spacing: 2) {
                Text(vehicleManager.currentVehicle.displayName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Text("An: \(vehicleManager.currentVehicle.year) | \(vehicleManager.currentVehicle.mileage) km")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
            }
            Spacer()
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var conditionSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stare vehicul")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            HStack(spacing: 6) {
                ForEach(VehicleCondition.allCases, id: \.self) { c in
                    Button(action: { condition = c; if valuation != nil { calculateValue() } }) {
                        Text(c.rawValue)
                            .font(.system(size: 11, weight: condition == c ? .bold : .regular))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(condition == c ? Theme.primary : Theme.surfaceBackground)
                            .foregroundColor(condition == c ? .white : Theme.textSecondary)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var calculateButton: some View {
        Button(action: { calculateValue() }) {
            HStack(spacing: 8) {
                Image(systemName: "tag.fill")
                Text("Estimeaza Valoarea")
                    .font(.system(size: 15, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
    }
    
    private var calculatingCard: some View {
        VStack(spacing: 10) {
            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Theme.primary)).scaleEffect(1.2)
            Text("Calculare valoare de piata...")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity).padding(16)
        .background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private func valuationResult(_ v: CarValuation) -> some View {
        VStack(spacing: 12) {
            Text("VALOARE ESTIMATA")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            HStack(alignment: .bottom, spacing: 4) {
                Text(String(format: "%.0f", v.estimatedPrice))
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(Theme.secondary)
                Text("- \(String(format: "%.0f", v.maxPrice)) RON")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Theme.textSecondary)
                    .padding(.bottom, 4)
            }
            
            Text("Pret mediu piata: \(String(format: "%.0f RON", v.averagePrice))")
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
            
            // Confidence bar
            HStack(spacing: 8) {
                Text("Incredere:")
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Theme.gaugeGreen)
                            .frame(width: geo.size.width * CGFloat(v.confidence) / 100.0)
                    }
                }
                .frame(height: 6)
                Text("\(v.confidence)%")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.gaugeGreen)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.secondary.opacity(0.3), lineWidth: 1))
    }
    
    private func priceFactors(_ v: CarValuation) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FACTORI PRET")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ForEach(v.factors, id: \.name) { factor in
                HStack {
                    Text(factor.name)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text(factor.impact)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(factor.isPositive ? Theme.gaugeGreen : Theme.gaugeRed)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func marketComparison(_ v: CarValuation) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("COMPARATIE PIATA")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ForEach(v.comparisons, id: \.platform) { comp in
                HStack {
                    Text(comp.platform)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Text("\(comp.count) anunturi")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)
                    Text(comp.priceRange)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.secondary)
                }
                .padding(8)
                .background(Theme.surfaceBackground)
                .cornerRadius(6)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func calculateValue() {
        isCalculating = true; valuation = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring()) {
                isCalculating = false
                valuation = CarValuation.sample(condition: condition)
            }
        }
    }
}

struct CarValuation {
    let estimatedPrice: Double
    let maxPrice: Double
    let averagePrice: Double
    let confidence: Int
    let factors: [PriceFactor]
    let comparisons: [MarketComparison]
    
    struct PriceFactor {
        let name: String; let impact: String; let isPositive: Bool
    }
    struct MarketComparison {
        let platform: String; let count: Int; let priceRange: String
    }
    
    static func sample(condition: CarValuationView.VehicleCondition) -> CarValuation {
        let base = 12500.0 * condition.multiplier
        return CarValuation(
            estimatedPrice: base * 0.9, maxPrice: base * 1.1, averagePrice: base,
            confidence: 78,
            factors: [
                PriceFactor(name: "An fabricatie 2019", impact: "+1200 RON", isPositive: true),
                PriceFactor(name: "Km parcursi (123.000)", impact: "-800 RON", isPositive: false),
                PriceFactor(name: "Stare \(condition.rawValue.lowercased())", impact: condition.multiplier >= 1 ? "+500 RON" : "-500 RON", isPositive: condition.multiplier >= 1),
                PriceFactor(name: "Cutie automata", impact: "+600 RON", isPositive: true),
                PriceFactor(name: "Motor diesel", impact: "-300 RON", isPositive: false),
                PriceFactor(name: "Istoric service complet", impact: "+400 RON", isPositive: true),
            ],
            comparisons: [
                MarketComparison(platform: "Autovit.ro", count: 47, priceRange: "\(Int(base*0.85))-\(Int(base*1.15)) RON"),
                MarketComparison(platform: "OLX Auto", count: 31, priceRange: "\(Int(base*0.8))-\(Int(base*1.2)) RON"),
                MarketComparison(platform: "Mobile.de", count: 128, priceRange: "\(Int(base*0.9))-\(Int(base*1.1)) EUR"),
            ]
        )
    }
}
