import Foundation
import SwiftUI

// MARK: - Position Card View
struct PositionCard: View {
    let position: Position
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topTrailing) {
                Image(position.id)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 140)
                    .clipped()
                
                // Favorite button
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(isFavorite ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(8)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(position.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: position.category.icon)
                        .font(.system(size: 10))
                    Text(position.category.displayName)
                        .font(.system(size: 11))
                }
                .foregroundColor(Theme.categoryColor(position.category))
                
                HStack(spacing: 4) {
                    Text(position.difficulty.displayName)
                        .font(.system(size: 10, weight: .medium))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.difficultyColor(position.difficulty).opacity(0.2))
                        .foregroundColor(Theme.difficultyColor(position.difficulty))
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    // Intimacy hearts
                    HStack(spacing: 1) {
                        ForEach(1...5, id: \.self) { level in
                            Image(systemName: level <= position.intimacy ? "heart.fill" : "heart")
                                .font(.system(size: 8))
                                .foregroundColor(level <= position.intimacy ? Theme.primary : Theme.textMuted)
                        }
                    }
                }
            }
            .padding(10)
        }
        .background(Theme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Category Filter Chip
struct CategoryChip: View {
    let category: PositionCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: category.icon)
                    .font(.system(size: 12))
                Text(category.displayName)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Theme.categoryColor(category).opacity(0.3) : Color.clear)
            .foregroundColor(isSelected ? Theme.categoryColor(category) : Theme.textSecondary)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Theme.categoryColor(category) : Theme.textMuted.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Difficulty Filter Chip
struct DifficultyChip: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(difficulty.displayName)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isSelected ? Theme.difficultyColor(difficulty).opacity(0.3) : Color.clear)
                .foregroundColor(isSelected ? Theme.difficultyColor(difficulty) : Theme.textSecondary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Theme.difficultyColor(difficulty) : Theme.textMuted.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Theme.textMuted)
            
            TextField("Cauta pozitii...", text: $text)
                .foregroundColor(Theme.textPrimary)
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.textMuted)
                }
            }
        }
        .padding(10)
        .background(Theme.cardBackground)
        .cornerRadius(10)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Theme.primary)
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            Spacer()
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(Theme.primary.opacity(0.5))
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}
