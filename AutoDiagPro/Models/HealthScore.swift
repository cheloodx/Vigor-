import Foundation
import SwiftUI

// MARK: - Health Score Model
struct HealthScore: Codable, Identifiable {
    var id = UUID()
    var overallScore: Int // 0-100
    var categories: [HealthCategory]
    var lastUpdated: Date
    var vehicleId: UUID
    
    var scoreColor: Color {
        if overallScore >= 80 { return Theme.gaugeGreen }
        if overallScore >= 50 { return Theme.gaugeYellow }
        return Theme.gaugeRed
    }
    
    var scoreLabel: String {
        if overallScore >= 90 { return "Excelent" }
        if overallScore >= 80 { return "Foarte Bun" }
        if overallScore >= 70 { return "Bun" }
        if overallScore >= 50 { return "Acceptabil" }
        if overallScore >= 30 { return "Necesita Atentie" }
        return "Critic"
    }
    
    var scoreEmoji: String {
        if overallScore >= 80 { return "shield.checkmark.fill" }
        if overallScore >= 50 { return "exclamationmark.shield.fill" }
        return "xmark.shield.fill"
    }
    
    static var sample: HealthScore {
        HealthScore(
            overallScore: 78,
            categories: HealthCategory.sampleCategories,
            lastUpdated: Date(),
            vehicleId: UUID()
        )
    }
}

struct HealthCategory: Codable, Identifiable {
    var id = UUID()
    var name: String
    var score: Int // 0-100
    var icon: String
    var details: String
    var recommendations: [String]
    
    var scoreColor: Color {
        if score >= 80 { return Theme.gaugeGreen }
        if score >= 50 { return Theme.gaugeYellow }
        return Theme.gaugeRed
    }
    
    static var sampleCategories: [HealthCategory] {
        [
            HealthCategory(name: "Motor", score: 85, icon: "engine.combustion.badge.exclamationmark", details: "Stare generala buna", recommendations: ["Schimb ulei la 5.000 km", "Verificare bujii"]),
            HealthCategory(name: "Frane", score: 72, icon: "circle.circle", details: "Placute uzate 60%", recommendations: ["Inlocuire placute frana fata", "Verificare discuri"]),
            HealthCategory(name: "Suspensie", score: 90, icon: "car.side.front.open", details: "Fara jocuri detectate", recommendations: ["Verificare la 30.000 km"]),
            HealthCategory(name: "Electrica", score: 68, icon: "bolt.fill", details: "Baterie slaba", recommendations: ["Inlocuire baterie recomandata", "Verificare alternator"]),
            HealthCategory(name: "Transmisie", score: 82, icon: "gearshape.2.fill", details: "Functioneaza normal", recommendations: ["Schimb ulei cutie la 60.000 km"]),
            HealthCategory(name: "Caroserie", score: 75, icon: "car.fill", details: "Rugina minora pe praguri", recommendations: ["Tratament anticoroziv", "Verificare ITP"]),
        ]
    }
}
