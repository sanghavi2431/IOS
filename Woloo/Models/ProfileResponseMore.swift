//
//  ProfileResponseMore.swift
//  Woloo
//
//  Created on 29/06/21.
//

import Foundation
import UIKit
import ObjectMapper

struct ProfileMoreResponse :Mappable{
    var userData: UserModel?
    var offerList: [Offer]?
    var planData: PlanData?
    var totalCoins: ProfileUserCoins?
    var lifeTime: Int?
    var isFutureSubcriptionExist: Bool?
    var futureSubcription: PlanData?

    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        userData <- map["profile"]
        offerList <- map["offerList"]
        planData <- map["planData"]
        totalCoins <- map["totalCoins"]
        lifeTime <- map["lifetime_free"]
        isFutureSubcriptionExist <- map["isFutureSubcriptionExist"]
        futureSubcription <- map["futureSubcription"]
    }
}


