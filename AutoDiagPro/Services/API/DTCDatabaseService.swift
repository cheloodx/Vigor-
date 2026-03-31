import Foundation

/// Service for decoding DTC (Diagnostic Trouble Code) error codes via the backend API.
final class DTCDatabaseService {
    static let shared = DTCDatabaseService()
    private let client = APIClient.shared
    
    private init() {}
    
    /// Decode a DTC code (e.g. P0300, B0001, C0035, U0100)
    func decode(code: String) async throws -> DTCDecodeAPIResponse {
        let request = DTCDecodeRequest(code: code.uppercased().trimmingCharacters(in: .whitespaces))
        return try await client.post(
            endpoint: "/api/dtc/decode",
            body: request,
            responseType: DTCDecodeAPIResponse.self
        )
    }
}
