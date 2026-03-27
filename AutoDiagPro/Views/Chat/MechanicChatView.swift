import SwiftUI

struct MechanicChatView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @EnvironmentObject var appState: AppState

    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Salut! Sunt AutoDiag Pro. Descrie problema masinii sau intreaba orice despre reparatii, piese sau intretinere.", isUser: false)
    ]
    @State private var inputText: String = ""
    @State private var isLoading = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Messages list
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(messages) { message in
                                messageBubble(message)
                                    .id(message.id)
                            }

                            if isLoading {
                                typingIndicator
                                    .id("typing")
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(messages.last?.id ?? "typing", anchor: .bottom)
                        }
                    }
                    .onChange(of: isLoading) { _ in
                        withAnimation {
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }

                // Quick suggestions (show only when no messages from user)
                if messages.count <= 1 {
                    quickSuggestions
                }

                // Input bar
                inputBar
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .foregroundColor(Theme.primary)
                        Text("Mecanic AI")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }

    // MARK: - Message Bubble
    private func messageBubble(_ message: ChatMessage) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if !message.isUser {
                // Bot avatar
                ZStack {
                    Circle()
                        .fill(Color(red: 0.06, green: 0.21, blue: 0.38))
                        .frame(width: 26, height: 26)
                        .overlay(Circle().stroke(Color(red: 0.12, green: 0.25, blue: 0.50), lineWidth: 1))
                    Image(systemName: "wrench.fill")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.primary)
                }
            }

            if message.isUser { Spacer(minLength: 60) }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textPrimary)
                    .lineSpacing(4)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        message.isUser
                            ? AnyShapeStyle(LinearGradient(colors: [Color(red: 0.11, green: 0.31, blue: 0.85), Color(red: 0.15, green: 0.39, blue: 0.92)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            : AnyShapeStyle(Color(red: 0.06, green: 0.10, blue: 0.14))
                    )
                    .cornerRadius(message.isUser ? 16 : 16, corners: message.isUser ? [.topLeading, .topTrailing, .bottomLeading] : [.topLeading, .topTrailing, .bottomTrailing])
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(message.isUser ? Color(red: 0.11, green: 0.31, blue: 0.85) : Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1)
                    )

                Text(message.timeFormatted)
                    .font(.system(size: 9))
                    .foregroundColor(Theme.textMuted)
            }

            if !message.isUser { Spacer(minLength: 60) }
        }
    }

    // MARK: - Typing Indicator
    private var typingIndicator: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.06, green: 0.21, blue: 0.38))
                    .frame(width: 26, height: 26)
                    .overlay(Circle().stroke(Color(red: 0.12, green: 0.25, blue: 0.50), lineWidth: 1))
                Image(systemName: "wrench.fill")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.primary)
            }

            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Theme.primary)
                        .frame(width: 6, height: 6)
                        .opacity(0.6)
                        .scaleEffect(1.0)
                        .animation(
                            .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: isLoading
                        )
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(red: 0.06, green: 0.10, blue: 0.14))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))

            Spacer()
        }
    }

    // MARK: - Quick Suggestions
    private var quickSuggestions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(QuickSuggestion.defaultSuggestions) { suggestion in
                    Button(action: { sendMessage(suggestion.text) }) {
                        HStack(spacing: 4) {
                            Image(systemName: suggestion.icon)
                                .font(.system(size: 10))
                            Text(suggestion.text)
                                .font(.system(size: 11, weight: .medium))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(Theme.cardBackground)
                        .foregroundColor(Theme.textSecondary)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
                    }
                    .disabled(isLoading)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Input Bar
    private var inputBar: some View {
        HStack(spacing: 8) {
            TextField("Descrie problema masinii...", text: $inputText)
                .font(.system(size: 13))
                .foregroundColor(Theme.textPrimary)
                .focused($isInputFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Theme.cardBackground)
                .cornerRadius(24)
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
                .onSubmit { sendCurrentMessage() }

            // Send button
            Button(action: sendCurrentMessage) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
                    .background(
                        (inputText.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                            ? Color.gray.opacity(0.3)
                            : LinearGradient(colors: [Color(red: 0.11, green: 0.31, blue: 0.85), Theme.primary], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(21)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Theme.background)
        .overlay(Rectangle().fill(Color(red: 0.10, green: 0.17, blue: 0.25)).frame(height: 1), alignment: .top)
    }

    // MARK: - Actions
    private func sendCurrentMessage() {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty, !isLoading else { return }
        inputText = ""
        sendMessage(text)
    }

    private func sendMessage(_ text: String) {
        // Add user message
        let userMessage = ChatMessage(text: text, isUser: true)
        messages.append(userMessage)
        isLoading = true

        // Generate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let response = MechanicAI.generateResponse(for: text, vehicle: vehicleManager.currentVehicle)
            let aiMessage = ChatMessage(text: response, isUser: false)
            withAnimation {
                messages.append(aiMessage)
                isLoading = false
            }
        }
    }
}

// MARK: - Rounded Corner Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
