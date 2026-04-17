import Foundation
import RevenueCat

/// Subscription state, backed by RevenueCat.
///
/// RevenueCat is the source of truth. Each purchase / restore emits a CustomerInfo
/// update; we listen to that stream and flip `isPremium` based on whether our
/// configured entitlement (default: "premium") is active.
///
/// The RevenueCat SDK is configured from `OsmanliBilgiYarisiApp` on launch.
/// When the user signs in with Apple, call `logIn(userId:)` to link the
/// RevenueCat anonymous ID to our backend user ID so subscriptions follow the user
/// across devices.
@MainActor
final class SubscriptionManager: NSObject, ObservableObject {
    static let shared = SubscriptionManager()

    /// Name of the entitlement to check. Must match what you configure in the
    /// RevenueCat dashboard (Entitlements → identifier). We use "premium".
    static let premiumEntitlementID = "premium"

    /// Offering identifier for the main paywall offering. "default" matches RC's
    /// convention when you don't explicitly name it.
    static let defaultOfferingID = "default"

    @Published var isPremium = false
    @Published var isLoading = false
    @Published var currentOffering: Offering?
    @Published var errorMessage: String?

    private override init() {
        super.init()
        // Listen for CustomerInfo updates so premium status stays in sync with any
        // store event (purchase, renewal, cancellation, restore).
        Purchases.shared.delegate = self

        Task {
            await self.refresh()
            await self.loadOfferings()
        }
    }

    // MARK: - Status

    func refresh() async {
        do {
            let info = try await Purchases.shared.customerInfo()
            self.isPremium = info.entitlements[Self.premiumEntitlementID]?.isActive == true
        } catch {
            print("Failed to fetch customerInfo:", error)
        }
    }

    func loadOfferings() async {
        do {
            let offerings = try await Purchases.shared.offerings()
            self.currentOffering = offerings.offering(identifier: Self.defaultOfferingID)
                ?? offerings.current
        } catch {
            print("Failed to fetch offerings:", error)
        }
    }

    // MARK: - User linking

    /// Call this after backend sign-in so RevenueCat associates purchases with
    /// our stable user ID.
    func logIn(userId: String) async {
        do {
            let (info, _) = try await Purchases.shared.logIn(userId)
            self.isPremium = info.entitlements[Self.premiumEntitlementID]?.isActive == true
        } catch {
            print("RevenueCat logIn failed:", error)
        }
    }

    func logOut() async {
        do {
            let info = try await Purchases.shared.logOut()
            self.isPremium = info.entitlements[Self.premiumEntitlementID]?.isActive == true
        } catch {
            // If the user was already anonymous this throws — that's fine.
            print("RevenueCat logOut:", error)
        }
    }

    // MARK: - Purchase

    /// Purchase the primary package from the current offering.
    /// Returns true if the user now has the premium entitlement.
    func purchasePremium() async -> Bool {
        if currentOffering == nil {
            await loadOfferings()
        }
        guard let offering = currentOffering else {
            errorMessage = "Abonelik yüklenemedi. Lütfen daha sonra tekrar deneyin."
            return false
        }

        // Prefer the monthly package if available, otherwise the first available.
        let package = offering.monthly
            ?? offering.annual
            ?? offering.lifetime
            ?? offering.availablePackages.first

        guard let package else {
            errorMessage = "Satın alınabilir paket bulunamadı."
            return false
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await Purchases.shared.purchase(package: package)
            if result.userCancelled { return false }
            self.isPremium = result.customerInfo.entitlements[Self.premiumEntitlementID]?.isActive == true
            return self.isPremium
        } catch {
            errorMessage = "Satın alma başarısız oldu: \(error.localizedDescription)"
            return false
        }
    }

    /// Restore previously-purchased subscriptions (for users reinstalling the app
    /// or switching devices).
    func restorePurchases() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        do {
            let info = try await Purchases.shared.restorePurchases()
            self.isPremium = info.entitlements[Self.premiumEntitlementID]?.isActive == true
            return self.isPremium
        } catch {
            errorMessage = "Geri yükleme başarısız: \(error.localizedDescription)"
            return false
        }
    }

    // MARK: - Price display

    /// Formatted price for the default package, e.g. "₺19.99 / ay".
    var displayPrice: String? {
        guard let offering = currentOffering,
              let package = offering.monthly ?? offering.availablePackages.first else {
            return nil
        }
        return package.storeProduct.localizedPriceString
    }
}

// MARK: - PurchasesDelegate

extension SubscriptionManager: PurchasesDelegate {
    nonisolated func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.isPremium = customerInfo.entitlements[Self.premiumEntitlementID]?.isActive == true
        }
    }
}
