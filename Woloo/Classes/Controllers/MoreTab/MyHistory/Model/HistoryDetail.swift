//
//  HistoryDetail.swift
//  Woloo
//
//  Created by Kapil Dongre on 13/09/24.
//

import Foundation

struct HistoryDetail : Codable {
    let id : Int?
    let code : String?
    let name : String?
    let title : String?
    let image : [String]?
    let opening_hours : String?
    let restaurant : String?
    let segregated : String?
    let address : String?
    let city : String?
    let lat : String?
    let lng : String?
    let user_id : Int?
    let status : Int?
    let description : String?
    let created_at : String?
    let updated_at : String?
    let deleted_at : String?
    let is_covid_free : Int?
    let is_safe_space : Int?
    let is_clean_and_hygiene : Int?
    let is_sanitary_pads_available : Int?
    let is_makeup_room_available : Int?
    let is_coffee_available : Int?
    let is_sanitizer_available : Int?
    let is_feeding_room : Int?
    let is_wheelchair_accessible : Int?
    let is_washroom : Int?
    let is_premium : Int?
    let is_franchise : Int?
    let pincode : Int?

    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case code = "code"
        case name = "name"
        case title = "title"
        case image = "image"
        case opening_hours = "opening_hours"
        case restaurant = "restaurant"
        case segregated = "segregated"
        case address = "address"
        case city = "city"
        case lat = "lat"
        case lng = "lng"
        case user_id = "user_id"
        case status = "status"
        case description = "description"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case deleted_at = "deleted_at"
        case is_covid_free = "is_covid_free"
        case is_safe_space = "is_safe_space"
        case is_clean_and_hygiene = "is_clean_and_hygiene"
        case is_sanitary_pads_available = "is_sanitary_pads_available"
        case is_makeup_room_available = "is_makeup_room_available"
        case is_coffee_available = "is_coffee_available"
        case is_sanitizer_available = "is_sanitizer_available"
        case is_feeding_room = "is_feeding_room"
        case is_wheelchair_accessible = "is_wheelchair_accessible"
        case is_washroom = "is_washroom"
        case is_premium = "is_premium"
        case is_franchise = "is_franchise"
        case pincode = "pincode"
       
        
    }
    
    
    var getAllOfferNameV2: [String] {
        
        var values2 = [String]()
        
        if is_clean_and_hygiene == 1{
            values2.append("Clean & Hygienic Toilets")
        }
        
        if is_wheelchair_accessible == 1{
            values2.append("Wheelchair")
        }
        if is_safe_space == 1 {
            values2.append("Safe Space")
        }
        if is_sanitizer_available == 1 {
            values2.append("Sanitizer")
        }
        if is_covid_free == 1 {
            values2.append("Covid Free")
        }
        if is_feeding_room == 1 {
            values2.append("Feeding room")
        }
        if is_coffee_available == 1 {
            values2.append("Coffee available")
        }
        if is_makeup_room_available == 1 {
            values2.append("Makeup available")
        }
        if is_sanitizer_available == 1 {
            values2.append("Sanitary Pads")
        }
        
        if is_washroom == 1 {
            values2.append("Western Washroom")
        }
        if is_washroom == 0{
            values2.append("Indian Washroom")
        }
        if segregated == "YES"{
            values2.append("Gender Specific")
        }
        if segregated == "NO"{
            values2.append("Unisex")
        }
        return values2
    }
    
}
