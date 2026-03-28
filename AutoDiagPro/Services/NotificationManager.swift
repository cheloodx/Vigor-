import SwiftUI
import UserNotifications
import Combine

// MARK: - Push Notification Manager
// Manages local and push notifications for maintenance alerts
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    @Published var pendingNotifications: [UNNotificationRequest] = []
    @Published var notificationSettings: NotificationSettings = NotificationSettings()
    
    struct NotificationSettings {
        var serviceAlerts: Bool = true
        var itpReminder: Bool = true
        var rcaReminder: Bool = true
        var weeklyReport: Bool = false
        var dtcAlerts: Bool = true
        var fuelReminder: Bool = false
    }
    
    init() {
        checkAuthorization()
    }
    
    // MARK: - Authorization
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if granted {
                    self?.registerCategories()
                }
            }
        }
    }
    
    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Register Categories
    private func registerCategories() {
        let serviceAction = UNNotificationAction(identifier: "VIEW_SERVICE", title: "Vezi Detalii", options: .foreground)
        let dismissAction = UNNotificationAction(identifier: "DISMISS", title: "Inchide", options: .destructive)
        
        let serviceCategory = UNNotificationCategory(
            identifier: "SERVICE_ALERT",
            actions: [serviceAction, dismissAction],
            intentIdentifiers: [],
            options: []
        )
        
        let itpCategory = UNNotificationCategory(
            identifier: "ITP_REMINDER",
            actions: [serviceAction, dismissAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([serviceCategory, itpCategory])
    }
    
    // MARK: - Schedule Service Alert
    func scheduleServiceAlert(serviceName: String, daysUntilDue: Int, vehicleName: String) {
        guard isAuthorized, notificationSettings.serviceAlerts else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Service Auto - \(vehicleName)"
        content.body = "\(serviceName) se apropie! Mai sunt \(daysUntilDue) zile pana la urmatorul service."
        content.sound = .default
        content.categoryIdentifier = "SERVICE_ALERT"
        content.badge = 1
        
        let trigger: UNNotificationTrigger
        if daysUntilDue > 0 {
            let futureDate = Calendar.current.date(byAdding: .day, value: daysUntilDue - 7, to: Date()) ?? Date()
            guard futureDate > Date() else { return }
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: futureDate)
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        } else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        }
        
        let request = UNNotificationRequest(
            identifier: "service_\(serviceName)_\(vehicleName)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Schedule ITP Reminder
    func scheduleITPReminder(dueDate: Date, vehicleName: String) {
        guard isAuthorized, notificationSettings.itpReminder else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "ITP Expira Curand!"
        content.body = "ITP-ul pentru \(vehicleName) expira curand. Programeaza-te la o statie ITP."
        content.sound = .default
        content.categoryIdentifier = "ITP_REMINDER"
        
        // 30 days before
        let reminderDate = Calendar.current.date(byAdding: .day, value: -30, to: dueDate) ?? Date()
        guard reminderDate > Date() else { return }
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "itp_\(vehicleName)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Schedule Weekly Report
    func scheduleWeeklyReport(vehicleName: String) {
        guard isAuthorized, notificationSettings.weeklyReport else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Raport Saptamanal - \(vehicleName)"
        content.body = "Vezi raportul saptamanal de sanatate al masinii tale. Scor, consum, alarme."
        content.sound = .default
        
        // Every Sunday at 10:00
        var components = DateComponents()
        components.weekday = 1
        components.hour = 10
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "weekly_report_\(vehicleName)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Cancel All (only NotificationManager-owned notifications)
    func cancelAllNotifications() {
        // Only remove notifications with our prefixed identifiers, not alarm UUIDs from MaintenanceAlarmManager
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let ownedIds = requests
                .map(\.identifier)
                .filter { $0.hasPrefix("service_") || $0.hasPrefix("itp_") || $0.hasPrefix("weekly_report_") }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ownedIds)
        }
    }
    
    // MARK: - Refresh Pending
    func refreshPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] requests in
            DispatchQueue.main.async {
                self?.pendingNotifications = requests
            }
        }
    }
}

// MARK: - Notification Settings View
struct NotificationSettingsView: View {
    @ObservedObject private var notifManager = NotificationManager.shared
    @EnvironmentObject var vehicleManager: VehicleManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Status
                statusCard
                
