//
//  GetPlanModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/04/23.
//

import Foundation

struct GetPlanModel: Codable, Hashable {
    
    let id: Int?
    let name: String?
    let description: String?
    let frequency: String?
    let days: Int?
    let image: String?
    let price: String?
    let discount: String?
    let is_expired: Int?
    let status: Int?
    let created_at: String?
    let updated_at: String?
    let deleted_at: String?
    let plan_id: String?
    let currency: String?
    let is_voucher: Int?
    let backgroud_color: String?
    let text_color: String?
    let shield_color: String?
    let is_recommended: Int?
    let before_discount_price: Int?
    let price_with_gst: String?
    let apple_product_id: String?
    let apple_product_price: String?
    let is_insurance_available: Int?
    let insurance_desc: String?
    let end_at: String?
    let strike_out_price: Int?
    let start_at: String?
    
    enum CodingKeys: String, CodingKey{
        
        case id = "id"
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
        case text_color = "text_color"
        case shield_color = "shield_color"
        case is_recommended = "is_recommended"
        case before_discount_price = "before_discount_price"
        case price_with_gst = "price_with_gst"
        case apple_product_id = "apple_product_id"
        case apple_product_price = "apple_product_price"
        case is_insurance_available = "is_insurance_available"
        case insurance_desc = "insurance_desc"
        case end_at = "end_at"
        case strike_out_price = "strike_out_price"
        case start_at = "start_at"
    }
    
}
