import SwiftUI

struct VehicleJournalView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var entries: [JournalEntry] = JournalEntry.sampleEntries
    @State private var showAddEntry = false
    @State private var selectedType: JournalEntryType?
    @State private var totalSpent: Double = 0
    
    var filteredEntries: [JournalEntry] {
        if let type = selectedType {
            return entries.filter { $0.type == type }
        }
        return entries
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Summary cards
                    summaryCards
                    
                    // Type filter
                    typeFilter
                    
                    // Entries list
                    ForEach(filteredEntries) { entry in
                        journalEntryCard(entry)
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
                        Image(systemName: "book.fill")
                            .foregroundColor(Theme.primary)
                        Text("Jurnal Vehicul")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showAddEntry) {
                addEntrySheet
            }
            .onAppear { calculateTotals() }
        }
    }
    
    // MARK: - Summary Cards
    private var summaryCards: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                summaryBox(title: "Total Cheltuieli", value: String(format: "%.0f RON", totalSpent), icon: "creditcard.fill", color: Theme.primary)
                summaryBox(title: "Intrari", value: "\(entries.count)", icon: "doc.text.fill", color: Theme.gaugeGreen)
            }
            HStack(spacing: 8) {
                summaryBox(title: "Combustibil", value: String(format: "%.0f RON", entries.filter { $0.type == .fuel }.reduce(0) { $0 + $1.cost }), icon: "fuelpump.fill", color: Color(red: 0.22, green: 0.78, blue: 0.35))
                summaryBox(title: "Reparatii", value: String(format: "%.0f RON", entries.filter { $0.type == .repair || $0.type == .service }.reduce(0) { $0 + $1.cost }), icon: "wrench.fill", color: Theme.gaugeYellow)
            }
        }
    }
    
    private func summaryBox(title: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
            }
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.2), lineWidth: 1))
    }
    
    // MARK: - Type Filter
    private var typeFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button(action: { withAnimation { selectedType = nil } }) {
                    Text("Toate")
                        .font(.system(size: 12, weight: .semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedType == nil ? Theme.primary.opacity(0.2) : Theme.surfaceBackground)
                        .foregroundColor(selectedType == nil ? Theme.primary : Theme.textSecondary)
                        .cornerRadius(16)
                }
                
                ForEach(JournalEntryType.allCases, id: \.self) { type in
                    Button(action: { withAnimation { selectedType = selectedType == type ? nil : type } }) {
                        HStack(spacing: 4) {
                            Image(systemName: type.icon)
                                .font(.system(size: 10))
                            Text(type.rawValue)
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(selectedType == type ? type.color.opacity(0.2) : Theme.surfaceBackground)
                        .foregroundColor(selectedType == type ? type.color : Theme.textSecondary)
                        .cornerRadius(16)
                    }
                }
            }
        }
    }
    
    // MARK: - Journal Entry Card
    private func journalEntryCard(_ entry: JournalEntry) -> some View {
        HStack(spacing: 12) {
            // Type icon
            VStack {
                Image(systemName: entry.type.icon)
                    .font(.system(size: 16))
                    .foregroundColor(entry.type.color)
                    .frame(width: 36, height: 36)
                    .background(entry.type.color.opacity(0.15))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Text(entry.formattedCost)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(entry.cost > 0 ? Theme.secondary : Theme.textMuted)
                }
                
                Text(entry.details)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 9))
                        Text(entry.formattedDate)
                            .font(.system(size: 10))
                    }
                    .foregroundColor(Theme.textMuted)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "speedometer")
                            .font(.system(size: 9))
                        Text("\(entry.mileage) km")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(Theme.textMuted)
                }
            }
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(entry.type.color.opacity(0.15), lineWidth: 1))
    }
    
    // MARK: - Add Entry Sheet
    private var addEntrySheet: some View {
        NavigationView {
            AddJournalEntryView(entries: $entries, isPresented: $showAddEntry)
                .environmentObject(vehicleManager)
        }
    }
    
    private func calculateTotals() {
        totalSpent = entries.reduce(0) { $0 + $1.cost }
    }
}

// MARK: - Add Journal Entry View
struct AddJournalEntryView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @Binding var entries: [JournalEntry]
    @Binding var isPresented: Bool
    
    @State private var selectedType: JournalEntryType = .fuel
    @State private var title = ""
    @State private var details = ""
    @State private var cost = ""
    @State private var mileage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Type selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tip Intrare")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(JournalEntryType.allCases, id: \.self) { type in
                            Button(action: { selectedType = type }) {
                                VStack(spacing: 4) {
                                    Image(systemName: type.icon)
                                        .font(.system(size: 16))
                                    Text(type.rawValue)
                                        .font(.system(size: 8, weight: .semibold))
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedType == type ? type.color.opacity(0.2) : Theme.surfaceBackground)
                                .foregroundColor(selectedType == type ? type.color : Theme.textMuted)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(selectedType == type ? type.color.opacity(0.5) : Color.clear, lineWidth: 1))
                            }
                        }
                    }
                }
                
                // Fields
                inputField(label: "Titlu", placeholder: "ex: Alimentare OMV", text: $title)
                inputField(label: "Detalii", placeholder: "ex: Motorina Premium 45L", text: $details)
                inputField(label: "Cost (RON)", placeholder: "0", text: $cost)
                inputField(label: "Kilometraj", placeholder: "\(vehicleManager.currentVehicle.mileage)", text: $mileage)
                
                // Save button
                Button(action: saveEntry) {
                    Text("Salveaza")
                        .font(.system(size: 15, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(title.isEmpty ? Theme.textMuted : Theme.primaryGradient)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(title.isEmpty)
            }
            .padding(16)
        }
        .background(Theme.background)
        .navigationTitle("Adauga Intrare")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Anuleaza") { isPresented = false }
                    .foregroundColor(Theme.primary)
            }
        }
    }
    
    private func inputField(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Theme.textMuted)
            TextField(placeholder, text: text)
                .font(.system(size: 14))
                .padding(12)
                .background(Theme.surfaceBackground)
                .foregroundColor(Theme.textPrimary)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
        }
    }
    
    private func saveEntry() {
        let entry = JournalEntry(
            date: Date(),
            type: selectedType,
            title: title,
            details: details,
            cost: Double(cost) ?? 0,
            mileage: Int(mileage) ?? vehicleManager.currentVehicle.mileage,
            vehicleId: vehicleManager.currentVehicle.id
        )
        entries.insert(entry, at: 0)
        isPresented = false
    }
}
