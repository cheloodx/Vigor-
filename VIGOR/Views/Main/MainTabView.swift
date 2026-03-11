import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(AppState.Tab.home)
            
            TrainingView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Training")
                }
                .tag(AppState.Tab.training)
            
            CommunityView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Community")
                }
                .tag(AppState.Tab.community)
            
            NutritionView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Nutrition")
                }
                .tag(AppState.Tab.nutrition)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
                .tag(AppState.Tab.profile)
        }
        .accentColor(Theme.primary)
    }
}
