import SwiftUI

// MARK: - Onboarding View
// Welcome slides + country selection on first launch
struct OnboardingView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @EnvironmentObject var appState: AppState
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    @State private var selectedCountry: String = "Romania"
    @State private var selectedLanguage: String = "ro"
    @State private var animateSlide = false
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "car.fill",
            title: "Bun venit la AutoDiag Pro",
            subtitle: "Aplicatia #1 de diagnostic auto in Europa",
            description: "Diagnosticheaza-ti masina cu AI, OBD2 live data, istoric complet si mult mai mult.",
            color: Color(red: 0.0, green: 0.75, blue: 1.0),
            features: ["40+ functii de diagnostic", "44 tari europene", "AI Mecanic inteligent"]
        ),
        OnboardingPage(
            icon: "antenna.radiowaves.left.and.right",
            title: "OBD2 Live Data",
            subtitle: "Conecteaza-te la masina ta",
            description: "Vezi date live de la motor: turatie, viteza, temperatura, consum. Conecteaza un adaptor OBD2 Bluetooth.",
            color: Color(red: 0.0, green: 0.85, blue: 0.45),
            features: ["6 gauge-uri animate", "Consum real L/100km", "Istoric date live"]
        ),
        OnboardingPage(
            icon: "brain",
            title: "AI Mecanic Virtual",
            subtitle: "Intreaba orice despre masina ta",
            description: "Chat-ul AI stie marca, modelul si istoricul masinii tale. Primesti diagnostic instant si estimari de cost.",
            color: Color(red: 0.6, green: 0.2, blue: 0.9),
            features: ["Diagnostic vocal", "Predictor defectiuni", "Decodor erori DTC"]
        ),
        OnboardingPage(
            icon: "globe.americas.fill",
            title: "Adaptat pentru Europa",
            subtitle: "Selecteaza tara ta",
            description: "Legi, amenzi, camere radar, asigurari, inspectii tehnice — totul adaptat pentru tara ta.",
            color: Color(red: 0.0, green: 0.5, blue: 0.9),
            features: ["Legi trafic pe tara", "Preturi in moneda locala", "Service-uri verificate"]
        )
    ]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button(action: { skipToEnd() }) {
                            Text("Sari peste")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Theme.textMuted)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                    }
                }
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        pageView(pages[index], isLast: index == pages.count - 1)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Page indicator + button
                VStack(spacing: 20) {
                    // Page dots
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? pages[currentPage].color : Theme.textMuted.opacity(0.3))
                                .frame(width: index == currentPage ? 10 : 6, height: index == currentPage ? 10 : 6)
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    
                    // Next / Get Started button
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation { currentPage += 1 }
                        } else {
                            completeOnboarding()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(currentPage < pages.count - 1 ? "Continua" : "Incepe Acum")
                                .font(.system(size: 16, weight: .bold))
                            Image(systemName: currentPage < pages.count - 1 ? "arrow.right" : "checkmark")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(pages[currentPage].color)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear { withAnimation(.easeOut(duration: 0.6)) { animateSlide = true } }
    }
    
    // MARK: - Page View
    private func pageView(_ page: OnboardingPage, isLast: Bool) -> some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.15))
                    .frame(width: 120, height: 120)
                Circle()
                    .fill(page.color.opacity(0.08))
                    .frame(width: 160, height: 160)
                Image(systemName: page.icon)
                    .font(.system(size: 50))
                    .foregroundColor(page.color)
            }
            .scaleEffect(animateSlide ? 1.0 : 0.5)
            .opacity(animateSlide ? 1.0 : 0.0)
            
            // Title
            Text(page.title)
                .font(.system(size: 24, weight: .black))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(page.subtitle)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(page.color)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.system(size: 13))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            // Features list
            VStack(alignment: .leading, spacing: 8) {
                ForEach(page.features, id: \.self) { feature in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(page.color)
                        Text(feature)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .padding(.top, 8)
            
            // Country selector on last page
            if isLast {
                countrySelector
                    .padding(.top, 8)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Country Selector
    private var countrySelector: some View {
        VStack(spacing: 8) {
            Text("SELECTEAZA TARA")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(topCountries, id: \.name) { country in
                        Button(action: {
                            selectedCountry = country.name
                            selectedLanguage = country.langCode
                        }) {
                            VStack(spacing: 4) {
                                Text(country.flag)
                                    .font(.system(size: 28))
                                Text(country.name)
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundColor(selectedCountry == country.name ? .white : Theme.textSecondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedCountry == country.name ? pages[3].color : Theme.surfaceBackground)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Top Countries
    private var topCountries: [OnboardingCountry] {
        [
            OnboardingCountry(name: "Romania", flag: "\u{1F1F7}\u{1F1F4}", langCode: "ro"),
            OnboardingCountry(name: "Italia", flag: "\u{1F1EE}\u{1F1F9}", langCode: "it"),
            OnboardingCountry(name: "Germania", flag: "\u{1F1E9}\u{1F1EA}", langCode: "de"),
            OnboardingCountry(name: "Franta", flag: "\u{1F1EB}\u{1F1F7}", langCode: "fr"),
            OnboardingCountry(name: "UK", flag: "\u{1F1EC}\u{1F1E7}", langCode: "en"),
            OnboardingCountry(name: "Spania", flag: "\u{1F1EA}\u{1F1F8}", langCode: "es"),
            OnboardingCountry(name: "Polonia", flag: "\u{1F1F5}\u{1F1F1}", langCode: "pl"),
            OnboardingCountry(name: "Bulgaria", flag: "\u{1F1E7}\u{1F1EC}", langCode: "bg"),
            OnboardingCountry(name: "Ucraina", flag: "\u{1F1FA}\u{1F1E6}", langCode: "uk"),
            OnboardingCountry(name: "Ungaria", flag: "\u{1F1ED}\u{1F1FA}", langCode: "hu"),
            OnboardingCountry(name: "Austria", flag: "\u{1F1E6}\u{1F1F9}", langCode: "de"),
            OnboardingCountry(name: "Belgia", flag: "\u{1F1E7}\u{1F1EA}", langCode: "nl"),
        ]
    }
    
    // MARK: - Actions
    private func skipToEnd() {
        withAnimation { currentPage = pages.count - 1 }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(selectedCountry, forKey: "selectedCountry")
        UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        withAnimation(.easeInOut(duration: 0.3)) {
            isPresented = false
        }
    }
}

// MARK: - Models
struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    let color: Color
    let features: [String]
}

struct OnboardingCountry {
    let name: String
    let flag: String
    let langCode: String
}
