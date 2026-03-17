import SwiftUI

struct CompatibilityQuizView: View {
    @State private var currentQuestion = 0
    @State private var answersP1: [Int] = []
    @State private var answersP2: [Int] = []
    @State private var isPartner2 = false
    @State private var showResult = false
    @State private var started = false
    
    private let questions = FeatureData.compatibilityQuestions
    
    var compatibilityScore: Int {
        guard !answersP1.isEmpty && !answersP2.isEmpty else { return 0 }
        var matches = 0
        for i in 0..<min(answersP1.count, answersP2.count) {
            if answersP1[i] == answersP2[i] { matches += 1 }
        }
        return Int(Double(matches) / Double(questions.count) * 100)
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            if showResult {
                resultView
            } else if started {
                questionView
            } else {
                startView
            }
        }
        .navigationTitle("Compatibilitate")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var startView: some View {
        VStack(spacing: 20) {
            Text("\u{1F491}")
                .font(.system(size: 60))
            Text("Test de\nCompatibilitate")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text("Ambii parteneri raspund la aceleasi 10 intrebari separat, apoi vedeti cat de compatibili sunteti!")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Button(action: { started = true; isPartner2 = false; currentQuestion = 0; answersP1 = []; answersP2 = [] }) {
                Text("Partenerul 1 - Incepe")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.primaryGradient)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 30)
        }
    }
    
    var questionView: some View {
        VStack(spacing: 20) {
            Text(isPartner2 ? "Partenerul 2" : "Partenerul 1")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "FF6B8A"))
            
            Text("Intrebarea \(currentQuestion + 1)/\(questions.count)")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.5))
            
            let q = questions[currentQuestion]
            
            Text(q.question)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                ForEach(q.options.indices, id: \.self) { i in
                    Button(action: { selectAnswer(i) }) {
                        Text(q.options[i])
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(14)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top, 20)
    }
    
    var resultView: some View {
        VStack(spacing: 20) {
            Text(compatibilityScore >= 70 ? "\u{1F495}" : compatibilityScore >= 40 ? "\u{1F49B}" : "\u{1F4AA}")
                .font(.system(size: 60))
            
            Text("\(compatibilityScore)%")
                .font(.system(size: 50, weight: .bold))
                .foregroundStyle(Theme.primaryGradient)
            
            Text("Compatibilitate")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.6))
            
            Text(compatibilityScore >= 70 ? "Sunteti foarte compatibili! Ganditi la fel in multe privinte." : compatibilityScore >= 40 ? "Aveti o compatibilitate buna! Diferentele va fac mai interesanti." : "Sunteti diferiti, dar opusele se atrag! Comunicarea este cheia.")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Button(action: { showResult = false; started = false }) {
                Text("Refa Testul")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.primaryGradient)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 30)
        }
    }
    
    private func selectAnswer(_ index: Int) {
        if isPartner2 {
            answersP2.append(index)
        } else {
            answersP1.append(index)
        }
        
        if currentQuestion + 1 >= questions.count {
            if isPartner2 {
                showResult = true
            } else {
                isPartner2 = true
                currentQuestion = 0
            }
        } else {
            withAnimation { currentQuestion += 1 }
        }
    }
}
