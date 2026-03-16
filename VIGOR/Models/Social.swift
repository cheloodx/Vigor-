import Foundation
import SwiftUI

// MARK: - Couple Game Model
struct CoupleGame: Identifiable {
    let id: String
    let name: String
    let icon: String
    let description: String
    let color1: String
    let color2: String
    let minPlayers: Int
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: color1), Color(hex: color2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Truth or Dare
enum TruthOrDareType: String, CaseIterable {
    case truth = "Adevar"
    case dare = "Provocare"
    
    var icon: String {
        switch self {
        case .truth: return "bubble.left.fill"
        case .dare: return "flame.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .truth: return Color(hex: "4FC3F7")
        case .dare: return Color(hex: "FF6B8A")
        }
    }
}

struct TruthOrDareCard: Identifiable {
    let id = UUID()
    let type: TruthOrDareType
    let text: String
    let intensity: Int // 1-5
}

// MARK: - Would You Rather
struct WouldYouRatherCard: Identifiable {
    let id = UUID()
    let optionA: String
    let optionB: String
    let category: String
}

// MARK: - Dice Game
struct DiceAction: Identifiable {
    let id = UUID()
    let action: String
    let bodyPart: String
    let duration: String
    let icon: String
}

// MARK: - Quiz
struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

// MARK: - Challenge Card
struct ChallengeCard: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let duration: String
    let difficulty: String
    let icon: String
}
