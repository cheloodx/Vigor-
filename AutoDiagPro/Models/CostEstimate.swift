import Foundation
import SwiftUI

struct CostOperation: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: OperationCategory
    var laborCost: Double
    var partsCostMin: Double
    var partsCostMax: Double
    var laborHours: Double
    var isSelected: Bool = false
    var icon: String

    var totalMin: Double { laborCost + partsCostMin }
    var totalMax: Double { laborCost + partsCostMax }

    var totalRange: String {
        "\(Int(totalMin))-\(Int(totalMax)) RON"
    }
}

enum OperationCategory: String, Codable, CaseIterable {
    case motor = "Motor"
    case frane = "Frane"
    case suspensie = "Suspensie"
    case electric = "Electric"
    case caroserie = "Caroserie"
    case revizie = "Revizie"
    case transmisie = "Transmisie"
    case clima = "Climatizare"

    var icon: String {
        switch self {
        case .motor: return "bolt.heart.fill"
        case .frane: return "circle.circle.fill"
        case .suspensie: return "car.side.fill"
        case .electric: return "bolt.fill"
        case .caroserie: return "car.fill"
        case .revizie: return "wrench.and.screwdriver.fill"
        case .transmisie: return "gearshape.fill"
        case .clima: return "snowflake"
        }
    }

    var color: Color {
        switch self {
        case .motor: return Theme.accent
        case .frane: return Theme.danger
        case .suspensie: return Theme.gaugeBlue
        case .electric: return Theme.gaugeYellow
        case .caroserie: return Theme.textSecondary
        case .revizie: return Theme.primary
        case .transmisie: return Theme.secondary
        case .clima: return Color(red: 0.5, green: 0.8, blue: 1.0)
        }
    }
}

struct CostSummary {
    var operations: [CostOperation]

    var selectedOperations: [CostOperation] {
        operations.filter { $0.isSelected }
    }

    var totalLaborCost: Double {
        selectedOperations.reduce(0) { $0 + $1.laborCost }
    }

    var totalPartsCostMin: Double {
        selectedOperations.reduce(0) { $0 + $1.partsCostMin }
    }

    var totalPartsCostMax: Double {
        selectedOperations.reduce(0) { $0 + $1.partsCostMax }
    }

    var totalHours: Double {
        selectedOperations.reduce(0) { $0 + $1.laborHours }
    }

    var grandTotalMin: Double {
        totalLaborCost + totalPartsCostMin
    }

    var grandTotalMax: Double {
        totalLaborCost + totalPartsCostMax
    }
}

// MARK: - Sample Data
extension CostOperation {
    static let allOperations: [CostOperation] = [
        // Revizie
        CostOperation(name: "Schimb ulei + filtru ulei", category: .revizie, laborCost: 80, partsCostMin: 180, partsCostMax: 350, laborHours: 0.5, icon: "drop.fill"),
        CostOperation(name: "Schimb filtru aer", category: .revizie, laborCost: 30, partsCostMin: 35, partsCostMax: 80, laborHours: 0.15, icon: "wind"),
        CostOperation(name: "Schimb filtru combustibil", category: .revizie, laborCost: 60, partsCostMin: 45, partsCostMax: 120, laborHours: 0.5, icon: "fuelpump.fill"),
        CostOperation(name: "Schimb filtru habitaclu", category: .revizie, laborCost: 30, partsCostMin: 30, partsCostMax: 65, laborHours: 0.15, icon: "allergens"),
        CostOperation(name: "Schimb bujii", category: .revizie, laborCost: 100, partsCostMin: 80, partsCostMax: 200, laborHours: 0.75, icon: "bolt.fill"),

        // Frane
        CostOperation(name: "Placute frana fata", category: .frane, laborCost: 120, partsCostMin: 100, partsCostMax: 250, laborHours: 1.0, icon: "circle.circle.fill"),
        CostOperation(name: "Placute frana spate", category: .frane, laborCost: 100, partsCostMin: 80, partsCostMax: 200, laborHours: 1.0, icon: "circle.circle"),
        CostOperation(name: "Discuri frana fata", category: .frane, laborCost: 150, partsCostMin: 200, partsCostMax: 500, laborHours: 1.5, icon: "record.circle"),
        CostOperation(name: "Schimb lichid frana", category: .frane, laborCost: 80, partsCostMin: 40, partsCostMax: 80, laborHours: 0.75, icon: "drop.triangle.fill"),

        // Suspensie
        CostOperation(name: "Amortizoare fata (set)", category: .suspensie, laborCost: 300, partsCostMin: 400, partsCostMax: 900, laborHours: 2.5, icon: "arrow.up.arrow.down"),
        CostOperation(name: "Bieleta stabilizator", category: .suspensie, laborCost: 60, partsCostMin: 40, partsCostMax: 100, laborHours: 0.5, icon: "link"),
        CostOperation(name: "Brat suspensie", category: .suspensie, laborCost: 150, partsCostMin: 150, partsCostMax: 400, laborHours: 1.5, icon: "car.side.fill"),
        CostOperation(name: "Rulment roata", category: .suspensie, laborCost: 120, partsCostMin: 80, partsCostMax: 200, laborHours: 1.0, icon: "circle.dashed"),

        // Motor
        CostOperation(name: "Curea distributie + kit", category: .motor, laborCost: 500, partsCostMin: 400, partsCostMax: 900, laborHours: 4.0, icon: "gearshape.2.fill"),
        CostOperation(name: "Pompa apa", category: .motor, laborCost: 200, partsCostMin: 150, partsCostMax: 350, laborHours: 2.0, icon: "drop.fill"),
        CostOperation(name: "Termostat", category: .motor, laborCost: 150, partsCostMin: 60, partsCostMax: 150, laborHours: 1.5, icon: "thermometer.medium"),
        CostOperation(name: "Schimb lichid racire", category: .motor, laborCost: 80, partsCostMin: 50, partsCostMax: 100, laborHours: 0.75, icon: "thermometer.snowflake"),

        // Electric
        CostOperation(name: "Alternator recondiționat", category: .electric, laborCost: 200, partsCostMin: 300, partsCostMax: 700, laborHours: 1.5, icon: "bolt.circle.fill"),
        CostOperation(name: "Electromotor", category: .electric, laborCost: 200, partsCostMin: 250, partsCostMax: 600, laborHours: 1.5, icon: "power"),
        CostOperation(name: "Baterie auto", category: .electric, laborCost: 30, partsCostMin: 250, partsCostMax: 500, laborHours: 0.25, icon: "battery.100.bolt"),

        // Transmisie
        CostOperation(name: "Schimb ulei cutie viteze", category: .transmisie, laborCost: 100, partsCostMin: 100, partsCostMax: 250, laborHours: 1.0, icon: "gearshape.fill"),
        CostOperation(name: "Kit ambreiaj", category: .transmisie, laborCost: 400, partsCostMin: 350, partsCostMax: 800, laborHours: 4.0, icon: "circle.grid.2x1.fill"),
        CostOperation(name: "Volanta masa dubla", category: .transmisie, laborCost: 400, partsCostMin: 800, partsCostMax: 2000, laborHours: 4.0, icon: "circle.grid.cross.fill"),

        // Climatizare
        CostOperation(name: "Incarcare freon AC", category: .clima, laborCost: 80, partsCostMin: 50, partsCostMax: 100, laborHours: 0.5, icon: "snowflake"),
        CostOperation(name: "Compresor AC", category: .clima, laborCost: 300, partsCostMin: 500, partsCostMax: 1200, laborHours: 2.5, icon: "fan.fill"),
    ]
}
