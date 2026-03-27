import SwiftUI
import AVFoundation

// MARK: - AR Diagnostic View
// Shows an AR-style overlay on camera feed highlighting broken/problematic parts
struct ARDiagnosticView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var isScanning = false
    @State private var scanProgress: CGFloat = 0
    @State private var detectedParts: [ARDetectedPart] = []
    @State private var selectedPart: ARDetectedPart?
    @State private var showCamera = false
    @State private var scanPhase: ScanPhase = .ready
    @State private var pulseAnimation = false
    @State private var scanLineOffset: CGFloat = 0
    @State private var showPartDetail = false
    
    enum ScanPhase: String {
        case ready = "Pregatit pentru scanare"
        case scanning = "Scanare in curs..."
        case analyzing = "Analiza componente..."
        case complete = "Scanare completa"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // AR Camera Preview Card
                        arPreviewCard
                        
                        // Scan button
                        if scanPhase == .ready || scanPhase == .complete {
                            scanButton
                        }
                        
                        // Scanning progress
                        if scanPhase == .scanning || scanPhase == .analyzing {
                            scanProgressCard
                        }
                        
                        // Detected parts list
                        if !detectedParts.isEmpty {
                            detectedPartsSection
                        }
                        
                        // Selected part detail
                        if let part = selectedPart, showPartDetail {
                            partARDetailCard(part)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "viewfinder")
                            .foregroundColor(Theme.primary)
                        Text("AR Piese Stricate")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - AR Preview Card
    private var arPreviewCard: some View {
        ZStack {
            // Background - simulated camera/AR view
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.08, blue: 0.12),
                            Color(red: 0.08, green: 0.12, blue: 0.18)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 340)
            
            // Car outline
            CarOutlineShape()
                .stroke(
                    scanPhase == .complete ? Theme.primary : Theme.primary.opacity(0.2),
                    lineWidth: scanPhase == .complete ? 2.5 : 1.5
                )
                .frame(width: 280, height: 180)
                .offset(y: -10)
            
            // AR scan line animation
            if scanPhase == .scanning {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.primary.opacity(0), Theme.primary.opacity(0.6), Theme.primary.opacity(0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 3)
                    .offset(y: scanLineOffset - 170)
            }
            
            // AR grid overlay
            if scanPhase != .ready {
                arGridOverlay
                    .opacity(scanPhase == .scanning ? 0.3 : 0.15)
            }
            
            // Detected part markers (shown after scan)
            if scanPhase == .complete || scanPhase == .analyzing {
                ForEach(detectedParts) { part in
                    ARPartMarker(part: part, isSelected: selectedPart?.id == part.id, pulseAnimation: pulseAnimation)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                if selectedPart?.id == part.id {
                                    selectedPart = nil
                                    showPartDetail = false
                                } else {
                                    selectedPart = part
                                    showPartDetail = true
                                }
                            }
                        }
                }
            }
            
            // AR corner brackets
            arCornerBrackets
            
            // Phase label
            VStack {
                Spacer()
                HStack {
                    Image(systemName: scanPhase == .complete ? "checkmark.circle.fill" : "viewfinder")
                        .font(.system(size: 10))
                    Text(scanPhase.rawValue)
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(scanPhase == .complete ? Theme.gaugeGreen : Theme.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.6))
                .cornerRadius(20)
                .padding(.bottom, 12)
            }
            .frame(height: 340)
            
            // Vehicle info overlay
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("AR VIEW")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Theme.primary)
                            .tracking(2)
                        Text(vehicleManager.currentVehicle.displayName)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    if scanPhase == .complete {
                        let issueCount = detectedParts.filter { $0.severity == .critical || $0.severity == .warning }.count
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 10))
                            Text("\(issueCount) probleme")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .foregroundColor(issueCount > 0 ? Theme.gaugeRed : Theme.gaugeGreen)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                    }
                }
                .padding(12)
                
                Spacer()
            }
            .frame(height: 340)
        }
        .cornerRadius(Theme.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(
                    scanPhase == .complete ? Theme.primary.opacity(0.4) : Theme.primary.opacity(0.15),
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - AR Grid Overlay
    private var arGridOverlay: some View {
        Canvas { context, size in
            let spacing: CGFloat = 30
            let color = Theme.primary.opacity(0.2)
            
            // Vertical lines
            var x: CGFloat = 0
            while x < size.width {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(color), lineWidth: 0.5)
                x += spacing
            }
            
            // Horizontal lines
            var y: CGFloat = 0
            while y < size.height {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(color), lineWidth: 0.5)
                y += spacing
            }
        }
        .frame(height: 340)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - AR Corner Brackets
    private var arCornerBrackets: some View {
        ZStack {
            // Top-left
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Rectangle().fill(Theme.primary).frame(width: 20, height: 2)
                    Spacer()
                }
                Rectangle().fill(Theme.primary).frame(width: 2, height: 18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            
            // Top-right
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                    Rectangle().fill(Theme.primary).frame(width: 20, height: 2)
                }
                Rectangle().fill(Theme.primary).frame(width: 2, height: 18)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
            
            // Bottom-left
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Theme.primary).frame(width: 2, height: 18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 0) {
                    Rectangle().fill(Theme.primary).frame(width: 20, height: 2)
                    Spacer()
                }
            }
            
            // Bottom-right
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Theme.primary).frame(width: 2, height: 18)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                HStack(spacing: 0) {
                    Spacer()
                    Rectangle().fill(Theme.primary).frame(width: 20, height: 2)
                }
            }
        }
        .frame(height: 340)
        .padding(8)
    }
    
    // MARK: - Scan Button
    private var scanButton: some View {
        Button(action: { startARScan() }) {
            HStack(spacing: 10) {
                Image(systemName: scanPhase == .complete ? "arrow.clockwise" : "viewfinder")
                    .font(.system(size: 16))
                Text(scanPhase == .complete ? "Scaneaza Din Nou" : "Incepe Scanare AR")
                    .font(.system(size: 15, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(14)
        }
    }
    
    // MARK: - Scan Progress Card
    private var scanProgressCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text(scanPhase.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("\(Int(scanProgress * 100))%")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.primary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.primaryGradient)
                        .frame(width: geo.size.width * scanProgress)
                        .animation(.easeInOut(duration: 0.3), value: scanProgress)
                }
            }
            .frame(height: 8)
            
            // Scanning steps
            VStack(spacing: 6) {
                scanStep(icon: "camera.viewfinder", text: "Captura imagine", done: scanProgress > 0.2)
                scanStep(icon: "cpu", text: "Detectie componente", done: scanProgress > 0.5)
                scanStep(icon: "wand.and.stars", text: "Analiza stare piese", done: scanProgress > 0.8)
                scanStep(icon: "checkmark.seal", text: "Generare raport AR", done: scanProgress >= 1.0)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func scanStep(icon: String, text: String, done: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: done ? "checkmark.circle.fill" : icon)
                .font(.system(size: 12))
                .foregroundColor(done ? Theme.gaugeGreen : Theme.textMuted)
                .frame(width: 18)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(done ? Theme.textPrimary : Theme.textMuted)
            Spacer()
        }
    }
    
    // MARK: - Detected Parts Section
    private var detectedPartsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("PIESE DETECTATE")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.5)
                
                Spacer()
                
                let criticalCount = detectedParts.filter { $0.severity == .critical }.count
                let warningCount = detectedParts.filter { $0.severity == .warning }.count
                
                if criticalCount > 0 {
                    HStack(spacing: 3) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 9))
                        Text("\(criticalCount)")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(Theme.gaugeRed)
                }
                
                if warningCount > 0 {
                    HStack(spacing: 3) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 9))
                        Text("\(warningCount)")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(Theme.gaugeYellow)
                }
            }
            
            ForEach(detectedParts) { part in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        if selectedPart?.id == part.id {
                            selectedPart = nil
                            showPartDetail = false
                        } else {
                            selectedPart = part
                            showPartDetail = true
                        }
                    }
                }) {
                    detectedPartRow(part)
                }
            }
        }
    }
    
    private func detectedPartRow(_ part: ARDetectedPart) -> some View {
        HStack(spacing: 12) {
            // Severity indicator
            ZStack {
                Circle()
                    .fill(part.severity.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: part.icon)
                    .font(.system(size: 16))
                    .foregroundColor(part.severity.color)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(part.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Text(part.shortDescription)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                Text(part.severity.label)
                    .font(.system(size: 9, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(part.severity.color.opacity(0.2))
                    .foregroundColor(part.severity.color)
                    .cornerRadius(4)
                
                Text("\(part.healthPercent)%")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(part.severity.color)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
        }
        .padding(12)
        .background(selectedPart?.id == part.id ? part.severity.color.opacity(0.08) : Theme.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(selectedPart?.id == part.id ? part.severity.color.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
    
    // MARK: - Part AR Detail Card
    private func partARDetailCard(_ part: ARDetectedPart) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with AR badge
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(part.severity.color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: part.icon)
                        .font(.system(size: 20))
                        .foregroundColor(part.severity.color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(part.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        // AR badge
                        Text("AR")
                            .font(.system(size: 8, weight: .black))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Theme.primary)
                            .foregroundColor(.white)
                            .cornerRadius(3)
                    }
                    Text(part.severity.label)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(part.severity.color)
                }
                
                Spacer()
                
                // Health circle
                ZStack {
                    Circle()
                        .stroke(Color(red: 0.1, green: 0.15, blue: 0.2), lineWidth: 4)
                        .frame(width: 48, height: 48)
                    Circle()
                        .trim(from: 0, to: CGFloat(part.healthPercent) / 100.0)
                        .stroke(part.severity.color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-90))
                    Text("\(part.healthPercent)%")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(part.severity.color)
                }
            }
            
            Divider().background(Color(red: 0.12, green: 0.17, blue: 0.23))
            
            // Description
            Text(part.fullDescription)
                .font(.system(size: 13))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(4)
            
            // Damage indicators
            if !part.damageIndicators.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("INDICATORI DAUNE AR")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1)
                    
                    ForEach(part.damageIndicators, id: \.self) { indicator in
                        HStack(spacing: 8) {
                            Image(systemName: "viewfinder")
                                .font(.system(size: 9))
                                .foregroundColor(part.severity.color)
                            Text(indicator)
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
            }
            
            // Recommendations
            if !part.recommendations.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("RECOMANDARI")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1)
                    
                    ForEach(part.recommendations, id: \.self) { rec in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .font(.system(size: 9))
                                .foregroundColor(Theme.primary)
                                .padding(.top, 2)
                            Text(rec)
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
            }
            
            // Cost estimate
            if part.estimatedCost > 0 {
                HStack {
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.secondary)
                    Text("Cost estimat reparatie:")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textMuted)
                    Text(String(format: "%.0f - %.0f RON", part.estimatedCost * 0.8, part.estimatedCost * 1.2))
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.secondary)
                }
                .padding(.top, 4)
            }
            
            // Urgency bar
            HStack(spacing: 8) {
                Text("Urgenta:")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textMuted)
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                        RoundedRectangle(cornerRadius: 3)
                            .fill(part.severity.color)
                            .frame(width: geo.size.width * CGFloat(100 - part.healthPercent) / 100.0)
                    }
                }
                .frame(height: 6)
                
                Text(part.urgencyText)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(part.severity.color)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(part.severity.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Scan Logic
    private func startARScan() {
        withAnimation { scanPhase = .scanning }
        scanProgress = 0
        detectedParts = []
        selectedPart = nil
        showPartDetail = false
        
        // Start scan line animation
        withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: true)) {
            scanLineOffset = 340
        }
        
        // Simulate scanning phases
        simulateScanProgress()
    }
    
    private func simulateScanProgress() {
        // Phase 1: Camera capture (0-25%)
        for i in 1...5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                withAnimation { scanProgress = CGFloat(i) * 0.05 }
            }
        }
        
        // Phase 2: Component detection (25-60%)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation { scanPhase = .analyzing }
        }
        for i in 6...12 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 + Double(i - 5) * 0.25) {
                withAnimation { scanProgress = CGFloat(i) * 0.05 }
            }
        }
        
        // Phase 3: Analysis (60-100%)
        for i in 13...20 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5 + Double(i - 12) * 0.2) {
                withAnimation { scanProgress = CGFloat(i) * 0.05 }
            }
        }
        
        // Complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            withAnimation(.spring()) {
                scanPhase = .complete
                scanProgress = 1.0
                detectedParts = ARDetectedPart.sampleParts
                scanLineOffset = 0
            }
            
            // Start pulse animation for issue parts
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }
}

