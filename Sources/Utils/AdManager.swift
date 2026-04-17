import Foundation
import GoogleMobileAds
import UIKit

class AdManager: NSObject, ObservableObject {
    static let shared = AdManager()
    
    @Published var isInterstitialLoaded = false
    
    private var interstitialAdUnitID: String = "ca-app-pub-3940256099942544/4411468910"
    private var interstitialAd: InterstitialAd?
    private var completionHandler: (() -> Void)?
    
    // Rastgele hedef soru sayısı
    private var questionsAnswered = 0
    private var nextAdThreshold: Int = 0
    
    override init() {
        super.init()
        setNextAdThreshold()
        setupAdMob()
    }
    
    // Her reklamdan sonra yeni rastgele eşik belirle (10-12 arası)
    private func setNextAdThreshold() {
        nextAdThreshold = questionsAnswered + Int.random(in: 10...12)
        print("Next ad will show at question: \(nextAdThreshold)")
    }
    
    private func setupAdMob() {
        MobileAds.shared.start { status in
            print("AdMob initialization complete: \(status)")
        }
        loadInterstitial()
    }
    
    func loadInterstitial() {
        isInterstitialLoaded = false
        let request = Request()
        InterstitialAd.load(
            with: interstitialAdUnitID,
            request: request
        ) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            self?.isInterstitialLoaded = true
            print("Interstitial ad loaded successfully")
        }
    }
    
    // Her soru sonrası bu fonksiyonu çağır
    func recordQuestionAnswered() {
        questionsAnswered += 1
    }
    
    func shouldShowAd() -> Bool {
        return questionsAnswered >= nextAdThreshold && isInterstitialLoaded
    }
    
    func showInterstitial(from viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let interstitialAd = interstitialAd, isInterstitialLoaded else {
            print("Ad not ready, skipping.")
            completion?()
            return
        }
        
        completionHandler = completion
        interstitialAd.present(from: viewController)
    }
}

extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent() {
        completionHandler?()       // Completion'ı burada çağır
        completionHandler = nil
        setNextAdThreshold()       // Yeni eşik belirle
        loadInterstitial()         // Sonraki reklamı yükle
    }
    
    func adWillDismissFullScreenContent() {
        // Gerekirse kullanılabilir
    }
    
    func ad(_ ad: any FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        print("Ad failed to present: \(error.localizedDescription)")
        completionHandler?()
        completionHandler = nil
        setNextAdThreshold()
        loadInterstitial()
    }
}