                // Settings
                settingsCard
                
                // Pending notifications
                pendingCard
                
                // Actions
                actionsCard
                
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
                    Image(systemName: "bell.badge.fill")
                        .foregroundColor(Theme.gaugeYellow)
                    Text("Notificari")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .onAppear { notifManager.refreshPendingNotifications() }
    }
    
    private var statusCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill((notifManager.isAuthorized ? Theme.gaugeGreen : Theme.gaugeRed).opacity(0.15))
                    .frame(width: 60, height: 60)
                Image(systemName: notifManager.isAuthorized ? "bell.badge.fill" : "bell.slash.fill")
                    .font(.system(size: 26))
                    .foregroundColor(notifManager.isAuthorized ? Theme.gaugeGreen : Theme.gaugeRed)
            }
            
            Text(notifManager.isAuthorized ? "Notificari Active" : "Notificari Dezactivate")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            if !notifManager.isAuthorized {
                Button(action: { notifManager.requestAuthorization() }) {
                    Text("Activeaza Notificarile")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Theme.primary)
                        .cornerRadius(10)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TIPURI NOTIFICARI")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            notifToggle(title: "Alarme Service", subtitle: "Cand se apropie revizia", icon: "wrench.fill", color: Theme.primary, binding: $notifManager.notificationSettings.serviceAlerts)
            notifToggle(title: "Reminder ITP", subtitle: "30 zile inainte de expirare", icon: "shield.checkered", color: Theme.gaugeRed, binding: $notifManager.notificationSettings.itpReminder)
            notifToggle(title: "Reminder RCA", subtitle: "30 zile inainte de expirare", icon: "shield.fill", color: Color(red: 0.2, green: 0.5, blue: 0.9), binding: $notifManager.notificationSettings.rcaReminder)
            notifToggle(title: "Raport Saptamanal", subtitle: "Duminica la 10:00", icon: "chart.bar.fill", color: Theme.gaugeGreen, binding: $notifManager.notificationSettings.weeklyReport)
            notifToggle(title: "Alerte DTC", subtitle: "Erori motor detectate", icon: "exclamationmark.triangle.fill", color: Theme.gaugeYellow, binding: $notifManager.notificationSettings.dtcAlerts)
            notifToggle(title: "Reminder Alimentare", subtitle: "Inregistreaza consumul", icon: "fuelpump.fill", color: Color(red: 0.0, green: 0.8, blue: 0.6), binding: $notifManager.notificationSettings.fuelReminder)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func notifToggle(title: String, subtitle: String, icon: String, color: Color, binding: Binding<Bool>) -> some View {
        Toggle(isOn: binding) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(color)
                    .frame(width: 26, height: 26)
                    .background(color.opacity(0.15))
                    .cornerRadius(7)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)
                }
            }
        }
        .tint(Theme.primary)
    }
    
    private var pendingCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NOTIFICARI PROGRAMATE (\(notifManager.pendingNotifications.count))")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            if notifManager.pendingNotifications.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.textMuted)
                        Text("Nicio notificare programata")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(.vertical, 16)
                    Spacer()
                }
            } else {
                ForEach(notifManager.pendingNotifications.prefix(5), id: \.identifier) { notif in
                    HStack(spacing: 8) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.gaugeYellow)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(notif.content.title)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                            Text(notif.content.body)
                                .font(.system(size: 9))
                                .foregroundColor(Theme.textMuted)
                                .lineLimit(1)
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
    
    private var actionsCard: some View {
        VStack(spacing: 8) {
            Button(action: {
                notifManager.scheduleServiceAlert(serviceName: "Ulei Motor", daysUntilDue: 30, vehicleName: vehicleManager.currentVehicle.displayName)
                notifManager.refreshPendingNotifications()
            }) {
                HStack {
                    Image(systemName: "bell.badge.fill")
                    Text("Programeaza Alerta Test")
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.primary.opacity(0.1))
                .cornerRadius(10)
            }
            
            Button(action: {
                notifManager.cancelAllNotifications()
                notifManager.refreshPendingNotifications()
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Sterge Toate Notificarile")
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.gaugeRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.gaugeRed.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
}
