//
//  WolooRewardHistoryResponse.swift
//  Woloo
//
//  Created by ideveloper2 on 10/06/21.
//

import Foundation
import ObjectMapper

struct WolooRewardHistoryResponse: Mappable {
    
    var totalCount: Int?
    var historyCount: Int?
    var history: [WolooHistory]?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        totalCount <- map["total_count"]
        historyCount <- map["history_count"]
        history <- map["history"]
    }
}


// MARK: - WolooHistory
struct WolooHistory: Mappable {
   
    var id, wolooId, userId: Int?
    var amount, type: String?
    var isReviewPending: Int?
    var createdAt, updatedAt: String?
    var wolooDetails: WolooStore?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        wolooId <- map["woloo_id"]
        userId <- map["user_id"]
        amount <- map["amount"]
        type <- map["type"]
        isReviewPending <- map["is_review_pending"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        wolooDetails <- map["woloo_details"]
    }
    
}

struct WolooNavigationReward: Mappable {
    var code : Int?
    var status : String?
    var message : String?
    
     init?(map: Map) {  }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        status <- map["status"]
        message <- map["message"]
    }
}
