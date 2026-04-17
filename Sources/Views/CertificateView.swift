import SwiftUI

struct CertificateView: View {
    let score: Int
    let level: Int
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            .padding(20)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Sertifika kartı
                    ZStack {
                        // Arka plan
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "fdf6e3"), Color(hex: "f5e6c8")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        // Köşe süslemeleri
                        VStack {
                            HStack {
                                cornerOrnament()
                                Spacer()
                                cornerOrnament().rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            }
                            Spacer()
                            HStack {
                                cornerOrnament().rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                                Spacer()
                                cornerOrnament().rotation3DEffect(.degrees(180), axis: (x: 1, y: 1, z: 0))
                            }
                        }
                        .padding(12)
                        
                        // Dış çerçeve
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "c8a951"), lineWidth: 2)
                            .padding(10)
                        
                        // İç çerçeve
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "c8a951").opacity(0.5), lineWidth: 1)
                            .padding(20)
                        
                        // İçerik
                        VStack(spacing: 16) {
                            // Üst semboller
                            HStack(spacing: 12) {
                                Image(systemName: "moon.stars.fill")
                                    .foregroundColor(Color(hex: "c8a951"))
                                    .font(.system(size: 20))
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(hex: "c8a951"))
                                    .font(.system(size: 14))
                                Image(systemName: "moon.stars.fill")
                                    .foregroundColor(Color(hex: "c8a951"))
                                    .font(.system(size: 20))
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            }
                            .padding(.top, 20)
                            
                            Text("T.C.")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(hex: "8B0000"))
                                .tracking(4)
                            
                            Text("OSMANLI TARİHİ\nARAŞTIRMA ENSTİTÜSÜ")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "5a3e1b"))
                                .tracking(2)
                                .multilineTextAlignment(.center)
                            
                            // Tuğra benzeri süsleme
                            ZStack {
                                Circle()
                                    .stroke(Color(hex: "c8a951"), lineWidth: 1.5)
                                    .frame(width: 80, height: 80)
                                Circle()
                                    .stroke(Color(hex: "c8a951").opacity(0.4), lineWidth: 1)
                                    .frame(width: 70, height: 70)
                                VStack(spacing: 2) {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(Color(hex: "c8a951"))
                                        .font(.system(size: 22))
                                    Text("1299")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color(hex: "8B0000"))
                                }
                            }
                            .padding(.vertical, 4)
                            
                            // Başlık
                            VStack(spacing: 4) {
                                Text("BİLGİ VE BAŞARI")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Color(hex: "8B6914"))
                                    .tracking(3)
                                
                                Text("SERTİFİKASI")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(Color(hex: "8B0000"))
                                    .tracking(4)
                            }
                            
                            // İnce çizgi
                            HStack {
                                Rectangle()
                                    .fill(Color(hex: "c8a951").opacity(0.6))
                                    .frame(height: 1)
                                Image(systemName: "diamond.fill")
                                    .foregroundColor(Color(hex: "c8a951"))
                                    .font(.system(size: 8))
                                Rectangle()
                                    .fill(Color(hex: "c8a951").opacity(0.6))
                                    .frame(height: 1)
                            }
                            .padding(.horizontal, 30)
                            
                            VStack(spacing: 6) {
                                Text("Bu belge")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "5a3e1b").opacity(0.8))
                                
                                Text("Osmanlı İmparatorluğu tarihi alanında")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "5a3e1b").opacity(0.8))
                                
                                Text("gösterilen üstün başarı ve derin bilgi birikimi")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "5a3e1b").opacity(0.8))
                                
                                Text("nedeniyle")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "5a3e1b").opacity(0.8))
                            }
                            .multilineTextAlignment(.center)
                            
                            // Unvan
                            VStack(spacing: 4) {
                                Text("OSMANLI TARİHİ UZMANI")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(Color(hex: "8B0000"))
                                    .tracking(2)
                                
                                Text("ünvanının verildiğini tasdik eder.")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "5a3e1b").opacity(0.8))
                            }
                            .padding(.vertical, 4)
                            
                            // İnce çizgi
                            HStack {
                                Rectangle()
                                    .fill(Color(hex: "c8a951").opacity(0.6))
                                    .frame(height: 1)
                                Image(systemName: "diamond.fill")
                                    .foregroundColor(Color(hex: "c8a951"))
                                    .font(.system(size: 8))
                                Rectangle()
                                    .fill(Color(hex: "c8a951").opacity(0.6))
                                    .frame(height: 1)
                            }
                            .padding(.horizontal, 30)
                            
                            // Puan & Tarih & Mühür
                            HStack(alignment: .bottom) {
                                // Puan
                                VStack(spacing: 3) {
                                    Text("PUAN")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color(hex: "8B6914"))
                                        .tracking(2)
                                    Text("\(score)")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(Color(hex: "8B0000"))
                                    Rectangle()
                                        .fill(Color(hex: "c8a951"))
                                        .frame(height: 1)
                                    Text("Başarı Puanı")
                                        .font(.system(size: 9))
                                        .foregroundColor(Color(hex: "5a3e1b").opacity(0.7))
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Mühür
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "8B0000").opacity(0.08))
                                        .frame(width: 70, height: 70)
                                    Circle()
                                        .stroke(Color(hex: "8B0000").opacity(0.4), lineWidth: 1.5)
                                        .frame(width: 70, height: 70)
                                    Circle()
                                        .stroke(Color(hex: "8B0000").opacity(0.2), lineWidth: 1)
                                        .frame(width: 60, height: 60)
                                    VStack(spacing: 1) {
                                        Text("RESMİ")
                                            .font(.system(size: 7, weight: .bold))
                                            .foregroundColor(Color(hex: "8B0000").opacity(0.7))
                                            .tracking(1)
                                        Text("MÜHÜR")
                                            .font(.system(size: 7, weight: .bold))
                                            .foregroundColor(Color(hex: "8B0000").opacity(0.7))
                                            .tracking(1)
                                    }
                                }
                                
                                // Tarih
                                VStack(spacing: 3) {
                                    Text("TARİH")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color(hex: "8B6914"))
                                        .tracking(2)
                                    Text(formattedDate)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(hex: "5a3e1b"))
                                    Rectangle()
                                        .fill(Color(hex: "c8a951"))
                                        .frame(height: 1)
                                    Text("Tanzim Tarihi")
                                        .font(.system(size: 9))
                                        .foregroundColor(Color(hex: "5a3e1b").opacity(0.7))
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal, 30)
                            .padding(.bottom, 25)
                        }
                        .padding(.horizontal, 15)
                    }
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    
                    // Kapat butonu
                    Button(action: onClose) {
                        Text("Kapat")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
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
    
    @ViewBuilder
    func cornerOrnament() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "star.fill")
                    .foregroundColor(Color(hex: "c8a951"))
                    .font(.system(size: 8))
                Rectangle()
                    .fill(Color(hex: "c8a951"))
                    .frame(width: 20, height: 1)
            }
            Rectangle()
                .fill(Color(hex: "c8a951"))
                .frame(width: 1, height: 20)
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }
}
