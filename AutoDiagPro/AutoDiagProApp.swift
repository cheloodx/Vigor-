import SwiftUI

@main
struct AutoDiagProApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var vehicleManager = VehicleManager()
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .environmentObject(appState)
                    .environmentObject(vehicleManager)
                    .preferredColorScheme(.dark)

                if showOnboarding {
                    OnboardingView(isPresented: $showOnboarding)
                        .environmentObject(vehicleManager)
                        .environmentObject(appState)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showOnboarding)
            .onAppear {
                AnalyticsManager.shared.setupCrashHandler()
                AnalyticsManager.shared.trackSessionStart()
            }
        }
    }
}
