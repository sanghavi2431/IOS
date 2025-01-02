//
//  CategoryInfo.swift
//  Woloo
//
//  Created on 31/08/21.
//

import Foundation
import ObjectMapper
struct CategoryInfo: Mappable {
    var id, blogCount: Int?
    var categoryName, categoryIconURL: String?
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        categoryName <- map["category_name"]
        categoryIconURL <- map["category_icon_url"]
        blogCount <- map["blog_count"]
    }
}

struct SubCategories: Mappable {
    var id: Int?
    var categoryName, categoryIconURL: String?
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        categoryName <- map["sub_category"]
        categoryIconURL <- map["sub_category_icon_url"]
    }
}


struct CategoryResponse: Mappable {
    var categories: [CategoryInfo]?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        categories <- map["categories"]
    }
}

struct BlogsAndCategoryResponse: Mappable {
    var blogs: [BlogDetail]?
    var categories: [CategoryInfo]?
    var subCategories: [SubCategories]?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        categories <- map["categories"]
        blogs <- map["blogs"]
        subCategories <- map["sub_categories"]
    }
}

struct GetCategoriesResponse: Mappable {
    var categories: String?
    
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        categories <- map["user_saved_categories"]
    }
}
