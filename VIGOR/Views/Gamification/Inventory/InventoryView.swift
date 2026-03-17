import SwiftUI

struct BucketListView: View {
    @State private var items: [BucketListItem] = FeatureData.defaultBucketList
    
    private static let storageKey = "bucket_list_items"
    
    var completedCount: Int { items.filter { $0.isCompleted }.count }
    var progress: Double { items.isEmpty ? 0 : Double(completedCount) / Double(items.count) }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Progress Card
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Progres")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("\(completedCount) din \(items.count) completate")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                                Text("\(Int(progress * 100))%")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(Theme.primaryGradient)
                            }
                            
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.white.opacity(0.1))
                                        .frame(height: 8)
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Theme.primaryGradient)
                                        .frame(width: geo.size.width * progress, height: 8)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(18)
                        .padding(.horizontal)
                        
                        // Items List
                        ForEach(items.indices, id: \.self) { index in
                            Button(action: {
                                    withAnimation(.spring()) {
                                        items[index].isCompleted.toggle()
                                        saveItems()
                                    }
                            }) {
                                HStack(spacing: 12) {
                                    Text(items[index].icon)
                                        .font(.system(size: 24))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(items[index].title)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                            .strikethrough(items[index].isCompleted)
                                        Text(items[index].description)
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.5))
                                            .lineLimit(2)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: items[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 22))
                                        .foregroundColor(items[index].isCompleted ? Color(hex: "66BB6A") : .white.opacity(0.2))
                                }
                                .padding(14)
                                .background(Color.white.opacity(items[index].isCompleted ? 0.08 : 0.04))
                                .cornerRadius(14)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 8)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Bucket List")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadItems() }
    }
    
    private func loadItems() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([BucketListItem].self, from: data) else { return }
        items = decoded
    }
    
    private func saveItems() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }
}
