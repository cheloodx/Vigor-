import SwiftUI
import Combine

// MARK: - Analytics Manager
// Lightweight analytics tracking for crash reports and usage statistics
// Uses local storage — can be extended to Firebase/Amplitude in production
class AnalyticsManager: ObservableObject {
    static let shared = AnalyticsManager()
    
    @Published var totalSessions: Int = 0
    @Published var totalScans: Int = 0
    @Published var totalOBDConnections: Int = 0
    @Published var totalChatMessages: Int = 0
    @Published var crashReports: [CrashReport] = []
    @Published var featureUsage: [String: Int] = [:]
    @Published var analyticsEnabled: Bool {
        didSet { UserDefaults.standard.set(analyticsEnabled, forKey: "analyticsEnabled") }
    }
    
    struct CrashReport: Identifiable, Codable {
        let id: String
        let date: Date
        let description: String
        let stackTrace: String
        let appVersion: String
        let iosVersion: String
        let deviceModel: String
    }
    
    init() {
        self.analyticsEnabled = UserDefaults.standard.object(forKey: "analyticsEnabled") as? Bool ?? true
        loadStats()
    }
    
    // MARK: - Event Tracking
    func trackEvent(_ event: String, properties: [String: String] = [:]) {
        guard analyticsEnabled else { return }
        featureUsage[event, default: 0] += 1
        saveStats()
    }
    
    func trackScreenView(_ screen: String) {
        guard analyticsEnabled else { return }
        trackEvent("screen_view_\(screen)")
    }
    
    func trackScan() {
        guard analyticsEnabled else { return }
        totalScans += 1
        trackEvent("scan_performed")
    }
    
    func trackOBDConnection() {
        guard analyticsEnabled else { return }
        totalOBDConnections += 1
        trackEvent("obd_connected")
    }
    
    func trackChatMessage() {
        guard analyticsEnabled else { return }
        totalChatMessages += 1
        trackEvent("chat_message_sent")
    }
    
    func trackSessionStart() {
        guard analyticsEnabled else { return }
        totalSessions += 1
        trackEvent("session_start")
    }
    
    // MARK: - Crash Reporting
    func logCrash(description: String, stackTrace: String = "") {
        let report = CrashReport(
            id: UUID().uuidString,
            date: Date(),
            description: description,
            stackTrace: stackTrace,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "3.0",
            iosVersion: UIDevice.current.systemVersion,
            deviceModel: UIDevice.current.model
        )
        crashReports.append(report)
        saveCrashReports()
    }
    
    func setupCrashHandler() {
        // Capture device info on main thread before registering crash handler
        let cachedIOSVersion = UIDevice.current.systemVersion
        let cachedDeviceModel = UIDevice.current.model
        let cachedAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "3.0"
        
        NSSetUncaughtExceptionHandler { exception in
            let report = CrashReport(
                id: UUID().uuidString,
                date: Date(),
                description: exception.name.rawValue + ": " + (exception.reason ?? "Unknown"),
                stackTrace: exception.callStackSymbols.joined(separator: "\n"),
                appVersion: cachedAppVersion,
                iosVersion: cachedIOSVersion,
                deviceModel: cachedDeviceModel
            )
            if let data = try? JSONEncoder().encode([report]) {
                UserDefaults.standard.set(data, forKey: "pending_crash_reports")
            }
        }
        
        // Check for pending crash reports from last session
        if let data = UserDefaults.standard.data(forKey: "pending_crash_reports"),
           let reports = try? JSONDecoder().decode([CrashReport].self, from: data) {
            crashReports.append(contentsOf: reports)
            UserDefaults.standard.removeObject(forKey: "pending_crash_reports")
            saveCrashReports()
        }
    }
    
    // MARK: - Persistence
    private func saveStats() {
        UserDefaults.standard.set(totalSessions, forKey: "analytics_sessions")
        UserDefaults.standard.set(totalScans, forKey: "analytics_scans")
        UserDefaults.standard.set(totalOBDConnections, forKey: "analytics_obd")
        UserDefaults.standard.set(totalChatMessages, forKey: "analytics_chat")
        if let data = try? JSONEncoder().encode(featureUsage) {
            UserDefaults.standard.set(data, forKey: "analytics_features")
        }
    }
    
