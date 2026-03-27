import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var vehicleManager: VehicleManager

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            ScanView()
                .tabItem {
                    Image(systemName: "camera.viewfinder")
                    Text("Scan")
                }
                .tag(0)

            VINScanView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("VIN/Nr")
                }
                .tag(1)

            ServiceCalendarView()
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Service")
                }
                .tag(2)

            CostEstimatorView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Costuri")
                }
                .tag(3)

            LiveDashboardView()
                .tabItem {
                    Image(systemName: "gauge.open.with.lines.needle.33percent.and.arrowtriangle")
                    Text("Live")
                }
                .tag(4)

            VoiceDiagnosticView()
                .tabItem {
                    Image(systemName: "mic.fill")
                    Text("Voce")
                }
                .tag(5)

            MechanicChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Mecanic")
                }
                .tag(6)
        }
        .accentColor(Theme.primary)
        .onAppear {
            configureTabBarAppearance()
        }
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Theme.background)

        // Style for normal state
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Theme.textMuted)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Theme.textMuted),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]

        // Style for selected state
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Theme.primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Theme.primary),
            .font: UIFont.systemFont(ofSize: 10, weight: .bold)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
