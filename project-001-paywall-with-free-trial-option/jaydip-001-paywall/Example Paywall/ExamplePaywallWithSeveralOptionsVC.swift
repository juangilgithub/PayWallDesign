//
//  ExamplePaywallVC.swift
//  jaydip-001-paywall
//
//  Created by Kevin Quisquater on 17/04/2021.
//

import Foundation
import UIKit
import SafariServices

public struct PaywallSeveralOptionsConfiguration {
    
    // What should be displayed at the bottom
    // when a purchase option is selected
    public enum PurchaseOptionBottomDisplayType {
        case text(text: String)
        case badgeSimpleText(text: String)
        
        // In the following string,
        // "#period" will be replaced by the period name (ex: day, month)
        // and #quantity by the number of free periods (ex: 7)
        case badgeFreeTrial(textFormat: String)
        case none
    }
    
    // What should be displayed to the right of the price button
    public enum PurchaseOptionRightDisplayType {
        
        case simpleText(text: String)
        
        // In order to display "33% off", if you have for instance 3 purchase options
        // in the following order: lifetime, then monthly, then yearly
        // if you want to write "33% off" to the right of the yearly option,
        // and the discount is calculated compared on the monthly option.
        // In yearly, you should use the following parameters:
        // showDiscount(comparedToPurchaseOptionWithIndex: 1,
        //              stringFormat: "#DISCOUNT% off" (don't forget the % sign if you want it)
        case showDiscount(comparedToPurchaseOptionWithIndex: Int,
                          stringFormat: String)
        
        case none
    }
    
    // Why a class? Because we need to be able to update productInformation once it's loaded
    public class PurchaseOption {
        
        let productId: String
        let productType: IPPurchaseOptionType
        let isSelectedByDefault: Bool
        let rightDisplayType: PurchaseOptionRightDisplayType
        let bottomDisplayType: PurchaseOptionBottomDisplayType
        
        var productInformation: ProductInformation?
        
        public init(productId: String,
                    productType: IPPurchaseOptionType,
                    isSelectedByDefault: Bool,
                    rightDisplayType: PurchaseOptionRightDisplayType,
                    bottomDisplayType: PurchaseOptionBottomDisplayType) {
            self.productId = productId
            self.productType = productType
            self.isSelectedByDefault = isSelectedByDefault
            self.rightDisplayType = rightDisplayType
            self.bottomDisplayType = bottomDisplayType
        }
    }
    
    var purchaseOptions: [PurchaseOption]
    let productSelectedBackgroundColor: UIColor
    let animationImages: [UIImage]?
    let gradientType: IPGradientType
    let stripesImage: UIImage?
    let titleText: String
    let subtitleText: String
    let dismissButtonText: String
    let purchaseButtonTitle: String
    let privacyButtonTitle: String
    let restoreButtonTitle: String
    let delayBeforeEnablingDismiss: TimeInterval? // If nil, will be 0 (immediately visible)
    let badgeBackgroundColor: UIColor
    let purchaseButtonBackgroundColor: UIColor
    let purchaseButtonTextColor: UIColor
    
    var handleUserAction: ((_ action: ExamplePaywallWithSeveralOptionsVC.UserAction) -> Void)
    
