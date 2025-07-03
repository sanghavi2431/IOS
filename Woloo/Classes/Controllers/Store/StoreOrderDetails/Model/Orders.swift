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
    var total: Int?
    var subtotal: Int?
    var tax_total: Int?
    var discount_total: Int?
    var discount_tax_total: Int?
    var original_total:Int?
    var original_tax_total: Int?
    var item_total: Int?
    var item_subtotal: Int?
    var item_tax_total: Int?
    var sales_channel_id: String? = ""
    var original_item_total: Int?
    var original_item_subtotal: Int?
    var original_item_tax_total: Int?
    var shipping_total: Int?
    var shipping_subtotal: Int?
    var shipping_tax_total: Int?
    var items: [OrderItem]?
    
}
