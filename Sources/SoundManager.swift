import SwiftUI
import AudioToolbox
import UIKit

class SoundManager {
    static let shared = SoundManager()
    
    private init() {}
    
    var isSoundEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: "isSoundEnabled") == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: "isSoundEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isSoundEnabled")
        }
    }
    
    // Play light click sound on tap
    func playTapSound() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1104) // Standard iOS camera/tap sound
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    // Play add-to-cart sound
    func playAddToCartSound() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1057) // Tink sound
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // Play order success sound
    func playOrderSuccessSound() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1025) // Modern notification / chime
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
