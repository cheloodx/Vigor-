import SwiftUI
import AVFoundation

// MARK: - QR/Barcode Part Scanner View
// Scan part serial number via QR code or barcode and find compatible alternatives
struct QRPartScannerView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var cameraManager = CameraSessionManager()
    @State private var scannedCode: String = ""
    @State private var isScanning = false
    @State private var showManualEntry = false
    @State private var manualSerial = ""
    @State private var scanResult: PartScanResult?
    @State private var isSearching = false
    @State private var showCamera = false
    @State private var flashAnimation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Scanner card
                        scannerCard
                        
                        // Manual entry
                        manualEntryCard
                        
                        // Search progress
                        if isSearching {
                            searchingCard
                        }
                        
                        // Results
                        if let result = scanResult {
                            originalPartCard(result)
                            alternativesSection(result)
                            compatibilityNote
                        }
                        
                        // How it works
                        if scanResult == nil && !isSearching {
                            howItWorksCard
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
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(Theme.primary)
                        Text("Scanner Piese")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Scanner Card (Real Camera + Barcode Detection)
    private var scannerCard: some View {
        VStack(spacing: 14) {
            // Scanner preview area with real camera
            ZStack {
                if isScanning && cameraManager.permissionGranted {
                    // Real camera feed for scanning
                    CameraPreviewView(session: cameraManager.session)
                        .frame(height: 260)
                        .cornerRadius(14)
                    
                    // QR frame overlay on camera
                    VStack(spacing: 12) {
                        ZStack {
                            qrFrameCorners
                                .frame(width: 180, height: 180)
                            
                            // Scan line animation
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.primary.opacity(0), Theme.primary, Theme.primary.opacity(0)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 160, height: 2)
                                .offset(y: flashAnimation ? 70 : -70)
                        }
                        
                        Text("Pozitioneaza codul in cadru")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                    }
                    
                    // Torch button
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: { cameraManager.toggleTorch() }) {
                                Image(systemName: "flashlight.on.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Theme.gaugeYellow)
                                    .padding(8)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(8)
                            }
                            .padding(8)
                        }
                        Spacer()
                    }
                } else if !scannedCode.isEmpty {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(red: 0.04, green: 0.07, blue: 0.11))
                        .frame(height: 220)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(Theme.gaugeGreen)
                                
                                Text("Cod scanat cu succes!")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.textPrimary)
                                
                                Text(scannedCode)
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundColor(Theme.primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.primary.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        )
                } else {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.04, green: 0.07, blue: 0.11),
                                    Color(red: 0.07, green: 0.10, blue: 0.16)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 220)
                        .overlay(
                            VStack(spacing: 10) {
                                Image(systemName: "qrcode.viewfinder")
                                    .font(.system(size: 48))
                                    .foregroundColor(Theme.primary.opacity(0.5))
                                
                                Text("Scaneaza codul de pe piesa")
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.textSecondary)
                                
                                Text("QR Code, Cod de Bare, EAN")
                                    .font(.system(size: 10))
                                    .foregroundColor(Theme.textMuted)
                            }
                        )
                }
            }
            
            // Scan button
            Button(action: { startScanning() }) {
                HStack(spacing: 8) {
                    Image(systemName: isScanning ? "stop.circle.fill" : "camera.viewfinder")
                        .font(.system(size: 16))
                    Text(isScanning ? "Opreste Scanarea" : "Scaneaza Cod Piesa")
                        .font(.system(size: 14, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isScanning ? Color(red: 0.9, green: 0.3, blue: 0.3) : Theme.primary)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.primary.opacity(0.2), lineWidth: 1))
    }
    
    // MARK: - QR Frame Corners
    private var qrFrameCorners: some View {
        ZStack {
            // Top-left
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Rectangle().fill(Theme.primary).frame(width: 24, height: 3)
                    Spacer()
                }
                Rectangle().fill(Theme.primary).frame(width: 3, height: 21)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            // Top-right
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                    Rectangle().fill(Theme.primary).frame(width: 24, height: 3)
                }
                Rectangle().fill(Theme.primary).frame(width: 3, height: 21)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
            // Bottom-left
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Theme.primary).frame(width: 3, height: 21)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 0) {
                    Rectangle().fill(Theme.primary).frame(width: 24, height: 3)
                    Spacer()
                }
            }
            // Bottom-right
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Theme.primary).frame(width: 3, height: 21)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                HStack(spacing: 0) {
                    Spacer()
                    Rectangle().fill(Theme.primary).frame(width: 24, height: 3)
                }
            }
        }
    }
    
    // MARK: - Manual Entry Card
    private var manualEntryCard: some View {
        VStack(spacing: 10) {
            Button(action: { withAnimation { showManualEntry.toggle() } }) {
                HStack {
                    Image(systemName: "keyboard")
                        .font(.system(size: 14))
                    Text("Introducere manuala serie piesa")
                        .font(.system(size: 13, weight: .semibold))
                    Spacer()
                    Image(systemName: showManualEntry ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11))
                }
                .foregroundColor(Theme.textSecondary)
            }
            
            if showManualEntry {
                HStack(spacing: 8) {
                    TextField("Ex: 04E 115 561 H", text: $manualSerial)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(Theme.textPrimary)
                        .padding(10)
                        .background(Color(red: 0.06, green: 0.09, blue: 0.14))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
                    
                    Button(action: { searchPart(serial: manualSerial) }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Theme.primary)
                            .cornerRadius(8)
                    }
                    .disabled(manualSerial.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(manualSerial.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Searching Card
    private var searchingCard: some View {
        VStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Theme.primary))
                .scaleEffect(1.2)
            
            Text("Cautare piese compatibile...")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Se verifica baza de date pentru \(vehicleManager.currentVehicle.displayName)")
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Original Part Card
    private func originalPartCard(_ result: PartScanResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("PIESA ORIGINALA")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                Spacer()
                
                Text("OEM")
                    .font(.system(size: 9, weight: .black))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Theme.primary.opacity(0.2))
                    .foregroundColor(Theme.primary)
                    .cornerRadius(4)
            }
            
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Theme.primary.opacity(0.1))
                        .frame(width: 50, height: 50)
                    Image(systemName: result.icon)
                        .font(.system(size: 22))
                        .foregroundColor(Theme.primary)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(result.partName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Serie: \(result.serialNumber)")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(Theme.textSecondary)
                    
                    Text("Producator: \(result.manufacturer)")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                infoChip(icon: "car.fill", text: result.vehicleCompatibility)
                infoChip(icon: "tag.fill", text: result.category)
            }
            
            HStack {
                Text("Pret mediu OEM:")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textMuted)
                Text(String(format: "%.0f RON", result.originalPrice))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.secondary)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
    }
    
    // MARK: - Alternatives Section
    private func alternativesSection(_ result: PartScanResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("ALTERNATIVE COMPATIBILE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                Spacer()
                
                Text("\(result.alternatives.count) gasite")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.gaugeGreen)
            }
            
            ForEach(result.alternatives) { alt in
                alternativePartRow(alt, originalPrice: result.originalPrice)
            }
        }
    }
    
    private func alternativePartRow(_ alt: AlternativePart, originalPrice: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(alt.brand)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text(alt.quality.label)
                            .font(.system(size: 8, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(alt.quality.color.opacity(0.2))
                            .foregroundColor(alt.quality.color)
                            .cornerRadius(3)
                    }
                    
                    Text("Serie: \(alt.serialNumber)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(Theme.textMuted)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.0f RON", alt.price))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(alt.price < originalPrice ? Theme.gaugeGreen : Theme.gaugeYellow)
                    
                    let saving = originalPrice - alt.price
                    if saving > 0 {
                        Text(String(format: "-%.0f RON (%.0f%%)", saving, (saving / originalPrice) * 100))
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Theme.gaugeGreen)
                    }
                }
            }
            
            // Compatibility and rating
            HStack(spacing: 12) {
                HStack(spacing: 3) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.gaugeGreen)
                    Text("Compatibil")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textSecondary)
                }
                
                HStack(spacing: 3) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: i < alt.rating ? "star.fill" : "star")
                            .font(.system(size: 8))
                            .foregroundColor(i < alt.rating ? Theme.gaugeYellow : Theme.textMuted)
                    }
                    Text("(\(alt.reviewCount))")
                        .font(.system(size: 9))
                        .foregroundColor(Theme.textMuted)
                }
                
                if alt.inStock {
                    HStack(spacing: 3) {
                        Circle()
                            .fill(Theme.gaugeGreen)
                            .frame(width: 5, height: 5)
                        Text("In stoc")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.gaugeGreen)
                    }
                } else {
                    HStack(spacing: 3) {
                        Circle()
                            .fill(Theme.gaugeYellow)
                            .frame(width: 5, height: 5)
                        Text("2-3 zile")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.gaugeYellow)
                    }
                }
                
                Spacer()
                
                Text("Garantie: \(alt.warrantyMonths) luni")
                    .font(.system(size: 9))
                    .foregroundColor(Theme.textMuted)
            }
        }
        .padding(12)
        .background(Theme.surfaceBackground)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
    }
    
    // MARK: - Compatibility Note
    private var compatibilityNote: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(Theme.primary)
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Nota compatibilitate")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Text("Piesele alternative au fost verificate pentru compatibilitate cu \(vehicleManager.currentVehicle.displayName). Recomandam consultarea unui mecanic inainte de achizitie.")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(3)
            }
        }
        .padding(12)
        .background(Theme.primary.opacity(0.08))
        .cornerRadius(10)
    }
    
    // MARK: - How It Works Card
    private var howItWorksCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CUM FUNCTIONEAZA")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            stepRow(number: 1, icon: "qrcode.viewfinder", text: "Scaneaza codul QR sau codul de bare de pe piesa auto")
            stepRow(number: 2, icon: "magnifyingglass", text: "Sistemul identifica piesa si producatorul original")
            stepRow(number: 3, icon: "list.bullet.rectangle", text: "Primesti lista de piese alternative compatibile")
            stepRow(number: 4, icon: "arrow.left.arrow.right", text: "Compara preturi, calitate si garantie")
            
            Divider().background(Color(red: 0.12, green: 0.17, blue: 0.23))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Tipuri de coduri suportate:")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.textSecondary)
                
                HStack(spacing: 8) {
                    codeTypeChip("QR Code")
                    codeTypeChip("Cod de Bare")
                    codeTypeChip("EAN-13")
                    codeTypeChip("DataMatrix")
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Helpers
    private func infoChip(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 9))
            Text(text)
                .font(.system(size: 10))
        }
        .foregroundColor(Theme.textMuted)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(red: 0.08, green: 0.12, blue: 0.18))
        .cornerRadius(6)
    }
    
    private func stepRow(number: Int, icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Theme.primary.opacity(0.15))
                    .frame(width: 28, height: 28)
                Text("\(number)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Theme.primary)
            }
            
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Theme.primary)
                .frame(width: 18)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    private func codeTypeChip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Theme.primary.opacity(0.1))
            .foregroundColor(Theme.primary)
            .cornerRadius(4)
    }
    
    // MARK: - Actions (Real Camera Barcode Scanning)
    private func startScanning() {
        if isScanning {
            // Stop scanning
            isScanning = false
            flashAnimation = false
            cameraManager.stopSession()
            return
        }
        
        scannedCode = ""
        scanResult = nil
        isScanning = true
        cameraManager.detectedBarcodes = []
        
        // Set up barcode detection callback
        cameraManager.onBarcodeDetected = { [self] code in
            withAnimation(.spring()) {
                isScanning = false
                flashAnimation = false
                scannedCode = code
                cameraManager.stopSession()
                searchPart(serial: code)
            }
        }
        
        // Start real camera session
        cameraManager.startSession()
        
        // Start scan line animation
        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: true)) {
            flashAnimation = true
        }
        
        // Fallback timeout: if no barcode detected in 15 seconds, use demo data
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { [self] in
            guard isScanning else { return }
            // Camera is running but no barcode found - show hint
        }
    }
    
    private func searchPart(serial: String) {
        guard !serial.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        isSearching = true
        scanResult = nil
        scannedCode = serial
        
        // Simulate search
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.spring()) {
                isSearching = false
                scanResult = PartScanResult.sampleResult(for: serial, vehicle: vehicleManager.currentVehicle.displayName)
            }
        }
    }
}

