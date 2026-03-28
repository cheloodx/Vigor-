import SwiftUI
import Intents

// MARK: - Siri Shortcuts View
// Configure Siri voice commands for car diagnostics
struct SiriShortcutsView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var shortcuts: [SiriShortcut] = SiriShortcut.defaultShortcuts
    @State private var selectedShortcut: SiriShortcut?
    @State private var showSetupAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Header
                headerCard
                
                // Active shortcuts
                VStack(alignment: .leading, spacing: 8) {
                    Text("COMENZI VOCALE DISPONIBILE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .tracking(1.2)
                    
                    ForEach(shortcuts) { shortcut in
                        shortcutCard(shortcut)
                    }
                }
                
                // How it works
                howItWorks
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: "waveform.circle.fill")
                        .foregroundColor(Color(red: 0.0, green: 0.6, blue: 1.0))
                    Text("Siri Shortcuts")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .alert("Adauga Shortcut", isPresented: $showSetupAlert) {
            Button("Deschide Setari Siri") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Anuleaza", role: .cancel) {}
        } message: {
            if let shortcut = selectedShortcut {
                Text("Pentru a adauga '\(shortcut.phrase)' ca shortcut Siri, mergi la Setari > Siri & Search > All Shortcuts > AutoDiag Pro.")
            }
        }
    }
    
    // MARK: - Header
    private var headerCard: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.0, green: 0.6, blue: 1.0).opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(Color(red: 0.0, green: 0.6, blue: 1.0))
            }
            
            Text("\"Hey Siri...\"")
                .font(.system(size: 22, weight: .black))
                .foregroundColor(Theme.textPrimary)
            
            Text("Controleaza AutoDiag Pro cu vocea ta. Configureaza comenzi rapide pentru cele mai folosite functii.")
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    // MARK: - Shortcut Card
    private func shortcutCard(_ shortcut: SiriShortcut) -> some View {
        Button(action: {
            selectedShortcut = shortcut
            showSetupAlert = true
            donateShortcut(shortcut)
        }) {
            HStack(spacing: 12) {
                Image(systemName: shortcut.icon)
                    .font(.system(size: 16))
                    .foregroundColor(shortcut.color)
                    .frame(width: 36, height: 36)
                    .background(shortcut.color.opacity(0.15))
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("\"\(shortcut.phrase)\"")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .italic()
                    Text(shortcut.description)
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Image(systemName: shortcut.isEnabled ? "checkmark.circle.fill" : "plus.circle")
                        .font(.system(size: 18))
                        .foregroundColor(shortcut.isEnabled ? Theme.gaugeGreen : Theme.textMuted)
                    Text(shortcut.isEnabled ? "Activ" : "Adauga")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(shortcut.isEnabled ? Theme.gaugeGreen : Theme.textMuted)
                }
            }
            .padding(12)
            .background(Theme.surfaceBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(shortcut.isEnabled ? Theme.gaugeGreen.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
    }
    
    // MARK: - How it works
    private var howItWorks: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CUM FUNCTIONEAZA")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Theme.textMuted)
                .tracking(1.2)
            
            stepRow(number: 1, text: "Apasa pe un shortcut de mai sus")
            stepRow(number: 2, text: "Confirm in Setari > Siri & Search")
            stepRow(number: 3, text: "Spune \"Hey Siri\" + fraza aleasa")
            stepRow(number: 4, text: "AutoDiag Pro se deschide automat la functia dorita")
            
            Text("Siri Shortcuts functioneaza pe iPhone, Apple Watch, HomePod si CarPlay.")
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
                .padding(.top, 4)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func stepRow(number: Int, text: String) -> some View {
        HStack(spacing: 10) {
            Text("\(number)")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Color(red: 0.0, green: 0.6, blue: 1.0))
                .clipShape(Circle())
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    // MARK: - Donate Shortcut to Siri
    private func donateShortcut(_ shortcut: SiriShortcut) {
        let activity = NSUserActivity(activityType: "com.autodiagpro.\(shortcut.activityType)")
        activity.title = shortcut.phrase
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.suggestedInvocationPhrase = shortcut.phrase
        activity.becomeCurrent()
    }
}

// MARK: - Siri Shortcut Model
struct SiriShortcut: Identifiable {
    let id = UUID()
    let phrase: String
    let description: String
    let icon: String
    let color: Color
    let activityType: String
    var isEnabled: Bool
    
    static var defaultShortcuts: [SiriShortcut] {
        [
            SiriShortcut(phrase: "Ce scor are masina mea?", description: "Afiseaza scorul de sanatate 0-100", icon: "heart.text.square.fill", color: Theme.gaugeGreen, activityType: "healthScore", isEnabled: false),
            SiriShortcut(phrase: "Diagnosticheaza masina", description: "Lanseaza diagnosticul rapid", icon: "stethoscope", color: Theme.primary, activityType: "quickDiagnose", isEnabled: false),
            SiriShortcut(phrase: "Cand e urmatorul service?", description: "Verifica alarmele de intretinere", icon: "bell.badge.fill", color: Theme.gaugeYellow, activityType: "nextService", isEnabled: false),
            SiriShortcut(phrase: "Conecteaza OBD2", description: "Porneste scanarea Bluetooth OBD2", icon: "antenna.radiowaves.left.and.right", color: Theme.primary, activityType: "connectOBD", isEnabled: false),
            SiriShortcut(phrase: "Cat consuma masina?", description: "Afiseaza consumul real L/100km", icon: "fuelpump.fill", color: Color(red: 0.0, green: 0.8, blue: 0.6), activityType: "fuelConsumption", isEnabled: false),
            SiriShortcut(phrase: "Trece ITP-ul?", description: "Verifica daca masina trece ITP", icon: "shield.checkered", color: Theme.gaugeRed, activityType: "itpCheck", isEnabled: false),
            SiriShortcut(phrase: "Cat valoreaza masina?", description: "Estimeaza valoarea pe piata", icon: "tag.fill", color: Theme.secondary, activityType: "carValue", isEnabled: false),
            SiriShortcut(phrase: "Deschide mecanicul AI", description: "Lanseaza chat-ul cu mecanicul virtual", icon: "bubble.left.and.bubble.right.fill", color: Color(red: 0.6, green: 0.2, blue: 0.9), activityType: "aiChat", isEnabled: false),
        ]
    }
}
