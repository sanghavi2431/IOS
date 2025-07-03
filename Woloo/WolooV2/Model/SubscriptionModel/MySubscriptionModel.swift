//
//  MySubscriptionModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 19/04/23.
//

import Foundation

struct MySubscriptionModel: Codable, Hashable {
    
    var activeSubscription: GetPlanModel?
    var futureSubscription: [GetPlanModel]?
    var purchase_by: String?
    
    enum CodingKeys: String, CodingKey{
        
        case activeSubscription = "activeSubscription"
        case futureSubscription = "futureSubscription"
        case purchase_by = "purchase_by"
    }
    
    
    struct ActiveSubscription: Codable, Hashable{
        
        var id: Int?
        var name: String?
        var description: String?
        var frequency: String?
        var days: Int?
        var image: String?
        var price: String?
        var discount: String?
        var is_expired: Int?
        var status: Int?
        var created_at: String?
        var updated_at: String?
        var deleted_at: String?
        var plan_id: String?
        var currency: String?
        var is_voucher: Int?
        var backgroud_color: String?
        var shield_color: String?
        var is_recommended: Int?
        var before_discount_price: Int?
        var price_with_gst: String?
        var apple_product_id: String?
        var apple_product_price: String?
        var is_insurance_available: Int?
        var insurance_desc: String?
        var strike_out_price: Int?
        var start_at: String?
        var end_at: String?
        
        enum CodingKeys: String, CodingKey{
            
            case id  = "id"
            case name = "name"
            case description = "description"
            case frequency = "frequency"
            case days = "days"
            case image = "image"
            case price = "price"
            case discount = "discount"
            case is_expired = "is_expired"
            case status = "status"
            case created_at = "created_at"
            case updated_at = "updated_at"
            case deleted_at = "deleted_at"
            case plan_id = "plan_id"
            case currency = "currency"
            case is_voucher = "is_voucher"
            case backgroud_color = "backgroud_color"
            case shield_color = "shield_color"
            case is_recommended = "is_recommended"
            case before_discount_price = "before_discount_price"
            case price_with_gst = "price_with_gst"
            case apple_product_id = "apple_product_id"
            case apple_product_price = "apple_product_price"
            case is_insurance_available = "is_insurance_available"
            case insurance_desc = "insurance_desc"
            case strike_out_price = "strike_out_price"
            case start_at = "start_at"
            case end_at = "end_at"
            
        }
    }
    
    struct FutureSubscription: Codable, Hashable{
        var id: Int?
        var name: String?
        var description: String?
        var frequency: String?
        var days: Int?
        var image: String?
        var price: String?
        var discount: String?
        var is_expired: Int?
        var status: Int?
        var created_at: String?
        var updated_at: String?
        var deleted_at: String?
        var plan_id: String?
        var currency: String?
        var is_voucher: Int?
        var backgroud_color: String?
        var shield_color: String?
        var is_recommended: Int?
        var before_discount_price: Int?
        var price_with_gst: String?
        var apple_product_id: String?
        var apple_product_price: String?
        var is_insurance_available: Int?
        var insurance_desc: String?
        var strike_out_price: Int?
        var start_at: String?
        var end_at: String?
        
        
        
        enum CodingKeys: String, CodingKey{
            
            case id  = "id"
            case name = "name"
            case description = "description"
            case frequency = "frequency"
            case days = "days"
            case image = "image"
            case price = "price"
            case discount = "discount"
            case is_expired = "is_expired"
            case status = "status"
            case created_at = "created_at"
            case updated_at = "updated_at"
            case deleted_at = "deleted_at"
            case plan_id = "plan_id"
            case currency = "currency"
            case is_voucher = "is_voucher"
            case backgroud_color = "backgroud_color"
            case shield_color = "shield_color"
            case is_recommended = "is_recommended"
            case before_discount_price = "before_discount_price"
            case price_with_gst = "price_with_gst"
            case apple_product_id = "apple_product_id"
            case apple_product_price = "apple_product_price"
            case is_insurance_available = "is_insurance_available"
            case insurance_desc = "insurance_desc"
            case strike_out_price = "strike_out_price"
            case start_at = "start_at"
            case end_at = "end_at"
            
        }
    }
}
