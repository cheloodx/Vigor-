import SwiftUI

struct FitPointsWalletView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showDailyRewards = false
    @State private var showStore = false
    @State private var showPackageStore = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Balance Card
                    balanceCard
                    
                    // Quick Actions
                    quickActions
                    
                    // Daily Missions Summary
                    dailyMissionsSummary
                    
                    // Transaction History
                    transactionHistory
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("FitPoints Wallet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Close") { dismiss() }
                                    .foregroundColor(Theme.primary)
                            }
                        }
                        .sheet(isPresented: $showDailyRewards) {
                DailyRewardsView()
            }
            .sheet(isPresented: $showStore) {
                FitPointsStoreView()
            }
            .sheet(isPresented: $showPackageStore) {
                PackageStoreView()
            }
        }
    }
    
    // MARK: - Balance Card
    private var balanceCard: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FF8C00"), Color(hex: "FF6347"), Color(hex: "CC5500")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)
                    .shadow(color: Theme.primary.opacity(0.3), radius: 15, y: 5)
                
                VStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                    
                    Text("\(appState.fitPoints)")
                        .font(.system(size: 48, weight: .black))
                        .foregroundColor(.white)
                    
                    Text("Available FitPoints")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    
    // MARK: - Quick Actions
    private var quickActions: some View {
        HStack(spacing: 12) {
            walletActionButton(title: "Daily\nRewards", icon: "gift.fill", color: Theme.accent) {
                showDailyRewards = true
            }
            walletActionButton(title: "FitPoints\nStore", icon: "bag.fill", color: Theme.primary) {
                showStore = true
            }
            walletActionButton(title: "Surprise\nPackages", icon: "shippingbox.fill", color: Theme.rarityEpic) {
                showPackageStore = true
            }
            walletActionButton(title: "Reload\nPoints", icon: "plus.circle.fill", color: Theme.success) {
                // Reload points
            }
        }
    }
    
    private func walletActionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(color)
                }
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
        }
    }
    
    // MARK: - Daily Missions
    private var dailyMissionsSummary: some View {
        CardView {
            VStack(spacing: 12) {
                HStack {
                    Text("Daily Missions")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Text("1/4 complete")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.primary)
                }
                
                ProgressView(value: 0.25)
                    .tint(Theme.primary)
                
                Text("Complete missions to earn up to 55 FP!")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
    
    // MARK: - Transaction History
    private var transactionHistory: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Transaction History", showSeeAll: true)
            
            ForEach(FitPointsTransaction.samples) { transaction in
                CardView(padding: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(transaction.isCredit ? Theme.success.opacity(0.2) : Theme.error.opacity(0.2))
                                .frame(width: 40, height: 40)
                            Image(systemName: transaction.icon)
                                .font(.system(size: 16))
                                .foregroundColor(transaction.isCredit ? Theme.success : Theme.error)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(transaction.description)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                            Text(formatDate(transaction.date))
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textTertiary)
                        }
                        
                        Spacer()
                        
                        Text("\(transaction.isCredit ? "+" : "-")\(transaction.amount) FP")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(transaction.isCredit ? Theme.success : Theme.error)
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
