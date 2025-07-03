//
//  Coupons.swift
//  Woloo
//
//  Created by Rahul Patra on 28/08/21.
//

import Foundation

// MARK: - Coupon
class Coupon: Codable {
    let id, couponCode, title, couponDescription: String?
    let value, valueUnit, startDate, endDate: String?
    let categoryIDS, vendorsIDS, productIDS, dateTime: String?
    let status: String?
    
    var getProductsIds: [String] {
        get {
            productIDS?.components(separatedBy: ",") ?? []
        }
    }
    
    var getCategoriesIds: [String] {
        get {
            categoryIDS?.components(separatedBy: ",") ?? []
        }
    }
    
    var getVendorsIDS: [String] {
        get {
            vendorsIDS?.components(separatedBy: ",") ?? []
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case couponCode = "coupon_code"
        case title
        case couponDescription = "description"
        case value
        case valueUnit = "value_unit"
        case startDate = "start_date"
        case endDate = "end_date"
        case categoryIDS = "category_ids"
        case vendorsIDS = "vendors_ids"
        case productIDS = "product_ids"
        case dateTime = "date_time"
        case status
    }

    init(id: String?, couponCode: String?, title: String?, couponDescription: String?, value: String?, valueUnit: String?, startDate: String?, endDate: String?, categoryIDS: String?, vendorsIDS: String?, productIDS: String?, dateTime: String?, status: String?) {
        self.id = id
        self.couponCode = couponCode
        self.title = title
        self.couponDescription = couponDescription
        self.value = value
        self.valueUnit = valueUnit
        self.startDate = startDate
        self.endDate = endDate
        self.categoryIDS = categoryIDS
        self.vendorsIDS = vendorsIDS
        self.productIDS = productIDS
        self.dateTime = dateTime
        self.status = status
    }
}

typealias Coupons = [Coupon]
