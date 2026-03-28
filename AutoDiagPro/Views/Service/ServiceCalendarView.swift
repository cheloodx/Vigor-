import SwiftUI

struct ServiceCalendarView: View {
    @EnvironmentObject var vehicleManager: VehicleManager

    @State private var currentKmText: String = ""
    @State private var showMarkSheet = false
    @State private var selectedServiceItem: ServiceItem?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Vehicle info card
                    if !vehicleManager.currentVehicle.make.isEmpty {
                        vehicleInfoBanner
                    }

                    // Mileage input card
                    mileageInputCard

                    // Service items list
                    ForEach(vehicleManager.serviceItems) { item in
                        serviceItemRow(item)
                    }

                    Spacer(minLength: 80)
                }
                .padding(.top, 8)
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .foregroundColor(Theme.primary)
                        Text("Calendar Intretinere")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showMarkSheet) {
                if let item = selectedServiceItem {
                    MarkServiceSheet(item: item, currentKm: Int(currentKmText) ?? vehicleManager.currentVehicle.mileage) { date, km in
                        vehicleManager.markServiceDone(itemId: item.id, date: date, km: km)
                        showMarkSheet = false
                    }
                }
            }
        }
    }

    // MARK: - Vehicle Info Banner
    private var vehicleInfoBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(vehicleManager.currentVehicle.make) \(vehicleManager.currentVehicle.model) \u{00B7} \(String(vehicleManager.currentVehicle.year))")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.primary)
                Text("Revizie la 15.000 km / 12 luni")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textMuted)
            }
            Spacer()
            Image(systemName: "car.fill")
                .foregroundColor(Theme.primary.opacity(0.5))
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
        .padding(.horizontal, 16)
    }

    // MARK: - Mileage Input
    private var mileageInputCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Kilometraj actual")
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)

            TextField("ex: 87500", text: $currentKmText)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.textPrimary)
                .keyboardType(.numberPad)
                .padding(12)
                .background(Color(red: 0.02, green: 0.04, blue: 0.06))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
                .onChange(of: currentKmText) { newValue in
                    if let km = Int(newValue) {
                        vehicleManager.updateServiceMileage(km)
                    }
                }

            // Quick mark buttons
            Text("Marchez ultima interventie:")
                .font(.system(size: 11))
                .foregroundColor(Theme.textMuted)

            FlowLayout(spacing: 6) {
                ForEach(vehicleManager.serviceItems) { item in
                    Button(action: {
                        selectedServiceItem = item
                        showMarkSheet = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: item.icon)
                                .font(.system(size: 10))
                            Text(item.name)
                                .font(.system(size: 11))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(item.lastServiceKm != nil ? Color(red: 0.06, green: 0.21, blue: 0.38) : Theme.cardBackground)
                        .foregroundColor(item.lastServiceKm != nil ? Theme.primary : Theme.textMuted)
                        .cornerRadius(6)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(
                            item.lastServiceKm != nil ? Theme.primary : Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
                    }
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
        .padding(.horizontal, 16)
    }

    // MARK: - Service Item Row
    private func serviceItemRow(_ item: ServiceItem) -> some View {
        let statusConfig = itemStatusConfig(item)

        return VStack(spacing: 8) {
            // Header
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: item.icon)
                        .font(.system(size: 22))
                        .foregroundColor(statusConfig.color)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        Text("\(item.intervalKm.formatted()) km / \(item.intervalMonths) luni")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textSecondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    // Status badge
                    Text(statusConfig.label)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(statusConfig.color.opacity(0.15))
                        .foregroundColor(statusConfig.color)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(statusConfig.color.opacity(0.4), lineWidth: 1))

                    // Cost
                    Text("\(Int(item.estimatedCost)) RON")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Theme.secondary)
                }
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(red: 0.12, green: 0.17, blue: 0.23))
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(progressColor(for: item))
                        .frame(width: max(0, geo.size.width * CGFloat(1 - item.progressPercentage)), height: 4)
                }
            }
            .frame(height: 4)

            // Status text
            if !currentKmText.isEmpty {
                statusText(for: item)
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(statusConfig.color.opacity(0.25), lineWidth: 1))
        .padding(.horizontal, 16)
    }

    private func statusText(for item: ServiceItem) -> some View {
        let progress = 1 - item.progressPercentage
        let nextKm = (item.lastServiceKm ?? 0) + item.intervalKm
        let remaining = item.kmRemaining
        let overdueKm: Int = {
            guard let lastKm = item.lastServiceKm else { return 0 }
            let diff = (item.currentKm - lastKm) - item.intervalKm
            return max(0, diff)
        }()

        return Group {
            if progress >= 1 {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 10))
                    Text("Depasit cu \(overdueKm.formatted()) km")
                }
                .font(.system(size: 11))
                .foregroundColor(Theme.danger)
            } else if progress >= 0.8 {
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 10))
                    Text("Urmator la \(nextKm.formatted()) km (\(remaining.formatted()) km ramasi)")
                }
                .font(.system(size: 11))
                .foregroundColor(Theme.gaugeYellow)
            } else {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10))
                    Text("Urmator la \(nextKm.formatted()) km")
                }
                .font(.system(size: 11))
                .foregroundColor(Theme.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func progressColor(for item: ServiceItem) -> Color {
        let usedPct = 1 - item.progressPercentage
        if usedPct >= 1 { return Theme.danger }
        if usedPct >= 0.8 { return Theme.gaugeYellow }
        return Theme.gaugeGreen
    }

    private struct StatusConfig {
        let color: Color
        let label: String
    }

    private func itemStatusConfig(_ item: ServiceItem) -> StatusConfig {
        let pct = 1 - item.progressPercentage
        if pct >= 1 {
            return StatusConfig(color: Theme.danger, label: "Expirat")
        } else if pct >= 0.8 {
            return StatusConfig(color: Theme.gaugeYellow, label: "Curand")
        }
        return StatusConfig(color: Theme.gaugeGreen, label: "OK")
    }
}

// MARK: - Mark Service Sheet
struct MarkServiceSheet: View {
    let item: ServiceItem
    let currentKm: Int
    let onSave: (Date, Int) -> Void

    @State private var date = Date()
    @State private var kmText: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    Image(systemName: item.icon)
                        .font(.system(size: 28))
                        .foregroundColor(Theme.primary)
                    Text(item.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Data interventiei")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Kilometraj la interventie")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                    TextField("ex: \(currentKm)", text: $kmText)
                        .font(.system(size: 16, design: .monospaced))
                        .keyboardType(.numberPad)
                        .padding(12)
                        .background(Color(red: 0.02, green: 0.04, blue: 0.06))
                        .foregroundColor(Theme.textPrimary)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
                }

                Button(action: {
                    let km = Int(kmText) ?? currentKm
                    onSave(date, km)
                }) {
                    Text("Salveaza")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.primaryGradient)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Spacer()
            }
            .padding(20)
            .background(Theme.background)
            .navigationTitle("Marcheaza Interventie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuleaza") { dismiss() }
                        .foregroundColor(Theme.primary)
                }
            }
        }
        .onAppear { kmText = "\(currentKm)" }
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: ProposedViewSize(width: bounds.width, height: bounds.height), subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var maxHeight: CGFloat = 0
        var positions: [CGPoint] = []

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += maxHeight + spacing
                maxHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            maxHeight = max(maxHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + maxHeight), positions)
    }
}
