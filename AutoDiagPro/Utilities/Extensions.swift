import SwiftUI

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .shadow(color: Theme.cardShadow, radius: 8, x: 0, y: 4)
    }

    func glowingBorder(color: Color = Theme.primary, lineWidth: CGFloat = 1) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(color.opacity(0.5), lineWidth: lineWidth)
            )
            .shadow(color: color.opacity(0.2), radius: 8)
    }

    func pulseAnimation(_ isActive: Bool) -> some View {
        self.scaleEffect(isActive ? 1.05 : 1.0)
            .animation(
                isActive ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default,
                value: isActive
            )
    }
}

// MARK: - Color Extensions
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

// MARK: - Date Extensions
extension Date {
    func formatRomanian() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ro_RO")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: self)
    }

    func shortFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ro_RO")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }

    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .month, .year], from: self, to: now)

        if let years = components.year, years > 0 {
            return "acum \(years) an\(years > 1 ? "i" : "")"
        } else if let months = components.month, months > 0 {
            return "acum \(months) lun\(months > 1 ? "i" : "a")"
        } else if let days = components.day, days > 0 {
            return "acum \(days) zi\(days > 1 ? "le" : "")"
        }
        return "azi"
    }
}

// MARK: - Double Extensions
extension Double {
    func formattedCurrency() -> String {
        return String(format: "%.0f RON", self)
    }

    func formattedKm() -> String {
        if self >= 1000 {
            return String(format: "%.0fk km", self / 1000)
        }
        return String(format: "%.0f km", self)
    }
}

// MARK: - String Extensions
extension String {
    func isValidVIN() -> Bool {
        let vinRegex = "^[A-HJ-NPR-Z0-9]{17}$"
        return self.range(of: vinRegex, options: .regularExpression) != nil
    }

    func isValidPlate() -> Bool {
        // Romanian plate format: XX-00-XXX or B-000-XXX
        let plateRegex = "^[A-Z]{1,2}-?\\d{2,3}-?[A-Z]{3}$"
        return self.uppercased().range(of: plateRegex, options: .regularExpression) != nil
    }
}
