import SwiftUI

// MARK: - Playlist Recommendations View
struct PlaylistView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(FeatureData.playlists) { playlist in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Text(playlist.icon)
                                        .font(.system(size: 30))
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(playlist.name)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                        Text(playlist.description)
                                            .font(.system(size: 12))
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    Spacer()
                                    Text(playlist.mood)
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.white.opacity(0.08))
                                        .cornerRadius(8)
                                }
                                
                                ForEach(playlist.songs) { song in
                                    HStack(spacing: 10) {
                                        Image(systemName: "music.note")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(hex: "FF6B8A"))
                                        Text(song.title)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.white)
                                        Text("- \(song.artist)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white.opacity(0.5))
                                        Spacer()
                                    }
                                    .padding(.leading, 4)
                                }
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(18)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Playlisturi")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Achievements/Badges View
struct AchievementsView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                            Text("\u{1F3C6}")
                                .font(.system(size: 50))
                            Text("Realizari")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            Text("Deblocheaza realizari pe masura ce explorezi aplicatia!")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom, 8)
                        
                        ForEach(FeatureData.achievements) { badge in
                            HStack(spacing: 14) {
                                Text(badge.icon)
                                    .font(.system(size: 32))
                                    .frame(width: 50, height: 50)
                                    .background(badge.gradient.opacity(0.2))
                                    .cornerRadius(14)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(badge.name)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                    Text(badge.description)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                    Text(badge.requirement)
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.white.opacity(0.2))
                            }
                            .padding(14)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Realizari")
        .navigationBarTitleDisplayMode(.inline)
    }
}
