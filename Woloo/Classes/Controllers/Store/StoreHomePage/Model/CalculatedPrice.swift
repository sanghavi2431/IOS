//
//  CalculatedPrice.swift
//  Woloo
//
//  Created by CEPL on 02/04/25.
//

import Foundation

class CalculatedPrice: Codable{
    
    var id: String? = ""
    var is_calculated_price_price_list: Bool? = false
    var is_calculated_price_tax_inclusive: Bool? = false
    var calculated_amount: Int?
    var is_original_price_price_list: Bool? = false
    var is_original_price_tax_inclusive: Bool? = false
    var original_amount: Int?
    
}
