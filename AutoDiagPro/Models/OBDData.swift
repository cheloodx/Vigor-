import Foundation
import SwiftUI

struct OBDLiveData: Codable {
    var engineTemp: Double = 0       // Celsius
    var airTemp: Double = 0          // Celsius
    var rpm: Double = 0              // RPM
    var speed: Double = 0            // km/h
    var batteryVoltage: Double = 0   // Volts
    var oilPressure: Double = 0      // Bar

    var engineTempFormatted: String { String(format: "%.0f°C", engineTemp) }
    var airTempFormatted: String { String(format: "%.0f°C", airTemp) }
    var rpmFormatted: String { String(format: "%.0f", rpm) }
    var speedFormatted: String { String(format: "%.0f", speed) }
    var voltageFormatted: String { String(format: "%.1fV", batteryVoltage) }
    var oilPressureFormatted: String { String(format: "%.1f bar", oilPressure) }
}

struct GaugeConfig: Identifiable {
    let id = UUID()
    let title: String
    let unit: String
    let minValue: Double
    let maxValue: Double
    let warningThreshold: Double
    let dangerThreshold: Double
    let icon: String
    let keyPath: KeyPath<OBDLiveData, Double>
    let colorScheme: GaugeColorScheme

    var range: ClosedRange<Double> {
        minValue...maxValue
    }

    func normalizedValue(_ data: OBDLiveData) -> Double {
        let value = data[keyPath: keyPath]
        return (value - minValue) / (maxValue - minValue)
    }

    func statusColor(_ data: OBDLiveData) -> Color {
        let value = data[keyPath: keyPath]
        switch colorScheme {
        case .highIsBad:
            if value >= dangerThreshold { return Theme.gaugeRed }
            if value >= warningThreshold { return Theme.gaugeYellow }
            return Theme.gaugeGreen
        case .lowIsBad:
            if value <= dangerThreshold { return Theme.gaugeRed }
            if value <= warningThreshold { return Theme.gaugeYellow }
            return Theme.gaugeGreen
        case .neutral:
            return Theme.gaugeBlue
        }
    }
}

enum GaugeColorScheme {
    case highIsBad
    case lowIsBad
    case neutral
}

// MARK: - Gauge Configurations
extension GaugeConfig {
    static let allGauges: [GaugeConfig] = [
        GaugeConfig(
            title: "Temperatura Motor",
            unit: "°C",
            minValue: 0,
            maxValue: 130,
            warningThreshold: 100,
            dangerThreshold: 110,
            icon: "thermometer.high",
            keyPath: \.engineTemp,
            colorScheme: .highIsBad
        ),
        GaugeConfig(
            title: "Temperatura Aer",
            unit: "°C",
            minValue: -20,
            maxValue: 50,
            warningThreshold: 40,
            dangerThreshold: 45,
            icon: "thermometer.sun.fill",
            keyPath: \.airTemp,
            colorScheme: .neutral
        ),
        GaugeConfig(
            title: "Turatie Motor",
            unit: "RPM",
            minValue: 0,
            maxValue: 8000,
            warningThreshold: 5500,
            dangerThreshold: 6500,
            icon: "gauge.open.with.lines.needle.33percent",
            keyPath: \.rpm,
            colorScheme: .highIsBad
        ),
        GaugeConfig(
            title: "Viteza",
            unit: "km/h",
            minValue: 0,
            maxValue: 260,
            warningThreshold: 180,
            dangerThreshold: 220,
            icon: "speedometer",
            keyPath: \.speed,
            colorScheme: .neutral
        ),
        GaugeConfig(
            title: "Tensiune Baterie",
            unit: "V",
            minValue: 10,
            maxValue: 16,
            warningThreshold: 11.5,
            dangerThreshold: 11.0,
            icon: "battery.100.bolt",
            keyPath: \.batteryVoltage,
            colorScheme: .lowIsBad
        ),
        GaugeConfig(
            title: "Presiune Ulei",
            unit: "bar",
            minValue: 0,
            maxValue: 6,
            warningThreshold: 1.5,
            dangerThreshold: 1.0,
            icon: "drop.fill",
            keyPath: \.oilPressure,
            colorScheme: .lowIsBad
        ),
    ]
}

// MARK: - Demo Data Generator
class OBDDemoSimulator: ObservableObject {
    @Published var liveData = OBDLiveData()
    private var timer: Timer?

    deinit {
        stopSimulation()
    }

    func startSimulation() {
        // Initial values
        liveData = OBDLiveData(
            engineTemp: 45,
            airTemp: 22,
            rpm: 800,
            speed: 0,
            batteryVoltage: 12.6,
            oilPressure: 2.0
        )

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateValues()
        }
    }

    func stopSimulation() {
        timer?.invalidate()
        timer = nil
    }

    private func updateValues() {
        let time = Date().timeIntervalSinceReferenceDate

        // Simulate engine warming up and driving
        let drivePhase = sin(time * 0.05) * 0.5 + 0.5 // 0-1 cycle

        liveData.engineTemp = min(95, liveData.engineTemp + 0.02) + sin(time * 0.1) * 2
        liveData.airTemp = 22 + sin(time * 0.01) * 3
        liveData.rpm = 800 + drivePhase * 3500 + sin(time * 0.3) * 200
        liveData.speed = drivePhase * 120 + sin(time * 0.2) * 10
        liveData.batteryVoltage = 13.8 + sin(time * 0.05) * 0.3
        liveData.oilPressure = 2.0 + drivePhase * 2.5 + sin(time * 0.15) * 0.3

        // Clamp values
        liveData.speed = max(0, liveData.speed)
        liveData.rpm = max(600, liveData.rpm)
        liveData.oilPressure = max(0.5, liveData.oilPressure)
    }
}
