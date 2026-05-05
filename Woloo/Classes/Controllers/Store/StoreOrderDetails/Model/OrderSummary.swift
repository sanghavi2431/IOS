//
//  OrderSummary.swift
//  Woloo
//
//  Created by CEPL on 02/04/25.
//

import Foundation

class OrderSummary: Codable{
    
    var paid_total: Int?
    var difference_sum: Int?
    var refunded_total: Int?
    var accounting_total: Int?
    var credit_line_total: Int?
    var transaction_total: Int?
    var pending_difference: Int?
    var current_order_total: Int?
    var original_order_total: Int?
}
