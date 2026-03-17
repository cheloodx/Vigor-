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
            
            GamesListView()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Jocuri")
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorite")
                }
                .tag(2)
            
            InfoView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Info")
                }
                .tag(3)
            
            DiscoverView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Descopera")
                }
                .tag(4)
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
