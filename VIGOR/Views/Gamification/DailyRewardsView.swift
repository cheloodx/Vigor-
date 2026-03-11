import SwiftUI

struct DailyRewardsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var claimedToday = false
    @State private var showClaimAnimation = false
    
    private let rewards = DailyReward.weeklyRewards(currentDay: 5)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Header
                    streakHeader
                    
                    // Weekly Rewards Grid
                    weeklyRewardsGrid
                    
                    // Daily Missions
                    dailyMissionsSection
                    
                    // Claim Button
                    if !claimedToday {
                        PrimaryButton("Claim Daily Bonus", icon: "gift.fill") {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                claimedToday = true
                                showClaimAnimation = true
                                appState.addFitPoints(30)
                            }
                        }
                    } else {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Theme.success)
                            Text("Bonus claimed today!")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Theme.success)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.success.opacity(0.15))
                        .cornerRadius(Theme.cornerRadiusMedium)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Daily Rewards")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") { dismiss() }
                            .foregroundColor(Theme.primary)
                    }
                }
            }
        }
    
    // MARK: - Streak Header
    private var streakHeader: some View {
        CardView {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Theme.primary.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    VStack(spacing: 2) {
                        Text("🔥")
                            .font(.system(size: 28))
                        Text("\(appState.dailyStreak)")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(Theme.primary)
                    }
                }
                
                Text("Daily Streak")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                Text("Keep your streak going for bigger rewards!")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Weekly Rewards Grid
    private var weeklyRewardsGrid: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Weekly Rewards")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(rewards) { reward in
                    rewardDayCard(reward)
                }
            }
        }
    }
    
    private func rewardDayCard(_ reward: DailyReward) -> some View {
        VStack(spacing: 6) {
            Text("Day \(reward.day)")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(reward.isToday ? .black : Theme.textSecondary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(reward.isClaimed ? Theme.success.opacity(0.2) : (reward.isToday ? Theme.primary : Theme.cardBackgroundLight))
                    .frame(height: 60)
                
                if reward.isClaimed {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Theme.success)
                } else {
                    VStack(spacing: 2) {
                        Image(systemName: reward.bonusItem != nil ? "gift.fill" : "flame.fill")
                            .font(.system(size: 16))
                            .foregroundColor(reward.isToday ? .black : Theme.accent)
                        Text("+\(reward.points)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(reward.isToday ? .black : Theme.textPrimary)
                    }
                }
            }
            
            if let bonus = reward.bonusItem {
                Text(bonus)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(Theme.accent)
                    .lineLimit(1)
            }
        }
    }
    
    // MARK: - Daily Missions
    private var dailyMissionsSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Daily Missions")
            
            ForEach(DailyMission.samples) { mission in
                CardView(padding: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(mission.isCompleted ? Theme.success.opacity(0.2) : Theme.primary.opacity(0.15))
                                .frame(width: 40, height: 40)
                            Image(systemName: mission.isCompleted ? "checkmark" : mission.icon)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(mission.isCompleted ? Theme.success : Theme.primary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(mission.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                                .strikethrough(mission.isCompleted)
                            
                            ProgressView(value: mission.progress)
                                .tint(mission.isCompleted ? Theme.success : Theme.primary)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 2) {
                            Text("+\(mission.reward)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.accent)
                            Text("FP")
                                .font(.system(size: 10))
                                .foregroundColor(Theme.accent.opacity(0.7))
                        }
                    }
                }
            }
        }
    }
}
