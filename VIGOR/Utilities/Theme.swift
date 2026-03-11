import SwiftUI

struct Theme {
    // MARK: - Colors
    static let primary = Color(hex: "FF8C00") // Orange
    static let primaryDark = Color(hex: "CC7000")
    static let primaryLight = Color(hex: "FFB347")
    static let accent = Color(hex: "FFD700") // Gold
    
    static let background = Color(hex: "0D0D0D")
    static let cardBackground = Color(hex: "1A1A1A")
    static let cardBackgroundLight = Color(hex: "242424")
    static let surfaceBackground = Color(hex: "2A2A2A")
    
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "B0B0B0")
    static let textTertiary = Color(hex: "707070")
    
    static let success = Color(hex: "4CAF50")
    static let warning = Color(hex: "FF9800")
    static let error = Color(hex: "F44336")
    static let info = Color(hex: "2196F3")
    
    // Rarity Colors
    static let rarityLegendary = Color(hex: "FF8C00")
    static let rarityEpic = Color(hex: "9C27B0")
    static let rarityRare = Color(hex: "2196F3")
    static let rarityCommon = Color(hex: "9E9E9E")
    
    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [primary, primaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let goldGradient = LinearGradient(
        colors: [accent, primary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let darkGradient = LinearGradient(
        colors: [cardBackground, background],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let legendaryGradient = LinearGradient(
        colors: [Color(hex: "FFD700"), Color(hex: "FF8C00"), Color(hex: "FF6347")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let epicGradient = LinearGradient(
        colors: [Color(hex: "CE93D8"), Color(hex: "9C27B0")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Spacing
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXLarge: CGFloat = 32
    
    // MARK: - Corner Radius
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 16
    static let cornerRadiusXLarge: CGFloat = 24
    
    // MARK: - Shadows
    static let shadowColor = Color.black.opacity(0.3)
    static let glowColor = primary.opacity(0.3)
}

// MARK: - Color Extension
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
