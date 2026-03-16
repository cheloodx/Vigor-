import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            PositionsGridView()
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Pozitii")
                }
                .tag(0)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorite")
                }
                .tag(1)
            
            InfoView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Info")
                }
                .tag(2)
        }
        .accentColor(Theme.primary)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Theme.background)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
