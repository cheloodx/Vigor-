import SwiftUI

// MARK: - RCA Insurance Comparator View
struct RCAComparatorView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var offers: [InsuranceOffer] = []
    @State private var isSearching = false
    @State private var searchComplete = false
    @State private var selectedPeriod = 12
    
    let periods = [1, 3, 6, 12]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    vehicleInfoCard
                    periodSelector
                    
                    if !searchComplete && !isSearching {
                        searchButton
                    }
                    
                    if isSearching { searchingCard }
                    
                    if searchComplete {
                        ForEach(offers) { offer in
                            offerCard(offer)
                        }
                        legalInfoCard
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
                        Image(systemName: "shield.fill")
                            .foregroundColor(Theme.primary)
                        Text("Comparator RCA")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var vehicleInfoCard: some View {
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
                Text("\(vehicleManager.currentVehicle.year) | \(vehicleManager.currentVehicle.mileage) km")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
            }
            Spacer()
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var periodSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Perioada asigurare")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            HStack(spacing: 8) {
                ForEach(periods, id: \.self) { p in
                    Button(action: { selectedPeriod = p; if searchComplete { searchOffers() } }) {
                        Text("\(p) luni")
                            .font(.system(size: 12, weight: selectedPeriod == p ? .bold : .regular))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedPeriod == p ? Theme.primary : Theme.surfaceBackground)
                            .foregroundColor(selectedPeriod == p ? .white : Theme.textSecondary)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var searchButton: some View {
        Button(action: { searchOffers() }) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                Text("Compara Oferte RCA")
                    .font(.system(size: 15, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
    }
    
    private var searchingCard: some View {
        VStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Theme.primary))
                .scaleEffect(1.2)
            Text("Cautare oferte RCA...")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func offerCard(_ offer: InsuranceOffer) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(offer.company)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                if offer.isBestPrice {
                    Text("CEL MAI BUN PRET")
                        .font(.system(size: 8, weight: .black))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Theme.gaugeGreen.opacity(0.2))
                        .foregroundColor(Theme.gaugeGreen)
                        .cornerRadius(4)
                }
            }
            
            HStack(alignment: .bottom) {
                Text(String(format: "%.0f", offer.price))
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(offer.isBestPrice ? Theme.gaugeGreen : Theme.secondary)
                Text(offer.currency)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.textSecondary)
                    .padding(.bottom, 4)
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: i < offer.rating ? "star.fill" : "star")
                            .font(.system(size: 9))
                            .foregroundColor(i < offer.rating ? Theme.gaugeYellow : Theme.textMuted)
                    }
                }
            }
            
            HStack(spacing: 12) {
                featureChip(offer.decontareDirecta ? "Decontare directa" : "Decontare clasica", active: offer.decontareDirecta)
                featureChip("Asistenta rutiera", active: offer.asistentaRutiera)
                featureChip("Online", active: offer.emitereOnline)
            }
            
            HStack {
                Text("Despagubire max: \(offer.despagubireMax)")
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
                Spacer()
                Text("Teritoriu: \(offer.teritoriu)")
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(offer.isBestPrice ? Theme.gaugeGreen.opacity(0.3) : Color.clear, lineWidth: 1))
    }
    
    private func featureChip(_ text: String, active: Bool) -> some View {
        HStack(spacing: 3) {
            Image(systemName: active ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 8))
            Text(text)
                .font(.system(size: 9))
        }
        .foregroundColor(active ? Theme.gaugeGreen : Theme.textMuted)
    }
    
    private var legalInfoCard: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(Theme.primary)
            Text("Preturile sunt orientative. RCA obligatoriu conform Legii 132/2017. Tarifele pot varia in functie de istoricul de daune (Bonus-Malus), varsta soferului si zona de inmatriculare.")
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
                .lineSpacing(2)
        }
        .padding(10)
        .background(Theme.primary.opacity(0.05))
        .cornerRadius(8)
    }
    
    private func searchOffers() {
        isSearching = true
        searchComplete = false
        offers = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.spring()) {
                isSearching = false
                searchComplete = true
                offers = InsuranceOffer.sampleOffers(months: selectedPeriod)
            }
        }
    }
}

struct InsuranceOffer: Identifiable {
    let id = UUID()
    let company: String
    let price: Double
    let currency: String
    let rating: Int
    let decontareDirecta: Bool
    let asistentaRutiera: Bool
    let emitereOnline: Bool
    let despagubireMax: String
    let teritoriu: String
    let isBestPrice: Bool
    
    static func sampleOffers(months: Int) -> [InsuranceOffer] {
        let multiplier = Double(months) / 12.0
        return [
            InsuranceOffer(company: "Euroins", price: 850 * multiplier, currency: "RON", rating: 3, decontareDirecta: false, asistentaRutiera: false, emitereOnline: true, despagubireMax: "1.22M EUR", teritoriu: "Europa", isBestPrice: true),
            InsuranceOffer(company: "City Insurance", price: 920 * multiplier, currency: "RON", rating: 3, decontareDirecta: false, asistentaRutiera: true, emitereOnline: true, despagubireMax: "1.22M EUR", teritoriu: "Europa", isBestPrice: false),
            InsuranceOffer(company: "Groupama", price: 1050 * multiplier, currency: "RON", rating: 4, decontareDirecta: true, asistentaRutiera: true, emitereOnline: true, despagubireMax: "1.22M EUR", teritoriu: "Europa", isBestPrice: false),
            InsuranceOffer(company: "Allianz-Tiriac", price: 1180 * multiplier, currency: "RON", rating: 5, decontareDirecta: true, asistentaRutiera: true, emitereOnline: true, despagubireMax: "6.07M EUR", teritoriu: "Europa", isBestPrice: false),
            InsuranceOffer(company: "Omniasig VIG", price: 1100 * multiplier, currency: "RON", rating: 4, decontareDirecta: true, asistentaRutiera: true, emitereOnline: true, despagubireMax: "1.22M EUR", teritoriu: "Europa", isBestPrice: false),
            InsuranceOffer(company: "Generali", price: 1250 * multiplier, currency: "RON", rating: 5, decontareDirecta: true, asistentaRutiera: true, emitereOnline: true, despagubireMax: "6.07M EUR", teritoriu: "Europa + Turcia", isBestPrice: false),
        ]
    }
}
