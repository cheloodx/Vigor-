import SwiftUI

struct CommunityView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedFilter: CommunityPost.PostCategory? = nil
    @State private var showCreatePost = false
    @State private var showVideoCall = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Quick Actions
                    quickActions
                    
                    // Filter
                    filterSection
                    
                    // Posts
                    postsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Comunitate")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCreatePost = true }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showCreatePost) {
                CreatePostView()
            }
            .fullScreenCover(isPresented: $showVideoCall) {
                VideoCallView()
            }
        }
    }
    
    // MARK: - Quick Actions
    private var quickActions: some View {
        HStack(spacing: 12) {
            Button(action: { showVideoCall = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "video.fill")
                        .font(.system(size: 16))
                    Text("Antrenament Grup")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.primaryGradient)
                .cornerRadius(Theme.cornerRadiusMedium)
            }
            
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 16))
                    Text("Provocari")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(Theme.accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.accent.opacity(0.15))
                .cornerRadius(Theme.cornerRadiusMedium)
            }
        }
    }
    
    // MARK: - Filter
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(title: "Toate", isSelected: selectedFilter == nil) {
                    selectedFilter = nil
                }
                ForEach(CommunityPost.PostCategory.allCases, id: \.self) { category in
                    filterChip(title: category.rawValue, isSelected: selectedFilter == category) {
                        selectedFilter = category
                    }
                }
            }
        }
    }
    
    private func filterChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .black : Theme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Theme.primary : Theme.cardBackground)
                .cornerRadius(16)
        }
    }
    
    // MARK: - Posts
    private var postsSection: some View {
        let filteredPosts = selectedFilter == nil ? CommunityPost.samples : CommunityPost.samples.filter { $0.category == selectedFilter }
        
        return ForEach(filteredPosts) { post in
            PostCardView(post: post)
        }
    }
}

// MARK: - Post Card
struct PostCardView: View {
    let post: CommunityPost
    @State private var isLiked: Bool
    @State private var likeCount: Int
    
    init(post: CommunityPost) {
        self.post = post
        _isLiked = State(initialValue: post.isLiked)
        _likeCount = State(initialValue: post.likes)
    }
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                // Author
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Theme.primary.opacity(0.2))
                            .frame(width: 40, height: 40)
                        Image(systemName: post.authorAvatar)
                            .font(.system(size: 20))
                            .foregroundColor(Theme.primary)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.author)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        HStack(spacing: 4) {
                            BadgeView(text: post.category.rawValue, color: post.category.color)
                            Text(post.timeAgo)
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textTertiary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Theme.textTertiary)
                    }
                }
                
                // Content
                Text(post.content)
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textPrimary)
                    .lineSpacing(4)
                
                // Image placeholder
                if let imageName = post.imageSystemName {
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.surfaceBackground)
                                .frame(height: 120)
                            Image(systemName: imageName)
                                .font(.system(size: 40))
                                .foregroundColor(Theme.primary.opacity(0.5))
                        }
                        Spacer()
                    }
                }
                
                // Actions
                HStack(spacing: 24) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            isLiked.toggle()
                            likeCount += isLiked ? 1 : -1
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : Theme.textTertiary)
                            Text("\(likeCount)")
                                .font(.system(size: 13))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "bubble.left")
                                .foregroundColor(Theme.textTertiary)
                            Text("\(post.comments)")
                                .font(.system(size: 13))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Theme.textTertiary)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Create Post View
struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var content = ""
    @State private var selectedCategory: CommunityPost.PostCategory = .workout
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(CommunityPost.PostCategory.allCases, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                Text(category.rawValue)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(selectedCategory == category ? .white : Theme.textSecondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(selectedCategory == category ? category.color : Theme.cardBackground)
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Text Editor
                TextEditor(text: $content)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textPrimary)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(Theme.cardBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .frame(minHeight: 200)
                
                Spacer()
                
                // Post Button
                PrimaryButton("Posteaza", icon: "paperplane.fill") {
                    dismiss()
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Postare Noua")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Anuleaza") { dismiss() }
                        .foregroundColor(Theme.primary)
                }
            }
        }
    }
}
