//
//  ctaFavouriteModel.swift
//  Woloo
//
//  Created by kapil dongre on 09/11/23.
//

import Foundation

struct ctaFavouriteModel: Codable{
    
    var favourite: Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case favourite = "favourite"
    }
    
}
