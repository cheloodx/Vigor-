import SwiftUI

// MARK: - Games List View
struct GamesListView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedGame: CoupleGame?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Jocuri de Cuplu")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(Theme.primaryGradient)
                        
                        Text("Distractie si intimitate")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text("\(GameData.allGames.count) Jocuri")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Theme.primaryGradient)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, 8)
                    
                    // Games Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(GameData.allGames) { game in
                            GameCard(game: game)
                                .onTapGesture {
                                    selectedGame = game
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 20)
            }
            .background(Theme.backgroundGradient.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(item: $selectedGame) { game in
                GameDetailView(game: game)
                    .environmentObject(appState)
            }
        }
    }
}

// MARK: - Game Card
struct GameCard: View {
    let game: CoupleGame
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(game.gradient.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                Image(systemName: game.icon)
                    .font(.system(size: 26))
                    .foregroundStyle(game.gradient)
            }
            
            Text(game.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(game.description)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(LinearGradient(
                    colors: [Color.white.opacity(0.08), Color.white.opacity(0.03)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(game.gradient, lineWidth: 1)
                .opacity(0.3)
        )
    }
}
