import SwiftUI
import AVFoundation

// MARK: - Live Camera Preview using AVCaptureSession
// Used by AR Live view and Scanner for real camera feed
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        uiView.previewLayer.session = session
    }
}

class CameraPreviewUIView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

// MARK: - Camera Session Manager
// Manages AVCaptureSession for live camera feed with optional barcode detection
class CameraSessionManager: NSObject, ObservableObject {
    @Published var isRunning = false
    @Published var permissionGranted = false
    @Published var errorMessage: String?
    @Published var detectedBarcodes: [String] = []
    
    let session = AVCaptureSession()
    private var metadataOutput: AVCaptureMetadataOutput?
    var onBarcodeDetected: ((String) -> Void)?
    
    override init() {
        super.init()
        checkPermission()
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async { [weak self] in
                self?.permissionGranted = true
            }
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.permissionGranted = granted
                    if granted {
                        self?.setupSession()
                    } else {
                        self?.errorMessage = "Camera nu este autorizata. Activati din Setari > Confidentialitate > Camera."
                    }
                }
            }
        case .denied, .restricted:
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Camera nu este autorizata. Activati din Setari > Confidentialitate > Camera."
            }
        @unknown default:
            break
        }
    }
    
    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .high
        
        // Add video input
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Nu se poate accesa camera."
            }
            session.commitConfiguration()
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        // Add metadata output for barcode detection
        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [
                .qr, .ean8, .ean13, .code128, .code39, .code93,
                .upce, .pdf417, .dataMatrix, .interleaved2of5
            ]
            self.metadataOutput = metadataOutput
        }
        
        session.commitConfiguration()
    }
    
    func startSession() {
        guard permissionGranted, !session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
            DispatchQueue.main.async {
                self?.isRunning = true
            }
        }
    }
    
    func stopSession() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
            DispatchQueue.main.async {
                self?.isRunning = false
            }
        }
    }
    
    func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = device.torchMode == .on ? .off : .on
        device.unlockForConfiguration()
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension CameraSessionManager: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        for metadata in metadataObjects {
            guard let readable = metadata as? AVMetadataMachineReadableCodeObject,
                  let code = readable.stringValue,
                  !code.isEmpty else { continue }
            
            if !detectedBarcodes.contains(code) {
                detectedBarcodes.append(code)
                onBarcodeDetected?(code)
                
                // Haptic feedback
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
    }
}
