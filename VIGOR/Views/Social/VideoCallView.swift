import SwiftUI

// MARK: - Game Detail Router View
struct GameDetailView: View {
    let game: CoupleGame
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            Group {
                switch game.id {
                case "truth-or-dare":
                    TruthOrDareGameView()
                case "would-you-rather":
                    WouldYouRatherGameView()
                case "dice-game":
                    DiceGameView()
                case "quiz":
                    QuizGameView()
                case "challenges":
                    ChallengesGameView()
                case "position-roulette":
                    PositionRouletteView()
                        .environmentObject(appState)
                default:
                    Text("Joc in curs de dezvoltare")
                }
            }
            .background(Theme.backgroundGradient.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
        }
    }
}

// MARK: - Truth or Dare Game
struct TruthOrDareGameView: View {
    @State private var currentCard: TruthOrDareCard?
    @State private var showCard = false
    @State private var selectedType: TruthOrDareType?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Adevar sau Provocare")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Theme.primaryGradient)
                
                Text("Alege intre Adevar si Provocare!")
                    .foregroundColor(.white.opacity(0.6))
                
                if let card = currentCard, showCard {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: card.type.icon)
                                .foregroundColor(card.type.color)
                            Text(card.type.rawValue)
                                .fontWeight(.bold)
                                .foregroundColor(card.type.color)
                        }
                        .font(.title3)
                        
                        Text(card.text)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack(spacing: 4) {
                            ForEach(0..<5) { i in
                                Image(systemName: i < card.intensity ? "flame.fill" : "flame")
                                    .foregroundColor(i < card.intensity ? Color(hex: "FF6B8A") : .white.opacity(0.3))
                            }
                        }
                        .font(.caption)
                        
                        Text("Intensitate: \(card.intensity)/5")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                    )
                    .padding(.horizontal)
                    .transition(.scale.combined(with: .opacity))
                }
                
                HStack(spacing: 16) {
                    Button(action: { drawCard(.truth) }) {
                        HStack {
                            Image(systemName: "bubble.left.fill")
                            Text("Adevar")
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [Color(hex: "4FC3F7"), Color(hex: "0288D1")], startPoint: .top, endPoint: .bottom))
                        )
                    }
                    
                    Button(action: { drawCard(.dare) }) {
                        HStack {
                            Image(systemName: "flame.fill")
                            Text("Provocare")
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Theme.primaryGradient)
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
        }
    }
    
    private func drawCard(_ type: TruthOrDareType) {
        withAnimation(.spring(response: 0.5)) {
            showCard = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let cards = type == .truth ? GameData.truthCards : GameData.dareCards
            currentCard = cards.randomElement()
            withAnimation(.spring(response: 0.5)) {
                showCard = true
            }
        }
    }
}

// MARK: - Would You Rather Game
struct WouldYouRatherGameView: View {
    @State private var currentCard: WouldYouRatherCard?
    @State private var selectedOption: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Ce Ai Prefera?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex: "A55EEA"), Color(hex: "8854D0")], startPoint: .leading, endPoint: .trailing)
                    )
                
                if let card = currentCard {
                    VStack(spacing: 16) {
                        Text(card.category)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(hex: "A55EEA").opacity(0.3))
                            .cornerRadius(10)
                            .foregroundColor(Color(hex: "A55EEA"))
                        
                        Button(action: { selectedOption = "A" }) {
                            Text(card.optionA)
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(selectedOption == "A" ? Color(hex: "A55EEA") : Color.white.opacity(0.08))
                                )
                        }
                        
                        Text("SAU")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.4))
                        
                        Button(action: { selectedOption = "B" }) {
                            Text(card.optionB)
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(selectedOption == "B" ? Color(hex: "8854D0") : Color.white.opacity(0.08))
                                )
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.05))
                    )
                    .padding(.horizontal)
                }
                
                Button(action: { nextCard() }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text(currentCard == nil ? "Incepe Jocul" : "Urmatoarea Intrebare")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [Color(hex: "A55EEA"), Color(hex: "8854D0")], startPoint: .leading, endPoint: .trailing))
                    )
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
        }
    }
    
    private func nextCard() {
        selectedOption = nil
        currentCard = GameData.wouldYouRather.randomElement()
    }
}

// MARK: - Dice Game
struct DiceGameView: View {
    @State private var currentAction: DiceAction?
    @State private var isRolling = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Zarurile Pasiunii")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex: "FF6348"), Color(hex: "EE5A24")], startPoint: .leading, endPoint: .trailing)
                    )
                
                Text("Arunca zarurile si urmeaza instructiunile!")
                    .foregroundColor(.white.opacity(0.6))
                
                // Dice display
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(colors: [Color(hex: "FF6348").opacity(0.2), Color(hex: "EE5A24").opacity(0.1)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "dice.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(LinearGradient(colors: [Color(hex: "FF6348"), Color(hex: "EE5A24")], startPoint: .top, endPoint: .bottom))
                        .rotationEffect(.degrees(isRolling ? 360 : 0))
                }
                
                if let action = currentAction {
                    VStack(spacing: 16) {
                        Image(systemName: action.icon)
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex: "FF6348"))
                        
                        Text(action.action)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(action.bodyPart)
                            .font(.title3)
                            .foregroundColor(Color(hex: "FF6348"))
                        
                        HStack {
                            Image(systemName: "clock.fill")
                            Text(action.duration)
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.08))
                    )
                    .padding(.horizontal)
                    .transition(.scale.combined(with: .opacity))
                }
                
                Button(action: { rollDice() }) {
                    HStack {
                        Image(systemName: "dice.fill")
                        Text("Arunca Zarurile!")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [Color(hex: "FF6348"), Color(hex: "EE5A24")], startPoint: .leading, endPoint: .trailing))
                    )
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
        }
    }
    
    private func rollDice() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isRolling = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring()) {
                isRolling = false
                currentAction = GameData.diceActions.randomElement()
            }
        }
    }
}
