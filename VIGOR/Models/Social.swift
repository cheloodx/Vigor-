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
        case workout = "Antrenament"
        case progress = "Progres"
        case nutrition = "Nutritie"
        case motivation = "Motivatie"
        case challenge = "Provocare"
        
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
        CommunityPost(id: UUID(), author: "Maria Popescu", authorAvatar: "person.circle.fill", content: "Am terminat provocarea de 30 de zile! 💪 Cel mai bun program de antrenament pe care l-am urmat vreodata!", imageSystemName: "figure.strengthtraining.traditional", likes: 42, comments: 8, timeAgo: "2h", isLiked: true, category: .progress),
        CommunityPost(id: UUID(), author: "Alex Ionescu", authorAvatar: "person.circle.fill", content: "Reteta mea preferata post-antrenament: Shake proteic cu banana, unt de arahide si lapte de migdale. Incercati!", imageSystemName: "cup.and.saucer.fill", likes: 28, comments: 15, timeAgo: "4h", isLiked: false, category: .nutrition),
        CommunityPost(id: UUID(), author: "Elena Dumitrescu", authorAvatar: "person.circle.fill", content: "Cine vrea sa participe la provocarea de planks de saptamana asta? 🔥", imageSystemName: nil, likes: 56, comments: 23, timeAgo: "6h", isLiked: true, category: .challenge),
        CommunityPost(id: UUID(), author: "Andrei Marin", authorAvatar: "person.circle.fill", content: "Nu conteaza cat de incet mergi, atata timp cat nu te opresti. Continuati sa luptati! 🏋️", imageSystemName: nil, likes: 89, comments: 12, timeAgo: "8h", isLiked: false, category: .motivation),
        CommunityPost(id: UUID(), author: "Cristina Vasile", authorAvatar: "person.circle.fill", content: "PR nou la genuflexiuni: 100kg! De la 60kg in 3 luni cu programul Putere Maxima. Multumesc VIGOR!", imageSystemName: "trophy.fill", likes: 134, comments: 31, timeAgo: "12h", isLiked: true, category: .progress),
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
        VideoCallParticipant(id: UUID(), name: "Tu", avatarSystemName: "person.circle.fill", isMuted: false, isVideoOn: true, isHost: false),
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
        VirtualGift(id: UUID(), name: "Shake Proteic", icon: "cup.and.saucer.fill", cost: 50, description: "Trimite un shake proteic virtual!", rarity: .common),
        VirtualGift(id: UUID(), name: "Medalie de Aur", icon: "medal.fill", cost: 150, description: "Premiaza performanta exceptionala!", rarity: .rare),
        VirtualGift(id: UUID(), name: "Insigna Fitness", icon: "star.circle.fill", cost: 100, description: "O insigna pentru dedicatie!", rarity: .rare),
        VirtualGift(id: UUID(), name: "Trofeu Campion", icon: "trophy.fill", cost: 300, description: "Pentru adevaratii campioni!", rarity: .epic),
        VirtualGift(id: UUID(), name: "Coroana Legendara", icon: "crown.fill", cost: 500, description: "Cel mai prestigios cadou!", rarity: .legendary),
    ]
}

struct ChatMessage: Identifiable {
    let id: UUID
    var author: String
    var content: String
    var timestamp: Date
    var isCurrentUser: Bool
    
    static let samples: [ChatMessage] = [
        ChatMessage(id: UUID(), author: "Maria P.", content: "Hai sa incepem incalzirea! 🔥", timestamp: Date().addingTimeInterval(-300), isCurrentUser: false),
        ChatMessage(id: UUID(), author: "Tu", content: "Sunt gata! 💪", timestamp: Date().addingTimeInterval(-240), isCurrentUser: true),
        ChatMessage(id: UUID(), author: "Alex I.", content: "Inca un set si terminam!", timestamp: Date().addingTimeInterval(-120), isCurrentUser: false),
        ChatMessage(id: UUID(), author: "Elena D.", content: "Bravo tuturor!", timestamp: Date().addingTimeInterval(-60), isCurrentUser: false),
    ]
}
