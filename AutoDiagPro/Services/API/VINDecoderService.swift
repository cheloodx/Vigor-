import Foundation
import os.log

/// Service for decoding VINs via the backend API.
/// Production path: calls POST /vin/decode on the real backend.
/// No local VIN decoding logic — all computation happens server-side.
final class VINDecoderService {
    static let shared = VINDecoderService()
    private let client = APIClient.shared
    private let logger = Logger(subsystem: "com.autodiagpro", category: "VINDecoder")
    
    private init() {}
    
    /// Decode a VIN using the backend API (NHTSA + WMI fallback on server).
    /// - Parameter vin: 17-character Vehicle Identification Number
    /// - Returns: Decoded vehicle information from the backend
    func decode(vin: String) async throws -> VINDecodeAPIResponse {
        let cleaned = vin.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard cleaned.count == 17 else {
            throw APIError.invalidRequest
        }
        
        logger.info("Decoding VIN: \(cleaned)")
        
        let request = VINDecodeRequest(vin: cleaned)
        let response = try await client.post(
            endpoint: "/vin/decode",
            body: request,
            responseType: VINDecodeAPIResponse.self
        )
        
        logger.info("VIN decoded: \(response.make) \(response.model) (\(response.year))")
        return response
    }
}
