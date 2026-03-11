import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var username: String
    var email: String
    var avatarURL: String?
    var level: Int
    var experience: Int
    var fitPoints: Int
    var dailyStreak: Int
    var totalWorkouts: Int
    var totalCaloriesBurned: Int
    var joinDate: Date
    var badges: [String]
    
    var experienceToNextLevel: Int {
        return level * 500
    }
    
    var levelProgress: Double {
        guard experienceToNextLevel > 0 else { return 0 }
        return min(Double(experience) / Double(experienceToNextLevel), 1.0)
    }
    
    static let sample = User(
        id: UUID(),
        name: "Ionut",
        username: "ionut_vigor",
        email: "ionut@vigor.app",
        avatarURL: nil,
        level: 12,
        experience: 3200,
        fitPoints: 2450,
        dailyStreak: 5,
        totalWorkouts: 87,
        totalCaloriesBurned: 42500,
        joinDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
        badges: ["Early Adopter", "Streak Master", "Iron Will"]
    )
}
