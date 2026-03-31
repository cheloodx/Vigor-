import SwiftUI
import AVFoundation

struct EngineSoundAnalysisView: View {
    @StateObject private var viewModel = EngineSoundAnalysisViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Waveform visualization
                    waveformCard
                    
                    // Recording controls
                    recordingControls
                    
                    // Analysis result
                    if let result = viewModel.analysisResult {
                        analysisResultCard(result)
                    }
                    
                    // Tips
                    if viewModel.analysisResult == nil && !viewModel.isRecording {
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
            .onDisappear { viewModel.cleanup() }
        }
    }
    
    // MARK: - Waveform Card
    private var waveformCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text(viewModel.isRecording ? "INREGISTRARE..." : (viewModel.isAnalyzing ? "ANALIZA IN CURS..." : "WAVEFORM"))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(viewModel.isRecording ? Theme.gaugeRed : Theme.textMuted)
                    .tracking(1.5)
                
                Spacer()
                
                if viewModel.isRecording {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Theme.gaugeRed)
                            .frame(width: 8, height: 8)
                        Text(String(format: "%.1fs", viewModel.recordingDuration))
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.gaugeRed)
                    }
                }
            }
            
            // Waveform bars
            HStack(spacing: 2) {
                ForEach(0..<50, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(viewModel.barColor(index))
                        .frame(width: 4, height: max(4, viewModel.waveformData[index] * 80))
                        .animation(.easeInOut(duration: 0.1), value: viewModel.waveformData[index])
                }
            }
            .frame(height: 80)
            .padding(.vertical, 8)
            
            // Audio level meter
            if viewModel.isRecording {
                VStack(spacing: 4) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                            RoundedRectangle(cornerRadius: 3)
                                .fill(viewModel.levelColor)
                                .frame(width: geo.size.width * viewModel.audioLevel)
                                .animation(.easeInOut(duration: 0.1), value: viewModel.audioLevel)
                        }
                    }
                    .frame(height: 6)
                    
                    HStack {
                        Text("Nivel audio")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                        Spacer()
                        Text(String(format: "%.0f dB", viewModel.audioLevel * 100))
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(viewModel.levelColor)
                    }
                }
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(viewModel.isRecording ? Theme.gaugeRed.opacity(0.3) : Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
    }
    
    // MARK: - Recording Controls
    private var recordingControls: some View {
        VStack(spacing: 12) {
            if let error = viewModel.errorMessage {
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
                Button(action: { viewModel.isRecording ? viewModel.stopRecording() : viewModel.startRecording() }) {
                    ZStack {
                        Circle()
                            .fill(viewModel.isRecording ? Theme.gaugeRed.opacity(0.2) : Theme.primary.opacity(0.15))
                            .frame(width: 72, height: 72)
                        
                        if viewModel.isRecording {
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
                .disabled(viewModel.isAnalyzing)
            }
            
            Text(viewModel.isRecording ? "Apasa pentru a opri" : "Apasa pentru a inregistra sunetul motorului")
                .font(.system(size: 12))
                .foregroundColor(Theme.textMuted)
            
            // Progress bar
            if viewModel.isRecording {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Theme.primary)
                            .frame(width: geo.size.width * CGFloat(viewModel.recordingDuration / viewModel.maxDuration))
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
