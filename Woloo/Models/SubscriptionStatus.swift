//
//  SubscriptionStatus.swift
//  Woloo
//
//  Created by ideveloper1 on 21/04/21.
//

import Foundation
import ObjectMapper

struct SubscriptionStatusResponse: Mappable {
    var status : Status?
    var message : String?
    var userData: UserModel?
    var planData: PlanData?

    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        userData <- map["userData"]
        planData <- map["planData"]
    }
}

struct PlanData: Mappable {
    var id: Int?
    var name: String?
    var description: String?
    var currency: String?
    var planId: Int?
    var frequency: String?
    var days: Int?
    var status: Int?
    var image: String?
    var price: String?
    var discount: String?
    var isExpired: Int?
    var createdAt: String?
    var updatedAt: String?
    var deletedAt: String?
    var isVoucher: String?
    var backgroudColor: String?
    var shieldColor: String?
    var isRecommended: String?
    var beforeDiscountPrice: String?
    var priceWithGst: String?
    var isCancel: Bool? = false
    
    init() { }
    
    init?(map: Map) { }
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        currency <- map["currency"]
        isExpired <- map["is_expired"]
        planId <- map["plan_id"]
        frequency <- map["frequency"]
        status <- map["status"]
        days <- map["days"]
        image <- map["image"]
        price <- map["price"]
        discount <- map["discount"]
        isExpired <- map["is_expired"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        deletedAt <- map["deleted_at"]
        isVoucher <- map["is_voucher"]
        backgroudColor <- map["backgroud_color"]
        shieldColor <- map["shield_color"]
        isRecommended <- map["is_recommended"]
        beforeDiscountPrice <- map["before_discount_price"]
        priceWithGst <- map["price_with_gst"]
        isCancel <- map["is_cancel"]
   }
}

class AppleTransactionUserCheckResponse: Mappable {
    var status : Status?
    var message : String?
    var allowUser : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        allowUser <- map["allowUser"]
    }
}

