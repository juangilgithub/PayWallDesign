//
//  GradientView.swift
//  IndiePurchases
//
//  Created by Edouard Barbier on 02/02/2021.
//

import Foundation
import UIKit

public enum GradientDirection {
    case topBottom
    case bottomTop
    case leftRight
    case rightLeft
    case topLeftBottomRight
    case topRightBottomLeft
    case bottomLeftTopRight
    case bottomRightTopLeft
}

extension GradientDirection: RawRepresentable {
    
    public typealias RawValue = (startPoint: CGPoint, endPoint: CGPoint)
    
    public init?(rawValue: (startPoint: CGPoint, endPoint: CGPoint)) {
        return nil
    }
    
    public var rawValue: (startPoint: CGPoint, endPoint: CGPoint) {
        switch self {
        case .topBottom:
            return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
        case .bottomTop:
            return (CGPoint(x: 0.5, y: 1.0), CGPoint(x: 0.5, y: 0.0))
        case .leftRight:
            return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        case .rightLeft:
            return (CGPoint(x: 1.0, y: 0.5), CGPoint(x: 0.0, y: 0.5))
        case .topLeftBottomRight:
            return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0))
        case .topRightBottomLeft:
            return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        case .bottomLeftTopRight:
            return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
        case .bottomRightTopLeft:
            return (CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0))
        }
    }
}

public class GradientView: UIView {
    
    var needsDropShadow = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        if needsDropShadow {
            self.dropShadow(offsetX: 0, offsetY: 0, color: .black, opacity: 0.3, radius: 2)
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        return gradientLayer
    }()
    
    // ––––––––––––––––
    // MARK: Colors
    // ––––––––––––––––
    
    var colors: [UIColor] = [] {
            didSet {
                gradientLayer.colors = colors.map{$0.cgColor}
                setNeedsDisplay()
            }
        }
    
    // ––––––––––––––––
    // MARK: Direction
    // ––––––––––––––––
    
    var direction: GradientDirection = .topBottom {
        didSet {
            gradientLayer.startPoint = direction.rawValue.startPoint
            gradientLayer.endPoint = direction.rawValue.endPoint
            setNeedsDisplay()
        }
    }
    
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0) {
        didSet {
            gradientLayer.startPoint = startPoint
            setNeedsDisplay()
        }
    }
    
    var endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0) {
        didSet {
            gradientLayer.endPoint = endPoint
            setNeedsDisplay()
        }
    }
    
    //––––––––––––––––––––––———
    // MARK: - Refresh
    //––––––––––––––––––––––———
    
    func refresh() {
        gradientLayer.setNeedsDisplay()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            
            if #available(iOS 13.0, *) {
                if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                    gradientLayer.colors = colors.map{$0.cgColor}
                    setNeedsDisplay()
                }
            }
        }
}

