import Foundation
import SwiftUI

struct Workout: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var category: WorkoutCategory
    var difficulty: Difficulty
    var duration: Int // minutes
    var caloriesBurned: Int
    var exercises: [Exercise]
    var imageSystemName: String
    var fitPointsReward: Int
    
    enum WorkoutCategory: String, CaseIterable {
        case strength = "Forta"
        case cardio = "Cardio"
        case flexibility = "Flexibilitate"
        case hiit = "HIIT"
        case yoga = "Yoga"
        case functional = "Functional"
        
        var icon: String {
            switch self {
            case .strength: return "dumbbell.fill"
            case .cardio: return "heart.fill"
            case .flexibility: return "figure.flexibility"
            case .hiit: return "bolt.fill"
            case .yoga: return "figure.mind.and.body"
            case .functional: return "figure.cross.training"
            }
        }
        
        var color: Color {
            switch self {
            case .strength: return Theme.primary
            case .cardio: return .red
            case .flexibility: return .green
            case .hiit: return .orange
            case .yoga: return .purple
            case .functional: return .blue
            }
        }
    }
    
    enum Difficulty: String, CaseIterable {
        case beginner = "Incepator"
        case intermediate = "Intermediar"
        case advanced = "Avansat"
        case elite = "Elit"
        
        var color: Color {
            switch self {
            case .beginner: return .green
            case .intermediate: return .yellow
            case .advanced: return .orange
            case .elite: return .red
            }
        }
    }
    
    static let samples: [Workout] = [
        Workout(
            id: UUID(), name: "Putere Totala", description: "Antrenament complet de forta pentru tot corpul",
            category: .strength, difficulty: .intermediate, duration: 45, caloriesBurned: 350,
            exercises: Exercise.sampleStrength, imageSystemName: "dumbbell.fill", fitPointsReward: 50
        ),
        Workout(
            id: UUID(), name: "Cardio Intens", description: "Sesiune de cardio de inalta intensitate",
            category: .cardio, difficulty: .advanced, duration: 30, caloriesBurned: 400,
            exercises: Exercise.sampleCardio, imageSystemName: "heart.fill", fitPointsReward: 60
        ),
        Workout(
            id: UUID(), name: "HIIT Fulger", description: "Antrenament HIIT scurt si eficient",
            category: .hiit, difficulty: .advanced, duration: 20, caloriesBurned: 300,
            exercises: Exercise.sampleHIIT, imageSystemName: "bolt.fill", fitPointsReward: 45
        ),
        Workout(
            id: UUID(), name: "Yoga Dimineata", description: "Sesiune de yoga pentru energie si flexibilitate",
            category: .yoga, difficulty: .beginner, duration: 30, caloriesBurned: 150,
            exercises: Exercise.sampleYoga, imageSystemName: "figure.mind.and.body", fitPointsReward: 30
        ),
        Workout(
            id: UUID(), name: "Flexibilitate & Stretching", description: "Imbunatateste mobilitatea si flexibilitatea",
            category: .flexibility, difficulty: .beginner, duration: 25, caloriesBurned: 100,
            exercises: Exercise.sampleFlexibility, imageSystemName: "figure.flexibility", fitPointsReward: 25
        ),
        Workout(
            id: UUID(), name: "Functional Elite", description: "Antrenament functional pentru performanta maxima",
            category: .functional, difficulty: .elite, duration: 60, caloriesBurned: 550,
            exercises: Exercise.sampleStrength, imageSystemName: "figure.cross.training", fitPointsReward: 80
        )
    ]
}

struct Exercise: Identifiable {
    let id: UUID
    var name: String
    var sets: Int
    var reps: Int
    var restSeconds: Int
    var imageSystemName: String
    
    static let sampleStrength: [Exercise] = [
        Exercise(id: UUID(), name: "Genuflexiuni cu Bara", sets: 4, reps: 10, restSeconds: 90, imageSystemName: "figure.strengthtraining.traditional"),
        Exercise(id: UUID(), name: "Impins de pe Banca", sets: 4, reps: 8, restSeconds: 90, imageSystemName: "figure.strengthtraining.traditional"),
        Exercise(id: UUID(), name: "Trase la Bara", sets: 3, reps: 10, restSeconds: 60, imageSystemName: "figure.strengthtraining.traditional"),
        Exercise(id: UUID(), name: "Presa Umeri", sets: 3, reps: 12, restSeconds: 60, imageSystemName: "figure.strengthtraining.traditional"),
    ]
    
