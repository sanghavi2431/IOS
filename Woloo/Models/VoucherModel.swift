//
//  VoucherModel.swift
//  Woloo
//
//  Created by ideveloper2 on 23/06/21.
//

import Foundation
import ObjectMapper

struct VoucherModel: Mappable {
    
    var user: UserModel?
    var subscription: VoucherSubscription?
    
    init?(map: Map) {
      
    }
    
    mutating func mapping(map: Map) {
        user <- map["user"]
        subscription <- map["subscription"]
    }
}

struct VoucherSubscription: Mappable {
    var days: String?
    
    init?(map: Map) {
      
    }
    
    mutating func mapping(map: Map) {
        days <- map["days"]
    }
}

struct getVoucherSubscription: Mappable {
    var subscriptionid: String?
    
    init?(map: Map) {
      
    }
    
    mutating func mapping(map: Map) {
        subscriptionid <- map["subscription_id"]
    }
}
