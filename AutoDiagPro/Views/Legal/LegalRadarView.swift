import SwiftUI

// MARK: - Legal Radar View
// Speed cameras by country, different rules (UK vs Germany), possible fines
struct LegalRadarView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedCountry: String = "Romania"
    @State private var selectedTab: LegalTab = .cameras
    
    enum LegalTab: String, CaseIterable {
        case cameras = "Camere Radar"
        case rules = "Reguli Trafic"
        case fines = "Amenzi"
        case tips = "Sfaturi"
    }
    
    private let countries = ["Romania", "Germania", "Franta", "Italia", "Regatul Unit", "Spania", "Austria", "Elvetia", "Ungaria", "Bulgaria", "Polonia", "Cehia"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    // Country selector
                    countrySelector
                    
                    // Tab selector
                    tabSelector
                    
                    // Content
                    switch selectedTab {
                    case .cameras: camerasContent
                    case .rules: rulesContent
                    case .fines: finesContent
                    case .tips: tipsContent
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
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(Theme.gaugeYellow)
                        Text(localization.t("legal.fines"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Country Selector
    private var countrySelector: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SELECTEAZA TARA")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(countries, id: \.self) { country in
                        Button(action: { withAnimation { selectedCountry = country } }) {
                            Text(countryFlag(country) + " " + country)
                                .font(.system(size: 11, weight: selectedCountry == country ? .bold : .regular))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 7)
                                .background(selectedCountry == country ? Theme.primary : Theme.surfaceBackground)
                                .foregroundColor(selectedCountry == country ? .white : Theme.textSecondary)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 4) {
            ForEach(LegalTab.allCases, id: \.self) { tab in
                Button(action: { withAnimation { selectedTab = tab } }) {
                    Text(tab.rawValue)
                        .font(.system(size: 11, weight: selectedTab == tab ? .bold : .regular))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(selectedTab == tab ? Theme.primary : Theme.surfaceBackground)
                        .foregroundColor(selectedTab == tab ? .white : Theme.textSecondary)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Cameras Content
    private var camerasContent: some View {
        let cameraData = getCameraData(for: selectedCountry)
        return VStack(spacing: 10) {
            // Map placeholder
            VStack(spacing: 8) {
                Image(systemName: "map.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Theme.primary.opacity(0.3))
                Text("Harta camere radar - \(selectedCountry)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                Text("Datele sunt orientative. Verificati intotdeauna semnalizarea rutiera.")
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            
            // Camera types
            ForEach(cameraData, id: \.type) { camera in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(camera.color.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: camera.icon)
                            .font(.system(size: 16))
                            .foregroundColor(camera.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(camera.type)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        Text(camera.description)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("\(camera.count)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(camera.color)
                }
                .padding(12)
                .background(Theme.cardBackground)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Rules Content
    private var rulesContent: some View {
        let rules = getRules(for: selectedCountry)
        return VStack(spacing: 10) {
            ForEach(rules, id: \.category) { rule in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: rule.icon)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.primary)
                        Text(rule.category)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    
                    ForEach(rule.items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 6) {
                            Circle()
                                .fill(Theme.primary)
                                .frame(width: 4, height: 4)
                                .padding(.top, 5)
                            Text(item)
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
                .padding(12)
                .background(Theme.cardBackground)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Fines Content
    private var finesContent: some View {
        let fines = getFines(for: selectedCountry)
        return VStack(spacing: 10) {
            // Warning header
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Theme.gaugeYellow)
                Text("Amenzi orientative \(selectedCountry) - verificati legislatia in vigoare")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.gaugeYellow)
            }
            .padding(10)
            .background(Theme.gaugeYellow.opacity(0.1))
            .cornerRadius(8)
            
            ForEach(fines, id: \.offense) { fine in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(fine.offense)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        Text(fine.details)
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(fine.amount)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.gaugeRed)
                        if !fine.points.isEmpty {
                            Text(fine.points)
                                .font(.system(size: 9))
                                .foregroundColor(Theme.textMuted)
                        }
                    }
                }
                .padding(12)
                .background(Theme.cardBackground)
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Tips Content
    private var tipsContent: some View {
        VStack(spacing: 10) {
            tipCard(icon: "car.fill", title: "Documente obligatorii", tips: [
                "Permis de conducere valid",
                "Certificat de inmatriculare",
                "Polita RCA/asigurare internationala (carte verde)",
                "ITP/MOT valid (conform tarii)",
                "Trusa medicala si triunghi reflectorizant"
            ])
            
            tipCard(icon: "fuelpump.fill", title: "Vinieta/Taxa drum", tips: [
                "Austria: vinieta obligatorie pe autostrazi (10 zile: 9.90 EUR)",
                "Elvetia: vinieta anuala obligatorie (40 CHF)",
                "Ungaria: e-vinieta electronica",
                "Romania: rovinieta obligatorie",
                "Germania: autostrazi gratuite (pentru moment)"
            ])
            
            tipCard(icon: "lightbulb.fill", title: "Echipamente obligatorii", tips: [
                "Franta: etiloptest obligatoriu in masina",
                "Austria: trusa prim-ajutor obligatorie",
                "Italia: vesta reflectorizanta obligatorie",
                "Romania: 2 triunghiuri reflectorizante",
                "Regatul Unit: se conduce pe stanga!"
            ])
        }
    }
    
    private func tipCard(icon: String, title: String, tips: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.primary)
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            ForEach(tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.gaugeGreen)
                        .padding(.top, 1)
                    Text(tip)
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(10)
    }
    
    // MARK: - Helpers
    private func countryFlag(_ country: String) -> String {
        switch country {
        case "Romania": return "🇷🇴"
        case "Germania": return "🇩🇪"
        case "Franta": return "🇫🇷"
        case "Italia": return "🇮🇹"
        case "Regatul Unit": return "🇬🇧"
        case "Spania": return "🇪🇸"
        case "Austria": return "🇦🇹"
        case "Elvetia": return "🇨🇭"
        case "Ungaria": return "🇭🇺"
        case "Bulgaria": return "🇧🇬"
        case "Polonia": return "🇵🇱"
        case "Cehia": return "🇨🇿"
        default: return "🇪🇺"
        }
    }
    
    private func getCameraData(for country: String) -> [CameraInfo] {
        switch country {
        case "Romania":
            return [
                CameraInfo(type: "Camere fixe viteza", icon: "video.fill", color: Theme.gaugeRed, count: 350, description: "Pe autostrazi si drumuri nationale"),
                CameraInfo(type: "Radare mobile", icon: "car.fill", color: Theme.gaugeYellow, count: 120, description: "Echipaje mobile politie"),
                CameraInfo(type: "Semafor rosu", icon: "lightbulb.fill", color: Theme.primary, count: 85, description: "Intersectii monitorizate"),
                CameraInfo(type: "Camere mediu urban", icon: "building.2.fill", color: Color.purple, count: 200, description: "Monitorizare trafic oras"),
            ]
        case "Germania":
            return [
                CameraInfo(type: "Blitzer fix", icon: "video.fill", color: Theme.gaugeRed, count: 4700, description: "Radare fixe pe drumuri"),
                CameraInfo(type: "Mobile Blitzer", icon: "car.fill", color: Theme.gaugeYellow, count: 800, description: "Radare mobile politie"),
                CameraInfo(type: "Abschnittskontrollen", icon: "arrow.left.arrow.right", color: Theme.primary, count: 10, description: "Control viteza medie pe sector"),
                CameraInfo(type: "Rotlicht-Blitzer", icon: "lightbulb.fill", color: Color.purple, count: 1200, description: "Camere semafor rosu"),
            ]
        case "Regatul Unit":
            return [
                CameraInfo(type: "Gatso cameras", icon: "video.fill", color: Theme.gaugeRed, count: 2400, description: "Camere fixe viteza"),
                CameraInfo(type: "SPECS", icon: "arrow.left.arrow.right", color: Theme.gaugeYellow, count: 350, description: "Control viteza medie"),
                CameraInfo(type: "ANPR cameras", icon: "camera.fill", color: Theme.primary, count: 11000, description: "Recunoastere numar inmatriculare"),
                CameraInfo(type: "Red light cameras", icon: "lightbulb.fill", color: Color.purple, count: 700, description: "Camere semafor rosu"),
            ]
        default:
            return [
                CameraInfo(type: "Camere fixe", icon: "video.fill", color: Theme.gaugeRed, count: 500, description: "Radare fixe pe drumuri"),
                CameraInfo(type: "Radare mobile", icon: "car.fill", color: Theme.gaugeYellow, count: 200, description: "Echipaje mobile"),
                CameraInfo(type: "Camere semafor", icon: "lightbulb.fill", color: Theme.primary, count: 150, description: "Intersectii monitorizate"),
            ]
        }
    }
    
    private func getRules(for country: String) -> [TrafficRuleGroup] {
        switch country {
        case "Romania":
            return [
                TrafficRuleGroup(category: "Limite viteza", icon: "speedometer", items: ["Localitate: 50 km/h", "Drum national: 90-100 km/h", "Autostrada: 130 km/h", "Drumuri expres: 120 km/h"]),
                TrafficRuleGroup(category: "Alcool", icon: "drop.fill", items: ["Limita: 0.00‰ (zero toleranta)", "Peste 0.80‰: infractiune penala", "Sanctiune: suspendare permis + amenda"]),
                TrafficRuleGroup(category: "Faruri", icon: "light.max", items: ["Obligatorii ziua in afara localitatii", "Lumini de zi sau faza scurta"]),
                TrafficRuleGroup(category: "Centura", icon: "person.fill", items: ["Obligatorie pe toate locurile", "Copii sub 12 ani: scaun auto special"]),
            ]
        case "Germania":
            return [
                TrafficRuleGroup(category: "Limite viteza", icon: "speedometer", items: ["Localitate: 50 km/h", "Drum national: 100 km/h", "Autostrada: recomandat 130 km/h (fara limita pe unele sectoare)"]),
                TrafficRuleGroup(category: "Alcool", icon: "drop.fill", items: ["Limita: 0.50‰", "Soferi incepatori (sub 21 ani): 0.00‰", "Peste 1.10‰: infractiune penala"]),
                TrafficRuleGroup(category: "Umweltzone", icon: "leaf.fill", items: ["Zona de mediu in multe orase", "Necesita vinieta ecologica (Umweltplakette)", "Fara vinieta: amenda 80 EUR"]),
            ]
        case "Regatul Unit":
            return [
                TrafficRuleGroup(category: "Limite viteza", icon: "speedometer", items: ["Localitate: 30 mph (48 km/h)", "Drum national: 60 mph (96 km/h)", "Autostrada: 70 mph (112 km/h)", "ATENTIE: Se conduce pe STANGA!"]),
                TrafficRuleGroup(category: "Alcool", icon: "drop.fill", items: ["Anglia/Tara Galilor: 0.80‰", "Scotia: 0.50‰"]),
                TrafficRuleGroup(category: "Congestion Charge", icon: "sterlingsign.circle", items: ["Londra: taxa congestie 15 GBP/zi", "ULEZ: taxa emisii 12.50 GBP/zi", "Alte orase au clean air zones"]),
            ]
        default:
            return [
                TrafficRuleGroup(category: "Limite viteza", icon: "speedometer", items: ["Localitate: 50 km/h", "In afara localitatii: 90-100 km/h", "Autostrada: 110-130 km/h"]),
                TrafficRuleGroup(category: "Alcool", icon: "drop.fill", items: ["Verificati limita specifica tarii", "In general: 0.50‰ in Europa de Vest"]),
            ]
        }
    }
    
    private func getFines(for country: String) -> [FineInfo] {
        switch country {
        case "Romania":
            return [
                FineInfo(offense: "Depasire viteza 10-20 km/h", details: "In localitate", amount: "580-725 RON", points: "2 puncte"),
                FineInfo(offense: "Depasire viteza 21-30 km/h", details: "In localitate", amount: "725-870 RON", points: "3 puncte"),
                FineInfo(offense: "Depasire viteza 31-40 km/h", details: "In localitate", amount: "870-1160 RON", points: "4 puncte"),
                FineInfo(offense: "Depasire viteza >50 km/h", details: "Oriunde", amount: "1305-2900 RON", points: "6 puncte + suspendare"),
                FineInfo(offense: "Alcool la volan", details: "0.01-0.80‰", amount: "1305-2900 RON", points: "Suspendare 90 zile"),
                FineInfo(offense: "Fara centura", details: "Sofer sau pasager", amount: "580-725 RON", points: "2 puncte"),
                FineInfo(offense: "Telefon la volan", details: "Fara handsfree", amount: "580-725 RON", points: "3 puncte"),
                FineInfo(offense: "Trecere pe rosu", details: "Semafor", amount: "870-1160 RON", points: "4 puncte"),
            ]
        case "Germania":
            return [
                FineInfo(offense: "Depasire viteza 10 km/h", details: "In localitate", amount: "30 EUR", points: ""),
                FineInfo(offense: "Depasire viteza 21-25 km/h", details: "In localitate", amount: "115 EUR", points: "1 punct Flensburg"),
                FineInfo(offense: "Depasire viteza 31-40 km/h", details: "In localitate", amount: "260 EUR", points: "2 puncte + 1 luna suspendare"),
                FineInfo(offense: "Depasire viteza >70 km/h", details: "In localitate", amount: "800 EUR", points: "2 puncte + 3 luni suspendare"),
                FineInfo(offense: "Alcool 0.50-1.09‰", details: "Prima abatere", amount: "500 EUR", points: "2 puncte + 1 luna suspendare"),
                FineInfo(offense: "Telefon la volan", details: "Fara handsfree", amount: "100 EUR", points: "1 punct"),
                FineInfo(offense: "Fara Umweltplakette", details: "In zona de mediu", amount: "80 EUR", points: ""),
            ]
        case "Regatul Unit":
            return [
                FineInfo(offense: "Depasire viteza", details: "Minima", amount: "100 GBP", points: "3 puncte"),
                FineInfo(offense: "Depasire viteza grava", details: "Peste limita cu mult", amount: "2500 GBP", points: "6 puncte + ban"),
                FineInfo(offense: "Alcool la volan", details: "Peste limita", amount: "Nelimitat", points: "Inchisoare posibila"),
                FineInfo(offense: "Telefon la volan", details: "Fara handsfree", amount: "200 GBP", points: "6 puncte"),
                FineInfo(offense: "Fara centura", details: "Sofer sau pasager", amount: "500 GBP", points: ""),
                FineInfo(offense: "Congestion Charge", details: "Londra, fara plata", amount: "160 GBP", points: ""),
            ]
        default:
            return [
                FineInfo(offense: "Depasire viteza minora", details: "10-20 km/h", amount: "50-150 EUR", points: ""),
                FineInfo(offense: "Depasire viteza grava", details: "Peste 40 km/h", amount: "300-1000 EUR", points: "Suspendare posibila"),
                FineInfo(offense: "Alcool la volan", details: "Peste limita", amount: "500-5000 EUR", points: "Suspendare"),
            ]
        }
    }
}

// MARK: - Models
struct CameraInfo {
    let type: String
    let icon: String
    let color: Color
    let count: Int
    let description: String
}

struct TrafficRuleGroup {
    let category: String
    let icon: String
    let items: [String]
}

struct FineInfo {
    let offense: String
    let details: String
    let amount: String
    let points: String
}