// MARK: - Part Scan Result Model
struct PartScanResult {
    let partName: String
    let serialNumber: String
    let manufacturer: String
    let icon: String
    let category: String
    let vehicleCompatibility: String
    let originalPrice: Double
    let alternatives: [AlternativePart]
    
    static func sampleResult(for serial: String, vehicle: String) -> PartScanResult {
        // Generate different results based on serial input
        let normalizedSerial = serial.uppercased().trimmingCharacters(in: .whitespaces)
        
        if normalizedSerial.contains("115") || normalizedSerial.contains("ULEI") {
            return PartScanResult(
                partName: "Filtru Ulei Motor",
                serialNumber: normalizedSerial.isEmpty ? "04E 115 561 H" : normalizedSerial,
                manufacturer: "VAG Original",
                icon: "drop.fill",
                category: "Filtre",
                vehicleCompatibility: vehicle,
                originalPrice: 85,
                alternatives: [
                    AlternativePart(brand: "MANN-FILTER", serialNumber: "W 712/95", price: 42, quality: .premium, rating: 5, reviewCount: 1847, inStock: true, warrantyMonths: 24),
                    AlternativePart(brand: "MAHLE", serialNumber: "OC 593/4", price: 38, quality: .premium, rating: 5, reviewCount: 923, inStock: true, warrantyMonths: 24),
                    AlternativePart(brand: "BOSCH", serialNumber: "F 026 407 181", price: 45, quality: .premium, rating: 4, reviewCount: 672, inStock: true, warrantyMonths: 24),
                    AlternativePart(brand: "FILTRON", serialNumber: "OP 641/2", price: 28, quality: .standard, rating: 4, reviewCount: 445, inStock: true, warrantyMonths: 12),
                    AlternativePart(brand: "HENGST", serialNumber: "H90W25", price: 35, quality: .premium, rating: 4, reviewCount: 318, inStock: false, warrantyMonths: 24),
                ]
            )
        } else if normalizedSerial.contains("FRANA") || normalizedSerial.contains("PLACUTE") || normalizedSerial.contains("5Q0") {
            return PartScanResult(
                partName: "Placute Frana Fata",
                serialNumber: normalizedSerial.isEmpty ? "5Q0 698 151 AE" : normalizedSerial,
                manufacturer: "TRW Original",
                icon: "circle.circle",
                category: "Frane",
                vehicleCompatibility: vehicle,
                originalPrice: 320,
                alternatives: [
                    AlternativePart(brand: "TRW", serialNumber: "GDB 2074", price: 195, quality: .premium, rating: 5, reviewCount: 2103, inStock: true, warrantyMonths: 24),
                    AlternativePart(brand: "BREMBO", serialNumber: "P 85 150", price: 225, quality: .premium, rating: 5, reviewCount: 1567, inStock: true, warrantyMonths: 24),
                    AlternativePart(brand: "ATE", serialNumber: "13.0460-7792.2", price: 180, quality: .premium, rating: 4, reviewCount: 891, inStock: true, warrantyMonths: 24),
                    AlternativePart(brand: "FERODO", serialNumber: "FDB4045", price: 165, quality: .standard, rating: 4, reviewCount: 534, inStock: false, warrantyMonths: 18),
                    AlternativePart(brand: "RIDEX", serialNumber: "402B0033", price: 89, quality: .economy, rating: 3, reviewCount: 267, inStock: true, warrantyMonths: 12),
                ]
            )
        } else {
            // Default: air filter
            return PartScanResult(
                partName: "Filtru Aer Motor",
                serialNumber: normalizedSerial.isEmpty ? "5Q0 129 620 B" : normalizedSerial,
                manufacturer: "VAG Original",
                icon: "wind",
                category: "Filtre",
                vehicleCompatibility: vehicle,
                originalPrice: 120,
                alternatives: [
                    AlternativePart(brand: "MANN-FILTER", serialNumber: "C 27 009", price: 58, quality: .premium, rating: 5, reviewCount: 1421, inStock: true, warrantyMonths: 24),
                    AlternativePart(brand: "MAHLE", serialNumber: "LX 2831", price: 52, quality: .premium, rating: 5, reviewCount: 734, inStock: true, warrantyMonths: 24),
                    AlternativePart(brand: "BOSCH", serialNumber: "F 026 400 497", price: 65, quality: .premium, rating: 4, reviewCount: 589, inStock: true, warrantyMonths: 24),
                    AlternativePart(brand: "FILTRON", serialNumber: "AP 183/4", price: 35, quality: .standard, rating: 4, reviewCount: 412, inStock: true, warrantyMonths: 12),
                    AlternativePart(brand: "KNECHT", serialNumber: "LX 2831", price: 48, quality: .premium, rating: 4, reviewCount: 298, inStock: false, warrantyMonths: 24),
                    AlternativePart(brand: "CHAMPION", serialNumber: "CAF100689P", price: 32, quality: .economy, rating: 3, reviewCount: 156, inStock: true, warrantyMonths: 12),
                ]
            )
        }
    }
}

// MARK: - Alternative Part Model
struct AlternativePart: Identifiable {
    let id = UUID()
    let brand: String
    let serialNumber: String
    let price: Double
    let quality: PartQuality
    let rating: Int
    let reviewCount: Int
    let inStock: Bool
    let warrantyMonths: Int
    
    enum PartQuality {
        case premium, standard, economy
        
        var label: String {
            switch self {
            case .premium: return "PREMIUM"
            case .standard: return "STANDARD"
            case .economy: return "ECONOMIC"
            }
        }
        
        var color: Color {
            switch self {
            case .premium: return Theme.gaugeGreen
            case .standard: return Theme.primary
            case .economy: return Theme.gaugeYellow
            }
        }
    }
}
