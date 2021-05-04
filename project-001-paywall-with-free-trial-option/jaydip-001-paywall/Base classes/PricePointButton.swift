//
//  PricePointButton.swift
//  IndiePurchases
//
//  Created by Edouard Barbier on 01/02/2021.
//

import Foundation
import UIKit

public class PricePointButton: UIButton {
    
    // ———————————————————
    // MARK: Initializers
    // ———————————————————
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //––––––––––––––––––––––———
    // MARK: - Variables
    //––––––––––––––––––––––———
        
    private var selectedBackgroundColor = UIColor.black
    private var unselectedBackgroundColor = UIColor.black.withAlphaComponent(0.15)
    
    
    var isOptionSelected = false {
        didSet {
            guard isOptionSelected != oldValue else {
                return
            }
            toggleLayout()
        }
    }
    
    // ———————————————————
    // MARK: Setup UI
    // ———————————————————
    
    func set(selectedBackgroundColor: UIColor) {
        self.selectedBackgroundColor = selectedBackgroundColor
    }
    
    let selectedIcon: UIImage? = {
       
        if #available(iOS 13, *) {
            return UIImage(systemName: "smallcircle.fill.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
        } else {
            return UIImage(named: "selected-circle")
        }
    }()
        
    let unselectedIcon: UIImage? = {
       
        if #available(iOS 13, *) {
            return UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold))?.withTintColor(UIColor.white.withAlphaComponent(0.6), renderingMode: .alwaysTemplate)
        } else {
            return UIImage(named: "unselected-circle")
        }
        
    }()
        
        
       
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = false
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "..."
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.3
        lbl.numberOfLines = 2
        lbl.textColor = .white
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    
    let rightDetailLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.3
        lbl.numberOfLines = 2
        lbl.textColor = .white
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    
    func setupUI() {
        
        backgroundColor = unselectedBackgroundColor
    
        let stackView = UIStackView(arrangedSubviews: [priceLabel, rightDetailLbl])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false

            
        addSubview(icon)
        addSubview(stackView)
        
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 12).isActive = true
        icon.heightAnchor.constraint(equalTo: icon.widthAnchor).isActive = true
        
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        layer.applySketchShadow(color: .black, alpha: 0.2, x: 0, y: 1, blur: 3, spread: 0)
        
        layer.cornerRadius = 8
        
        applyShrinkOnTap()
    }
    
    func setup(isPreSelected: Bool = false, localizedPrice: String, period: String? = nil, details: String?) {
        
        backgroundColor = isPreSelected ? selectedBackgroundColor : unselectedBackgroundColor
        icon.image = isPreSelected ? selectedIcon : unselectedIcon
        icon.tintColor = isPreSelected ? UIColor.white : UIColor.white.withAlphaComponent(0.6)
        
        if let period = period {
            priceLabel.text = "\(localizedPrice) / \(period)"
            
        } else {
            priceLabel.text = "\(localizedPrice)"
        }
        
        rightDetailLbl.text = details
        
        isOptionSelected = isPreSelected
        
    }
    
    func toggleLayout() {
        
        backgroundColor = isOptionSelected ? selectedBackgroundColor : unselectedBackgroundColor
        icon.image = isOptionSelected ? selectedIcon : unselectedIcon
        icon.tintColor = isOptionSelected ? UIColor.white : UIColor.white.withAlphaComponent(0.6)
        
        priceLabel.alpha = isOptionSelected ? 1 : 0.6
        rightDetailLbl.alpha = isOptionSelected ? 1 : 0.6
        
        priceLabel.font = .systemFont(ofSize: 18, weight: isOptionSelected ? .bold : .regular)
        rightDetailLbl.font = .systemFont(ofSize: 18, weight: isOptionSelected ? .bold : .regular)
    }
        
}
