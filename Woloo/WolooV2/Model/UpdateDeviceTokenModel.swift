//
//  UpdateDeviceTokenModel.swift
//  Woloo
//
//  Created by kapil dongre on 07/11/23.
//

import Foundation

struct UpdateDeviceTokenModel: Codable{
    
    var message: String?
    
    enum CodingKeys: String, CodingKey{
        
        case message = "message"
    }
    
}
