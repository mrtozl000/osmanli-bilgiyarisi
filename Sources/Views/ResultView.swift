import SwiftUI

struct ResultView: View {
    let score: Int
    let totalQuestions: Int
    let level: Int
    let isMasterLevel: Bool
    let isPremium: Bool
    let onPlayAgain: () -> Void
    let onNextLevel: () -> Void
    let onHome: () -> Void
    let onUnlockPremium: () -> Void
    
    @StateObject private var adManager = AdManager.shared
    
    // Reklam gösterilecek level'lar
    private let adLevels = [1, 4, 8, 10]
    
    var percentage: Int {
        (score * 100) / totalQuestions
    }
    
    var passed: Bool {
        percentage >= 70
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Result Icon
            ZStack {
                Circle()
                    .fill(passed ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .frame(width: 150, height: 150)
                
                Image(systemName: passed ? "crown.fill" : "xmark")
                    .font(.system(size: 60))
                    .foregroundColor(passed ? .yellow : .red)
            }
            
            // Result Text
            VStack(spacing: 10) {
                Text(passed ? "TEBRİKLER!" : "ÜZGÜNÜM!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(passed ? Color(hex: "d4af37") : .red)
                
                Text(passed ? "Seviyeyi Geçtin" : "Seviyeyi Geçemedin")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Score Card
            VStack(spacing: 15) {
                HStack {
                    Text("Seviye \(level)")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text(levelName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "d4af37"))
                }
                
                HStack {
                    Text("Doğru Cevap")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text("\(score) / \(totalQuestions)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.green)
                }
                
                HStack {
                    Text("Başarı Oranı")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text("%\(percentage)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(passed ? .green : .red)
                }
                
                if !isPremium {
                    HStack {
                        Text("Durum")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("Reklamlı")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(25)
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
            .padding(.horizontal, 30)
            
            // Message for Master Level
            if isMasterLevel && passed {
                VStack(spacing: 10) {
                    Image(systemName: "certificate.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                    
                    Text("OSMANLI TARİHİ UZMANI!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.yellow)
                    
                    Text("Sertifikanı görüntülemek için devam et")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
            }
            
            // Premium upgrade prompt
            if !isPremium && (!passed || level > 5) {
                Button(action: onUnlockPremium) {
                    HStack {
                        Image(systemName: "crown.fill")
                        Text("PREMIUM'A GEÇ")
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.yellow)
                    .cornerRadius(15)
                }
                .padding(.horizontal, 30)
            }
            
            // Action Buttons
            VStack(spacing: 15) {
                if passed && level < 10 {
                    Button(action: onNextLevel) {
                        HStack {
                            Text("SONRAKİ SEVİYE")
                            Image(systemName: "arrow.right")
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "1a1a2e"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "d4af37"))
                        .cornerRadius(15)
                    }
                }
                
                Button(action: onPlayAgain) {
                    Text("TEKRAR OYNA")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                }
                
                Button(action: onHome) {
                    Text("ANA MENÜ")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 5)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .onAppear {
            // Premium değilse ve reklam gösterilecek level'lardan biriyse reklam göster
            guard !isPremium, adLevels.contains(level) else { return }
            
            // Kısa bir gecikme ile göster (ekran tam yerleşsin)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showInterstitialAd()
            }
        }
    }
    
    func showInterstitialAd() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        adManager.showInterstitial(from: rootVC)
    }
    
    var levelName: String {
        switch level {
        case 1...3: return "Başlangıç"
        case 4...6: return "Orta"
        case 7...9: return "Uzman"
        case 10: return "MASTER"
        default: return ""
        }
    }
}
