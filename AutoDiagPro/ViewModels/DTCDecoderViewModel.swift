import Foundation
import SwiftUI

@MainActor
final class DTCDecoderViewModel: ObservableObject {
    @Published var dtcInput = ""
    @Published var decodedError: DTCError?
    @Published var isDecoding = false
    @Published var recentCodes: [DTCError] = []
    @Published var errorMessage: String?
    
    private let service = DTCDatabaseService.shared
    
    func decodeDTC() {
        let code = dtcInput.uppercased().trimmingCharacters(in: .whitespaces)
        guard code.count >= 5 else { return }
        isDecoding = true
        decodedError = nil
        errorMessage = nil
        
        Task {
            do {
                let response = try await service.decode(code: code)
                withAnimation(.spring()) {
                    isDecoding = false
                    let severity: DTCError.DTCSeverity
                    switch response.severity {
                    case "critical": severity = .critical
                    case "major": severity = .major
                    default: severity = .minor
                    }
                    
                    let decoded = DTCError(
                        code: response.code,
                        shortDescription: response.shortDescription,
                        description: response.description,
                        system: response.system,
                        category: response.category,
                        severity: severity,
                        causes: response.causes,
                        symptoms: response.symptoms,
                        fix: response.fix,
                        costRange: response.costRange,
                        canDrive: response.canDrive
                    )
                    decodedError = decoded
                    if !recentCodes.contains(where: { $0.code == decoded.code }) {
                        recentCodes.insert(decoded, at: 0)
                        if recentCodes.count > 5 { recentCodes.removeLast() }
                    }
                }
            } catch {
                withAnimation(.spring()) {
                    isDecoding = false
                    // Fallback to local decode
                    let decoded = DTCError.decode(code)
                    decodedError = decoded
                    if !recentCodes.contains(where: { $0.code == decoded.code }) {
                        recentCodes.insert(decoded, at: 0)
                        if recentCodes.count > 5 { recentCodes.removeLast() }
                    }
                    errorMessage = "Date locale (offline). \(error.localizedDescription)"
                }
            }
        }
    }
    
    func selectCode(_ code: String) {
        dtcInput = code
        decodeDTC()
    }
    
    func selectRecentCode(_ dtcError: DTCError) {
        dtcInput = dtcError.code
        decodedError = dtcError
    }
}
