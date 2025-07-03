//
//  wolooGuestModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 16/03/23.
//

import Foundation

struct WolooGuestModel: Codable, Hashable {
    
    let woloo: wolooResponse?
    
    
    enum CodingKeys: String, CodingKey{
        
        case woloo
    }
    
    struct wolooResponse: Codable, Hashable {
        
        let Response: String?
        
        enum CodingKeys: String, CodingKey{
            
            case Response
        }
        
    }
}
