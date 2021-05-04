//
//  BasePaywallVC.swift
//  jaydip-001-paywall
//
//  Created by Kevin Quisquater on 17/04/2021.
//

import UIKit

//SUPERCLASS
public class BasePaywallVC: UIViewController {

    //––––––––––––––––––––––———
    // MARK: - Variables
    //––––––––––––––––––––––———

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delayBeforeEnablingDismiss: TimeInterval?
    
    var selectedProduct: ProductInformation? {
        didSet {
            guard let selectedProduct = selectedProduct else { return }
            print("💰 - Product selected: \(selectedProduct.productId)")
        }
    }
    
    //––––––––––––––––––––––———
    // MARK: - Closures
    //––––––––––––––––––––––———
    
    public var handleSkipButtonTapped: (() -> Void)?
    public var handlePurchaseSuccessful: ((_ productId: String) -> Void)?
    public var handlePurchaseRestored: ((_ productId: String) -> Void)?
    public var handlePurchaseFailed: ((_ errorMessage: String) -> Void)?
    
    //––––––––––––––––––––––———
    // MARK: - Actions
    //––––––––––––––––––––––———
    
    ///For paywalls with multiple products -> this function can be used to set the pre-selected products and to updates the currently selected product after users change to their preferred option.
    func select(product: ProductInformation) {
        self.selectedProduct = product
    }
    
    func handlePurchaseButtonTapped() {
        guard let selectedProduct = selectedProduct else {
            assertionFailure("Purchase button was tapped but no product is selected")
            return
        }
        purchase(product: selectedProduct)
    }
    
    //––––––––––––––––––––––———
    // MARK: - PURCHASE
    //––––––––––––––––––––––———
    
    ///Purchase product directly by passing a ProductInformation object. Based on the product type (IAP or Weekly, Monthly or Yearly Subscription), this function will call buyLifetime or buySubscription accordingly and return an alert with the output.
    func purchase(product: ProductInformation) {
        // LEFT EMPTY ON PURPOSE
    }
    
    //––––––––––––––––––––––———
    // MARK: - RESTORE
    //––––––––––––––––––––––———
    
    //calls function from PremiumPurchasable & handles the completion handler so we don't have to repeat that code.
    func restore() {
        // LEFT EMPTY ON PURPOSE
    }
        
    func skip() {
        handleSkipButtonTapped?()
    }
    
    func openPrivacyPolicy() {
        // LEFT EMPTY ON PURPOSE
    }
}

public enum ProductInformationResult {
    case success(ProductInformation)
    case failure(_ errorMessage: String)
}


