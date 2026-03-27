import SwiftUI

@main
struct AutoDiagProApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var vehicleManager = VehicleManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appState)
                .environmentObject(vehicleManager)
                .preferredColorScheme(.dark)
        }
    }
}
