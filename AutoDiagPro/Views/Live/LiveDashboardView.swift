import SwiftUI

struct LiveDashboardView: View {
    @EnvironmentObject var appState: AppState

    @StateObject private var simulator = OBDDemoSimulator()
    @State private var isConnected = false
    @State private var isConnecting = false

    var body: some View {
        NavigationView {
            ScrollView {
                if isConnected {
                    connectedView
                } else {
                    disconnectedView
                }
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "gauge.open.with.lines.needle.33percent")
                            .foregroundColor(Theme.primary)
                        Text("Date Live OBD2")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                if isConnected {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Theme.gaugeGreen)
                                .frame(width: 8, height: 8)
                                .pulseAnimation(true)
                            Text("LIVE")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Theme.gaugeGreen)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Disconnected View
    private var disconnectedView: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 40)

            VStack(spacing: 14) {
                Image(systemName: "cable.connector")
                    .font(.system(size: 52))
                    .foregroundColor(Theme.textMuted)

                Text("Conectare OBD2 Bluetooth")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                VStack(spacing: 4) {
                    Text("Conectati adaptorul ELM327 la portul")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                    Text("de diagnosticare (sub volan).")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)

                    Text("Demo mode disponibil.")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.primary)
                        .padding(.top, 4)
                }
                .multilineTextAlignment(.center)

                // Connect button
                Button(action: connectOBD) {
                    HStack(spacing: 8) {
                        if isConnecting {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.white)
                            Text("Conectare...")
                                .font(.system(size: 13, weight: .semibold))
                        } else {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                            Text("Conectare OBD2 Bluetooth")
                                .font(.system(size: 13, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(LinearGradient(colors: [Color(red: 0.06, green: 0.46, blue: 0.43), Color(red: 0.08, green: 0.72, blue: 0.65)], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isConnecting)

                // Demo button
                Button(action: startDemo) {
                    HStack(spacing: 8) {
                        if isConnecting {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.white)
                            Text("Pornire...")
                                .font(.system(size: 13, weight: .semibold))
                        } else {
                            Image(systemName: "play.fill")
                            Text("Demo Live")
                                .font(.system(size: 13, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.06, green: 0.21, blue: 0.38))
                    .foregroundColor(Theme.primary)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.12, green: 0.25, blue: 0.50), lineWidth: 1))
                }
                .disabled(isConnecting)
            }
            .padding(28)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
            .padding(.horizontal, 16)

            Spacer(minLength: 80)
        }
    }

    // MARK: - Connected View
    private var connectedView: some View {
        VStack(spacing: 12) {
            // Gauges grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(GaugeConfig.allGauges) { config in
                    GaugeWidgetView(config: config, data: simulator.liveData)
                }
            }
            .padding(.horizontal, 16)

            // Additional data card
            VStack(alignment: .leading, spacing: 8) {
                Text("DATE SUPLIMENTARE")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Theme.primary)
                    .tracking(1)

                infoRow(label: "Sarcina motor", value: "\(String(format: "%.1f", 20 + sin(Date().timeIntervalSinceReferenceDate * 0.1) * 15))%")
                infoRow(label: "Status OBD", value: "Conectat \u{00B7} Fara erori")
                infoRow(label: "Protocol", value: "ISO 15765-4 CAN")
                infoRow(label: "Adaptorul", value: "ELM327 v2.1")
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
            .padding(.horizontal, 16)

            // Disconnect button
            Button(action: disconnect) {
                HStack(spacing: 8) {
                    Image(systemName: "cable.connector")
                    Text("Deconectare")
                        .font(.system(size: 13, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(red: 0.11, green: 0.04, blue: 0.04))
                .foregroundColor(Theme.danger)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.5, green: 0.11, blue: 0.11), lineWidth: 1))
            }
            .padding(.horizontal, 16)

            Spacer(minLength: 80)
        }
        .padding(.top, 8)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .padding(.vertical, 6)
        .overlay(Rectangle().fill(Color(red: 0.12, green: 0.17, blue: 0.23)).frame(height: 1), alignment: .bottom)
    }

    // MARK: - Actions
    private func connectOBD() {
        isConnecting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isConnecting = false
            isConnected = true
            simulator.startSimulation()
            appState.isOBDConnected = true
        }
    }

    private func startDemo() {
        connectOBD()
    }

    private func disconnect() {
        simulator.stopSimulation()
        isConnected = false
        appState.isOBDConnected = false
    }
}

// MARK: - Gauge Widget
struct GaugeWidgetView: View {
    let config: GaugeConfig
    let data: OBDLiveData

    var currentValue: Double {
        data[keyPath: config.keyPath]
    }

    var normalizedValue: Double {
        config.normalizedValue(data)
    }

    var statusColor: Color {
        config.statusColor(data)
    }

    var body: some View {
        VStack(spacing: 6) {
            // Icon
            Image(systemName: config.icon)
                .font(.system(size: 18))
                .foregroundColor(statusColor)

            // Gauge arc
            ZStack {
                // Background arc
                ArcShape(startAngle: .degrees(135), endAngle: .degrees(405))
                    .stroke(Color(red: 0.12, green: 0.17, blue: 0.23), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 72, height: 40)

                // Value arc
                ArcShape(startAngle: .degrees(135), endAngle: .degrees(135 + 270 * min(1, max(0, normalizedValue))))
                    .stroke(statusColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 72, height: 40)
                    .animation(.easeOut(duration: 0.3), value: normalizedValue)

                // Value text
                VStack(spacing: 0) {
                    Spacer()
                    Text(formattedValue)
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(statusColor)
                }
                .frame(width: 72, height: 40)
            }

            // Label
            Text(config.title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(Theme.textMuted)
                .lineLimit(1)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(statusColor.opacity(0.25), lineWidth: 1))
    }

    private var formattedValue: String {
        if currentValue > 100 {
            return "\(Int(currentValue))\(config.unit)"
        }
        return "\(String(format: "%.1f", currentValue))\(config.unit)"
    }
}

// MARK: - Arc Shape
struct ArcShape: Shape {
    let startAngle: Angle
    var endAngle: Angle

    var animatableData: Double {
        get { endAngle.degrees }
        set { endAngle = .degrees(newValue) }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let radius = min(rect.width, rect.height * 2) / 2
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
}
