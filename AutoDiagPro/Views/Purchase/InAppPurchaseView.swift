import SwiftUI
import StoreKit

// MARK: - In-App Purchase View
// Free vs PRO subscription comparison + purchase flow
struct InAppPurchaseView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedPlan: PurchasePlan = .yearly
    @State private var isPurchasing = false
    @State private var showRestoreAlert = false
    @State private var isPro: Bool = UserDefaults.standard.bool(forKey: "isPro")
    
    enum PurchasePlan: String, CaseIterable {
        case monthly = "Lunar"
        case yearly = "Anual"
        case lifetime = "Pe Viata"
        
        var price: String {
            switch self {
            case .monthly: return "4.99"
            case .yearly: return "29.99"
            case .lifetime: return "79.99"
            }
        }
        
        var period: String {
            switch self {
            case .monthly: return "/luna"
            case .yearly: return "/an"
            case .lifetime: return " o singura data"
            }
        }
        
        var savings: String? {
            switch self {
            case .monthly: return nil
            case .yearly: return "Economisesti 50%"
            case .lifetime: return "Cel mai bun pret"
            }
        }
        
        var currency: String { "EUR" }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                if isPro {
                    proActiveCard
                } else {
                    // Header
                    headerCard
                    
                    // Feature comparison
                    featureComparison
                    
                    // Plans
                    planSelector
                    
                    // Purchase button
                    purchaseButton
                    
                    // Restore
                    restoreButton
                    
                    // Legal
                    legalInfo
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
                    Image(systemName: "star.fill")
                        .foregroundColor(Theme.secondary)
                    Text("PRO")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .alert("Restaurare Achizitii", isPresented: $showRestoreAlert) {
            Button("OK") {}
        } message: {
            Text("Achizitiile au fost restaurate cu succes.")
        }
    }
    
    // MARK: - Pro Active Card
    private var proActiveCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Theme.secondary.opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: "crown.fill")
                    .font(.system(size: 36))
                    .foregroundColor(Theme.secondary)
            }
            
            Text("AutoDiag PRO Activ!")
                .font(.system(size: 22, weight: .black))
                .foregroundColor(Theme.secondary)
            
            Text("Ai acces complet la toate functiile premium.")
                .font(.system(size: 13))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 8) {
                proFeature(text: "Functii AI nelimitate")
                proFeature(text: "Export PDF nelimitat")
                proFeature(text: "OBD2 date avansate")
                proFeature(text: "Fara reclame")
                proFeature(text: "Suport prioritar")
            }
            .padding(16)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
        }
        .padding(20)
    }
    
    private func proFeature(text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(Theme.secondary)
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textPrimary)
        }
    }
    
    // MARK: - Header
    private var headerCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.secondary.opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: "crown.fill")
                    .font(.system(size: 36))
                    .foregroundColor(Theme.secondary)
            }
            
            Text("AutoDiag PRO")
                .font(.system(size: 24, weight: .black))
                .foregroundColor(Theme.secondary)
            
            Text("Deblocheaza toate functiile premium si diagnostic-uri avansate")
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: [Theme.secondary.opacity(0.1), Theme.cardBackground], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Feature Comparison
    private var featureComparison: some View {
        VStack(spacing: 0) {
            // Header row
            HStack {
                Text("FUNCTIE")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("GRATUIT")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .frame(width: 60)
                Text("PRO")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(Theme.secondary)
                    .frame(width: 60)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Theme.surfaceBackground)
            
            // Features
            comparisonRow(feature: "Scor Sanatate", free: true, pro: true)
            comparisonRow(feature: "Diagnostic Basic", free: true, pro: true)
            comparisonRow(feature: "3 Vehicule", free: true, pro: false, proText: "Nelimitat")
            comparisonRow(feature: "OBD2 Basic", free: true, pro: false, proText: "Avansat")
            comparisonRow(feature: "AI Mecanic", free: false, pro: true, freeText: "3/zi")
            comparisonRow(feature: "Export PDF", free: false, pro: true, freeText: "1/luna")
            comparisonRow(feature: "Predictor AI", free: false, pro: true)
            comparisonRow(feature: "Consum Real", free: false, pro: true)
            comparisonRow(feature: "Alarme Nelimitate", free: false, pro: true)
            comparisonRow(feature: "Fara Reclame", free: false, pro: true)
            comparisonRow(feature: "Suport Prioritar", free: false, pro: true)
        }
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func comparisonRow(feature: String, free: Bool, pro: Bool, freeText: String? = nil, proText: String? = nil) -> some View {
        HStack {
            Text(feature)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                if let text = freeText {
                    Text(text)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(Theme.gaugeYellow)
                } else {
                    Image(systemName: free ? "checkmark.circle.fill" : "xmark.circle")
                        .font(.system(size: 13))
                        .foregroundColor(free ? Theme.gaugeGreen : Theme.textMuted.opacity(0.3))
                }
            }
            .frame(width: 60)
            
            Group {
                if let text = proText {
                    Text(text)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(Theme.secondary)
                } else {
                    Image(systemName: pro ? "checkmark.circle.fill" : "xmark.circle")
                        .font(.system(size: 13))
                        .foregroundColor(pro ? Theme.secondary : Theme.textMuted.opacity(0.3))
                }
            }
            .frame(width: 60)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
    }
    
    // MARK: - Plan Selector
    private var planSelector: some View {
        VStack(spacing: 8) {
            Text("SELECTEAZA PLANUL")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(PurchasePlan.allCases, id: \.rawValue) { plan in
                Button(action: { selectedPlan = plan }) {
                    HStack(spacing: 10) {
                        Image(systemName: selectedPlan == plan ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 18))
                            .foregroundColor(selectedPlan == plan ? Theme.secondary : Theme.textMuted)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text(plan.rawValue)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                if let savings = plan.savings {
                                    Text(savings)
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(Theme.secondary)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Theme.secondary.opacity(0.15))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(plan.price) \(plan.currency)\(plan.period)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(selectedPlan == plan ? Theme.secondary : Theme.textSecondary)
                    }
                    .padding(12)
                    .background(selectedPlan == plan ? Theme.secondary.opacity(0.1) : Theme.surfaceBackground)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedPlan == plan ? Theme.secondary.opacity(0.5) : Color.clear, lineWidth: 1.5)
                    )
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Purchase Button
    private var purchaseButton: some View {
        Button(action: {
            isPurchasing = true
            // Simulate purchase
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isPurchasing = false
                isPro = true
                UserDefaults.standard.set(true, forKey: "isPro")
            }
        }) {
            HStack(spacing: 8) {
                if isPurchasing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "crown.fill")
                    Text("Upgrade la PRO — \(selectedPlan.price) \(selectedPlan.currency)\(selectedPlan.period)")
                }
            }
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.secondary)
            .cornerRadius(14)
        }
        .disabled(isPurchasing)
    }
    
    // MARK: - Restore Button
    private var restoreButton: some View {
        Button(action: {
            showRestoreAlert = true
        }) {
            Text("Restaureaza Achizitiile Anterioare")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textMuted)
        }
    }
    
    // MARK: - Legal Info
    private var legalInfo: some View {
        VStack(spacing: 4) {
            Text("Abonamentul se reinnoieste automat. Poti anula oricand din Setari > Abonamente.")
                .font(.system(size: 9))
                .foregroundColor(Theme.textMuted)
                .multilineTextAlignment(.center)
            Text("Politica de Confidentialitate | Termeni si Conditii")
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(Theme.primary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
    }
}
