//
//  OfferModel.swift
//  Woloo
//
//  Created by ideveloper2 on 23/06/21.
//

import Foundation
import ObjectMapper

struct RedeemOfferModel: Mappable {
    
    var redeemId: Int?
    var userData: [String:Any]?
    init?(map: Map) {
      
    }
    
    mutating func mapping(map: Map) {
        userData <- map["user_data"]
    }
}
