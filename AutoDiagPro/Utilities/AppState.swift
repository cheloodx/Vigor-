import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var isLoading: Bool = false
    @Published var showOnboarding: Bool = false

    // Scan state
    @Published var lastScanResult: DiagnosticResult?
    @Published var isCameraActive: Bool = false

    // Voice state
    @Published var isRecording: Bool = false

    // Chat state
    @Published var chatMessages: [ChatMessage] = []

    // OBD state
    @Published var isOBDConnected: Bool = false
    @Published var obdData: OBDLiveData = OBDLiveData()
}
