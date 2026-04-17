import SwiftUI

struct HomeView: View {
    @StateObject private var adManager = AdManager.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    
    @State private var selectedLevel: Int = 1
    @State private var gameState: GameState = .notStarted
    @State private var currentQuestions: [Question] = []
    @State private var currentQuestionIndex: Int = 0
    @State private var score: Int = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showResult: Bool = false
    @State private var showCertificate: Bool = false
    @State private var showPaywall: Bool = false
    @State private var unlockedLevels: Int = 1
    @State private var completedLevels: Set<Int> = []
    @State private var highScores: [Int: Int] = [:]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if showPaywall {
                    PaywallView(
                        onPurchase: {
                            Task {
                                let success = await subscriptionManager.purchasePremium()
                                if success {
                                    showPaywall = false
                                }
                            }
                        },
                        onRestore: {
                            Task {
                                _ = await subscriptionManager.restorePurchases()
                            }
                        },
                        onClose: {
                            showPaywall = false
                        },
                        isLoading: subscriptionManager.isLoading
                    )
                } else if showCertificate {
                    CertificateView(
                        score: score,
                        level: selectedLevel,
                        onClose: {
                            showCertificate = false
                            gameState = .notStarted
                        }
                    )
                } else if showResult {
                    ResultView(
                        score: score,
                        totalQuestions: currentQuestions.count,
                        level: selectedLevel,
                        isMasterLevel: selectedLevel == 10,
                        isPremium: subscriptionManager.isPremium,
                        onPlayAgain: {
                            restartLevel()
                        },
                        onNextLevel: {
                            if selectedLevel < 10 {
                                selectedLevel += 1
                                unlockedLevels = max(unlockedLevels, selectedLevel)
                            }
                            gameState = .notStarted
                            showResult = false
                        },
                        onHome: {
                            gameState = .notStarted
                            showResult = false
                        },
                        onUnlockPremium: {
                            showPaywall = true
                        }
                    )
                } else if gameState == .playing {
                    QuizView(
                        questions: currentQuestions,
                        currentIndex: $currentQuestionIndex,
                        score: $score,
                        selectedAnswer: $selectedAnswer,
                        level: selectedLevel,
                        showAds: !subscriptionManager.isPremium,
                        onAnswer: { answer in
                            handleAnswer(answer)
                        },
                        onFinish: {
                            finishQuiz()
                        },
                        onQuit: {
                            gameState = .notStarted
                        }
                    )
                } else {
                    levelSelectionView
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    var levelSelectionView: some View {
        VStack(spacing: 20) {
            // Premium Badge
            if subscriptionManager.isPremium {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                    Text("PREMIUM")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(20)
                .padding(.top, 10)
            }
            
            // Title
            Text("OSMANLI")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(Color(hex: "d4af37"))
            
            Text("BİLGİ YARIŞI")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.white)
            
            Text("Tarih Uzmanı Ol")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            // Levels Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    ForEach(1...10, id: \.self) { level in
                        LevelButton(
                            level: level,
                            isUnlocked: level <= unlockedLevels || subscriptionManager.isPremium,
                            isCompleted: completedLevels.contains(level),
                            highScore: highScores[level] ?? 0,
                            isSelected: selectedLevel == level
                        ) {
                            if level <= unlockedLevels || subscriptionManager.isPremium {
                                selectedLevel = level
                            } else if level > 5 {
                                showPaywall = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
            
            // Premium Button (if not premium)
            if !subscriptionManager.isPremium {
                Button(action: { showPaywall = true }) {
                    HStack {
                        Image(systemName: "crown")
                        Text("PREMIUM'A GEÇ")
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.yellow)
                    .frame(width: 200, height: 45)
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow.opacity(0.5), lineWidth: 1)
                    )
                }
                .padding(.top, 10)
            }
            
            // Start Button
            Button(action: startGame) {
                Text("OYUNA BAŞLA")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "1a1a2e"))
                    .frame(width: 250, height: 55)
                    .background(Color(hex: "d4af37"))
                    .cornerRadius(15)
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
    }
    
    func startGame() {
        // Check if trying to play locked levels without premium
        if selectedLevel > 5 && !subscriptionManager.isPremium && selectedLevel > unlockedLevels {
            showPaywall = true
            return
        }
        
        let questionCount = Int.random(in: 15...20)
        currentQuestions = QuestionData.getQuestions(for: selectedLevel, count: questionCount)
        currentQuestionIndex = 0
        score = 0
        selectedAnswer = nil
        gameState = .playing
    }
    
    func handleAnswer(_ answer: Int) {
        if selectedAnswer != nil { return }
        selectedAnswer = answer
        
        if answer == currentQuestions[currentQuestionIndex].correctAnswer {
            score += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            nextQuestion()
        }
    }
    
    func nextQuestion() {
        selectedAnswer = nil
        if currentQuestionIndex < currentQuestions.count - 1 {
            currentQuestionIndex += 1
        } else {
            finishQuiz()
        }
    }
    
    func finishQuiz() {
        gameState = .finished
        showResult = true
        
        let percentage = (score * 100) / currentQuestions.count
        if percentage >= 70 {
            completedLevels.insert(selectedLevel)
            if highScores[selectedLevel] ?? 0 < score {
                highScores[selectedLevel] = score
            }
            if selectedLevel == 10 && percentage >= 70 {
                showCertificate = true
            }
        }
    }
    
    func restartLevel() {
        startGame()
    }
}

struct LevelButton: View {
    let level: Int
    let isUnlocked: Bool
    let isCompleted: Bool
    let highScore: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                ZStack {
                    Circle()
                        .fill(isUnlocked ? (isSelected ? Color(hex: "d4af37") : Color(hex: "2d3a4f")) : Color.gray.opacity(0.3))
                        .frame(width: 55, height: 55)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.green)
                    } else {
                        Text("\(level)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(isUnlocked ? (isSelected ? Color(hex: "1a1a2e") : .white) : .gray)
                    }
                }
                
                if highScore > 0 {
                    Text("\(highScore)")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow)
                }
                
                Text(levelName(for: level))
                    .font(.system(size: 8))
                    .foregroundColor(isUnlocked ? .white : .gray)
                    .lineLimit(1)
            }
        }
        .disabled(!isUnlocked)
    }
    
    func levelName(for level: Int) -> String {
        switch level {
        case 1...3: return "Başlangıç"
        case 4...6: return "Orta"
        case 7...9: return "Uzman"
        case 10: return "MASTER"
        default: return ""
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    HomeView()
}
