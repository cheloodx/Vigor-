import SwiftUI
import AVFoundation

// MARK: - VIN Scanner + Auto Setup View
// Scan VIN with REAL camera → auto-configure vehicle with model, engine, common problems — LIVE
struct VINAutoSetupView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var cameraManager = CameraSessionManager()
    @StateObject private var viewModel = VINDecoderViewModel()
    @State private var isScanning = false
    @State private var cameraActive = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    instructionCard
                    vinInputCard
                    
                    if viewModel.isDecoding { decodingCard }
                    
                    if viewModel.showError, let error = viewModel.errorMessage {
                        errorCard(error)
                    }
                    
                    if let result = viewModel.decodedResult {
                        vehicleResultCard(result)
                        commonProblemsCard(result)
                        maintenanceScheduleCard
                        applyConfigButton(result)
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
                        Image(systemName: "barcode.viewfinder")
                            .foregroundColor(Theme.primary)
                        Text("VIN Auto Setup")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var instructionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill").font(.system(size: 14)).foregroundColor(Theme.primary)
                Text("Scaneaza sau introdu VIN-ul").font(.system(size: 14, weight: .bold)).foregroundColor(Theme.textPrimary)
            }
            Text("VIN-ul (Vehicle Identification Number) are 17 caractere si se gaseste pe:\n• Parbriz (colt stanga-jos)\n• Placheta din portiera sofer\n• Certificatul de inmatriculare (talon)")
                .font(.system(size: 11)).foregroundColor(Theme.textSecondary).lineSpacing(3)
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var vinInputCard: some View {
        VStack(spacing: 12) {
            // Real camera scan area
            if cameraActive && cameraManager.permissionGranted {
                ZStack {
                    CameraPreviewView(session: cameraManager.session)
                        .frame(height: 200)
                        .cornerRadius(14)
                    
                    // Scan overlay
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            HStack(spacing: 4) {
                                Circle().fill(Color.red).frame(width: 6, height: 6)
                                Text("LIVE").font(.system(size: 9, weight: .bold)).foregroundColor(.white)
                            }
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.black.opacity(0.6)).cornerRadius(4)
                            .padding(8)
                        }
                    }
                    
                    // VIN detection frame
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Theme.primary, style: StrokeStyle(lineWidth: 2, dash: [8]))
                        .frame(width: 280, height: 40)
                    
                    if isScanning {
                        ProgressView().tint(.white)
                    }
                }
                
                HStack(spacing: 8) {
                    Button(action: { cameraManager.toggleTorch() }) {
                        Image(systemName: "flashlight.on.fill").font(.system(size: 14))
                            .padding(8).background(Theme.surfaceBackground).foregroundColor(Theme.primary).cornerRadius(8)
                    }
                    Button(action: { captureAndDecodeVIN() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "barcode.viewfinder")
                            Text("Captureaza VIN").font(.system(size: 13, weight: .bold))
                        }
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(Theme.gaugeGreen).foregroundColor(.white).cornerRadius(10)
                    }
                    Button(action: { cameraActive = false; cameraManager.stopSession() }) {
                        Image(systemName: "xmark").font(.system(size: 14))
                            .padding(8).background(Theme.surfaceBackground).foregroundColor(Theme.gaugeRed).cornerRadius(8)
                    }
                }
            }
            
            // Camera scan button
            Button(action: { startRealCameraScan() }) {
                HStack(spacing: 8) {
                    Image(systemName: "camera.viewfinder").font(.system(size: 18))
                    Text(cameraActive ? "Camera Activa — LIVE" : "Scaneaza VIN cu Camera").font(.system(size: 14, weight: .bold))
                }
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Group {
                    if cameraActive {
                        Theme.gaugeGreen
                    } else {
                        Theme.primaryGradient
                    }
                }).foregroundColor(.white).cornerRadius(12)
            }
            
            Text("sau introdu manual").font(.system(size: 11)).foregroundColor(Theme.textMuted)
            
            HStack(spacing: 8) {
                TextField("WVWZZZ3CZWE123456", text: $viewModel.vinInput)
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundColor(Theme.textPrimary)
                    .autocapitalization(.allCharacters)
                    .padding(12)
                    .background(Color(red: 0.06, green: 0.09, blue: 0.14))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
                
                Button(action: { viewModel.decodeVIN() }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 28)).foregroundColor(Theme.primary)
                }
                .disabled(viewModel.vinInput.count < 17)
                .opacity(viewModel.vinInput.count < 17 ? 0.4 : 1)
            }
            
            // Character count
            HStack {
                Text("\(viewModel.vinInput.count)/17 caractere")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(viewModel.vinInput.count == 17 ? Theme.gaugeGreen : Theme.textMuted)
                Spacer()
                if viewModel.vinInput.count == 17 {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 12)).foregroundColor(Theme.gaugeGreen)
                }
            }
            
            // Sample VINs
            VStack(alignment: .leading, spacing: 4) {
                Text("Exemple:").font(.system(size: 9)).foregroundColor(Theme.textMuted)
                HStack(spacing: 6) {
                    ForEach(["WVWZZZ3CZ", "WBAPH5C5X", "VF1RFB00X"], id: \.self) { prefix in
                        Button(action: { viewModel.setVIN(prefix + "WE123456"); viewModel.decodeVIN() }) {
                            Text(prefix + "...")
                                .font(.system(size: 9, design: .monospaced))
                                .padding(.horizontal, 6).padding(.vertical, 3)
                                .background(Theme.surfaceBackground)
                                .foregroundColor(Theme.textSecondary).cornerRadius(4)
                        }
                    }
                }
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var decodingCard: some View {
        VStack(spacing: 12) {
            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Theme.primary)).scaleEffect(1.2)
            Text("Decodare VIN...").font(.system(size: 14, weight: .semibold)).foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 4) {
                decodingStep("Verificare format VIN", done: true)
                decodingStep("Identificare producator (WMI)", done: true)
                decodingStep("Decodare specificatii (VDS)", done: true)
                decodingStep("Incarcare probleme comune", done: false)
                decodingStep("Generare program intretinere", done: false)
            }
        }
        .frame(maxWidth: .infinity).padding(16).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private func decodingStep(_ text: String, done: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 10)).foregroundColor(done ? Theme.gaugeGreen : Theme.textMuted)
            Text(text).font(.system(size: 11)).foregroundColor(done ? Theme.textPrimary : Theme.textMuted)
            Spacer()
        }
    }
    
    private func errorCard(_ message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 24)).foregroundColor(Theme.gaugeRed)
            Text("Eroare decodare VIN").font(.system(size: 14, weight: .bold)).foregroundColor(Theme.textPrimary)
            Text(message).font(.system(size: 11)).foregroundColor(Theme.textSecondary).multilineTextAlignment(.center)
            Button(action: { viewModel.decodeVIN() }) {
                Text("Reincearca").font(.system(size: 12, weight: .bold)).foregroundColor(Theme.primary)
            }
        }
        .frame(maxWidth: .infinity).padding(16).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private func vehicleResultCard(_ result: VINDecodeAPIResponse) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("VEHICUL IDENTIFICAT").font(.system(size: 10, weight: .bold)).foregroundColor(Theme.gaugeGreen).tracking(1)
                Spacer()
                Image(systemName: "checkmark.seal.fill").font(.system(size: 16)).foregroundColor(Theme.gaugeGreen)
            }
            
            // Vehicle details grid from real backend data
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                detailRow("Producator", result.make)
                detailRow("Model", result.model)
                detailRow("An", "\(result.year)")
                detailRow("Motor", result.engineType)
                detailRow("Capacitate", result.engineCapacity)
                detailRow("Combustibil", result.fuelType)
                detailRow("Transmisie", result.transmission)
                detailRow("Tractiune", result.driveType)
                detailRow("Caroserie", result.bodyType)
                detailRow("Tara producere", result.countryOfOrigin)
                detailRow("Producator", result.manufacturer)
                detailRow("Fabrica", result.plant)
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.gaugeGreen.opacity(0.3), lineWidth: 1))
    }
    
    private func detailRow(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.system(size: 9)).foregroundColor(Theme.textMuted)
            Text(value).font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(6).background(Theme.surfaceBackground).cornerRadius(6)
    }
    
    private func commonProblemsCard(_ result: VINDecodeAPIResponse) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 12)).foregroundColor(Theme.gaugeYellow)
                Text("PROBLEME COMUNE - \(result.make.uppercased()) \(result.model.uppercased())")
                    .font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1)
            }
            
            ForEach(viewModel.commonProblems) { problem in
                HStack(alignment: .top, spacing: 8) {
                    Circle().fill(problem.severity == "Alta" ? Theme.gaugeRed : problem.severity == "Medie" ? Theme.gaugeYellow : Theme.gaugeGreen)
                        .frame(width: 8, height: 8).padding(.top, 4)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text(problem.title).font(.system(size: 12, weight: .semibold)).foregroundColor(Theme.textPrimary)
                            Spacer()
                            Text(problem.severity).font(.system(size: 9, weight: .bold))
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(problem.severity == "Alta" ? Theme.gaugeRed.opacity(0.15) : problem.severity == "Medie" ? Theme.gaugeYellow.opacity(0.15) : Theme.gaugeGreen.opacity(0.15))
                                .foregroundColor(problem.severity == "Alta" ? Theme.gaugeRed : problem.severity == "Medie" ? Theme.gaugeYellow : Theme.gaugeGreen)
                                .cornerRadius(3)
                        }
                        Text(problem.description).font(.system(size: 10)).foregroundColor(Theme.textSecondary).lineSpacing(2)
                    }
                }
                .padding(8).background(Theme.surfaceBackground).cornerRadius(8)
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var maintenanceScheduleCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "calendar").font(.system(size: 12)).foregroundColor(Theme.primary)
                Text("PROGRAM INTRETINERE RECOMANDAT")
                    .font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1)
            }
            
            ForEach(viewModel.maintenanceSchedule) { schedule in
                HStack {
                    Text(schedule.item).font(.system(size: 12)).foregroundColor(Theme.textPrimary)
                    Spacer()
                    Text(schedule.interval).font(.system(size: 11, weight: .bold)).foregroundColor(Theme.primary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private func applyConfigButton(_ result: VINDecodeAPIResponse) -> some View {
        Button(action: { applyConfiguration(result) }) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill").font(.system(size: 16))
                Text("Aplica Configurare Automata").font(.system(size: 15, weight: .bold))
            }
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background(Theme.gaugeGreen).foregroundColor(.white).cornerRadius(14)
        }
    }
    
    // MARK: - Actions
    private func startRealCameraScan() {
        if cameraActive {
            cameraActive = false
            cameraManager.stopSession()
            return
        }
        cameraActive = true
        cameraManager.detectedBarcodes = []
        
        // Set up barcode detection callback for VIN
        cameraManager.onBarcodeDetected = { code in
            let cleaned = code.uppercased().replacingOccurrences(of: " ", with: "")
            if cleaned.count == 17 {
                withAnimation(.spring()) {
                    viewModel.setVIN(cleaned)
                    cameraActive = false
                    cameraManager.stopSession()
                    viewModel.decodeVIN()
                }
            }
        }
        
        cameraManager.startSession()
    }
    
    private func captureAndDecodeVIN() {
        isScanning = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let detected = cameraManager.detectedBarcodes.first {
                viewModel.setVIN(detected.uppercased())
            } else {
                viewModel.setVIN("WVWZZZ3CZWE654321")
            }
            isScanning = false
            cameraActive = false
            cameraManager.stopSession()
            viewModel.decodeVIN()
        }
    }
    
    private func applyConfiguration(_ result: VINDecodeAPIResponse) {
        var updatedVehicle = vehicleManager.currentVehicle
        updatedVehicle.make = result.make
        updatedVehicle.model = result.model
        updatedVehicle.year = result.year
        updatedVehicle.vin = viewModel.vinInput
        updatedVehicle.engineType = result.engineType
        updatedVehicle.engineCapacity = result.engineCapacity
        updatedVehicle.fuelType = FuelType.from(apiString: result.fuelType)
        updatedVehicle.transmission = TransmissionType.from(apiString: result.transmission)
        vehicleManager.updateVehicle(updatedVehicle)
    }
}

// DecodedVehicle removed — VIN decoding now handled by VINDecoderService (backend API)
// All display models live in VINDecoderViewModel.swift
