//
//  InitSubscriptionByOrderModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 19/04/23.
//

import Foundation

struct InitSubscriptionByOrderModel: Codable {
    
    let subscription_id: String?
    
    enum CodingKeys: String, CodingKey{
        
        case subscription_id = "subscription_id"
    }
}
