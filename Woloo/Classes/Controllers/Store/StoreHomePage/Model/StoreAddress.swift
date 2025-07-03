//
//  StoreAddress.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import Foundation

class StoreAddress: Codable{
    
    var id: String? = ""
    var address_name: String? = ""
    var is_default_shipping: Bool? = false
    var is_default_billing: Bool? = false
    var company: String? = ""
    var first_name: String? = ""
    var last_name: String? = ""
    var address_1: String? = ""
    var address_2: String? = ""
    var city: String? = ""
    var country_code: String? = ""
    var province: String? = ""
    var postal_code: String? = ""
    var phone: String? = ""
    //var metadata
    var customer_id: String? = ""
    var created_at: String? = ""
    var updated_at: String? = ""
    var deleted_at: String? = ""
    
    //App use
    var isSelected: Bool? = false
}

