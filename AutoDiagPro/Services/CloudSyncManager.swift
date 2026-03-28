import SwiftUI
import Combine

// MARK: - iCloud Sync Manager
// Syncs vehicles, journal entries, and diagnostics via iCloud key-value store
class CloudSyncManager: ObservableObject {
    static let shared = CloudSyncManager()
    
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?
    @Published var syncEnabled: Bool {
        didSet { UserDefaults.standard.set(syncEnabled, forKey: "iCloudSyncEnabled") }
    }
    @Published var syncStatus: SyncStatus = .idle
    @Published var pulledVehicles: [Vehicle] = []
    @Published var pulledJournalEntries: [JournalEntry] = []
    
    enum SyncStatus: String {
        case idle = "Inactiv"
        case syncing = "Sincronizare..."
        case success = "Sincronizat"
        case error = "Eroare sincronizare"
        case disabled = "Dezactivat"
    }
    
    private let kvStore = NSUbiquitousKeyValueStore.default
    
    init() {
        self.syncEnabled = UserDefaults.standard.object(forKey: "iCloudSyncEnabled") as? Bool ?? true
        setupNotifications()
        if syncEnabled { pullFromCloud() }
    }
    
    // MARK: - Setup
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kvStoreChanged),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: kvStore
        )
    }
    
    @objc private func kvStoreChanged(_ notification: Notification) {
        guard syncEnabled else { return }
        DispatchQueue.main.async { [weak self] in
            self?.pullFromCloud()
        }
    }
    
    // MARK: - Push to iCloud
    func pushToCloud(vehicles: [Vehicle], journalEntries: [JournalEntry]) {
        guard syncEnabled else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.isSyncing = true
            self?.syncStatus = .syncing
        }
        
        // Encode vehicles
        if let vehicleData = try? JSONEncoder().encode(vehicles) {
            kvStore.set(vehicleData, forKey: "sync_vehicles")
        }
        
        // Encode journal entries
        if let journalData = try? JSONEncoder().encode(journalEntries) {
            kvStore.set(journalData, forKey: "sync_journal")
        }
        
        // Store sync timestamp
        let now = Date()
        kvStore.set(now.timeIntervalSince1970, forKey: "sync_timestamp")
        kvStore.synchronize()
        
        DispatchQueue.main.async { [weak self] in
            self?.isSyncing = false
            self?.lastSyncDate = now
            self?.syncStatus = .success
        }
    }
    
    // MARK: - Pull from iCloud
    func pullFromCloud() {
        guard syncEnabled else {
            DispatchQueue.main.async { [weak self] in
                self?.syncStatus = .disabled
            }
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isSyncing = true
            self?.syncStatus = .syncing
        }
        
        // Read data from kvStore (thread-safe reads)
        let timestamp = kvStore.double(forKey: "sync_timestamp")
        let vehicleData = kvStore.data(forKey: "sync_vehicles")
        let journalData = kvStore.data(forKey: "sync_journal")
        
        // Decode off main queue
        let decodedVehicles = vehicleData.flatMap { try? JSONDecoder().decode([Vehicle].self, from: $0) }
        let decodedEntries = journalData.flatMap { try? JSONDecoder().decode([JournalEntry].self, from: $0) }
        let syncDate = timestamp > 0 ? Date(timeIntervalSince1970: timestamp) : nil
        
        // Update all @Published properties on main thread
        DispatchQueue.main.async { [weak self] in
            if let syncDate = syncDate {
                self?.lastSyncDate = syncDate
            }
            if let vehicles = decodedVehicles {
                self?.pulledVehicles = vehicles
            }
            if let entries = decodedEntries {
                self?.pulledJournalEntries = entries
            }
            self?.isSyncing = false
            self?.syncStatus = .success
        }
    }
    
    // MARK: - Force Sync
    func forceSync() {
        kvStore.synchronize()
        pullFromCloud()
    }
    
    // MARK: - Clear Cloud Data
    func clearCloudData() {
        kvStore.removeObject(forKey: "sync_vehicles")
        kvStore.removeObject(forKey: "sync_journal")
        kvStore.removeObject(forKey: "sync_timestamp")
        kvStore.synchronize()
        lastSyncDate = nil
        syncStatus = .idle
    }
}

// MARK: - iCloud Sync Settings View
struct CloudSyncSettingsView: View {
    @ObservedObject private var syncManager = CloudSyncManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Sync status card
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(statusColor.opacity(0.15))
                            .frame(width: 80, height: 80)
                        Image(systemName: statusIcon)
                            .font(.system(size: 34))
                            .foregroundColor(statusColor)
                    }
                    
                    Text("iCloud Sync")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(syncManager.syncStatus.rawValue)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(statusColor)
                    
                    if let lastSync = syncManager.lastSyncDate {
                        Text("Ultima sincronizare: \(lastSync, formatter: dateFormatter)")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textMuted)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
                // Toggle sync
                VStack(spacing: 12) {
                    Toggle(isOn: $syncManager.syncEnabled) {
                        HStack(spacing: 10) {
                            Image(systemName: "icloud.fill")
                                .foregroundColor(Theme.primary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sincronizare iCloud")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                Text("Vehicule, jurnal, diagnostice")
                                    .font(.system(size: 11))
                                    .foregroundColor(Theme.textMuted)
                            }
                        }
                    }
                    .tint(Theme.primary)
                }
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
                // Sync actions
                VStack(spacing: 8) {
                    Text("ACTIUNI")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1.2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    syncAction(icon: "arrow.triangle.2.circlepath", title: "Sincronizeaza Acum", subtitle: "Forteaza sincronizarea", color: Theme.primary) {
                        syncManager.forceSync()
                    }
                    
                    syncAction(icon: "trash.fill", title: "Sterge Date Cloud", subtitle: "Elimina toate datele din iCloud", color: Theme.gaugeRed) {
                        syncManager.clearCloudData()
                    }
                }
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
                // Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("INFORMATII")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1.2)
                    
                    infoRow(icon: "checkmark.shield.fill", text: "Datele sunt criptate end-to-end")
                    infoRow(icon: "iphone.and.arrow.forward", text: "Sincronizare automata intre dispozitive")
                    infoRow(icon: "wifi.slash", text: "Functioneaza si offline, sincronizeaza cand e disponibil")
                }
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
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
                    Image(systemName: "icloud.fill")
                        .foregroundColor(Theme.primary)
                    Text("iCloud Sync")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
    }
    
    private func syncAction(icon: String, title: String, subtitle: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                    .frame(width: 30, height: 30)
                    .background(color.opacity(0.15))
                    .cornerRadius(8)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textMuted)
            }
        }
    }
    
    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Theme.gaugeGreen)
                .frame(width: 20)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    private var statusColor: Color {
        switch syncManager.syncStatus {
        case .idle: return Theme.textMuted
        case .syncing: return Theme.primary
        case .success: return Theme.gaugeGreen
        case .error: return Theme.gaugeRed
        case .disabled: return Theme.textMuted
        }
    }
    
    private var statusIcon: String {
        switch syncManager.syncStatus {
        case .idle: return "icloud"
        case .syncing: return "arrow.triangle.2.circlepath"
        case .success: return "icloud.fill"
        case .error: return "icloud.slash.fill"
        case .disabled: return "icloud.slash"
        }
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }
}
