import Foundation
import UserNotifications
import SwiftUI

// MARK: - Maintenance Alarm Model
struct MaintenanceAlarm: Codable, Identifiable {
    var id = UUID()
    var componentName: String
    var icon: String
    var lastServiceDate: Date
    var lastServiceMileage: Int
    var intervalMonths: Int
    var intervalKm: Int
    var isEnabled: Bool
    var vehicleId: UUID
    
    var nextServiceDate: Date {
        Calendar.current.date(byAdding: .month, value: intervalMonths, to: lastServiceDate) ?? lastServiceDate
    }
    
    var nextServiceMileage: Int {
        lastServiceMileage + intervalKm
    }
    
    func daysRemaining() -> Int {
        Calendar.current.dateComponents([.day], from: Date(), to: nextServiceDate).day ?? 0
    }
    
    func kmRemaining(currentMileage: Int) -> Int {
        nextServiceMileage - currentMileage
    }
    
    func urgencyColor(currentMileage: Int) -> Color {
        let days = daysRemaining()
        let km = kmRemaining(currentMileage: currentMileage)
        if days <= 0 || km <= 0 { return Theme.gaugeRed }
        if days <= 30 || km <= 2000 { return Theme.gaugeYellow }
        return Theme.gaugeGreen
    }
    
    func urgencyLabel(currentMileage: Int) -> String {
        let days = daysRemaining()
        let km = kmRemaining(currentMileage: currentMileage)
        if days <= 0 || km <= 0 { return "DEPASIT" }
        if days <= 7 || km <= 500 { return "URGENT" }
        if days <= 30 || km <= 2000 { return "CURAND" }
        return "OK"
    }
    
    static var sampleAlarms: [MaintenanceAlarm] {
        [
            MaintenanceAlarm(componentName: "Schimb Ulei Motor", icon: "drop.fill", lastServiceDate: Date().addingTimeInterval(-86400 * 300), lastServiceMileage: 110000, intervalMonths: 12, intervalKm: 15000, isEnabled: true, vehicleId: UUID()),
            MaintenanceAlarm(componentName: "Filtru Aer", icon: "wind", lastServiceDate: Date().addingTimeInterval(-86400 * 200), lastServiceMileage: 115000, intervalMonths: 12, intervalKm: 20000, isEnabled: true, vehicleId: UUID()),
            MaintenanceAlarm(componentName: "Placute Frana", icon: "circle.circle", lastServiceDate: Date().addingTimeInterval(-86400 * 400), lastServiceMileage: 100000, intervalMonths: 24, intervalKm: 30000, isEnabled: true, vehicleId: UUID()),
            MaintenanceAlarm(componentName: "Lichid Frana", icon: "drop.triangle.fill", lastServiceDate: Date().addingTimeInterval(-86400 * 600), lastServiceMileage: 95000, intervalMonths: 24, intervalKm: 40000, isEnabled: true, vehicleId: UUID()),
            MaintenanceAlarm(componentName: "Curele Distributie", icon: "gearshape.2.fill", lastServiceDate: Date().addingTimeInterval(-86400 * 500), lastServiceMileage: 90000, intervalMonths: 48, intervalKm: 120000, isEnabled: true, vehicleId: UUID()),
            MaintenanceAlarm(componentName: "ITP", icon: "checkmark.seal.fill", lastServiceDate: Date().addingTimeInterval(-86400 * 340), lastServiceMileage: 120000, intervalMonths: 12, intervalKm: 999999, isEnabled: true, vehicleId: UUID()),
            MaintenanceAlarm(componentName: "RCA Asigurare", icon: "shield.fill", lastServiceDate: Date().addingTimeInterval(-86400 * 330), lastServiceMileage: 120000, intervalMonths: 12, intervalKm: 999999, isEnabled: true, vehicleId: UUID()),
            MaintenanceAlarm(componentName: "Anvelope Vara/Iarna", icon: "circle.grid.cross.fill", lastServiceDate: Date().addingTimeInterval(-86400 * 150), lastServiceMileage: 118000, intervalMonths: 6, intervalKm: 999999, isEnabled: true, vehicleId: UUID()),
        ]
    }
}

// MARK: - Maintenance Alarm Manager
class MaintenanceAlarmManager: ObservableObject {
    @Published var alarms: [MaintenanceAlarm] = MaintenanceAlarm.sampleAlarms
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if granted {
                DispatchQueue.main.async {
                    self?.scheduleNotifications()
                }
            }
        }
    }
    
    func scheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for alarm in alarms where alarm.isEnabled {
            let content = UNMutableNotificationContent()
            content.title = "AutoDiag Pro - Intretinere"
            content.body = "\(alarm.componentName) necesita atentie! Programati o vizita la service."
            content.sound = .default
            
            let days = alarm.daysRemaining()
            if days > 0 && days <= 30 {
                let triggerDate = Calendar.current.date(byAdding: .day, value: -7, to: alarm.nextServiceDate) ?? Date()
                guard triggerDate > Date() else { continue }
                let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: triggerDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                
                let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    func toggleAlarm(_ alarm: MaintenanceAlarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].isEnabled.toggle()
            scheduleNotifications()
        }
    }
}
