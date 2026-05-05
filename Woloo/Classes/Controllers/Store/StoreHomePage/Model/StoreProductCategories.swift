//
//  StoreProductCategories.swift
//  Woloo
//
//  Created by CEPL on 18/03/25.
//

import Foundation

class StoreProductCategories: Codable{
    
    var id: String? = ""
    var name: String? = ""
    var description: String? = ""
    var handle: String? = ""
    var rank: Int?
    var parent_category_id: String? = ""
    var created_at: String? = ""
    var updated_at: String? = ""
    var metadata: ProductMetaData?
    var parent_category: ParentCategory?
    
    // App use
    var isSelected: Bool? = false
}

class ProductMetaData: Codable{
    var image: String? = ""
    var background_color: String? = ""
    var videos: String? = ""
}


class ParentCategory: Codable{
    var handle: String? = ""
    var id: String? = ""
    var created_at: String? = ""
    var parent_category_id: String? = ""
    var rank: Int?
    var description: String? = ""
    var name: String? = ""
    
}


struct TakeSneakPeekServiceItem {
    var videoUrl: String
}
