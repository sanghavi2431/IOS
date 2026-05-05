//
//  ShippingCharges.swift
//  Woloo
//
//  Created by Rahul Patra on 09/08/21.
//

import Foundation

// MARK: - ShippingCharge
class ShippingCharge: Codable {
    let id, shippingCharges, freeShippingAbove, dateTime: String?
    let status: String?
    
    var getDoubleValuePrice: Double {
        get {
            Double(shippingCharges ?? "0") ?? 0.0
        }
    }
    
    func getShippingChargesprice(withfinalPrice price: Double) -> Double {
        if price >= Double(freeShippingAbove ?? "0") ?? 0.0 {
            return 0.0
        } else {
            return Double("\(shippingCharges ?? "0")") ?? 0.0
        }
    }

    func getShippingCharges(withfinalPrice price: Double) -> String {
        if price >= Double(freeShippingAbove ?? "0") ?? 0.0 {
            return "Free"
        } else {
            return "Rs. \(shippingCharges ?? "0")"
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case shippingCharges = "shipping_charges"
        case freeShippingAbove = "free_shipping_above"
        case dateTime = "date_time"
        case status
    }

    init(id: String?, shippingCharges: String?, freeShippingAbove: String?, dateTime: String?, status: String?) {
        self.id = id
        self.shippingCharges = shippingCharges
        self.freeShippingAbove = freeShippingAbove
        self.dateTime = dateTime
        self.status = status
    }
}

typealias ShippingCharges = [ShippingCharge]
