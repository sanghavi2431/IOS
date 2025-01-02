//
//  InviteModel.swift
//  Woloo
//
//  Created by kapil dongre on 20/11/23.
//

import Foundation
struct InviteModel: Codable{
    
    var MESSAGE: String?
    
    enum CodingKeys: String, CodingKey {
        
        case MESSAGE = "message"
    }
    
}
