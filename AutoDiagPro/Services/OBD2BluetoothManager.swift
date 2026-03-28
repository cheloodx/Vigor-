import Foundation
import CoreBluetooth
import Combine

// MARK: - OBD2 Connection State
enum OBD2ConnectionState: String {
    case disconnected = "Deconectat"
    case scanning = "Cautare dispozitive..."
    case connecting = "Conectare..."
    case initializing = "Initializare ELM327..."
    case connected = "Conectat"
    case error = "Eroare"
}

// MARK: - ELM327 Commands
struct ELM327Commands {
    static let reset = "ATZ\r"
    static let echoOff = "ATE0\r"
    static let lineFeedOff = "ATL0\r"
    static let spacesOff = "ATS0\r"
    static let headersOff = "ATH0\r"
    static let autoProtocol = "ATSP0\r"
    static let protocolSearch = "0100\r"

    // OBD2 PIDs (Mode 01)
    static let engineCoolantTemp = "0105\r"   // PID 05 - Celsius
    static let engineRPM = "010C\r"           // PID 0C - RPM
    static let vehicleSpeed = "010D\r"        // PID 0D - km/h
    static let intakeAirTemp = "010F\r"       // PID 0F - Celsius
    static let controlModuleVoltage = "ATRV\r" // Battery voltage (AT command)
    static let engineLoad = "0104\r"          // PID 04 - %
    static let oilTemp = "015C\r"             // PID 5C - Celsius (if supported)
}

// MARK: - OBD2 Bluetooth Manager
class OBD2BluetoothManager: NSObject, ObservableObject {
    @Published var connectionState: OBD2ConnectionState = .disconnected
    @Published var liveData = OBDLiveData()
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var errorMessage: String?
    @Published var protocolName: String = "Necunoscut"
    @Published var adapterVersion: String = "ELM327"

    deinit {
        disconnect()
    }

    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?
    private var notifyCharacteristic: CBCharacteristic?

    // ELM327 service/characteristic UUIDs (common for most adapters)
    private let elm327ServiceUUID = CBUUID(string: "FFF0")
    private let elm327WriteUUID = CBUUID(string: "FFF1")
    private let elm327NotifyUUID = CBUUID(string: "FFF2")

    // Alternative UUIDs used by some adapters
    private let sppServiceUUID = CBUUID(string: "0000FFE0-0000-1000-8000-00805F9B34FB")
    private let sppCharUUID = CBUUID(string: "0000FFE1-0000-1000-8000-00805F9B34FB")

    private var responseBuffer = ""
    private var pollingTimer: Timer?
    private var initStep = 0
    private var currentPIDIndex = 0
    private let pidCycle: [String] = [
        ELM327Commands.engineCoolantTemp,
        ELM327Commands.engineRPM,
        ELM327Commands.vehicleSpeed,
        ELM327Commands.intakeAirTemp,
        ELM327Commands.controlModuleVoltage,
        ELM327Commands.oilTemp,
    ]

    var isConnected: Bool {
        connectionState == .connected
    }

    // MARK: - Public API

    func startScanning() {
        connectionState = .scanning
        errorMessage = nil
        discoveredDevices = []

        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        } else if centralManager?.state == .poweredOn {
            centralManager?.scanForPeripherals(
                withServices: nil,
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
            )
        }

