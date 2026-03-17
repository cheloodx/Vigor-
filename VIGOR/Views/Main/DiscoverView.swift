import SwiftUI

struct DiscoverView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text("\u{2728}")
                                .font(.system(size: 50))
                            Text("Descopera")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text("Exploreaza toate functiile pentru cupluri")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.bottom, 8)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            ForEach(FeatureData.discoverFeatures) { feature in
                                NavigationLink(destination: destinationView(for: feature.id)) {
                                    VStack(spacing: 10) {
                                        Text(feature.icon)
                                            .font(.system(size: 36))
                                        Text(feature.name)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                        Text(feature.description)
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.5))
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 8)
                                    .background(feature.gradient.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(Color(hex: feature.color1).opacity(0.3), lineWidth: 1)
                                    )
                                    .cornerRadius(18)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Descopera")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    func destinationView(for featureId: String) -> some View {
        switch featureId {
        case "quotes": RomanticQuotesView()
        case "mood": MoodTrackerView()
        case "datenight": DateNightGeneratorView()
        case "massage": MassageTimerView()
        case "bucketlist": BucketListView()
        case "playlists": PlaylistView()
        case "lovelanguage": LoveLanguageTestView()
        case "compatibility": CompatibilityQuizView()
        case "achievements": AchievementsView()
        default: EmptyView()
        }
    }
}
