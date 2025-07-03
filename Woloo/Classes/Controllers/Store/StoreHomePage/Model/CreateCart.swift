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
    var subtotal: Int?
    var tax_total: Int?
    var discount_total: Int?
    var discount_subtotal: Int?
    var discount_tax_total: Int?
    var original_total: Int?
    var original_tax_total: Int?
    var item_total: Double?
    var item_subtotal: Int?
    var item_tax_total: Int?
    var original_item_total: Int?
    var original_item_subtotal: Int?
    var original_item_tax_total: Int?
    var shipping_total: Int?
    var shipping_subtotal: Int?
    var shipping_tax_total: Int?
    var original_shipping_tax_total: Int?
    var original_shipping_subtotal: Int?
    var original_shipping_total: Int?
    var credit_lines_subtotal: Int?
    var credit_lines_tax_total: Int?
    var credit_lines_total: Int?
   // var metadata
    var sales_channel_id: String? = ""
    var shipping_address_id: String? = ""
   // var customer_id
    var items: [CartItems]?
    var shipping_address: StoreAddress?
    var billing_address: StoreAddress?

    //App use
    var deliveryCharges: Double?
}
