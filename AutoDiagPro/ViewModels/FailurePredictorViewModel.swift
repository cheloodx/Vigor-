import Foundation
import SwiftUI

@MainActor
final class FailurePredictorViewModel: ObservableObject {
    @Published var predictions: [FailurePrediction] = []
    @Published var isAnalyzing = false
    @Published var analysisComplete = false
    @Published var progress: CGFloat = 0
    @Published var errorMessage: String?
    
    private let engine = PredictionEngine.shared
    
    func startAnalysis(vehicle: Vehicle) {
        isAnalyzing = true
        analysisComplete = false
        progress = 0
        predictions = []
        errorMessage = nil
        
        // Animate progress while API call runs
        for i in 1...15 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.15) {
                withAnimation { self.progress = CGFloat(i) / 20.0 }
            }
        }
        
        Task {
            do {
                let response = try await engine.predict(
                    make: vehicle.make,
                    model: vehicle.model,
                    year: vehicle.year,
                    mileage: vehicle.mileage,
                    fuelType: vehicle.fuelType.rawValue,
                    engineType: vehicle.engineType
                )
                
                // Finish progress animation
                withAnimation { progress = 1.0 }
                
                try? await Task.sleep(nanoseconds: 500_000_000)
                
                withAnimation(.spring()) {
                    isAnalyzing = false
                    analysisComplete = true
                    predictions = response.predictions.map { item in
                        let risk: FailurePrediction.RiskLevel
                        switch item.riskLevel {
                        case "high": risk = .high
                        case "medium": risk = .medium
                        default: risk = .low
                        }
                        return FailurePrediction(
                            componentName: item.componentName,
                            icon: item.icon,
                            probability: item.probability,
                            riskLevel: risk,
                            timeframe: item.timeframe,
                            description: item.description,
                            estimatedCost: item.estimatedCost,
                            preventionTip: item.preventionTip
                        )
                    }
                }
            } catch {
                withAnimation(.spring()) {
                    isAnalyzing = false
                    analysisComplete = true
                    predictions = FailurePrediction.samplePredictions
                    errorMessage = "Date locale (offline). \(error.localizedDescription)"
                }
            }
        }
    }
}
