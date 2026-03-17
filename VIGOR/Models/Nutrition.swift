import Foundation
import SwiftUI

// MARK: - Romantic Quote
struct RomanticQuote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
    let category: QuoteCategory
}

enum QuoteCategory: String, CaseIterable {
    case love = "Dragoste"
    case passion = "Pasiune"
    case romance = "Romantism"
    case wisdom = "Intelepciune"
    case humor = "Umor"
    
    var icon: String {
        switch self {
        case .love: return "heart.fill"
        case .passion: return "flame.fill"
        case .romance: return "sparkles"
        case .wisdom: return "brain.head.profile"
        case .humor: return "face.smiling.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .love: return Color(hex: "FF6B8A")
        case .passion: return Color(hex: "FF6348")
        case .romance: return Color(hex: "A55EEA")
        case .wisdom: return Color(hex: "4FC3F7")
        case .humor: return Color(hex: "FFB74D")
        }
    }
}

// MARK: - Mood Entry
struct MoodEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let mood: Int
    let intimacy: Int
    let note: String
    
    init(id: UUID = UUID(), date: Date = Date(), mood: Int, intimacy: Int, note: String = "") {
        self.id = id
        self.date = date
        self.mood = mood
        self.intimacy = intimacy
        self.note = note
    }
    
    var moodEmoji: String {
        switch mood {
        case 1: return "\u{1F614}"
        case 2: return "\u{1F610}"
        case 3: return "\u{1F642}"
        case 4: return "\u{1F60A}"
        case 5: return "\u{1F60D}"
        default: return "\u{1F642}"
        }
    }
}

// MARK: - Bucket List Item
struct BucketListItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    var isCompleted: Bool
    let category: String
    
    init(id: UUID = UUID(), title: String, description: String, icon: String, isCompleted: Bool = false, category: String) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.isCompleted = isCompleted
        self.category = category
    }
}

// MARK: - Date Night Idea
struct DateNightIdea: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let category: String
    let budget: String
    let duration: String
}

// MARK: - Badge/Achievement
struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let requirement: String
    let color1: String
    let color2: String
    
    var gradient: LinearGradient {
        LinearGradient(colors: [Color(hex: color1), Color(hex: color2)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// MARK: - Love Language
struct LoveLanguageQuestion: Identifiable {
    let id = UUID()
    let optionA: String
    let optionB: String
    let languageA: LoveLanguage
    let languageB: LoveLanguage
}

enum LoveLanguage: String, CaseIterable {
    case wordsOfAffirmation = "Cuvinte de Afirmare"
    case actsOfService = "Acte de Serviciu"
    case receivingGifts = "Primirea Cadourilor"
    case qualityTime = "Timp de Calitate"
    case physicalTouch = "Atingere Fizica"
    
    var icon: String {
        switch self {
        case .wordsOfAffirmation: return "text.bubble.fill"
        case .actsOfService: return "hands.sparkles.fill"
        case .receivingGifts: return "gift.fill"
        case .qualityTime: return "clock.fill"
        case .physicalTouch: return "hand.raised.fill"
        }
    }
    
    var langDescription: String {
        switch self {
        case .wordsOfAffirmation: return "Te simti iubit/a cand partenerul iti spune lucruri frumoase, te complimenteaza si iti exprima aprecierea verbal."
        case .actsOfService: return "Te simti iubit/a cand partenerul face lucruri pentru tine - gateste, curata, te ajuta cu sarcinile zilnice."
        case .receivingGifts: return "Te simti iubit/a cand primesti cadouri atente care arata ca partenerul s-a gandit la tine."
        case .qualityTime: return "Te simti iubit/a cand petreceti timp de calitate impreuna, fara distractii, concentrati unul pe celalalt."
        case .physicalTouch: return "Te simti iubit/a prin atingere fizica - imbratisari, saruturi, tinutul de mana, proximitate fizica."
        }
    }
    
    var color: Color {
        switch self {
        case .wordsOfAffirmation: return Color(hex: "FF6B8A")
        case .actsOfService: return Color(hex: "4FC3F7")
        case .receivingGifts: return Color(hex: "FFB74D")
        case .qualityTime: return Color(hex: "A55EEA")
        case .physicalTouch: return Color(hex: "FF6348")
        }
    }
}

// MARK: - Compatibility Question
struct CompatibilityQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
}

// MARK: - Massage Timer Preset
struct MassagePreset: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int
    let icon: String
    let description: String
    let color1: String
    let color2: String
    
    var gradient: LinearGradient {
        LinearGradient(colors: [Color(hex: color1), Color(hex: color2)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// MARK: - Playlist
struct PlaylistRecommendation: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let mood: String
    let songs: [SongSuggestion]
    let color1: String
    let color2: String
    
    var gradient: LinearGradient {
        LinearGradient(colors: [Color(hex: color1), Color(hex: color2)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct SongSuggestion: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
}

// MARK: - Discover Feature Item
struct DiscoverFeature: Identifiable {
    let id: String
    let name: String
    let icon: String
    let description: String
    let color1: String
    let color2: String
    
    var gradient: LinearGradient {
        LinearGradient(colors: [Color(hex: color1), Color(hex: color2)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
