import Foundation

struct Vehicle: Identifiable, Codable {
    var id = UUID()
    var vin: String = ""
    var licensePlate: String = ""
    var make: String = ""
    var model: String = ""
    var year: Int = 2020
    var engineType: String = ""
    var engineCapacity: String = ""
    var fuelType: FuelType = .diesel
    var color: String = ""
    var equipment: String = ""
    var mileage: Int = 0
    var transmission: TransmissionType = .manual

    var displayName: String {
        if !make.isEmpty && !model.isEmpty {
            return "\(make) \(model) (\(year))"
        }
        return "Vehicul necunoscut"
    }

    var shortName: String {
        if !make.isEmpty {
            return "\(make) \(model)"
        }
        return "N/A"
    }
}

enum FuelType: String, Codable, CaseIterable {
    case diesel = "Diesel"
    case benzina = "Benzina"
    case hybrid = "Hybrid"
    case electric = "Electric"
    case gpl = "GPL"

    var icon: String {
        switch self {
        case .diesel: return "fuelpump.fill"
        case .benzina: return "fuelpump"
        case .hybrid: return "bolt.fill"
        case .electric: return "bolt.fill"
        case .gpl: return "flame.fill"
        }
    }
}

enum TransmissionType: String, Codable, CaseIterable {
    case manual = "Manuala"
    case automatic = "Automata"
    case dsg = "DSG"
    case cvt = "CVT"
}

// MARK: - Sample Data
extension Vehicle {
    static let sample = Vehicle(
        vin: "WVWZZZ3CZWE123456",
        licensePlate: "B-123-ABC",
        make: "Volkswagen",
        model: "Golf 7",
        year: 2019,
        engineType: "2.0 TDI",
        engineCapacity: "1968cc",
        fuelType: .diesel,
        color: "Gri Indium",
        equipment: "Highline",
        mileage: 85000,
        transmission: .manual
    )

    static let sampleBMW = Vehicle(
        vin: "WBAPH5C55BA123456",
        licensePlate: "CJ-99-BMW",
        make: "BMW",
        model: "320d F30",
        year: 2018,
        engineType: "2.0d N47",
        engineCapacity: "1995cc",
        fuelType: .diesel,
        color: "Negru Sapphire",
        equipment: "M Sport",
        mileage: 120000,
        transmission: .automatic
    )
}
