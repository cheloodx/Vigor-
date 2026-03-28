import Foundation
import SwiftUI
import CoreLocation

// MARK: - Service Location Model
struct ServiceLocation: Codable, Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var type: ServiceType
    var rating: Double // 1-5
    var reviewCount: Int
    var phone: String
    var isAuthorized: Bool
    var specialties: [String]
    var priceLevel: PriceLevel
    var isOpen: Bool
    var distance: Double? // km from user
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var formattedRating: String {
        String(format: "%.1f", rating)
    }
    
    var formattedDistance: String {
        guard let dist = distance else { return "" }
        if dist < 1 {
            return String(format: "%.0f m", dist * 1000)
        }
        return String(format: "%.1f km", dist)
    }
    
    static var sampleLocations: [ServiceLocation] {
        [
            ServiceLocation(name: "Auto Service Pro", address: "Str. Industriei 25, Cluj-Napoca", latitude: 46.7712, longitude: 23.6236, type: .general, rating: 4.7, reviewCount: 234, phone: "0264-123456", isAuthorized: true, specialties: ["VW", "Audi", "Skoda"], priceLevel: .medium, isOpen: true, distance: 1.2),
            ServiceLocation(name: "Quick Oil Change", address: "Calea Turzii 180, Cluj-Napoca", latitude: 46.7580, longitude: 23.5900, type: .quickService, rating: 4.3, reviewCount: 89, phone: "0264-654321", isAuthorized: false, specialties: ["Schimb ulei", "Filtre", "Frane"], priceLevel: .low, isOpen: true, distance: 2.5),
            ServiceLocation(name: "BMW Service Oficial", address: "Str. Fabricii 5, Cluj-Napoca", latitude: 46.7800, longitude: 23.6100, type: .authorized, rating: 4.8, reviewCount: 156, phone: "0264-111222", isAuthorized: true, specialties: ["BMW", "MINI"], priceLevel: .high, isOpen: true, distance: 3.1),
            ServiceLocation(name: "Vulcanizare Rapid", address: "Str. Mehedinti 15, Cluj-Napoca", latitude: 46.7650, longitude: 23.6300, type: .tires, rating: 4.5, reviewCount: 312, phone: "0264-333444", isAuthorized: false, specialties: ["Anvelope", "Jante", "Echilibrare"], priceLevel: .low, isOpen: false, distance: 0.8),
            ServiceLocation(name: "ITP Center Plus", address: "Str. Muncii 70, Cluj-Napoca", latitude: 46.7550, longitude: 23.6150, type: .itp, rating: 4.1, reviewCount: 445, phone: "0264-555666", isAuthorized: true, specialties: ["ITP", "RAR", "Emisii"], priceLevel: .medium, isOpen: true, distance: 4.2),
            ServiceLocation(name: "Electro Auto Expert", address: "Str. Traian 42, Cluj-Napoca", latitude: 46.7690, longitude: 23.5950, type: .electrical, rating: 4.6, reviewCount: 67, phone: "0264-777888", isAuthorized: false, specialties: ["Electrica", "Diagnoza", "Climatizare"], priceLevel: .medium, isOpen: true, distance: 1.8),
        ]
    }
}

enum ServiceType: String, Codable, CaseIterable {
    case general = "Service General"
    case authorized = "Service Autorizat"
    case quickService = "Service Rapid"
    case tires = "Vulcanizare"
    case itp = "ITP/RAR"
    case electrical = "Electrica Auto"
    case bodyShop = "Tinichigerie/Vopsitorie"
    
    var icon: String {
        switch self {
        case .general: return "wrench.and.screwdriver.fill"
        case .authorized: return "building.2.fill"
        case .quickService: return "bolt.fill"
        case .tires: return "circle.circle"
        case .itp: return "checkmark.seal.fill"
        case .electrical: return "bolt.fill"
        case .bodyShop: return "paintbrush.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .general: return Theme.primary
        case .authorized: return Color.purple
        case .quickService: return Theme.gaugeGreen
        case .tires: return Theme.gaugeYellow
        case .itp: return Color(red: 0.0, green: 0.75, blue: 0.85)
        case .electrical: return Color(red: 0.95, green: 0.5, blue: 0.2)
        case .bodyShop: return Color(red: 0.85, green: 0.3, blue: 0.5)
        }
    }
}

enum PriceLevel: String, Codable {
    case low = "€"
    case medium = "€€"
    case high = "€€€"
    
    var label: String {
        switch self {
        case .low: return "Accesibil"
        case .medium: return "Mediu"
        case .high: return "Premium"
        }
    }
}
