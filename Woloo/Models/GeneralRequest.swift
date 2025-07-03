//
//  PortletDetailsRequest.swift
//  YesFlixTV
//
//  Created by Ashish.Khobragade on 15/10/19.
//  Copyright © 2019 Jetsynthesys. All rights reserved.
//

import UIKit
import ObjectMapper

struct GeneralRequest: Mappable {
    var superStoreId, storeId,pageId,portletId,packageId,seriesId,seasonId,page: Int?
    var contentType,contentId,userCode,categoryProgramId,genreId: String?
    var startDate ,endDate: String?
    var locale: LocaleModel?
    
    init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        superStoreId        <- map["superStoreId"]
        storeId             <- map["storeId"]
        pageId              <- map["pageId"]
        portletId           <- map["portletId"]
        packageId           <- map["packageId"]
        seriesId            <- map["seriesId"]
        seasonId            <- map["seasonId"]
        contentType         <- map["contentType"]
        contentId           <- map["contentId"]
        userCode            <- map["userCode"]
        categoryProgramId   <- map["categoryProgramId"]
        genreId             <- map["genreId"]
        page                <- map["page"]
        locale              <- map["locale"]
        startDate           <- map["startDate"]
        endDate             <- map["endDate"]
    }
}

struct NearByWolooStoreRequest:Mappable {
    
    var lat,long: String?
    var locale: LocaleModel?
    var page, range, mode: String?
    var isSearch:String?
    var offers:String?
   init() {
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        long             <- map["lng"]
        lat                <- map["lat"]
        locale              <- map["locale"]
        page                <- map["page"]
        range               <- map["range"]
        mode                <- map["mode"]
        isSearch            <- map["isSearch"]
        offers            <- map["offers"]
  }
}

// MARK: - ReviewList Request
struct ReviewListRequest: Mappable {
    var wolooId: Int?
    var pageNumber: Int?
    
    init?(map: Map) {
        
    }
    
    init() {
    }
    
    mutating func mapping(map: Map) {
        wolooId <- map["wolooId"]
        pageNumber <- map["pageNumber"]
    }
}
