//
//  Extensions.swift
//  IndiePurchases
//
//  Created by Edouard Barbier on 28/01/2021.
//

import Foundation
import UIKit

extension UIWindow {
    
    @available(iOS 13.0, *)
    static var isLandscape: Bool {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? false
    }
    
    @available(iOS 13.0, *)
    static var isPortrait: Bool {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isPortrait ?? false
    }
}

extension UIViewController {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        return view.safeAreaLayoutGuide.topAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        return view.safeAreaLayoutGuide.bottomAnchor
    }
    
    var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isSmallDevice: Bool {
        return [1136.0, 1334.0].contains(UIScreen.main.nativeBounds.height)
    }
    
    var isXOrAfter: Bool {
        if let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 {
            return true
        }
        return false
    }
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat = 0,
                height: CGFloat = 0
        ) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    public func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    public func fillSuperviewLayoutMargins() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.layoutMarginsGuide.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.layoutMarginsGuide.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor).isActive = true
        }
    }
    
    public func anchorWithReturnAnchors(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    // Custom by Kevin
    public func anchorCenterX(toView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }
    
    public func anchorCenterY(toView view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }
    
    // From KM
    public func equalWidthToHeight() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0).isActive = true
    }
    
    public func equalHeightToWidth() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
    }
    
    public func equal(width: NSLayoutDimension? = nil, widthMultiplier: CGFloat? = 1.0, height: NSLayoutDimension? = nil, heightMultiplier: CGFloat? = 1.0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier!).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: heightMultiplier!).isActive = true
        }
    }
    
    func scale(values: [Float], duration: Double, repeatsForever: Bool, timingFunctionName: CAMediaTimingFunctionName = .linear) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale.xy")
        animation.timingFunction = CAMediaTimingFunction(name: timingFunctionName)
        animation.duration = duration
        animation.values = values
        animation.repeatCount = repeatsForever ? Float.infinity : 1
        layer.add(animation, forKey: "scale")
    }
    
    func dropShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


extension UIButton {
    public func applyShrinkOnTap() {
        addTapTargets()
    }
    
    private func addTapTargets() {
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        addTarget(self, action: #selector(touchDown), for: .touchDown)
    }
    
    @objc private func touchUp() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.9,
            options: [],
            animations: {
                self.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        })
    }
    
    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.layer.transform = CATransform3DMakeScale(0.98, 0.98, 1.0);
        })
    }
}

// MARK: UIColor
extension UIColor {
    
    static let lightGrayBackground  = UIColor(hex: "F5F5F5")
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    // https://crunchybagel.com/working-with-hex-colors-in-swift-3/
    public convenience init(hex: String, alpha: CGFloat = 1) {
        
        var hex = hex
        if hex.starts(with: "#") {
            hex = String(hex.dropFirst())
        }
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
}

extension CALayer {
    
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension String {
    
    func toNSAttStringWith(size: CGFloat, weight: UIFont.Weight, textColor: UIColor, extraAttributes: [NSAttributedString.Key : NSObject] = [:]) -> NSAttributedString {
        var attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: weight), NSAttributedString.Key.foregroundColor: textColor]
        for extra in extraAttributes {
            attributes[extra.key] = extra.value
        }
        return NSAttributedString(string: self, attributes: attributes)
        
    }
}

extension Array where Element: NSAttributedString {
    
    func concat() -> NSMutableAttributedString {
        let final = NSMutableAttributedString()
        for att in self {
            final.append(att)
        }
        return final
    }
}

public extension Date {
    func toString(dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

public enum DateFormat: String {
    case yyyyMMdd = "yyyy-MM-dd"
    case MMMddyyyy = "MMM dd, yyyy"
    case fullDateAccurateTiming = "yyyy-MM-dd HH:mm:ss"
    case iSO8601Format = "yyyy-MM-dd'T'HH:mm:ssZ"
}

extension String {
    func attributedStringWithHighlights(stringsToHighlight: [String], highlightColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in stringsToHighlight {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: highlightColor, range: range)
        }
        return attributedString
    }
}
