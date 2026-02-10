import Foundation
struct CoffeeGameModel {
    var score: Int
    var attempts: Int
    var isGameActive: Bool
    
    init(score: Int = 0, attempts: Int = 0, isGameActive: Bool = true) {
        self.score = score
        self.attempts = attempts
        self.isGameActive = isGameActive
    }
    
    /// Calculate success rate
    var successRate: Double {
        guard attempts > 0 else { return 0.0 }
        return Double(score) / Double(attempts) * 100
    }
    
    /// Check if player has perfect score
    var isPerfect: Bool {
        return attempts > 0 && score == attempts
    }
    
    /// Reset game state
    mutating func reset() {
        score = 0
        attempts = 0
        isGameActive = true
    }
}

// MARK: - Game Action Enum
enum GameAction {
    case tapDallah // Wrong action
    case tapCup    // Correct action
    case reset     // Reset game
}

// MARK: - Feedback Message
enum FeedbackMessage {
    case wrong
    case correct
    case none
    
    var text: String {
        switch self {
        case .wrong:
            return "اضغط على الفنجان، مو الدلة!"
        case .correct:
            return "أحسنت! 👏"
        case .none:
            return ""
        }
    }
}

