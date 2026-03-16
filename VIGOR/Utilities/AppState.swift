import Foundation
import SwiftUI
import Combine

// MARK: - App State
class AppState: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var favoriteIDs: Set<String> = [] {
        didSet {
            if didFinishInit {
                saveFavorites()
            }
        }
    }
    @Published var searchText: String = ""
    @Published var selectedCategory: PositionCategory? = nil
    @Published var selectedDifficulty: Difficulty? = nil
    
    private let favoritesKey = "kamasutra_favorites"
    private var didFinishInit = false
    
    init() {
        loadFavorites()
        didFinishInit = true
    }
    
    // MARK: - Favorites Management
    func toggleFavorite(_ position: Position) {
        if favoriteIDs.contains(position.id) {
            favoriteIDs.remove(position.id)
        } else {
            favoriteIDs.insert(position.id)
        }
    }
    
    func isFavorite(_ position: Position) -> Bool {
        favoriteIDs.contains(position.id)
    }
    
    var favoritePositions: [Position] {
        PositionData.allPositions.filter { favoriteIDs.contains($0.id) }
    }
    
    // MARK: - Filtered Positions
    var filteredPositions: [Position] {
        var positions = PositionData.allPositions
        
        if let category = selectedCategory {
            positions = positions.filter { $0.category == category }
        }
        
        if let difficulty = selectedDifficulty {
            positions = positions.filter { $0.difficulty == difficulty }
        }
        
        if !searchText.isEmpty {
            positions = positions.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return positions
    }
    
    // MARK: - Persistence
    private func saveFavorites() {
        let array = Array(favoriteIDs)
        UserDefaults.standard.set(array, forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        if let array = UserDefaults.standard.stringArray(forKey: favoritesKey) {
            favoriteIDs = Set(array)
        }
    }
    
    // MARK: - Stats
    var totalPositions: Int { PositionData.allPositions.count }
    var totalFavorites: Int { favoriteIDs.count }
    
    func positionsCount(for category: PositionCategory) -> Int {
        PositionData.allPositions.filter { $0.category == category }.count
    }
    
    func positionsCount(for difficulty: Difficulty) -> Int {
        PositionData.allPositions.filter { $0.difficulty == difficulty }.count
    }
}
