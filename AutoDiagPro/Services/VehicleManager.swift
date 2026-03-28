import SwiftUI
import Combine

class VehicleManager: ObservableObject {
    @Published var currentVehicle: Vehicle = Vehicle.sample
    @Published var savedVehicles: [Vehicle] = [Vehicle.sample, Vehicle.sampleBMW]
    @Published var serviceItems: [ServiceItem] = ServiceItem.allItems
    @Published var costOperations: [CostOperation] = CostOperation.allOperations
    @Published var diagnosticHistory: [DiagnosticResult] = []

    private let vehiclesKey = "saved_vehicles"
    private let serviceKey = "service_items"

    init() {
        loadData()
        // Persist default vehicles on first launch so their UUIDs are stable across restarts.
        // Without this, Vehicle.sample/sampleBMW generate new UUIDs each launch,
        // causing journal entries (keyed by vehicle UUID) to be lost.
        saveData()
    }

    // MARK: - Vehicle Management
    func selectVehicle(_ vehicle: Vehicle) {
        currentVehicle = vehicle
        updateServiceMileage(vehicle.mileage)
    }

    func addVehicle(_ vehicle: Vehicle) {
        let isDuplicate = savedVehicles.contains { existing in
            (!vehicle.vin.isEmpty && existing.vin == vehicle.vin) ||
            (!vehicle.licensePlate.isEmpty && existing.licensePlate == vehicle.licensePlate)
        }
        guard !isDuplicate else { return }
        savedVehicles.append(vehicle)
        saveData()
    }

    func updateVehicle(_ vehicle: Vehicle) {
        if let index = savedVehicles.firstIndex(where: { $0.id == vehicle.id }) {
            savedVehicles[index] = vehicle
            if currentVehicle.id == vehicle.id {
                currentVehicle = vehicle
            }
            saveData()
        }
    }

    // MARK: - Service Management
    func updateServiceMileage(_ km: Int) {
        for i in serviceItems.indices {
            serviceItems[i].currentKm = km
        }
    }

    func markServiceDone(itemId: UUID, date: Date, km: Int) {
        if let index = serviceItems.firstIndex(where: { $0.id == itemId }) {
            serviceItems[index].lastServiceDate = date
            serviceItems[index].lastServiceKm = km
            serviceItems[index].currentKm = km
            saveData()
        }
    }

    // MARK: - Cost Operations
    func toggleOperation(_ operationId: UUID) {
        if let index = costOperations.firstIndex(where: { $0.id == operationId }) {
            costOperations[index].isSelected.toggle()
        }
    }

    func clearSelectedOperations() {
        for i in costOperations.indices {
            costOperations[i].isSelected = false
        }
    }

    var costSummary: CostSummary {
        CostSummary(operations: costOperations)
    }

    // MARK: - Diagnostic
    func addDiagnosticResult(_ result: DiagnosticResult) {
        diagnosticHistory.insert(result, at: 0)
    }

    // MARK: - Persistence
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(savedVehicles) {
            UserDefaults.standard.set(encoded, forKey: vehiclesKey)
        }
        if let encoded = try? JSONEncoder().encode(serviceItems) {
            UserDefaults.standard.set(encoded, forKey: serviceKey)
        }
    }

    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: vehiclesKey),
           let vehicles = try? JSONDecoder().decode([Vehicle].self, from: data) {
            savedVehicles = vehicles
            if let first = vehicles.first {
                currentVehicle = first
            }
        }
        if let data = UserDefaults.standard.data(forKey: serviceKey),
           let items = try? JSONDecoder().decode([ServiceItem].self, from: data) {
            serviceItems = items
        }
    }
}
