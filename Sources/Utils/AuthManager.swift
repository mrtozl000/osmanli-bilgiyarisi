import Foundation
import AuthenticationServices
import CryptoKit
import SwiftUI

/// Owns authentication state for the app.
/// - Generates a per-sign-in nonce (raw + SHA256 hash)
/// - Exchanges Apple's identityToken with our backend
/// - Stores the backend session token in Keychain
/// - Exposes current user / isAuthenticated as @Published state
@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published private(set) var userId: String?
    @Published private(set) var email: String?
    @Published private(set) var name: String?
    @Published private(set) var isAuthenticated: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    /// Raw nonce for the current sign-in attempt. Stored briefly so we can send it to
    /// the backend after Apple returns the signed token (the backend verifies that
    /// SHA256(rawNonce) matches the nonce claim embedded in Apple's JWT).
    private var currentRawNonce: String?

    private init() {
        // If we have a session token saved, optimistically mark as authenticated and
        // refresh /me in the background.
        if KeychainHelper.read("sessionToken") != nil {
            self.isAuthenticated = true
            Task { await self.refreshProfile() }
        }
    }

    // MARK: - Nonce

    /// Called from the SignInWithAppleButton request closure. Returns the SHA256
    /// hash of a fresh random nonce; stashes the raw nonce for later.
    func prepareNonce() -> String {
        let raw = randomNonceString()
        currentRawNonce = raw
        return sha256(raw)
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remaining = length
        while remaining > 0 {
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess { continue }
            if random < charset.count {
                result.append(charset[Int(random) % charset.count])
                remaining -= 1
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let hashed = SHA256.hash(data: Data(input.utf8))
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Sign in

    /// Called after ASAuthorizationController returns a successful credential.
    func handleAuthorization(_ authorization: ASAuthorization) async {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8) else {
            errorMessage = "Apple'dan geçerli bir kimlik doğrulama alınamadı."
            return
        }
        guard let rawNonce = currentRawNonce else {
            errorMessage = "Güvenlik doğrulaması başarısız oldu. Lütfen tekrar deneyin."
            return
        }

        isLoading = true
        defer { isLoading = false }

        // Apple only sends name on the FIRST authorization for this app.
        let fullName: String? = [credential.fullName?.givenName, credential.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
            .nilIfEmpty

        let request = APIClient.AppleSignInRequest(
            idToken: idToken,
            nonce: rawNonce,
            fullName: fullName,
            email: credential.email
        )

        do {
            let response = try await APIClient.shared.signInWithApple(request)
            KeychainHelper.save(response.sessionToken, for: "sessionToken")
            self.userId = response.userId
            self.isAuthenticated = true
            await refreshProfile()
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Giriş başarısız oldu."
        }

        currentRawNonce = nil
    }

    func handleAuthorizationError(_ error: Error) {
        errorMessage = "Apple ile giriş yapılamadı: \(error.localizedDescription)"
    }

    func refreshProfile() async {
        do {
            let me = try await APIClient.shared.me()
            self.userId = me.userId
            self.email = me.email
            self.name = me.name
        } catch APIClient.APIError.unauthorized {
            // Token was invalidated server-side — force re-auth
            signOut()
        } catch {
            // Network hiccup — keep stale state, user can retry
            print("refreshProfile failed:", error)
        }
    }

    #if DEBUG
    func testSignIn() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response: APIClient.AppleSignInResponse = try await APIClient.shared.testSignIn()
            KeychainHelper.save(response.sessionToken, for: "sessionToken")
            self.userId = response.userId
            self.isAuthenticated = true
            await refreshProfile()
        } catch {
            errorMessage = "Test girişi başarısız: \(error.localizedDescription)"
        }
    }
    #endif

    func signOut() {
        KeychainHelper.delete("sessionToken")
        userId = nil
        email = nil
        name = nil
        isAuthenticated = false
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
