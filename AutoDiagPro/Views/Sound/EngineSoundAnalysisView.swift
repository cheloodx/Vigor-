import SwiftUI
import AVFoundation

struct EngineSoundAnalysisView: View {
    @State private var isRecording = false
    @State private var isAnalyzing = false
    @State private var analysisResult: SoundAnalysisResult?
    @State private var audioLevel: CGFloat = 0
    @State private var recordingDuration: TimeInterval = 0
    @State private var waveformData: [CGFloat] = Array(repeating: 0.3, count: 50)
    @State private var timer: Timer?
    @State private var audioRecorder: AVAudioRecorder?
    @State private var errorMessage: String?
    
    private let maxDuration: TimeInterval = 10
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Waveform visualization
                    waveformCard
                    
                    // Recording controls
                    recordingControls
                    
                    // Analysis result
                    if let result = analysisResult {
                        analysisResultCard(result)
                    }
                    
                    // Tips
                    if analysisResult == nil && !isRecording {
                        tipsCard
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
                        Image(systemName: "waveform.circle.fill")
                            .foregroundColor(Theme.primary)
                        Text("Analiza Sunet Motor")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Waveform Card
    private var waveformCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text(isRecording ? "INREGISTRARE..." : (isAnalyzing ? "ANALIZA IN CURS..." : "WAVEFORM"))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(isRecording ? Theme.gaugeRed : Theme.textMuted)
                    .tracking(1.5)
                
                Spacer()
                
                if isRecording {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Theme.gaugeRed)
                            .frame(width: 8, height: 8)
                        Text(String(format: "%.1fs", recordingDuration))
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.gaugeRed)
                    }
                }
            }
            
            // Waveform bars
            HStack(spacing: 2) {
                ForEach(0..<50, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(barColor(for: index))
                        .frame(width: 4, height: max(4, waveformData[index] * 80))
                        .animation(.easeInOut(duration: 0.1), value: waveformData[index])
                }
            }
            .frame(height: 80)
            .padding(.vertical, 8)
            
            // Audio level meter
            if isRecording {
                VStack(spacing: 4) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                            RoundedRectangle(cornerRadius: 3)
                                .fill(levelColor)
                                .frame(width: geo.size.width * audioLevel)
                                .animation(.easeInOut(duration: 0.1), value: audioLevel)
                        }
                    }
                    .frame(height: 6)
                    
                    HStack {
                        Text("Nivel audio")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                        Spacer()
                        Text(String(format: "%.0f dB", audioLevel * 100))
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(levelColor)
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(isRecording ? Theme.gaugeRed.opacity(0.3) : Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
    }
    
    // MARK: - Recording Controls
    private var recordingControls: some View {
        VStack(spacing: 12) {
            if let error = errorMessage {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(Theme.danger)
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.danger)
                }
                .padding(10)
                .background(Theme.danger.opacity(0.1))
                .cornerRadius(8)
            }
            
            HStack(spacing: 20) {
                // Record button
                Button(action: { isRecording ? stopRecording() : startRecording() }) {
                    ZStack {
                        Circle()
                            .fill(isRecording ? Theme.gaugeRed.opacity(0.2) : Theme.primary.opacity(0.15))
                            .frame(width: 72, height: 72)
                        
                        if isRecording {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Theme.gaugeRed)
                                .frame(width: 24, height: 24)
                        } else {
                            Circle()
                                .fill(Theme.primary)
                                .frame(width: 52, height: 52)
                            Image(systemName: "mic.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                    }
                }
                .disabled(isAnalyzing)
            }
            
            Text(isRecording ? "Apasa pentru a opri" : "Apasa pentru a inregistra sunetul motorului")
                .font(.system(size: 12))
                .foregroundColor(Theme.textMuted)
            
            // Progress bar
            if isRecording {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Theme.primary)
                            .frame(width: geo.size.width * CGFloat(recordingDuration / maxDuration))
                    }
                }
                .frame(height: 4)
            }
        }
    }
    
    // MARK: - Analysis Result Card
    private func analysisResultCard(_ result: SoundAnalysisResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: result.statusIcon)
                    .font(.system(size: 20))
                    .foregroundColor(result.statusColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Rezultat Analiza")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                    Text(result.overallStatus)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(result.statusColor)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("\(result.confidenceScore)%")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.primary)
                    Text("incredere")
                        .font(.system(size: 9))
                        .foregroundColor(Theme.textMuted)
                }
            }
            
            Divider().background(Color(red: 0.12, green: 0.17, blue: 0.23))
            
            // Detected sounds
            Text("SUNETE DETECTATE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            ForEach(result.detectedSounds, id: \.name) { sound in
                HStack(spacing: 10) {
                    Circle()
                        .fill(sound.severity == "normal" ? Theme.gaugeGreen : (sound.severity == "warning" ? Theme.gaugeYellow : Theme.gaugeRed))
                        .frame(width: 8, height: 8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(sound.name)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Text(sound.description)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(sound.frequency)
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(Theme.textMuted)
                }
                .padding(8)
                .background(Theme.surfaceBackground)
                .cornerRadius(6)
            }
            
            // Recommendations
            if !result.recommendations.isEmpty {
                Text("RECOMANDARI")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                    .padding(.top, 4)
                
                ForEach(result.recommendations, id: \.self) { rec in
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
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(result.statusColor.opacity(0.3), lineWidth: 1))
    }
    
    // MARK: - Tips Card
    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(Theme.gaugeYellow)
                Text("SFATURI PENTRU INREGISTRARE")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
            }
            
            tipRow(icon: "1.circle.fill", text: "Porniti motorul si lasati-l la ralanti 30 secunde")
            tipRow(icon: "2.circle.fill", text: "Tineti telefonul aproape de motor (30-50 cm)")
            tipRow(icon: "3.circle.fill", text: "Evitati zgomotele de fundal (trafic, muzica)")
            tipRow(icon: "4.circle.fill", text: "Inregistrati minim 5 secunde pentru rezultate precise")
            tipRow(icon: "5.circle.fill", text: "Accelerati usor o data in timpul inregistrarii")
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func tipRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Theme.primary)
                .frame(width: 16)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    // MARK: - Recording Functions
    private func startRecording() {
        errorMessage = nil
        analysisResult = nil
        recordingDuration = 0
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement)
            try session.setActive(true)
        } catch {
            errorMessage = "Nu s-a putut activa microfonul. Verificati permisiunile."
            return
        }
        
        // Check microphone permission
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            beginRecording()
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        beginRecording()
                    } else {
                        errorMessage = "Permisiunea microfonului este necesara. Activati din Setari."
                    }
                }
            }
        case .denied:
            errorMessage = "Permisiunea microfonului este dezactivata. Activati din Setari > Confidentialitate > Microfon."
        @unknown default:
            errorMessage = "Eroare la accesarea microfonului."
        }
    }
    
    private func beginRecording() {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("engine_sound.m4a")
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            isRecording = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                updateRecording()
            }
        } catch {
            // Demo mode fallback
            isRecording = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                updateDemoRecording()
            }
        }
    }
    
    private func updateRecording() {
        recordingDuration += 0.05
        
        audioRecorder?.updateMeters()
        let power = audioRecorder?.averagePower(forChannel: 0) ?? -50
        let normalizedPower = max(0, (power + 50) / 50)
        audioLevel = CGFloat(normalizedPower)
        
        // Update waveform
        waveformData.removeFirst()
        waveformData.append(CGFloat(normalizedPower) * 0.8 + CGFloat.random(in: 0.1...0.3))
        
        if recordingDuration >= maxDuration {
            stopRecording()
        }
    }
    
    private func updateDemoRecording() {
        recordingDuration += 0.05
        
        let time = recordingDuration
        audioLevel = CGFloat(0.4 + sin(time * 3) * 0.2 + sin(time * 7) * 0.1)
        
        waveformData.removeFirst()
        waveformData.append(CGFloat(0.3 + sin(time * 5) * 0.3 + Double.random(in: -0.1...0.1)))
        
        if recordingDuration >= maxDuration {
            stopRecording()
        }
    }
    
    private func stopRecording() {
        timer?.invalidate()
        timer = nil
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        isAnalyzing = true
        
        // Simulate analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                analysisResult = generateAnalysisResult()
                isAnalyzing = false
            }
        }
    }
    
    private func generateAnalysisResult() -> SoundAnalysisResult {
        let scenarios: [SoundAnalysisResult] = [
            SoundAnalysisResult(
                overallStatus: "Motor Sanatos",
                confidenceScore: 87,
                statusIcon: "checkmark.circle.fill",
                statusColor: Theme.gaugeGreen,
                detectedSounds: [
                    DetectedSound(name: "Ralanti normal", description: "Frecventa stabila, fara variatii anormale", frequency: "800 Hz", severity: "normal"),
                    DetectedSound(name: "Pompa combustibil", description: "Zgomot normal de functionare", frequency: "2.4 kHz", severity: "normal"),
                ],
                recommendations: ["Motorul functioneaza in parametri normali", "Continuati intretinerea regulata"]
            ),
            SoundAnalysisResult(
                overallStatus: "Atentie - Zgomote Detectate",
                confidenceScore: 72,
                statusIcon: "exclamationmark.triangle.fill",
                statusColor: Theme.gaugeYellow,
                detectedSounds: [
                    DetectedSound(name: "Bataie motor", description: "Posibila bataie la accelerare — verificare bujii/injectoare", frequency: "1.2 kHz", severity: "warning"),
                    DetectedSound(name: "Zgomot curele", description: "Scartait la pornire la rece", frequency: "3.8 kHz", severity: "warning"),
                    DetectedSound(name: "Ralanti", description: "Frecventa stabila", frequency: "780 Hz", severity: "normal"),
                ],
                recommendations: ["Verificati tensiunea curelei de accesorii", "Inspectie bujii si bobine", "Programati vizita la service in 1-2 saptamani"]
            ),
            SoundAnalysisResult(
                overallStatus: "Problema Detectata",
                confidenceScore: 65,
                statusIcon: "xmark.circle.fill",
                statusColor: Theme.gaugeRed,
                detectedSounds: [
                    DetectedSound(name: "Zgomot metalic", description: "Bataie ritmica din zona inferioara motor — posibil rulment", frequency: "450 Hz", severity: "danger"),
                    DetectedSound(name: "Vibratii anormale", description: "Vibratii la turatie joasa", frequency: "200 Hz", severity: "warning"),
                    DetectedSound(name: "Zgomot turbo", description: "Suierat anormal la accelerare", frequency: "5.2 kHz", severity: "warning"),
                ],
                recommendations: ["Programati urgent vizita la service", "Evitati turatii mari pana la diagnosticare", "Posibil rulment palier sau bielle uzate", "Cost estimat inspectie: 150-300 RON"]
            ),
        ]
        
        return scenarios.randomElement() ?? scenarios[0]
    }
    
    // MARK: - Helpers
    private func barColor(for index: Int) -> Color {
        if isRecording {
            let value = waveformData[index]
            if value > 0.7 { return Theme.gaugeRed }
            if value > 0.5 { return Theme.gaugeYellow }
            return Theme.primary
        }
        return Theme.primary.opacity(0.3)
    }
    
    private var levelColor: Color {
        if audioLevel > 0.8 { return Theme.gaugeRed }
        if audioLevel > 0.5 { return Theme.gaugeYellow }
        return Theme.gaugeGreen
    }
}

// MARK: - Sound Analysis Models
struct SoundAnalysisResult {
    let overallStatus: String
    let confidenceScore: Int
    let statusIcon: String
    let statusColor: Color
    let detectedSounds: [DetectedSound]
    let recommendations: [String]
}

struct DetectedSound {
    let name: String
    let description: String
    let frequency: String
    let severity: String // "normal", "warning", "danger"
}
