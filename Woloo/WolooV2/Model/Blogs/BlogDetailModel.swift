//
//  BlogDetailModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 26/08/24.
//

import Foundation

struct BlogDetailModel: Codable{
    
    
    var blogs = [BlogModel]()
    var sub_categories = [SubCategoryModel]()
    var categories = [CategoryModel]()
    
    enum CodingKeys: String, CodingKey {
        
        case blogs = "blogs"
        case sub_categories = "sub_categories"
        case categories = "categories"
    }
}
