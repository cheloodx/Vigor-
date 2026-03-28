import SwiftUI

// MARK: - Widget-Ready Health View
// This provides the widget UI components that can be used by a WidgetKit extension
// To add a real widget: File > New > Target > Widget Extension in Xcode

struct HealthWidgetPreview: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var healthScore: Int = 78
    @State private var animateRing = false
    
    var scoreColor: Color {
        if healthScore >= 80 { return Theme.gaugeGreen }
        if healthScore >= 50 { return Theme.gaugeYellow }
        return Theme.gaugeRed
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Widget preview header
                    Text("PREVIEW WIDGET IOS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1.5)
                    
                    // Small widget
                    VStack(spacing: 4) {
                        Text("Widget Mic (2x2)")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textMuted)
                        
                        smallWidgetPreview
                            .frame(width: 155, height: 155)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.3), radius: 10)
                    }
                    
                    // Medium widget
                    VStack(spacing: 4) {
                        Text("Widget Mediu (4x2)")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textMuted)
                        
                        mediumWidgetPreview
                            .frame(width: 329, height: 155)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.3), radius: 10)
                    }
                    
                    // Instructions
                    instructionsCard
                    
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
                        Image(systemName: "square.grid.2x2.fill")
                            .foregroundColor(Theme.primary)
                        Text("Widget iOS")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animateRing = true
                }
            }
        }
    }
    
    // MARK: - Small Widget Preview
    private var smallWidgetPreview: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.06, blue: 0.1), Color(red: 0.06, green: 0.1, blue: 0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(Color(red: 0.1, green: 0.15, blue: 0.2), lineWidth: 8)
                        .frame(width: 70, height: 70)
                    
                    Circle()
                        .trim(from: 0, to: animateRing ? CGFloat(healthScore) / 100.0 : 0)
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.2), value: animateRing)
                    
                    Text("\(healthScore)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(scoreColor)
                }
                
                Text(vehicleManager.currentVehicle.make)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("AutoDiag Pro")
                    .font(.system(size: 8))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(12)
        }
    }
    
    // MARK: - Medium Widget Preview
    private var mediumWidgetPreview: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.06, blue: 0.1), Color(red: 0.06, green: 0.1, blue: 0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            HStack(spacing: 16) {
                // Score ring
                ZStack {
                    Circle()
                        .stroke(Color(red: 0.1, green: 0.15, blue: 0.2), lineWidth: 10)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: animateRing ? CGFloat(healthScore) / 100.0 : 0)
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.2), value: animateRing)
                    
                    VStack(spacing: 0) {
                        Text("\(healthScore)")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(scoreColor)
                        Text("scor")
                            .font(.system(size: 8))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(vehicleManager.currentVehicle.displayName)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text("\(vehicleManager.currentVehicle.mileage) km")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        widgetStatBadge(icon: "checkmark.circle.fill", value: "4", color: Theme.gaugeGreen)
                        widgetStatBadge(icon: "exclamationmark.triangle.fill", value: "2", color: Theme.gaugeYellow)
                        widgetStatBadge(icon: "xmark.circle.fill", value: "0", color: Theme.gaugeRed)
                    }
                    
                    Text("AutoDiag Pro")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(16)
        }
    }
    
    private func widgetStatBadge(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 9))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Instructions Card
    private var instructionsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(Theme.primary)
                Text("CUM SA ADAUGI WIDGET-UL")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
            }
            
            instructionRow(step: "1", text: "Apasa lung pe ecranul Home")
            instructionRow(step: "2", text: "Apasa butonul + din coltul stanga sus")
            instructionRow(step: "3", text: "Cauta \"AutoDiag Pro\" in lista")
            instructionRow(step: "4", text: "Alege dimensiunea (mic sau mediu)")
            instructionRow(step: "5", text: "Apasa \"Adauga Widget\"")
            
            Text("Widget-ul se actualizeaza automat la fiecare diagnostic nou.")
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
                .padding(.top, 4)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func instructionRow(step: String, text: String) -> some View {
        HStack(spacing: 10) {
            Text(step)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(Theme.primary)
                .frame(width: 20, height: 20)
                .background(Theme.primary.opacity(0.15))
                .cornerRadius(10)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
    }
}
