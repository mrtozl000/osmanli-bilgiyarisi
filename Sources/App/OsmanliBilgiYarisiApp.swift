import SwiftUI
import RevenueCat

@main
struct OsmanliBilgiYarisiApp: App {
    @StateObject private var auth = AuthManager.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared

    init() {
        // Configure RevenueCat once at app launch, before any purchase code runs.
        // The API key comes from Info.plist so it doesn't land in source control.
        // Set REVENUECAT_API_KEY in project.yml / Info.plist for production builds.
        let apiKey = (Bundle.main.object(forInfoDictionaryKey: "REVENUECAT_API_KEY") as? String) ?? ""
        if !apiKey.isEmpty {
            Purchases.logLevel = .warn
            Purchases.configure(withAPIKey: apiKey)
        } else {
            print("⚠️ REVENUECAT_API_KEY is missing from Info.plist — RevenueCat is disabled.")
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if auth.isAuthenticated {
                    HomeView()
                        .task(id: auth.userId) {
                            // Link RevenueCat to the backend user ID so entitlements
                            // follow the user across devices.
                            if let uid = auth.userId {
                                await subscriptionManager.logIn(userId: uid)
                            }
                        }
                } else {
                    AuthView()
                }
            }
            .environmentObject(auth)
            .environmentObject(subscriptionManager)
        }
    }
}
