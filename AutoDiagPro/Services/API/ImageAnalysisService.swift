import Foundation

/// Service for analyzing vehicle images/symptoms via the backend API.
final class ImageAnalysisService {
    static let shared = ImageAnalysisService()
    private let client = APIClient.shared
    
    private init() {}
    
    /// Analyze a vehicle scan based on description and symptoms.
    func analyze(
        imageDescription: String = "",
        vehicleMake: String = "",
        vehicleModel: String = "",
        symptom: String = ""
    ) async throws -> ScanAnalysisAPIResponse {
        let request = ScanAnalysisAPIRequest(
            imageDescription: imageDescription,
            vehicleMake: vehicleMake,
            vehicleModel: vehicleModel,
            symptom: symptom
        )
        return try await client.post(
            endpoint: "/scan/analyze",
            body: request,
            responseType: ScanAnalysisAPIResponse.self
        )
    }
}
