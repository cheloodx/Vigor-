import SwiftUI

struct InfoView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(Theme.primaryGradient)
                            
                            Text("Kamasutra Guide")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Theme.textPrimary)
                            
                            Text("Ghidul complet al intimitatii")
                                .font(.system(size: 16))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 10)
                        
                        // Statistics Card
                        statsCard
                        
                        // Category Breakdown
                        categoryBreakdown
                        
                        // Difficulty Breakdown
                        difficultyBreakdown
                        
                        // About Section
                        aboutSection
                        
                        // Disclaimer
                        disclaimerSection
                        
                        // Version
                        Text("Versiunea 1.0.0")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textMuted)
                            .padding(.bottom, 30)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Stats Card
    private var statsCard: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Statistici", icon: "chart.bar.fill")
            
            HStack(spacing: 20) {
                statItem(value: "\(appState.totalPositions)", label: "Pozitii", icon: "square.grid.2x2.fill")
                statItem(value: "\(appState.totalFavorites)", label: "Favorite", icon: "heart.fill")
                statItem(value: "4", label: "Categorii", icon: "folder.fill")
                statItem(value: "4", label: "Niveluri", icon: "chart.bar.fill")
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(12)
    }
    
    private func statItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Theme.primary)
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Category Breakdown
    private var categoryBreakdown: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Categorii", icon: "tag.fill")
            
            ForEach(PositionCategory.allCases, id: \.self) { category in
                HStack {
                    Image(systemName: category.icon)
                        .font(.system(size: 16))
                        .foregroundColor(Theme.categoryColor(category))
                        .frame(width: 30)
                    
                    Text(category.displayName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Text("\(appState.positionsCount(for: category))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.categoryColor(category))
                }
                .padding(.vertical, 4)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(12)
    }
    
    // MARK: - Difficulty Breakdown
    private var difficultyBreakdown: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Niveluri de dificultate", icon: "chart.bar.fill")
            
            ForEach(Difficulty.allCases, id: \.self) { difficulty in
                HStack {
                    Circle()
                        .fill(Theme.difficultyColor(difficulty))
                        .frame(width: 10, height: 10)
                    
                    Text(difficulty.displayName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Text("\(appState.positionsCount(for: difficulty))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.difficultyColor(difficulty))
                }
                .padding(.vertical, 4)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(12)
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Despre aplicatie", icon: "info.circle.fill")
            
            Text("Kamasutra Guide este un ghid educational complet care prezinta 57 de pozitii din arta clasica a iubirii. Aplicatia ofera informatii detaliate despre fiecare pozitie, inclusiv beneficii, sfaturi practice si variatii.")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(4)
            
            Text("Aceasta aplicatie este destinata exclusiv adultilor si are un scop educational. Toate informatiile sunt prezentate intr-o maniera respectuoasa si informativa.")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(12)
    }
    
    // MARK: - Disclaimer
    private var disclaimerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                Text("Avertisment")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.yellow)
            }
            
            Text("Aceasta aplicatie este destinata exclusiv persoanelor cu varsta de peste 18 ani. Continutul are un caracter educational si informativ. Practicati intotdeauna comunicarea deschisa cu partenerul.")
                .font(.system(size: 13))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(3)
        }
        .padding(16)
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
        )
    }
}
