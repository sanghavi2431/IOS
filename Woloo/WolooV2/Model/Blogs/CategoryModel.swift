//
//  CategoryModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 26/08/24.
//

import Foundation

struct CategoryModel: Codable{
    var id: Int?
    var categoryName, categoryIconURL: String?
    var blogCount: Int?
    var bgColor: String?
    
    //app use
    var isSelected: Bool? = false
    
    enum  CodingKeys: String, CodingKey {
        
        case id = "id"
        case categoryName = "category_name"
        case categoryIconURL = "category_icon_url"
        case blogCount = "blog_count"
        case bgColor = "bg_color"
    }
}