        // Auto-stop scan after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self, self.connectionState == .scanning else { return }
            self.centralManager?.stopScan()
            if self.discoveredDevices.isEmpty {
                self.errorMessage = "Nu s-au gasit dispozitive OBD2. Verificati ca adaptorul e pornit."
                self.connectionState = .disconnected
            }
        }
    }

    func connectToDevice(_ peripheral: CBPeripheral) {
        centralManager?.stopScan()
        connectionState = .connecting
        connectedPeripheral = peripheral
        peripheral.delegate = self
        centralManager?.connect(peripheral, options: nil)
    }

    func disconnect() {
        pollingTimer?.invalidate()
        pollingTimer = nil

        if let peripheral = connectedPeripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
        }

        connectedPeripheral = nil
        writeCharacteristic = nil
        notifyCharacteristic = nil
        connectionState = .disconnected
        liveData = OBDLiveData()
    }

    // MARK: - ELM327 Initialization

    private func initializeELM327() {
        connectionState = .initializing
        initStep = 0
        sendNextInitCommand()
    }

    private func sendNextInitCommand() {
        let initCommands = [
            ELM327Commands.reset,
            ELM327Commands.echoOff,
            ELM327Commands.lineFeedOff,
            ELM327Commands.spacesOff,
            ELM327Commands.headersOff,
            ELM327Commands.autoProtocol,
            ELM327Commands.protocolSearch,
        ]

        guard initStep < initCommands.count else {
            // Initialization complete
            connectionState = .connected
            startPolling()
            return
        }

        sendCommand(initCommands[initStep])
    }

    // MARK: - Data Polling

    private func startPolling() {
        currentPIDIndex = 0
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            self?.pollNextPID()
        }
    }

    private func pollNextPID() {
        guard connectionState == .connected else {
            pollingTimer?.invalidate()
            pollingTimer = nil
            return
        }

        let command = pidCycle[currentPIDIndex]
        sendCommand(command)
        currentPIDIndex = (currentPIDIndex + 1) % pidCycle.count
    }

    // MARK: - Send Command

    private func sendCommand(_ command: String) {
        guard let characteristic = writeCharacteristic ?? notifyCharacteristic,
              let peripheral = connectedPeripheral,
              let data = command.data(using: .ascii) else {
            return
        }

        let writeType: CBCharacteristicWriteType = characteristic.properties.contains(.write) ? .withResponse : .withoutResponse
        peripheral.writeValue(data, for: characteristic, type: writeType)
    }

    // MARK: - Response Parsing

    private func processResponse(_ response: String) {
        let cleaned = response
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: ">", with: "")
            .trimmingCharacters(in: .whitespaces)

        if cleaned.isEmpty { return }

        // During initialization
        if connectionState == .initializing {
            if cleaned.contains("ELM327") {
                adapterVersion = cleaned
            }
            if cleaned.contains("ISO") || cleaned.contains("CAN") || cleaned.contains("SAE") {
                protocolName = cleaned
            }

            // Detect error responses from ELM327
            let errorIndicators = ["?", "ERROR", "UNABLE TO CONNECT", "NO DATA", "CAN ERROR"]
            let isError = errorIndicators.contains { cleaned.uppercased().contains($0) }

            // Protocol search (last init step) failing means vehicle ECU is not responding
            if isError && initStep >= 6 {
                errorMessage = "Vehiculul nu raspunde. Verificati contactul si cablul OBD2."
                connectionState = .error
                return
            }

            initStep += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.sendNextInitCommand()
            }
            return
        }

        // Parse PID responses
        parsePIDResponse(cleaned)
    }

    private func parsePIDResponse(_ response: String) {
        // Remove spaces and get hex bytes
        let hex = response.replacingOccurrences(of: " ", with: "")

        // Check for standard OBD response format: 41XX...
        guard hex.count >= 4, hex.hasPrefix("41") else {
            // Check for voltage response (ATRV)
            if response.contains("V") || response.contains("v") {
                let digits = response.filter { $0.isNumber || $0 == "." }
                if let voltage = Double(digits) {
                    DispatchQueue.main.async { [weak self] in
                        self?.liveData.batteryVoltage = voltage
                    }
                }
            }
            return
        }

        let pidHex = String(hex.dropFirst(2).prefix(2)).uppercased()
        let dataHex = String(hex.dropFirst(4))

        switch pidHex {
        case "05": // Engine coolant temperature
            if let byteA = UInt8(dataHex.prefix(2), radix: 16) {
                let temp = Double(byteA) - 40
                DispatchQueue.main.async { [weak self] in
                    self?.liveData.engineTemp = temp
                }
            }

        case "0C": // Engine RPM
            if dataHex.count >= 4,
               let byteA = UInt16(dataHex.prefix(2), radix: 16),
               let byteB = UInt16(String(dataHex.dropFirst(2).prefix(2)), radix: 16) {
                let rpm = Double((byteA * 256 + byteB)) / 4.0
                DispatchQueue.main.async { [weak self] in
                    self?.liveData.rpm = rpm
                }
            }

        case "0D": // Vehicle speed
            if let byteA = UInt8(dataHex.prefix(2), radix: 16) {
                let speed = Double(byteA)
                DispatchQueue.main.async { [weak self] in
                    self?.liveData.speed = speed
                }
            }

        case "0F": // Intake air temperature
            if let byteA = UInt8(dataHex.prefix(2), radix: 16) {
                let temp = Double(byteA) - 40
                DispatchQueue.main.async { [weak self] in
                    self?.liveData.airTemp = temp
                }
            }

        case "5C": // Oil temperature
            if let byteA = UInt8(dataHex.prefix(2), radix: 16) {
                let temp = Double(byteA) - 40
                DispatchQueue.main.async { [weak self] in
                    self?.liveData.oilTemp = temp
                }
            }

        default:
            break
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension OBD2BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            if connectionState == .scanning {
                central.scanForPeripherals(
                    withServices: nil,
                    options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
                )
            }
        case .poweredOff:
            errorMessage = "Bluetooth este oprit. Porniti Bluetooth din Setari."
            connectionState = .disconnected
        case .unauthorized:
            errorMessage = "Aplicatia nu are permisiune pentru Bluetooth. Activati din Setari."
            connectionState = .disconnected
        case .unsupported:
            errorMessage = "Acest dispozitiv nu suporta Bluetooth LE."
            connectionState = .disconnected
        default:
            break
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let name = peripheral.name ?? ""
        // Filter for likely OBD2 adapters
        let obdKeywords = ["OBD", "ELM", "V-LINK", "Vgate", "iCar", "OBDII", "Veepeak", "Konnwei", "Scan"]
        let isLikelyOBD = obdKeywords.contains { name.localizedCaseInsensitiveContains($0) }

        if isLikelyOBD || !name.isEmpty {
            if !discoveredDevices.contains(where: { $0.identifier == peripheral.identifier }) {
                DispatchQueue.main.async { [weak self] in
                    self?.discoveredDevices.append(peripheral)
                }
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([elm327ServiceUUID, sppServiceUUID])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = "Nu m-am putut conecta: \(error?.localizedDescription ?? "eroare necunoscuta")"
            self?.connectionState = .disconnected
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.pollingTimer?.invalidate()
            self?.pollingTimer = nil
            self?.connectionState = .disconnected
            if error != nil {
                self?.errorMessage = "Conexiunea s-a pierdut. Reconectati adaptorul."
            }
        }
    }
}

// MARK: - CBPeripheralDelegate
extension OBD2BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services, error == nil else {
            errorMessage = "Nu s-au putut descoperi serviciile Bluetooth."
            connectionState = .error
            return
        }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) || characteristic.properties.contains(.indicate) {
                peripheral.setNotifyValue(true, for: characteristic)
                notifyCharacteristic = characteristic
            }

            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                writeCharacteristic = characteristic
            }

            // For SPP-like services, the same characteristic handles both
            if characteristic.uuid == sppCharUUID {
                writeCharacteristic = characteristic
                notifyCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }

        // If we found write + notify, start initialization (only once)
        if (writeCharacteristic != nil || notifyCharacteristic != nil) && connectionState == .connecting {
            initializeELM327()
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value, let response = String(data: data, encoding: .ascii) else { return }

        responseBuffer += response

        // ELM327 responses end with ">" prompt
        if responseBuffer.contains(">") {
            let fullResponse = responseBuffer
            responseBuffer = ""
            processResponse(fullResponse)
        }
    }
}
