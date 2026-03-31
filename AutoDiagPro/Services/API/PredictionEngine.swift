import Foundation

/// Service for predicting component failures based on vehicle data via the backend API.
final class PredictionEngine {
    static let shared = PredictionEngine()
    private let client = APIClient.shared
    
    private init() {}
    
    /// Predict failures for a vehicle based on make, model, year, mileage, fuel type.
    func predict(
        make: String,
        model: String,
        year: Int,
        mileage: Int,
        fuelType: String,
        engineType: String = ""
    ) async throws -> PredictionAPIResponse {
        let request = PredictionAPIRequest(
            make: make,
            model: model,
            year: year,
            mileage: mileage,
            fuelType: fuelType,
            engineType: engineType
        )
        return try await client.post(
            endpoint: "/api/predictions/failure",
            body: request,
            responseType: PredictionAPIResponse.self
        )
    }
}
