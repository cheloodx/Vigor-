import SwiftUI

struct MaintenanceAlarmsView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var alarmManager = MaintenanceAlarmManager()
    @State private var showAddAlarm = false
    
    var sortedAlarms: [MaintenanceAlarm] {
        let mileage = vehicleManager.currentVehicle.mileage
        return alarmManager.alarms.sorted { a, b in
            let urgencyA = min(a.daysRemaining(), a.kmRemaining(currentMileage: mileage))
            let urgencyB = min(b.daysRemaining(), b.kmRemaining(currentMileage: mileage))
            return urgencyA < urgencyB
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Summary
                    alarmSummary
                    
                    // Alarm list
                    ForEach(sortedAlarms) { alarm in
                        alarmCard(alarm)
                    }
                    
                    // Add alarm button
                    Button(action: { showAddAlarm = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                            Text("Adauga Alarma")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.surfaceBackground)
                        .foregroundColor(Theme.primary)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
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
                        Image(systemName: "bell.badge.fill")
                            .foregroundColor(Theme.primary)
                        Text(localization.t("service.calendar"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .onAppear { alarmManager.requestNotificationPermission() }
        }
    }
    
    // MARK: - Alarm Summary
    private var alarmSummary: some View {
        let mileage = vehicleManager.currentVehicle.mileage
        let overdue = alarmManager.alarms.filter { $0.daysRemaining() <= 0 || $0.kmRemaining(currentMileage: mileage) <= 0 }.count
        let upcoming = alarmManager.alarms.filter { $0.daysRemaining() > 0 && $0.kmRemaining(currentMileage: mileage) > 0 && ($0.daysRemaining() <= 30 || $0.kmRemaining(currentMileage: mileage) <= 2000) }.count
        let ok = alarmManager.alarms.count - overdue - upcoming
        
        return HStack(spacing: 8) {
            alarmStatBox(value: "\(overdue)", label: "Depasite", color: Theme.gaugeRed, icon: "exclamationmark.circle.fill")
            alarmStatBox(value: "\(upcoming)", label: "Curand", color: Theme.gaugeYellow, icon: "clock.fill")
            alarmStatBox(value: "\(ok)", label: "OK", color: Theme.gaugeGreen, icon: "checkmark.circle.fill")
        }
    }
    
    private func alarmStatBox(value: String, label: String, color: Color, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.cardBackground)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.2), lineWidth: 1))
    }
    
    // MARK: - Alarm Card
    private func alarmCard(_ alarm: MaintenanceAlarm) -> some View {
        let mileage = vehicleManager.currentVehicle.mileage
        let days = alarm.daysRemaining()
        let km = alarm.kmRemaining(currentMileage: mileage)
        let color = alarm.urgencyColor(currentMileage: mileage)
        let urgency = alarm.urgencyLabel(currentMileage: mileage)
        
        return HStack(spacing: 12) {
            // Icon
            Image(systemName: alarm.icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.15))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(alarm.componentName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    // Urgency badge
                    Text(urgency)
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(color.opacity(0.2))
                        .foregroundColor(color)
                        .cornerRadius(4)
                }
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 9))
                        Text(days > 0 ? "\(days) zile ramase" : "Depasit cu \(abs(days)) zile")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(days <= 0 ? Theme.gaugeRed : Theme.textSecondary)
                    
                    if alarm.intervalKm < 999999 {
                        HStack(spacing: 4) {
                            Image(systemName: "speedometer")
                                .font(.system(size: 9))
                            Text(km > 0 ? "\(km) km ramasi" : "Depasit cu \(abs(km)) km")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(km <= 0 ? Theme.gaugeRed : Theme.textSecondary)
                    }
                }
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                        RoundedRectangle(cornerRadius: 2)
                            .fill(color)
                            .frame(width: geo.size.width * progressValue(alarm))
                    }
                }
                .frame(height: 4)
            }
            
            // Toggle
            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { _ in alarmManager.toggleAlarm(alarm) }
            ))
            .labelsHidden()
            .tint(Theme.primary)
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(color.opacity(0.2), lineWidth: 1))
    }
    
    private func progressValue(_ alarm: MaintenanceAlarm) -> CGFloat {
        let mileage = vehicleManager.currentVehicle.mileage
        let days = alarm.daysRemaining()
        let totalDays = alarm.intervalMonths * 30
        let dayProgress = totalDays > 0 ? CGFloat(totalDays - days) / CGFloat(totalDays) : 1.0
        
        let km = alarm.kmRemaining(currentMileage: mileage)
        let kmProgress = alarm.intervalKm > 0 ? CGFloat(alarm.intervalKm - km) / CGFloat(alarm.intervalKm) : 0
        
        return min(1.0, max(0.0, max(dayProgress, kmProgress)))
    }
}
