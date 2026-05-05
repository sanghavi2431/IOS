//
//  CreateCart.swift
//  Woloo
//
//  Created by CEPL on 25/03/25.
//

import Foundation

class CreateCart: Codable{
    
    var cart: CreateCartDetails?
   
}

     
class CreateCartDetails: Codable{
    var id: String? = ""
    var currency_code: String? = ""
    var email: String? = ""
    var region_id: String? = ""
    var created_at: String? = ""
    var updated_at: String? = ""
    var total: Double?
    var subtotal: Double?
    var tax_total: Double?
    var discount_total: Double?
    var discount_subtotal: Double?
    var discount_tax_total: Double?
    var original_total: Double?
    var original_tax_total: Double?
    var item_total: Double?
    var item_subtotal: Double?
    var item_tax_total: Double?
    var original_item_total: Double?
    var original_item_subtotal: Double?
    var original_item_tax_total: Double?
    var shipping_total: Double?
    var shipping_subtotal: Double?
    var shipping_tax_total: Double?
    var original_shipping_tax_total: Double?
    var original_shipping_subtotal: Double?
    var original_shipping_total: Double?
    var credit_lines_subtotal: Double?
    var credit_lines_tax_total: Double?
    var credit_lines_total: Double?
   // var metadata
    var sales_channel_id: String? = ""
    var shipping_address_id: String? = ""
   // var customer_id
    var items: [CartItems]?
    var shipping_address: StoreAddress?
    var billing_address: StoreAddress?
    var promotions: [Promotions]?

    //App use
    var deliveryCharges: Double?
}


class Promotions: Codable{
    var id: String? = ""
    var code: String? = ""
    var is_automatic: Bool? = false
    
}
