//
//  PaywallDarkOnboarding.swift
//  jaydip-001-paywall
//
//  Created by Kevin Quisquater on 17/04/2021.
//

import UIKit

public class PaywallDarkOnboardingVC: BasePaywallVC {
    
    //––––––––––––––––––––––———
    // MARK: - Initializer
    //––––––––––––––––––––––———
    
    public init(config: PaywallOneOptionConfiguration) {
        self.config = config
        super.init()
        
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
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        handleUserAction(.screenAppeared)
        
        if let delayBeforeEnablingDismiss = delayBeforeEnablingDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayBeforeEnablingDismiss) { [weak self] in
                
                self?.dismissButton.alpha = 1
            }
        } else {
            dismissButton.alpha = 1
        }
    }
    
    //––––––––––––––––––––––———
    // MARK: - Load Products Information
    //––––––––––––––––––––––———
    
    private func loadProductsInformation() {
        
        // This will be replaced by real logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            
            guard let self = self else {
                return
            }
            
            let fakeProductInformation = ProductInformation(
                productId: "test",
                productType: .yearlySubscription,
                price: 19.99,
                priceLocale: Locale(identifier: "en_US"),
                localizedPrice: "$19.99",
                freeTrial: FreeTrialInformation.day(quantity: 3)
            )
            let fakeResult = ProductInformationResult.success(fakeProductInformation)
            self.processProductInformationResult(productId: self.config.purchaseOption.productId, result: fakeResult)
        }
        
        /*
         PurchasesManager.getProductInformationFor(productId: productId) { [weak self] result in
         self?.processProductInformationResult(productId: productId, result: result)
         }
         */
    }
    
    private func processProductInformationResult(productId: String, result: ProductInformationResult) {
        switch result {
        case let .success(productInformation):
            
            // Save the product information we just retrieved
            config.purchaseOption.productInformation = productInformation
            
            setupBottomLabel()
            
        case let .failure(errorMessaage):
            print("Error while loading product with ID \(productId). Error: \(errorMessaage)")
        }
    }
    
    //––––––––––––––––––––––———
    // MARK: - Variables
    //––––––––––––––––––––––———
    
    private var config: PaywallOneOptionConfiguration
    
    private var currentImageIndex = 0
    
    //––––––––––––––––––––––———
    // MARK: - Utility methods
    //––––––––––––––––––––––———
    
    
    
    //––––––––––––––––––––––———
    // MARK: - User Actions
    //––––––––––––––––––––––———
    
    private lazy var handleUserAction = config.handleUserAction
    
    public enum UserAction {
        case screenAppeared
        case purchaseButtonTapped(productId: String)
        case skipTapped
        case restoreTapped
    }
    
    //––––––––––––––––––––––———
    // MARK: - Setup UI
    //––––––––––––––––––––––———
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.animationDuration = 12
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "InfinitySignLogo")
        return imageView
    }()
    
    private lazy var backgroundOverlay: GradientView = {
        let gradientView = GradientView()
        gradientView.colors = [config.pageBackgroundColor, config.pageBackgroundColor]
        return gradientView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.numberOfLines = 0
        let attributedWithTextColor = config.titleText.attributedStringWithHighlights(
            stringsToHighlight: config.titleHighlightedParts,
            highlightColor: UIColor(hex: "3369FF") // TODO: Get from config file
        )
        label.attributedText = attributedWithTextColor
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSAttributedString(
            string: config.purchaseButtonTitle,
            attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .medium),
                         .foregroundColor : config.purchaseButtonTextColor]
        )
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = config.purchaseButtonBackgroundColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.anchor(height: 60)
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorLineView: UIView = {
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        return bottomDividerView
    }()
    
    private lazy var restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(config.restoreButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
        return button
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        // Careful: if image change, change size below
        let imageButton = UIImage(named: "CloseButtonIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(imageButton, for: .normal)
        button.tintColor = UIColor(hex: "EBEBF5").withAlphaComponent(0.3)
        button.backgroundColor = .clear
        button.alpha = 0
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        button.anchor(width: 24, height: 24) // Has to be the size of the image
        return button
    }()
    
    // Contains all the elements that scroll
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        stackView.addArrangedSubview(topButtonStackView)
        stackView.addArrangedSubview(centerContentStackView)
        return stackView
    }()
    
    private lazy var topButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        
        let horizontalPadding: CGFloat = isIpad ? 40 : 24
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 24,
            leading: horizontalPadding,
            bottom: 0,
            trailing: horizontalPadding
        )
        
        // Expandable invisible view
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        
        stackView.addArrangedSubview(dismissButton)
        stackView.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(restoreButton)
        return stackView
    }()
    
    // Contains the elements that have a fixed width on iPad
    private lazy var centerContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0 // This is ignored, a big space is added
        
        let horizontalPadding: CGFloat = {
            if isIpad {
                let fixedWidth: CGFloat = 400
                return (view.frame.size.width - fixedWidth) / 2
            } else {
                return 48
            }
        }()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: horizontalPadding,
            bottom: 0,
            trailing: horizontalPadding
        )
        
        stackView.addArrangedSubview(logoImageView) // Can't get rid of the space below the image, at the moment
        stackView.addArrangedSubview(titleLabel)
        let spacingAfterTitle: CGFloat = isIpad ? 58 : 32
        stackView.setCustomSpacing(spacingAfterTitle, after: titleLabel)
        stackView.addArrangedSubview(argumentsStackView)
        return stackView
    }()
    
    private lazy var argumentsStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 24
        // We add some inset so that the feature stack view is sligthly smaller than the title and logo
        stackView.isLayoutMarginsRelativeArrangement = true
        let horizontalPadding: CGFloat = isIpad ? 30 : 10
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: horizontalPadding,
            bottom: 0,
            trailing: horizontalPadding
        )
        for argument in config.arguments {
            stackView.addArrangedSubview(getArgumentStackView(argument))
        }
        return stackView
    }()
    
    private func getArgumentStackView(_ argument: String) -> UIStackView {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        let checkmark = UIImageView()
        checkmark.contentMode = .scaleAspectFit
        checkmark.image = UIImage(named: "CheckmarkIcon")?.withRenderingMode(.alwaysTemplate)
        checkmark.tintColor = config.checkmarkColor
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.text = argument
        label.numberOfLines = 0
        
        stackView.addArrangedSubview(checkmark)
        stackView.addArrangedSubview(label)
        return stackView
    }
    
    // Is in the container view at the bottom of the screen
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 14
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(purchaseButton)
        return stackView
    }()
    
    private func setupUI() {
        
        view.addSubview(backgroundOverlay)
        
        backgroundOverlay.fillSuperview()
        
        // BOTTOM VIEW
        // We use a container view so that we can set a background color
        let fixedBottomContainerView = UIView()
        view.addSubview(fixedBottomContainerView)
        fixedBottomContainerView.backgroundColor = config.pageBackgroundColor
        fixedBottomContainerView.addSubview(separatorLineView)
        fixedBottomContainerView.addSubview(bottomStackView)
        
        let horizontalPadding: CGFloat = {
            if isIpad {
                let fixedWidth: CGFloat = 327
                return (view.frame.size.width - fixedWidth) / 2
            } else {
                return 24
            }
        }()
        
        fixedBottomContainerView.layoutMargins = UIEdgeInsets(top: 14, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        
        let bottomPaddingBottomStackView: CGFloat = isIpad ? 24 : 10
        bottomStackView.anchor(top: fixedBottomContainerView.layoutMarginsGuide.topAnchor,
                               left: fixedBottomContainerView.layoutMarginsGuide.leftAnchor,
                               bottom: safeBottomAnchor,
                               right: fixedBottomContainerView.layoutMarginsGuide.rightAnchor,
                               paddingBottom: bottomPaddingBottomStackView)
        
        fixedBottomContainerView.anchor(left: view.leftAnchor,
                                        bottom: view.bottomAnchor,
                                        right: view.rightAnchor)
        
        separatorLineView.anchor(
            top: fixedBottomContainerView.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: 1)
        
        // SCROLLABLE CONTENT
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          bottom: fixedBottomContainerView.topAnchor,
                          right: view.rightAnchor)
        
        scrollView.addSubview(mainStackView)
        mainStackView.fillSuperview()
        mainStackView.equal(width: scrollView.widthAnchor)
    }
    
    private func animateImages() {
        guard let images = config.animationImages, images.count > 1 else {
            return
        }
        
        UIView.transition(
            with: self.logoImageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                let nextIndex = images.indices.contains(self.currentImageIndex + 1) ? self.currentImageIndex + 1 : 0
                self.logoImageView.image = images[nextIndex]
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
    
    private func setupBottomLabel() {
        
        switch config.bottomDisplayType {
        case .noOptions(let textFormat):
            // Will set up the text
            
            guard config.purchaseOption.productType != .lifetime else {
                assertionFailure("Error: looking for a free trial in a lifetime product")
                break
            }
            
            guard let productInformation = config.purchaseOption.productInformation else {
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
            
            let subscriptionPeriodName: String
            switch productInformation.productType {
            case .weeklySubscription:
                subscriptionPeriodName =  "week"
            case .monthlySubscription(let quantity):
                if quantity == 1 {
                    subscriptionPeriodName = "month"
                } else {
                    subscriptionPeriodName = "months"
                }
            case .yearlySubscription:
                subscriptionPeriodName = "year"
            case .oneTimePurchase:
                subscriptionPeriodName = ""
            }
            
            priceLabel.text = textFormat
                .replacingOccurrences(of: "#periodTrial",
                                      with: freeTrialPeriodName.addLetterSIfNeeded(quantity: freeTrialQuantity))
                .replacingOccurrences(of: "#periodSubscription",
                                      with: subscriptionPeriodName)
                .replacingOccurrences(of: "#quantity", with: "\(freeTrialQuantity)")
                .replacingOccurrences(of: "#price", with: productInformation.localizedPrice)
            
        case .freeTrialSwitch:
            // Ignore for now
            break
        }
    }
    
    @objc private func handleRestore() {
        handleUserAction(.restoreTapped)
        restore()
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
