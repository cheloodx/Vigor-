import SwiftUI

struct MoodTrackerView: View {
    @State private var entries: [MoodEntry] = []
    @State private var selectedMood: Int = 3
    @State private var selectedIntimacy: Int = 3
    @State private var noteText: String = ""
    
    private static let storageKey = "mood_tracker_entries"
    
    private let moodEmojis = ["\u{1F614}", "\u{1F610}", "\u{1F642}", "\u{1F60A}", "\u{1F60D}"]
    private let intimacyLabels = ["Scazut", "Moderat", "Bun", "Ridicat", "Intens"]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Add Entry Card
                        VStack(spacing: 16) {
                            Text("Cum te simti azi?")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Mood Selector
                            VStack(spacing: 8) {
                                Text("Stare de spirit")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.6))
                                HStack(spacing: 16) {
                                    ForEach(0..<5) { i in
                                        Button(action: { selectedMood = i + 1 }) {
                                            Text(moodEmojis[i])
                                                .font(.system(size: selectedMood == i + 1 ? 36 : 28))
                                                .opacity(selectedMood == i + 1 ? 1.0 : 0.4)
                                        }
                                    }
                                }
                            }
                            
                            // Intimacy Selector
                            VStack(spacing: 8) {
                                Text("Nivel de intimitate")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.6))
                                HStack(spacing: 8) {
                                    ForEach(1...5, id: \.self) { level in
                                        Button(action: { selectedIntimacy = level }) {
                                            Text("\(level)")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(selectedIntimacy >= level ? .white : .white.opacity(0.3))
                                                .frame(width: 44, height: 44)
                                                .background(selectedIntimacy >= level ? Color(hex: "FF6B8A") : Color.white.opacity(0.08))
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                                Text(intimacyLabels[selectedIntimacy - 1])
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "FF6B8A"))
                            }
                            
                            // Save Button
                            Button(action: addEntry) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Salveaza")
                                }
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Theme.primaryGradient)
                                .cornerRadius(14)
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // Stats
                        if !entries.isEmpty {
                            HStack(spacing: 12) {
                                StatBox(value: String(format: "%.1f", averageMood), label: "Medie Mood", icon: "face.smiling")
                                StatBox(value: String(format: "%.1f", averageIntimacy), label: "Medie Intimitate", icon: "heart.fill")
                                StatBox(value: "\(entries.count)", label: "Inregistrari", icon: "chart.bar.fill")
                            }
                            .padding(.horizontal)
                        }
                        
                        // History
                        if !entries.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Istoric")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ForEach(entries.reversed()) { entry in
                                    HStack(spacing: 12) {
                                        Text(entry.moodEmoji)
                                            .font(.system(size: 28))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(entry.date, style: .date)
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(.white)
                                            HStack(spacing: 4) {
                                                ForEach(0..<entry.intimacy, id: \.self) { _ in
                                                    Image(systemName: "heart.fill")
                                                        .font(.system(size: 10))
                                                        .foregroundColor(Color(hex: "FF6B8A"))
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(Color.white.opacity(0.04))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                }
                            }
                        } else {
                            VStack(spacing: 12) {
                                Text("\u{1F4CA}")
                                    .font(.system(size: 50))
                                Text("Nicio inregistrare inca")
                                    .foregroundColor(.white.opacity(0.5))
                                Text("Inregistreaza-ti starea zilnic!")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            .padding(40)
                        }
                    }
                    .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Mood Tracker")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadEntries() }
    }
    
    private var averageMood: Double {
        guard !entries.isEmpty else { return 0 }
        return Double(entries.map { $0.mood }.reduce(0, +)) / Double(entries.count)
    }
    
    private var averageIntimacy: Double {
        guard !entries.isEmpty else { return 0 }
        return Double(entries.map { $0.intimacy }.reduce(0, +)) / Double(entries.count)
    }
    
    private func addEntry() {
        let entry = MoodEntry(mood: selectedMood, intimacy: selectedIntimacy, note: noteText)
        entries.append(entry)
        noteText = ""
        saveEntries()
    }
    
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) else { return }
        entries = decoded
    }
    
    private func saveEntries() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "FF6B8A"))
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.06))
        .cornerRadius(14)
    }
}
