import SwiftUI

// MARK: - CarPlay Preview View
// Shows what CarPlay integration would look like + setup info
struct CarPlayPreviewView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedScreen = 0
    @State private var animateGauges = false
    
    private let screens = ["Dashboard", "Gauges", "Alarme", "Navigatie"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // CarPlay screen preview
                carPlayScreen
                
                // Screen selector
                screenSelector
                
                // Features
                carPlayFeatures
                
                // Setup
                setupInfo
                
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
                    Image(systemName: "car.fill")
                        .foregroundColor(Theme.primary)
                    Text("CarPlay")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .onAppear { withAnimation(.easeOut(duration: 1.2)) { animateGauges = true } }
    }
    
    // MARK: - CarPlay Screen
    private var carPlayScreen: some View {
        VStack(spacing: 8) {
            Text("PREVIEW CARPLAY")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            // CarPlay display
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black)
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 2)
                    )
                
                Group {
                    switch selectedScreen {
                    case 0: dashboardScreen
                    case 1: gaugesScreen
                    case 2: alarmsScreen
                    default: navigationScreen
                    }
                }
                .padding(12)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Dashboard Screen
    private var dashboardScreen: some View {
        VStack(spacing: 8) {
            HStack {
                Text("AutoDiag Pro")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Theme.primary)
                Spacer()
                Text(vehicleManager.currentVehicle.shortName)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 16) {
                // Health score
                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .stroke(Theme.gaugeGreen.opacity(0.2), lineWidth: 5)
                            .frame(width: 60, height: 60)
                        Circle()
                            .trim(from: 0, to: animateGauges ? 0.78 : 0)
                            .stroke(Theme.gaugeGreen, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                        Text("78")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                    Text("Sanatate")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(.gray)
                }
                
                // Quick stats grid
                VStack(spacing: 6) {
                    HStack(spacing: 10) {
                        carPlayStat(label: "Motor", value: "88°C", color: Theme.gaugeGreen)
                        carPlayStat(label: "Baterie", value: "12.4V", color: Theme.gaugeYellow)
                    }
                    HStack(spacing: 10) {
                        carPlayStat(label: "RPM", value: "2,450", color: Theme.primary)
                        carPlayStat(label: "Consum", value: "7.2L", color: Color(red: 0.0, green: 0.8, blue: 0.6))
                    }
                }
            }
            
            // Alert bar
            HStack(spacing: 6) {
                Circle()
                    .fill(Theme.gaugeYellow)
                    .frame(width: 5, height: 5)
                Text("Urmatorul service: Ulei motor in 500km")
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
    
    // MARK: - Gauges Screen
    private var gaugesScreen: some View {
        HStack(spacing: 14) {
            miniGauge(title: "RPM", value: animateGauges ? 0.45 : 0, text: "2,450", color: Theme.primary)
            miniGauge(title: "km/h", value: animateGauges ? 0.6 : 0, text: "72", color: Theme.gaugeGreen)
            miniGauge(title: "°C", value: animateGauges ? 0.88 : 0, text: "88", color: Theme.gaugeYellow)
            miniGauge(title: "V", value: animateGauges ? 0.85 : 0, text: "12.4", color: Color(red: 0.0, green: 0.8, blue: 0.6))
        }
    }
    
    private func miniGauge(title: String, value: CGFloat, text: String, color: Color) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 5)
                    .frame(width: 55, height: 55)
                Circle()
                    .trim(from: 0, to: value)
                    .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 55, height: 55)
                    .rotationEffect(.degrees(-90))
                Text(text)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.gray)
        }
    }
    
    // MARK: - Alarms Screen
    private var alarmsScreen: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Alarme Service")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Theme.primary)
            
            alarmRow(name: "Ulei Motor", status: "in 500km", color: Theme.gaugeYellow)
            alarmRow(name: "Filtre Aer", status: "OK - 3,200km", color: Theme.gaugeGreen)
            alarmRow(name: "Frane Fata", status: "DEPASIT", color: Theme.gaugeRed)
            alarmRow(name: "Antigel", status: "in 2 luni", color: Theme.gaugeYellow)
        }
    }
    
    private func alarmRow(name: String, status: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 5, height: 5)
            Text(name)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            Text(status)
                .font(.system(size: 9))
                .foregroundColor(color)
        }
    }
    
    // MARK: - Navigation Screen
    private var navigationScreen: some View {
        VStack(spacing: 8) {
            Text("Navigatie catre Service")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Theme.primary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                    .frame(height: 120)
                
                VStack(spacing: 4) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 30))
                        .foregroundColor(Theme.primary.opacity(0.5))
                    Text("Service Auto Rapid")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                    Text("2.3 km - 5 min")
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private func carPlayStat(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 7, weight: .semibold))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Screen Selector
    private var screenSelector: some View {
        HStack(spacing: 6) {
            ForEach(0..<screens.count, id: \.self) { index in
                Button(action: { withAnimation { selectedScreen = index } }) {
                    Text(screens[index])
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(selectedScreen == index ? .white : Theme.textMuted)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedScreen == index ? Theme.primary : Theme.surfaceBackground)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Features
    private var carPlayFeatures: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("FUNCTII CARPLAY")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            featureRow(icon: "gauge.medium", title: "Dashboard Live", desc: "Toate datele OBD2 pe ecranul masinii")
            featureRow(icon: "bell.badge.fill", title: "Alarme Service", desc: "Notificari intretinere in timp real")
            featureRow(icon: "map.fill", title: "Navigatie Service", desc: "Directii catre cel mai apropiat service")
            featureRow(icon: "mic.fill", title: "Comenzi Vocale", desc: "\"Hey Siri, ce scor are masina?\"")
            featureRow(icon: "exclamationmark.triangle.fill", title: "Alerte Motor", desc: "Avertizari DTC instant pe ecran")
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func featureRow(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(Theme.primary)
                .frame(width: 26, height: 26)
                .background(Theme.primary.opacity(0.15))
                .cornerRadius(7)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                Text(desc)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
            }
            Spacer()
        }
    }
    
    // MARK: - Setup Info
    private var setupInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("COMPATIBILITATE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            Text("CarPlay necesita un vehicul compatibil cu Apple CarPlay sau un adaptor aftermarket. Conecteaza iPhone-ul prin USB sau wireless (daca masina suporta).")
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
            
            Text("Necesita: iOS 16+, iPhone 8 sau mai nou")
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
                .padding(.top, 2)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
}
