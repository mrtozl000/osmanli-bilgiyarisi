import SwiftUI

struct PaywallView: View {
    let onPurchase: () -> Void
    let onRestore: () -> Void
    let onClose: () -> Void
    let isLoading: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            .padding(20)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Crown Icon
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.yellow)
                    }
                    
                    // Title
                    Text("PREMIUM'A GEÇ")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.yellow)
                    
                    Text("Tüm seviyeleri aç ve reklamsız oyna!")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    // Features
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(icon: "crown.fill", text: "Tüm 10 seviyeye erişim")
                        FeatureRow(icon: "xmark.circle.fill", text: "Reklamsız oyun deneyimi")
                        FeatureRow(icon: "certificate.fill", text: "Sertifika her zaman erişilebilir")
                        FeatureRow(icon: "star.fill", text: "Özel rozetler ve başarımlar")
                    }
                    .padding(25)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    
                    // Price Button
                    Button(action: onPurchase) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            } else {
                                Text("₺19.99")
                                    .font(.system(size: 22, weight: .bold))
                            }
                            Text("Satın Al")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.yellow)
                        .cornerRadius(15)
                    }
                    .disabled(isLoading)
                    .padding(.horizontal, 20)
                    
                    // Restore Button
                    Button(action: onRestore) {
                        Text("Satın alımları geri yükle")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.yellow)
                .frame(width: 30)
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}
