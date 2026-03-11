import SwiftUI

struct InventoryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: VirtualItem.ItemCategory? = nil
    @State private var selectedRarity: ItemRarity? = nil
    @State private var selectedItem: VirtualItem? = nil
    @State private var showItemDetail = false
    
    private let items = VirtualItem.samples
    
    var filteredItems: [VirtualItem] {
        var result = items
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        if let rarity = selectedRarity {
            result = result.filter { $0.rarity == rarity }
        }
        return result
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats
                    statsSection
                    
                    // Filters
                    categoryFilter
                    rarityFilter
                    
                    // Items Grid
                    itemsGrid
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Item Inventory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Close") { dismiss() }
                                    .foregroundColor(Theme.primary)
                            }
                        }
                        .sheet(isPresented: $showItemDetail) {
                if let item = selectedItem {
                    ItemDetailView(item: item)
                }
            }
        }
    }
    
    // MARK: - Stats
    private var statsSection: some View {
        HStack(spacing: 12) {
            inventoryStat(title: "Total", value: "\(items.count)", color: Theme.primary)
            inventoryStat(title: "Legendary", value: "\(items.filter { $0.rarity == .legendary }.count)", color: Theme.rarityLegendary)
            inventoryStat(title: "Epic", value: "\(items.filter { $0.rarity == .epic }.count)", color: Theme.rarityEpic)
            inventoryStat(title: "Equipped", value: "\(items.filter { $0.isEquipped }.count)", color: Theme.success)
        }
    }
    
    private func inventoryStat(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadiusMedium)
    }
    
    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(VirtualItem.ItemCategory.allCases, id: \.self) { category in
                    filterChip(title: category.rawValue, icon: category.icon, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    // MARK: - Rarity Filter
    private var rarityFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                rarityChip(title: "All", color: Theme.textSecondary, isSelected: selectedRarity == nil) {
                    selectedRarity = nil
                }
                ForEach(ItemRarity.allCases, id: \.self) { rarity in
                    rarityChip(title: rarity.label, color: rarity.color, isSelected: selectedRarity == rarity) {
                        selectedRarity = rarity
                    }
                }
            }
        }
    }
    
    private func filterChip(title: String, icon: String? = nil, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 11))
                }
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(isSelected ? .black : Theme.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Theme.primary : Theme.cardBackground)
            .cornerRadius(14)
        }
    }
    
    private func rarityChip(title: String, color: Color, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color : color.opacity(0.15))
                .cornerRadius(14)
        }
    }
    
    // MARK: - Items Grid
    private var itemsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(filteredItems) { item in
                Button(action: {
                    selectedItem = item
                    showItemDetail = true
                }) {
                    inventoryItemCard(item)
                }
            }
        }
    }
    
    private func inventoryItemCard(_ item: VirtualItem) -> some View {
        VStack(spacing: 8) {
            // Rarity border glow
            ZStack {
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .fill(Theme.cardBackground)
                
                VStack(spacing: 8) {
                    // Top: Rarity + Equipped
                    HStack {
                        BadgeView(text: item.rarity.label, color: item.rarity.color)
                        Spacer()
                        if item.isEquipped {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.success)
                        }
                    }
                    
                    // Icon
                    ZStack {
                        Circle()
                            .fill(item.rarity.color.opacity(0.15))
                            .frame(width: 50, height: 50)
                        Image(systemName: item.icon)
                            .font(.system(size: 22))
                            .foregroundColor(item.rarity.color)
                    }
                    
                    // Name
                    Text(item.name)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)
                    
                    // Category
                    Text(item.category.rawValue)
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textTertiary)
                }
                .padding(10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .stroke(item.rarity.color.opacity(item.isEquipped ? 0.5 : 0.2), lineWidth: item.isEquipped ? 2 : 1)
            )
        }
    }
}

// MARK: - Item Detail View
struct ItemDetailView: View {
    let item: VirtualItem
    @Environment(\.dismiss) var dismiss
    @State private var isEquipped: Bool
    
    init(item: VirtualItem) {
        self.item = item
        _isEquipped = State(initialValue: item.isEquipped)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()
                
                // Item Display
                ZStack {
                    Circle()
                        .fill(item.rarity.color.opacity(0.1))
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .fill(item.rarity.color.opacity(0.2))
                        .frame(width: 110, height: 110)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 50))
                        .foregroundColor(item.rarity.color)
                }
                
                // Rarity Badge
                Text(item.rarity.label.uppercased())
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(item.rarity.color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(item.rarity.color.opacity(0.15))
                    .cornerRadius(8)
                
                // Name & Description
                VStack(spacing: 6) {
                    Text(item.name)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(item.description)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    Text(item.category.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textTertiary)
                }
                
                // Stats
                if let date = item.acquiredDate {
                    HStack(spacing: 20) {
                        VStack(spacing: 2) {
                            Text("Acquired")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textTertiary)
                            Text(formatDate(date))
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                        }
                        
                        Divider().frame(height: 30)
                        
                        VStack(spacing: 2) {
                            Text("Rarity")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textTertiary)
                            Text(item.rarity.label)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(item.rarity.color)
                        }
                        
                        Divider().frame(height: 30)
                        
                        VStack(spacing: 2) {
                            Text("Status")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textTertiary)
                            Text(isEquipped ? "Equipped" : "In inventory")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(isEquipped ? Theme.success : Theme.textSecondary)
                        }
                    }
                    .padding()
                    .background(Theme.cardBackground)
                    .cornerRadius(Theme.cornerRadiusMedium)
                }
                
                Spacer()
                
                // Actions
                VStack(spacing: 10) {
                    PrimaryButton(isEquipped ? "Unequip" : "Equip", icon: isEquipped ? "xmark" : "checkmark") {
                        withAnimation { isEquipped.toggle() }
                    }
                    
                    SecondaryButton("Share with Friends", icon: "square.and.arrow.up") {}
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") { dismiss() }
                            .foregroundColor(Theme.primary)
                    }
                }
            }
        }
    
        private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
