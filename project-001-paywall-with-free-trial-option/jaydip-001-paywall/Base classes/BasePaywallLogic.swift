//
//  BasePaywallLogic.swift
//  IndiePurchases
//
//  Created by Kevin Quisquater on 14/02/2021.
//

import UIKit

// Using "IP" prefix for IndiePurchases when it may conflict with our apps' code

// MARK: - Pluralize words (dumb method)

extension String {
    func addLetterSIfNeeded(quantity: Int) -> String {
        if quantity == 1 {
            return self
        }
        return self + "s"
    }
}

// MARK: - GRADIENTS

public typealias IPGradientPoints = (start: CGPoint, end: CGPoint)

public enum IPGradientType {
    case points(points: IPGradientPoints, overlayColors: [UIColor])
    case direction(direction: GradientDirection, overlayColors: [UIColor])
}

// MARK: - PURCHASE OPTION TYPE

public enum IPPurchaseOptionType {
    case lifetime
    case yearly
    case semester // 6 months
    case quarter // 3 months
    case monthly
    case weekly
    
    // nil for lifetime, "week" for week, etc.
    // use for instance to display "$2.99 / week" or "per week"
    #warning("Maybe we would want the possibility to display `semester`, `quarter`, etc? To discuss")
    var periodName: String? {
        switch self {
        case .lifetime:
            return nil
        case .yearly:
            return "year"
        case .semester:
            return "6 months"
        case .quarter:
            return "3 months"
        case .monthly:
            return "month"
        case .weekly:
            return "week"
        }
    }
}

// MARK: - PURCHASE OPTION COMPARISON
// This object contains discounts calculated between prices
// It is not public so no need for a prefix

struct PurchaseOptionComparison {
    
    enum PriceComparisonType {
        case monthlyComparedToWeekly // Will compare the price of monthly compared to (4.33 * the weekly price)
        case yearlyComparedToWeekly // Will compare the yearly price to (52 * the weekly price)
        case yearlyComparedToMonthly // Will compare the yearly price to (12 * the monthly price)
    }
    
    let indexDiscountedProduct: Int // Usually yearly
    let indexExpensiveProduct: Int // Usually monthly
    let stringFormat: String
    let type: PriceComparisonType
    var discountInPercent: Int? // 0 to 100. If value nil, hasn't been calculated yet
    
    var discountHasBeenCalculated: Bool {
        return discountInPercent != nil
    }
}
