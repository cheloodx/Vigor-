import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var showNotifications = false
    @State private var showWallet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with greeting
                    headerSection
                    
                    // Quick Stats
                    quickStatsSection
                    
                    // Daily Progress Ring
                    dailyProgressSection
                    
                    // Active Program
                    activeProgramSection
                    
                    // Today's Workout
                    todayWorkoutSection
                    
                    // Daily Missions
                    dailyMissionsSection
                    
                    // Recent Activity
                    recentActivitySection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 8) {
                        Image(systemName: "v.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Theme.primary)
                        Text("VIGOR")
                            .font(.system(size: 24, weight: .black))
                            .foregroundColor(Theme.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Button(action: { showWallet = true }) {
                            FitPointsDisplay(points: appState.fitPoints)
                        }
                        Button(action: { showNotifications = true }) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Theme.textSecondary)
                                Circle()
                                    .fill(Theme.error)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showNotifications) {
                WatchNotificationsView()
            }
            .sheet(isPresented: $showWallet) {
                FitPointsWalletView()
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Buna, \(appState.currentUser.name)! 👋")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            Text("Hai sa ne antrenam astazi!")
                .font(.system(size: 16))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }
    
    // MARK: - Quick Stats
    private var quickStatsSection: some View {
        HStack(spacing: 12) {
            StatCard(title: "Streak", value: "\(appState.dailyStreak)🔥", icon: "flame.fill", color: .orange)
            StatCard(title: "Nivel", value: "Lv.\(appState.currentUser.level)", icon: "star.fill", color: Theme.accent)
            StatCard(title: "Calorii", value: "420", icon: "bolt.fill", color: .green)
        }
    }
    
    // MARK: - Daily Progress
    private var dailyProgressSection: some View {
        CardView {
            VStack(spacing: 16) {
                SectionHeader(title: "Progres Zilnic")
                
                HStack(spacing: 24) {
                    VStack(spacing: 8) {
                        ProgressRing(progress: 0.7, color: Theme.primary, size: 70)
                            .overlay(
                                VStack(spacing: 0) {
                                    Text("70%")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                }
                            )
                        Text("Antrenament")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    VStack(spacing: 8) {
                        ProgressRing(progress: 0.55, color: .green, size: 70)
                            .overlay(
                                VStack(spacing: 0) {
                                    Text("55%")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                }
                            )
                        Text("Nutritie")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    VStack(spacing: 8) {
                        ProgressRing(progress: 0.8, color: .blue, size: 70)
                            .overlay(
                                VStack(spacing: 0) {
                                    Text("80%")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                }
                            )
                        Text("Pasi")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    VStack(spacing: 8) {
                        ProgressRing(progress: 0.5, color: .cyan, size: 70)
                            .overlay(
                                VStack(spacing: 0) {
                                    Text("1.5L")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                }
                            )
                        Text("Apa")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Active Program
    private var activeProgramSection: some View {
        CardView {
            VStack(spacing: 12) {
                SectionHeader(title: "Program Activ")
                
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Theme.primary.opacity(0.2))
                            .frame(width: 50, height: 50)
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Theme.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Putere Maxima 8 Saptamani")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        Text("Saptamana 3 din 8")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("35%")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.primary)
                }
                
                ProgressView(value: 0.35)
                    .tint(Theme.primary)
            }
        }
    }
    
    // MARK: - Today's Workout
    private var todayWorkoutSection: some View {
        CardView {
            VStack(spacing: 12) {
                SectionHeader(title: "Antrenamentul de Azi")
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Putere Totala")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Theme.textPrimary)
                            
                            HStack(spacing: 12) {
                                Label("45 min", systemImage: "clock.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.textSecondary)
                                Label("350 kcal", systemImage: "flame.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.textSecondary)
                                Label("+50 FP", systemImage: "star.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Theme.accent)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "dumbbell.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Theme.primary.opacity(0.5))
                    }
                }
                
                PrimaryButton("Incepe Antrenamentul", icon: "play.fill") {
                    // Start workout
                }
            }
        }
    }
    
    // MARK: - Daily Missions
    private var dailyMissionsSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Misiuni Zilnice", showSeeAll: true)
            
            ForEach(DailyMission.samples.prefix(3)) { mission in
                CardView(padding: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(mission.isCompleted ? Theme.success.opacity(0.2) : Theme.primary.opacity(0.2))
                                .frame(width: 40, height: 40)
                            Image(systemName: mission.isCompleted ? "checkmark" : mission.icon)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(mission.isCompleted ? Theme.success : Theme.primary)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(mission.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                                .strikethrough(mission.isCompleted)
                            Text(mission.description)
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("+\(mission.reward) FP")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.accent)
                            
                            if !mission.isCompleted {
                                ProgressView(value: mission.progress)
                                    .tint(Theme.primary)
                                    .frame(width: 50)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Recent Activity
    private var recentActivitySection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Activitate Recenta", showSeeAll: true)
            
            ForEach(FitPointsTransaction.samples.prefix(3)) { transaction in
                CardView(padding: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(transaction.isCredit ? Theme.success.opacity(0.2) : Theme.error.opacity(0.2))
                                .frame(width: 36, height: 36)
                            Image(systemName: transaction.icon)
                                .font(.system(size: 14))
                                .foregroundColor(transaction.isCredit ? Theme.success : Theme.error)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(transaction.description)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                        }
                        
                        Spacer()
                        
                        Text("\(transaction.isCredit ? "+" : "-")\(transaction.amount) FP")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(transaction.isCredit ? Theme.success : Theme.error)
                    }
                }
            }
        }
    }
}
