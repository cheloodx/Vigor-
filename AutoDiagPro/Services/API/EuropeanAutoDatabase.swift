import Foundation

/// Service for fetching European market insights per brand/country via the backend API.
final class EuropeanAutoDatabase {
    static let shared = EuropeanAutoDatabase()
    private let client = APIClient.shared
    
    private init() {}
    
    /// Get European insights for a car brand in a specific country.
    func getInsights(brand: String, countryCode: String) async throws -> InsightsAPIResponse {
        let request = InsightsAPIRequest(brand: brand, countryCode: countryCode)
        return try await client.post(
            endpoint: "/api/insights/european",
            body: request,
            responseType: InsightsAPIResponse.self
        )
    }
}
