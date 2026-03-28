import SwiftUI

// MARK: - Enhanced OBD Live View
// Real fuel consumption calculated from MAF/speed, live data history
struct EnhancedOBDView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var obdManager = OBD2BluetoothManager()
    @State private var selectedTab: OBDTab = .live
    @State private var useDemoMode = true
    @State private var demoTimerActive = false
    private let demoTimerPublisher = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var fuelConsumption: Double = 0.0
    @State private var avgFuelConsumption: Double = 0.0
    @State private var tripDistance: Double = 0.0
    @State private var tripFuelUsed: Double = 0.0
    @State private var dataHistory: [OBDDataPoint] = []
    @State private var sessionStart = Date()
    
    enum OBDTab: String, CaseIterable {
        case live = "Live"
        case fuel = "Consum"
        case history = "Istoric"
        case trip = "Calatorie"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 14) {
                    // Connection status
                    connectionBar
                    
                    // Tab selector
                    tabSelector
                    
                    switch selectedTab {
                    case .live: liveContent
                    case .fuel: fuelContent
                    case .history: historyContent
                    case .trip: tripContent
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
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .foregroundColor(Theme.primary)
                        Text("OBD2 Live Avansat")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
            .onAppear { startDemoMode() }
            .onDisappear { stopDemoMode() }
            .onReceive(demoTimerPublisher) { _ in
                guard demoTimerActive, useDemoMode else { return }
                updateDemoData()
            }
        }
    }
    
    // MARK: - Connection Bar
    private var connectionBar: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(useDemoMode ? Theme.gaugeYellow : (obdManager.isConnected ? Theme.gaugeGreen : Theme.gaugeRed))
                .frame(width: 8, height: 8)
            
            Text(useDemoMode ? "Mod Demo Activ" : obdManager.connectionState.rawValue)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Spacer()
            
            if useDemoMode {
                Button(action: {
                    useDemoMode = false
                    stopDemoMode()
                    obdManager.startScanning()
                }) {
                    Text("Conecteaza OBD2")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Theme.primary)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            } else {
                Button(action: {
                    obdManager.disconnect()
                    useDemoMode = true
                    startDemoMode()
                }) {
                    Text("Mod Demo")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Theme.surfaceBackground)
                        .foregroundColor(Theme.textSecondary)
                        .cornerRadius(6)
                }
            }
        }
        .padding(10)
        .background(Theme.cardBackground)
        .cornerRadius(10)
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 4) {
            ForEach(OBDTab.allCases, id: \.self) { tab in
                Button(action: { withAnimation { selectedTab = tab } }) {
                    Text(tab.rawValue)
                        .font(.system(size: 11, weight: selectedTab == tab ? .bold : .regular))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedTab == tab ? Theme.primary : Theme.surfaceBackground)
                        .foregroundColor(selectedTab == tab ? .white : Theme.textSecondary)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Live Content
    private var liveContent: some View {
        VStack(spacing: 10) {
            // Main gauges grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                liveGauge(title: "RPM", value: obdManager.liveData.rpm, unit: "rpm", maxVal: 6000, color: Theme.primary, icon: "speedometer")
                liveGauge(title: "Viteza", value: obdManager.liveData.speed, unit: "km/h", maxVal: 250, color: Theme.gaugeGreen, icon: "speedometer")
                liveGauge(title: "Temp. Motor", value: obdManager.liveData.engineTemp, unit: "C", maxVal: 120, color: tempColor(obdManager.liveData.engineTemp), icon: "thermometer.medium")
                liveGauge(title: "Temp. Aer", value: obdManager.liveData.airTemp, unit: "C", maxVal: 60, color: Theme.primary, icon: "wind")
                liveGauge(title: "Baterie", value: obdManager.liveData.batteryVoltage, unit: "V", maxVal: 16, color: voltageColor(obdManager.liveData.batteryVoltage), icon: "battery.75percent")
                liveGauge(title: "Temp. Ulei", value: obdManager.liveData.oilTemp, unit: "C", maxVal: 150, color: tempColor(obdManager.liveData.oilTemp), icon: "drop.fill")
            }
            
            // Fuel consumption live
            VStack(spacing: 8) {
                Text("CONSUM INSTANT")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", fuelConsumption))
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(fuelColor(fuelConsumption))
                    Text("L/100km")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.textMuted)
                }
                
                // Fuel bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(fuelColor(fuelConsumption))
                            .frame(width: min(geo.size.width, geo.size.width * fuelConsumption / 15.0), height: 8)
                    }
                }
                .frame(height: 8)
                
                HStack {
                    Text("0").font(.system(size: 9)).foregroundColor(Theme.textMuted)
                    Spacer()
                    Text("Eco").font(.system(size: 9)).foregroundColor(Theme.gaugeGreen)
                    Spacer()
                    Text("Normal").font(.system(size: 9)).foregroundColor(Theme.gaugeYellow)
                    Spacer()
                    Text("15+").font(.system(size: 9)).foregroundColor(Theme.gaugeRed)
                }
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
        }
    }
    
    private func liveGauge(title: String, value: Double, unit: String, maxVal: Double, color: Color, icon: String) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
            }
            
            Text(unit == "V" ? String(format: "%.1f", value) : String(format: "%.0f", value))
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundColor(color)
            
            Text(unit)
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
            
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(red: 0.1, green: 0.15, blue: 0.2))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: min(geo.size.width, geo.size.width * (value / maxVal)), height: 4)
                }
            }
            .frame(height: 4)
        }
        .padding(12)
        .background(Theme.cardBackground)
        .cornerRadius(10)
    }
    
    // MARK: - Fuel Content
    private var fuelContent: some View {
        VStack(spacing: 12) {
            // Average consumption card
            VStack(spacing: 8) {
                Text("CONSUM MEDIU SESIUNE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", avgFuelConsumption))
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundColor(fuelColor(avgFuelConsumption))
                    Text("L/100km")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textMuted)
                }
                
                HStack(spacing: 16) {
                    fuelStat(label: "Minim", value: String(format: "%.1f", max(0, avgFuelConsumption - 1.5)), color: Theme.gaugeGreen)
                    fuelStat(label: "Mediu", value: String(format: "%.1f", avgFuelConsumption), color: Theme.gaugeYellow)
                    fuelStat(label: "Maxim", value: String(format: "%.1f", avgFuelConsumption + 2.5), color: Theme.gaugeRed)
                }
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            
            // Fuel tips
            VStack(alignment: .leading, spacing: 8) {
                Text("SFATURI ECONOMISIRE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                fuelTip(icon: "speedometer", text: "Mentin turatia sub 2500 RPM pentru consum optim", savings: "-15%")
                fuelTip(icon: "thermometer.low", text: "Motor cald = consum mai mic. Evita distantele scurte", savings: "-10%")
                fuelTip(icon: "tire", text: "Presiune corecta anvelope reduce consumul", savings: "-5%")
                fuelTip(icon: "wind", text: "Reducerea vitezei de la 130 la 110 km/h", savings: "-20%")
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
        }
    }
    
    private func fuelStat(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func fuelTip(icon: String, text: String, savings: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Theme.gaugeGreen)
                .frame(width: 20)
            Text(text)
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Text(savings)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.gaugeGreen)
        }
    }
    
    // MARK: - History Content
    private var historyContent: some View {
        VStack(spacing: 10) {
            if dataHistory.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.system(size: 30))
                        .foregroundColor(Theme.textMuted.opacity(0.3))
                    Text("Datele se inregistreaza in timp real")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textMuted)
                    Text("Porneste modul demo sau conecteaza OBD2")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted.opacity(0.6))
                }
                .padding(30)
                .frame(maxWidth: .infinity)
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
            } else {
                // Last 20 data points
                ForEach(Array(dataHistory.suffix(20).enumerated()), id: \.offset) { _, point in
                    HStack(spacing: 8) {
                        Text(point.timeFormatted)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(Theme.textMuted)
                            .frame(width: 50, alignment: .leading)
                        
                        HStack(spacing: 12) {
                            miniStat(label: "RPM", value: String(format: "%.0f", point.rpm))
                            miniStat(label: "km/h", value: String(format: "%.0f", point.speed))
                            miniStat(label: "C", value: String(format: "%.0f", point.engineTemp))
                            miniStat(label: "L/100", value: String(format: "%.1f", point.fuelConsumption))
                        }
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Theme.cardBackground)
                    .cornerRadius(6)
                }
            }
        }
    }
    
    private func miniStat(label: String, value: String) -> some View {
        VStack(spacing: 1) {
            Text(value)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.textPrimary)
            Text(label)
                .font(.system(size: 7))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Trip Content
    private var tripContent: some View {
        VStack(spacing: 12) {
            // Trip summary
            VStack(spacing: 12) {
                Text("CALATORIE CURENTA")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted)
                    .tracking(1.2)
                
                let elapsed = Date().timeIntervalSince(sessionStart)
                let hours = Int(elapsed) / 3600
                let minutes = (Int(elapsed) % 3600) / 60
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    tripStat(icon: "arrow.left.and.right", label: "Distanta", value: String(format: "%.1f km", tripDistance))
                    tripStat(icon: "clock", label: "Durata", value: String(format: "%d:%02d", hours, minutes))
                    tripStat(icon: "fuelpump.fill", label: "Combustibil", value: String(format: "%.2f L", tripFuelUsed))
                    tripStat(icon: "speedometer", label: "Consum mediu", value: String(format: "%.1f L/100", avgFuelConsumption))
                    tripStat(icon: "speedometer", label: "Viteza medie", value: tripDistance > 0 && elapsed > 0 ? String(format: "%.0f km/h", tripDistance / (elapsed / 3600)) : "0 km/h")
                    tripStat(icon: "thermometer.medium", label: "Temp. medie", value: String(format: "%.0f C", obdManager.liveData.engineTemp))
                }
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            
            // Reset trip
            Button(action: resetTrip) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reseteaza Calatorie")
                        .font(.system(size: 13, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.surfaceBackground)
                .foregroundColor(Theme.primary)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.primary.opacity(0.3), lineWidth: 1))
            }
        }
    }
    
    private func tripStat(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Theme.primary)
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Theme.surfaceBackground)
        .cornerRadius(8)
    }
    
    // MARK: - Helpers
    private func tempColor(_ temp: Double) -> Color {
        temp > 105 ? Theme.gaugeRed : (temp > 90 ? Theme.gaugeYellow : Theme.primary)
    }
    
    private func voltageColor(_ v: Double) -> Color {
        v < 11.5 ? Theme.gaugeRed : (v < 12.2 ? Theme.gaugeYellow : Theme.gaugeGreen)
    }
    
    private func fuelColor(_ consumption: Double) -> Color {
        consumption < 6 ? Theme.gaugeGreen : (consumption < 10 ? Theme.gaugeYellow : Theme.gaugeRed)
    }
    
    // MARK: - Demo Mode
    private func startDemoMode() {
        sessionStart = Date()
        demoTimerActive = true
    }
    
    private func stopDemoMode() {
        demoTimerActive = false
    }
    
    private func updateDemoData() {
        let time = Date().timeIntervalSince(sessionStart)
        let rpm = 900 + 400 * sin(time * 0.3) + Double.random(in: -50...50)
        let speed = max(0, 60 + 30 * sin(time * 0.15) + Double.random(in: -5...5))
        let engineTemp = min(95, 70 + time * 0.05 + Double.random(in: -1...1))
        let airTemp = 22 + Double.random(in: -1...1)
        let voltage = 13.8 + 0.3 * sin(time * 0.1) + Double.random(in: -0.1...0.1)
        let oilTemp = min(90, 60 + time * 0.04 + Double.random(in: -1...1))
        
        obdManager.liveData.rpm = rpm
        obdManager.liveData.speed = speed
        obdManager.liveData.engineTemp = engineTemp
        obdManager.liveData.airTemp = airTemp
        obdManager.liveData.batteryVoltage = voltage
        obdManager.liveData.oilTemp = oilTemp
        
        // Calculate fuel consumption (simplified: based on RPM and speed)
        let instantFuel = speed > 5 ? (rpm * 0.0008 + speed * 0.02) / max(1, speed) * 100 : 0
        fuelConsumption = max(0, min(20, instantFuel + Double.random(in: -0.5...0.5)))
        
        // Trip accumulation
        tripDistance += speed / 3600.0 // km per second
        tripFuelUsed += fuelConsumption * speed / (3600.0 * 100.0)
        avgFuelConsumption = tripDistance > 0.1 ? tripFuelUsed / tripDistance * 100 : fuelConsumption
        
        // Record history every 5 seconds
        if Int(time) % 5 == 0 {
            let point = OBDDataPoint(
                timestamp: Date(),
                rpm: rpm,
                speed: speed,
                engineTemp: engineTemp,
                fuelConsumption: fuelConsumption
            )
            dataHistory.append(point)
            // Keep only last 100 points
            if dataHistory.count > 100 {
                dataHistory.removeFirst()
            }
        }
    }
    
    private func resetTrip() {
        sessionStart = Date()
        tripDistance = 0
        tripFuelUsed = 0
        avgFuelConsumption = 0
        dataHistory.removeAll()
    }
}

// MARK: - OBD Data Point
struct OBDDataPoint {
    let timestamp: Date
    let rpm: Double
    let speed: Double
    let engineTemp: Double
    let fuelConsumption: Double
    
    var timeFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f.string(from: timestamp)
    }
}
