import Foundation

/// Service for fetching European market insights per brand/country via the backend API.
final class EuropeanAutoDatabase {
    static let shared = EuropeanAutoDatabase()
    private let client = APIClient.shared
    
    private init() {}
    
    /// Get European insights for a car brand in a specific country.
    func getInsights(
        brand: String,
        countryCode: String,
        category: String = "",
        vin: String? = nil
    ) async throws -> InsightsAPIResponse {
        let request = InsightsAPIRequest(
            brand: brand,
            countryCode: countryCode,
            category: category,
            vin: vin
        )
        return try await client.post(
            endpoint: "/ai/european-insights",
            body: request,
            responseType: InsightsAPIResponse.self
        )
    }
}
