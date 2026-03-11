import SwiftUI

struct UnboxingView: View {
    let package: SurprisePackage
    @Environment(\.dismiss) var dismiss
    @State private var phase: UnboxingPhase = .intro
    @State private var shakeAmount: CGFloat = 0
    @State private var glowOpacity: Double = 0
    @State private var revealScale: CGFloat = 0.3
    @State private var revealOpacity: Double = 0
    @State private var particleOpacity: Double = 0
    @State private var rotationAngle: Double = 0
    
    // Randomly select a reward item
    private var rewardItem: VirtualItem {
        let possibleItems: [VirtualItem] = {
            switch package.tier {
            case .legendary:
                return VirtualItem.samples.filter { $0.rarity == .legendary || $0.rarity == .epic }
            case .elite:
                return VirtualItem.samples.filter { $0.rarity == .epic || $0.rarity == .rare }
            case .basic:
                return VirtualItem.samples.filter { $0.rarity == .rare || $0.rarity == .common }
            }
        }()
        return possibleItems.randomElement() ?? VirtualItem.samples[0]
    }
    
    enum UnboxingPhase {
        case intro, shaking, opening, reveal, complete
    }
    
    var body: some View {
        ZStack {
            // Background
            Theme.background.ignoresSafeArea()
            
            // Particles
            if phase == .reveal || phase == .complete {
                particleEffects
            }
            
            VStack(spacing: 24) {
                // Close button
                HStack {
                    Spacer()
                    if phase == .complete {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Main Content
                switch phase {
                case .intro, .shaking:
                    packageDisplay
                case .opening:
                    openingAnimation
                case .reveal, .complete:
                    revealDisplay
                }
                
                Spacer()
                
                // Action Button
                actionButton
                    .padding(.horizontal)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            startGlowAnimation()
        }
    }
    
    // MARK: - Package Display
    private var packageDisplay: some View {
        VStack(spacing: 20) {
            Text(package.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(package.tier.color)
            
            ZStack {
                // Glow
                Circle()
                    .fill(package.tier.color.opacity(0.1))
                    .frame(width: 220, height: 220)
                    .opacity(glowOpacity)
                
                Circle()
                    .fill(package.tier.color.opacity(0.05))
                    .frame(width: 280, height: 280)
                    .opacity(glowOpacity)
                
                // Package Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(package.tier.gradient)
                        .frame(width: 140, height: 140)
                        .shadow(color: package.tier.color.opacity(0.5), radius: 20)
                    
                    Image(systemName: package.icon)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                }
                .offset(x: shakeAmount)
                .rotationEffect(.degrees(Double(shakeAmount) * 0.5))
            }
            
            Text("Apasa pentru a deschide!")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textSecondary)
                .opacity(phase == .intro ? 1 : 0)
        }
    }
    
    // MARK: - Opening Animation
    private var openingAnimation: some View {
        ZStack {
            // Burst effect
            ForEach(0..<8, id: \.self) { i in
                Rectangle()
                    .fill(package.tier.color)
                    .frame(width: 3, height: 30)
                    .offset(y: -80)
                    .rotationEffect(.degrees(Double(i) * 45))
                    .opacity(glowOpacity)
            }
            
            // Opening box
            Image(systemName: "shippingbox.fill")
                .font(.system(size: 80))
                .foregroundColor(package.tier.color)
                .scaleEffect(1.2)
                .opacity(0.5)
        }
    }
    
    // MARK: - Reveal Display
    private var revealDisplay: some View {
        VStack(spacing: 20) {
            // Rarity label
            Text(rewardItem.rarity.label.uppercased())
                .font(.system(size: 18, weight: .black))
                .foregroundColor(rewardItem.rarity.color)
                .opacity(revealOpacity)
            
            // Item
            ZStack {
                // Outer glow rings
                Circle()
                    .stroke(rewardItem.rarity.color.opacity(0.2), lineWidth: 2)
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(rotationAngle))
                
                Circle()
                    .stroke(rewardItem.rarity.color.opacity(0.1), lineWidth: 1)
                    .frame(width: 240, height: 240)
                    .rotationEffect(.degrees(-rotationAngle))
                
                // Item icon
                ZStack {
                    Circle()
                        .fill(rewardItem.rarity.color.opacity(0.15))
                        .frame(width: 130, height: 130)
                    
                    Image(systemName: rewardItem.icon)
                        .font(.system(size: 56))
                        .foregroundColor(rewardItem.rarity.color)
                }
                .scaleEffect(revealScale)
                .opacity(revealOpacity)
            }
            
            // Item name
            VStack(spacing: 6) {
                Text(rewardItem.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                Text(rewardItem.description)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                
                BadgeView(text: rewardItem.category.rawValue, color: rewardItem.rarity.color)
            }
            .opacity(revealOpacity)
        }
    }
    
    // MARK: - Particle Effects
    private var particleEffects: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill(rewardItem.rarity.color)
                    .frame(width: CGFloat.random(in: 4...10), height: CGFloat.random(in: 4...10))
                    .offset(
                        x: CGFloat.random(in: -180...180),
                        y: CGFloat.random(in: -300...300)
                    )
                    .opacity(particleOpacity * Double.random(in: 0.3...1.0))
            }
            
            // Stars
            ForEach(0..<10, id: \.self) { i in
                Image(systemName: "star.fill")
                    .font(.system(size: CGFloat.random(in: 8...16)))
                    .foregroundColor(Theme.accent)
                    .offset(
                        x: CGFloat.random(in: -150...150),
                        y: CGFloat.random(in: -250...250)
                    )
                    .opacity(particleOpacity * Double.random(in: 0.2...0.8))
            }
        }
    }
    
    // MARK: - Action Button
    @ViewBuilder
    private var actionButton: some View {
        switch phase {
        case .intro:
            Button(action: startShaking) {
                HStack(spacing: 8) {
                    Image(systemName: "hand.tap.fill")
                    Text("Deschide Pachetul")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(package.tier.gradient)
                .cornerRadius(Theme.cornerRadiusLarge)
                .shadow(color: package.tier.color.opacity(0.4), radius: 10)
            }
            
        case .shaking:
            Text("Se deschide...")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            
        case .opening:
            EmptyView()
            
        case .reveal:
            EmptyView()
            
        case .complete:
            VStack(spacing: 12) {
                PrimaryButton("Revendica", icon: "checkmark.circle.fill") {
                    dismiss()
                }
                
                SecondaryButton("Deschide Alt Pachet", icon: "arrow.counterclockwise") {
                    resetAnimation()
                }
            }
        }
    }
    
    // MARK: - Animations
    private func startGlowAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            glowOpacity = 1.0
        }
    }
    
    private func startShaking() {
        phase = .shaking
        
        // Shake animation
        let shakeSequence = [5.0, -5.0, 8.0, -8.0, 12.0, -12.0, 15.0, -15.0, 0.0]
        for (index, offset) in shakeSequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    shakeAmount = CGFloat(offset)
                }
            }
        }
        
        // Transition to opening
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeIn(duration: 0.3)) {
                phase = .opening
            }
            
            // Transition to reveal
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                    phase = .reveal
                    revealScale = 1.0
                    revealOpacity = 1.0
                }
                
                withAnimation(.easeIn(duration: 0.5)) {
                    particleOpacity = 1.0
                }
                
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
                
                // Complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    phase = .complete
                    
                    withAnimation(.easeOut(duration: 2)) {
                        particleOpacity = 0
                    }
                }
            }
        }
    }
    
    private func resetAnimation() {
        phase = .intro
        shakeAmount = 0
        revealScale = 0.3
        revealOpacity = 0
        particleOpacity = 0
        rotationAngle = 0
        startGlowAnimation()
    }
}
