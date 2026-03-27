import Foundation
import SwiftUI

// MARK: - Journal Entry Model
struct JournalEntry: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var type: JournalEntryType
    var title: String
    var details: String
    var cost: Double
    var mileage: Int
    var vehicleId: UUID
    var attachmentCount: Int = 0
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "ro_RO")
        return formatter.string(from: date)
    }
    
    var formattedCost: String {
        cost > 0 ? String(format: "%.0f RON", cost) : "-"
    }
    
    static var sampleEntries: [JournalEntry] {
        [
            JournalEntry(date: Date().addingTimeInterval(-86400 * 2), type: .fuel, title: "Alimentare OMV", details: "Motorina Premium 45L", cost: 315, mileage: 125430, vehicleId: UUID()),
            JournalEntry(date: Date().addingTimeInterval(-86400 * 15), type: .repair, title: "Schimb placute frana fata", details: "Placute Brembo + verificare discuri", cost: 450, mileage: 124800, vehicleId: UUID()),
            JournalEntry(date: Date().addingTimeInterval(-86400 * 30), type: .service, title: "Revizie 120.000 km", details: "Ulei Castrol 5W30, filtru ulei, filtru aer, filtru habitaclu", cost: 680, mileage: 120000, vehicleId: UUID()),
            JournalEntry(date: Date().addingTimeInterval(-86400 * 60), type: .itp, title: "ITP Reusit", details: "Inspectie tehnica periodica - ADMIS", cost: 150, mileage: 118500, vehicleId: UUID()),
            JournalEntry(date: Date().addingTimeInterval(-86400 * 90), type: .insurance, title: "RCA Euroins", details: "Polita RCA 12 luni", cost: 1200, mileage: 115000, vehicleId: UUID()),
            JournalEntry(date: Date().addingTimeInterval(-86400 * 120), type: .fuel, title: "Alimentare Petrom", details: "Motorina 50L", cost: 340, mileage: 112000, vehicleId: UUID()),
            JournalEntry(date: Date().addingTimeInterval(-86400 * 150), type: .accident, title: "Lovitura parcare", details: "Bara spate - vopsire si indreptare", cost: 800, mileage: 110000, vehicleId: UUID()),
            JournalEntry(date: Date().addingTimeInterval(-86400 * 200), type: .modification, title: "Jante aliaj 17\"", details: "Set 4 jante + anvelope Michelin 225/45 R17", cost: 3200, mileage: 105000, vehicleId: UUID()),
        ]
    }
}

enum JournalEntryType: String, Codable, CaseIterable {
    case fuel = "Alimentare"
    case service = "Service/Revizie"
    case repair = "Reparatie"
    case itp = "ITP"
    case insurance = "Asigurare"
    case accident = "Accident/Dauna"
    case modification = "Modificare/Tuning"
    case other = "Altele"
    
    var icon: String {
        switch self {
        case .fuel: return "fuelpump.fill"
        case .service: return "wrench.and.screwdriver.fill"
        case .repair: return "wrench.fill"
        case .itp: return "checkmark.seal.fill"
        case .insurance: return "shield.fill"
        case .accident: return "exclamationmark.triangle.fill"
        case .modification: return "sparkles"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .fuel: return Color(red: 0.22, green: 0.78, blue: 0.35)
        case .service: return Theme.primary
        case .repair: return Theme.gaugeYellow
        case .itp: return Color.purple
        case .insurance: return Color(red: 0.0, green: 0.75, blue: 0.85)
        case .accident: return Theme.gaugeRed
        case .modification: return Color(red: 0.95, green: 0.5, blue: 0.2)
        case .other: return Theme.textMuted
        }
    }
}

// MARK: - Diagnostic History Entry
struct DiagnosticHistoryEntry: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var vehicleName: String
    var vehicleId: UUID
    var overallStatus: String // "good", "warning", "danger"
    var issuesFound: Int
    var scanType: String // "foto", "obd2", "voce", "manual"
    var summary: String
    var healthScore: Int
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "ro_RO")
        return formatter.string(from: date)
    }
    
    var statusColor: Color {
        switch overallStatus {
        case "good": return Theme.gaugeGreen
        case "warning": return Theme.gaugeYellow
        default: return Theme.gaugeRed
        }
    }
    
    var statusIcon: String {
        switch overallStatus {
        case "good": return "checkmark.circle.fill"
        case "warning": return "exclamationmark.triangle.fill"
        default: return "xmark.circle.fill"
        }
    }
    
    var scanTypeIcon: String {
        switch scanType {
        case "foto": return "camera.fill"
        case "obd2": return "antenna.radiowaves.left.and.right"
        case "voce": return "mic.fill"
        default: return "doc.text.fill"
        }
    }
    
    static var sampleHistory: [DiagnosticHistoryEntry] {
        [
            DiagnosticHistoryEntry(date: Date().addingTimeInterval(-3600), vehicleName: "VW Golf 7 1.6 TDI", vehicleId: UUID(), overallStatus: "warning", issuesFound: 2, scanType: "foto", summary: "Placute frana uzate 60%, nivel lichid frana scazut", healthScore: 78),
            DiagnosticHistoryEntry(date: Date().addingTimeInterval(-86400 * 3), vehicleName: "VW Golf 7 1.6 TDI", vehicleId: UUID(), overallStatus: "good", issuesFound: 0, scanType: "obd2", summary: "Toti parametrii in limite normale", healthScore: 85),
            DiagnosticHistoryEntry(date: Date().addingTimeInterval(-86400 * 10), vehicleName: "VW Golf 7 1.6 TDI", vehicleId: UUID(), overallStatus: "warning", issuesFound: 1, scanType: "voce", summary: "Zgomot suspensie dreapta fata - verificare necesara", healthScore: 72),
            DiagnosticHistoryEntry(date: Date().addingTimeInterval(-86400 * 20), vehicleName: "VW Golf 7 1.6 TDI", vehicleId: UUID(), overallStatus: "good", issuesFound: 0, scanType: "manual", summary: "Revizie completa efectuata - totul OK", healthScore: 92),
            DiagnosticHistoryEntry(date: Date().addingTimeInterval(-86400 * 45), vehicleName: "VW Golf 7 1.6 TDI", vehicleId: UUID(), overallStatus: "danger", issuesFound: 3, scanType: "obd2", summary: "DPF colmatat, turbo cu joc, eroare senzor lambda", healthScore: 45),
        ]
    }
}
