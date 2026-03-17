import SwiftUI

struct MassageTimerView: View {
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedPreset: MassagePreset? = nil
    @State private var timeRemaining: Int = 0
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    @State private var endDate: Date? = nil
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    if let preset = selectedPreset {
                        timerView(preset: preset)
                    } else {
                        presetsView
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Timer Masaj")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { stopTimer() }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active, let endDate = endDate, isRunning {
                timeRemaining = max(0, Int(endDate.timeIntervalSinceNow))
                if timeRemaining <= 0 { stopTimer() }
            }
        }
    }
    
    var presetsView: some View {
        VStack(spacing: 16) {
            Text("\u{1F932}")
                .font(.system(size: 50))
            Text("Alege Tipul de Masaj")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            ForEach(FeatureData.massagePresets) { preset in
                Button(action: {
                    selectedPreset = preset
                    timeRemaining = preset.duration * 60
                }) {
                    HStack(spacing: 14) {
                        Text(preset.icon)
                            .font(.system(size: 30))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(preset.name)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                            Text(preset.description)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.5))
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        Text("\(preset.duration) min")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "FF6B8A"))
                    }
                    .padding(14)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(16)
                }
                .padding(.horizontal)
            }
        }
    }
    
    func timerView(preset: MassagePreset) -> some View {
        VStack(spacing: 24) {
            Text(preset.icon)
                .font(.system(size: 50))
            
            Text(preset.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 8)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: Double(timeRemaining) / Double(preset.duration * 60))
                    .stroke(Theme.primaryGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: timeRemaining)
                
                VStack(spacing: 4) {
                    Text(timeString)
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    Text("ramase")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            HStack(spacing: 20) {
                Button(action: toggleTimer) {
                    HStack {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        Text(isRunning ? "Pauza" : "Start")
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.primaryGradient)
                    .cornerRadius(16)
                }
                
                Button(action: resetTimer) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset")
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal)
            
            Button(action: { selectedPreset = nil; stopTimer() }) {
                Text("Inapoi la Preseturi")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(.horizontal)
    }
    
    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func toggleTimer() {
        if isRunning { stopTimer() } else { startTimer() }
    }
    
    func startTimer() {
        guard timeRemaining > 0 else { return }
        endDate = Date().addingTimeInterval(Double(timeRemaining))
        isRunning = true
        let t = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 { timeRemaining -= 1 } else { stopTimer() }
        }
        RunLoop.current.add(t, forMode: .common)
        timer = t
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        endDate = nil
    }
    
    func resetTimer() {
        stopTimer()
        if let preset = selectedPreset {
            timeRemaining = preset.duration * 60
        }
    }
}
