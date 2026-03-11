import SwiftUI

struct WatchSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var settings = WatchSettings()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Watch Connection
                    watchConnectionSection
                    
                    // Notifications
                    notificationsSection
                    
                    // Health Settings
                    healthSection
                    
                    // Display
                    displaySection
                    
                    // Workout Detection
                    workoutSection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Watch Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Theme.primary)
                }
            }
        }
    }
    
    private var watchConnectionSection: some View {
        CardView {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Theme.success.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: "applewatch")
                        .font(.system(size: 22))
                        .foregroundColor(Theme.success)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Apple Watch Connected")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    Text("Series 9 • Battery 78%")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Circle()
                    .fill(Theme.success)
                    .frame(width: 10, height: 10)
            }
        }
    }
    
    private var notificationsSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Notifications")
            
            CardView {
                VStack(spacing: 16) {
                    settingToggle(title: "Heart Rate Alerts", icon: "heart.fill", color: .red, isOn: $settings.heartRateAlerts)
                    Divider().background(Theme.textTertiary.opacity(0.3))
                    settingToggle(title: "Workout Reminders", icon: "dumbbell.fill", color: Theme.primary, isOn: $settings.workoutReminders)
                    Divider().background(Theme.textTertiary.opacity(0.3))
                    settingToggle(title: "Community Notifications", icon: "person.2.fill", color: .blue, isOn: $settings.communityNotifications)
                    Divider().background(Theme.textTertiary.opacity(0.3))
                    settingToggle(title: "Achievement Alerts", icon: "trophy.fill", color: Theme.accent, isOn: $settings.achievementAlerts)
                }
            }
        }
    }
    
    private var healthSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Health")
            
            CardView {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 18))
                            .foregroundColor(.green)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Daily Steps Goal")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                            Text("\(settings.stepGoal) steps")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        Stepper("", value: $settings.stepGoal, in: 5000...20000, step: 1000)
                            .labelsHidden()
                    }
                    
                    Divider().background(Theme.textTertiary.opacity(0.3))
                    
                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Heart Rate Threshold")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                            Text("\(settings.heartRateThreshold) BPM")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        Stepper("", value: $settings.heartRateThreshold, in: 120...200, step: 5)
                            .labelsHidden()
                    }
                }
            }
        }
    }
    
    private var displaySection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Display")
            
            CardView {
                VStack(spacing: 16) {
                    settingToggle(title: "Haptic Feedback", icon: "hand.tap.fill", color: .purple, isOn: $settings.hapticFeedback)
                    Divider().background(Theme.textTertiary.opacity(0.3))
                    settingToggle(title: "Always On Display", icon: "sun.max.fill", color: .yellow, isOn: $settings.alwaysOnDisplay)
                }
            }
        }
    }
    
    private var workoutSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Workout")
            
            CardView {
                VStack(spacing: 16) {
                    settingToggle(title: "Auto Workout Detection", icon: "figure.run", color: .green, isOn: $settings.autoWorkoutDetection)
                    
                    Divider().background(Theme.textTertiary.opacity(0.3))
                    
                    HStack {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Theme.primary)
                            .frame(width: 30)
                        
                        Text("Reminder Time")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Spacer()
                        
                        DatePicker("", selection: $settings.reminderTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
            }
        }
    }
    
    private func settingToggle(title: String, icon: String, color: Color, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Theme.primary)
        }
    }
}
