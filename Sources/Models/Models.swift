import Foundation

struct Question: Identifiable, Codable {
    let id: Int
    let question: String
    let options: [String]
    let correctAnswer: Int
    let level: Int
}

struct Level: Identifiable {
    let id: Int
    let name: String
    let difficulty: String
    let questionCount: Int
    let isUnlocked: Bool
    let isCompleted: Bool
    let highScore: Int
}

enum GameState {
    case notStarted
    case playing
    case finished
}
