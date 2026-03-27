import Foundation
import UIKit
import SwiftUI
import Combine

// MARK: - Night Mode Manager
class NightModeManager: ObservableObject {
    @Published var isNightMode: Bool = false
    @Published var isAutoMode: Bool = true
    @Published var brightness: CGFloat = 0.5
    
    private var brightnessTimer: Timer?
    
    init() {
        updateBrightness()
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        brightnessTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateBrightness()
        }
    }
    
    func stopMonitoring() {
        brightnessTimer?.invalidate()
        brightnessTimer = nil
    }
    
    func updateBrightness() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.brightness = UIScreen.main.brightness
            
            if self.isAutoMode {
                // Auto night mode based on screen brightness and time
                let hour = Calendar.current.component(.hour, from: Date())
                let isNightTime = hour >= 20 || hour < 7
                let isLowBrightness = self.brightness < 0.3
                
                let shouldBeNight = isNightTime || isLowBrightness
                if self.isNightMode != shouldBeNight {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isNightMode = shouldBeNight
                    }
                }
            }
        }
    }
    
    func toggleNightMode() {
        isAutoMode = false
        withAnimation(.easeInOut(duration: 0.3)) {
            isNightMode.toggle()
        }
    }
    
    func enableAutoMode() {
        isAutoMode = true
        updateBrightness()
    }
    
    // Night mode theme adjustments
    var backgroundOpacity: Double {
        isNightMode ? 0.7 : 1.0
    }
    
    var textBrightness: Double {
        isNightMode ? 0.8 : 1.0
    }
    
    var accentBrightness: Double {
        isNightMode ? 0.6 : 1.0
    }
}
