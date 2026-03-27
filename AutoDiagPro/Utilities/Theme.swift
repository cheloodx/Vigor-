import SwiftUI

enum Theme {
    // MARK: - Primary Colors
    static let primary = Color(red: 0.0, green: 0.75, blue: 1.0)       // Electric blue
    static let secondary = Color(red: 0.0, green: 0.9, blue: 0.6)      // Neon green
    static let accent = Color(red: 1.0, green: 0.4, blue: 0.2)         // Warning orange
    static let danger = Color(red: 1.0, green: 0.25, blue: 0.25)       // Red alert

    // MARK: - Background Colors
    static let background = Color(red: 0.06, green: 0.07, blue: 0.11)  // Deep dark
    static let cardBackground = Color(red: 0.10, green: 0.11, blue: 0.16)
    static let surfaceBackground = Color(red: 0.14, green: 0.15, blue: 0.20)

    // MARK: - Text Colors
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.65)
    static let textMuted = Color(white: 0.4)

    // MARK: - Gauge Colors
    static let gaugeGreen = Color(red: 0.2, green: 0.9, blue: 0.4)
    static let gaugeYellow = Color(red: 1.0, green: 0.85, blue: 0.2)
    static let gaugeRed = Color(red: 1.0, green: 0.2, blue: 0.2)
    static let gaugeBlue = Color(red: 0.2, green: 0.6, blue: 1.0)

    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [cardBackground, surfaceBackground],
        startPoint: .top,
        endPoint: .bottom
    )

    static let scanGradient = LinearGradient(
        colors: [primary.opacity(0.3), secondary.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Shadows
    static let glowShadow = Color.blue.opacity(0.3)
    static let cardShadow = Color.black.opacity(0.4)

    // MARK: - Corner Radius
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 10
    static let largeCornerRadius: CGFloat = 24

    // MARK: - Status Colors
    static func statusColor(for percentage: Double) -> Color {
        switch percentage {
        case 0..<0.3:
            return gaugeRed
        case 0.3..<0.6:
            return gaugeYellow
        case 0.6..<0.85:
            return primary
        default:
            return gaugeGreen
        }
    }
}
