import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Logo / crest
                ZStack {
                    Circle()
                        .fill(Color.yellow.opacity(0.15))
                        .frame(width: 140, height: 140)
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 56))
                        .foregroundColor(Color(hex: "c8a951"))
                }

                VStack(spacing: 10) {
                    Text("Osmanlı Bilgi Yarışı")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)

                    Text("Devam etmek için giriş yapın")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.75))
                }

                Spacer()

                // Apple sign in
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = auth.prepareNonce()
                } onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        Task { await auth.handleAuthorization(authorization) }
                    case .failure(let error):
                        auth.handleAuthorizationError(error)
                    }
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 52)
                .cornerRadius(12)
                .padding(.horizontal, 32)

                if auth.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.top, 8)
                }

                if let message = auth.errorMessage {
                    Text(message)
                        .font(.system(size: 13))
                        .foregroundColor(.red.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Text("Devam ederek Kullanım Koşulları ve Gizlilik Politikası'nı kabul etmiş olursunuz.")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 24)
            }
        }
    }
}
