import Foundation
import SwiftUI

@MainActor
final class RecallCampaignsViewModel: ObservableObject {
    @Published var recalls: [RecallCampaign] = []
    @Published var isChecking = false
    @Published var checkComplete = false
    @Published var errorMessage: String?
    
    private let service = RecallService.shared
    
    func checkRecalls(vehicle: Vehicle) {
        isChecking = true
        checkComplete = false
        recalls = []
        errorMessage = nil
        
        Task {
            do {
                let response = try await service.checkRecalls(
                    make: vehicle.make,
                    model: vehicle.model,
                    year: vehicle.year,
                    vin: vehicle.vin
                )
                
                withAnimation(.spring()) {
                    isChecking = false
                    checkComplete = true
                    recalls = response.recalls.map { item in
                        let status: RecallCampaign.RecallStatus = item.status == "active" ? .active : .resolved
                        return RecallCampaign(
                            title: item.title,
                            description: item.description,
                            date: item.date,
                            severity: item.severity,
                            affectedParts: item.affectedParts,
                            status: status
                        )
                    }
                }
            } catch {
                withAnimation(.spring()) {
                    isChecking = false
                    checkComplete = true
                    recalls = RecallCampaign.sampleRecalls
                    errorMessage = "Date locale (offline). \(error.localizedDescription)"
                }
            }
        }
    }
}