    static let sampleCardio: [Exercise] = [
        Exercise(id: UUID(), name: "Alergare", sets: 1, reps: 1, restSeconds: 0, imageSystemName: "figure.run"),
        Exercise(id: UUID(), name: "Sarituri cu Coarda", sets: 3, reps: 100, restSeconds: 30, imageSystemName: "figure.jumprope"),
        Exercise(id: UUID(), name: "Bicicleta", sets: 1, reps: 1, restSeconds: 0, imageSystemName: "figure.outdoor.cycle"),
    ]
    
    static let sampleHIIT: [Exercise] = [
        Exercise(id: UUID(), name: "Burpees", sets: 4, reps: 15, restSeconds: 30, imageSystemName: "figure.highintensity.intervaltraining"),
        Exercise(id: UUID(), name: "Mountain Climbers", sets: 4, reps: 20, restSeconds: 20, imageSystemName: "figure.highintensity.intervaltraining"),
        Exercise(id: UUID(), name: "Jump Squats", sets: 4, reps: 15, restSeconds: 30, imageSystemName: "figure.highintensity.intervaltraining"),
    ]
    
    static let sampleYoga: [Exercise] = [
        Exercise(id: UUID(), name: "Salutul Soarelui", sets: 3, reps: 5, restSeconds: 15, imageSystemName: "figure.mind.and.body"),
        Exercise(id: UUID(), name: "Pozitia Razboinicului", sets: 2, reps: 1, restSeconds: 10, imageSystemName: "figure.mind.and.body"),
        Exercise(id: UUID(), name: "Pozitia Copacului", sets: 2, reps: 1, restSeconds: 10, imageSystemName: "figure.mind.and.body"),
    ]
    
    static let sampleFlexibility: [Exercise] = [
        Exercise(id: UUID(), name: "Stretching Spate", sets: 2, reps: 1, restSeconds: 30, imageSystemName: "figure.flexibility"),
        Exercise(id: UUID(), name: "Stretching Picioare", sets: 2, reps: 1, restSeconds: 30, imageSystemName: "figure.flexibility"),
        Exercise(id: UUID(), name: "Rotiri Umeri", sets: 2, reps: 15, restSeconds: 15, imageSystemName: "figure.flexibility"),
    ]
}

struct TrainingProgram: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var durationWeeks: Int
    var workoutsPerWeek: Int
    var difficulty: Workout.Difficulty
    var category: Workout.WorkoutCategory
    var progress: Double
    var imageSystemName: String
    
    static let samples: [TrainingProgram] = [
        TrainingProgram(id: UUID(), name: "Putere Maxima 8 Saptamani", description: "Program complet de forta pentru masa musculara", durationWeeks: 8, workoutsPerWeek: 4, difficulty: .intermediate, category: .strength, progress: 0.35, imageSystemName: "dumbbell.fill"),
        TrainingProgram(id: UUID(), name: "Cardio Warrior", description: "Creste rezistenta cardiovasculara", durationWeeks: 6, workoutsPerWeek: 5, difficulty: .advanced, category: .cardio, progress: 0.6, imageSystemName: "heart.fill"),
        TrainingProgram(id: UUID(), name: "HIIT Transformation", description: "Transformare corporala in 4 saptamani", durationWeeks: 4, workoutsPerWeek: 3, difficulty: .advanced, category: .hiit, progress: 0.0, imageSystemName: "bolt.fill"),
        TrainingProgram(id: UUID(), name: "Zen Master Yoga", description: "Yoga si mindfulness pentru echilibru", durationWeeks: 12, workoutsPerWeek: 3, difficulty: .beginner, category: .yoga, progress: 0.15, imageSystemName: "figure.mind.and.body"),
    ]
}
