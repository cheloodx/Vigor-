import SwiftUI

// MARK: - Recall Campaigns View
struct RecallCampaignsView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var viewModel = RecallCampaignsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    vehicleCard
                    
                    if !viewModel.checkComplete && !viewModel.isChecking {
                        checkButton
                    }
                    if viewModel.isChecking { checkingCard }
                    
                    if viewModel.checkComplete {
                        resultSummary
                        ForEach(viewModel.recalls) { recall in
                            recallCard(recall)
                        }
                        safetyNote
                    }
                    
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
                        Image(systemName: "bell.badge.fill")
                            .foregroundColor(Theme.gaugeRed)
                        Text(localization.t("feature.recall_check"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
    
    private var vehicleCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "car.fill").font(.system(size: 20)).foregroundColor(Theme.primary)
                .frame(width: 40, height: 40).background(Theme.primary.opacity(0.15)).cornerRadius(10)
            VStack(alignment: .leading, spacing: 2) {
                Text(vehicleManager.currentVehicle.displayName)
                    .font(.system(size: 14, weight: .bold)).foregroundColor(Theme.textPrimary)
                Text("VIN: \(vehicleManager.currentVehicle.vin.isEmpty ? "Necompletat" : vehicleManager.currentVehicle.vin)")
                    .font(.system(size: 10, design: .monospaced)).foregroundColor(Theme.textSecondary)
            }
            Spacer()
        }
        .padding(12).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var checkButton: some View {
        Button(action: { viewModel.checkRecalls(vehicle: vehicleManager.currentVehicle) }) {
            HStack(spacing: 8) {
                Image(systemName: "bell.badge.fill")
                Text("Verifica Campanii Rechemare")
                    .font(.system(size: 15, weight: .bold))
            }
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background(Theme.primaryGradient).foregroundColor(.white).cornerRadius(14)
        }
    }
    
    private var checkingCard: some View {
        VStack(spacing: 10) {
            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Theme.primary)).scaleEffect(1.2)
            Text("Verificare campanii active...").font(.system(size: 13, weight: .semibold)).foregroundColor(Theme.textPrimary)
            Text("Se verifica baza de date RAPEX si producator").font(.system(size: 10)).foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity).padding(16).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var resultSummary: some View {
        let activeCount = viewModel.recalls.filter { $0.status == .active }.count
        let color: Color = activeCount > 0 ? Theme.gaugeRed : Theme.gaugeGreen
        let icon = activeCount > 0 ? "exclamationmark.triangle.fill" : "checkmark.seal.fill"
        let text = activeCount > 0 ? "\(activeCount) CAMPANII ACTIVE" : "NICIO CAMPANIE ACTIVA"
        
        return VStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 36)).foregroundColor(color)
            Text(text).font(.system(size: 16, weight: .black)).foregroundColor(color)
            Text("Verificat la: \(Date(), formatter: dateFormatter)")
                .font(.system(size: 10)).foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity).padding(16)
        .background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(color.opacity(0.3), lineWidth: 1))
    }
    
    private func recallCard(_ recall: RecallCampaign) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(recall.status == .active ? "ACTIVA" : "REZOLVATA")
                    .font(.system(size: 9, weight: .bold))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(recall.status == .active ? Theme.gaugeRed.opacity(0.2) : Theme.gaugeGreen.opacity(0.2))
                    .foregroundColor(recall.status == .active ? Theme.gaugeRed : Theme.gaugeGreen)
                    .cornerRadius(4)
                Spacer()
                Text(recall.date).font(.system(size: 10)).foregroundColor(Theme.textMuted)
            }
            
            Text(recall.title).font(.system(size: 14, weight: .bold)).foregroundColor(Theme.textPrimary)
            Text(recall.description).font(.system(size: 12)).foregroundColor(Theme.textSecondary).lineSpacing(3)
            
            HStack(spacing: 12) {
                infoChip("Severitate: \(recall.severity)", color: recall.severity == "Critica" ? Theme.gaugeRed : Theme.gaugeYellow)
                infoChip("Piese afectate: \(recall.affectedParts)", color: Theme.primary)
            }
            
            if recall.status == .active {
                Text("Contactati dealerul \(vehicleManager.currentVehicle.make) pentru programare gratuita.")
                    .font(.system(size: 11, weight: .semibold)).foregroundColor(Theme.primary)
                    .padding(8).background(Theme.primary.opacity(0.08)).cornerRadius(6)
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(recall.status == .active ? Theme.gaugeRed.opacity(0.2) : Color.clear, lineWidth: 1))
    }
    
    private func infoChip(_ text: String, color: Color) -> some View {
        Text(text).font(.system(size: 9, weight: .semibold))
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(color.opacity(0.1)).foregroundColor(color).cornerRadius(4)
    }
    
    private var safetyNote: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle.fill").font(.system(size: 12)).foregroundColor(Theme.primary)
            Text("Campaniile de rechemare sunt gratuite la dealer. Verificati periodic pe site-ul RAR (Registrul Auto Roman) sau al producatorului.")
                .font(.system(size: 10)).foregroundColor(Theme.textMuted).lineSpacing(2)
        }
        .padding(10).background(Theme.primary.opacity(0.05)).cornerRadius(8)
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter(); f.dateFormat = "dd.MM.yyyy HH:mm"; return f
    }
    
}

struct RecallCampaign: Identifiable {
    let id = UUID()
    let title: String; let description: String; let date: String
    let severity: String; let affectedParts: String
    let status: RecallStatus
    
    enum RecallStatus { case active, resolved }
    
    static var sampleRecalls: [RecallCampaign] {
        [
            RecallCampaign(title: "Actualizare software ECU - emisii", description: "Campanie de actualizare software pentru controlul emisiilor NOx. Update gratuit la dealer, durata aprox. 45 minute.", date: "15.01.2024", severity: "Moderata", affectedParts: "ECU Motor", status: .active),
            RecallCampaign(title: "Verificare airbag-uri laterale", description: "Verificare preventiva a modulelor airbag laterale pentru un posibil defect de fabricatie al furnizorului Takata.", date: "03.09.2023", severity: "Critica", affectedParts: "Airbag-uri", status: .active),
            RecallCampaign(title: "Inlocuire pompa combustibil", description: "Campanie de inlocuire preventiva a pompei de combustibil care poate prezenta scurgeri. Rezolvata deja.", date: "20.03.2022", severity: "Moderata", affectedParts: "Pompa combustibil", status: .resolved),
        ]
    }
}
