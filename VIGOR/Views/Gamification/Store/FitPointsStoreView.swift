import SwiftUI

struct LoveLanguageTestView: View {
    @State private var currentQuestion = 0
    @State private var scores: [LoveLanguage: Int] = [:]
    @State private var showResult = false
    @State private var started = false
    
    private let questions = FeatureData.loveLanguageQuestions
    
    var topLanguage: LoveLanguage {
        scores.max(by: { $0.value < $1.value })?.key ?? .qualityTime
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
        .navigationTitle("Limbajul Iubirii")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var startView: some View {
        VStack(spacing: 20) {
            Text("\u{1F49D}")
                .font(.system(size: 60))
            Text("Descopera Limbajul\nTau al Iubirii")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text("Raspunde la 15 intrebari pentru a descoperi cum preferi sa primesti si sa oferi iubire.")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Button(action: { started = true; currentQuestion = 0; scores = [:] }) {
                Text("Incepe Testul")
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
            HStack {
                Text("Intrebarea \(currentQuestion + 1)/\(questions.count)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
            }
            .padding(.horizontal)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.primaryGradient)
                        .frame(width: geo.size.width * Double(currentQuestion) / Double(questions.count), height: 6)
                }
            }
            .frame(height: 6)
            .padding(.horizontal)
            
            Text("Ce preferi?")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            let q = questions[currentQuestion]
            
            Button(action: { answer(q.languageA) }) {
                Text(q.optionA)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(16)
            }
            .padding(.horizontal)
            
            Text("sau")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white.opacity(0.3))
            
            Button(action: { answer(q.languageB) }) {
                Text(q.optionB)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(16)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 16)
    }
    
    var resultView: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("\u{1F49D}")
                    .font(.system(size: 50))
                Text("Limbajul Tau al Iubirii")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
                
                Text(topLanguage.rawValue)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Image(systemName: topLanguage.icon)
                    .font(.system(size: 40))
                    .foregroundColor(topLanguage.color)
                
                Text(topLanguage.langDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                VStack(spacing: 10) {
                    ForEach(LoveLanguage.allCases, id: \.self) { lang in
                        HStack {
                            Image(systemName: lang.icon)
                                .foregroundColor(lang.color)
                                .frame(width: 24)
                            Text(lang.rawValue)
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(scores[lang, default: 0])")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(lang.color)
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                Button(action: { showResult = false; started = false }) {
                    Text("Refa Testul")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.primaryGradient)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
    }
    
    private func answer(_ language: LoveLanguage) {
        scores[language, default: 0] += 1
        if currentQuestion + 1 >= questions.count {
            showResult = true
        } else {
            withAnimation { currentQuestion += 1 }
        }
    }
}
