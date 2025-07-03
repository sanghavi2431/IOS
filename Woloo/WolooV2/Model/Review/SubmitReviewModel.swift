//
//  SubmitReviewModel.swift
//  Woloo
//
//  Created by kapil dongre on 23/10/23.
//

import Foundation

struct SubmitReviewModel: Codable{
    
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        
        case message = "message"
    }
    
}
