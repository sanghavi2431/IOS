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
    var title: String?
    var mainImage: [String]?
    var detailedBlogLink: String?
    var detailedShortLink: String?
    var categories, subCategories, category_types: String?
    var likeCounts, favouriteCounts, isLiked, isFavourite, isBlogRead: Int?
    var shop_map_id: String?
    var shop_category_id: String?
    var content: String?
    var video_thumbnail: [String]?
    var main_video: [String]?
    var main_image_count: Int?
    var short_link: String?
    
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
        case category_types = "category_types"
        case likeCounts = "like_counts"
        case favouriteCounts = "favourite_counts"
        case isLiked = "is_liked"
        case isFavourite = "is_favourite"
        case isBlogRead = "is_blog_read"
        case shop_map_id = "shop_map_id"
        case shop_category_id = "shop_category_id"
        case content = "content"
        case main_video = "main_video"
        case main_image_count = "main_image_count"
       
    }
    
    
}
