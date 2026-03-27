import SwiftUI
import CoreMotion

// MARK: - Shake to Diagnose Feature
struct ShakeDiagnoseView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var isShaking = false
    @State private var showResult = false
    @State private var quickDiagnosis: QuickDiagnosis?
    @State private var shakeCount = 0
    @State private var phoneAngle: Double = 0
    @State private var timer: Timer?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if showResult, let diagnosis = quickDiagnosis {
                        // Result card
                        quickResultCard(diagnosis)
                        
                        // Reset button
                        Button(action: resetDiagnosis) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Diagnostic Nou")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.surfaceBackground)
                            .foregroundColor(Theme.primary)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
                        }
                    } else {
                        // Shake instruction
                        shakeInstructionCard
                        
                        // Or tap to diagnose
                        Button(action: performQuickDiagnosis) {
                            HStack(spacing: 8) {
                                Image(systemName: "hand.tap.fill")
                                Text("Sau apasa aici pentru diagnostic rapid")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.primaryGradient)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        // Recent quick diagnostics
                        recentDiagnostics
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
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .foregroundColor(Theme.primary)
                        Text("Diagnostic Rapid")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .onAppear { startMotionDetection() }
            .onDisappear { stopMotionDetection() }
        }
    }
    
    // MARK: - Shake Instruction
    private var shakeInstructionCard: some View {
        VStack(spacing: 20) {
            // Animated phone icon
            ZStack {
                Circle()
                    .fill(Theme.primary.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "iphone.gen3")
                    .font(.system(size: 50))
                    .foregroundColor(Theme.primary)
                    .rotationEffect(.degrees(isShaking ? -15 : 15))
                    .animation(.easeInOut(duration: 0.15).repeatForever(autoreverses: true), value: isShaking)
                    .onAppear { isShaking = true }
            }
            
            Text("Scuturati telefonul!")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Scuturati telefonul de 3 ori pentru un diagnostic rapid al vehiculului dumneavoastra")
                .font(.system(size: 13))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            // Shake counter
            HStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(i < shakeCount ? Theme.primary : Color(red: 0.1, green: 0.15, blue: 0.2))
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle().stroke(Theme.primary.opacity(0.3), lineWidth: 1)
                        )
                        .scaleEffect(i < shakeCount ? 1.2 : 1.0)
                        .animation(.spring(), value: shakeCount)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.primary.opacity(0.2), lineWidth: 1))
    }
    
    // MARK: - Quick Result Card
    private func quickResultCard(_ diagnosis: QuickDiagnosis) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: diagnosis.statusIcon)
                    .font(.system(size: 24))
                    .foregroundColor(diagnosis.statusColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Diagnostic Rapid")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                    Text(diagnosis.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(diagnosis.statusColor)
                }
                
                Spacer()
                
                Text("\(diagnosis.score)/100")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(diagnosis.statusColor)
            }
            
            Text(vehicleManager.currentVehicle.displayName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            
            Divider().background(Color(red: 0.12, green: 0.17, blue: 0.23))
            
            // Quick checks
            ForEach(diagnosis.checks, id: \.name) { check in
                HStack(spacing: 10) {
                    Image(systemName: check.passed ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(check.passed ? Theme.gaugeGreen : Theme.gaugeYellow)
                    
                    Text(check.name)
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Text(check.value)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(check.passed ? Theme.gaugeGreen : Theme.gaugeYellow)
                }
                .padding(.vertical, 2)
            }
            
            Divider().background(Color(red: 0.12, green: 0.17, blue: 0.23))
            
            // Recommendations
            Text("ACTIUNI RECOMANDATE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ForEach(diagnosis.actions, id: \.self) { action in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.primary)
                        .padding(.top, 2)
                    Text(action)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            // Share
            Button(action: {}) {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Partajeaza Diagnosticul")
                        .font(.system(size: 13, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.primaryGradient)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(diagnosis.statusColor.opacity(0.3), lineWidth: 1))
    }
    
    // MARK: - Recent Diagnostics
    private var recentDiagnostics: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CUM FUNCTIONEAZA")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.5)
            
            howItWorksRow(icon: "1.circle.fill", text: "Scuturati telefonul sau apasati butonul")
            howItWorksRow(icon: "2.circle.fill", text: "AI-ul analizeaza datele vehiculului salvate")
            howItWorksRow(icon: "3.circle.fill", text: "Primiti un scor instant si recomandari")
            howItWorksRow(icon: "4.circle.fill", text: "Partajati rezultatul cu mecanicul")
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func howItWorksRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Theme.primary)
                .frame(width: 20)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    // MARK: - Motion Detection
    private func startMotionDetection() {
        // Use timer-based shake simulation for demo
        // Real shake detection uses UIResponder's motionEnded
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            // In real app, CMMotionManager detects shakes
            // Demo: auto-increment after some time to show the feature
        }
    }
    
    private func stopMotionDetection() {
        timer?.invalidate()
        timer = nil
    }
    
    private func performQuickDiagnosis() {
        let vehicle = vehicleManager.currentVehicle
        let highMileage = vehicle.mileage > 100000
        let veryHighMileage = vehicle.mileage > 150000
        
        var checks: [QuickCheck] = []
        var score = 100
        var actions: [String] = []
        
        // Mileage check
        if veryHighMileage {
            checks.append(QuickCheck(name: "Kilometraj", value: "\(vehicle.mileage) km - RIDICAT", passed: false))
            score -= 20
            actions.append("Inspectie completa recomandata la kilometraj ridicat")
        } else if highMileage {
            checks.append(QuickCheck(name: "Kilometraj", value: "\(vehicle.mileage) km", passed: true))
            score -= 10
        } else {
            checks.append(QuickCheck(name: "Kilometraj", value: "\(vehicle.mileage) km - OK", passed: true))
        }
        
        // Simulated checks
        let randomFactor = Int.random(in: 0...20)
        
        checks.append(QuickCheck(name: "Ultima revizie", value: highMileage ? "Necesara" : "La zi", passed: !highMileage))
        if highMileage { score -= 10; actions.append("Programati revizia la service") }
        
        checks.append(QuickCheck(name: "Frane", value: randomFactor > 15 ? "Verificare" : "OK", passed: randomFactor <= 15))
        if randomFactor > 15 { score -= 8; actions.append("Verificati placutele de frana") }
        
        checks.append(QuickCheck(name: "Baterie", value: randomFactor > 12 ? "Slaba" : "OK", passed: randomFactor <= 12))
        if randomFactor > 12 { score -= 7; actions.append("Verificati tensiunea bateriei") }
        
        checks.append(QuickCheck(name: "Anvelope", value: "Verificare vizuala", passed: true))
        checks.append(QuickCheck(name: "Lichide motor", value: highMileage ? "Verificare" : "OK", passed: !highMileage))
        if highMileage { actions.append("Verificati nivelul uleiului si al lichidului de racire") }
        
        score = max(30, score - randomFactor / 2)
        
        if actions.isEmpty {
            actions.append("Vehiculul pare in stare buna!")
            actions.append("Continuati intretinerea regulata")
        }
        
        let title: String
        let icon: String
        let color: Color
        if score >= 80 {
            title = "Stare Buna"
            icon = "checkmark.circle.fill"
            color = Theme.gaugeGreen
        } else if score >= 50 {
            title = "Atentie Necesara"
            icon = "exclamationmark.triangle.fill"
            color = Theme.gaugeYellow
        } else {
            title = "Verificare Urgenta"
            icon = "xmark.circle.fill"
            color = Theme.gaugeRed
        }
        
        withAnimation {
            quickDiagnosis = QuickDiagnosis(
                title: title,
                score: score,
                statusIcon: icon,
                statusColor: color,
                checks: checks,
                actions: actions
            )
            showResult = true
        }
    }
    
    private func resetDiagnosis() {
        withAnimation {
            showResult = false
            quickDiagnosis = nil
            shakeCount = 0
        }
    }
}

// MARK: - Quick Diagnosis Models
struct QuickDiagnosis {
    let title: String
    let score: Int
    let statusIcon: String
    let statusColor: Color
    let checks: [QuickCheck]
    let actions: [String]
}

struct QuickCheck {
    let name: String
    let value: String
    let passed: Bool
}