    private func loadStats() {
        totalSessions = UserDefaults.standard.integer(forKey: "analytics_sessions")
        totalScans = UserDefaults.standard.integer(forKey: "analytics_scans")
        totalOBDConnections = UserDefaults.standard.integer(forKey: "analytics_obd")
        totalChatMessages = UserDefaults.standard.integer(forKey: "analytics_chat")
        if let data = UserDefaults.standard.data(forKey: "analytics_features"),
           let usage = try? JSONDecoder().decode([String: Int].self, from: data) {
            featureUsage = usage
        }
        loadCrashReports()
    }
    
    private func saveCrashReports() {
        if let data = try? JSONEncoder().encode(crashReports) {
            UserDefaults.standard.set(data, forKey: "analytics_crashes")
        }
    }
    
    private func loadCrashReports() {
        if let data = UserDefaults.standard.data(forKey: "analytics_crashes"),
           let reports = try? JSONDecoder().decode([CrashReport].self, from: data) {
            crashReports = reports
        }
    }
    
    // MARK: - Clear All Data
    func clearAllData() {
        totalSessions = 0
        totalScans = 0
        totalOBDConnections = 0
        totalChatMessages = 0
        crashReports = []
        featureUsage = [:]
        saveStats()
        saveCrashReports()
    }
}

// MARK: - Analytics Dashboard View
struct AnalyticsDashboardView: View {
    @ObservedObject private var analytics = AnalyticsManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Stats overview
                statsOverview
                
                // Feature usage
                featureUsageCard
                
                // Crash reports
                crashReportsCard
                
                // Settings
                settingsCard
                
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
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(Theme.primary)
                    Text("Statistici")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
    }
    
    private var statsOverview: some View {
        VStack(spacing: 10) {
            Text("UTILIZARE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                statCard(title: "Sesiuni", value: "\(analytics.totalSessions)", icon: "app.fill", color: Theme.primary)
                statCard(title: "Scanari", value: "\(analytics.totalScans)", icon: "camera.fill", color: Theme.gaugeGreen)
                statCard(title: "Conexiuni OBD2", value: "\(analytics.totalOBDConnections)", icon: "antenna.radiowaves.left.and.right", color: Theme.gaugeYellow)
                statCard(title: "Mesaje Chat", value: "\(analytics.totalChatMessages)", icon: "bubble.left.fill", color: Color(red: 0.6, green: 0.2, blue: 0.9))
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.08))
        .cornerRadius(10)
    }
    
    private var featureUsageCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FUNCTII CELE MAI FOLOSITE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            let sortedFeatures = analytics.featureUsage.sorted { $0.value > $1.value }.prefix(8)
            let maxUsage = sortedFeatures.first?.value ?? 1
            
            if sortedFeatures.isEmpty {
                HStack {
                    Spacer()
                    Text("Nicio utilizare inregistrata inca")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                    Spacer()
                }
                .padding(.vertical, 12)
            } else {
                ForEach(Array(sortedFeatures), id: \.key) { feature, count in
                    HStack(spacing: 8) {
                        Text(feature.replacingOccurrences(of: "screen_view_", with: "").replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                            .frame(width: 100, alignment: .leading)
                        
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Theme.primary)
                                .frame(width: geo.size.width * CGFloat(count) / CGFloat(max(1, maxUsage)))
                        }
                        .frame(height: 8)
                        
                        Text("\(count)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var crashReportsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("CRASH REPORTS (\(analytics.crashReports.count))")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                Spacer()
                if !analytics.crashReports.isEmpty {
                    Circle()
                        .fill(Theme.gaugeRed)
                        .frame(width: 8, height: 8)
                }
            }
            
            if analytics.crashReports.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.gaugeGreen)
                        Text("Niciun crash detectat")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.gaugeGreen)
                    }
                    .padding(.vertical, 12)
                    Spacer()
                }
            } else {
                ForEach(analytics.crashReports.suffix(3)) { report in
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.gaugeRed)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(report.description)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                                .lineLimit(1)
                            Text("\(report.date, formatter: crashDateFormatter) — iOS \(report.iosVersion)")
                                .font(.system(size: 8))
                                .foregroundColor(Theme.textMuted)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var settingsCard: some View {
        VStack(spacing: 10) {
            Toggle(isOn: $analytics.analyticsEnabled) {
                HStack(spacing: 8) {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(Theme.primary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Colectare Statistici")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Text("Ajuta la imbunatatirea aplicatiei")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                    }
                }
            }
            .tint(Theme.primary)
            
            Button(action: { analytics.clearAllData() }) {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Sterge Toate Statisticile")
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.gaugeRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Theme.gaugeRed.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var crashDateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }
}
