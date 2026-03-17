import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var appState: AppState
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Favorite")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                Text("\(appState.totalFavorites) pozitii salvate")
                                    .font(.system(size: 14))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            Spacer()
                            
                            Image(systemName: "heart.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Theme.primary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        if appState.favoritePositions.isEmpty {
                            EmptyStateView(
                                icon: "heart.slash",
                                title: "Nicio pozitie favorita",
                                message: "Apasati pe inima de pe orice pozitie pentru a o adauga la favorite."
                            )
                            .padding(.top, 60)
                        } else {
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(appState.favoritePositions) { position in
                                    NavigationLink(destination: PositionDetailView(position: position)) {
                                        PositionCard(
                                            position: position,
                                            isFavorite: true,
                                            onFavoriteToggle: { appState.toggleFavorite(position) }
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
