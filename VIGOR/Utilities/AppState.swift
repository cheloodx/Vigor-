import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var currentUser: User = User.sample
    @Published var fitPoints: Int = 2450
    @Published var dailyStreak: Int = 5
    @Published var selectedTab: Tab = .home
    
    enum Tab: Int {
        case home = 0
        case training = 1
        case community = 2
        case nutrition = 3
        case profile = 4
    }
    
    func addFitPoints(_ amount: Int) {
        withAnimation {
            fitPoints += amount
        }
    }
    
    func spendFitPoints(_ amount: Int) -> Bool {
        guard fitPoints >= amount else { return false }
        withAnimation {
            fitPoints -= amount
        }
        return true
    }
}
