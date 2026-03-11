import SwiftUI

struct PackageStoreView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selectedPackage: SurprisePackage? = nil
    @State private var showUnboxing = false
    @State private var showInsufficientFunds = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Balance
                    FitPointsDisplay(points: appState.fitPoints)
                    
                    // Packages
                    ForEach(SurprisePackage.samples) { package in
                        packageCard(package)
                    }
                    
                    // Info
                    infoSection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Surprise Packages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Close") { dismiss() }
                                    .foregroundColor(Theme.primary)
                            }
                        }
                        .fullScreenCover(isPresented: $showUnboxing) {
                if let package = selectedPackage {
                    UnboxingView(package: package)
                }
            }
                        .alert("Insufficient FitPoints", isPresented: $showInsufficientFunds) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text("You don't have enough FitPoints for this package. Earn more through workouts and daily missions!")
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "shippingbox.fill")
                .font(.system(size: 40))
                .foregroundColor(Theme.accent)
            
                        Text("Surprise Packages")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
            
                        Text("Open packages to get rare and legendary items!")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }
    
    private func packageCard(_ package: SurprisePackage) -> some View {
        VStack(spacing: 0) {
            // Package Visual
            ZStack {
                RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                    .fill(package.tier.gradient)
                    .frame(height: 140)
                
                VStack(spacing: 8) {
                    Image(systemName: package.icon)
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5)
                    
                    Text(package.name)
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                }
            }
            
            // Package Info
            VStack(spacing: 12) {
                Text(package.description)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                
                // Possible Items
                VStack(alignment: .leading, spacing: 4) {
                    Text("Possible contents:")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Theme.textTertiary)
                    ForEach(package.possibleItems, id: \.self) { item in
                        HStack(spacing: 4) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 4))
                                .foregroundColor(package.tier.color)
                            Text(item)
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
                
                // Buy Button
                Button(action: {
                    if appState.fitPoints >= package.cost {
                        selectedPackage = package
                        _ = appState.spendFitPoints(package.cost)
                        showUnboxing = true
                    } else {
                        showInsufficientFunds = true
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 14))
                        Text("\(package.cost) FitPoints")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(package.tier.gradient)
                    .cornerRadius(Theme.cornerRadiusMedium)
                }
            }
            .padding()
            .background(Theme.cardBackground)
        }
        .cornerRadius(Theme.cornerRadiusLarge)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadiusLarge)
                .stroke(package.tier.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var infoSection: some View {
        CardView {
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(Theme.info)
                    Text("How does it work?")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
                
                Text("Each package contains a random item. More expensive packages have higher chances of containing rare, epic, or legendary items. Items can be equipped on your profile or collected in your inventory.")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(4)
            }
        }
    }
}