// MARK: - AR Part Marker (overlay on car diagram)
struct ARPartMarker: View {
    let part: ARDetectedPart
    let isSelected: Bool
    let pulseAnimation: Bool
    
    var body: some View {
        ZStack {
            // Pulse ring for issues
            if part.severity != .ok {
                Circle()
                    .stroke(part.severity.color.opacity(0.4), lineWidth: 1.5)
                    .frame(width: 38, height: 38)
                    .scaleEffect(pulseAnimation ? 1.4 : 1.0)
                    .opacity(pulseAnimation ? 0 : 0.8)
            }
            
            // Main marker
            Circle()
                .fill(part.severity.color.opacity(isSelected ? 0.5 : 0.3))
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(part.severity.color, lineWidth: isSelected ? 2.5 : 1.5)
                )
                .scaleEffect(isSelected ? 1.3 : 1.0)
            
            // Icon
            Image(systemName: part.severity == .ok ? "checkmark" : "exclamationmark")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(part.severity.color)
            
            // Label (shown when selected)
            if isSelected {
                Text(part.name)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(part.severity.color.opacity(0.9))
                    .cornerRadius(4)
                    .offset(y: -26)
            }
        }
        .position(x: part.arPosition.x, y: part.arPosition.y)
    }
}

// MARK: - AR Detected Part Model
struct ARDetectedPart: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let arPosition: CGPoint
    let healthPercent: Int
    let severity: PartSeverity
    let shortDescription: String
    let fullDescription: String
    let damageIndicators: [String]
    let recommendations: [String]
    let estimatedCost: Double
    
    var urgencyText: String {
        switch severity {
        case .critical: return "IMEDIAT"
        case .warning: return "CURAND"
        case .ok: return "NORMAL"
        }
    }
    
    enum PartSeverity {
        case critical, warning, ok
        
        var color: Color {
            switch self {
            case .critical: return Theme.gaugeRed
            case .warning: return Theme.gaugeYellow
            case .ok: return Theme.gaugeGreen
            }
        }
        
        var label: String {
            switch self {
            case .critical: return "CRITIC"
            case .warning: return "ATENTIE"
            case .ok: return "OK"
            }
        }
    }
    
    static var sampleParts: [ARDetectedPart] {
        [
            ARDetectedPart(
                name: "Placute Frana Fata",
                icon: "circle.circle",
                arPosition: CGPoint(x: 85, y: 155),
                healthPercent: 25,
                severity: .critical,
                shortDescription: "Uzura critica detectata - inlocuire necesara",
                fullDescription: "Scanarea AR a detectat uzura avansata a placutelor de frana fata. Grosimea reziduala este sub limita minima de siguranta (2mm). Se observa uzura neuniforma pe discul stang, indicand posibila problema cu etrierul.",
                damageIndicators: [
                    "Grosime placute: 1.8mm (minim 2mm)",
                    "Uzura neuniforma disc stanga",
                    "Urme de supraincalzire pe disc",
                    "Praf metalic excesiv pe janta"
                ],
                recommendations: [
                    "Inlocuire URGENTA placute frana fata",
                    "Verificare si eventual rectificare discuri",
                    "Inspectie etrier frana stanga",
                    "Inlocuire lichid frana daca are peste 2 ani"
                ],
                estimatedCost: 450
            ),
            ARDetectedPart(
                name: "Baterie Auto",
                icon: "battery.100.bolt",
                arPosition: CGPoint(x: 120, y: 70),
                healthPercent: 40,
                severity: .warning,
                shortDescription: "Capacitate redusa - inlocuire recomandata",
                fullDescription: "Bateria prezinta semne de imbatranire. Tensiunea la repaus este de 12.1V (normal 12.6V+). Capacitatea de pornire la rece (CCA) este redusa cu aproximativ 35% fata de valoarea nominala.",
                damageIndicators: [
                    "Tensiune repaus: 12.1V (normal 12.6V+)",
                    "CCA redus cu ~35%",
                    "Coroziune usoara pe borna pozitiva",
                    "Varsta baterie: ~4 ani"
                ],
                recommendations: [
                    "Inlocuire baterie in urmatoarele 2 luni",
                    "Curatare borne si contacte",
                    "Verificare alternator (tensiune incarcare)"
                ],
                estimatedCost: 400
            ),
            ARDetectedPart(
                name: "Climatizare AC",
                icon: "snowflake",
                arPosition: CGPoint(x: 170, y: 80),
                healthPercent: 60,
                severity: .warning,
                shortDescription: "Presiune freon scazuta - incarcare necesara",
                fullDescription: "Sistemul de aer conditionat functioneaza dar cu eficienta redusa. Presiunea freonului R134a este sub nivelul optim. Diferenta de temperatura la iesire este de doar 8 grade (normal 12-15 grade).",
                damageIndicators: [
                    "Presiune freon sub normal",
                    "Diferenta temperatura: 8°C (normal 12-15°C)",
                    "Timp racire compartiment: +40%",
                    "Condensator cu depuneri de praf"
                ],
                recommendations: [
                    "Incarcare freon R134a",
                    "Curatare condensator",
                    "Verificare etanseitate circuit AC"
                ],
                estimatedCost: 250
            ),
            ARDetectedPart(
                name: "Motor",
                icon: "bolt.fill",
                arPosition: CGPoint(x: 85, y: 95),
                healthPercent: 85,
                severity: .ok,
                shortDescription: "Functioneaza in parametri normali",
                fullDescription: "Motorul functioneaza corect. Temperatura este stabila, turatia de ralanti este constanta. Niciun cod de eroare detectat. Uleiul motor este in parametri dar se apropie de intervalul de schimb.",
                damageIndicators: [
                    "Toate parametrii in limite normale",
                    "Niciun cod eroare activ",
                    "Ulei motor - 2000km pana la schimb"
                ],
                recommendations: [
                    "Programare schimb ulei la urmatoarea revizie"
                ],
                estimatedCost: 0
            ),
            ARDetectedPart(
                name: "Suspensie Fata",
                icon: "arrow.up.arrow.down",
                arPosition: CGPoint(x: 60, y: 125),
                healthPercent: 88,
                severity: .ok,
                shortDescription: "Stare buna - fara probleme detectate",
                fullDescription: "Amortizoarele si arcurile din fata sunt in stare buna. Nu s-au detectat jocuri sau scurgeri de ulei. Bucse si articulatii fara uzura vizibila.",
                damageIndicators: [
                    "Amortizoare fara scurgeri",
                    "Articulatii fara joc",
                    "Bucse in stare buna"
                ],
                recommendations: [],
                estimatedCost: 0
            ),
            ARDetectedPart(
                name: "Evacuare / DPF",
                icon: "wind",
                arPosition: CGPoint(x: 260, y: 110),
                healthPercent: 72,
                severity: .ok,
                shortDescription: "OK - monitorizare DPF recomandata",
                fullDescription: "Sistemul de evacuare nu prezinta scurgeri. Filtrul de particule (DPF) este functional dar nivelul de umplere a crescut. Se recomanda o regenerare fortata sau o cursa lunga pe autostrada.",
                damageIndicators: [
                    "Fara scurgeri detectate",
                    "DPF umplere: 65% (atentie la 80%)",
                    "Catalizator functional"
                ],
                recommendations: [
                    "Cursa lunga autostrada pentru regenerare DPF",
                    "Monitorizare nivel umplere DPF"
                ],
                estimatedCost: 0
            ),
        ]
    }
}
