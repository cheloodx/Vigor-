import Foundation
import SwiftUI

struct DiagnosticResult: Identifiable, Codable {
    var id = UUID()
    var timestamp: Date = Date()
    var vehicleName: String = ""
    var overallStatus: DiagnosticStatus = .good
    var items: [DiagnosticItem] = []
    var repairSteps: [RepairStep] = []
    var requiredParts: [RequiredPart] = []
    var estimatedCost: CostBreakdown = CostBreakdown()
    var arSteps: [ARStep] = []

    var statusPercentage: Double {
        guard !items.isEmpty else { return 1.0 }
        let goodCount = items.filter { $0.status == .good }.count
        return Double(goodCount) / Double(items.count)
    }
}

struct DiagnosticItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var status: DiagnosticStatus
    var detail: String = ""
    var severity: Int = 0 // 0-10
}

enum DiagnosticStatus: String, Codable, CaseIterable {
    case good = "OK"
    case warning = "Atentie"
    case critical = "Critic"
    case unknown = "Necunoscut"

    var color: Color {
        switch self {
        case .good: return Theme.gaugeGreen
        case .warning: return Theme.gaugeYellow
        case .critical: return Theme.gaugeRed
        case .unknown: return Theme.textMuted
        }
    }

    var icon: String {
        switch self {
        case .good: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .critical: return "xmark.octagon.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
}

struct RepairStep: Identifiable, Codable {
    var id = UUID()
    var stepNumber: Int
    var title: String
    var description: String
    var estimatedTime: String
    var difficulty: RepairDifficulty
    var tools: [String] = []
}

enum RepairDifficulty: String, Codable {
    case easy = "Usor"
    case medium = "Mediu"
    case hard = "Dificil"
    case expert = "Expert"

    var color: Color {
        switch self {
        case .easy: return Theme.gaugeGreen
        case .medium: return Theme.gaugeYellow
        case .hard: return Theme.accent
        case .expert: return Theme.gaugeRed
        }
    }
}

struct RequiredPart: Identifiable, Codable {
    var id = UUID()
    var name: String
    var partNumber: String
    var brand: String
    var priceMin: Double
    var priceMax: Double
    var availability: PartAvailability
    var isOriginal: Bool = false

    var priceRange: String {
        return "\(Int(priceMin))-\(Int(priceMax)) RON"
    }
}

enum PartAvailability: String, Codable {
    case inStock = "In stoc"
    case order2Days = "2-3 zile"
    case order5Days = "5-7 zile"
    case unavailable = "Indisponibil"

    var color: Color {
        switch self {
        case .inStock: return Theme.gaugeGreen
        case .order2Days: return Theme.gaugeYellow
        case .order5Days: return Theme.accent
        case .unavailable: return Theme.gaugeRed
        }
    }
}

struct CostBreakdown: Codable {
    var laborCost: Double = 0
    var partsCost: Double = 0
    var additionalCost: Double = 0
    var laborHours: Double = 0

    var totalCost: Double {
        return laborCost + partsCost + additionalCost
    }

    var totalFormatted: String {
        return String(format: "%.0f RON", totalCost)
    }
}

struct ARStep: Identifiable, Codable {
    var id = UUID()
    var stepNumber: Int
    var instruction: String
    var highlightArea: String
    var icon: String = "wrench.fill"
}

// MARK: - Sample Data
extension DiagnosticResult {
    static let sample: DiagnosticResult = {
        var result = DiagnosticResult()
        result.vehicleName = "VW Golf 7 2.0 TDI"
        result.overallStatus = .warning
        result.items = [
            DiagnosticItem(name: "Motor", description: "Functioneaza normal", status: .good, detail: "Turatie stabila, fara vibratii anormale"),
            DiagnosticItem(name: "Frane", description: "Placute uzate 70%", status: .warning, detail: "Placutele fata au uzura avansata, necesita inlocuire in ~5000km", severity: 6),
            DiagnosticItem(name: "Suspensie", description: "Bieleta stabilizator", status: .warning, detail: "Bieleta stanga fata prezinta joc", severity: 5),
            DiagnosticItem(name: "Ulei motor", description: "Nivel optim", status: .good, detail: "Ulei 5W30 LongLife III"),
            DiagnosticItem(name: "Baterie", description: "12.4V - Buna", status: .good, detail: "Baterie 72Ah, tensiune corespunzatoare"),
            DiagnosticItem(name: "Filtre", description: "Filtru aer de inlocuit", status: .warning, detail: "Filtru aer cu 45000km, recomandat inlocuire", severity: 3),
            DiagnosticItem(name: "Lichid racire", description: "Nivel OK", status: .good),
            DiagnosticItem(name: "Transmisie", description: "Fara probleme", status: .good),
        ]
        result.repairSteps = [
            RepairStep(stepNumber: 1, title: "Inlocuire placute frana fata", description: "Demontati etrierul, scoateti placutele vechi, montati placutele noi", estimatedTime: "45 min", difficulty: .medium, tools: ["Cheie 13mm", "Cheie 17mm", "Presa etrier"]),
            RepairStep(stepNumber: 2, title: "Inlocuire bieleta stabilizator", description: "Demontati bieleta veche de pe bara stabilizatoare si amortizor", estimatedTime: "30 min", difficulty: .easy, tools: ["Cheie 16mm", "Cheie tubulara"]),
            RepairStep(stepNumber: 3, title: "Inlocuire filtru aer", description: "Deschideti carcasa filtrului, scoateti filtrul vechi, montati cel nou", estimatedTime: "10 min", difficulty: .easy, tools: ["Surubelnita Torx T25"]),
        ]
        result.requiredParts = [
            RequiredPart(name: "Placute frana fata", partNumber: "8V0698151B", brand: "TRW", priceMin: 120, priceMax: 180, availability: .inStock),
            RequiredPart(name: "Bieleta stabilizator", partNumber: "5Q0411315A", brand: "Lemforder", priceMin: 45, priceMax: 80, availability: .inStock, isOriginal: true),
            RequiredPart(name: "Filtru aer", partNumber: "5Q0129620B", brand: "Mann", priceMin: 35, priceMax: 55, availability: .inStock),
        ]
        result.estimatedCost = CostBreakdown(laborCost: 250, partsCost: 315, additionalCost: 30, laborHours: 1.5)
        result.arSteps = [
            ARStep(stepNumber: 1, instruction: "Localizati etrierul frana stanga-fata", highlightArea: "front-left-brake", icon: "scope"),
            ARStep(stepNumber: 2, instruction: "Desurubuati suruburile etrierului", highlightArea: "caliper-bolts", icon: "wrench.fill"),
            ARStep(stepNumber: 3, instruction: "Ridicati etrierul si scoateti placutele", highlightArea: "brake-pads", icon: "arrow.up.circle"),
            ARStep(stepNumber: 4, instruction: "Impingeti pistonul etrierului inapoi", highlightArea: "caliper-piston", icon: "arrow.left.circle"),
            ARStep(stepNumber: 5, instruction: "Montati placutele noi si reasamblati", highlightArea: "new-pads", icon: "checkmark.circle"),
        ]
        return result
    }()
}
