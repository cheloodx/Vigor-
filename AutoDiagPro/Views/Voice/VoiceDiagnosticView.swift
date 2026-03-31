import SwiftUI
import Speech
import AVFoundation

struct VoiceDiagnosticView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var speechManager = SpeechRecognitionManager()

    @State private var aiResponse: String?
    @State private var isProcessing = false
    @State private var waveformPhase: Double = 0
    @State private var waveformTimer: Timer?

    private let quickCommands = [
        "Motorul face zgomot la pornire",
        "Check engine e aprins",
        "Franele scartaie",
        "Masina vibreaza la viteza",
        "Consumul e prea mare",
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    // Main voice card
                    voiceRecordCard

                    // Error message
                    if let error = speechManager.errorMessage {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 12))
                            Text(error)
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Color(red: 0.99, green: 0.65, blue: 0.65))
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.11, green: 0.04, blue: 0.04))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.5, green: 0.11, blue: 0.11), lineWidth: 1))
                        .padding(.horizontal, 16)
                    }

                    // AI Response
                    if let response = aiResponse {
                        responseCard(response)
                    }

                    // Quick commands
                    quickCommandsSection

                    Spacer(minLength: 80)
                }
                .padding(.top, 8)
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "mic.fill")
                            .foregroundColor(Theme.primary)
                        Text("Comanda Vocala")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }

    // MARK: - Voice Record Card
    private var voiceRecordCard: some View {
        VStack(spacing: 14) {
            // Waveform / Icon
            if speechManager.isListening {
                WaveformView(phase: waveformPhase)
                    .frame(height: 60)
            } else {
                HStack {
                    Spacer()
                    if isProcessing {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(Theme.primary)
                    } else {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Theme.textMuted.opacity(isProcessing ? 0.3 : 1))
                    }
                    Spacer()
                }
                .frame(height: 60)
            }

            // Record button
            Button(action: {
                if speechManager.isListening {
                    stopListening()
                } else {
                    startListening()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(
                            speechManager.isListening
                                ? LinearGradient(colors: [Color(red: 0.86, green: 0.15, blue: 0.15), Theme.danger], startPoint: .topLeading, endPoint: .bottomTrailing)
                                : Theme.primaryGradient
                        )
                        .frame(width: 76, height: 76)
                        .shadow(color: speechManager.isListening ? Theme.danger.opacity(0.4) : Theme.primary.opacity(0.4), radius: speechManager.isListening ? 20 : 12)

                    if isProcessing {
                        ProgressView()
                            .scaleEffect(1.3)
                            .tint(.white)
                    } else {
                        Image(systemName: speechManager.isListening ? "stop.fill" : "mic.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                }
            }
            .disabled(isProcessing)
            .pulseAnimation(speechManager.isListening)

            // Status text
            Text(
                speechManager.isListening ? "Ascult... (apasa pentru a opri)"
                : isProcessing ? "Procesez..."
                : speechManager.isAuthorized ? "Apasa pentru a vorbi"
                : "Apasa pentru a vorbi (mod demo)"
            )
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(
                speechManager.isListening ? Theme.danger
                : isProcessing ? Theme.gaugeYellow
                : Theme.textSecondary
            )

            // Transcript
            if !speechManager.transcript.isEmpty {
                Text("\u{201E}\(speechManager.transcript)\u{201D}")
                    .font(.system(size: 13))
                    .italic()
                    .foregroundColor(Theme.textSecondary)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.02, green: 0.04, blue: 0.06))
                    .cornerRadius(8)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
        .padding(.horizontal, 16)
        .onChange(of: speechManager.isListening) { listening in
            if !listening && !speechManager.transcript.isEmpty {
                analyzeText(speechManager.transcript)
            }
            if !listening {
                waveformTimer?.invalidate()
                waveformTimer = nil
            }
        }
    }

    // MARK: - Response Card
    private func responseCard(_ response: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "wrench.and.screwdriver.fill")
                .font(.system(size: 22))
                .foregroundColor(Theme.primary)

            Text(response)
                .font(.system(size: 13))
                .foregroundColor(Theme.textPrimary)
                .lineSpacing(5)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
        .padding(.horizontal, 16)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: - Quick Commands
    private var quickCommandsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 12))
                Text("Exemple comenzi:")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(Theme.textMuted)
            .padding(.horizontal, 16)

            VStack(spacing: 6) {
                ForEach(quickCommands, id: \.self) { command in
                    Button(action: { analyzeText(command) }) {
                        HStack(spacing: 8) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                            Text("\u{201E}\(command)\u{201D}")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                            Spacer()
                        }
                        .padding(10)
                        .background(Theme.cardBackground)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
                    }
                    .disabled(isProcessing)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Speech Recognition
    private func startListening() {
        aiResponse = nil

        // Start waveform animation
        waveformTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            waveformPhase += 0.06
        }

        speechManager.startListening()
    }

    private func stopListening() {
        speechManager.stopListening()
        waveformTimer?.invalidate()
        waveformTimer = nil
    }

    private func analyzeText(_ text: String) {
        speechManager.transcript = text
        isProcessing = true
        aiResponse = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                aiResponse = MechanicAI.generateResponse(for: text, vehicle: vehicleManager.currentVehicle)
                isProcessing = false
            }
        }
    }
}

// MARK: - Waveform View
struct WaveformView: View {
    let phase: Double
    let barCount: Int

    // Pre-computed random offsets for stable animation
    private let randomOffsets: [Double]

    init(phase: Double, barCount: Int = 36) {
        self.phase = phase
        self.barCount = barCount
        var offsets: [Double] = []
        for i in 0..<barCount {
            let seed = Double(i) * 0.7 + 1.3
            offsets.append(sin(seed * 3.14) * 4 + 4)
        }
        self.randomOffsets = offsets
    }

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: (geo.size.width / CGFloat(barCount)) * 0.15) {
                ForEach(0..<barCount, id: \.self) { i in
                    let height = 20 + sin(phase * 3 + Double(i) * 0.4) * 18 + randomOffsets[i] * sin(phase * 2 + Double(i))
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(colors: [Theme.primary, Color(red: 0.11, green: 0.31, blue: 0.85)],
                                           startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: max(2, (geo.size.width / CGFloat(barCount)) * 0.8),
                               height: CGFloat(max(4, height)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}
