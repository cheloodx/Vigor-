import SwiftUI

struct FitPointsStoreView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: VirtualItem.ItemCategory? = nil
    @State private var showPurchaseAlert = false
    @State private var selectedItem: StoreItem? = nil
    
    struct StoreItem: Identifiable {
        let id = UUID()
        var name: String
        var description: String
        var icon: String
        var price: Int
        var rarity: ItemRarity
        var category: VirtualItem.ItemCategory
    }
    
    private let storeItems: [StoreItem] = [
                StoreItem(name: "Legend Badge", description: "Customize your profile", icon: "star.fill", price: 200, rarity: .legendary, category: .badge),
                StoreItem(name: "Elite Shirt", description: "Rare avatar equipment", icon: "tshirt.fill", price: 350, rarity: .epic, category: .equipment),
                StoreItem(name: "Golden Dumbbells", description: "Legendary collectible item", icon: "dumbbell.fill", price: 500, rarity: .legendary, category: .equipment),
                StoreItem(name: "Energy Aura", description: "Epic visual effect", icon: "sparkles", price: 250, rarity: .epic, category: .effect),
                StoreItem(name: "Warrior Avatar", description: "Rare avatar frame", icon: "person.crop.circle.badge.checkmark", price: 150, rarity: .rare, category: .avatar),
                StoreItem(name: "Streak Badge", description: "For impressive streaks", icon: "flame.fill", price: 100, rarity: .rare, category: .badge),
                StoreItem(name: "Pro Headset", description: "Stylish audio equipment", icon: "headphones", price: 80, rarity: .common, category: .equipment),
                StoreItem(name: "Neon Background", description: "Profile background effect", icon: "paintbrush.fill", price: 120, rarity: .rare, category: .effect),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Balance
                    balanceHeader
                    
                    // Categories
                    categoryFilter
                    
                    // Items Grid
                    itemsGrid
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("FitPoints Store")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Close") { dismiss() }
                                    .foregroundColor(Theme.primary)
                            }
                        }
                        .alert("Confirm Purchase", isPresented: $showPurchaseAlert) {
                            Button("Buy") {
                                if let item = selectedItem {
                                    _ = appState.spendFitPoints(item.price)
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            if let item = selectedItem {
                                Text("Do you want to buy \(item.name) for \(item.price) FitPoints?")
                            }
                        }
        }
    }
    
    private var balanceHeader: some View {
        HStack {
            Image(systemName: "flame.fill")
                .font(.system(size: 20))
                .foregroundColor(Theme.accent)
            Text("\(appState.fitPoints) FitPoints")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            Spacer()
        }
        .padding()
        .background(Theme.accent.opacity(0.1))
        .cornerRadius(Theme.cornerRadiusMedium)
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterButton(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(VirtualItem.ItemCategory.allCases, id: \.self) { category in
                    filterButton(title: category.rawValue, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    private func filterButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .black : Theme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Theme.primary : Theme.cardBackground)
                .cornerRadius(16)
        }
    }
    
    private var itemsGrid: some View {
        let filtered = selectedCategory == nil ? storeItems : storeItems.filter { $0.category == selectedCategory }
        
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            ForEach(filtered) { item in
                storeItemCard(item)
            }
        }
    }
    
    private func storeItemCard(_ item: StoreItem) -> some View {
        Button(action: {
            selectedItem = item
            showPurchaseAlert = true
        }) {
            VStack(spacing: 10) {
                // Rarity indicator
                HStack {
                    Spacer()
                    BadgeView(text: item.rarity.label, color: item.rarity.color)
                }
                
                ZStack {
                    Circle()
                        .fill(item.rarity.color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    Image(systemName: item.icon)
                        .font(.system(size: 26))
                        .foregroundColor(item.rarity.color)
                }
                
                Text(item.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(1)
                
                Text(item.description)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.accent)
                    Text("\(item.price)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.accent)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Theme.accent.opacity(0.15))
                .cornerRadius(12)
            }
            .padding(12)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .stroke(item.rarity.color.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
