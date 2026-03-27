import SwiftUI

struct CostEstimatorView: View {
    @EnvironmentObject var vehicleManager: VehicleManager

    @State private var isLoading = false
    @State private var showResult = false

    var selectedCount: Int {
        vehicleManager.costOperations.filter { $0.isSelected }.count
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Vehicle info
                    if !vehicleManager.currentVehicle.make.isEmpty {
                        HStack {
                            Text("\(vehicleManager.currentVehicle.make) \(vehicleManager.currentVehicle.model) \u{00B7} \(String(vehicleManager.currentVehicle.year)) \u{00B7} \(vehicleManager.currentVehicle.engineType)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Theme.primary)
                            Spacer()
                        }
                        .padding(12)
                        .background(Theme.cardBackground)
                        .cornerRadius(Theme.cornerRadius)
                        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
                        .padding(.horizontal, 16)
                    }

                    // Instruction
                    Text("Selectati operatiile:")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    // Operations list
                    ForEach(Array(vehicleManager.costOperations.enumerated()), id: \.element.id) { index, operation in
                        operationRow(operation, index: index)
                    }

                    // Estimate button
                    Button(action: estimate) {
                        HStack(spacing: 8) {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                                Text("Calculez...")
                                    .font(.system(size: 13, weight: .semibold))
                            } else {
                                Image(systemName: "creditcard.fill")
                                Text("Estimeaza \(selectedCount) operatii")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedCount == 0 || isLoading
                                ? Color.gray.opacity(0.3)
                                : LinearGradient(colors: [Color(red: 0.49, green: 0.23, blue: 0.93), Color(red: 0.66, green: 0.55, blue: 0.98)], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(selectedCount == 0 || isLoading)
                    .padding(.horizontal, 16)

                    // Results
                    if showResult {
                        resultCard
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
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(Theme.primary)
                        Text("Estimator Costuri")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }

    // MARK: - Operation Row
    private func operationRow(_ operation: CostOperation, index: Int) -> some View {
        Button(action: {
            vehicleManager.toggleOperation(operation.id)
        }) {
            HStack(spacing: 10) {
                Image(systemName: operation.icon)
                    .font(.system(size: 20))
                    .foregroundColor(operation.category.color)

                VStack(alignment: .leading, spacing: 2) {
                    Text(operation.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    Text("\(String(format: "%.1f", operation.laborHours))h manopera")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(operation.totalMin))-\(Int(operation.totalMax)) RON")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.secondary)

                    // Checkbox
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(operation.isSelected ? Theme.primary : Color(red: 0.2, green: 0.25, blue: 0.33), lineWidth: 2)
                            .frame(width: 18, height: 18)

                        if operation.isSelected {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Theme.primary)
                                .frame(width: 18, height: 18)

                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(operation.isSelected ? Color(red: 0.06, green: 0.13, blue: 0.25) : Theme.cardBackground)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(
                operation.isSelected ? Theme.primary : Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Result Card
    private var resultCard: some View {
        let summary = vehicleManager.costSummary

        return VStack(spacing: 12) {
            Text("Estimare")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Cost grid
            HStack(spacing: 8) {
                costSummaryBox(title: "Manopera", value: "\(Int(summary.totalLaborCost)) RON", color: Theme.primary)
                costSummaryBox(title: "Piese", value: "\(Int(summary.totalPartsCostMin))-\(Int(summary.totalPartsCostMax)) RON", color: Color(red: 0.66, green: 0.55, blue: 0.98))
                costSummaryBox(title: "TOTAL", value: "\(Int(summary.grandTotalMin))-\(Int(summary.grandTotalMax)) RON", color: Theme.secondary)
            }

            // Time
            HStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                Text("Timp total:")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
                Text("\(String(format: "%.1f", summary.totalHours)) ore")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }

            // Operations breakdown
            Divider()
                .background(Color(red: 0.12, green: 0.17, blue: 0.23))

            ForEach(summary.selectedOperations) { op in
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: op.icon)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                        Text(op.name)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                    Text("\(Int(op.totalMin))-\(Int(op.totalMax)) RON")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                }
                .padding(.vertical, 4)

                Divider()
                    .background(Color(red: 0.12, green: 0.17, blue: 0.23))
            }

            // Info note
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.primary)
                Text(vehicleManager.currentVehicle.make.isEmpty
                     ? "Preturi estimate pentru Romania. Verificati la service."
                     : "Preturi estimate pentru \(vehicleManager.currentVehicle.make) \(vehicleManager.currentVehicle.model) in Romania.")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.49, green: 0.83, blue: 0.99))
            }
            .padding(10)
            .background(Color(red: 0.05, green: 0.13, blue: 0.22))
            .cornerRadius(8)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color(red: 0.49, green: 0.23, blue: 0.93).opacity(0.3), lineWidth: 1))
        .padding(.horizontal, 16)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func costSummaryBox(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 9))
                .foregroundColor(Theme.textMuted)
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(red: 0.02, green: 0.04, blue: 0.06))
        .cornerRadius(8)
    }

    // MARK: - Actions
    private func estimate() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                showResult = true
                isLoading = false
            }
        }
    }
}
