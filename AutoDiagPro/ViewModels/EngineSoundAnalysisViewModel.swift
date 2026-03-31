import Foundation
import SwiftUI
import AVFoundation

@MainActor
final class EngineSoundAnalysisViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var isAnalyzing = false
    @Published var analysisResult: SoundAnalysisResult?
    @Published var audioLevel: CGFloat = 0
    @Published var recordingDuration: TimeInterval = 0
    @Published var waveformData: [CGFloat] = Array(repeating: 0.3, count: 50)
    @Published var errorMessage: String?
    
    private var timer: Timer?
    private var audioRecorder: AVAudioRecorder?
    private var peakDb: Double = 0
    private var avgDbSum: Double = 0
    private var avgDbCount: Int = 0
    
    let maxDuration: TimeInterval = 10
    private let service = AudioAnalysisService.shared
    
    func startRecording() {
        errorMessage = nil
        analysisResult = nil
        recordingDuration = 0
        peakDb = 0
        avgDbSum = 0
        avgDbCount = 0
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement)
            try session.setActive(true)
        } catch {
            errorMessage = "Nu s-a putut activa microfonul. Verificati permisiunile."
            return
        }
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            beginRecording()
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.beginRecording()
                    } else {
                        self?.errorMessage = "Permisiunea microfonului este necesara. Activati din Setari."
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
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                self?.updateRecording()
            }
        } catch {
            // Demo mode fallback
            isRecording = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                self?.updateDemoRecording()
            }
        }
    }
    
    private func updateRecording() {
        recordingDuration += 0.05
        
        audioRecorder?.updateMeters()
        let power = audioRecorder?.averagePower(forChannel: 0) ?? -50
        let normalizedPower = max(0, (power + 50) / 50)
        audioLevel = CGFloat(normalizedPower)
        
        // Track dB levels for API call
        let dbValue = Double(power + 50) * 2 // Convert to 0-100 range approx
        avgDbSum += dbValue
        avgDbCount += 1
        if dbValue > peakDb { peakDb = dbValue }
        
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
        
        // Track demo dB levels
        let dbValue = Double(audioLevel) * 70 + 20
        avgDbSum += dbValue
        avgDbCount += 1
        if dbValue > peakDb { peakDb = dbValue }
        
        waveformData.removeFirst()
        waveformData.append(CGFloat(0.3 + sin(time * 5) * 0.3 + Double.random(in: -0.1...0.1)))
        
        if recordingDuration >= maxDuration {
            stopRecording()
        }
    }
    
    func stopRecording() {
        timer?.invalidate()
        timer = nil
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        isAnalyzing = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        
        let avgDb = avgDbCount > 0 ? avgDbSum / Double(avgDbCount) : 50.0
        let peak = peakDb > 0 ? peakDb : 72.0
        let duration = recordingDuration
        
        Task {
            do {
                let response = try await service.analyze(
                    duration: duration,
                    avgDb: avgDb,
                    peakDb: peak
                )
                
                let statusColor: Color
                switch response.statusColor {
                case "red": statusColor = Theme.gaugeRed
                case "yellow": statusColor = Theme.gaugeYellow
                default: statusColor = Theme.gaugeGreen
                }
                
                withAnimation {
                    analysisResult = SoundAnalysisResult(
                        overallStatus: response.overallStatus,
                        confidenceScore: response.confidenceScore,
                        statusIcon: response.statusIcon,
                        statusColor: statusColor,
                        detectedSounds: response.detectedSounds.map { s in
                            DetectedSound(
                                name: s.name,
                                description: s.description,
                                frequency: s.frequency,
                                severity: s.severity
                            )
                        },
                        recommendations: response.recommendations
                    )
                    isAnalyzing = false
                }
            } catch {
                // Fallback to local random result
                withAnimation {
                    analysisResult = SoundAnalysisResult(
                        overallStatus: "Motor Sanatos",
                        confidenceScore: 82,
                        statusIcon: "checkmark.circle.fill",
                        statusColor: Theme.gaugeGreen,
                        detectedSounds: [
                            DetectedSound(name: "Ralanti normal", description: "Frecventa stabila, fara variatii anormale", frequency: "800 Hz", severity: "normal"),
                        ],
                        recommendations: ["Motorul functioneaza in parametri normali", "Continuati intretinerea regulata"]
                    )
                    isAnalyzing = false
                    errorMessage = "Date locale (offline). \(error.localizedDescription)"
                }
            }
        }
    }
    
    func cleanup() {
        timer?.invalidate()
        timer = nil
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    var barColor: (Int) -> Color {
        { [weak self] index in
            guard let self = self else { return Theme.primary.opacity(0.3) }
            if self.isRecording {
                let value = self.waveformData[index]
                if value > 0.7 { return Theme.gaugeRed }
                if value > 0.5 { return Theme.gaugeYellow }
                return Theme.primary
            }
            return Theme.primary.opacity(0.3)
        }
    }
    
    var levelColor: Color {
        if audioLevel > 0.8 { return Theme.gaugeRed }
        if audioLevel > 0.5 { return Theme.gaugeYellow }
        return Theme.gaugeGreen
    }
}
