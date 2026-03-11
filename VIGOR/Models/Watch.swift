import Foundation
import SwiftUI

struct WatchNotification: Identifiable {
    let id: UUID
    var title: String
    var message: String
    var icon: String
    var type: NotificationType
    var time: String
    var isRead: Bool
    
    enum NotificationType: String, CaseIterable {
        case health = "Health"
        case workout = "Workout"
        case community = "Community"
        case achievement = "Achievement"
        
        var color: Color {
            switch self {
            case .health: return .red
            case .workout: return Theme.primary
            case .community: return .blue
            case .achievement: return Theme.accent
            }
        }
        
        var icon: String {
            switch self {
            case .health: return "heart.fill"
            case .workout: return "dumbbell.fill"
            case .community: return "person.2.fill"
            case .achievement: return "trophy.fill"
            }
        }
    }
    
    static let samples: [WatchNotification] = [
        WatchNotification(id: UUID(), title: "Health Alert", message: "Heart rate exceeded 160 BPM", icon: "heart.fill", type: .health, time: "Now", isRead: false),
        WatchNotification(id: UUID(), title: "Workout Reminder", message: "Time for your strength workout!", icon: "dumbbell.fill", type: .workout, time: "5 min", isRead: false),
        WatchNotification(id: UUID(), title: "New Comment", message: "Maria commented on your post", icon: "bubble.left.fill", type: .community, time: "15 min", isRead: true),
        WatchNotification(id: UUID(), title: "New Achievement!", message: "You unlocked the 'Iron Will' badge!", icon: "trophy.fill", type: .achievement, time: "1h", isRead: true),
        WatchNotification(id: UUID(), title: "Daily Steps", message: "You reached 8000 of 10000 steps", icon: "figure.walk", type: .health, time: "2h", isRead: true),
    ]
}

struct WatchSettings {
    var heartRateAlerts: Bool = true
    var workoutReminders: Bool = true
    var communityNotifications: Bool = true
    var achievementAlerts: Bool = true
    var stepGoal: Int = 10000
    var heartRateThreshold: Int = 160
    var reminderTime: Date = Calendar.current.date(from: DateComponents(hour: 18, minute: 0)) ?? Date()
    var hapticFeedback: Bool = true
    var alwaysOnDisplay: Bool = false
    var autoWorkoutDetection: Bool = true
}
