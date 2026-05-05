//
//  ReviewModel.swift
//  Woloo
//
//  Created by ideveloper2 on 12/06/21.
//

import Foundation
import ObjectMapper

// MARK: - ReviewModel
struct ReviewModel: Mappable {
    
    var totalReviewCount, reviewCount: Int?
    var review: [Review]?

    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        totalReviewCount <- map["total_review_count"]
        reviewCount <- map["review_count"]
        review <- map["review"]
        
    }
    
}


// MARK: - Review
struct Review: Mappable {
    var id, userId, wolooId, rating: Int?
    var remarks: String?
    var status: Int?
    var createdAt, updatedAt, ratingOption, reviewDescription: String?
    var userDetails: UserModel?
    
    init?(map: Map) {
      
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
        wolooId <- map["woloo_id"]
        rating <- map["rating"]
        remarks <- map["remarks"]
        status <- map["status"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        ratingOption <- map["rating_option"]
        reviewDescription <- map["review_description"]
        userDetails <- map["user_details"]
    }
}


// MARK: - UserDetails
struct UserDetails: Mappable {
    var id: Int?
    var name, avatar: String?
    
    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        avatar <- map["avatar"]
    }
}

struct ReviewOptionList: Mappable {
    var ratingOption: [ReviewOption]?
    var ratingReview: [ReviewOption]?
    var ratingImprovement: [ReviewOption]?
    
    
    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        ratingOption <- map["rating_option"]
        ratingReview <- map["rating_review"]
        ratingImprovement <- map["rating_improvement"]
    }
}
// MARK: - ReviewOption
struct ReviewOption: Mappable {
    var id: Int?
    var key: String?
    var displayName: String?
    var value: String?
    var details: Any?
    var type: String?
    var order: Int?
    var group: String?
    
    init?(map: Map) {
    
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        key <- map["key"]
        displayName <- map["display_name"]
        value <- map["value"]
        details <- map["details"]
        type <- map["type"]
        order <- map["order"]
        group <- map["group"]
    }
}
