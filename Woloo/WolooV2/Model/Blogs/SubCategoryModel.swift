//
//  SubCategoryModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 26/08/24.
//

import Foundation

struct SubCategoryModel: Codable{
    
    var id: Int?
    var subcategoryName, subcategoryIconURL: String?
    
    enum  CodingKeys: String, CodingKey {
        
        case id = "id"
        case subcategoryName = "sub_category"
        case subcategoryIconURL = "sub_category_icon_url"
    }
}
