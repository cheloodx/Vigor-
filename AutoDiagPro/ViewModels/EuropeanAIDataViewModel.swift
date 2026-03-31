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
    @Published var selectedCategory: String = ""
    @Published var selectedVIN: String? = nil
    
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
                    countryCode: selectedCountry,
                    category: selectedCategory,
                    vin: selectedVIN
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
                    // Deterministic fallback based on brand index
                    insights = AIInsight.generate(brand: selectedBrand, country: selectedCountry)
                    let brandIndex = EuropeanAIDataView.EUBrand.allCases.firstIndex(of: selectedBrand) ?? 0
                    fiabilitate = 75 + (brandIndex * 3) % 20
                    popularitate = 1 + brandIndex % 8
                    costMediu = 900 + brandIndex * 150
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
