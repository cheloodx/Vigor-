import SwiftUI

// MARK: - Multi-Country Configuration View
// Select country and see all adapted laws, prices, insurance, inspection rules
struct MultiCountryConfigView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedCountryId: String = "RO"
    @State private var searchText = ""
    @State private var selectedRegion: EuropeanCountry.EURegion?
    
    private var filteredCountries: [EuropeanCountry] {
        EuropeanCountry.allCountries.filter { country in
            let regionMatch = selectedRegion == nil || country.region == selectedRegion
            let searchMatch = searchText.isEmpty ||
                country.name.localizedCaseInsensitiveContains(searchText) ||
                country.nameLocal.localizedCaseInsensitiveContains(searchText) ||
                country.flag.contains(searchText)
            return regionMatch && searchMatch
        }
    }
    
    private var selectedCountry: EuropeanCountry {
        EuropeanCountry.country(for: selectedCountryId) ?? EuropeanCountry.allCountries[0]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Current country header
                    currentCountryHeader
                    
                    // Search + region filter
                    searchAndFilter
                    
                    // Country grid
                    countryGrid
                    
                    // Country details
                    trafficLaws
                    inspectionCard
                    insuranceCard
                    emergencyCard
                    commonBrandsCard
                    
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
                        Image(systemName: "globe.europe.africa.fill")
                            .foregroundColor(Theme.primary)
                        Text("Configurare Tara")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var currentCountryHeader: some View {
        HStack(spacing: 14) {
            Text(selectedCountry.flag)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(selectedCountry.name)
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(Theme.textPrimary)
                Text(selectedCountry.nameLocal)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                HStack(spacing: 8) {
                    countryChip(selectedCountry.language)
                    countryChip("\(selectedCountry.currencySymbol) \(selectedCountry.currencyCode)")
                }
            }
            Spacer()
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
    }
    
    private func countryChip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .semibold))
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(Theme.primary.opacity(0.1))
            .foregroundColor(Theme.primary)
            .cornerRadius(4)
    }
    
    private var searchAndFilter: some View {
        VStack(spacing: 8) {
            // Search
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").font(.system(size: 12)).foregroundColor(Theme.textMuted)
                TextField("Cauta tara...", text: $searchText)
                    .font(.system(size: 13)).foregroundColor(Theme.textPrimary)
            }
            .padding(10)
            .background(Theme.surfaceBackground)
            .cornerRadius(8)
            
            // Region filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    regionButton(nil, label: "Toate (\(EuropeanCountry.allCountries.count))")
                    regionButton(.eastern, label: "Est")
                    regionButton(.western, label: "Vest")
                    regionButton(.central, label: "Central")
                    regionButton(.northern, label: "Nord")
                    regionButton(.southern, label: "Sud")
                }
            }
        }
    }
    
    private func regionButton(_ region: EuropeanCountry.EURegion?, label: String) -> some View {
        Button(action: { withAnimation { selectedRegion = region } }) {
            Text(label)
                .font(.system(size: 10, weight: selectedRegion == region ? .bold : .regular))
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(selectedRegion == region ? Theme.primary : Theme.surfaceBackground)
                .foregroundColor(selectedRegion == region ? .white : Theme.textSecondary)
                .cornerRadius(6)
        }
    }
    
    private var countryGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),
            GridItem(.flexible()), GridItem(.flexible())
        ], spacing: 8) {
            ForEach(filteredCountries) { country in
                Button(action: { withAnimation { selectedCountryId = country.id } }) {
                    VStack(spacing: 2) {
                        Text(country.flag)
                            .font(.system(size: 22))
                        Text(country.id)
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                            .foregroundColor(selectedCountryId == country.id ? Theme.primary : Theme.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(selectedCountryId == country.id ? Theme.primary.opacity(0.15) : Theme.surfaceBackground)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(selectedCountryId == country.id ? Theme.primary.opacity(0.5) : Color.clear, lineWidth: 1))
                }
            }
        }
        .padding(10)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var trafficLaws: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("LEGI TRAFIC", icon: "car.fill")
            
            HStack(spacing: 12) {
                speedCard("Oras", limit: selectedCountry.speedLimitUrban, icon: "building.2.fill")
                speedCard("Rural", limit: selectedCountry.speedLimitRural, icon: "leaf.fill")
                speedCard("Autostrada", limit: selectedCountry.speedLimitMotorway == 0 ? nil : selectedCountry.speedLimitMotorway, icon: "road.lanes")
            }
            
            HStack(spacing: 16) {
                infoRow("Conducere:", selectedCountry.drivingSide == "stanga" ? "Pe STANGA" : "Pe DREAPTA", color: selectedCountry.drivingSide == "stanga" ? Theme.gaugeYellow : Theme.gaugeGreen)
                infoRow("Alcoolemie max:", selectedCountry.alcoholLimit == 0 ? "0.0‰ (ZERO)" : String(format: "%.1f‰", selectedCountry.alcoholLimit), color: selectedCountry.alcoholLimit == 0 ? Theme.gaugeRed : Theme.gaugeYellow)
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private func speedCard(_ label: String, limit: Int?, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 12)).foregroundColor(Theme.primary)
            if let limit = limit {
                Text("\(limit)")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
            } else {
                Text("∞")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(Theme.gaugeGreen)
            }
            Text("km/h").font(.system(size: 8)).foregroundColor(Theme.textMuted)
            Text(label).font(.system(size: 9, weight: .semibold)).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Theme.surfaceBackground)
        .cornerRadius(8)
    }
    
    private var inspectionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("INSPECTIE TEHNICA", icon: "shield.checkered")
            
            VStack(alignment: .leading, spacing: 4) {
                Text(selectedCountry.inspectionName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Text("Interval: \(selectedCountry.inspectionInterval)")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var insuranceCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("ASIGURARE OBLIGATORIE", icon: "shield.fill")
            
            VStack(alignment: .leading, spacing: 4) {
                Text(selectedCountry.insuranceName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Text("Cost estimat: \(selectedCountry.insuranceMinCost)")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.secondary)
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var emergencyCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("URGENTE", icon: "phone.fill")
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Urgenta").font(.system(size: 10)).foregroundColor(Theme.textMuted)
                    Text(selectedCountry.emergencyNumber)
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(Theme.gaugeRed)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Asistenta rutiera").font(.system(size: 10)).foregroundColor(Theme.textMuted)
                    Text(selectedCountry.roadAssistance)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.primary)
                }
                Spacer()
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var commonBrandsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("MARCI POPULARE IN \(selectedCountry.name.uppercased())", icon: "car.2.fill")
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                ForEach(selectedCountry.commonBrands, id: \.self) { brand in
                    Text(brand)
                        .font(.system(size: 11, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Theme.surfaceBackground)
                        .foregroundColor(Theme.textSecondary)
                        .cornerRadius(6)
                }
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 12)).foregroundColor(Theme.primary)
            Text(title).font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1.2)
        }
    }
    
    private func infoRow(_ label: String, _ value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.system(size: 9)).foregroundColor(Theme.textMuted)
            Text(value).font(.system(size: 12, weight: .bold)).foregroundColor(color)
        }
    }
}
