//
//  GetReviewOptionsModel.swift
//  Woloo
//
//  Created by kapil dongre on 23/10/23.
//

import Foundation

struct GetReviewOptionsListModel: Codable{
    
    var ratingOption: [RatingOptions]
    var ratingReview: [RatingOptions]
    var ratingImprovement: [RatingOptions]
    
    enum CodingKeys: String, CodingKey {
        
        case ratingOption = "rating_option"
        case ratingReview = "rating_review"
        case ratingImprovement = "rating_improvement"
    
    }
    

    
    
//    struct RatingReview: Codable{
//
//        var id: Int?
//        var key: String?
//        var display_name: String?
//        var value: String?
//        var details: String?
//        var type: String?
//        var order: Int?
//        var group: String?
//
//        enum CodingKeys: String, CodingKey {
//
//            case id = "id"
//            case key = "key"
//            case display_name = "display_name"
//            case value = "value"
//            case details  = "details"
//            case type = "type"
//            case order = "order"
//            case group = "group"
//        }
//
//    }
//
//
//    struct RatingImprovement: Codable{
//
//        var id: Int?
//        var key: String?
//        var display_name: String?
//        var value: String?
//        var details: String?
//        var type: String?
//        var order: Int?
//        var group: String?
//
//        enum CodingKeys: String, CodingKey {
//            case id = "id"
//            case key = "key"
//            case display_name = "display_name"
//            case value = "value"
//            case details  = "details"
//            case type = "type"
//            case order = "order"
//            case group = "group"
//        }
//    }
}

// MARK: - ReviewOption
struct RatingOptions: Codable{
    
    var id: Int?
    var key: String?
    var displayName: String?
    var value: String?
    var details: String?
    var type: String?
    var order: Int?
    var group: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case key = "key"
        case displayName = "display_name"
        case value = "value"
        case details = "details"
        case type = "type"
        case order = "order"
        case group = "group"
        
    }
}
