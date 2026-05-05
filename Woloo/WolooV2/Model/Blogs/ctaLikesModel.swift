//
//  ctaLikesModel.swift
//  Woloo
//
//  Created by kapil dongre on 09/11/23.
//

import Foundation

struct ctaLikesModel: Codable {
    
    var like_counts: Int?
    
    enum CodingKeys: String, CodingKey{
        
        case like_counts = "like_counts"
    }
    
}
