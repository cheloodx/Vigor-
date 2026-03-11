import SwiftUI

struct WatchNotificationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notifications = WatchNotification.samples
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Watch Preview
                    watchPreview
                    
                    // Notifications List
                    ForEach(notifications) { notification in
                        notificationCard(notification)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Notificari Ceas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Inchide") { dismiss() }
                        .foregroundColor(Theme.primary)
                }
            }
        }
    }
    
    private var watchPreview: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Theme.cardBackground)
                    .frame(width: 180, height: 220)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Theme.textTertiary, lineWidth: 2)
                    )
                
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "v.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.primary)
                        Text("VIGOR")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(Theme.primary)
                    }
                    
                    if let latest = notifications.first(where: { !$0.isRead }) {
                        VStack(spacing: 4) {
                            Image(systemName: latest.type.icon)
                                .font(.system(size: 24))
                                .foregroundColor(latest.type.color)
                            Text(latest.title)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Theme.textPrimary)
                            Text(latest.message)
                                .font(.system(size: 9))
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .padding(.horizontal, 12)
                    }
                    
                    Text("12:45")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textTertiary)
                }
            }
            
            Text("Apple Watch Preview")
                .font(.system(size: 12))
                .foregroundColor(Theme.textTertiary)
        }
        .padding(.vertical, 8)
    }
    
    private func notificationCard(_ notification: WatchNotification) -> some View {
        CardView(padding: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(notification.type.color.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: notification.icon)
                        .font(.system(size: 18))
                        .foregroundColor(notification.type.color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(notification.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        if !notification.isRead {
                            Circle()
                                .fill(Theme.primary)
                                .frame(width: 6, height: 6)
                        }
                    }
                    Text(notification.message)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Text(notification.time)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textTertiary)
            }
        }
    }
}
