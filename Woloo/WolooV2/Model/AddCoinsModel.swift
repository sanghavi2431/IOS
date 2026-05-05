//
//  AddCoinsModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 07/04/23.
//

import Foundation

struct AddCoinsModel: Codable {
    
    
    let order_id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case order_id = "order_id"
    }
}
