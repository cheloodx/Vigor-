import Foundation
import SwiftUI

struct CommunityPost: Identifiable {
    let id: UUID
    var author: String
    var authorAvatar: String
    var content: String
    var imageSystemName: String?
    var likes: Int
    var comments: Int
    var timeAgo: String
    var isLiked: Bool
    var category: PostCategory
    
    enum PostCategory: String, CaseIterable {
        case workout = "Workout"
        case progress = "Progress"
        case nutrition = "Nutrition"
        case motivation = "Motivation"
        case challenge = "Challenge"
        
        var color: Color {
            switch self {
            case .workout: return Theme.primary
            case .progress: return .green
            case .nutrition: return .orange
            case .motivation: return .purple
            case .challenge: return .red
            }
        }
    }
    
    static let samples: [CommunityPost] = [
        CommunityPost(id: UUID(), author: "Maria P.", authorAvatar: "person.circle.fill", content: "Just finished the 30-day challenge! 💪 Best workout program I've ever followed!", imageSystemName: "figure.strengthtraining.traditional", likes: 42, comments: 8, timeAgo: "2h", isLiked: true, category: .progress),
        CommunityPost(id: UUID(), author: "Alex I.", authorAvatar: "person.circle.fill", content: "My favorite post-workout recipe: Protein shake with banana, peanut butter and almond milk. Try it!", imageSystemName: "cup.and.saucer.fill", likes: 28, comments: 15, timeAgo: "4h", isLiked: false, category: .nutrition),
        CommunityPost(id: UUID(), author: "Elena D.", authorAvatar: "person.circle.fill", content: "Who wants to join this week's plank challenge? 🔥", imageSystemName: nil, likes: 56, comments: 23, timeAgo: "6h", isLiked: true, category: .challenge),
        CommunityPost(id: UUID(), author: "Andrew M.", authorAvatar: "person.circle.fill", content: "It doesn't matter how slow you go, as long as you don't stop. Keep pushing! 🏋️", imageSystemName: nil, likes: 89, comments: 12, timeAgo: "8h", isLiked: false, category: .motivation),
        CommunityPost(id: UUID(), author: "Chris V.", authorAvatar: "person.circle.fill", content: "New squat PR: 100kg! From 60kg in 3 months with the Max Power program. Thanks VIGOR!", imageSystemName: "trophy.fill", likes: 134, comments: 31, timeAgo: "12h", isLiked: true, category: .progress),
    ]
}

struct VideoCallParticipant: Identifiable {
    let id: UUID
    var name: String
    var avatarSystemName: String
    var isMuted: Bool
    var isVideoOn: Bool
    var isHost: Bool
    
    static let samples: [VideoCallParticipant] = [
        VideoCallParticipant(id: UUID(), name: "You", avatarSystemName: "person.circle.fill", isMuted: false, isVideoOn: true, isHost: false),
        VideoCallParticipant(id: UUID(), name: "Maria P.", avatarSystemName: "person.circle.fill", isMuted: false, isVideoOn: true, isHost: true),
        VideoCallParticipant(id: UUID(), name: "Alex I.", avatarSystemName: "person.circle.fill", isMuted: true, isVideoOn: true, isHost: false),
        VideoCallParticipant(id: UUID(), name: "Elena D.", avatarSystemName: "person.circle.fill", isMuted: false, isVideoOn: false, isHost: false),
    ]
}

struct VirtualGift: Identifiable {
    let id: UUID
    var name: String
    var icon: String
    var cost: Int
    var description: String
    var rarity: ItemRarity
    
    static let samples: [VirtualGift] = [
        VirtualGift(id: UUID(), name: "Protein Shake", icon: "cup.and.saucer.fill", cost: 50, description: "Send a virtual protein shake!", rarity: .common),
        VirtualGift(id: UUID(), name: "Gold Medal", icon: "medal.fill", cost: 150, description: "Reward exceptional performance!", rarity: .rare),
        VirtualGift(id: UUID(), name: "Fitness Badge", icon: "star.circle.fill", cost: 100, description: "A badge for dedication!", rarity: .rare),
        VirtualGift(id: UUID(), name: "Champion Trophy", icon: "trophy.fill", cost: 300, description: "For true champions!", rarity: .epic),
        VirtualGift(id: UUID(), name: "Legendary Crown", icon: "crown.fill", cost: 500, description: "The most prestigious gift!", rarity: .legendary),
    ]
}

struct ChatMessage: Identifiable {
    let id: UUID
    var author: String
    var content: String
    var timestamp: Date
    var isCurrentUser: Bool
    
    static let samples: [ChatMessage] = [
        ChatMessage(id: UUID(), author: "Maria P.", content: "Let's start the warm-up! 🔥", timestamp: Date().addingTimeInterval(-300), isCurrentUser: false),
        ChatMessage(id: UUID(), author: "You", content: "I'm ready! 💪", timestamp: Date().addingTimeInterval(-240), isCurrentUser: true),
        ChatMessage(id: UUID(), author: "Alex I.", content: "One more set and we're done!", timestamp: Date().addingTimeInterval(-120), isCurrentUser: false),
        ChatMessage(id: UUID(), author: "Elena D.", content: "Great job everyone!", timestamp: Date().addingTimeInterval(-60), isCurrentUser: false),
    ]
}
