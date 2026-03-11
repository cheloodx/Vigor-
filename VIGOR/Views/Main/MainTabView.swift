import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Acasa")
                }
                .tag(AppState.Tab.home)
            
            TrainingView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Antrenament")
                }
                .tag(AppState.Tab.training)
            
            CommunityView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Comunitate")
                }
                .tag(AppState.Tab.community)
            
            NutritionView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Nutritie")
                }
                .tag(AppState.Tab.nutrition)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profil")
                }
                .tag(AppState.Tab.profile)
        }
        .accentColor(Theme.primary)
    }
}
