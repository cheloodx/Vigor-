import SwiftUI
import AVFoundation

// MARK: - AR Repair Guide View
// Step-by-step AR-guided repair instructions with REAL camera feed — LIVE
struct ARRepairGuideView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    @StateObject private var cameraManager = CameraSessionManager()
    @State private var selectedRepair: RepairGuide?
    @State private var currentStep = 0
    @State private var isARActive = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if let repair = selectedRepair {
                        arPreview(repair)
                        stepsList(repair)
                        toolsRequired(repair)
                    } else {
                        repairCatalog
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
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .foregroundColor(Theme.gaugeGreen)
                        Text("Ghid Reparatie AR")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                if selectedRepair != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { withAnimation { selectedRepair = nil; currentStep = 0 } }) {
                            Image(systemName: "chevron.left").foregroundColor(Theme.primary)
                        }
                    }
                }
            }
        }
    }
    
    private func arPreview(_ repair: RepairGuide) -> some View {
        ZStack {
            if isARActive && cameraManager.permissionGranted {
                // REAL camera feed with AR overlays
                CameraPreviewView(session: cameraManager.session)
                    .frame(height: 250)
                    .cornerRadius(14)
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [Color(red: 0.04, green: 0.07, blue: 0.11), Color(red: 0.07, green: 0.10, blue: 0.16)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 250)
            }
            
            VStack {
                // Live badge
                if isARActive {
                    HStack {
                        HStack(spacing: 4) {
                            Circle().fill(Color.red).frame(width: 8, height: 8)
                            Text("AR LIVE").font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                        }
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.black.opacity(0.7)).cornerRadius(6)
                        Spacer()
                        Button(action: { cameraManager.toggleTorch() }) {
                            Image(systemName: "flashlight.on.fill").font(.system(size: 12))
                                .foregroundColor(.white).padding(6)
                                .background(Color.black.opacity(0.5)).cornerRadius(6)
                        }
                    }
                    .padding(10)
                }
                
                Spacer()
                
                // AR overlay on camera
                ZStack {
                    if !isARActive {
                        Image(systemName: repair.steps[min(currentStep, repair.steps.count - 1)].icon)
                            .font(.system(size: 50))
                            .foregroundColor(Theme.primary.opacity(0.3))
                    }
                    
                    if isARActive {
                        // AR detection markers overlaid on camera
                        Circle()
                            .stroke(Theme.gaugeGreen, lineWidth: 2)
                            .frame(width: 40, height: 40)
                            .offset(x: 20, y: -15)
                        
                        // Component label
                        Text(repair.steps[min(currentStep, repair.steps.count - 1)].title)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Theme.gaugeGreen.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .offset(x: 40, y: 20)
                    }
                }
                
                Spacer()
                
                // Controls
                HStack(spacing: 8) {
                    Button(action: { toggleAR() }) {
                        HStack(spacing: 4) {
                            Image(systemName: isARActive ? "camera.fill" : "camera")
                                .font(.system(size: 12))
                            Text(isARActive ? "AR LIVE" : "Porneste AR")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(isARActive ? Theme.gaugeGreen : Theme.primary)
                        .foregroundColor(.white).cornerRadius(8)
                    }
                    
                    Text("Pas \(currentStep + 1)/\(repair.steps.count)")
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white).cornerRadius(6)
                    
                    Spacer()
                    
                    Text(repair.title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.black.opacity(0.5)).cornerRadius(6)
                }
                .padding(10)
            }
        }
        .frame(height: 250)
        .cornerRadius(14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(isARActive ? Theme.gaugeGreen.opacity(0.5) : Theme.primary.opacity(0.2), lineWidth: isARActive ? 2 : 1))
    }
    
    private func toggleAR() {
        withAnimation {
            isARActive.toggle()
            if isARActive {
                cameraManager.startSession()
            } else {
                cameraManager.stopSession()
            }
        }
    }
    
    private func stepsList(_ repair: RepairGuide) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("PASI REPARATIE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Theme.textMuted).tracking(1.2)
                Spacer()
                Text("Dificultate: \(repair.difficulty)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(repair.difficulty == "Usor" ? Theme.gaugeGreen : repair.difficulty == "Mediu" ? Theme.gaugeYellow : Theme.gaugeRed)
            }
            
            ForEach(Array(repair.steps.enumerated()), id: \.offset) { index, step in
                Button(action: { withAnimation { currentStep = index } }) {
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(index == currentStep ? Theme.primary : index < currentStep ? Theme.gaugeGreen : Theme.surfaceBackground)
                                .frame(width: 30, height: 30)
                            if index < currentStep {
                                Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                            } else {
                                Text("\(index + 1)").font(.system(size: 12, weight: .bold))
                                    .foregroundColor(index == currentStep ? .white : Theme.textMuted)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(step.title)
                                .font(.system(size: 13, weight: index == currentStep ? .bold : .regular))
                                .foregroundColor(index == currentStep ? Theme.textPrimary : Theme.textSecondary)
                            Text(step.description)
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                                .lineLimit(index == currentStep ? nil : 2)
                            
                            if index == currentStep {
                                HStack(spacing: 8) {
                                    Image(systemName: step.icon).font(.system(size: 10)).foregroundColor(Theme.primary)
                                    Text("Timp: \(step.duration)").font(.system(size: 10)).foregroundColor(Theme.textMuted)
                                    if !step.warning.isEmpty {
                                        HStack(spacing: 3) {
                                            Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 9)).foregroundColor(Theme.gaugeYellow)
                                            Text(step.warning).font(.system(size: 10)).foregroundColor(Theme.gaugeYellow)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(10)
                    .background(index == currentStep ? Theme.primary.opacity(0.05) : Color.clear)
                    .cornerRadius(8)
                }
            }
            
            // Navigation buttons
            HStack(spacing: 12) {
                if currentStep > 0 {
                    Button(action: { withAnimation { currentStep -= 1 } }) {
                        HStack { Image(systemName: "chevron.left"); Text("Inapoi") }
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Theme.surfaceBackground).foregroundColor(Theme.textSecondary).cornerRadius(8)
                    }
                }
                Spacer()
                if currentStep < repair.steps.count - 1 {
                    Button(action: { withAnimation { currentStep += 1 } }) {
                        HStack { Text("Urmatorul"); Image(systemName: "chevron.right") }
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(Theme.primary).foregroundColor(.white).cornerRadius(8)
                    }
                } else {
                    Text("Reparatie completa!").font(.system(size: 12, weight: .bold)).foregroundColor(Theme.gaugeGreen)
                }
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private func toolsRequired(_ repair: RepairGuide) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SCULE NECESARE").font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1.2)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                ForEach(repair.tools, id: \.self) { tool in
                    HStack(spacing: 4) {
                        Image(systemName: "wrench.fill").font(.system(size: 9)).foregroundColor(Theme.primary)
                        Text(tool).font(.system(size: 11)).foregroundColor(Theme.textSecondary)
                        Spacer()
                    }
                    .padding(6).background(Theme.surfaceBackground).cornerRadius(4)
                }
            }
        }
        .padding(14).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
    }
    
    private var repairCatalog: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("GHIDURI REPARATII DISPONIBILE")
                .font(.system(size: 10, weight: .bold)).foregroundColor(Theme.textMuted).tracking(1.2)
            
            ForEach(RepairGuide.catalog) { guide in
                Button(action: { withAnimation { selectedRepair = guide } }) {
                    HStack(spacing: 12) {
                        Image(systemName: guide.icon).font(.system(size: 20))
                            .foregroundColor(Theme.primary).frame(width: 40, height: 40)
                            .background(Theme.primary.opacity(0.15)).cornerRadius(10)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(guide.title).font(.system(size: 14, weight: .bold)).foregroundColor(Theme.textPrimary)
                            Text("\(guide.steps.count) pasi | \(guide.totalDuration) | \(guide.difficulty)")
                                .font(.system(size: 11)).foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(Theme.textMuted)
                    }
                    .padding(12).background(Theme.cardBackground).cornerRadius(Theme.cornerRadius)
                }
            }
        }
    }
}

