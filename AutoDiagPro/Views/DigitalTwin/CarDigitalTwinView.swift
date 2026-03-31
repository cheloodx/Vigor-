import SwiftUI

// MARK: - Car Digital Twin View
// Complete digital representation of the vehicle with all data
struct CarDigitalTwinView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedSystem: CarSystem = .engine
    @State private var isLoading = true
    
    enum CarSystem: String, CaseIterable {
        case engine = "Motor"
        case brakes = "Frane"
        case suspension = "Suspensie"
        case electrical = "Electric"
        case cooling = "Racire"
        case exhaust = "Evacuare"
        
        var icon: String {
            switch self {
            case .engine: return "gear"
            case .brakes: return "circle.circle"
            case .suspension: return "arrow.up.arrow.down"
            case .electrical: return "bolt.fill"
            case .cooling: return "snowflake"
            case .exhaust: return "wind"
            }
        }
        
        var health: Int {
            switch self {
            case .engine: return 82
            case .brakes: return 45
            case .suspension: return 88
            case .electrical: return 91
            case .cooling: return 76
            case .exhaust: return 68
            }
        }
        
        var components: [TwinComponent] {
            switch self {
            case .engine: return [
                TwinComponent(name: "Bloc Motor", health: 90, status: "Normal", lastCheck: "15.01.2024"),
                TwinComponent(name: "Turbosuflanta", health: 78, status: "Uzura medie", lastCheck: "15.01.2024"),
                TwinComponent(name: "Curea Distributie", health: 65, status: "De schimbat curand", lastCheck: "20.09.2023"),
                TwinComponent(name: "Pompa Ulei", health: 88, status: "Normal", lastCheck: "15.01.2024"),
                TwinComponent(name: "Injectoare", health: 82, status: "Normal", lastCheck: "15.01.2024"),
            ]
            case .brakes: return [
                TwinComponent(name: "Placute Fata", health: 35, status: "Uzura critica", lastCheck: "10.02.2024"),
                TwinComponent(name: "Placute Spate", health: 55, status: "Uzura moderata", lastCheck: "10.02.2024"),
                TwinComponent(name: "Discuri Fata", health: 62, status: "Acceptabile", lastCheck: "10.02.2024"),
                TwinComponent(name: "Discuri Spate", health: 70, status: "Normal", lastCheck: "10.02.2024"),
                TwinComponent(name: "Lichid Frana", health: 50, status: "De inlocuit", lastCheck: "01.06.2023"),
            ]
            case .suspension: return [
                TwinComponent(name: "Amortizoare Fata", health: 85, status: "Normal", lastCheck: "05.11.2023"),
                TwinComponent(name: "Amortizoare Spate", health: 90, status: "Normal", lastCheck: "05.11.2023"),
                TwinComponent(name: "Arcuri", health: 92, status: "Excelent", lastCheck: "05.11.2023"),
                TwinComponent(name: "Bielete Stabilizare", health: 78, status: "Uzura usoara", lastCheck: "05.11.2023"),
            ]
            case .electrical: return [
                TwinComponent(name: "Baterie", health: 72, status: "Capacitate scazuta", lastCheck: "20.12.2023"),
                TwinComponent(name: "Alternator", health: 95, status: "Excelent", lastCheck: "15.01.2024"),
                TwinComponent(name: "Demaror", health: 88, status: "Normal", lastCheck: "15.01.2024"),
                TwinComponent(name: "Instalatie Electrica", health: 93, status: "Normal", lastCheck: "15.01.2024"),
            ]
            case .cooling: return [
                TwinComponent(name: "Radiator", health: 80, status: "Normal", lastCheck: "10.10.2023"),
                TwinComponent(name: "Termostat", health: 70, status: "Uzura medie", lastCheck: "10.10.2023"),
                TwinComponent(name: "Pompa Apa", health: 75, status: "Acceptabil", lastCheck: "10.10.2023"),
                TwinComponent(name: "Lichid Racire", health: 60, status: "De verificat", lastCheck: "01.04.2023"),
            ]
            case .exhaust: return [
                TwinComponent(name: "Catalizator", health: 72, status: "Uzura moderata", lastCheck: "15.01.2024"),
                TwinComponent(name: "Filtru Particule DPF", health: 65, status: "Regenerare necesara", lastCheck: "15.01.2024"),
                TwinComponent(name: "Sonde Lambda", health: 80, status: "Normal", lastCheck: "15.01.2024"),
                TwinComponent(name: "Toba Esapament", health: 85, status: "Normal", lastCheck: "20.09.2023"),
            ]
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Vehicle identity card
                    identityCard
                    
                    // 3D-style car visualization
                    carVisualization
                    
                    // System selector
                    systemSelector
                    
                    // System details
                    systemDetailCard
                    
                    // Component list
                    componentsList
                    
                    // Overall twin stats
                    twinStats
                    
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
                        Image(systemName: "cube.fill")
                            .foregroundColor(Theme.primary)
                        Text(localization.t("feature.digital_twin"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation { isLoading = false }
                }
            }
        }
    }
    
    private var identityCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(vehicleManager.currentVehicle.displayName)
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(Theme.textPrimary)
                    Text("An: \(vehicleManager.currentVehicle.year) | \(vehicleManager.currentVehicle.mileage) km")
                        .font(.system(size: 11)).foregroundColor(Theme.textSecondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("TWIN ID")
                        .font(.system(size: 8, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1)
                    Text(String(vehicleManager.currentVehicle.vin.prefix(8).isEmpty ? "AUTO-001" : vehicleManager.currentVehicle.vin.prefix(8)))
                        .font(.system(size: 10, design: .monospaced)).foregroundColor(Theme.primary)
                }
            }
            
            // Last sync
            HStack(spacing: 6) {
                Circle().fill(Theme.gaugeGreen).frame(width: 6, height: 6)
                Text("Sincronizat: \(Date(), formatter: twinDateFormatter)")
                    .font(.system(size: 9)).foregroundColor(Theme.textMuted)
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var carVisualization: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(LinearGradient(colors: [Color(red: 0.04, green: 0.06, blue: 0.10), Color(red: 0.06, green: 0.09, blue: 0.15)], startPoint: .top, endPoint: .bottom))
                .frame(height: 180)
            
            // Car outline with system highlights
            ZStack {
                // Car body outline
                Image(systemName: "car.side.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(red: 0.15, green: 0.2, blue: 0.3))
                
                // System highlight indicators
                ForEach(CarSystem.allCases, id: \.self) { system in
                    let offset = systemOffset(system)
                    Circle()
                        .fill(healthColor(system.health).opacity(system == selectedSystem ? 0.8 : 0.3))
                        .frame(width: system == selectedSystem ? 16 : 10, height: system == selectedSystem ? 16 : 10)
                        .overlay(
                            Circle().stroke(healthColor(system.health), lineWidth: system == selectedSystem ? 2 : 0)
                                .frame(width: system == selectedSystem ? 22 : 10)
                        )
                        .offset(x: offset.0, y: offset.1)
                }
            }
            
            // Overall health badge
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Text("Sanatate Generala")
                            .font(.system(size: 8, weight: .bold)).foregroundColor(Theme.textMuted)
                        Text("\(overallHealth)%")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(healthColor(overallHealth))
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    .padding(8)
                }
            }
        }
        .cornerRadius(14)
    }
    
    private var systemSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(CarSystem.allCases, id: \.self) { system in
                    Button(action: { withAnimation { selectedSystem = system } }) {
                        VStack(spacing: 4) {
                            Image(systemName: system.icon)
                                .font(.system(size: 14))
                            Text(system.rawValue)
                                .font(.system(size: 9, weight: .semibold))
                            Text("\(system.health)%")
                                .font(.system(size: 10, weight: .black, design: .rounded))
                                .foregroundColor(healthColor(system.health))
                        }
                        .frame(width: 65)
                        .padding(.vertical, 8)
                        .background(selectedSystem == system ? Theme.primary.opacity(0.15) : Theme.surfaceBackground)
                        .foregroundColor(selectedSystem == system ? Theme.primary : Theme.textSecondary)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(selectedSystem == system ? Theme.primary.opacity(0.5) : Color.clear, lineWidth: 1))
                    }
                }
            }
        }
    }
    
    private var systemDetailCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: selectedSystem.icon).font(.system(size: 16)).foregroundColor(Theme.primary)
                Text(selectedSystem.rawValue).font(.system(size: 15, weight: .bold)).foregroundColor(Theme.textPrimary)
                Spacer()
                Text("\(selectedSystem.health)%")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(healthColor(selectedSystem.health))
            }
            
            // Health bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                    RoundedRectangle(cornerRadius: 4).fill(healthColor(selectedSystem.health))
                        .frame(width: geo.size.width * CGFloat(selectedSystem.health) / 100.0)
                }
            }
            .frame(height: 8)
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var componentsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("COMPONENTE").font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1.2)
            
            ForEach(selectedSystem.components, id: \.name) { comp in
                HStack {
                    Circle().fill(healthColor(comp.health)).frame(width: 8, height: 8)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(comp.name).font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.textPrimary)
                        Text(comp.status).font(.system(size: 10)).foregroundColor(Theme.textMuted)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("\(comp.health)%").font(.system(size: 12, weight: .bold, design: .rounded)).foregroundColor(healthColor(comp.health))
                        Text(comp.lastCheck).font(.system(size: 8)).foregroundColor(Theme.textMuted)
                    }
                }
                .padding(10).background(Theme.surfaceBackground).cornerRadius(8)
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var twinStats: some View {
        HStack(spacing: 12) {
            twinStat(title: "Componente", value: "32", icon: "gearshape.2.fill")
            twinStat(title: "Monitorizate", value: "28", icon: "eye.fill")
            twinStat(title: "Alerte", value: "3", icon: "bell.fill")
        }
    }
    
    private func twinStat(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 14)).foregroundColor(Theme.primary)
            Text(value).font(.system(size: 18, weight: .black, design: .rounded)).foregroundColor(Theme.textPrimary)
            Text(title).font(.system(size: 9)).foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 12)
        .background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var overallHealth: Int {
        let systems = CarSystem.allCases
        return systems.reduce(0) { $0 + $1.health } / systems.count
    }
    
    private func healthColor(_ health: Int) -> Color {
        if health >= 80 { return Theme.gaugeGreen }
        if health >= 50 { return Theme.gaugeYellow }
        return Theme.gaugeRed
    }
    
    private func systemOffset(_ system: CarSystem) -> (CGFloat, CGFloat) {
        switch system {
        case .engine: return (-25, -10)
        case .brakes: return (35, 15)
        case .suspension: return (-35, 15)
        case .electrical: return (0, -25)
        case .cooling: return (-15, 5)
        case .exhaust: return (40, 5)
        }
    }
    
    private var twinDateFormatter: DateFormatter {
        let f = DateFormatter(); f.dateFormat = "dd.MM.yyyy HH:mm"; return f
    }
}

struct TwinComponent {
    let name: String; let health: Int; let status: String; let lastCheck: String
}
