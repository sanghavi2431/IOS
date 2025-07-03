//
//  PaymentProviders.swift
//  Woloo
//
//  Created by CEPL on 02/04/25.
//

import Foundation

class PaymentProviderWrapper: Codable{
    
    var payment_providers: [PaymentProviders]?
    var count: Int?
    var offset: Int?
    var limit: Int?
}

class PaymentProviders: Codable{
    
    var id: String? = ""
    var is_enabled: Bool? = false
}
