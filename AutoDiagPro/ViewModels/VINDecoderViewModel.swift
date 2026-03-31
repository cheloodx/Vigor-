import Foundation
import SwiftUI

/// ViewModel for VIN Auto Setup — manages async VIN decoding via backend.
/// All business logic lives here, not in the View.
@MainActor
final class VINDecoderViewModel: ObservableObject {
    // MARK: - Published State
    @Published var vinInput = ""
    @Published var isDecoding = false
    @Published var decodedResult: VINDecodeAPIResponse?
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let service = VINDecoderService.shared
    
    // MARK: - Computed Properties
    
    var isValidVIN: Bool {
        let cleaned = vinInput.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleaned.count == 17 else { return false }
        let allowed = CharacterSet.alphanumerics.subtracting(CharacterSet(charactersIn: "IOQ"))
        return cleaned.unicodeScalars.allSatisfy { allowed.contains($0) }
    }
    
    var commonProblems: [CommonProblemDisplay] {
        guard let result = decodedResult else { return [] }
        return result.commonProblems.enumerated().map { index, problem in
            let severity: String
            if index == 0 { severity = "Alta" }
            else if index < 3 { severity = "Medie" }
            else { severity = "Scazuta" }
            return CommonProblemDisplay(
                title: problem,
                description: "Problema raportata frecvent pentru \(result.make)",
                severity: severity
            )
        }
    }
    
    var maintenanceSchedule: [MaintenanceDisplay] {
        guard let result = decodedResult else { return [] }
        // Deterministic schedule based on fuel type
        var items = [
            MaintenanceDisplay(item: "Schimb ulei + filtru", interval: "La 15.000 km / 1 an"),
            MaintenanceDisplay(item: "Filtru aer", interval: "La 30.000 km"),
            MaintenanceDisplay(item: "Lichid frana", interval: "La 2 ani"),
        ]
        
        let fuelLower = result.fuelType.lowercased()
        if fuelLower.contains("diesel") {
            items.append(MaintenanceDisplay(item: "Filtru combustibil", interval: "La 40.000 km"))
            items.append(MaintenanceDisplay(item: "Bujii incandescente", interval: "La 90.000 km"))
        } else {
            items.append(MaintenanceDisplay(item: "Bujii", interval: "La 60.000 km"))
        }
        items.append(MaintenanceDisplay(item: "Curea/Lant distributie", interval: "La 160.000 km / 5 ani"))
        
        return items
    }
    
    // MARK: - Actions
    
    func decodeVIN() {
        guard isValidVIN else {
            errorMessage = "VIN-ul trebuie sa aiba exact 17 caractere valide (fara I, O, Q)"
            showError = true
            return
        }
        
        isDecoding = true
        decodedResult = nil
        errorMessage = nil
        showError = false
        
        Task {
            do {
                let result = try await service.decode(vin: vinInput)
                withAnimation(.spring()) {
                    isDecoding = false
                    decodedResult = result
                }
            } catch {
                withAnimation(.spring()) {
                    isDecoding = false
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
    
    func setVIN(_ vin: String) {
        vinInput = vin
    }
}

// MARK: - Display Models

struct CommonProblemDisplay: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let severity: String
}

struct MaintenanceDisplay: Identifiable {
    let id = UUID()
    let item: String
    let interval: String
}