    // Needed so we can initalize a config object in the project, outside of the pod: https://stackoverflow.com/a/54673401
    public init(
        purchaseOptions: [PurchaseOption],
        productSelectedBackgroundColor: UIColor?,
        animationImages: [UIImage]?,
        gradientType: IPGradientType?,
        stripesImage: UIImage?,
        titleText: String?,
        subtitleText: String?,
        dismissButtonText: String?,
        purchaseButtonTitle: String?,
        privacyButtonTitle: String?,
        restoreButtonTitle: String?,
        delayBeforeEnablingDismiss: TimeInterval? = nil,
        badgeBackgroundColor: UIColor?,
        purchaseButtonBackgroundColor: UIColor?,
        purchaseButtonTextColor: UIColor?,
        handleUserAction: @escaping ((_ action: ExamplePaywallWithSeveralOptionsVC.UserAction) -> Void)
    ) {
        
        // All the default values are here,
        // not need to scroll in the VC to change default texts, colors, etc
        
        let defaultTitle = "Ready to build your streaming empire?"
        let defaultSubtitle = "Set goals. Promote your streams. Track your growth. Reach milestones."
        let defaultDismissButtonTitle = "Not now"
        let defaultPurchaseButtonTitle = "Continue"
        let defaultPrivacyButtonTitle = "Privacy Policy"
        let defaultRestoreButtonTitle = "Restore purchases"
        let defaultProductSelectedBackgroundColor = UIColor(hex: "752BE9")
        let defaultGradientType = IPGradientType.points(
            points: (start: CGPoint(x: 0.5, y: 0.5), end: CGPoint(x: 0.5, y: 0.0)),
            overlayColors: [
                UIColor(hex: "2B2785"),
                UIColor(hex: "2B2785").withAlphaComponent(0)
            ]
        )
        let defaultBadgeBackgroundColor = UIColor(hex: "EFB710")
        let defaulPurchaseButtonBackgroundColor = UIColor.white
        let defaultPurchaseButtonTextColor = UIColor(hex: "2B2785")
        
        self.purchaseOptions = purchaseOptions
        self.productSelectedBackgroundColor = productSelectedBackgroundColor ?? defaultProductSelectedBackgroundColor
        self.animationImages = animationImages
        self.gradientType = gradientType ?? defaultGradientType
        self.stripesImage = stripesImage
        self.titleText = titleText ?? defaultTitle
        self.subtitleText = subtitleText ?? defaultSubtitle
        self.dismissButtonText = dismissButtonText ?? defaultDismissButtonTitle
        self.purchaseButtonTitle = purchaseButtonTitle ?? defaultPurchaseButtonTitle
        self.privacyButtonTitle = privacyButtonTitle ?? defaultPrivacyButtonTitle
        self.restoreButtonTitle = restoreButtonTitle ?? defaultRestoreButtonTitle
        self.delayBeforeEnablingDismiss = delayBeforeEnablingDismiss
        self.badgeBackgroundColor = badgeBackgroundColor ?? defaultBadgeBackgroundColor
        self.purchaseButtonBackgroundColor = purchaseButtonBackgroundColor ?? defaulPurchaseButtonBackgroundColor
        self.purchaseButtonTextColor = purchaseButtonTextColor ?? defaultPurchaseButtonTextColor
        self.handleUserAction = handleUserAction
    }
}


public class ExamplePaywallWithSeveralOptionsVC: BasePaywallVC {
   
    //––––––––––––––––––––––———
    // MARK: - Initializer
    //––––––––––––––––––––––———
    
