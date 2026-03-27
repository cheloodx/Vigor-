import SwiftUI

struct VINScanView: View {
    @EnvironmentObject var vehicleManager: VehicleManager

    @State private var manualPlate: String = ""
    @State private var manualVIN: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showImagePicker = false
    @State private var identifiedVehicle: Vehicle?
    @State private var showResult = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    if showResult, let vehicle = identifiedVehicle {
                        vehicleResultView(vehicle)
                    } else {
                        scanContent
                    }
                }
                .padding(.bottom, 80)
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(Theme.primary)
                        Text("Scan VIN / Nr. Inmatriculare")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }

    // MARK: - Scan Content
    private var scanContent: some View {
        VStack(spacing: 14) {
            // Camera area
            VStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Theme.primary)
                    Text("Analizez cu AI...")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                } else {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 50))
                        .foregroundColor(Theme.textMuted.opacity(0.3))

                    VStack(spacing: 4) {
                        Text("Fotografiati VIN-ul de pe motor/sasiu")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                        Text("sau numarul de inmatriculare")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .multilineTextAlignment(.center)

                    Text("OCR cu AI")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(0.5)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Theme.gaugeYellow.opacity(0.15))
                        .foregroundColor(Theme.gaugeYellow)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.gaugeYellow.opacity(0.4), lineWidth: 1))
                }

                // Error
                if let error = errorMessage {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 12))
                        Text(error)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color(red: 0.99, green: 0.65, blue: 0.65))
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.11, green: 0.04, blue: 0.04))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.5, green: 0.11, blue: 0.11), lineWidth: 1))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 200)
            .background(Color(red: 0.02, green: 0.04, blue: 0.06))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                    .foregroundColor(Color(red: 0.12, green: 0.23, blue: 0.37))
            )
            .padding(.horizontal, 16)
            .onTapGesture { showImagePicker = true }

            // Camera + Gallery buttons
            HStack(spacing: 8) {
                Button(action: { showImagePicker = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                        Text("Camera")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.primaryGradient)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Button(action: { showImagePicker = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "photo.fill")
                        Text("Galerie")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.surfaceBackground)
                    .foregroundColor(Theme.textPrimary)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
                }
            }
            .padding(.horizontal, 16)

            // Manual entry card
            manualEntryCard
        }
    }

    // MARK: - Manual Entry
    private var manualEntryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("INTRODUCERE MANUALA")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.primary)
                .tracking(1)

            // Plate input
            VStack(alignment: .leading, spacing: 4) {
                Text("Numar inmatriculare")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textMuted)

                TextField("ex: B 123 ABC", text: $manualPlate)
                    .font(.system(size: 17, weight: .bold, design: .monospaced))
                    .foregroundColor(Theme.gaugeYellow)
                    .multilineTextAlignment(.center)
                    .tracking(2)
                    .padding(10)
                    .background(Color(red: 0.02, green: 0.04, blue: 0.06))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
                    .onChange(of: manualPlate) { newValue in
                        manualPlate = newValue.uppercased()
                    }
            }

            // VIN input
            VStack(alignment: .leading, spacing: 4) {
                Text("Cod VIN (17 caractere)")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textMuted)

                TextField("ex: WBA3A5C50DF123456", text: $manualVIN)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Theme.primary)
                    .tracking(1)
                    .padding(10)
                    .background(Color(red: 0.02, green: 0.04, blue: 0.06))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.12, green: 0.23, blue: 0.37), lineWidth: 1))
                    .onChange(of: manualVIN) { newValue in
                        manualVIN = String(newValue.uppercased().prefix(17))
                    }
            }

            // Submit button
            Button(action: submitManual) {
                HStack(spacing: 8) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                        Text("Se cauta...")
                            .font(.system(size: 13, weight: .semibold))
                    } else {
                        Image(systemName: "magnifyingglass")
                        Text("Identifica Masina")
                            .font(.system(size: 13, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    (manualVIN.isEmpty && manualPlate.isEmpty) || isLoading
                        ? Color.gray.opacity(0.3)
                        : LinearGradient(colors: [Color(red: 0.06, green: 0.46, blue: 0.43), Color(red: 0.08, green: 0.72, blue: 0.65)], startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled((manualVIN.isEmpty && manualPlate.isEmpty) || isLoading)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
        .padding(.horizontal, 16)
    }

    // MARK: - Vehicle Result
    private func vehicleResultView(_ vehicle: Vehicle) -> some View {
        VStack(spacing: 14) {
            // Back button + Title
            HStack(spacing: 8) {
                Button(action: { withAnimation { showResult = false } }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(Theme.primary)
                }

                Text("Masina Identificata")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Spacer()
            }
            .padding(.horizontal, 16)

            // Vehicle card
            VStack(spacing: 12) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(vehicle.make) \(vehicle.model)")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        Text("\(vehicle.year) \u{00B7} \(vehicle.engineType)")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                    Text(!vehicle.vin.isEmpty ? "VIN" : "NR")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Theme.gaugeGreen.opacity(0.15))
                        .foregroundColor(Theme.gaugeGreen)
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Theme.gaugeGreen.opacity(0.4), lineWidth: 1))
                }

                // Info grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    infoCell(label: "Tara", value: "RO", icon: "globe.europe.africa.fill")
                    infoCell(label: "Culoare", value: vehicle.color, icon: "paintpalette.fill")
                    infoCell(label: "Echipare", value: vehicle.equipment, icon: "gearshape.fill")
                    infoCell(label: "Revizie", value: "15.000 km", icon: "calendar")
                }

                // VIN display
                if !vehicle.vin.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("VIN")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.textMuted)
                        Text(vehicle.vin)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(Theme.primary)
                            .tracking(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(Color(red: 0.02, green: 0.04, blue: 0.06))
                    .cornerRadius(8)
                }

                // Plate display
                if !vehicle.licensePlate.isEmpty {
                    Text(vehicle.licensePlate)
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundColor(Theme.gaugeYellow)
                        .tracking(3)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.06, green: 0.10, blue: 0.14))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.gaugeYellow, lineWidth: 2))
                }

                // Use vehicle button
                Button(action: {
                    vehicleManager.addVehicle(vehicle)
                    vehicleManager.selectVehicle(vehicle)
                    withAnimation { showResult = false }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Foloseste aceasta masina")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(LinearGradient(colors: [Color(red: 0.09, green: 0.64, blue: 0.26), Theme.gaugeGreen], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(14)
            .background(
                LinearGradient(colors: [Color(red: 0.02, green: 0.11, blue: 0.09), Color(red: 0.04, green: 0.09, blue: 0.16)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(Theme.cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Theme.gaugeGreen.opacity(0.3), lineWidth: 1))
            .padding(.horizontal, 16)
        }
    }

    private func infoCell(label: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 9))
                    .foregroundColor(Theme.textMuted)
                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
            }
            Text(value.isEmpty ? "-" : value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(red: 0.04, green: 0.09, blue: 0.16))
        .cornerRadius(8)
    }

    // MARK: - Actions
    private func submitManual() {
        guard !manualVIN.isEmpty || !manualPlate.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            let vehicle = Vehicle(
                vin: manualVIN.isEmpty ? "WBA3A5C50DF123456" : manualVIN,
                licensePlate: manualPlate,
                make: "BMW",
                model: "Seria 3",
                year: 2019,
                engineType: "2.0d 150cp",
                engineCapacity: "1995cc",
                fuelType: .diesel,
                color: "Negru Sapphire",
                equipment: "Advantage",
                mileage: 87500,
                transmission: .automatic
            )
            identifiedVehicle = vehicle
            isLoading = false
            withAnimation { showResult = true }
        }
    }
}