struct RepairGuide: Identifiable {
    let id = UUID(); let title: String; let icon: String; let difficulty: String
    let totalDuration: String; let steps: [RepairStep]; let tools: [String]
    
    struct RepairStep {
        let title: String; let description: String; let icon: String; let duration: String; let warning: String
    }
    
    static var catalog: [RepairGuide] {
        [
            RepairGuide(title: "Schimb Placute Frana", icon: "circle.circle", difficulty: "Mediu", totalDuration: "45 min",
                steps: [
                    RepairStep(title: "Ridica masina", description: "Foloseste cricul pentru a ridica roata. Asigura-te ca masina e pe teren plan si frana de mana e trasa.", icon: "arrow.up", duration: "5 min", warning: "Masina trebuie pe teren plan!"),
                    RepairStep(title: "Scoate roata", description: "Deschide prezoanele si scoate roata. Pune-o la o parte in siguranta.", icon: "circle", duration: "3 min", warning: ""),
                    RepairStep(title: "Scoate etrier", description: "Deschide cele 2 suruburi ale etrierului (cheie 13mm). Atarna etrier de arc cu o sarma.", icon: "wrench.fill", duration: "5 min", warning: "Nu lasa etrier sa atarne de furtun!"),
                    RepairStep(title: "Scoate placutele vechi", description: "Scoate placutele uzate din suportul etrierului. Verifica grosimea discului.", icon: "minus.circle", duration: "2 min", warning: ""),
                    RepairStep(title: "Impinge pistonul", description: "Foloseste un cleste special sau un C-clamp pentru a impinge pistonul etrierului inapoi.", icon: "arrow.left", duration: "5 min", warning: "Deschide capacul vasului lichid frana inainte!"),
                    RepairStep(title: "Monteaza placute noi", description: "Pune placutele noi in suport. Verifica sa fie orientate corect cu indicatorul de uzura in sus.", icon: "plus.circle", duration: "3 min", warning: ""),
                    RepairStep(title: "Remonteaza etrier", description: "Pune etrier la loc si strange suruburile la cuplul specificat (35 Nm).", icon: "wrench.fill", duration: "5 min", warning: ""),
                    RepairStep(title: "Test final", description: "Monteaza roata, coboara masina. Apasa de cateva ori pedala de frana inainte de a porni.", icon: "checkmark.circle", duration: "5 min", warning: "Apasa frana de 5-6 ori inainte de a conduce!"),
                ],
                tools: ["Cric + suport", "Cheie roti", "Cheie 13mm", "C-clamp / cleste piston", "Sarma sustinere", "Manusi protectie"]
            ),
            RepairGuide(title: "Schimb Filtru Ulei", icon: "drop.fill", difficulty: "Usor", totalDuration: "30 min",
                steps: [
                    RepairStep(title: "Incalzeste motorul", description: "Porneste motorul 2-3 minute ca uleiul sa devina fluid.", icon: "thermometer.high", duration: "3 min", warning: ""),
                    RepairStep(title: "Ridica masina", description: "Ridica masina pe rampa sau cric pentru acces la baia de ulei.", icon: "arrow.up", duration: "3 min", warning: ""),
                    RepairStep(title: "Drenaj ulei", description: "Pune un vas sub baia de ulei. Deschide surubul de drenaj si lasa uleiul sa curga complet.", icon: "drop.fill", duration: "10 min", warning: "Uleiul poate fi fierbinte!"),
                    RepairStep(title: "Scoate filtrul vechi", description: "Foloseste cheia de filtru pentru a desuruba filtrul de ulei vechi.", icon: "minus.circle", duration: "2 min", warning: ""),
                    RepairStep(title: "Monteaza filtru nou", description: "Unge garnitura noului filtru cu ulei proaspat. Insurubeaza manual pana face contact, apoi strangere 3/4 tura.", icon: "plus.circle", duration: "3 min", warning: "Nu strange cu cheia!"),
                    RepairStep(title: "Adauga ulei nou", description: "Pune surubul de drenaj la loc. Adauga cantitatea corecta de ulei proaspat prin capacul de umplere.", icon: "drop.fill", duration: "5 min", warning: ""),
                    RepairStep(title: "Verificare nivel", description: "Porneste motorul 1 minut, opreste, asteapta 3 minute, verifica nivel cu joja.", icon: "checkmark.circle", duration: "5 min", warning: "Nivelul trebuie intre MIN si MAX!"),
                ],
                tools: ["Cric sau rampa", "Cheie filtru ulei", "Cheie surub drenaj", "Vas colectare ulei", "Palnie", "Manusi"]
            ),
            RepairGuide(title: "Schimb Baterie", icon: "battery.100.bolt", difficulty: "Usor", totalDuration: "15 min",
                steps: [
                    RepairStep(title: "Opreste motorul", description: "Opreste motorul si scoate cheia din contact. Asteapta 5 minute.", icon: "power", duration: "1 min", warning: ""),
                    RepairStep(title: "Deconecteaza minus", description: "Deconecteaza mai intai borna NEGATIVA (-). Izoleaza cablul.", icon: "minus.circle", duration: "2 min", warning: "INTOTDEAUNA minus primul!"),
                    RepairStep(title: "Deconecteaza plus", description: "Deconecteaza borna POZITIVA (+).", icon: "plus.circle", duration: "2 min", warning: ""),
                    RepairStep(title: "Scoate bateria", description: "Desfaceti clema de fixare si scoateti bateria veche.", icon: "arrow.up", duration: "3 min", warning: "Bateria e grea (15-20 kg)!"),
                    RepairStep(title: "Monteaza bateria noua", description: "Pune bateria noua, fixeaza clema. Conecteaza PLUS (+) primul, apoi MINUS (-).", icon: "arrow.down", duration: "5 min", warning: "PLUS primul la montare!"),
                    RepairStep(title: "Verificare", description: "Porneste motorul, verifica lumini si accesorii.", icon: "checkmark.circle", duration: "2 min", warning: ""),
                ],
                tools: ["Cheie 10mm", "Cheie 13mm", "Manusi protectie", "Spray contact"]
            ),
        ]
    }
}
