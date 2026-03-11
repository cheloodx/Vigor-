import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.dismiss) var dismiss
    @State private var isStarted = false
    @State private var currentExerciseIndex = 0
    @State private var timer: Int = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    workoutHeader
                    
                    // Stats
                    statsRow
                    
                    // Exercise List
                    exerciseList
                    
                    // Start Button
                    PrimaryButton("Start Workout", icon: "play.fill") {
                        isStarted = true
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Theme.primary)
                }
            }
            .fullScreenCover(isPresented: $isStarted) {
                ActiveWorkoutView(workout: workout)
            }
        }
    }
    
    private var workoutHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(workout.category.color.opacity(0.2))
                    .frame(width: 80, height: 80)
                Image(systemName: workout.imageSystemName)
                    .font(.system(size: 36))
                    .foregroundColor(workout.category.color)
            }
            
            Text(workout.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text(workout.description)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                BadgeView(text: workout.category.rawValue, color: workout.category.color)
                BadgeView(text: workout.difficulty.rawValue, color: workout.difficulty.color)
            }
        }
        .padding(.top, 12)
    }
    
    private var statsRow: some View {
        HStack(spacing: 0) {
            statItem(title: "Duration", value: "\(workout.duration) min", icon: "clock.fill")
            Divider().frame(height: 40).background(Theme.textTertiary)
            statItem(title: "Calories", value: "\(workout.caloriesBurned)", icon: "flame.fill")
            Divider().frame(height: 40).background(Theme.textTertiary)
            statItem(title: "Exercises", value: "\(workout.exercises.count)", icon: "list.bullet")
            Divider().frame(height: 40).background(Theme.textTertiary)
            statItem(title: "Reward", value: "+\(workout.fitPointsReward) FP", icon: "star.fill")
        }
        .padding(.vertical, 12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadiusMedium)
    }
    
    private func statItem(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Theme.primary)
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var exerciseList: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Exercises")
            
            ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                CardView(padding: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Theme.primary.opacity(0.2))
                                .frame(width: 36, height: 36)
                            Text("\(index + 1)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.primary)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(exercise.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                            Text("\(exercise.sets) sets x \(exercise.reps) reps")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        if exercise.restSeconds > 0 {
                            Label("\(exercise.restSeconds)s", systemImage: "pause.circle.fill")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textTertiary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Active Workout View
struct ActiveWorkoutView: View {
    let workout: Workout
    @Environment(\.dismiss) var dismiss
    @State private var currentExercise = 0
    @State private var currentSet = 1
    @State private var isResting = false
    @State private var elapsedTime = 0
    @State private var timerActive = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Text(timeString(elapsedTime))
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Text("\(currentExercise + 1)/\(workout.exercises.count)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.primary)
            }
            .padding()
            
            Spacer()
            
            // Current Exercise
            if currentExercise < workout.exercises.count {
                let exercise = workout.exercises[currentExercise]
                
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Theme.primary.opacity(0.15))
                            .frame(width: 120, height: 120)
                        Image(systemName: exercise.imageSystemName)
                            .font(.system(size: 50))
                            .foregroundColor(Theme.primary)
                    }
                    
                    Text(exercise.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Set \(currentSet) of \(exercise.sets)")
                        .font(.system(size: 18))
                        .foregroundColor(Theme.textSecondary)
                    
                    Text("\(exercise.reps) reps")
                        .font(.system(size: 40, weight: .black))
                        .foregroundColor(Theme.primary)
                    
                    if isResting {
                        VStack(spacing: 8) {
                                                        Text("Rest")
                                                            .font(.system(size: 16, weight: .semibold))
                                                            .foregroundColor(Theme.accent)
                            Text("\(exercise.restSeconds)s")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Theme.textPrimary)
                        }
                        .padding()
                        .background(Theme.accent.opacity(0.1))
                        .cornerRadius(Theme.cornerRadiusMedium)
                    }
                }
            }
            
            Spacer()
            
            // Bottom Controls
            HStack(spacing: 20) {
                SecondaryButton("Pause", icon: "pause.fill") {
                    timerActive.toggle()
                }
                
                PrimaryButton("Next", icon: "forward.fill") {
                    nextStep()
                }
            }
            .padding()
        }
        .background(Theme.background.ignoresSafeArea())
        .onReceive(timer) { _ in
            if timerActive {
                elapsedTime += 1
            }
        }
    }
    
    private func nextStep() {
        guard currentExercise < workout.exercises.count else { return }
        let exercise = workout.exercises[currentExercise]
        
        if currentSet < exercise.sets {
            currentSet += 1
            isResting = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isResting = false
            }
        } else {
            currentSet = 1
            currentExercise += 1
            if currentExercise >= workout.exercises.count {
                dismiss()
            }
        }
    }
    
    private func timeString(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
