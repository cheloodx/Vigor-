import Foundation

/// Service for checking recall campaigns for a vehicle via the backend API.
final class RecallService {
    static let shared = RecallService()
    private let client = APIClient.shared
    
    private init() {}
    
    /// Check recall campaigns for a vehicle.
    func checkRecalls(
        make: String,
        model: String = "",
        year: Int = 0,
        vin: String = ""
    ) async throws -> RecallAPIResponse {
        let request = RecallAPIRequest(
            make: make,
            model: model,
            year: year,
            vin: vin
        )
        return try await client.post(
            endpoint: "/api/recalls/check",
            body: request,
            responseType: RecallAPIResponse.self
        )
    }
}
