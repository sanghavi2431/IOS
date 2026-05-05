//
//  ProfileUserCoins.swift
//  Woloo
//
//  Created by ideveloper1 on 21/04/21.
//

import Foundation
import ObjectMapper

struct ProfileUserCoins: Mappable {
    var totalCoins: Int?
    var giftCoins: Int?
    
    init() { }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        totalCoins <- map["total_coins"]
        giftCoins <- map["gift_coins"]
    }
}

struct MoreTabDetail {
    var userData: UserModel?
    var subscriptionData: PlanData?
    var userCoin: ProfileUserCoins?
}

struct MoreTabDetailV2{
    var userData: UserProfileModel.Profile?
    var subscriptionData: UserProfileModel.PlanData?
    var userCoin: UserProfileModel.TotalCoins?
}
