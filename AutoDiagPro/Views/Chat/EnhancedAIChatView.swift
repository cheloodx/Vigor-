import SwiftUI

// MARK: - Enhanced AI Chat View
// Context-aware AI mechanic: knows your car, history, OBD data
struct EnhancedAIChatView: View {
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var messages: [AIChatMessage] = []
    @State private var inputText = ""
    @State private var isTyping = false
    @State private var showQuickActions = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Vehicle context bar
                vehicleContextBar
                
                // Chat messages
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 10) {
                            // Welcome message
                            if messages.isEmpty {
                                welcomeCard
                            }
                            
                            ForEach(messages) { msg in
                                chatBubble(msg)
                                    .id(msg.id)
                            }
                            
                            if isTyping {
                                typingIndicator
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 80)
                    }
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Quick actions
                if showQuickActions && messages.count < 3 {
                    quickActionsBar
                }
                
                // Input bar
                inputBar
            }
            .background(Theme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .foregroundColor(Theme.primary)
                        Text(localization.t("chat.ai_title"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: clearChat) {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textMuted)
                    }
                }
            }
        }
    }
    
    // MARK: - Vehicle Context Bar
    private var vehicleContextBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "car.fill")
                .font(.system(size: 12))
                .foregroundColor(Theme.primary)
            Text("Context: \(vehicleManager.currentVehicle.shortName)")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            Text("| \(vehicleManager.currentVehicle.mileage) km | \(vehicleManager.currentVehicle.engineType)")
                .font(.system(size: 10))
                .foregroundColor(Theme.textMuted)
            Spacer()
            Image(systemName: "brain")
                .font(.system(size: 11))
                .foregroundColor(Theme.gaugeGreen)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Theme.cardBackground)
    }
    
    // MARK: - Welcome Card
    private var welcomeCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "wrench.and.screwdriver.fill")
                .font(.system(size: 36))
                .foregroundColor(Theme.primary)
            
            Text(localization.t("chat.ai_title"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Sunt mecanicul tau virtual cu experienta pe \(vehicleManager.currentVehicle.shortName). Stiu istoricul masinii tale, datele OBD2 si pot diagnostica probleme.")
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            // Context chips
            HStack(spacing: 6) {
                contextChip(icon: "car.fill", text: vehicleManager.currentVehicle.shortName)
                contextChip(icon: "speedometer", text: "\(vehicleManager.currentVehicle.mileage) km")
                contextChip(icon: "fuelpump.fill", text: vehicleManager.currentVehicle.fuelType.rawValue)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
    
    private func contextChip(icon: String, text: String) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon).font(.system(size: 8))
            Text(text).font(.system(size: 9, weight: .semibold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Theme.primary.opacity(0.1))
        .foregroundColor(Theme.primary)
        .cornerRadius(4)
    }
    
    // MARK: - Chat Bubble
    private func chatBubble(_ message: AIChatMessage) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if message.isUser {
                Spacer(minLength: 50)
            } else {
                ZStack {
                    Circle()
                        .fill(Theme.primary.opacity(0.15))
                        .frame(width: 30, height: 30)
                    Image(systemName: "wrench.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.primary)
                }
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.system(size: 13))
                    .foregroundColor(message.isUser ? .white : Theme.textPrimary)
                    .padding(12)
                    .background(message.isUser ? Theme.primary : Theme.cardBackground)
                    .cornerRadius(16)
                    .cornerRadius(16)
                
                // Action buttons for AI responses
                if !message.isUser && !message.actions.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(message.actions, id: \.self) { action in
                            Button(action: { sendMessage(action) }) {
                                Text(action)
                                    .font(.system(size: 10, weight: .semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Theme.primary.opacity(0.1))
                                    .foregroundColor(Theme.primary)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
                
                Text(message.timeFormatted)
                    .font(.system(size: 9))
                    .foregroundColor(Theme.textMuted)
            }
            
            if !message.isUser {
                Spacer(minLength: 50)
            }
        }
    }
    
    // MARK: - Typing Indicator
    private var typingIndicator: some View {
        HStack(alignment: .top, spacing: 8) {
            ZStack {
                Circle()
                    .fill(Theme.primary.opacity(0.15))
                    .frame(width: 30, height: 30)
                Image(systemName: "wrench.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.primary)
            }
            
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Theme.textMuted)
                        .frame(width: 6, height: 6)
                        .opacity(0.6)
                }
            }
            .padding(12)
            .background(Theme.cardBackground)
            .cornerRadius(16)
            
            Spacer(minLength: 50)
        }
    }
    
    // MARK: - Quick Actions
    private var quickActionsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                quickAction(text: "Ce probleme are masina mea?", icon: "exclamationmark.triangle")
                quickAction(text: "Cand trebuie revizia?", icon: "calendar")
                quickAction(text: "Cat costa schimbul de distributie?", icon: "creditcard")
                quickAction(text: "Am o eroare P0300", icon: "xmark.octagon")
                quickAction(text: "Masina vibreaza", icon: "waveform.path")
                quickAction(text: "Consum mare", icon: "fuelpump")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Theme.cardBackground)
    }
    
    private func quickAction(text: String, icon: String) -> some View {
        Button(action: { sendMessage(text) }) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 10))
                Text(text).font(.system(size: 11, weight: .semibold))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Theme.primary.opacity(0.1))
            .foregroundColor(Theme.primary)
            .cornerRadius(8)
        }
    }
    
    // MARK: - Input Bar
    private var inputBar: some View {
        HStack(spacing: 8) {
            TextField(localization.t("chat.placeholder"), text: $inputText)
                .font(.system(size: 14))
                .foregroundColor(Theme.textPrimary)
                .padding(10)
                .background(Theme.surfaceBackground)
                .cornerRadius(10)
            
            Button(action: { sendMessage(inputText) }) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(inputText.isEmpty ? Theme.textMuted : Theme.primary)
            }
            .disabled(inputText.isEmpty)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Theme.cardBackground)
    }
    
    // MARK: - Actions
    private func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let userMsg = AIChatMessage(text: trimmed, isUser: true, actions: [])
        messages.append(userMsg)
        inputText = ""
        showQuickActions = false
        isTyping = true
        
        let vehicle = vehicleManager.currentVehicle
        let response = generateContextAwareResponse(for: trimmed, vehicle: vehicle)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTyping = false
            messages.append(response)
        }
    }
    
    private func clearChat() {
        messages.removeAll()
        showQuickActions = true
    }
    
    // MARK: - AI Response Generation
    private func generateContextAwareResponse(for input: String, vehicle: Vehicle) -> AIChatMessage {
        let lower = input.lowercased()
        let carName = vehicle.shortName
        let km = vehicle.mileage
        let engine = vehicle.engineType
        
        // Context-aware responses
        if lower.contains("problema") || lower.contains("ce are") {
            return AIChatMessage(
                text: "Pe baza datelor din \(carName) cu \(km) km si motor \(engine), cele mai frecvente probleme la acest kilometraj sunt:\n\n1. Uzura placute frana (daca nu au fost schimbate recent)\n2. Volant bimasa - verificare la vibratie in ralanti\n3. EGR - curatatire recomandata la \(km > 100000 ? "acest kilometraj" : "100.000 km")\n4. Amortizoare - verificare stare\n\nAi observat vreun simptom specific?",
                isUser: false,
                actions: ["Vibratii motor", "Zgomot frane", "Fum esapament"]
            )
        }
        
        if lower.contains("revizie") || lower.contains("service") || lower.contains("cand") {
            let nextService = ((km / 15000) + 1) * 15000
            return AIChatMessage(
                text: "Pentru \(carName) cu motor \(engine):\n\nUrmatoarea revizie: la \(nextService) km (mai ai \(nextService - km) km)\n\nSe va schimba:\n- Ulei motor + filtru ulei\n- Filtru aer\n- Filtru habitaclu\n- Verificare frane si suspensie\n\nCost estimat: 450-700 RON la service independent, 800-1200 RON la dealer.\n\nVrei sa programezi la un mecanic verificat?",
                isUser: false,
                actions: ["Programeaza service", "Vezi costuri detaliate"]
            )
        }
        
        if lower.contains("distributie") || lower.contains("curea") || lower.contains("lant") {
            let hasBelt = engine.lowercased().contains("tdi") || engine.lowercased().contains("dci")
            return AIChatMessage(
                text: "Pentru \(carName) cu motor \(engine):\n\n\(hasBelt ? "Motorul tau are CUREA de distributie" : "Motorul tau are LANT de distributie").\n\n\(hasBelt ? "Interval schimb: 120.000 km sau 5 ani\nCost kit distributie + manopera: 1.500-2.500 RON\nInclude: curea, role, pompa apa, antigel\n\nATENTIE: La \(km) km \(km > 100000 ? "este URGENT sa verifici starea curelei!" : "mai ai timp, dar verifica la urmatoarea revizie.")" : "Lantul de distributie nu necesita schimb programat, dar verifica zgomotele la pornire la rece.")\n\nVrei deviz de la un mecanic verificat?",
                isUser: false,
                actions: ["Cere deviz", "Mecanici aproape"]
            )
        }
        
        if lower.contains("p0") || lower.contains("eroare") || lower.contains("dtc") || lower.contains("cod") {
            // Extract DTC code if present
            let dtcPattern = lower.components(separatedBy: " ").first(where: { $0.hasPrefix("p0") || $0.hasPrefix("p1") || $0.hasPrefix("p2") })
            let dtcCode = dtcPattern?.uppercased() ?? "P0300"
            
            return AIChatMessage(
                text: "Cod eroare \(dtcCode) pe \(carName):\n\n\(decodeDTC(dtcCode))\n\nPentru motorul \(engine), aceasta eroare apare frecvent din cauza:\n- Bujii uzate (interval schimb: 60.000 km)\n- Bobine de inductie defecte\n- Injectoare murdare\n\nGravitate: MEDIE - masina merge dar consumul creste\nCost reparatie: 200-800 RON\n\nRecomand diagnoza OBD2 completa la un mecanic.",
                isUser: false,
                actions: ["Diagnoza completa", "Cost reparatie"]
            )
        }
        
        if lower.contains("vibr") || lower.contains("tremur") {
            return AIChatMessage(
                text: "Vibratii pe \(carName) la \(km) km - cauze posibile:\n\n1. Suporti motor uzati (cel mai frecvent la \(km > 80000 ? "acest kilometraj" : "kilometraj mare"))\n2. Volant bimasa defect (\(engine.contains("TDI") || engine.contains("dCi") ? "FOARTE frecvent pe motoare diesel!" : "mai rar pe benzina"))\n3. Injectoare dezechilibrate\n4. Amortizoare uzate\n\nCand apar vibratiile?\n- La ralanti → suporti motor / volant bimasa\n- La accelerare → cardan / planetare\n- La franare → discuri ovalizate\n- Pe bord → cauciucuri dezechilibrate",
                isUser: false,
                actions: ["La ralanti", "La accelerare", "La franare"]
            )
        }
        
        if lower.contains("consum") || lower.contains("benz") || lower.contains("motorina") {
            return AIChatMessage(
                text: "Consum mare pe \(carName) cu motor \(engine):\n\nConsum normal pentru acest motor: \(engine.contains("TDI") ? "5.5-7.5" : "7-10") L/100km mixt\n\nCauze consum crescut:\n1. Filtru aer murdar (+10-15%)\n2. Presiune anvelope scazuta (+5-8%)\n3. Sonda lambda defecta (+15-25%)\n4. Termostat blocat deschis (+10%)\n5. EGR murdar (diesel)\n6. Stil de condus agresiv\n\nRecomandari:\n- Verifica presiunea anvelopelor (2.2-2.5 bar)\n- Schimba filtrul de aer daca are >30.000 km\n- Diagnoza OBD2 pentru erori ascunse",
                isUser: false,
                actions: ["Verifica senzori", "Sfaturi economisire"]
            )
        }
        
        if lower.contains("pret") || lower.contains("cost") || lower.contains("cat") {
            return AIChatMessage(
                text: "Costuri orientative pentru \(carName):\n\nRevizie completa: 450-700 RON\nPlacute frana (set fata): 250-450 RON\nDiscuri + placute: 600-1000 RON\nAmortizoare (set): 800-1400 RON\nKit distributie: 1500-2500 RON\nSchimb ulei + filtru: 200-350 RON\n\nPreturile variaza in functie de:\n- Piese originale vs aftermarket\n- Service autorizat vs independent\n- Oras (Bucuresti e mai scump)\n\nVrei comparatie autorizat vs independent?",
                isUser: false,
                actions: ["Compara preturi", "Cel mai ieftin aproape"]
            )
        }
        
        // Default response
        return AIChatMessage(
            text: "Inteles! Pentru \(carName) cu \(km) km si motor \(engine), pot sa te ajut cu:\n\n- Diagnosticare probleme\n- Costuri reparatii\n- Programare service\n- Explicare coduri eroare DTC\n- Sfaturi intretinere\n- Verificare stare masina\n\nPovesteste-mi mai exact ce simptom ai observat sau ce te intereseaza!",
            isUser: false,
            actions: ["Probleme comune", "Revizie", "Costuri"]
        )
    }
    
    private func decodeDTC(_ code: String) -> String {
        switch code {
        case "P0300": return "Rateuri multiple cilindri (Multiple Cylinder Misfire)"
        case "P0301": return "Rateu cilindru 1 (Cylinder 1 Misfire)"
        case "P0302": return "Rateu cilindru 2 (Cylinder 2 Misfire)"
        case "P0171": return "Amestec prea sarac Bank 1 (System Too Lean)"
        case "P0172": return "Amestec prea bogat Bank 1 (System Too Rich)"
        case "P0420": return "Eficienta catalizator sub prag Bank 1"
        case "P0401": return "Debit EGR insuficient"
        case "P0100": return "Senzor debit aer (MAF) - circuit defect"
        default: return "Eroare sistem motor - necesita diagnoza detaliata"
        }
    }
}

// MARK: - AI Chat Message Model
struct AIChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp = Date()
    let actions: [String]
    
    var timeFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: timestamp)
    }
}
