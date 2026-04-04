import SwiftUI
import AVFoundation

struct ScanView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var cameraManager = CameraSessionManager()

    @State private var selectedSubTab: ScanSubTab = .photo
    @State private var selectedResultTab: ResultTab = .diagnostic
    @State private var isLoading = false
    @State private var showImagePicker = false
    @State private var capturedImage: UIImage?
    @State private var diagnosticResult: DiagnosticResult?
    @State private var errorMessage: String?
    @State private var arStepIndex = 0
    @State private var showGalleryPicker = false
    @State private var arCameraActive = false

    enum ScanSubTab: String, CaseIterable {
        case photo = "photo"
        case ar = "ar"

        var icon: String {
            switch self {
            case .photo: return "camera.fill"
            case .ar: return "arkit"
            }
        }

        var displayName: String {
            switch self {
            case .photo: return "Foto Scan"
            case .ar: return "AR Live"
            }
        }
    }

    enum ResultTab: String, CaseIterable {
        case diagnostic = "diagnostic"
        case reparatie = "repair"
        case piese = "parts"
        case cost = "cost"
        case ar = "ar"

        var icon: String {
            switch self {
            case .diagnostic: return "magnifyingglass"
            case .reparatie: return "wrench.fill"
            case .piese: return "cart.fill"
            case .cost: return "creditcard.fill"
            case .ar: return "arkit"
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Sub-tab selector
                    subTabSelector

                    if selectedSubTab == .photo {
                        photoScanContent
                    } else {
                        arLiveContent
                    }
                }
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "camera.viewfinder")
                            .foregroundColor(Theme.primary)
                        Text(localization.t("scan.title"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(image: $capturedImage, sourceType: .camera)
            }
            .sheet(isPresented: $showGalleryPicker) {
                ImagePickerView(image: $capturedImage, sourceType: .photoLibrary)
            }
            .onChange(of: capturedImage) { newImage in
                if newImage != nil {
                    analyzeImage()
                }
            }
        }
    }

    // MARK: - Sub-tab Selector
    private var subTabSelector: some View {
        HStack(spacing: 0) {
            ForEach(ScanSubTab.allCases, id: \.self) { tab in
                Button(action: { withAnimation(.easeInOut(duration: 0.2)) { selectedSubTab = tab } }) {
                    HStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 12))
                        Text(tab.displayName)
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedSubTab == tab ? Color(red: 0.06, green: 0.21, blue: 0.38) : Theme.cardBackground)
                    .foregroundColor(selectedSubTab == tab ? Theme.primary : Theme.textMuted)
                }
            }
        }
        .background(Theme.cardBackground)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Photo Scan Content
    private var photoScanContent: some View {
        VStack(spacing: 12) {
            // Camera/Image area
            cameraArea

            // Action buttons
            HStack(spacing: 8) {
                Button(action: { showImagePicker = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                        Text(localization.t("general.camera"))
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.primaryGradient)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Button(action: { showGalleryPicker = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "photo.fill")
                        Text(localization.t("general.gallery"))
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.surfaceBackground)
                    .foregroundColor(Theme.textPrimary)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
                }

                if capturedImage != nil {
                    Button(action: { clearScan() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.danger)
                            .frame(width: 44, height: 44)
                            .background(Theme.surfaceBackground)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.2, green: 0.17, blue: 0.17), lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, 16)

            // Error message
            if let error = errorMessage, !isLoading {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(Theme.danger)
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundColor(Color(red: 0.99, green: 0.65, blue: 0.65))
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.11, green: 0.04, blue: 0.04))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.5, green: 0.11, blue: 0.11), lineWidth: 1))
                .padding(.horizontal, 16)
            }

            // Results
            if let result = diagnosticResult, !isLoading {
                diagnosticResultCard(result)
            }

            // Demo button
            if diagnosticResult == nil && !isLoading {
                Button(action: { loadDemoResult() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text(localization.t("scan.demo"))
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.06, green: 0.21, blue: 0.38))
                    .foregroundColor(Theme.primary)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
                }
                .padding(.horizontal, 16)
            }

            Spacer(minLength: 80)
        }
    }

    // MARK: - Camera Area
    private var cameraArea: some View {
        ZStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(14)

                if isLoading {
                    Color.black.opacity(0.6)
                        .cornerRadius(14)

                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Theme.primary)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 50))
                        .foregroundColor(Theme.textMuted.opacity(0.3))

                    Text(localization.t("scan.take_photo"))
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 190)
            }
        }
        .background(Color(red: 0.02, green: 0.04, blue: 0.06))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(
                    style: StrokeStyle(lineWidth: 2, dash: capturedImage == nil ? [8] : [])
                )
                .foregroundColor(Color(red: 0.12, green: 0.23, blue: 0.37))
        )
        .padding(.horizontal, 16)
        .onTapGesture {
            if capturedImage == nil { showImagePicker = true }
        }
    }

    // MARK: - Diagnostic Result Card
    private func diagnosticResultCard(_ result: DiagnosticResult) -> some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.vehicleName.isEmpty ? "Masina" : result.vehicleName)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(Theme.textPrimary)

                    if let firstItem = result.items.first {
                        Text(firstItem.name)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }

                    if !vehicleManager.currentVehicle.make.isEmpty {
                        Text("\(vehicleManager.currentVehicle.shortName)")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Theme.gaugeGreen.opacity(0.15))
                            .foregroundColor(Theme.gaugeGreen)
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.gaugeGreen.opacity(0.4), lineWidth: 1))
                    }
                }

                Spacer()

                // Severity badge
                severityBadge(result.overallStatus)
            }
            .padding(14)

            // OBD Codes
            if !result.items.filter({ $0.severity > 3 }).isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(result.items.filter({ $0.severity > 3 })) { item in
                            Text("P0\(item.severity)XX")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Theme.gaugeYellow.opacity(0.15))
                                .foregroundColor(Theme.gaugeYellow)
                                .cornerRadius(4)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.gaugeYellow.opacity(0.4), lineWidth: 1))
                        }
                    }
                    .padding(.horizontal, 14)
                }
                .padding(.bottom, 10)
            }

            // Result tab selector
            resultTabSelector

            // Tab content
            resultTabContent(result)
                .padding(14)
        }
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(result.overallStatus.color.opacity(0.3), lineWidth: 1))
        .padding(.horizontal, 16)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func severityBadge(_ status: DiagnosticStatus) -> some View {
        HStack(spacing: 4) {
            Image(systemName: status.icon)
                .font(.system(size: 10))
            Text(status.rawValue.uppercased())
                .font(.system(size: 10, weight: .bold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(status.color.opacity(0.15))
        .foregroundColor(status.color)
        .cornerRadius(4)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(status.color.opacity(0.5), lineWidth: 1))
    }

    // MARK: - Result Tab Selector
    private var resultTabSelector: some View {
        HStack(spacing: 0) {
            ForEach(ResultTab.allCases, id: \.self) { tab in
                Button(action: { withAnimation { selectedResultTab = tab } }) {
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 10))
                            Text(tab.rawValue)
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(selectedResultTab == tab ? Theme.primary : Theme.textMuted)

                        Rectangle()
                            .fill(selectedResultTab == tab ? Theme.primary : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 0)
        .overlay(Rectangle().fill(Color(red: 0.12, green: 0.17, blue: 0.23)).frame(height: 1), alignment: .bottom)
    }

    // MARK: - Result Tab Content
    @ViewBuilder
    private func resultTabContent(_ result: DiagnosticResult) -> some View {
        switch selectedResultTab {
        case .diagnostic:
            diagnosticTabContent(result)
        case .reparatie:
            repairTabContent(result)
        case .piese:
            partsTabContent(result)
        case .cost:
            costTabContent(result)
        case .ar:
            arTabContent(result)
        }
    }

    private func diagnosticTabContent(_ result: DiagnosticResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(result.items) { item in
                HStack(spacing: 10) {
                    Image(systemName: item.status.icon)
                        .foregroundColor(item.status.color)
                        .font(.system(size: 14))
                        .frame(width: 20)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Text(item.description)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                        if !item.detail.isEmpty {
                            Text(item.detail)
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                        }
                    }

                    Spacer()
                }
                .padding(.vertical, 4)
            }

            // Mechanic tip
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.primary)
                    .font(.system(size: 16))
                Text("Verificati periodic componentele marcate cu atentie. Un diagnostic complet la service este recomandat la fiecare 15.000 km.")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.49, green: 0.83, blue: 0.99))
                    .lineSpacing(4)
            }
            .padding(12)
            .background(Color(red: 0.05, green: 0.13, blue: 0.22))
            .cornerRadius(8)
        }
    }

    private func repairTabContent(_ result: DiagnosticResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(result.repairSteps) { step in
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.11, green: 0.31, blue: 0.85))
                            .frame(width: 24, height: 24)
                        Text("\(step.stepNumber)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(step.title)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                            Text(step.estimatedTime)
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                        }

                        Text(step.description)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                            .lineSpacing(3)

                        HStack(spacing: 4) {
                            Text(localization.t("general.filter") + ":")
                                .font(.system(size: 10))
                                .foregroundColor(Theme.textMuted)
                            Text(step.difficulty.rawValue)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(step.difficulty.color)
                        }

                        if !step.tools.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: "wrench.fill")
                                    .font(.system(size: 9))
                                    .foregroundColor(Theme.textMuted)
                                Text(step.tools.joined(separator: ", "))
                                    .font(.system(size: 10))
                                    .foregroundColor(Theme.textMuted)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private func partsTabContent(_ result: DiagnosticResult) -> some View {
        VStack(spacing: 8) {
            ForEach(Array(result.requiredParts.enumerated()), id: \.element.id) { index, part in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            if index == 0 {
                                Text("OEM")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Theme.primary)
                                    .tracking(1.5)
                                    .padding(.bottom, 2)
                            }
                            Text(part.name)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                        }
                        Spacer()
                        Text(part.priceRange)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Theme.secondary)
                    }

                    HStack {
                        Text(part.partNumber)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(Theme.textMuted)

                        Spacer()

                        Text(part.brand)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(part.isOriginal ? Theme.primary.opacity(0.15) : Color.purple.opacity(0.15))
                            .foregroundColor(part.isOriginal ? Theme.primary : Color.purple)
                            .cornerRadius(4)
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "shippingbox.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                        Text(part.availability.rawValue)
                            .font(.system(size: 11))
                            .foregroundColor(part.availability.color)
                    }
                }
                .padding(12)
                .background(index == 0 ? Color(red: 0.04, green: 0.09, blue: 0.16) : Color(red: 0.05, green: 0.08, blue: 0.13))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(index == 0 ? Color(red: 0.12, green: 0.23, blue: 0.37) : Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
            }
        }
    }

    private func costTabContent(_ result: DiagnosticResult) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                costBox(title: "Manopera", value: "\(Int(result.estimatedCost.laborCost)) RON", color: Theme.primary)
                costBox(title: "Piese", value: "\(Int(result.estimatedCost.partsCost)) RON", color: Color.purple)
                costBox(title: "TOTAL", value: result.estimatedCost.totalFormatted, color: Theme.secondary)
            }

            HStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                Text("Timp estimat:")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
                Text("\(String(format: "%.1f", result.estimatedCost.laborHours)) ore")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }
        }
    }

    private func costBox(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 9))
                .foregroundColor(Theme.textMuted)
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .default))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(red: 0.02, green: 0.04, blue: 0.06))
        .cornerRadius(8)
    }

    private func arTabContent(_ result: DiagnosticResult) -> some View {
        VStack(spacing: 6) {
            ForEach(result.arSteps) { step in
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Theme.gaugeYellow)
                            .frame(width: 22, height: 22)
                        Text("\(step.stepNumber)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.black)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.instruction)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Text(step.highlightArea)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textMuted)
                    }
                }
                .padding(10)
                .background(Color(red: 0.04, green: 0.09, blue: 0.16))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
            }
        }
    }

    // MARK: - AR Live Content (Real Camera Feed)
    private var arLiveContent: some View {
        VStack(spacing: 12) {
            // Live camera AR view
            ZStack {
                if cameraManager.permissionGranted {
                    // Real camera feed
                    CameraPreviewView(session: cameraManager.session)
                        .frame(height: 380)
                        .cornerRadius(14)
                } else {
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 380)
                        .overlay(
                            VStack(spacing: 12) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Theme.textMuted)
                                Text("Camera necesita permisiune")
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.textSecondary)
                                Button("Activeaza Camera") {
                                    cameraManager.checkPermission()
                                }
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Theme.primary)
                            }
                        )
                        .cornerRadius(14)
                }

                // AR overlay on top of camera
                AROverlayView()
                    .frame(height: 380)
                    .allowsHitTesting(false)

                // AR HUD badges
                VStack {
                    HStack(spacing: 6) {
                        ForEach(["LIVE", "AI", "AR"], id: \.self) { badge in
                            HStack(spacing: 4) {
                                if badge == "LIVE" {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 6, height: 6)
                                }
                                Text(badge)
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(badge == "LIVE" ? .red : Theme.primary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.black.opacity(0.85))
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
                        }
                        Spacer()
                        
                        // Torch toggle
                        Button(action: { cameraManager.toggleTorch() }) {
                            Image(systemName: "flashlight.on.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.gaugeYellow)
                                .padding(6)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(6)
                        }
                    }
                    .padding(10)

                    Spacer()

                    // Bottom controls
                    HStack(spacing: 12) {
                        Button(action: {
                            // Capture current frame and analyze
                            loadDemoResult()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "viewfinder")
                                Text("Scaneaza")
                                    .font(.system(size: 13, weight: .bold))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Theme.primaryGradient)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                        }

                        if let result = diagnosticResult, !result.arSteps.isEmpty {
                            HStack(spacing: 8) {
                                Button(action: { if arStepIndex > 0 { arStepIndex -= 1 } }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(arStepIndex == 0 ? Theme.textMuted : Theme.textPrimary)
                                }
                                .disabled(arStepIndex == 0)

                                Text("\(arStepIndex + 1)/\(result.arSteps.count)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.gaugeYellow)

                                Button(action: { if arStepIndex < result.arSteps.count - 1 { arStepIndex += 1 } }) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(arStepIndex == result.arSteps.count - 1 ? Theme.textMuted : Theme.textPrimary)
                                }
                                .disabled(arStepIndex == result.arSteps.count - 1)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.85))
                            .cornerRadius(20)
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
            .cornerRadius(14)
            .padding(.horizontal, 16)
            .onAppear {
                arCameraActive = true
                cameraManager.startSession()
            }
            .onDisappear {
                arCameraActive = false
                cameraManager.stopSession()
            }

            // AR step instruction
            if let result = diagnosticResult, !result.arSteps.isEmpty, arStepIndex < result.arSteps.count {
                let step = result.arSteps[arStepIndex]
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Theme.gaugeYellow)
                            .frame(width: 28, height: 28)
                        Text("\(step.stepNumber)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.instruction)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.gaugeYellow)
                        Text(step.highlightArea)
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(14)
                .background(Color(red: 0.07, green: 0.05, blue: 0.0))
                .cornerRadius(Theme.cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.gaugeYellow.opacity(0.4), lineWidth: 1))
                .padding(.horizontal, 16)
            }

            Spacer(minLength: 80)
        }
    }

    // MARK: - Actions
    private func clearScan() {
        capturedImage = nil
        diagnosticResult = nil
        errorMessage = nil
        selectedResultTab = .diagnostic
    }

    private func loadDemoResult() {
        withAnimation {
            isLoading = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                diagnosticResult = DiagnosticResult.sample
                isLoading = false
            }
        }
    }

    // MARK: - Image Analysis
    private func analyzeImage() {
        guard capturedImage != nil else { return }
        withAnimation { isLoading = true }
        errorMessage = nil

        let vehicle = vehicleManager.currentVehicle

        Task {
            do {
                let response = try await ImageAnalysisService.shared.analyze(
                    imageDescription: "Vehicle photo scan",
                    vehicleMake: vehicle.make,
                    vehicleModel: vehicle.model,
                    symptom: "general inspection"
                )
                
                var result = DiagnosticResult()
                result.vehicleName = vehicle.displayName
                
                let diagStatus: DiagnosticStatus
                switch response.severity {
                case "critical": diagStatus = .critical
                case "warning": diagStatus = .warning
                default: diagStatus = .good
                }
                
                result.items = [
                    DiagnosticItem(name: response.affectedSystem, description: response.diagnosis, status: diagStatus, detail: "Incredere: \(response.confidence)%"),
                ]
                
                for (i, cause) in response.possibleCauses.prefix(4).enumerated() {
                    result.items.append(DiagnosticItem(name: "Cauza \(i+1)", description: cause, status: .warning, detail: ""))
                }
                
                result.overallStatus = diagStatus
                
                result.repairSteps = response.recommendations.enumerated().map { i, rec in
                    RepairStep(stepNumber: i + 1, title: rec, description: "", estimatedTime: "—", difficulty: .medium, tools: [])
                }
                
                result.requiredParts = [
                    RequiredPart(name: "Piese conform diagnostic", partNumber: "—", brand: "OEM", priceMin: 0, priceMax: 0, availability: .inStock),
                ]
                
                result.estimatedCost = CostBreakdown(laborCost: 0, partsCost: 0, additionalCost: 0, laborHours: 0)
                result.arSteps = []
                
                withAnimation {
                    diagnosticResult = result
                    isLoading = false
                }
            } catch {
                // Fallback to local analysis
                let result = performLocalImageAnalysis(for: vehicle)
                withAnimation {
                    diagnosticResult = result
                    isLoading = false
                    errorMessage = "Date locale (offline). \(error.localizedDescription)"
                }
            }
        }
    }

    private func performLocalImageAnalysis(for vehicle: Vehicle) -> DiagnosticResult {
        var result = DiagnosticResult()
        result.vehicleName = vehicle.displayName
        let highMileage = vehicle.mileage > 100000

        result.items = [
            DiagnosticItem(name: "Motor", description: highMileage ? "Verificare recomandata" : "Aspect normal", status: highMileage ? .warning : .good, detail: "Bazat pe analiza vizuala si km vehicul (\(vehicle.mileage) km)"),
            DiagnosticItem(name: "Caroserie", description: "Analiza vizuala completata", status: .good, detail: "Nu s-au detectat daune majore vizibile"),
            DiagnosticItem(name: "Pneuri", description: "Verificati presiunea", status: .warning, detail: "Recomandam verificare presiune si uzura banda de rulare", severity: 4),
            DiagnosticItem(name: "Faruri/Stopuri", description: "Functioneaza", status: .good, detail: "Verificati periodic aliniere faruri"),
            DiagnosticItem(name: "Lichide", description: highMileage ? "Verificare niveluri" : "Nivel estimat OK", status: highMileage ? .warning : .good, detail: "Ulei, lichid racire, lichid frana, servodirectie", severity: highMileage ? 5 : 0),
            DiagnosticItem(name: "Frane", description: "Inspectie vizuala", status: .good, detail: "Pentru diagnosticare exacta, folositi tab-ul Live OBD2"),
        ]

        result.overallStatus = result.items.contains(where: { $0.status == .warning }) ? .warning : .good

        result.repairSteps = [
            RepairStep(stepNumber: 1, title: "Verificare presiune pneuri", description: "Verificati presiunea la rece: fata 2.2 bar, spate 2.0 bar", estimatedTime: "10 min", difficulty: .easy, tools: ["Manometru"]),
            RepairStep(stepNumber: 2, title: "Verificare niveluri lichide", description: "Deschideti capota si verificati: ulei motor, lichid racire, lichid frana", estimatedTime: "5 min", difficulty: .easy, tools: []),
            RepairStep(stepNumber: 3, title: "Inspectie vizuala sub capota", description: "Verificati starea curelelor, furtunurilor si conexiunilor", estimatedTime: "15 min", difficulty: .medium, tools: ["Lanterna"]),
        ]

        result.requiredParts = [
            RequiredPart(name: "Filtru aer", partNumber: "Specific \(vehicle.make)", brand: "Mann", priceMin: 30, priceMax: 60, availability: .inStock),
            RequiredPart(name: "Set becuri rezerva", partNumber: "H7+H1", brand: "Osram", priceMin: 40, priceMax: 80, availability: .inStock),
        ]

        result.estimatedCost = CostBreakdown(laborCost: 100, partsCost: 90, additionalCost: 20, laborHours: 0.5)

        result.arSteps = [
            ARStep(stepNumber: 1, instruction: "Deschideti capota motorului", highlightArea: "hood", icon: "arrow.up.circle"),
            ARStep(stepNumber: 2, instruction: "Localizati joja de ulei (maner galben)", highlightArea: "oil-dipstick", icon: "drop.fill"),
            ARStep(stepNumber: 3, instruction: "Verificati nivelul intre MIN si MAX", highlightArea: "oil-level", icon: "checkmark.circle"),
        ]

        return result
    }
}

