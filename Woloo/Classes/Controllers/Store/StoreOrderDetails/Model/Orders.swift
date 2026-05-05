//
//  Orders.swift
//  Woloo
//
//  Created by CEPL on 21/05/25.
//

import Foundation

class Orders: Codable{
    
    
    var customer_id: String? = ""
    var id: String? = ""
    var currency_code: String? = ""
    var email: String? = ""
    var created_at: String? = ""
    var updated_at: String? = ""
    var status: String? = ""
    var total: Double?
    var subtotal: Double?
    var tax_total: Double?
    var discount_total: Double?
    var discount_tax_total: Double?
    var original_total:Double?
    var original_tax_total: Double?
    var item_total: Double?
    var item_subtotal: Double?
    var item_tax_total: Double?
    var sales_channel_id: String? = ""
    var original_item_total: Double?
    var original_item_subtotal: Double?
    var original_item_tax_total: Double?
    var shipping_total: Double?
    var shipping_subtotal: Double?
    var shipping_tax_total: Double?
    var items: [OrderItem]?
    var fulfillment_status: String? = ""
    var payment_status: String? = ""
    
}
