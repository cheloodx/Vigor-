import Foundation
import SwiftUI

// MARK: - VIN Decode
struct VINDecodeRequest: Encodable {
    let vin: String
}

struct VINDecodeAPIResponse: Decodable {
    let vin: String
    let make: String
    let model: String
    let year: Int
    let engineType: String
    let engineCapacity: String
    let fuelType: String
    let transmission: String
    let bodyType: String
    let driveType: String
    let countryOfOrigin: String
    let manufacturer: String
    let plant: String
    let commonProblems: [String]
    let recallCount: Int
}

// MARK: - DTC Decode
struct DTCDecodeRequest: Encodable {
    let code: String
}

struct DTCDecodeAPIResponse: Decodable {
    let code: String
    let shortDescription: String
    let description: String
    let system: String
    let category: String
    let severity: String
    let causes: [String]
    let symptoms: [String]
    let fix: String
    let costRange: String
    let canDrive: Bool
}

// MARK: - European Insights
struct InsightsAPIRequest: Encodable {
    let brand: String
    let countryCode: String
    let category: String
    let vin: String?
}

struct AIInsightAPIItem: Decodable {
    let title: String
    let description: String
    let icon: String
    let color: String
    let category: String
    let dataPoints: [String]
}

struct InsightsAPIResponse: Decodable {
    let brand: String
    let country: String
    let fiabilitate: Int
    let popularitate: Int
    let costMediu: Int
    let currency: String
    let insights: [AIInsightAPIItem]
}

// MARK: - Failure Predictions
struct PredictionAPIRequest: Encodable {
    let make: String
    let model: String
    let year: Int
    let mileage: Int
    let fuelType: String
    let engineType: String
}

struct PredictionAPIItem: Decodable {
    let componentName: String
    let icon: String
    let probability: Int
    let riskLevel: String
    let timeframe: String
    let description: String
    let estimatedCost: Double
    let preventionTip: String
}

struct PredictionAPIResponse: Decodable {
    let vehicle: String
    let mileage: Int
    let predictions: [PredictionAPIItem]
    let riskSummary: [String: Int]
}

// MARK: - Recall Campaigns
struct RecallAPIRequest: Encodable {
    let make: String
    let model: String
    let year: Int
    let vin: String
}

struct RecallAPIItem: Decodable {
    let title: String
    let description: String
    let date: String
    let severity: String
    let affectedParts: String
    let status: String
}

struct RecallAPIResponse: Decodable {
    let vehicle: String
    let totalRecalls: Int
    let activeRecalls: Int
    let recalls: [RecallAPIItem]
}

// MARK: - Sound Analysis
struct SoundAnalysisAPIRequest: Encodable {
    let duration: Double
    let avgDb: Double
    let peakDb: Double
    let frequencies: [Double]
}

struct DetectedSoundAPIItem: Decodable {
    let name: String
    let description: String
    let frequency: String
    let severity: String
}

struct SoundAnalysisAPIResponse: Decodable {
    let overallStatus: String
    let confidenceScore: Int
    let statusIcon: String
    let statusColor: String
    let detectedSounds: [DetectedSoundAPIItem]
    let recommendations: [String]
}

// MARK: - Scan Analysis
struct ScanAnalysisAPIRequest: Encodable {
    let imageDescription: String
    let vehicleMake: String
    let vehicleModel: String
    let symptom: String
}

struct ScanAnalysisAPIResponse: Decodable {
    let diagnosis: String
    let confidence: Int
    let severity: String
    let affectedSystem: String
    let possibleCauses: [String]
    let recommendations: [String]
    let estimatedCost: String
}
