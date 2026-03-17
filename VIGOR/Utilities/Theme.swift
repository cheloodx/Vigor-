import Foundation
import SwiftUI

// MARK: - Kamasutra Guide Theme
struct Theme {
    // MARK: - Primary Colors (Rose/Pink)
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "FF6B8A"), Color(hex: "C44569")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [Color(hex: "1A1A2E"), Color(hex: "16213E"), Color(hex: "0F3460")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color(hex: "1E1E3F").opacity(0.8), Color(hex: "2D2D5F").opacity(0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Colors
    static let primary = Color(hex: "FF6B8A")
    static let secondary = Color(hex: "C44569")
    static let accent = Color(hex: "A855F7")
    static let background = Color(hex: "1A1A2E")
    static let cardBackground = Color(hex: "1E1E3F")
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textMuted = Color.white.opacity(0.5)
    
    // MARK: - Category Colors
    static func categoryColor(_ category: PositionCategory) -> Color {
        switch category {
        case .romantic: return Color(hex: "FF6B6B")
        case .passionate: return Color(hex: "FF6348")
        case .adventurous: return Color(hex: "A55EEA")
        case .intimate: return Color(hex: "FC5C7D")
        }
    }
    
    static func categoryGradient(_ category: PositionCategory) -> LinearGradient {
        switch category {
        case .romantic:
            return LinearGradient(colors: [Color(hex: "FF6B6B"), Color(hex: "EE5A24")], startPoint: .leading, endPoint: .trailing)
        case .passionate:
            return LinearGradient(colors: [Color(hex: "FF6348"), Color(hex: "EE5A24")], startPoint: .leading, endPoint: .trailing)
        case .adventurous:
            return LinearGradient(colors: [Color(hex: "A55EEA"), Color(hex: "8854D0")], startPoint: .leading, endPoint: .trailing)
        case .intimate:
            return LinearGradient(colors: [Color(hex: "FC5C7D"), Color(hex: "6A82FB")], startPoint: .leading, endPoint: .trailing)
        }
    }
    
    // MARK: - Difficulty Colors
    static func difficultyColor(_ difficulty: Difficulty) -> Color {
        switch difficulty {
        case .beginner: return Color(hex: "4CAF50")
        case .intermediate: return Color(hex: "FF9800")
        case .advanced: return Color(hex: "F44336")
        case .expert: return Color(hex: "9C27B0")
        }
    }
    
    // MARK: - Intimacy Hearts
    static func intimacyColor(level: Int) -> Color {
        if level >= 4 { return Color(hex: "FF6B8A") }
        if level >= 3 { return Color(hex: "FF9800") }
        return Color(hex: "78909C")
    }
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
