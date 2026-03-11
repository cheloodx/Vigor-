import Foundation
import SwiftUI

struct Meal: Identifiable {
    let id: UUID
    var name: String
    var mealType: MealType
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var foods: [Food]
    var date: Date
    var imageSystemName: String
    
    enum MealType: String, CaseIterable {
        case breakfast = "Mic Dejun"
        case lunch = "Pranz"
        case dinner = "Cina"
        case snack = "Gustare"
        
        var icon: String {
            switch self {
            case .breakfast: return "sunrise.fill"
            case .lunch: return "sun.max.fill"
            case .dinner: return "moon.fill"
            case .snack: return "leaf.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .breakfast: return .orange
            case .lunch: return .yellow
            case .dinner: return .indigo
            case .snack: return .green
            }
        }
    }
    
    static let samples: [Meal] = [
        Meal(id: UUID(), name: "Omleta cu Legume", mealType: .breakfast, calories: 350, protein: 25, carbs: 15, fat: 20, foods: Food.sampleBreakfast, date: Date(), imageSystemName: "sunrise.fill"),
        Meal(id: UUID(), name: "Piept de Pui cu Orez", mealType: .lunch, calories: 550, protein: 45, carbs: 55, fat: 12, foods: Food.sampleLunch, date: Date(), imageSystemName: "sun.max.fill"),
        Meal(id: UUID(), name: "Somon la Gratar", mealType: .dinner, calories: 480, protein: 38, carbs: 30, fat: 22, foods: Food.sampleDinner, date: Date(), imageSystemName: "moon.fill"),
        Meal(id: UUID(), name: "Shake Proteic", mealType: .snack, calories: 200, protein: 30, carbs: 15, fat: 5, foods: Food.sampleSnack, date: Date(), imageSystemName: "leaf.fill"),
    ]
}

struct Food: Identifiable {
    let id: UUID
    var name: String
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var servingSize: String
    
    static let sampleBreakfast: [Food] = [
        Food(id: UUID(), name: "Oua", calories: 180, protein: 14, carbs: 2, fat: 12, servingSize: "3 buc"),
        Food(id: UUID(), name: "Rosii", calories: 40, protein: 2, carbs: 8, fat: 0.5, servingSize: "100g"),
        Food(id: UUID(), name: "Ardei", calories: 30, protein: 1, carbs: 5, fat: 0.3, servingSize: "80g"),
    ]
    
    static let sampleLunch: [Food] = [
        Food(id: UUID(), name: "Piept de Pui", calories: 280, protein: 40, carbs: 0, fat: 8, servingSize: "200g"),
        Food(id: UUID(), name: "Orez Brun", calories: 220, protein: 5, carbs: 45, fat: 2, servingSize: "150g"),
        Food(id: UUID(), name: "Salata Verde", calories: 50, protein: 2, carbs: 10, fat: 1, servingSize: "100g"),
    ]
    
    static let sampleDinner: [Food] = [
        Food(id: UUID(), name: "Somon", calories: 350, protein: 35, carbs: 0, fat: 20, servingSize: "200g"),
        Food(id: UUID(), name: "Cartofi Dulci", calories: 130, protein: 3, carbs: 30, fat: 0.5, servingSize: "150g"),
    ]
    
    static let sampleSnack: [Food] = [
        Food(id: UUID(), name: "Whey Protein", calories: 120, protein: 25, carbs: 5, fat: 2, servingSize: "1 scoop"),
        Food(id: UUID(), name: "Banana", calories: 80, protein: 1, carbs: 20, fat: 0.3, servingSize: "1 buc"),
    ]
}

struct NutritionGoal {
    var targetCalories: Int
    var targetProtein: Double
    var targetCarbs: Double
    var targetFat: Double
    var waterGoalLiters: Double
    
    static let defaultGoal = NutritionGoal(
        targetCalories: 2200,
        targetProtein: 150,
        targetCarbs: 250,
        targetFat: 70,
        waterGoalLiters: 3.0
    )
}
