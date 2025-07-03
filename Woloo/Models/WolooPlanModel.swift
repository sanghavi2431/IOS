//
//  WolooPlanModel.swift
//  Woloo
//
//  Created on 26/04/21.
//


import UIKit
import ObjectMapper

struct WolooPlanResponse :Mappable {
    
    var plans: [WolooPlanModel]?
    var status : Status?
    var message : String?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        plans <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }
}

struct MySubscriptionPlan: Mappable {
    var activeSubscription: WolooPlanModel?
    var futureSubscription: WolooPlanModel?
    var purchaseBy: String?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        activeSubscription <- map["activeSubscription"]
        futureSubscription <- map["futureSubscription"]
        purchaseBy  <- map["purchase_by"]
    }
}

struct WolooPlanModel: Mappable {
    var pid: Int?
    var name: String?
    var wdescription: String?
    var frequency: String?
    var days: Int?
    var image: String?
    var price: String?
    var applePrice: String?
    var discount: String?
    var is_expired: Int?
    var status: Int?
    var planId: String?
    var currency: String?
    var isVoucher: Int?
    var backgroundColor: String?
    var shieldColor: String?
    var isRecommended: Int?
    var beforeDiscountPrice: Int?
    var corporationName: String?
    var appleProductId: String?
    var endAt: String?
    var strikeOutPrice: Int?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        pid             <- map["id"]
        name            <- map["name"]
        wdescription     <- map["description"]
        frequency       <- map["frequency"]
        days            <- map["days"]
        image           <- map["image"]
        price           <- map["price"]
        applePrice      <- map["apple_product_price"]
        discount        <- map["discount"]
        is_expired      <- map["is_expired"]
        status          <- map["status"]
        planId          <- map["plan_id"]
        currency        <- map["currency"]
        isVoucher       <- map["is_voucher"]
        backgroundColor <- map["backgroud_color"]
        shieldColor     <- map["shield_color"]
        isRecommended   <- map["is_recommended"]
        beforeDiscountPrice  <- map["before_discount_price"]
        corporationName  <- map["corporate_name"]
        appleProductId  <- map["apple_product_id"]
        endAt <- map["end_at"]
        strikeOutPrice <- map["strike_out_price"]
   }
}

// MARK: - Transport mode
enum TransportMode: Int, Codable {
    case car
    case walking
    case bicycle
    
    var fillImage: UIImage {
        switch self {
        case .car:
            return #imageLiteral(resourceName: "fillCar")
        case .bicycle:
            return #imageLiteral(resourceName: "fillBicycle")
        case .walking:
            return #imageLiteral(resourceName: "fillWalk")
        }
    }
    
    var unfillImage: UIImage {
        switch self {
        case .car:
            return #imageLiteral(resourceName: "unfillCar")
        case .bicycle:
            return #imageLiteral(resourceName: "unfillBicycle")
        case .walking:
            return #imageLiteral(resourceName: "unfillWalk")
        }
    }
    var whiteImage: UIImage {
        switch self {
        case .car:
            return #imageLiteral(resourceName: "ic_car")
        case .bicycle:
            return UIImage(named: "ic_cycle") ?? #imageLiteral(resourceName: "ic_car")
        case .walking:
            return UIImage(named: "ic_man") ?? #imageLiteral(resourceName: "ic_car")
        }
    }
    var name: String {
        switch self {
        case .car:
            return "driving"
        case .bicycle:
            return "bicycle"
        case .walking:
            return "walking"
        }
    }
    var googleAPIValue: String {
        switch self {
        case .car:
            return "driving"
        case .bicycle:
            return "Bicycling"
        case .walking:
            return "Driving"
        }
    }
}

enum TransportType: String{
    case CAR
    case WALK
}
