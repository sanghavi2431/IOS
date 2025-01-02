//
//  ReviewListModel.swift
//  MySDK
//
//  Created by DigitalFlake Kapil Dongre on 09/08/23.
//

import Foundation

struct ReviewListModel: Codable {
    
    var total_review_count, review_count: Int?
    var review: [Review]?
    
    enum CodingKeys: String, CodingKey {
        
        case total_review_count = "total_review_count"
        case review_count = "review_count"
        case review = "review"
    }
    
    
    struct Review: Codable{
        
        var id, user_id, woloo_id, rating: Int?
        var remarks: String?
        var status: Int?
        var created_at, updated_at, rating_option, review_description: String?
        var user_details: UserModel?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case user_id = "user_id"
            case woloo_id = "woloo_id"
            case rating = "rating"
            case remarks = "remarks"
            case status = "status"
            case created_at = "created_at"
            case updated_at = "updated_at"
            case rating_option = "rating_option"
            case review_description = "review_description"
            case user_details = "user_details"
        }
    }
    
    
    struct UserModel: Codable{
        
        var id: Int?
        var name: String?
        var avatar: String?
        
        enum CodingKeys: String, CodingKey {
            
            case id = "id"
            case name = "name"
            case avatar = "avatar"
            
        }
    }
}
