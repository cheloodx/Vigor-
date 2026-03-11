import SwiftUI

struct TrainingView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: Workout.WorkoutCategory? = nil
    @State private var showWorkoutDetail = false
    @State private var selectedWorkout: Workout? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Category Filter
                    categoryFilter
                    
                    // Active Programs
                    activeProgramsSection
                    
                    // Available Workouts
                    availableWorkoutsSection
                    
                    // Quick Start
                    quickStartSection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Antrenament")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                categoryChip(title: "Toate", icon: "square.grid.2x2.fill", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                
                ForEach(Workout.WorkoutCategory.allCases, id: \.self) { category in
                    categoryChip(title: category.rawValue, icon: category.icon, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    private func categoryChip(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(isSelected ? .black : Theme.textSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Theme.primary : Theme.cardBackground)
            .cornerRadius(20)
        }
    }
    
    // MARK: - Active Programs
    private var activeProgramsSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Programe Active", showSeeAll: true)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(TrainingProgram.samples.filter({ $0.progress > 0 })) { program in
                        programCard(program)
                    }
                }
            }
        }
    }
    
    private func programCard(_ program: TrainingProgram) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle()
                        .fill(program.category.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    Image(systemName: program.imageSystemName)
                        .font(.system(size: 18))
                        .foregroundColor(program.category.color)
                }
                Spacer()
                BadgeView(text: program.difficulty.rawValue, color: program.difficulty.color)
            }
            
            Text(program.name)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .lineLimit(2)
            
            Text("Sapt. \(Int(program.progress * Double(program.durationWeeks))) / \(program.durationWeeks)")
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
            
            ProgressView(value: program.progress)
                .tint(program.category.color)
            
            Text("\(Int(program.progress * 100))% completat")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(program.category.color)
        }
        .padding(14)
        .frame(width: 180)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadiusMedium)
    }
    
    // MARK: - Available Workouts
    private var availableWorkoutsSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Antrenamente Disponibile", showSeeAll: true)
            
            let filteredWorkouts = selectedCategory == nil ? Workout.samples : Workout.samples.filter { $0.category == selectedCategory }
            
            ForEach(filteredWorkouts) { workout in
                Button(action: {
                    selectedWorkout = workout
                    showWorkoutDetail = true
                }) {
                    workoutRow(workout)
                }
            }
        }
        .sheet(isPresented: $showWorkoutDetail) {
            if let workout = selectedWorkout {
                WorkoutDetailView(workout: workout)
            }
        }
    }
    
    private func workoutRow(_ workout: Workout) -> some View {
        CardView(padding: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(workout.category.color.opacity(0.2))
                        .frame(width: 56, height: 56)
                    Image(systemName: workout.imageSystemName)
                        .font(.system(size: 24))
                        .foregroundColor(workout.category.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(workout.description)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                    
                    HStack(spacing: 12) {
                        Label("\(workout.duration) min", systemImage: "clock.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textTertiary)
                        Label("\(workout.caloriesBurned) kcal", systemImage: "flame.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textTertiary)
                        Label("+\(workout.fitPointsReward) FP", systemImage: "star.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.accent)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    BadgeView(text: workout.difficulty.rawValue, color: workout.difficulty.color)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textTertiary)
                }
            }
        }
    }
    
    // MARK: - Quick Start
    private var quickStartSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Start Rapid")
            
            HStack(spacing: 12) {
                quickStartCard(title: "Timer", icon: "timer", color: .green) {}
                quickStartCard(title: "Liber", icon: "figure.run", color: .blue) {}
                quickStartCard(title: "Grup", icon: "person.2.fill", color: .purple) {}
            }
        }
    }
    
    private func quickStartCard(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 46, height: 46)
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
        }
    }
}
