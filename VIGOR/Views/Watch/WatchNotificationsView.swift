import SwiftUI

struct DateNightGeneratorView: View {
    @State private var currentIdea: DateNightIdea? = nil
    @State private var selectedCategory: String? = nil
    
    private let categories = ["Toate", "Acasa", "Afara", "Oras", "Activitate", "Aventura"]
    
    var filteredIdeas: [DateNightIdea] {
        if let cat = selectedCategory, cat != "Toate" {
            return FeatureData.dateNightIdeas.filter { $0.category == cat }
        }
        return FeatureData.dateNightIdeas
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    if let idea = currentIdea {
                            VStack(spacing: 14) {
                                Text(idea.icon)
                                    .font(.system(size: 50))
                                Text(idea.title)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                Text(idea.description)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                
                                HStack(spacing: 16) {
                                    Label(idea.category, systemImage: "tag.fill")
                                    Label(idea.budget, systemImage: "creditcard.fill")
                                    Label(idea.duration, systemImage: "clock.fill")
                                }
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white.opacity(0.5))
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                currentIdea = filteredIdeas.randomElement()
                            }
                        }) {
                            HStack {
                                Image(systemName: "sparkles")
                                Text(currentIdea == nil ? "Genereaza o Idee" : "Alta Idee")
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.primaryGradient)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(categories, id: \.self) { cat in
                                    Button(action: { selectedCategory = cat }) {
                                        Text(cat)
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(selectedCategory == cat || (selectedCategory == nil && cat == "Toate") ? .white : .white.opacity(0.6))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background((selectedCategory == cat || (selectedCategory == nil && cat == "Toate")) ? AnyView(Theme.primaryGradient) : AnyView(Color.white.opacity(0.08)))
                                            .cornerRadius(16)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        VStack(spacing: 10) {
                            ForEach(filteredIdeas) { idea in
                                Button(action: {
                                    withAnimation { currentIdea = idea }
                                }) {
                                    HStack(spacing: 12) {
                                        Text(idea.icon)
                                            .font(.system(size: 24))
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(idea.title)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.white)
                                            HStack(spacing: 8) {
                                                Text(idea.budget)
                                                Text("\u{2022}")
                                                Text(idea.duration)
                                            }
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.4))
                                        }
                                        Spacer()
                                        Text(idea.category)
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white.opacity(0.5))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.white.opacity(0.08))
                                            .cornerRadius(8)
                                    }
                                    .padding(12)
                                    .background(Color.white.opacity(0.04))
                                    .cornerRadius(14)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Date Night")
        .navigationBarTitleDisplayMode(.inline)
    }
}
