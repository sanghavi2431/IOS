//
//  StatusSuccessResponseModel.swift
//  Woloo
//
//  Created by kapil dongre on 09/11/23.
//

import Foundation

struct StatusSuccessResponseModel: Codable {
    
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        
        case message = "message"
    }
}
