import SwiftUI

struct QuizView: View {
    let questions: [Question]
    @Binding var currentIndex: Int
    @Binding var score: Int
    @Binding var selectedAnswer: Int?
    let level: Int
    let showAds: Bool
    let onAnswer: (Int) -> Void
    let onFinish: () -> Void
    let onQuit: () -> Void
    
    @StateObject private var adManager = AdManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onQuit) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                VStack {
                    Text("SEVİYE \(level)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(hex: "d4af37"))
                    
                    Text("\(currentIndex + 1) / \(questions.count)")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack {
                    Text("PUAN")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("\(score)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.green)
                }
                .padding(10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(Color(hex: "d4af37"))
                        .frame(width: geometry.size.width * CGFloat(currentIndex + 1) / CGFloat(questions.count), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 20)
            .padding(.top, 15)
            
            // Question
            ScrollView {
                VStack(spacing: 25) {
                    Text(questions[currentIndex].question)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                    
                    // Options
                    ForEach(0..<questions[currentIndex].options.count, id: \.self) { index in
                        OptionButton(
                            text: questions[currentIndex].options[index],
                            index: index,
                            isSelected: selectedAnswer == index,
                            isCorrect: index == questions[currentIndex].correctAnswer,
                            isRevealed: selectedAnswer != nil
                        ) {
                            onAnswer(index)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            
            // Question counter dots
            HStack(spacing: 5) {
                ForEach(0..<min(questions.count, 15), id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color(hex: "d4af37") : (index < currentIndex ? Color.green : Color.white.opacity(0.3)))
                        .frame(width: 8, height: 8)
                }
                if questions.count > 15 {
                    Text("+")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(.bottom, 20)
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        // Her currentIndex değişiminde sayacı artır ve reklam kontrolü yap
        .onChange(of: currentIndex) { _ in
            guard showAds else { return }
            adManager.recordQuestionAnswered()
            if adManager.shouldShowAd() {
                showInterstitialAd()
            }
        }
    }
    
    func showInterstitialAd() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        adManager.showInterstitial(from: rootVC) {
            // Reklam kapandıktan sonra yapılacak işlem (gerekirse)
        }
    }
}

struct OptionButton: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let isRevealed: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if isRevealed {
            if isCorrect {
                return .green.opacity(0.8)
            } else if isSelected {
                return .red.opacity(0.8)
            }
        }
        if isSelected {
            return Color(hex: "d4af37").opacity(0.8)
        }
        return Color.white.opacity(0.1)
    }
    
    var borderColor: Color {
        if isRevealed {
            if isCorrect {
                return .green
            } else if isSelected {
                return .red
            }
        }
        if isSelected {
            return Color(hex: "d4af37")
        }
        return .white.opacity(0.3)
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(optionLetter(index))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isSelected || (isRevealed && isCorrect) ? .white : Color(hex: "d4af37"))
                
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isRevealed && isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                } else if isRevealed && isSelected && !isCorrect {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding(18)
            .background(backgroundColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .disabled(isRevealed)
    }
    
    func optionLetter(_ index: Int) -> String {
        switch index {
        case 0: return "A"
        case 1: return "B"
        case 2: return "C"
        case 3: return "D"
        default: return ""
        }
    }
}
