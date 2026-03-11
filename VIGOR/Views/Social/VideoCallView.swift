import SwiftUI

struct VideoCallView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isMuted = false
    @State private var isVideoOn = true
    @State private var showChat = false
    @State private var showGifts = false
    @State private var showEmojis = false
    @State private var chatMessage = ""
    @State private var messages: [ChatMessage] = ChatMessage.samples
    @State private var floatingEmojis: [FloatingEmoji] = []
    
    let participants = VideoCallParticipant.samples
    
    struct FloatingEmoji: Identifiable {
        let id = UUID()
        let emoji: String
        let xOffset: CGFloat
    }
    
    var body: some View {
        ZStack {
            // Video Grid Background
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                topBar
                
                // Video Grid
                videoGrid
                
                // Emoji Reactions Bar
                if showEmojis {
                    emojiBar
                }
                
                // Bottom Controls
                bottomControls
            }
            
            // Chat Overlay
            if showChat {
                chatOverlay
            }
            
            // Gift Panel
            if showGifts {
                giftPanel
            }
            
            // Floating Emojis
            ForEach(floatingEmojis) { emoji in
                Text(emoji.emoji)
                    .font(.system(size: 40))
                    .offset(x: emoji.xOffset)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
            }
        }
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("Group Workout")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Text("\(participants.count) participants")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: { showChat.toggle() }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bubble.left.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(showChat ? Theme.primary : Color.white.opacity(0.2))
                            .clipShape(Circle())
                        
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: -2)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    // MARK: - Video Grid
    private var videoGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(participants) { participant in
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.cardBackground)
                        .aspectRatio(3/4, contentMode: .fit)
                        .overlay(
                            VStack {
                                if participant.isVideoOn {
                                    Image(systemName: participant.avatarSystemName)
                                        .font(.system(size: 40))
                                        .foregroundColor(Theme.primary.opacity(0.5))
                                } else {
                                    VStack(spacing: 8) {
                                        Image(systemName: "video.slash.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(Theme.textTertiary)
                                        Text("Camera off")
                                            .font(.system(size: 11))
                                            .foregroundColor(Theme.textTertiary)
                                    }
                                }
                            }
                        )
                    
                    // Name tag
                    HStack(spacing: 4) {
                        if participant.isMuted {
                            Image(systemName: "mic.slash.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.red)
                        }
                        Text(participant.name)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                        if participant.isHost {
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(Theme.accent)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)
                    .padding(8)
                }
            }
        }
        .padding(.horizontal, 8)
        .frame(maxHeight: .infinity)
    }
    
    // MARK: - Emoji Bar
    private var emojiBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(["🔥", "💪", "👏", "❤️", "😤", "🏋️", "⚡️", "🎯", "💯", "🙌"], id: \.self) { emoji in
                    Button(action: {
                        sendEmoji(emoji)
                    }) {
                        Text(emoji)
                            .font(.system(size: 28))
                            .padding(6)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Theme.cardBackground.opacity(0.95))
    }
    
    // MARK: - Bottom Controls
    private var bottomControls: some View {
        HStack(spacing: 16) {
            controlButton(icon: isMuted ? "mic.slash.fill" : "mic.fill", isActive: !isMuted, color: isMuted ? .red : .white) {
                isMuted.toggle()
            }
            
            controlButton(icon: isVideoOn ? "video.fill" : "video.slash.fill", isActive: isVideoOn, color: isVideoOn ? .white : .red) {
                isVideoOn.toggle()
            }
            
            controlButton(icon: "face.smiling.fill", isActive: showEmojis, color: showEmojis ? Theme.accent : .white) {
                withAnimation { showEmojis.toggle() }
            }
            
            controlButton(icon: "gift.fill", isActive: false, color: Theme.primary) {
                withAnimation { showGifts.toggle() }
            }
            
            Button(action: { dismiss() }) {
                Image(systemName: "phone.down.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 44)
                    .background(Color.red)
                    .cornerRadius(22)
            }
        }
        .padding()
        .background(Theme.cardBackground.opacity(0.95))
    }
    
    private func controlButton(icon: String, isActive: Bool, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(isActive ? 0.2 : 0.1))
                .clipShape(Circle())
        }
    }
    
    // MARK: - Chat Overlay
    private var chatOverlay: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                // Chat Header
                HStack {
                    Text("Chat")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Button(action: { showChat = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Theme.textTertiary)
                    }
                }
                .padding()
                
                Divider().background(Theme.textTertiary)
                
                // Messages
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(messages) { message in
                            HStack(alignment: .top, spacing: 8) {
                                if !message.isCurrentUser {
                                    Text(message.author)
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Theme.primary)
                                }
                                Text(message.content)
                                    .font(.system(size: 14))
                                    .foregroundColor(Theme.textPrimary)
                            }
                            .frame(maxWidth: .infinity, alignment: message.isCurrentUser ? .trailing : .leading)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 150)
                
                // Input
                HStack(spacing: 8) {
                    TextField("Write a message...", text: $chatMessage)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Theme.surfaceBackground)
                        .cornerRadius(20)
                    
                    Button(action: {
                        if !chatMessage.isEmpty {
                            messages.append(ChatMessage(id: UUID(), author: "You", content: chatMessage, timestamp: Date(), isCurrentUser: true))
                            chatMessage = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Theme.primary)
                    }
                }
                .padding()
            }
            .background(Theme.cardBackground.opacity(0.95))
            .cornerRadius(Theme.cornerRadiusLarge, corners: [.topLeft, .topRight])
        }
        .transition(.move(edge: .bottom))
        .ignoresSafeArea(edges: .bottom)
    }
    
    // MARK: - Gift Panel
    private var giftPanel: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                HStack {
                    Text("Virtual Gifts")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Button(action: { showGifts = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Theme.textTertiary)
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(VirtualGift.samples) { gift in
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(gift.rarity.color.opacity(0.2))
                                        .frame(width: 60, height: 60)
                                    Image(systemName: gift.icon)
                                        .font(.system(size: 26))
                                        .foregroundColor(gift.rarity.color)
                                }
                                
                                Text(gift.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Theme.textPrimary)
                                    .lineLimit(1)
                                
                                HStack(spacing: 2) {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(Theme.accent)
                                    Text("\(gift.cost)")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Theme.accent)
                                }
                                
                                Button(action: {}) {
                                    Text("Send")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 6)
                                        .background(Theme.primaryGradient)
                                        .cornerRadius(12)
                                }
                            }
                            .frame(width: 90)
                        }
                    }
                }
            }
            .padding()
            .background(Theme.cardBackground.opacity(0.98))
            .cornerRadius(Theme.cornerRadiusXLarge, corners: [.topLeft, .topRight])
        }
        .transition(.move(edge: .bottom))
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func sendEmoji(_ emoji: String) {
        let newEmoji = FloatingEmoji(emoji: emoji, xOffset: CGFloat.random(in: -100...100))
        withAnimation(.easeOut(duration: 0.3)) {
            floatingEmojis.append(newEmoji)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                floatingEmojis.removeAll { $0.id == newEmoji.id }
            }
        }
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
