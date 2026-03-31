import SwiftUI

// MARK: - Apple Watch Companion App Preview
// Shows what the watch app would look like + setup instructions
struct WatchPreviewView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedComplication = 0
    @State private var animateScore = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Watch preview
                watchFacePreview
                
                // Complications
                complicationPicker
                
                // Features list
                watchFeatures
                
                // Setup instructions
                setupInstructions
                
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
                    Image(systemName: "applewatch")
                        .foregroundColor(Theme.primary)
                    Text("Apple Watch")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .onAppear { withAnimation(.easeOut(duration: 1.0)) { animateScore = true } }
    }
    
    // MARK: - Watch Face Preview
    private var watchFacePreview: some View {
        VStack(spacing: 12) {
            Text("PREVIEW APPLE WATCH")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ZStack {
                // Watch body
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .frame(width: 180, height: 220)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color(red: 0.3, green: 0.3, blue: 0.3), lineWidth: 2)
                    )
                
                // Watch screen
                VStack(spacing: 6) {
                    // Health score ring
                    ZStack {
                        Circle()
                            .stroke(Theme.primary.opacity(0.2), lineWidth: 6)
                            .frame(width: 70, height: 70)
                        
                        Circle()
                            .trim(from: 0, to: animateScore ? 0.78 : 0)
                            .stroke(Theme.gaugeGreen, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 70, height: 70)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 0) {
                            Text("78")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text("Scor")
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Vehicle name
                    Text(vehicleManager.currentVehicle.shortName)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Quick stats
                    HStack(spacing: 12) {
                        watchStat(icon: "thermometer.medium", value: "88°C", color: Theme.gaugeGreen)
                        watchStat(icon: "bolt.fill", value: "12.4V", color: Theme.gaugeYellow)
                    }
                    
                    // Alarm indicator
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Theme.gaugeYellow)
                            .frame(width: 5, height: 5)
                        Text("Ulei motor - 500km")
                            .font(.system(size: 7))
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 150, height: 190)
            }
            
            // Crown
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                .frame(width: 6, height: 20)
                .offset(x: 93, y: -70)
        }
        .padding(20)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Watch Stats
    private func watchStat(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 8))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Complication Picker
    private var complicationPicker: some View {
        VStack(spacing: 8) {
            Text("COMPLICATIONS")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    complicationCard(title: "Scor Sanatate", icon: "heart.square.fill", color: Theme.gaugeGreen, index: 0)
                    complicationCard(title: "Temp. Motor", icon: "thermometer.medium", color: Theme.primary, index: 1)
                    complicationCard(title: "Baterie", icon: "bolt.fill", color: Theme.gaugeYellow, index: 2)
                    complicationCard(title: "Alarma Service", icon: "bell.badge.fill", color: Theme.gaugeRed, index: 3)
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func complicationCard(title: String, icon: String, color: Color, index: Int) -> some View {
        Button(action: { selectedComplication = index }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(selectedComplication == index ? color : Theme.textMuted)
                Text(title)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(selectedComplication == index ? Theme.textPrimary : Theme.textMuted)
            }
            .frame(width: 80, height: 60)
            .background(selectedComplication == index ? color.opacity(0.15) : Theme.surfaceBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedComplication == index ? color.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
    }
    
    // MARK: - Watch Features
    private var watchFeatures: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("FUNCTII WATCH")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            featureRow(icon: "heart.square.fill", title: "Scor Sanatate", description: "Vede scorul 0-100 pe ceas", color: Theme.gaugeGreen)
            featureRow(icon: "bell.badge.fill", title: "Alarme Service", description: "Notificari cand se apropie revizia", color: Theme.gaugeYellow)
            featureRow(icon: "antenna.radiowaves.left.and.right", title: "Date OBD2", description: "Temperatura, tensiune in timp real", color: Theme.primary)
            featureRow(icon: "speedometer", title: "Consum Instant", description: "L/100km pe ecranul ceasului", color: Color(red: 0.0, green: 0.8, blue: 0.6))
            featureRow(icon: "exclamationmark.triangle.fill", title: "Alerte DTC", description: "Erori motor direct pe ceas", color: Theme.gaugeRed)
            featureRow(icon: "location.fill", title: "Parcare", description: "Salveaza locatia parcarii", color: Color.purple)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func featureRow(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
                .frame(width: 28, height: 28)
                .background(color.opacity(0.15))
                .cornerRadius(7)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                Text(description)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
            }
            Spacer()
        }
    }
    
    // MARK: - Setup Instructions
    private var setupInstructions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CONFIGURARE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            Text("Pentru a utiliza pe Apple Watch:")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            stepRow(number: 1, text: "Deschide Watch app pe iPhone")
            stepRow(number: 2, text: "Gaseste AutoDiag Pro in lista")
            stepRow(number: 3, text: "Activeaza 'Show on Apple Watch'")
            stepRow(number: 4, text: "Selecteaza complicatia dorita")
            
            Text("Nota: Necesita Apple Watch Series 5+ cu watchOS 9+")
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
                .padding(.top, 4)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func stepRow(number: Int, text: String) -> some View {
        HStack(spacing: 10) {
            Text("\(number)")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Theme.primary)
                .clipShape(Circle())
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
    }
}
