import SwiftUI

// MARK: - Card View
struct CardView<Content: View>: View {
    let content: Content
    var padding: CGFloat = Theme.paddingMedium
    
    init(padding: CGFloat = Theme.paddingMedium, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadiusMedium)
    }
}

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.primaryGradient)
            .cornerRadius(Theme.cornerRadiusMedium)
        }
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(Theme.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.primary.opacity(0.15))
            .cornerRadius(Theme.cornerRadiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadiusMedium)
                    .stroke(Theme.primary.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadiusMedium)
    }
}

// MARK: - Progress Ring
struct ProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let color: Color
    let size: CGFloat
    
    init(progress: Double, lineWidth: CGFloat = 6, color: Color = Theme.primary, size: CGFloat = 60) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.color = color
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var showSeeAll: Bool = false
    var seeAllAction: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Spacer()
            
            if showSeeAll {
                Button(action: { seeAllAction?() }) {
                    Text("See all")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.primary)
                }
            }
        }
    }
}

// MARK: - Badge View
struct BadgeView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(4)
    }
}

// MARK: - FitPoints Display
struct FitPointsDisplay: View {
    let points: Int
    var showIcon: Bool = true
    
    var body: some View {
        HStack(spacing: 4) {
            if showIcon {
                Image(systemName: "flame.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.accent)
            }
            Text("\(points)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Theme.accent)
            Text("FP")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.accent.opacity(0.7))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Theme.accent.opacity(0.15))
        .cornerRadius(20)
    }
}

// MARK: - Animated Shimmer
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [.clear, .white.opacity(0.1), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        phase = 300
                    }
                }
            )
            .clipped()
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}
