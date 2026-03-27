import SwiftUI

struct DiagnosticHistoryView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var history: [DiagnosticHistoryEntry] = DiagnosticHistoryEntry.sampleHistory
    @State private var selectedFilter: String = "Toate"
    @State private var showShareSheet = false
    @State private var shareText = ""
    
    private let filters = ["Toate", "foto", "obd2", "voce", "manual"]
    
    var filteredHistory: [DiagnosticHistoryEntry] {
        if selectedFilter == "Toate" { return history }
        return history.filter { $0.scanType == selectedFilter }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Stats header
                    statsHeader
                    
                    // Filter chips
                    filterChips
                    
                    // History list
                    if filteredHistory.isEmpty {
                        emptyState
                    } else {
                        ForEach(filteredHistory) { entry in
                            historyCard(entry)
                        }
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
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(Theme.primary)
                        Text("Istoric Diagnostic")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(items: [shareText])
            }
        }
    }
    
    // MARK: - Stats Header
    private var statsHeader: some View {
        HStack(spacing: 8) {
            miniStat(value: "\(history.count)", label: "Total Scanari", color: Theme.primary)
            miniStat(value: "\(history.filter { $0.overallStatus == "good" }.count)", label: "OK", color: Theme.gaugeGreen)
            miniStat(value: "\(history.filter { $0.overallStatus == "warning" }.count)", label: "Avertizari", color: Theme.gaugeYellow)
            miniStat(value: "\(history.filter { $0.overallStatus == "danger" }.count)", label: "Critice", color: Theme.gaugeRed)
        }
    }
    
    private func miniStat(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Theme.cardBackground)
        .cornerRadius(8)
    }
    
    // MARK: - Filter Chips
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: { withAnimation { selectedFilter = filter } }) {
                        HStack(spacing: 4) {
                            if filter != "Toate" {
                                Image(systemName: iconForFilter(filter))
                                    .font(.system(size: 10))
                            }
                            Text(labelForFilter(filter))
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedFilter == filter ? Theme.primary.opacity(0.2) : Theme.surfaceBackground)
                        .foregroundColor(selectedFilter == filter ? Theme.primary : Theme.textSecondary)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(selectedFilter == filter ? Theme.primary.opacity(0.5) : Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
                    }
                }
            }
        }
    }
    
    // MARK: - History Card
    private func historyCard(_ entry: DiagnosticHistoryEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: entry.statusIcon)
                    .foregroundColor(entry.statusColor)
                    .font(.system(size: 16))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.vehicleName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    Text(entry.formattedDate)
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                
                Spacer()
                
                // Health score badge
                VStack(spacing: 2) {
                    Text("\(entry.healthScore)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(entry.statusColor)
                    Text("scor")
                        .font(.system(size: 9))
                        .foregroundColor(Theme.textMuted)
                }
                
                // Scan type badge
                Image(systemName: entry.scanTypeIcon)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textMuted)
                    .padding(6)
                    .background(Theme.surfaceBackground)
                    .cornerRadius(6)
            }
            
            Text(entry.summary)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(3)
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 10))
                    Text("\(entry.issuesFound) probleme gasite")
                        .font(.system(size: 11))
                }
                .foregroundColor(entry.issuesFound > 0 ? Theme.gaugeYellow : Theme.gaugeGreen)
                
                Spacer()
                
                Button(action: {
                    shareText = "Diagnostic \(entry.vehicleName)\n\(entry.formattedDate)\nScor: \(entry.healthScore)/100\n\(entry.summary)\n\nGenerat cu AutoDiag Pro"
                    showShareSheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 10))
                        Text("Partajeaza")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(Theme.primary)
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(entry.statusColor.opacity(0.2), lineWidth: 1))
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(Theme.textMuted.opacity(0.3))
            Text("Niciun diagnostic gasit")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
            Text("Efectuati o scanare din tab-ul Scan sau Live")
                .font(.system(size: 12))
                .foregroundColor(Theme.textMuted)
        }
        .padding(40)
    }
    
    // MARK: - Helpers
    private func iconForFilter(_ filter: String) -> String {
        switch filter {
        case "foto": return "camera.fill"
        case "obd2": return "antenna.radiowaves.left.and.right"
        case "voce": return "mic.fill"
        case "manual": return "doc.text.fill"
        default: return "list.bullet"
        }
    }
    
    private func labelForFilter(_ filter: String) -> String {
        switch filter {
        case "foto": return "Foto"
        case "obd2": return "OBD2"
        case "voce": return "Voce"
        case "manual": return "Manual"
        default: return "Toate"
        }
    }
}
