import Foundation

// MARK: - Position Model
struct Position: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let category: PositionCategory
    let difficulty: Difficulty
    let intimacy: Int
    let image: String
    let description: String
    let benefits: [String]
    let tips: [String]
    let variations: [String]
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Category
enum PositionCategory: String, Codable, CaseIterable {
    case romantic
    case passionate
    case adventurous
    case intimate
    
    var displayName: String {
        switch self {
        case .romantic: return "Romantic"
        case .passionate: return "Pasional"
        case .adventurous: return "Aventuros"
        case .intimate: return "Intim"
        }
    }
    
    var icon: String {
        switch self {
        case .romantic: return "heart.fill"
        case .passionate: return "flame.fill"
        case .adventurous: return "sparkles"
        case .intimate: return "lock.fill"
        }
    }
    
    var gradientColors: [String] {
        switch self {
        case .romantic: return ["FF6B6B", "EE5A24"]
        case .passionate: return ["FF6348", "EE5A24"]
        case .adventurous: return ["A55EEA", "8854D0"]
        case .intimate: return ["FC5C7D", "6A82FB"]
        }
    }
}

// MARK: - Difficulty
enum Difficulty: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
    case expert
    
    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        case .expert: return "Expert"
        }
    }
    
    var colorHex: String {
        switch self {
        case .beginner: return "4CAF50"
        case .intermediate: return "FF9800"
        case .advanced: return "F44336"
        case .expert: return "9C27B0"
        }
    }
}