    public init(config: PaywallSeveralOptionsConfiguration) {
        self.config = config
        super.init()
        self.purchaseOptionsComparisons = getPurchaseOptionsComparisons(purchaseOptions: config.purchaseOptions)
        
        delayBeforeEnablingDismiss = config.delayBeforeEnablingDismiss
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //––––––––––––––––––––––———
    // MARK: - View Life Cycle
    //––––––––––––––––––––––———
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadProductsInformation()
        animateImages()
        setDefaultProductSelected()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        handleUserAction(.screenAppeared)
        
        if let delayBeforeEnablingDismiss = delayBeforeEnablingDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayBeforeEnablingDismiss) { [weak self] in
                self?.dismissBtn.alpha = 1
            }
        } else {
            dismissBtn.alpha = 1
        }
    }
    
    private func setDefaultProductSelected() {
        for (index, purchaseOption) in config.purchaseOptions.enumerated() {
            if purchaseOption.isSelectedByDefault {
                setPricePointSelected(index: index)
                return
            }
        }
        print("No product is selected by default")
    }
    
    //––––––––––––––––––––––———
    // MARK: - Load Products Information
    //––––––––––––––––––––––———
    
    private func loadProductsInformation() {
        for productId in config.purchaseOptions.map({$0.productId}) {
            
            // This will be replaced by real logic
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let fakeProductInformation = ProductInformation(
                    productId: "test",
                    productType: .yearlySubscription,
                    price: 19.99,
                    priceLocale: Locale.current,
                    localizedPrice: "$19.99",
                    freeTrial: FreeTrialInformation.day(quantity: 3)
                )
                let fakeResult = ProductInformationResult.success(fakeProductInformation)
                self.processProductInformationResult(productId: productId, result: fakeResult)
            }
            
            /*
            PurchasesManager.getProductInformationFor(productId: productId) { [weak self] result in
                self?.processProductInformationResult(productId: productId, result: result)
            }
             */
        }
    }
    
    private func processProductInformationResult(productId: String, result: ProductInformationResult) {
        switch result {
        case let .success(productInformation):
            
            var indexPurchaseOptionFound: Int?
            for (index, purchaseOption) in config.purchaseOptions.enumerated() {
                if purchaseOption.productId == productId {
                    indexPurchaseOptionFound = index
                    break
                }
            }
            
            guard let indexPurchaseOption = indexPurchaseOptionFound else {
                assertionFailure("Could not find purchase option with product ID \(productId)")
                return
            }
            
            // Save the product information we just retrieved
            let purchaseOption = config.purchaseOptions[indexPurchaseOption]
            purchaseOption.productInformation = productInformation
            
            // In case having loaded this product price was needed to calculate a discount
            calculatePurchaseOptionsDiscountsIfNeeded()
            
            // Setup the UI of the price point button
            if let pricePointButton = pricePointsStackView.arrangedSubviews[indexPurchaseOption] as? PricePointButton {
                
                let detailsText: String?
                
                switch purchaseOption.rightDisplayType {
                
                case .simpleText(let text):
                    detailsText = text
                case .showDiscount(let indexExpensivePurchaseOption, let stringFormat):
                    
                    // Let's see if we have a discount indeed
                    guard let purchaseOptionsComparison = self.purchaseOptionsComparisons
                        .filter(({$0.indexDiscountedProduct == indexPurchaseOption
                            && $0.indexExpensiveProduct == indexExpensivePurchaseOption
                        })).first else {
                        
                        print("ERROR: price option wants to display price comparison but there is no saved purchase comparision with the corresponding product indices")
                        
                        detailsText = nil
                        return
                    }
                    
                    guard let discountInPercent = purchaseOptionsComparison.discountInPercent else {
                        print("Price discount hasn't been calculated yet")
                        detailsText = nil
                        return
                    }
                    
                    detailsText = stringFormat.replacingOccurrences(of: "#DISCOUNT", with: "\(discountInPercent)")
                    
                case .none:
                    detailsText = nil
                }
                
                pricePointButton.setup(isPreSelected: purchaseOption.isSelectedByDefault,
                                       localizedPrice: productInformation.localizedPrice,
                                       period: purchaseOption.productType.periodName,
                                       details: detailsText)
                
                if purchaseOption.isSelectedByDefault {
                    setPricePointSelected(index: indexPurchaseOption)
                }
                
                
            } else {
                assertionFailure("Could not find price point button for purchase option with ID \(purchaseOption.productId)")
            }
            
        case let .failure(errorMessaage):
            print("Error while loading product with ID \(productId). Error: \(errorMessaage)")
        }
    }
    
    private func calculatePurchaseOptionsDiscountsIfNeeded() {
        
        // For comparisons that haven't been calculated yet
        for (incexPurchaseOptionComparison, purchaseOptionsComparison) in self.purchaseOptionsComparisons.filter({!$0.discountHasBeenCalculated}).enumerated() {
            
            // Let's check if both product prices have been loaded already
            let discountedProduct = self.config.purchaseOptions[purchaseOptionsComparison.indexDiscountedProduct]
            let expensiveProduct = self.config.purchaseOptions[purchaseOptionsComparison.indexExpensiveProduct]
            
            guard let priceDiscountedProduct = discountedProduct.productInformation?.price,
                  let priceExpensiveProduct = expensiveProduct.productInformation?.price else {
                // Prices are not available yet
                continue
            }
            
            let periodMultiple: Float // How many times the short period fits into the long period, like 12 months in 1 year
            
            // We have the prices of both products
            switch purchaseOptionsComparison.type {
            case .monthlyComparedToWeekly:
                periodMultiple = 52/12 // 4.33 weeks in a month
            case .yearlyComparedToWeekly:
                periodMultiple = 52 // 52 weeks in a year
            case .yearlyComparedToMonthly:
                periodMultiple = 12 // 12 months in a year
            }
            
            #warning("Check how it is rounded, if it ever is 100, 0, etc")
            let discount = priceDiscountedProduct.floatValue / (periodMultiple * priceExpensiveProduct.floatValue)
            let discountInPercent = Int(100 * discount)
            
            print("Discount of \(purchaseOptionsComparison.indexDiscountedProduct) compared to \(purchaseOptionsComparison.indexExpensiveProduct) is \(discountInPercent)%")
            
            self.purchaseOptionsComparisons[incexPurchaseOptionComparison].discountInPercent = discountInPercent
        }
    }
    
    //––––––––––––––––––––––———
    // MARK: - Variables
    //––––––––––––––––––––––———
    
    private var config: PaywallSeveralOptionsConfiguration
     
    private var currentImageIndex = 0
    
    private var purchaseOptionsComparisons = [PurchaseOptionComparison]()
    
    //––––––––––––––––––––––———
    // MARK: - Utility methods
    //––––––––––––––––––––––———
    
    private func getPurchaseOptionsComparisons(purchaseOptions: [PaywallSeveralOptionsConfiguration.PurchaseOption]) -> [PurchaseOptionComparison] {
        
        var purchaseOptionsComparisons = [PurchaseOptionComparison]()
        
        // Let's save the price comparisons we have to calculate,
        // we will calculate them once the product prices will have loaded
        for (indexDiscountedProduct, discountedPurchaseOption) in config.purchaseOptions.enumerated() {
            switch discountedPurchaseOption.rightDisplayType {
            case .simpleText, .none:
                break
            case .showDiscount(let indexExpensiveOption, let stringFormat):
                
                let expensivePurchase = config.purchaseOptions[indexExpensiveOption]
                
                let comparisonType: PurchaseOptionComparison.PriceComparisonType? = {
                    switch discountedPurchaseOption.productType {
                    case .lifetime:
                        assertionFailure("We do not support calculating discounts on lifetime products")
                        return nil
                    case .semester, .quarter:
                        assertionFailure("We do not yet support calculating discounts on semester/quarter products")
                        return nil
                        
                    case .weekly:
                        assertionFailure("Cannot calculate discount on weekly subscription, it's the shortest period")
                        return nil
                        
                    case .yearly:
                        switch expensivePurchase.productType {
                        
                        case .lifetime, .yearly:
                            assertionFailure("Impossible to compare a yearly price to a lifetime or yearly price")
                            return nil
                            
                        case .semester, .quarter:
                            assertionFailure("We do not yet support calculating discounts on semester/quarter products")
                            return nil
                            
                        case .monthly:
                            return .yearlyComparedToMonthly
                        case .weekly:
                            return .yearlyComparedToWeekly
                        }
                        
                    case .monthly:
                        switch expensivePurchase.productType {
                        case .lifetime, .yearly, .semester, .quarter, .monthly:
                            assertionFailure("Impossible to compare a discounted monthly price compared to lifetime/yearly/semester/quarter/monthly price")
                            return nil
                            
                        case .weekly:
                            return .monthlyComparedToWeekly
                        }
                    }
                }()
                
                guard let comparisonTypeRetrieved = comparisonType else {
                    print("ERROR: Will not calculate comparison")
                    continue
                }
                
                // Here if the other products are already pre-loaded, we could already calculate discounts. But it's fine, we do it when product info will be retrieve which will be instant if pre-loaded
                
                let purchaseOptionComparison = PurchaseOptionComparison(
                    indexDiscountedProduct: indexDiscountedProduct,
                    indexExpensiveProduct: indexExpensiveOption,
                    stringFormat: stringFormat,
                    type: comparisonTypeRetrieved,
                    discountInPercent: nil)
                
                purchaseOptionsComparisons.append(purchaseOptionComparison)
                
            }
        }
        
        return purchaseOptionsComparisons
    }
    
    //––––––––––––––––––––––———
    // MARK: - User Actions
    //––––––––––––––––––––––———
        
    private lazy var handleUserAction = config.handleUserAction
    
    public enum UserAction {
        case screenAppeared
        case optionSelected(productId: String)
        case purchaseButtonTapped(productId: String)
        case skipTapped
        case restoreTapped
        case privacyTapped
    }
    
    //––––––––––––––––––––––———
    // MARK: - Setup UI
    //––––––––––––––––––––––———
    
    private lazy var animatedImageView: UIImageView = {
        let iv = UIImageView()
        iv.animationDuration = 12
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var backgroundOverlay: GradientView = {
        let gradientView = GradientView()
        
        switch config.gradientType {
        case .points(let gradientPoints, let overlayColors):
            gradientView.startPoint = gradientPoints.start
            gradientView.endPoint = gradientPoints.end
            gradientView.colors = overlayColors.map({ $0 })
        case .direction(let direction, let overlayColors):
            gradientView.direction = direction
            gradientView.colors = overlayColors.map({ $0 })
        }
        
        return gradientView
    }()
    
    private lazy var stripesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = config.stripesImage
        return imageView
    }()
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = config.titleText
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 50, weight: .heavy)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 2
        lbl.layer.applySketchShadow(color: .black, alpha: 0.7, x: 1, y: 1, blur: 3, spread: 0)
        return lbl
    }()
    
    private lazy var subtitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = config.subtitleText
        lbl.font = .systemFont(ofSize: 22, weight: .regular)
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        lbl.layer.applySketchShadow(color: .black, alpha: 0.7, x: 1, y: 1, blur: 3, spread: 0)
        return lbl
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        stackView.addArrangedSubview(titleLbl)
        stackView.addArrangedSubview(subtitleLbl)
        return stackView
    }()
    
    private lazy var pricePointsStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        for (index, purchaseOption) in config.purchaseOptions.enumerated() {
            let pricePointButton = PricePointButton(type: .system)
            pricePointButton.tag = index
            pricePointButton.set(selectedBackgroundColor: config.productSelectedBackgroundColor)
            pricePointButton.addTarget(self, action: #selector(handlePurchaseOptionTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(pricePointButton)
        }
        return stackView
    }()
    
    @objc private func handlePurchaseOptionTapped(_ button: PricePointButton) {
        
        let indexPurchaseOption = button.tag
        
        // If not already seleted, switch to that option
        guard button.isOptionSelected else {
            setPricePointSelected(index: indexPurchaseOption)
            return
        }
        
        // If option already selected, start purchase
        guard indexPurchaseOption < config.purchaseOptions.count else {
            #warning("TODO: Show an alert to the user. We do not seem to have an extension to show info alert")
            assertionFailure("Index of the purchase option is out of bounds in \(#function)")
            return
        }
        
        guard let productInformation = config.purchaseOptions[indexPurchaseOption].productInformation else {
            assertionFailure("Should we prevent user from tapping button before information is loaded?")
            print("Error: product information hasn't been loaded yet")
            return
        }
        
        purchase(product: productInformation)
    }
    
    private lazy var bottomLblWidth = NSLayoutConstraint()
    
    private lazy var bottomLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = " "
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 1
        lbl.layer.cornerRadius = 10
        lbl.clipsToBounds = true
        return lbl
    }()
    
    private lazy var purchaseButton: UIButton = {
        let btn = UIButton(type: .system)
        let title = NSAttributedString(
            string: config.purchaseButtonTitle,
            attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .heavy),
                         .foregroundColor : config.purchaseButtonTextColor]
        )
        btn.setAttributedTitle(title, for: .normal)
        btn.backgroundColor = config.purchaseButtonBackgroundColor
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return btn
    }()
    
    private lazy var privacyPolicyBtn: UIButton = {
        let btn = UIButton(type: .system)
        let title = NSAttributedString(
            string: config.privacyButtonTitle,
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium),
                         .foregroundColor : UIColor.white.withAlphaComponent(0.6)]
        )
        btn.setAttributedTitle(title, for: .normal)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(handlePrivacyPolicy), for: .touchUpInside)
        return btn
    }()
    
    private lazy var restoreBtn: UIButton = {
        let btn = UIButton(type: .system)
        let title = NSAttributedString(
            string: config.restoreButtonTitle,
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium),
                         .foregroundColor : UIColor.white.withAlphaComponent(0.6)]
        )
        btn.setAttributedTitle(title, for: .normal)
        btn.backgroundColor = .clear
        btn.contentHorizontalAlignment = .right
        btn.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
        return btn
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [privacyPolicyBtn, restoreBtn])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 40
        return sv
    }()
    
    private lazy var dismissBtn: UIButton = {
        let button = UIButton(type: .system)
        let attributedTextTitle = NSAttributedString(
            string: config.dismissButtonText,
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium),
                         .foregroundColor : UIColor.white.withAlphaComponent(0.6)
            ]
        )
        button.setAttributedTitle(attributedTextTitle, for: .normal)
        button.backgroundColor = UIColor.clear
        button.alpha = 0
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return button
    }()
    
    private func setupUI() {
        
        view.addSubview(animatedImageView)
        view.addSubview(backgroundOverlay)
        view.addSubview(stripesImageView)
        view.addSubview(titleStackView)
        
        view.addSubview(pricePointsStackView)
        
        view.addSubview(bottomLbl)
        view.addSubview(purchaseButton)
        view.addSubview(bottomStackView)
        view.addSubview(dismissBtn)
        
        animatedImageView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0))
        backgroundOverlay.fillSuperview()
        
        stripesImageView.anchor(top: view.topAnchor,
                                left: view.leftAnchor,
                                paddingTop: 50,
                                width: 60,
                                height: 120)
        
        titleStackView.anchor(left: view.leftAnchor,
                              bottom: pricePointsStackView.topAnchor,
                              right: view.rightAnchor,
                              paddingLeft: 30,
                              paddingBottom: 40,
                              paddingRight: 30)
        
        pricePointsStackView.anchor(left: view.leftAnchor,
                                    bottom: bottomLbl.topAnchor,
                                    right: view.rightAnchor,
                                    paddingLeft: 30,
                                    paddingBottom: 25,
                                    paddingRight: 30,
                                    height: 180)
        
        bottomLbl.anchor(bottom: purchaseButton.topAnchor,
                         paddingBottom: 25,
                         height: 40)
        bottomLbl.anchorCenterXToSuperview()
        bottomLblWidth = bottomLbl.widthAnchor.constraint(equalToConstant: 0)
        bottomLblWidth.isActive = true
        
        purchaseButton.anchor(left: view.leftAnchor,
                           bottom: bottomStackView.topAnchor,
                           right: view.rightAnchor,
                           paddingLeft: 30,
                           paddingBottom: 25,
                           paddingRight: 30,
                           height: 50)
        
        bottomStackView.anchor(left: view.leftAnchor,
                               bottom: view.bottomAnchor,
                               right: view.rightAnchor,
                               paddingLeft: 30,
                               paddingBottom: 30,
                               paddingRight: 30,
                               height: 30)
        
        dismissBtn.anchor(top: safeTopAnchor,
                          right: view.rightAnchor,
                          paddingTop: 15,
                          paddingRight: 16,
                          height: 20)
    }
    
    private func animateImages() {
        
        guard let images = config.animationImages, images.count > 1 else {
            return
        }
        
        UIView.transition(
            with: self.animatedImageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                let nextIndex = images.indices.contains(self.currentImageIndex + 1) ? self.currentImageIndex + 1 : 0
                self.animatedImageView.image = images[nextIndex]
                self.currentImageIndex = nextIndex
            }, completion: { [weak self] completed in
                guard completed else {
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    self?.animateImages()
                }
            }
        )
    }
    
    //––––––––––––––––––––––———
    // MARK: - Handlers
    //––––––––––––––––––––––———
    
    @objc private func handleSkip() {
        DispatchQueue.main.async { [weak self] in
            self?.handleUserAction(.skipTapped)
            self?.handleSkipButtonTapped?()
        }
    }
    
    //––––––––––––––––––––––———————————
    // MARK: - Set Selected Price Point
    //––––––––––––––––––––––———————————
    
    #warning("#period we could replace by #periodPlural and #periodSingular maybe")
    
    func setPricePointSelected(index: Int) {
        
        guard index < pricePointsStackView.arrangedSubviews.count else {
            assertionFailure("Price point selected is outside of the stackView's array bounds")
            return
        }
        
        for (indexButton, pricePointButton) in pricePointsStackView.arrangedSubviews.enumerated() {
            guard let pricePointButton = pricePointButton as? PricePointButton else {
                assertionFailure("Arranged subview is not a PricePointButton")
                continue
            }
            pricePointButton.isOptionSelected = (indexButton == index)
        }
        
        guard index < config.purchaseOptions.count else {
            assertionFailure("Purchase option selected is outside of the config purchase options array bounds")
            return
        }
        
        let purchaseOptionSelected = config.purchaseOptions[index]
        setupBottomLabel(purchaseOption: purchaseOptionSelected)
        
        handleUserAction(.optionSelected(productId: purchaseOptionSelected.productId))
        
        // Could be nil
        self.selectedProduct = purchaseOptionSelected.productInformation
    }
    
    private func setupBottomLabel(purchaseOption:  PaywallSeveralOptionsConfiguration.PurchaseOption) {
        switch purchaseOption.bottomDisplayType {
        case .text(let text):
            bottomLbl.text = text
            bottomLbl.backgroundColor = .clear
            bottomLbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            
            animateBottomLabel()
            
        case .badgeSimpleText(let text):
            
            bottomLbl.text = text
            bottomLbl.backgroundColor = config.badgeBackgroundColor
            bottomLbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            
            animateBottomLabel()
            
        case .badgeFreeTrial(let textFormat):
            
            guard purchaseOption.productType != .lifetime else {
                assertionFailure("Error: looking for a free trial in a lifetime product")
                break
            }
            
            guard let productInformation = purchaseOption.productInformation else {
                print("Product information is not ready")
                break
            }
            
            guard let freeTrial = productInformation.freeTrial else {
                assertionFailure("Error: trying to create a free trial badge in a product with none")
                break
            }
            
            let freeTrialPeriodName: String
            let freeTrialQuantity: Int
            
            switch freeTrial {
            case .day(let quantity):
                freeTrialPeriodName = "day"
                freeTrialQuantity = quantity
            case .week(let quantity):
                freeTrialPeriodName = "day"
                freeTrialQuantity = (quantity * 7) // We display 7 days instead of 1 week
            case .month(quantity: let quantity):
                freeTrialPeriodName = "month"
                freeTrialQuantity = quantity
            case .year(quantity: let quantity):
                freeTrialPeriodName = "year"
                freeTrialQuantity = quantity
            }
            
            bottomLbl.text = textFormat
                .replacingOccurrences(of: "#period",
                                      with: freeTrialPeriodName.addLetterSIfNeeded(quantity: freeTrialQuantity))
                .replacingOccurrences(of: "#quantity", with: "\(freeTrialQuantity)")
            bottomLbl.backgroundColor = config.badgeBackgroundColor
            bottomLbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            
            animateBottomLabel()
            
        case .none:
            bottomLbl.text = nil
            bottomLbl.backgroundColor = .clear
            bottomLbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
    }
    
    private func animateBottomLabel() {
        bottomLblWidth.constant = bottomLbl.intrinsicContentSize.width * 1.25
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.bottomLbl.scale(values: [1.0, 1.05, 1.0], duration: 0.3, repeatsForever: false)
        }
    }
    
    @objc private func handleRestore() {
        handleUserAction(.restoreTapped)
        restore()
    }
    
    @objc private func handlePrivacyPolicy() {
        handleUserAction(.privacyTapped)
        openPrivacyPolicy()
    }
    
    @objc private func handleContinue() {
        
        guard let selectedProduct = selectedProduct else {
            print("💰 - No selected product")
            return
        }
        handleUserAction(.purchaseButtonTapped(productId: selectedProduct.productId))
        
        handlePurchaseButtonTapped()
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
