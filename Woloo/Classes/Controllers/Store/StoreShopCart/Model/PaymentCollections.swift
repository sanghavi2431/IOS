//
//  PaymentCollections.swift
//  Woloo
//
//  Created by CEPL on 02/04/25.
//

import Foundation

class PaymentCollectionsWrapper: Codable{
    
    var payment_collection: PaymentCollections?
    

    
}
class PaymentCollections: Codable{
    
  
    
    var id: String? = ""
    var currency_code: String? = ""
    var amount: Int?
    var payment_sessions: [PaymentSessions]?
    
}
