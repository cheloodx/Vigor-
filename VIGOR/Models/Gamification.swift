import Foundation
import SwiftUI

// MARK: - Item Rarity
enum ItemRarity: String, CaseIterable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: Color {
        switch self {
        case .common: return Theme.rarityCommon
        case .rare: return Theme.rarityRare
        case .epic: return Theme.rarityEpic
        case .legendary: return Theme.rarityLegendary
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .common:
            return LinearGradient(colors: [Color(hex: "9E9E9E"), Color(hex: "757575")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .rare:
            return LinearGradient(colors: [Color(hex: "42A5F5"), Color(hex: "1565C0")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .epic:
            return LinearGradient(colors: [Color(hex: "CE93D8"), Color(hex: "7B1FA2")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .legendary:
            return LinearGradient(colors: [Color(hex: "FFD700"), Color(hex: "FF8C00"), Color(hex: "FF6347")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    var label: String {
        switch self {
        case .common: return "Common"
        case .rare: return "Rare"
        case .epic: return "Epic"
        case .legendary: return "Legendary"
        }
    }
}

// MARK: - Virtual Item
struct VirtualItem: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var icon: String
    var rarity: ItemRarity
    var category: ItemCategory
    var isEquipped: Bool
    var acquiredDate: Date?
    
    enum ItemCategory: String, CaseIterable {
        case badge = "Badges"
        case equipment = "Equipment"
        case avatar = "Avatar"
        case effect = "Effects"
        
        var icon: String {
            switch self {
            case .badge: return "star.circle.fill"
            case .equipment: return "tshirt.fill"
            case .avatar: return "person.crop.circle.fill"
            case .effect: return "sparkles"
            }
        }
    }
    
    static let samples: [VirtualItem] = [
        VirtualItem(id: UUID(), name: "Golden Shirt", description: "Legendary equipment for avatar", icon: "tshirt.fill", rarity: .legendary, category: .equipment, isEquipped: true, acquiredDate: Date().addingTimeInterval(-86400 * 5)),
        VirtualItem(id: UUID(), name: "Marathon Medal", description: "For completing 26 workouts", icon: "medal.fill", rarity: .epic, category: .badge, isEquipped: false, acquiredDate: Date().addingTimeInterval(-86400 * 10)),
        VirtualItem(id: UUID(), name: "Speed Shoes", description: "Rare equipment for avatar", icon: "shoe.fill", rarity: .rare, category: .equipment, isEquipped: true, acquiredDate: Date().addingTimeInterval(-86400 * 3)),
        VirtualItem(id: UUID(), name: "Pro Headphones", description: "Audio equipment for workouts", icon: "headphones", rarity: .common, category: .equipment, isEquipped: false, acquiredDate: Date().addingTimeInterval(-86400 * 1)),
        VirtualItem(id: UUID(), name: "Golden Dumbbells", description: "Legendary collectible item", icon: "dumbbell.fill", rarity: .legendary, category: .equipment, isEquipped: false, acquiredDate: Date().addingTimeInterval(-86400 * 2)),
        VirtualItem(id: UUID(), name: "Legend Badge", description: "For the most dedicated users", icon: "star.fill", rarity: .legendary, category: .badge, isEquipped: true, acquiredDate: Date().addingTimeInterval(-86400 * 7)),
        VirtualItem(id: UUID(), name: "Energy Aura", description: "Epic visual effect", icon: "sparkles", rarity: .epic, category: .effect, isEquipped: false, acquiredDate: Date().addingTimeInterval(-86400 * 4)),
        VirtualItem(id: UUID(), name: "Warrior Avatar", description: "Rare avatar frame", icon: "person.crop.circle.badge.checkmark", rarity: .rare, category: .avatar, isEquipped: true, acquiredDate: Date().addingTimeInterval(-86400 * 6)),
    ]
}

// MARK: - Surprise Package (Crate)
struct SurprisePackage: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var icon: String
    var cost: Int
    var tier: PackageTier
    var possibleItems: [String]
    
    enum PackageTier: String, CaseIterable {
        case basic = "Basic Crate"
        case elite = "Elite Chest"
        case legendary = "Legendary Vault"
        
        var color: Color {
            switch self {
            case .basic: return Theme.rarityCommon
            case .elite: return Theme.rarityEpic
            case .legendary: return Theme.rarityLegendary
            }
        }
        
        var gradient: LinearGradient {
            switch self {
            case .basic:
                return LinearGradient(colors: [Color(hex: "9E9E9E"), Color(hex: "616161")], startPoint: .top, endPoint: .bottom)
            case .elite:
                return LinearGradient(colors: [Color(hex: "CE93D8"), Color(hex: "7B1FA2")], startPoint: .top, endPoint: .bottom)
            case .legendary:
                return LinearGradient(colors: [Color(hex: "FFD700"), Color(hex: "FF8C00"), Color(hex: "FF4500")], startPoint: .top, endPoint: .bottom)
            }
        }
    }
    
    static let samples: [SurprisePackage] = [
        SurprisePackage(id: UUID(), name: "Basic Crate", description: "An affordable option to start your collection", icon: "shippingbox.fill", cost: 100, tier: .basic, possibleItems: ["Common Badges", "Common Equipment", "Common Effects"]),
        SurprisePackage(id: UUID(), name: "Elite Chest", description: "Higher chances for rare and epic items", icon: "lock.shield.fill", cost: 300, tier: .elite, possibleItems: ["Rare/Epic Badges", "Rare/Epic Equipment", "Rare Effects"]),
        SurprisePackage(id: UUID(), name: "Legendary Vault", description: "Guaranteed elite item for true champions", icon: "crown.fill", cost: 750, tier: .legendary, possibleItems: ["Legendary Badges", "Legendary Equipment", "Epic/Legendary Effects"]),
    ]
}

// MARK: - Daily Reward
struct DailyReward: Identifiable {
    let id: UUID
    var day: Int
    var points: Int
    var bonusItem: String?
    var isClaimed: Bool
    var isToday: Bool
    
    static func weeklyRewards(currentDay: Int) -> [DailyReward] {
        return [
            DailyReward(id: UUID(), day: 1, points: 10, bonusItem: nil, isClaimed: currentDay > 1, isToday: currentDay == 1),
            DailyReward(id: UUID(), day: 2, points: 15, bonusItem: nil, isClaimed: currentDay > 2, isToday: currentDay == 2),
            DailyReward(id: UUID(), day: 3, points: 20, bonusItem: nil, isClaimed: currentDay > 3, isToday: currentDay == 3),
            DailyReward(id: UUID(), day: 4, points: 25, bonusItem: nil, isClaimed: currentDay > 4, isToday: currentDay == 4),
            DailyReward(id: UUID(), day: 5, points: 30, bonusItem: "Streak Badge", isClaimed: currentDay > 5, isToday: currentDay == 5),
            DailyReward(id: UUID(), day: 6, points: 40, bonusItem: nil, isClaimed: currentDay > 6, isToday: currentDay == 6),
            DailyReward(id: UUID(), day: 7, points: 75, bonusItem: "Basic Crate", isClaimed: false, isToday: currentDay == 7),
        ]
    }
}

// MARK: - Daily Mission
struct DailyMission: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var icon: String
    var reward: Int
    var progress: Double
    var isCompleted: Bool
    
    static let samples: [DailyMission] = [
        DailyMission(id: UUID(), title: "Daily Workout", description: "Complete a workout", icon: "dumbbell.fill", reward: 20, progress: 1.0, isCompleted: true),
        DailyMission(id: UUID(), title: "Log Meals", description: "Log 3 meals", icon: "fork.knife", reward: 15, progress: 0.66, isCompleted: false),
        DailyMission(id: UUID(), title: "Hydration", description: "Drink 3 liters of water", icon: "drop.fill", reward: 10, progress: 0.5, isCompleted: false),
        DailyMission(id: UUID(), title: "Social Butterfly", description: "Leave 3 comments", icon: "bubble.left.fill", reward: 10, progress: 0.33, isCompleted: false),
    ]
}

// MARK: - FitPoints Transaction
struct FitPointsTransaction: Identifiable {
    let id: UUID
    var description: String
    var amount: Int
    var isCredit: Bool
    var date: Date
    var icon: String
    
    static let samples: [FitPointsTransaction] = [
        FitPointsTransaction(id: UUID(), description: "Workout completed", amount: 50, isCredit: true, date: Date(), icon: "dumbbell.fill"),
        FitPointsTransaction(id: UUID(), description: "Daily bonus", amount: 25, isCredit: true, date: Date().addingTimeInterval(-86400), icon: "gift.fill"),
        FitPointsTransaction(id: UUID(), description: "Elite Chest purchased", amount: 300, isCredit: false, date: Date().addingTimeInterval(-86400 * 2), icon: "shippingbox.fill"),
        FitPointsTransaction(id: UUID(), description: "Gift sent: Medal", amount: 150, isCredit: false, date: Date().addingTimeInterval(-86400 * 3), icon: "gift.fill"),
        FitPointsTransaction(id: UUID(), description: "Challenge completed", amount: 100, isCredit: true, date: Date().addingTimeInterval(-86400 * 4), icon: "trophy.fill"),
        FitPointsTransaction(id: UUID(), description: "Daily mission", amount: 15, isCredit: true, date: Date().addingTimeInterval(-86400 * 5), icon: "checkmark.circle.fill"),
    ]
}
