import SwiftUI

// MARK: - 3D Car Animation View (Visual Component Model)
struct CarAnimationView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var healthScore: HealthScore = .sample
    @State private var selectedPart: CarPart?
    @State private var rotationAngle: Double = 0
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Car diagram
                    carDiagramCard
                    
                    // Selected part detail
                    if let part = selectedPart {
                        partDetailCard(part)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    // All parts grid
                    partsGrid
                    
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
                        Text("Diagrama Vehicul")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .onAppear { startAnimation() }
        }
    }
    
    // MARK: - Car Diagram Card
    private var carDiagramCard: some View {
        VStack(spacing: 12) {
            Text(vehicleManager.currentVehicle.displayName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            
            ZStack {
                // Car body outline
                carBodyShape
                    .stroke(Theme.primary.opacity(0.3), lineWidth: 2)
                    .frame(height: 200)
                
                // Interactive parts
                ForEach(CarPart.allParts) { part in
                    Button(action: { withAnimation(.spring()) { selectedPart = selectedPart?.id == part.id ? nil : part } }) {
                        ZStack {
                            Circle()
                                .fill(partColor(part).opacity(0.3))
                                .frame(width: 32, height: 32)
                                .scaleEffect(selectedPart?.id == part.id ? 1.3 : (part.hasIssue ? pulseScale : 1.0))
                            
                            Image(systemName: part.icon)
                                .font(.system(size: 14))
                                .foregroundColor(partColor(part))
                        }
                    }
                    .position(x: part.position.x, y: part.position.y)
                }
            }
            .frame(height: 220)
            .padding(8)
            
            // Legend
            HStack(spacing: 16) {
                legendItem(color: Theme.gaugeGreen, label: "OK")
                legendItem(color: Theme.gaugeYellow, label: "Atentie")
                legendItem(color: Theme.gaugeRed, label: "Problema")
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.primary.opacity(0.2), lineWidth: 1))
    }
    
    // MARK: - Car Body Shape
    private var carBodyShape: some Shape {
        CarOutlineShape()
    }
    
    // MARK: - Part Detail Card
    private func partDetailCard(_ part: CarPart) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: part.icon)
                    .font(.system(size: 18))
                    .foregroundColor(partColor(part))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(part.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    Text(part.statusLabel)
                        .font(.system(size: 12))
                        .foregroundColor(partColor(part))
                }
                
                Spacer()
                
                Text("\(part.healthPercent)%")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(partColor(part))
            }
            
            Text(part.description)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(3)
            
            if !part.recommendations.isEmpty {
                Divider().background(Color(red: 0.12, green: 0.17, blue: 0.23))
                
                ForEach(part.recommendations, id: \.self) { rec in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.primary)
                            .padding(.top, 2)
                        Text(rec)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
            
            if part.estimatedCost > 0 {
                HStack {
                    Text("Cost estimat reparatie:")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                    Text(String(format: "%.0f - %.0f RON", part.estimatedCost * 0.8, part.estimatedCost * 1.2))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.secondary)
                }
                .padding(.top, 4)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(partColor(part).opacity(0.3), lineWidth: 1))
    }
    
    // MARK: - Parts Grid
    private var partsGrid: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TOATE COMPONENTELE")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.5)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(CarPart.allParts) { part in
                    Button(action: { withAnimation(.spring()) { selectedPart = part } }) {
                        HStack(spacing: 8) {
                            Image(systemName: part.icon)
                                .font(.system(size: 14))
                                .foregroundColor(partColor(part))
                                .frame(width: 28, height: 28)
                                .background(partColor(part).opacity(0.15))
                                .cornerRadius(7)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text(part.name)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Theme.textPrimary)
                                Text("\(part.healthPercent)%")
                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                                    .foregroundColor(partColor(part))
                            }
                            
                            Spacer()
                        }
                        .padding(8)
                        .background(selectedPart?.id == part.id ? partColor(part).opacity(0.08) : Theme.surfaceBackground)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(selectedPart?.id == part.id ? partColor(part).opacity(0.3) : Color.clear, lineWidth: 1))
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func partColor(_ part: CarPart) -> Color {
        if part.healthPercent >= 80 { return Theme.gaugeGreen }
        if part.healthPercent >= 50 { return Theme.gaugeYellow }
        return Theme.gaugeRed
    }
    
    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.25
        }
    }
}

