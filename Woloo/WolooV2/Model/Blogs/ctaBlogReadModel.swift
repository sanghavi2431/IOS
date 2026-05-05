//
//  catBlogReadModel.swift
//  Woloo
//
//  Created by kapil dongre on 09/11/23.
//

import Foundation

struct ctaBlogReadModel: Codable {
    
    var blog_read_status: Int?
    
    enum CodingKeys: String, CodingKey{
        
        case blog_read_status = "blog_read_status"
    }
    
}
