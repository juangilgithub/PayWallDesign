//
//  ProductInformation.swift
//  IndiePurchases
//
//  Created by Edouard Barbier on 29/01/2021.
//

import Foundation

public enum ProductType {
    case oneTimePurchase
    case yearlySubscription
    case monthlySubscription(quantity: Int)
    case weeklySubscription
}

public struct ProductInformation: Equatable {

    let productId: String
    let productType: ProductType
    let price: NSDecimalNumber
    let priceLocale: Locale
    let localizedPrice: String
    let freeTrial: FreeTrialInformation?
    
    public static func == (lhs: ProductInformation, rhs: ProductInformation) -> Bool {
        return lhs.productId == rhs.productId
    }
    
}

public enum FreeTrialInformation {
    case day(quantity: Int)
    case week(quantity: Int)
    case month(quantity: Int)
    case year(quantity: Int)
}
