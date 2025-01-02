//
//  BlogModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 26/08/24.
//

import Foundation

struct BlogModel: Codable{
    
        var id, status: Int?
        var createdAt, updatedAt: String?
        var authorID: Int?
        var mainImage, title: String?
        var detailedBlogLink: String?
        var detailedShortLink: String?
        var categories, subCategories: String?
        var likeCounts, favouriteCounts, isLiked, isFavourite, isBlogRead: Int?
    
    enum CodingKeys: String, CodingKey {
        
            case id = "id"
            case  status = "status"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case authorID = "author_id"
            case mainImage = "main_image"
            case title = "title"
            case detailedBlogLink = "detailed_blog_link"
            case detailedShortLink = "short_link"
            case categories = "categories"
            case subCategories = "blog_read_status"
            case likeCounts = "like_counts"
            case favouriteCounts = "favourite_counts"
            case isLiked = "is_liked"
            case isFavourite = "is_favourite"
            case isBlogRead = "is_blog_read"
    }
    
    
}
