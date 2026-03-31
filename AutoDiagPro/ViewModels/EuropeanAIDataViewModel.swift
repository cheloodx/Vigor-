import Foundation
import SwiftUI

@MainActor
final class EuropeanAIDataViewModel: ObservableObject {
    @Published var selectedBrand: EuropeanAIDataView.EUBrand = .volkswagen
    @Published var selectedCountry: String = "RO"
    @Published var isAnalyzing = false
    @Published var analysisComplete = false
    @Published var insights: [AIInsight] = []
    @Published var fiabilitate = 0
    @Published var popularitate = 0
    @Published var costMediu = 0
    @Published var currency = "RON"
    @Published var countryName = "Romania"
    @Published var errorMessage: String?
    
    private let service = EuropeanAutoDatabase.shared
    
    func startAnalysis() {
        isAnalyzing = true
        analysisComplete = false
        insights = []
        errorMessage = nil
        
        Task {
            do {
                let response = try await service.getInsights(
                    brand: selectedBrand.rawValue,
                    countryCode: selectedCountry
                )
                
                withAnimation(.spring()) {
                    isAnalyzing = false
                    analysisComplete = true
                    fiabilitate = response.fiabilitate
                    popularitate = response.popularitate
                    costMediu = response.costMediu
                    currency = response.currency
                    countryName = response.country
                    
                    insights = response.insights.map { item in
                        let color: Color
                        switch item.color {
                        case "red": color = Theme.gaugeRed
                        case "orange": color = Theme.secondary
                        case "green": color = Theme.gaugeGreen
                        case "yellow": color = Theme.gaugeYellow
                        default: color = Theme.primary
                        }
                        return AIInsight(
                            title: item.title,
                            description: item.description,
                            icon: item.icon,
                            color: color,
                            category: item.category,
                            dataPoints: item.dataPoints
                        )
                    }
                }
            } catch {
                withAnimation(.spring()) {
                    isAnalyzing = false
                    analysisComplete = true
                    // Fallback to local generation
                    insights = AIInsight.generate(brand: selectedBrand, country: selectedCountry)
                    fiabilitate = Int.random(in: 70...92)
                    popularitate = Int.random(in: 1...8)
                    costMediu = Int.random(in: 800...2500)
                    errorMessage = "Date locale (offline). \(error.localizedDescription)"
                }
            }
        }
    }
    
    func selectBrand(_ brand: EuropeanAIDataView.EUBrand) {
        selectedBrand = brand
        if analysisComplete { startAnalysis() }
    }
    
    func selectCountry(_ code: String) {
        selectedCountry = code
        if analysisComplete { startAnalysis() }
    }
}
