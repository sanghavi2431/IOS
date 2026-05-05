//
//  WolooNavigationRewardModel.swift
//  Woloo
//
//  Created by kapil dongre on 27/11/23.
//

import Foundation

struct wolooNavigationRewardV2: Codable{
    
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        
        case message = "message"
    }
    
}
