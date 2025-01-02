//
//  GetAllCategoryModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 02/09/24.
//

import Foundation

struct GetAllCategoryModel: Codable{
     
    var data: [DataAllBlog]?
    
}

struct DataAllBlog: Codable{
    var id: Int?
    var category_name: String? = ""
    var icon: String? = ""
    var status: Int?
    var created_at: String? = ""
    var updated_at: String? = ""
}
