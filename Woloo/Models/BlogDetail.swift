//
//  BlogDetail.swift
//  Woloo
//
//  Created on 01/09/21.
//

import Foundation
import ObjectMapper

// MARK: - BlogDetail
/// Get BLOG Detail Info.
struct BlogDetail: Mappable {
    var id, status: Int?
        var createdAt, updatedAt: String?
        var authorID: Int?
        var mainImage, title: String?
        var detailedBlogLink: String?
        var detailedShortLink: String?
        var categories, subCategories: String?
        var likeCounts, favouriteCounts, isLiked, isFavourite, isBlogRead: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        status <- map["status"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        authorID <- map["author_id"]
        mainImage <- map["main_image"]
        title <- map["title"]
        detailedBlogLink <- map["detailed_blog_link"]
        detailedShortLink <- map["short_link"]
        categories <- map["categories"]
        subCategories <- map["sub_categories"]
        likeCounts <- map["like_counts"]
        favouriteCounts <- map["favourite_counts"]
        isLiked <- map["is_liked"]
        isFavourite <- map["is_favourite"]
        isBlogRead <- map["is_blog_read"]
    }
}

struct BlogUserBYCategories {
    
}
