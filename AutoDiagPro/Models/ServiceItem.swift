import Foundation
import SwiftUI

struct ServiceItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var icon: String
    var intervalKm: Int
    var intervalMonths: Int
    var lastServiceDate: Date?
    var lastServiceKm: Int?
    var estimatedCost: Double
    var currentKm: Int = 0
    var notes: String = ""

    var progressPercentage: Double {
        guard let lastKm = lastServiceKm else { return 0 }
        let kmSinceService = currentKm - lastKm
        let progress = 1.0 - (Double(kmSinceService) / Double(intervalKm))
        return max(0, min(1, progress))
    }

    var kmRemaining: Int {
        guard let lastKm = lastServiceKm else { return intervalKm }
        return max(0, intervalKm - (currentKm - lastKm))
    }

    var monthsRemaining: Int {
        guard let lastDate = lastServiceDate else { return intervalMonths }
        let calendar = Calendar.current
        let months = calendar.dateComponents([.month], from: lastDate, to: Date()).month ?? 0
        return max(0, intervalMonths - months)
    }

    var statusColor: Color {
        return Theme.statusColor(for: progressPercentage)
    }

    var isOverdue: Bool {
        return progressPercentage <= 0 || monthsRemaining <= 0
    }

    var statusText: String {
        if isOverdue {
            return "DEPASIT"
        } else if progressPercentage < 0.2 {
            return "URGENT"
        } else if progressPercentage < 0.4 {
            return "CURAND"
        }
        return "OK"
    }
}

// MARK: - Maintenance Schedule
struct MaintenanceSchedule: Codable {
    var vehicleId: UUID
    var items: [ServiceItem]
    var currentMileage: Int

    mutating func updateMileage(_ km: Int) {
        currentMileage = km
        for i in items.indices {
            items[i].currentKm = km
        }
    }
}

// MARK: - Sample Data
extension ServiceItem {
    static let allItems: [ServiceItem] = {
        let calendar = Calendar.current
        let now = Date()

        return [
            ServiceItem(
                name: "Ulei motor + filtru",
                icon: "drop.fill",
                intervalKm: 15000,
                intervalMonths: 12,
                lastServiceDate: calendar.date(byAdding: .month, value: -8, to: now),
                lastServiceKm: 75000,
                estimatedCost: 350,
                currentKm: 85000
            ),
            ServiceItem(
                name: "Filtru aer",
                icon: "wind",
                intervalKm: 30000,
                intervalMonths: 24,
                lastServiceDate: calendar.date(byAdding: .month, value: -14, to: now),
                lastServiceKm: 60000,
                estimatedCost: 80,
                currentKm: 85000
            ),
            ServiceItem(
                name: "Filtru combustibil",
                icon: "fuelpump.fill",
                intervalKm: 60000,
                intervalMonths: 48,
                lastServiceDate: calendar.date(byAdding: .month, value: -20, to: now),
                lastServiceKm: 60000,
                estimatedCost: 120,
                currentKm: 85000
            ),
            ServiceItem(
                name: "Filtru habitaclu",
                icon: "allergens",
                intervalKm: 15000,
                intervalMonths: 12,
                lastServiceDate: calendar.date(byAdding: .month, value: -10, to: now),
                lastServiceKm: 73000,
                estimatedCost: 65,
                currentKm: 85000
            ),
            ServiceItem(
                name: "Placute frana fata",
                icon: "circle.circle.fill",
                intervalKm: 40000,
                intervalMonths: 36,
                lastServiceDate: calendar.date(byAdding: .month, value: -24, to: now),
                lastServiceKm: 55000,
                estimatedCost: 350,
                currentKm: 85000
            ),
            ServiceItem(
                name: "Placute frana spate",
                icon: "circle.circle",
                intervalKm: 60000,
                intervalMonths: 48,
                lastServiceDate: calendar.date(byAdding: .month, value: -24, to: now),
                lastServiceKm: 55000,
                estimatedCost: 280,
                currentKm: 85000
            ),
            ServiceItem(
                name: "Lichid frana",
                icon: "drop.triangle.fill",
                intervalKm: 60000,
                intervalMonths: 24,
                lastServiceDate: calendar.date(byAdding: .month, value: -22, to: now),
                lastServiceKm: 60000,
                estimatedCost: 150,
                currentKm: 85000
            ),
            ServiceItem(
                name: "Lichid racire",
                icon: "thermometer.snowflake",
                intervalKm: 120000,
                intervalMonths: 60,
                lastServiceDate: calendar.date(byAdding: .month, value: -36, to: now),
                lastServiceKm: 45000,
                estimatedCost: 180,
                currentKm: 85000
            ),
            ServiceItem(
                name: "Curea distributie + kit",
                icon: "gearshape.2.fill",
                intervalKm: 120000,
                intervalMonths: 72,
                lastServiceDate: calendar.date(byAdding: .month, value: -48, to: now),
                lastServiceKm: 60000,
                estimatedCost: 1800,
                currentKm: 85000
            ),
        ]
    }()
}
