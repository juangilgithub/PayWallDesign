//
//  PaywallOneOptionConfiguration.swift
//  jaydip-001-paywall
//
//  Created by Kevin Quisquater on 29/04/2021.
//

import UIKit

public struct PaywallOneOptionConfiguration {
    
    // What should be displayed at the bottom
    // when a purchase option is selected
    public enum BottomSectionType {
        
        // We simply display a button and a label above it
        
        // In the following string called textFormat,
        // "#period" will be replaced by the period name (ex: day, month)
        // and #quantity by the number of free periods (ex: 7)
        // and #price by the price string (ex: $19.99)
        case noOptions(textFormat: String)
        
        // We show a rectangle with the UISwitch to enabled/disable free trial
        case freeTrialSwitch(
                isFreeTrialEnabledByDefault: Bool,
                productIdWhenSwitchOff: String,
                productIdWhenSwitchOn: String,
                priceTextWhenSwitchOff: String,
                priceTextWhenSwitchOn: String,
                explanationTextWhenSwitchOff: String,
                explanationTextWhenSwitchOn: String
             )
    }
    
    // Why a class? Because we need to be able to update productInformation once it's loaded
    public class PurchaseOption {
        
        let productId: String
        let productType: IPPurchaseOptionType
        var productInformation: ProductInformation?
        
        public init(productId: String,
                    productType: IPPurchaseOptionType) {
            self.productId = productId
            self.productType = productType
        }
    }
    
    var purchaseOption: PurchaseOption
    let bottomDisplayType: BottomSectionType
    let animationImages: [UIImage]?
    let pageBackgroundColor: UIColor
    
    let titleText: String
    let titleHighlightedParts: [String]
    
    let arguments: [String]
    let purchaseButtonTitle: String
    let restoreButtonTitle: String
    let delayBeforeEnablingDismiss: TimeInterval? // If nil, will be 0 (immediately visible)
    let purchaseButtonBackgroundColor: UIColor
    let purchaseButtonTextColor: UIColor
    let checkmarkColor: UIColor
    
    var handleUserAction: ((_ action: PaywallDarkOnboardingVC.UserAction) -> Void)
    
    // Needed so we can initalize a config object in the project, outside of the pod: https://stackoverflow.com/a/54673401
    public init(
        purchaseOption: PurchaseOption,
        bottomDisplayType: BottomSectionType,
        animationImages: [UIImage]?,
        pageBackgroundColor: UIColor?,
        titleText: String?,
        titleHighlightedParts: [String],
        arguments: [String]?,
        purchaseButtonTitle: String?,
        restoreButtonTitle: String?,
        delayBeforeEnablingDismiss: TimeInterval? = nil,
        purchaseButtonBackgroundColor: UIColor?,
        purchaseButtonTextColor: UIColor?,
        checkmarkColor: UIColor?,
        handleUserAction: @escaping ((_ action: PaywallDarkOnboardingVC.UserAction) -> Void)
    ) {
        
        // All the default values are here,
        // not need to scroll in the VC to change default texts, colors, etc
        
        let defaultBlueColor = UIColor(hex: "3369FF")
        
        let defaultTitle = "Unlock Unlimited Access"
        let defaultArguments = ["Argument 1", "Argument 2", "Argument 3 and a very long line to test the label width and make sure any lines we want will fit", "Argument 4", "Argument 5", "Argument 6", "Argument 7", "Argument 8"]
        let defaultPurchaseButtonTitle = "Continue"
        let defaultRestoreButtonTitle = "Restore"
        let defaultPageBackgroundColor = UIColor(hex: "27282E")
        let defaulPurchaseButtonBackgroundColor = defaultBlueColor
        let defaultPurchaseButtonTextColor = UIColor.white
        let defaultCheckmarkColor = defaultBlueColor
        
        self.purchaseOption = purchaseOption
        self.bottomDisplayType = bottomDisplayType
        self.animationImages = animationImages
        self.pageBackgroundColor = pageBackgroundColor ?? defaultPageBackgroundColor
        
        self.titleText = titleText ?? defaultTitle
        self.titleHighlightedParts = titleHighlightedParts
        
        self.arguments = arguments ?? defaultArguments
        self.purchaseButtonTitle = purchaseButtonTitle ?? defaultPurchaseButtonTitle
        self.restoreButtonTitle = restoreButtonTitle ?? defaultRestoreButtonTitle
        self.delayBeforeEnablingDismiss = delayBeforeEnablingDismiss
        self.purchaseButtonBackgroundColor = purchaseButtonBackgroundColor ?? defaulPurchaseButtonBackgroundColor
        self.purchaseButtonTextColor = purchaseButtonTextColor ?? defaultPurchaseButtonTextColor
        self.checkmarkColor = checkmarkColor ?? defaultCheckmarkColor
        self.handleUserAction = handleUserAction
    }
}
