//
//  StatusSuccessResponse.swift
//  Woloo
//
//  Created by ideveloper1 on 24/04/21.
//

import UIKit
import ObjectMapper

class StatusSuccessResponse: Mappable {
    var status : Status?
    var message : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
    }
}
