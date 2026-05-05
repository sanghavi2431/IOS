//
//  PaymentSessions.swift
//  Woloo
//
//  Created by CEPL on 02/04/25.
//

import Foundation

class PaymentSessions: Codable{
    
    var id: String? = ""
    var currency_code: String? = ""
    
    var data: PaymentSessionData?
}   

class PaymentSessionData: Codable{
    var id: String? = ""
}
