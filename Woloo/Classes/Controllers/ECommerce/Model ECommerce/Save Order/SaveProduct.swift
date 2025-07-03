//
//  SaveProduct.swift
//  Woloo
//
//  Created by Rahul Patra on 12/08/21.
//

import Foundation



//
//struct FinalSaveProduct: Codable {
//    let order: [Order]?
//    let order_product: [SaveProduct]?
//}

// MARK: - FinalSaveProduct
//struct FinalSaveProduct: Codable {
//    let order: [Order]?
//    let orderProduct: [SaveProduct]?
//
//    enum CodingKeys: String, CodingKey {
//        case order
//        case orderProduct = "order_product"
//    }
//}
//
//// MARK: - Order
//struct Order: Codable {
//    let address, couponCode, couponDiscount, email: String?
//    let giftCardUsedValue, mobile, name, shippingCharges: String?
//    let totalAmount, userID, userType: String?
//
//    enum CodingKeys: String, CodingKey {
//        case address
//        case couponCode = "coupon_code"
//        case couponDiscount = "coupon_discount"
//        case email
//        case giftCardUsedValue = "gift_card_used_value"
//        case mobile, name
//        case shippingCharges = "shipping_charges"
//        case totalAmount = "total_amount"
//        case userID = "user_id"
//        case userType = "user_type"
//    }
//}
//
//// MARK: - OrderProduct
//struct SaveProduct: Codable {
//    let amount, customerMarginPer, pointUsed, price: String?
//    let proID, proName, qty: String?
//
//    enum CodingKeys: String, CodingKey {
//        case amount
//        case customerMarginPer = "customer_margin_per"
//        case pointUsed = "point_used"
//        case price
//        case proID = "pro_id"
//        case proName = "pro_name"
//        case qty
//    }
//}

// MARK: - FinalSaveProduct
struct FinalSaveProduct: Codable {
    let order: [Order]?
    let orderProduct: [SaveProduct]?

    enum CodingKeys: String, CodingKey {
        case order
        case orderProduct = "order_product"
    }
}

// MARK: - Order
struct Order: Codable {
    let userID, name, totalAmount, address: String?
    let email, mobile, shippingCharges, userType: String?
    let giftCardUsedValue, couponCode: String?
    let couponDiscount: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name
        case totalAmount = "total_amount"
        case address, email, mobile
        case shippingCharges = "shipping_charges"
        case userType = "user_type"
        case giftCardUsedValue = "gift_card_used_value"
        case couponCode = "coupon_code"
        case couponDiscount = "coupon_discount"
    }
}

// MARK: - OrderProduct
struct SaveProduct: Codable {
    let proID, proName, qty, price: String?
    let customerMarginPer, pointUsed, amount: String?

    enum CodingKeys: String, CodingKey {
        case proID = "pro_id"
        case proName = "pro_name"
        case qty, price
        case customerMarginPer = "customer_margin_per"
        case pointUsed = "point_used"
        case amount
    }
}
