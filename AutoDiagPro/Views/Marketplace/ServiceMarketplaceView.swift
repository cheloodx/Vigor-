import SwiftUI

// MARK: - Service Marketplace View
// Connect users with mechanics and service shops, with commission model
struct ServiceMarketplaceView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedCategory: ServiceCategory = .all
    @State private var providers: [ServiceProvider] = ServiceProvider.sampleProviders
    @State private var searchText = ""
    
    enum ServiceCategory: String, CaseIterable {
        case all = "Toate"
        case mechanic = "Mecanici"
        case service = "Service-uri"
        case mobile = "Mobil"
        case specialist = "Specialisti"
        
        var icon: String {
            switch self {
            case .all: return "square.grid.2x2.fill"
            case .mechanic: return "wrench.fill"
            case .service: return "building.2.fill"
            case .mobile: return "car.fill"
            case .specialist: return "star.fill"
            }
        }
    }
    
    private var filteredProviders: [ServiceProvider] {
        providers.filter { provider in
            let categoryMatch = selectedCategory == .all || provider.category == selectedCategory
            let searchMatch = searchText.isEmpty || provider.name.localizedCaseInsensitiveContains(searchText) || provider.speciality.localizedCaseInsensitiveContains(searchText)
            return categoryMatch && searchMatch
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Search
                    searchBar
                    
                    // Category filter
                    categoryFilter
                    
                    // Featured
                    if selectedCategory == .all && searchText.isEmpty {
                        featuredSection
                    }
                    
                    // Providers list
                    providersList
                    
                    // How it works
                    howItWorksCard
                    
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
                        Image(systemName: "storefront.fill")
                            .foregroundColor(Theme.secondary)
                        Text("Marketplace Auto")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14)).foregroundColor(Theme.textMuted)
            TextField("Cauta mecanic, service, specialitate...", text: $searchText)
                .font(.system(size: 13)).foregroundColor(Theme.textPrimary)
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.primary.opacity(0.2), lineWidth: 1))
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ServiceCategory.allCases, id: \.self) { cat in
                    Button(action: { withAnimation { selectedCategory = cat } }) {
                        HStack(spacing: 4) {
                            Image(systemName: cat.icon).font(.system(size: 10))
                            Text(cat.rawValue).font(.system(size: 11, weight: selectedCategory == cat ? .bold : .regular))
                        }
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(selectedCategory == cat ? Theme.primary : Theme.surfaceBackground)
                        .foregroundColor(selectedCategory == cat ? .white : Theme.textSecondary)
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("RECOMANDATE PENTRU TINE")
                .font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1.2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(providers.filter { $0.isFeatured }) { provider in
                        featuredCard(provider)
                    }
                }
            }
        }
    }
    
    private func featuredCard(_ provider: ServiceProvider) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(provider.name).font(.system(size: 13, weight: .bold)).foregroundColor(Theme.textPrimary)
                Spacer()
                HStack(spacing: 2) {
                    Image(systemName: "star.fill").font(.system(size: 9)).foregroundColor(Theme.gaugeYellow)
                    Text(String(format: "%.1f", provider.rating)).font(.system(size: 11, weight: .bold)).foregroundColor(Theme.textPrimary)
                }
            }
            Text(provider.speciality).font(.system(size: 10)).foregroundColor(Theme.textSecondary)
            HStack {
                Image(systemName: "mappin").font(.system(size: 9)).foregroundColor(Theme.primary)
                Text(provider.location).font(.system(size: 10)).foregroundColor(Theme.textMuted)
            }
        }
        .frame(width: 200)
        .padding(12).background(Theme.cardBackground).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.primary.opacity(0.2), lineWidth: 1))
    }
    
    private var providersList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(filteredProviders.count) REZULTATE")
                .font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1.2)
            
            ForEach(filteredProviders) { provider in
                providerCard(provider)
            }
        }
    }
    
    private func providerCard(_ provider: ServiceProvider) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle().fill(provider.category.icon == "wrench.fill" ? Theme.primary.opacity(0.15) : Theme.secondary.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: provider.category.icon).font(.system(size: 16))
                        .foregroundColor(provider.category.icon == "wrench.fill" ? Theme.primary : Theme.secondary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(provider.name).font(.system(size: 14, weight: .bold)).foregroundColor(Theme.textPrimary)
                        if provider.isVerified {
                            Image(systemName: "checkmark.seal.fill").font(.system(size: 10)).foregroundColor(Theme.primary)
                        }
                    }
                    Text(provider.speciality).font(.system(size: 11)).foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill").font(.system(size: 9)).foregroundColor(Theme.gaugeYellow)
                        Text(String(format: "%.1f", provider.rating)).font(.system(size: 12, weight: .bold)).foregroundColor(Theme.textPrimary)
                    }
                    Text("(\(provider.reviewCount) recenzii)").font(.system(size: 9)).foregroundColor(Theme.textMuted)
                }
            }
            
            HStack(spacing: 12) {
                HStack(spacing: 3) {
                    Image(systemName: "mappin").font(.system(size: 9)).foregroundColor(Theme.primary)
                    Text(provider.location).font(.system(size: 10)).foregroundColor(Theme.textMuted)
                }
                HStack(spacing: 3) {
                    Image(systemName: "clock").font(.system(size: 9)).foregroundColor(Theme.primary)
                    Text(provider.availability).font(.system(size: 10)).foregroundColor(Theme.textMuted)
                }
                Spacer()
                Text(provider.priceRange).font(.system(size: 11, weight: .bold)).foregroundColor(Theme.secondary)
            }
            
            // Quick services
            if !provider.quickServices.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(provider.quickServices, id: \.self) { service in
                            Text(service).font(.system(size: 9, weight: .semibold))
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(Theme.primary.opacity(0.1)).foregroundColor(Theme.primary).cornerRadius(4)
                        }
                    }
                }
            }
            
            // Action buttons
            HStack(spacing: 8) {
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill").font(.system(size: 10))
                        Text("Suna").font(.system(size: 11, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                    .background(Theme.primary).foregroundColor(.white).cornerRadius(8)
                }
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar").font(.system(size: 10))
                        Text("Programeaza").font(.system(size: 11, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                    .background(Theme.surfaceBackground).foregroundColor(Theme.primary).cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
                }
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var howItWorksCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CUM FUNCTIONEAZA").font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1.2)
            
            HStack(spacing: 12) {
                stepBadge(num: 1, text: "Cauta", icon: "magnifyingglass")
                stepBadge(num: 2, text: "Compara", icon: "arrow.left.arrow.right")
                stepBadge(num: 3, text: "Programeaza", icon: "calendar")
                stepBadge(num: 4, text: "Platesti", icon: "creditcard.fill")
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private func stepBadge(num: Int, text: String, icon: String) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle().fill(Theme.primary.opacity(0.15)).frame(width: 32, height: 32)
                Image(systemName: icon).font(.system(size: 12)).foregroundColor(Theme.primary)
            }
            Text(text).font(.system(size: 9, weight: .semibold)).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ServiceProvider: Identifiable {
    let id = UUID()
    let name: String; let speciality: String; let location: String
    let rating: Double; let reviewCount: Int; let availability: String
    let priceRange: String; let category: ServiceMarketplaceView.ServiceCategory
    let isVerified: Bool; let isFeatured: Bool; let quickServices: [String]
    
    static var sampleProviders: [ServiceProvider] {
        [
            ServiceProvider(name: "AutoMaster Pro", speciality: "Service auto complet, diagnoza computerizata", location: "Bucuresti, Sector 3", rating: 4.8, reviewCount: 312, availability: "Luni-Vineri 8-18", priceRange: "$$", category: .service, isVerified: true, isFeatured: true, quickServices: ["Revizie", "Frane", "Distributie", "Diagnoza"]),
            ServiceProvider(name: "Mihai Popescu", speciality: "Mecanic specialist VAG (VW, Audi, Skoda)", location: "Bucuresti, Sector 1", rating: 4.9, reviewCount: 187, availability: "Luni-Sambata 9-17", priceRange: "$", category: .mechanic, isVerified: true, isFeatured: true, quickServices: ["DSG", "TDI", "TSI", "Diagnoza VAG"]),
            ServiceProvider(name: "MobilFix Auto", speciality: "Service mobil la domiciliu", location: "Bucuresti + Ilfov", rating: 4.6, reviewCount: 98, availability: "Non-stop", priceRange: "$$", category: .mobile, isVerified: true, isFeatured: false, quickServices: ["Baterie", "Cauciucuri", "Revizie"]),
            ServiceProvider(name: "ClimAuto Expert", speciality: "Specialist climatizare auto", location: "Cluj-Napoca", rating: 4.7, reviewCount: 156, availability: "Luni-Vineri 8-17", priceRange: "$$$", category: .specialist, isVerified: true, isFeatured: false, quickServices: ["Incarcare AC", "Reparatie compresor", "Spalare evaporator"]),
            ServiceProvider(name: "TurboService RO", speciality: "Reconditare si reparatie turbine", location: "Timisoara", rating: 4.5, reviewCount: 89, availability: "Luni-Vineri 9-18", priceRange: "$$", category: .specialist, isVerified: false, isFeatured: false, quickServices: ["Reconditionare turbo", "Geometrie variabila", "Diagnoza turbo"]),
            ServiceProvider(name: "Andrei Mecanicul", speciality: "Mecanic auto general, ITP", location: "Iasi", rating: 4.4, reviewCount: 67, availability: "Luni-Sambata 8-16", priceRange: "$", category: .mechanic, isVerified: false, isFeatured: false, quickServices: ["Revizie", "Frane", "Suspensie", "ITP"]),
        ]
    }
}
