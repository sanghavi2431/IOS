//
//  OrderSets.swift
//  Woloo
//
//  Created by CEPL on 16/05/25.
//

import Foundation

class OrderSets: Codable{
  
    var id: String? = ""
    var updated_at: String? = ""
    var created_at: String? = ""
    var display_id: String? = ""
    var customer_id: String? = ""
    var cart_id: String? = ""
    var payment_collection_id: String? = ""
    //var customer
    //var cart
    //var payment_collection
    var orders: [Orders]?
    var status: String? = ""
    var payment_status: String? = ""
    var fulfillment_status: String? = ""
    var tax_total: Int?
    var shipping_tax_total: Int?
    var shipping_total: Int?
    var total: Int?
    var subtotal: Int?
}