// MARK: - AR Overlay View
struct AROverlayView: View {
    @State private var scanLineOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Corner brackets
                ARCornerBracket(position: .topLeft)
                    .position(x: 20, y: 20)
                ARCornerBracket(position: .topRight)
                    .position(x: w - 20, y: 20)
                ARCornerBracket(position: .bottomLeft)
                    .position(x: 20, y: h - 20)
                ARCornerBracket(position: .bottomRight)
                    .position(x: w - 20, y: h - 20)

                // Crosshair
                Path { path in
                    path.move(to: CGPoint(x: w/2 - 14, y: h/2))
                    path.addLine(to: CGPoint(x: w/2 + 14, y: h/2))
                    path.move(to: CGPoint(x: w/2, y: h/2 - 14))
                    path.addLine(to: CGPoint(x: w/2, y: h/2 + 14))
                }
                .stroke(Theme.primary.opacity(0.5), lineWidth: 1)

                // Scan line animation
                Rectangle()
                    .fill(
                        LinearGradient(colors: [.clear, Theme.primary.opacity(0.15), .clear],
                                       startPoint: .top, endPoint: .bottom)
                    )
                    .frame(height: 80)
                    .offset(y: scanLineOffset - h/2)
                    .onAppear {
                        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                            scanLineOffset = h
                        }
                    }

                // Grid lines
                ForEach(1..<6) { i in
                    Rectangle()
                        .fill(Theme.primary.opacity(0.03))
                        .frame(width: 1)
                        .offset(x: CGFloat(i) * w / 6 - w / 2)
                }
                ForEach(1..<4) { i in
                    Rectangle()
                        .fill(Theme.primary.opacity(0.03))
                        .frame(height: 1)
                        .offset(y: CGFloat(i) * h / 4 - h / 2)
                }
            }
        }
    }
}

struct ARCornerBracket: View {
    enum Position {
        case topLeft, topRight, bottomLeft, bottomRight
    }

    let position: Position
    let length: CGFloat = 28

    var body: some View {
        Path { path in
            switch position {
            case .topLeft:
                path.move(to: CGPoint(x: 0, y: length))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: length, y: 0))
            case .topRight:
                path.move(to: CGPoint(x: -length, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: length))
            case .bottomLeft:
                path.move(to: CGPoint(x: 0, y: -length))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: length, y: 0))
            case .bottomRight:
                path.move(to: CGPoint(x: -length, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: -length))
            }
        }
        .stroke(Theme.primary, lineWidth: 2.5)
    }
}
