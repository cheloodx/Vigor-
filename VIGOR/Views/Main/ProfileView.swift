import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSettings = false
    @State private var showWatchSettings = false
    @State private var showInventory = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    profileHeader
                    
                    // Level Progress
                    levelProgressSection
                    
                    // Stats Grid
                    statsGrid
                    
                    // Quick Actions
                    quickActions
                    
                    // Badges
                    badgesSection
                    
                    // Settings
                    settingsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showWatchSettings) {
                WatchSettingsView()
            }
            .sheet(isPresented: $showInventory) {
                InventoryView()
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.primaryGradient)
                    .frame(width: 90, height: 90)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Text(appState.currentUser.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("@\(appState.currentUser.username)")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
            
            HStack(spacing: 16) {
                FitPointsDisplay(points: appState.fitPoints)
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(appState.dailyStreak) zile streak")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .padding(.top, 12)
    }
    
    private var levelProgressSection: some View {
        CardView {
            VStack(spacing: 8) {
                HStack {
                    Text("Nivel \(appState.currentUser.level)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.primary)
                    Spacer()
                    Text("\(appState.currentUser.experience)/\(appState.currentUser.experienceToNextLevel) XP")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                }
                ProgressView(value: appState.currentUser.levelProgress)
                    .tint(Theme.primary)
            }
        }
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(title: "Antrenamente", value: "\(appState.currentUser.totalWorkouts)", icon: "dumbbell.fill", color: Theme.primary)
            StatCard(title: "Calorii Arse", value: "\(appState.currentUser.totalCaloriesBurned / 1000)K", icon: "flame.fill", color: .red)
            StatCard(title: "Streak Maxim", value: "\(appState.dailyStreak)", icon: "flame.fill", color: .orange)
            StatCard(title: "Insigne", value: "\(appState.currentUser.badges.count)", icon: "star.fill", color: Theme.accent)
        }
    }
    
    private var quickActions: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Actiuni Rapide")
            
            HStack(spacing: 12) {
                quickActionButton(title: "Inventar", icon: "bag.fill", color: Theme.primary) {
                    showInventory = true
                }
                quickActionButton(title: "Ceas", icon: "applewatch", color: .blue) {
                    showWatchSettings = true
                }
                quickActionButton(title: "Setari", icon: "gearshape.fill", color: .gray) {
                    showSettings = true
                }
            }
        }
    }
    
    private func quickActionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
        }
    }
    
    private var badgesSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Insigne Obtinute")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(appState.currentUser.badges, id: \.self) { badge in
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(Theme.accent.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                Image(systemName: "star.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Theme.accent)
                            }
                            Text(badge)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(spacing: 8) {
            SectionHeader(title: "Setari")
            
            ForEach(settingsItems, id: \.title) { item in
                CardView(padding: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(item.color.opacity(0.2))
                                .frame(width: 36, height: 36)
                            Image(systemName: item.icon)
                                .font(.system(size: 16))
                                .foregroundColor(item.color)
                        }
                        
                        Text(item.title)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textTertiary)
                    }
                }
            }
        }
    }
    
    private var settingsItems: [(title: String, icon: String, color: Color)] {
        [
            ("Notificari", "bell.fill", .blue),
            ("Confidentialitate", "lock.fill", .green),
            ("Limba", "globe", .purple),
            ("Despre VIGOR", "info.circle.fill", Theme.primary),
        ]
    }
}
