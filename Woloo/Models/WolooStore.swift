//
//  WolooStore.swift
//  Woloo
//
//  Created by Ashish Khobragade on 08/01/21.
//

import UIKit
import ObjectMapper

// MARK: - WolooStore

struct NearByStoreResponse :Mappable{
    
    var stores: [WolooStore]?
    var status : Status?
    var message : String?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        stores <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }
}

struct WolooStore: Mappable {
    
    var storeId: Int?
    var code, name, title: String?
    var image: [String]?
    var openingHours, restaurant, segregated, address: String?
    var city: String?
    var lat, lng: String?
    var userid: Int?
    var wolooStoreDescription: String?
    var distance: String?
    var createdAt, updatedAt, deletedAt: String?
    var status: Int?
    var offer: Offer?
    var isCleanAndHygiene: Int?
    var isSanitaryPadsAvailable: Int?
    var isMakeupRoomAvailable: Int?
    var isSanitizerAvailable: Int?
    var isFeedingRoom: Int?
    var isCovidFree: Int?
    var isSafeSpace: Int?
    var isCoffeeAvailable: Int?
    var isPremium: Int?
    var isFranchise: Int?
    var pinCode: Int?
    var recommendedBy: String?
    var recommendedMobile: String?
    var userReviewCount: Int?
    var isWheelchairAccessible: Int?
    var isWashroom: Int?
    var isLiked: Int?
    var duration: String?
    var rating: String?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        storeId             <- map["id"]
        code                <- map["code"]
        name                <- map["name"]
        title               <- map["title"]
        image               <- map["image"]
        openingHours        <- map["opening_hours"]
        restaurant          <- map["restaurant"]
        segregated          <- map["segregated"]
        address             <- map["address"]
        city                <- map["city"]
        lat                 <- map["lat"]
        lng                 <- map["lng"]
        userid              <- map["user_id"]
        wolooStoreDescription  <- map["description"]
        createdAt           <- map["created_at"]
        updatedAt           <- map["updated_at"]
        deletedAt           <- map["deleted_at"]
        distance             <- map["distance"]
        offer               <- map["offer"]
        status              <- map["status"]
        isSanitaryPadsAvailable <- map["is_sanitary_pads_available"]
        isMakeupRoomAvailable <- map["is_makeup_room_available"]
        isSanitizerAvailable <- map["is_sanitizer_available"]
        isCleanAndHygiene <- map["is_clean_and_hygiene"]
        isWheelchairAccessible <- map["is_wheelchair_accessible"]
        isCovidFree <- map["is_covid_free"]
        isSafeSpace <- map["is_safe_space"]
        isCoffeeAvailable <- map["is_coffee_available"]
        isPremium <- map["is_premium"]
        isWashroom <- map["is_washroom"]
        isFeedingRoom <- map["is_feeding_room"]
        isLiked <- map["is_liked"]
        duration <- map["duration"]
        rating <- map["user_rating"]
        isFranchise <- map["is_franchise"]
        pinCode     <- map["pincode"]
        recommendedBy <- map["recommended_by"]
        recommendedMobile <- map["recommended_mobile"]
        userReviewCount   <- map["user_review_count"]
    }
    
    var getAllOfferName: [String] {
        var values = [String]()
        if isCleanAndHygiene == 1 {
            values.append("Clean & Hygienic Toilets")
        }
        if isWheelchairAccessible == 1 {
            values.append("Wheelchair")
        }
        if isSafeSpace == 1 {
            values.append("Safe Space")
        }
        if isSanitizerAvailable == 1 {
            values.append("Sanitizer")
        }
        if isCovidFree == 1 {
            values.append("Covid Free")
        }
        if isFeedingRoom == 1 {
            values.append("Feeding room")
        }
        if isCoffeeAvailable == 1 {
            values.append("Coffee available")
        }
        if isMakeupRoomAvailable == 1 {
            values.append("Makeup available")
        }
        if isSanitaryPadsAvailable == 1 {
            values.append("Sanitary Pads")
        }
        return values
    }
}

// MARK: - Offer
struct Offer: Mappable {
    var offerId: Int?
    var title, offerDescription: String?
    var image: String?
    var wolooid: Int?
    var startDate, endDate: String?
    var status: Int?
    var createdAt, updatedAt: String?
    var deletedAt: String?
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        offerId             <- map["id"]
        title               <- map["title"]
        offerDescription    <- map["description"]
        image               <- map["image"]
        wolooid             <- map["woloo_id"]
        startDate           <- map["start_date"]
        endDate             <- map["end_date"]
        createdAt           <- map["created_at"]
        updatedAt           <- map["updated_at"]
        deletedAt           <- map["deleted_at"]
        status              <- map["status"]
    }
}

struct WolooOffer: Mappable {
    var offerId: Int?
    var couponCode: String?
    var title, offerDescription, value, valueUnit, categoryIds, vendorsIds, productIds, dateTime, status: String?
    var image: String?
    var wolooid: Int?
    var startDate, endDate: String?
    var createdAt, updatedAt: String?
    var deletedAt: String?
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        dateTime            <- map["date_time"]
        productIds          <- map["product_ids"]
        vendorsIds          <- map["vendors_ids"]
        categoryIds         <- map["category_ids"]
        value               <- map["value"]
        valueUnit           <- map["value_unit"]
        couponCode         <- map["coupon_code"]
        offerId             <- map["id"]
        title               <- map["title"]
        offerDescription    <- map["description"]
        image               <- map["image"]
        wolooid             <- map["woloo_id"]
        startDate           <- map["start_date"]
        endDate             <- map["end_date"]
        createdAt           <- map["created_at"]
        updatedAt           <- map["updated_at"]
        deletedAt           <- map["deleted_at"]
        status              <- map["status"]
    }
}

struct OfferReponse: Mappable {
    var offerCount, wolooCount: Int?
    var shopOffer: [WolooOffer]?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        offerCount <- map["offerCount"]
        wolooCount <- map["wolooCount"]
        shopOffer <- map["shopOffer"]
    }
}
// MARK: - Offer
struct WolooLikeStatus: Mappable{
    
    var isLiked: Int = 0
    var status : Status?
    var message : String?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        isLiked <- map["is_liked"]
        status <- map["status"]
        message <- map["message"]
    }
}
