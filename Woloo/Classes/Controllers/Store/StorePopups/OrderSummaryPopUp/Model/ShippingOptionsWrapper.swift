//
//  ShippingOptionsWrapper.swift
//  Woloo
//
//  Created by CEPL on 01/04/25.
//

import Foundation

class ShippingOptionsWrapper: Codable{
    
    var shipping_options: [ShippingOptions]?
    
}

class ShippingOptions: Codable{
    
    var id: String? = ""
    var name: String? = ""
    var price_type: String? = ""
    var service_zone_id: String? = ""
    var shipping_profile_id: String? = ""
    var provider_id: String? = ""
//    var shipping_option_type_id: String? = ""
//    var calculated_price: CalculatedPrice?
    var amount: Double?
//    var is_tax_inclusive: Bool? = false
    
}


