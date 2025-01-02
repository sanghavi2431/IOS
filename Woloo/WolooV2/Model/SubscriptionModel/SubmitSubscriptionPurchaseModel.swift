//
//  SubmitSubscriptionPurchase.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/04/23.
//

import Foundation

struct SubmitSubscriptionPurchaseModel: Codable{
    
    var message: String?
    
    enum CodingKeys:  String, CodingKey{
        
        case message = "message"
    }
    
    
}
