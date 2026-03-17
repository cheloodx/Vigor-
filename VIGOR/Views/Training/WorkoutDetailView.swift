import SwiftUI

// MARK: - Quiz Game View
struct QuizGameView: View {
    @State private var currentQuestion: QuizQuestion?
    @State private var selectedAnswer: Int?
    @State private var showExplanation = false
    @State private var score = 0
    @State private var questionsAnswered = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Cat de Bine Ma Cunosti?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex: "4FC3F7"), Color(hex: "0288D1")], startPoint: .leading, endPoint: .trailing)
                    )
                
                // Score
                HStack(spacing: 20) {
                    VStack {
                        Text("\(score)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "4CAF50"))
                        Text("Corecte")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    VStack {
                        Text("\(questionsAnswered)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "4FC3F7"))
                        Text("Intrebari")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.08))
                )
                
                if let question = currentQuestion {
                    VStack(spacing: 16) {
                        Text(question.question)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        ForEach(0..<question.options.count, id: \.self) { index in
                            Button(action: {
                                if selectedAnswer == nil {
                                    selectedAnswer = index
                                    showExplanation = true
                                    questionsAnswered += 1
                                    if index == question.correctIndex {
                                        score += 1
                                    }
                                }
                            }) {
                                HStack {
                                    Text(question.options[index])
                                        .foregroundColor(.white)
                                    Spacer()
                                    if let selected = selectedAnswer {
                                        if index == question.correctIndex {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(Color(hex: "4CAF50"))
                                        } else if index == selected {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(Color(hex: "F44336"))
                                        }
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(backgroundColor(for: index))
                                )
                            }
                        }
                        
                        if showExplanation {
                            VStack(spacing: 8) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(Color(hex: "FFB74D"))
                                Text(question.explanation)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "FFB74D").opacity(0.1))
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                Button(action: { nextQuestion() }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text(currentQuestion == nil ? "Incepe Quiz-ul" : "Urmatoarea Intrebare")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [Color(hex: "4FC3F7"), Color(hex: "0288D1")], startPoint: .leading, endPoint: .trailing))
                    )
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
        }
    }
    
    private func backgroundColor(for index: Int) -> Color {
        guard let selected = selectedAnswer, let question = currentQuestion else {
            return Color.white.opacity(0.08)
        }
        if index == question.correctIndex {
            return Color(hex: "4CAF50").opacity(0.3)
        } else if index == selected {
            return Color(hex: "F44336").opacity(0.3)
        }
        return Color.white.opacity(0.08)
    }
    
    private func nextQuestion() {
        selectedAnswer = nil
        showExplanation = false
        currentQuestion = GameData.quizQuestions.randomElement()
    }
}

// MARK: - Challenges Game View
struct ChallengesGameView: View {
    @State private var currentChallenge: ChallengeCard?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Provocari de Cuplu")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex: "FFB74D"), Color(hex: "FF8F00")], startPoint: .leading, endPoint: .trailing)
                    )
                
                Text("Alege o provocare si distreaza-va impreuna!")
                    .foregroundColor(.white.opacity(0.6))
                
                if let challenge = currentChallenge {
                    VStack(spacing: 16) {
                        Image(systemName: challenge.icon)
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex: "FFB74D"))
                        
                        Text(challenge.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(challenge.description)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            HStack {
                                Image(systemName: "clock.fill")
                                Text(challenge.duration)
                            }
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            
                            HStack {
                                Image(systemName: "speedometer")
                                Text(challenge.difficulty)
                            }
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                            .foregroundColor(Color(hex: "FFB74D"))
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.08))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "FFB74D").opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .transition(.scale.combined(with: .opacity))
                }
                
                Button(action: {
                    withAnimation(.spring()) {
                        currentChallenge = GameData.challenges.randomElement()
                    }
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                        Text(currentChallenge == nil ? "Alege o Provocare" : "Alta Provocare")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [Color(hex: "FFB74D"), Color(hex: "FF8F00")], startPoint: .leading, endPoint: .trailing))
                    )
                }
                .padding(.horizontal)
                
                // Show all challenges list
                VStack(alignment: .leading, spacing: 12) {
                    Text("Toate Provocarile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ForEach(GameData.challenges) { challenge in
                        HStack(spacing: 12) {
                            Image(systemName: challenge.icon)
                                .font(.title3)
                                .foregroundColor(Color(hex: "FFB74D"))
                                .frame(width: 36)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(challenge.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text(challenge.description)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            Text(challenge.difficulty)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Position Roulette View
struct PositionRouletteView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPosition: Position?
    @State private var isSpinning = false
    @State private var rotation: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Ruleta Pozitiilor")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex: "FC5C7D"), Color(hex: "6A82FB")], startPoint: .leading, endPoint: .trailing)
                    )
                
                Text("Lasa soarta sa aleaga pentru voi!")
                    .foregroundColor(.white.opacity(0.6))
                
                // Spinning wheel
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color(hex: "FC5C7D").opacity(0.2), Color(hex: "6A82FB").opacity(0.2)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 150, height: 150)
                    
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 50))
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "FC5C7D"), Color(hex: "6A82FB")], startPoint: .top, endPoint: .bottom))
                        .rotationEffect(.degrees(rotation))
                }
                
                if let position = selectedPosition {
                    VStack(spacing: 16) {
                        Image(position.id)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .clipped()
                            .cornerRadius(16)
                        
                        Text(position.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            Text(position.category.displayName)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Theme.categoryColor(position.category).opacity(0.3))
                                .cornerRadius(8)
                                .foregroundColor(Theme.categoryColor(position.category))
                            
                            Text(position.difficulty.displayName)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Theme.difficultyColor(position.difficulty).opacity(0.3))
                                .cornerRadius(8)
                                .foregroundColor(Theme.difficultyColor(position.difficulty))
                        }
                        
                        Text(position.description)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.08))
                    )
                    .padding(.horizontal)
                    .transition(.scale.combined(with: .opacity))
                }
                
                Button(action: { spin() }) {
                    HStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text(selectedPosition == nil ? "Invarte Ruleta!" : "Invarte Din Nou!")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [Color(hex: "FC5C7D"), Color(hex: "6A82FB")], startPoint: .leading, endPoint: .trailing))
                    )
                }
                .padding(.horizontal)
                .disabled(isSpinning)
            }
            .padding(.top, 20)
        }
    }
    
    private func spin() {
        isSpinning = true
        withAnimation(.easeInOut(duration: 1.5)) {
            rotation += Double.random(in: 720...1440)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring()) {
                selectedPosition = PositionData.allPositions.randomElement()
                isSpinning = false
            }
        }
    }
}
