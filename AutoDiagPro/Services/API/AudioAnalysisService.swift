import Foundation

/// Service for analyzing engine sound via the backend API.
final class AudioAnalysisService {
    static let shared = AudioAnalysisService()
    private let client = APIClient.shared
    
    private init() {}
    
    /// Analyze engine sound based on audio recording characteristics.
    func analyze(
        duration: Double,
        avgDb: Double,
        peakDb: Double,
        frequencies: [Double] = []
    ) async throws -> SoundAnalysisAPIResponse {
        let request = SoundAnalysisAPIRequest(
            duration: duration,
            avgDb: avgDb,
            peakDb: peakDb,
            frequencies: frequencies
        )
        return try await client.post(
            endpoint: "/sound/analyze",
            body: request,
            responseType: SoundAnalysisAPIResponse.self
        )
    }
}
