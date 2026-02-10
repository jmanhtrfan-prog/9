import SwiftUI
import Combine

// MARK: - ViewModel (Improved with Model)
class CoffeeGameViewModel: ObservableObject {
    // MARK: - Model
    @Published private(set) var gameModel = CoffeeGameModel()
    
    // MARK: - UI State (Published properties for View)
    @Published var isPouringCoffee = false
    @Published var cupRotation: Double = 0
    @Published var cupScale: CGFloat = 1.0
    @Published var coffeeSpillOpacity: Double = 0
    @Published var showSuccessPopup = false
    
    // MARK: - Computed Properties
    var score: Int {
        gameModel.score
    }
    
    var attempts: Int {
        gameModel.attempts
    }
    
    var successRate: Double {
        gameModel.successRate
    }
    
    // MARK: - Public Methods
    
    /// Handle game action
    func handleAction(_ action: GameAction) {
        switch action {
        case .tapDallah:
            handleDallahTap()
        case .tapCup:
            handleCupTap()
        case .reset:
            resetGame()
        }
    }
    
    /// Reset the game
    func resetGame() {
        gameModel.reset()
        resetUIState()
    }
    
    // MARK: - Private Methods
    
    /// Handle when user taps the dallah (incorrect action)
    func handleDallahTap() {
        // Coffee pours out - wrong action!
        isPouringCoffee = true
        coffeeSpillOpacity = 1
        
        // Provide haptic feedback
        triggerHapticFeedback(style: .medium)
        
        // Reset animations after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isPouringCoffee = false
            
            // Fade out spill
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.coffeeSpillOpacity = 0
            }
        }
    }
    
    /// Handle when user taps the cup (correct action)
    func handleCupTap() {
        gameModel.attempts += 1
        gameModel.score += 1
        
        // Trigger success haptic
        triggerSuccessHaptic()
        
        // Start shake animation - polite refusal!
        shakeCup()
        
        // Show success popup after shake animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.showSuccessPopup = true
        }
    }
    
    /// Reset UI state
    private func resetUIState() {
        isPouringCoffee = false
        cupRotation = 0
        cupScale = 1.0
        coffeeSpillOpacity = 0
        showSuccessPopup = false
    }
    
    /// Animate the cup shaking with rotation and scale
    private func shakeCup() {
        let shakeDuration: Double = 0.08
        let rotationAngles: [Double] = [-8, 8, -6, 6, -4, 4, -2, 2, 0]
        
        for (index, angle) in rotationAngles.enumerated() {
            let delay = Double(index) * shakeDuration
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.cupRotation = angle
                
                // Add scale bounce effect
                if index % 2 == 0 {
                    self.cupScale = 1.1
                } else {
                    self.cupScale = 0.95
                }
            }
        }
        
        // Final reset
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(rotationAngles.count) * shakeDuration) {
            self.cupRotation = 0
            self.cupScale = 1.0
        }
    }
    
    /// Trigger haptic feedback for wrong action
    private func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impact = UIImpactFeedbackGenerator(style: style)
        impact.impactOccurred()
    }
    
    /// Trigger success haptic feedback
    private func triggerSuccessHaptic() {
        let success = UINotificationFeedbackGenerator()
        success.notificationOccurred(.success)
    }
}


 