// MARK: - Car Part Model
struct CarPart: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let position: CGPoint
    let healthPercent: Int
    let hasIssue: Bool
    let statusLabel: String
    let description: String
    let recommendations: [String]
    let estimatedCost: Double
    
    static var allParts: [CarPart] {
        [
            CarPart(name: "Motor", icon: "bolt.fill", position: CGPoint(x: 80, y: 90), healthPercent: 85, hasIssue: false, statusLabel: "Functioneaza normal", description: "Motorul functioneaza in parametri normali. Temperatura si turatia sunt stabile.", recommendations: ["Schimb ulei la urmatoarea revizie"], estimatedCost: 0),
            CarPart(name: "Frane Fata", icon: "circle.circle", position: CGPoint(x: 50, y: 160), healthPercent: 62, hasIssue: true, statusLabel: "Uzura detectata", description: "Placutele de frana fata sunt uzate aproximativ 60%. Recomandam inlocuirea in urmatoarele 5.000 km.", recommendations: ["Inlocuire placute frana fata", "Verificare discuri frana"], estimatedCost: 450),
            CarPart(name: "Frane Spate", icon: "circle.circle", position: CGPoint(x: 270, y: 160), healthPercent: 78, hasIssue: false, statusLabel: "Uzura moderata", description: "Placutele de frana spate au inca suficienta grosime pentru 15.000 km.", recommendations: ["Verificare la urmatoarea revizie"], estimatedCost: 0),
            CarPart(name: "Baterie", icon: "battery.100percent", position: CGPoint(x: 110, y: 60), healthPercent: 55, hasIssue: true, statusLabel: "Capacitate redusa", description: "Bateria are capacitate redusa. Tensiunea scade sub 12V la pornire.", recommendations: ["Inlocuire baterie recomandata", "Verificare alternator"], estimatedCost: 400),
            CarPart(name: "Suspensie", icon: "arrow.up.arrow.down", position: CGPoint(x: 160, y: 170), healthPercent: 88, hasIssue: false, statusLabel: "Stare buna", description: "Amortizoarele si arcurile sunt in stare buna. Niciun joc detectat.", recommendations: [], estimatedCost: 0),
            CarPart(name: "Transmisie", icon: "gearshape.2.fill", position: CGPoint(x: 160, y: 100), healthPercent: 82, hasIssue: false, statusLabel: "Functioneaza normal", description: "Schimbarea vitezelor se face lin. Uleiul de cutie este in parametri.", recommendations: ["Schimb ulei cutie la 60.000 km"], estimatedCost: 0),
            CarPart(name: "Directie", icon: "arrow.left.and.right", position: CGPoint(x: 50, y: 110), healthPercent: 90, hasIssue: false, statusLabel: "Excelenta", description: "Sistemul de directie functioneaza fara probleme. Servodirectia este precisa.", recommendations: [], estimatedCost: 0),
            CarPart(name: "Climatizare", icon: "snowflake", position: CGPoint(x: 160, y: 60), healthPercent: 70, hasIssue: false, statusLabel: "OK - incarcare recomandata", description: "Sistemul de aer conditionat functioneaza dar presiunea freonului este la limita.", recommendations: ["Incarcare freon recomandata"], estimatedCost: 200),
            CarPart(name: "Evacuare", icon: "wind", position: CGPoint(x: 270, y: 100), healthPercent: 75, hasIssue: false, statusLabel: "Verificare DPF", description: "Sistemul de evacuare functioneaza normal. DPF-ul necesita verificare la 150.000 km.", recommendations: ["Curatare DPF preventiva"], estimatedCost: 350),
            CarPart(name: "Faruri", icon: "lightbulb.fill", position: CGPoint(x: 40, y: 70), healthPercent: 95, hasIssue: false, statusLabel: "Excelente", description: "Toate luminile functioneaza corect. Becurile sunt in stare buna.", recommendations: [], estimatedCost: 0),
        ]
    }
}

// MARK: - Car Outline Shape
struct CarOutlineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Simple car side profile
        path.move(to: CGPoint(x: w * 0.08, y: h * 0.65))
        
        // Front bumper
        path.addLine(to: CGPoint(x: w * 0.05, y: h * 0.55))
        path.addQuadCurve(to: CGPoint(x: w * 0.12, y: h * 0.45), control: CGPoint(x: w * 0.05, y: h * 0.45))
        
        // Hood
        path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.42))
        
        // Windshield
        path.addLine(to: CGPoint(x: w * 0.35, y: h * 0.22))
        
        // Roof
        path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.20))
        
        // Rear window
        path.addLine(to: CGPoint(x: w * 0.78, y: h * 0.35))
        
        // Trunk
        path.addLine(to: CGPoint(x: w * 0.90, y: h * 0.40))
        
        // Rear bumper
        path.addQuadCurve(to: CGPoint(x: w * 0.95, y: h * 0.55), control: CGPoint(x: w * 0.95, y: h * 0.42))
        path.addLine(to: CGPoint(x: w * 0.92, y: h * 0.65))
        
        // Bottom - rear wheel arch
        path.addQuadCurve(to: CGPoint(x: w * 0.78, y: h * 0.72), control: CGPoint(x: w * 0.88, y: h * 0.78))
        path.addQuadCurve(to: CGPoint(x: w * 0.65, y: h * 0.65), control: CGPoint(x: w * 0.70, y: h * 0.78))
        
        // Bottom
        path.addLine(to: CGPoint(x: w * 0.35, y: h * 0.65))
        
        // Front wheel arch
        path.addQuadCurve(to: CGPoint(x: w * 0.22, y: h * 0.72), control: CGPoint(x: w * 0.30, y: h * 0.78))
        path.addQuadCurve(to: CGPoint(x: w * 0.08, y: h * 0.65), control: CGPoint(x: w * 0.12, y: h * 0.78))
        
        path.closeSubpath()
        
        return path
    }
}
