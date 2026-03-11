import SwiftUI

struct NutritionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDate = Date()
    @State private var waterIntake: Double = 1.5
    @State private var showAddMeal = false
    
    private let nutritionGoal = NutritionGoal.defaultGoal
    
    private var totalCalories: Int {
        Meal.samples.reduce(0) { $0 + $1.calories }
    }
    
    private var totalProtein: Double {
        Meal.samples.reduce(0) { $0 + $1.protein }
    }
    
    private var totalCarbs: Double {
        Meal.samples.reduce(0) { $0 + $1.carbs }
    }
    
    private var totalFat: Double {
        Meal.samples.reduce(0) { $0 + $1.fat }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Date Selector
                    dateSelector
                    
                    // Calorie Summary
                    calorieSummary
                    
                    // Macros
                    macrosSection
                    
                    // Water Tracker
                    waterTracker
                    
                    // Meals
                    mealsSection
                    
                    // Add Meal Button
                    PrimaryButton("Add Meal", icon: "plus") {
                        showAddMeal = true
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Nutrition")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddMeal) {
                AddMealView()
            }
        }
    }
    
    // MARK: - Date Selector
    private var dateSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(-3...3, id: \.self) { offset in
                    let date = Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date()
                    let isToday = offset == 0
                    
                    Button(action: {
                        selectedDate = date
                    }) {
                        VStack(spacing: 4) {
                            Text(dayName(date))
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(isToday ? .black : Theme.textSecondary)
                            Text("\(Calendar.current.component(.day, from: date))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(isToday ? .black : Theme.textPrimary)
                        }
                        .frame(width: 48, height: 60)
                        .background(isToday ? Theme.primary : Theme.cardBackground)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private func dayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).capitalized
    }
    
    // MARK: - Calorie Summary
    private var calorieSummary: some View {
        CardView {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calories Today")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(totalCalories)")
                                .font(.system(size: 32, weight: .black))
                                .foregroundColor(Theme.textPrimary)
                            Text("/ \(nutritionGoal.targetCalories) kcal")
                                .font(.system(size: 16))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    ProgressRing(
                        progress: min(Double(totalCalories) / Double(nutritionGoal.targetCalories), 1.0),
                        lineWidth: 8,
                        color: Theme.primary,
                        size: 70
                    )
                    .overlay(
                        Text("\(Int(Double(totalCalories) / Double(nutritionGoal.targetCalories) * 100))%")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.primary)
                    )
                }
                
                HStack(spacing: 16) {
                    VStack(spacing: 2) {
                        Text("Remaining")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textTertiary)
                        Text("\(max(nutritionGoal.targetCalories - totalCalories, 0))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.success)
                    }
                    
                    Divider().frame(height: 30)
                    
                    VStack(spacing: 2) {
                        Text("Consumed")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textTertiary)
                        Text("\(totalCalories)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.primary)
                    }
                    
                    Divider().frame(height: 30)
                    
                    VStack(spacing: 2) {
                        Text("Burned")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textTertiary)
                        Text("350")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    // MARK: - Macros Section
    private var macrosSection: some View {
        CardView {
            VStack(spacing: 12) {
                SectionHeader(title: "Macronutrients")
                
                HStack(spacing: 16) {
                                        macroBar(title: "Protein", current: totalProtein, target: nutritionGoal.targetProtein, color: .red, unit: "g")
                                        macroBar(title: "Carbs", current: totalCarbs, target: nutritionGoal.targetCarbs, color: .blue, unit: "g")
                                        macroBar(title: "Fat", current: totalFat, target: nutritionGoal.targetFat, color: .yellow, unit: "g")
                }
            }
        }
    }
    
    private func macroBar(title: String, current: Double, target: Double, color: Color, unit: String) -> some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(color.opacity(0.2))
                    .frame(width: 30, height: 80)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 30, height: min(CGFloat(current / target) * 80, 80))
            }
            
            Text("\(Int(current))\(unit)")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(Theme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Water Tracker
    private var waterTracker: some View {
        CardView {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.cyan)
                    Text("Hydration")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Text(String(format: "%.1fL / %.1fL", waterIntake, nutritionGoal.waterGoalLiters))
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                }
                
                ProgressView(value: waterIntake / nutritionGoal.waterGoalLiters)
                    .tint(.cyan)
                
                HStack(spacing: 12) {
                    ForEach([0.25, 0.5, 1.0], id: \.self) { amount in
                        Button(action: {
                            withAnimation { waterIntake = min(waterIntake + amount, nutritionGoal.waterGoalLiters) }
                        }) {
                            Text("+\(amount == 1.0 ? "1L" : "\(Int(amount * 1000))ml")")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.cyan)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.cyan.opacity(0.15))
                                .cornerRadius(16)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Meals Section
    private var mealsSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Today's Meals")
            
            ForEach(Meal.samples) { meal in
                CardView(padding: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(meal.mealType.color.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Image(systemName: meal.mealType.icon)
                                .font(.system(size: 18))
                                .foregroundColor(meal.mealType.color)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(meal.mealType.rawValue)
                                .font(.system(size: 11))
                                .foregroundColor(meal.mealType.color)
                            Text(meal.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                            HStack(spacing: 8) {
                                Text("\(meal.calories) kcal")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textSecondary)
                                Text("P: \(Int(meal.protein))g")
                                    .font(.system(size: 11))
                                    .foregroundColor(.red.opacity(0.7))
                                Text("C: \(Int(meal.carbs))g")
                                    .font(.system(size: 11))
                                    .foregroundColor(.blue.opacity(0.7))
                                Text("G: \(Int(meal.fat))g")
                                    .font(.system(size: 11))
                                    .foregroundColor(.yellow.opacity(0.7))
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textTertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Add Meal View
struct AddMealView: View {
    @Environment(\.dismiss) var dismiss
    @State private var mealName = ""
    @State private var selectedType: Meal.MealType = .lunch
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Meal Type Selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Meal Type")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                        
                        HStack(spacing: 10) {
                            ForEach(Meal.MealType.allCases, id: \.self) { type in
                                Button(action: { selectedType = type }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: type.icon)
                                            .font(.system(size: 20))
                                        Text(type.rawValue)
                                            .font(.system(size: 10, weight: .medium))
                                    }
                                    .foregroundColor(selectedType == type ? .black : Theme.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(selectedType == type ? type.color : Theme.cardBackground)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    // Name
                    inputField(title: "Meal Name", text: $mealName, placeholder: "e.g. Chicken Breast with Rice")
                    
                    // Macros
                    HStack(spacing: 12) {
                                                inputField(title: "Calories", text: $calories, placeholder: "kcal")
                                                inputField(title: "Protein", text: $protein, placeholder: "g")
                    }
                    
                    HStack(spacing: 12) {
                                                inputField(title: "Carbs", text: $carbs, placeholder: "g")
                                                inputField(title: "Fat", text: $fat, placeholder: "g")
                    }
                    
                    PrimaryButton("Save Meal", icon: "checkmark") {
                        dismiss()
                    }
                }
                .padding()
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cancel") { dismiss() }
                            .foregroundColor(Theme.primary)
                    }
                }
            }
        }
    
    private func inputField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            TextField(placeholder, text: text)
                .font(.system(size: 15))
                .foregroundColor(Theme.textPrimary)
                .padding(12)
                .background(Theme.cardBackground)
                .cornerRadius(10)
        }
    }
}
