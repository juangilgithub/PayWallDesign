//
//  AppDelegate.swift
//  jaydip-001-paywall
//
//  Created by Kevin Quisquater on 17/04/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createAndPresentVC()
        return true
    }
    
    private func createAndPresentVC() {
        // let vc = ExamplePaywallWithSeveralOptionsVC(config: testConfigurationSeveralOptions)
        let vc = PaywallDarkOnboardingVC(config: testConfigurationOneOption)
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = vc
    }
    
    //––––––––––––––––––––––———–––––––
    // MARK: - PAYWALL THREE OPTIONS
    //––––––––––––––––––––––———–––––––
    
    let gradientsColors = [UIColor(hex: "2B2785"), UIColor(hex: "2B2785").withAlphaComponent(0.0)]
    
    let gradientPoints: IPGradientPoints = (
        start: CGPoint(x: 0.5, y: 0.7), end: CGPoint(x: 0.5, y: 0.0)
    )
    
    let lifetimePurchaseOption = PaywallSeveralOptionsConfiguration.PurchaseOption(
        productId: "test",
        productType: .lifetime,
        isSelectedByDefault: false,
        rightDisplayType: .simpleText(text: "Lifetime access"),
        bottomDisplayType: .text(text: "No subscription, just pay once.")
    )
    let monthlyPurchaseOption = PaywallSeveralOptionsConfiguration.PurchaseOption(
        productId: "test",
        productType: .monthly,
        isSelectedByDefault: false,
        rightDisplayType: .none,
        bottomDisplayType: .none
    )
    let yearlyPurchaseOption = PaywallSeveralOptionsConfiguration.PurchaseOption(
        productId: "test",
        productType: .yearly,
        isSelectedByDefault: true,
        rightDisplayType: .showDiscount(comparedToPurchaseOptionWithIndex: 1,
                                        stringFormat: "#DISCOUNT% off"),
        bottomDisplayType: .badgeFreeTrial(textFormat: "Try free for #quantity #period")
    )
    
    private var testConfigurationSeveralOptions: PaywallSeveralOptionsConfiguration {
        PaywallSeveralOptionsConfiguration(
            purchaseOptions: [lifetimePurchaseOption, monthlyPurchaseOption, yearlyPurchaseOption],
            productSelectedBackgroundColor: nil,
            animationImages: [],
            gradientType: .points(points: gradientPoints, overlayColors: gradientsColors),
            stripesImage: nil,
            titleText: "Ready to build your streaming empire?",
            subtitleText: "Set goals. Promote your streams. Track your growth. Reach milestones.",
            dismissButtonText: "Later",
            purchaseButtonTitle: nil,
            privacyButtonTitle: nil,
            restoreButtonTitle: "Already Premium?",
            delayBeforeEnablingDismiss: 0,
            badgeBackgroundColor: UIColor(hex: "FF7E00"),
            purchaseButtonBackgroundColor: nil,
            purchaseButtonTextColor: nil,
            handleUserAction: { [weak self] (action) in
                switch action {
                case .screenAppeared:
                    print("💰🧩 paywall 3 options appeared")
                case .skipTapped:
                    print("💰🧩 payWall 3 options was dismissed")
                case .optionSelected(productId: let productId):
                    print("💰🧩 paywall 3 options - \(productId) selected")
                case .purchaseButtonTapped(productId: let productId):
                    print("💰🧩 paywall 3 options - continue with \(productId)")
                default:
                    break
                }
            }
        )
    }
    
    
    
    //––––––––––––––––––––––———–––––––
    // MARK: - PAYWALL DARK ONBOARDING
    //––––––––––––––––––––––———–––––––
    
    
    let oneOptionYearlyPurchaseOption = PaywallOneOptionConfiguration.PurchaseOption(
        productId: "test",
        productType: .yearly
    )
    
    private var testConfigurationOneOption: PaywallOneOptionConfiguration {
        
        PaywallOneOptionConfiguration(
            purchaseOption: oneOptionYearlyPurchaseOption,
            bottomDisplayType: .noOptions(textFormat: "Free for #quantity #periodTrial, then #price/#periodSubscription."),
            animationImages: [],
            pageBackgroundColor: nil,
            titleText: "Unlock\nUnlimited Access",
            titleHighlightedParts: ["Unlimited"],
            arguments: ["Unlimited texts", "No more ads", "Script tools for actors this is a long time", "Dark mode", "Support a solo developer", "Cancel subscriptions anytime"],
            purchaseButtonTitle: nil,
            restoreButtonTitle: nil,
            purchaseButtonBackgroundColor: nil,
            purchaseButtonTextColor: nil,
            checkmarkColor: nil,
            handleUserAction: { [weak self] action in
                switch action {
                
                case .screenAppeared:
                    print("💰🧩 Paywall Dark Onboarding - appeared")
                case .purchaseButtonTapped(let productId):
                    print("💰🧩 Paywall Dark Onboarding - purchase with \(productId)")
                case .skipTapped:
                    print("💰🧩 Paywall Dark Onboarding - was dismissed")
                case .restoreTapped:
                    print("💰🧩 Paywall Dark Onboarding - restore tapped")
                }
            }
        )
    }
}

