import SwiftUI

// MARK: - App Store Screenshots View
// Generates professional app store listing screenshots
struct AppStoreScreenshotsView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var currentPage = 0
    @State private var animateElements = false
    
    private let screenshots: [AppStoreScreen] = [
        AppStoreScreen(
            title: "Diagnostic Auto Complet",
            subtitle: "Scor Sanatate 0-100",
            icon: "heart.square.fill",
            color: Color(red: 0.0, green: 0.85, blue: 0.45),
            features: ["Motor", "Frane", "Electrica", "Suspensie", "Transmisie", "Caroserie"],
            mockValue: "78"
        ),
        AppStoreScreen(
            title: "OBD2 Live Data",
            subtitle: "Conecteaza-te la masina",
            icon: "antenna.radiowaves.left.and.right",
            color: Color(red: 0.0, green: 0.75, blue: 1.0),
            features: ["RPM", "Viteza", "Temperatura", "Consum", "Baterie", "Ulei"],
            mockValue: "2,450"
        ),
        AppStoreScreen(
            title: "AI Mecanic Virtual",
            subtitle: "Diagnostic instant cu AI",
            icon: "brain",
            color: Color(red: 0.6, green: 0.2, blue: 0.9),
            features: ["Chat AI", "Predictor", "DTC Decoder", "Voce", "Consum", "ITP"],
            mockValue: "15+"
        ),
        AppStoreScreen(
            title: "44 Tari Europene",
            subtitle: "Adaptat pentru tara ta",
            icon: "globe.americas.fill",
            color: Color(red: 0.0, green: 0.5, blue: 0.9),
            features: ["Legi trafic", "Amenzi", "Camere radar", "Asigurari", "ITP/MOT/TUV", "Moneda locala"],
            mockValue: "44"
        ),
        AppStoreScreen(
            title: "Export & Partajare",
            subtitle: "Raport PDF profesional",
            icon: "doc.richtext.fill",
            color: Color(red: 0.95, green: 0.5, blue: 0.2),
            features: ["Export PDF", "Share Report", "CV Auto", "QR Scanner", "Facturi", "Istoric"],
            mockValue: "PDF"
        ),
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Title
                VStack(spacing: 6) {
                    Image(systemName: "rectangle.on.rectangle.angled")
                        .font(.system(size: 28))
                        .foregroundColor(Theme.primary)
                    Text("App Store Screenshots")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(Theme.textPrimary)
                    Text("Preview-uri pentru listarea in App Store")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                .padding(.bottom, 4)
                
                // Screenshot carousel
                TabView(selection: $currentPage) {
                    ForEach(0..<screenshots.count, id: \.self) { index in
                        screenshotCard(screenshots[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 520)
                
                // Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("APP STORE LISTING")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1.2)
                    
                    listingRow(label: "Nume", value: "AutoDiag Pro - Diagnostic Auto")
                    listingRow(label: "Subtitlu", value: "OBD2 Live + AI Mecanic + 44 Tari")
                    listingRow(label: "Categorie", value: "Utilities / Auto & Vehicles")
                    listingRow(label: "Pret", value: "Gratuit (In-App Purchases)")
                    listingRow(label: "Varsta", value: "4+")
                    listingRow(label: "Compatibilitate", value: "iOS 16.0+, iPhone, iPad")
                    listingRow(label: "Limbi", value: "20 limbi europene")
                    listingRow(label: "Versiune", value: "3.0 — Europe Edition")
                }
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
                // Keywords
                VStack(alignment: .leading, spacing: 8) {
                    Text("KEYWORDS (100 caractere)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1.2)
                    
                    Text("OBD2,diagnostic,auto,masina,mecanic,AI,ITP,RCA,service,consum,DTC,ELM327,Bluetooth,scan,European")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(Theme.primary)
                        .padding(10)
                        .background(Theme.surfaceBackground)
                        .cornerRadius(8)
                }
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("App Store")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }
        }
        .onAppear { withAnimation(.easeOut(duration: 0.8)) { animateElements = true } }
    }
    
    // MARK: - Screenshot Card
    private func screenshotCard(_ screen: AppStoreScreen) -> some View {
        VStack(spacing: 0) {
            // Phone frame
            ZStack {
                // Background gradient
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [screen.color.opacity(0.8), screen.color.opacity(0.3), Theme.background],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VStack(spacing: 12) {
                    // Title
                    Text(screen.title)
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.white)
                    Text(screen.subtitle)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    // Mock phone
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Theme.background)
                            .frame(width: 180, height: 300)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                            )
                        
                        VStack(spacing: 8) {
                            // Score ring
                            ZStack {
                                Circle()
                                    .stroke(screen.color.opacity(0.2), lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                Circle()
                                    .trim(from: 0, to: animateElements ? 0.78 : 0)
                                    .stroke(screen.color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                    .frame(width: 70, height: 70)
                                    .rotationEffect(.degrees(-90))
                                
                                VStack(spacing: 0) {
                                    Text(screen.mockValue)
                                        .font(.system(size: 18, weight: .black, design: .rounded))
                                        .foregroundColor(screen.color)
                                    Image(systemName: screen.icon)
                                        .font(.system(size: 10))
                                        .foregroundColor(screen.color.opacity(0.7))
                                }
                            }
                            
                            // Features grid
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 4) {
                                ForEach(screen.features, id: \.self) { feature in
                                    HStack(spacing: 3) {
                                        Circle()
                                            .fill(screen.color)
                                            .frame(width: 4, height: 4)
                                        Text(feature)
                                            .font(.system(size: 8, weight: .semibold))
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, 10)
                            
                            // Tab bar mock
                            HStack(spacing: 0) {
                                ForEach(["camera.fill", "barcode.viewfinder", "speedometer", "bubble.left.fill", "square.grid.2x2.fill"], id: \.self) { icon in
                                    Image(systemName: icon)
                                        .font(.system(size: 10))
                                        .foregroundColor(Theme.textMuted)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.vertical, 6)
                            .background(Theme.surfaceBackground)
                            .cornerRadius(8)
                            .padding(.horizontal, 8)
                        }
                        .frame(width: 160, height: 270)
                    }
                }
                .padding(.vertical, 20)
            }
            .frame(height: 470)
            .cornerRadius(20)
        }
        .padding(.horizontal, 8)
    }
    
    private func listingRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Theme.textMuted)
                .frame(width: 90, alignment: .leading)
            Text(value)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Theme.textPrimary)
            Spacer()
        }
    }
}

// MARK: - App Store Screen Model
struct AppStoreScreen {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let features: [String]
    let mockValue: String
}
