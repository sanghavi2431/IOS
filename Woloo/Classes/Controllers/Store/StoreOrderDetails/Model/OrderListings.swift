//
//  OrderListings.swift
//  Woloo
//
//  Created by CEPL on 02/04/25.
//

import Foundation

class OrderListings: Codable{
    
    var id: String? = ""
    var status: String? = ""
    var summary: OrderSummary?
    var items: [Products]?
    var payment_status: String? = ""
    var fulfillment_status: String? = ""
}
