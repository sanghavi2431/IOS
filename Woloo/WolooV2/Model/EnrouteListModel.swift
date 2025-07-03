//
//  enrouteListModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 16/06/23.
//

import Foundation

struct EnrouteListModel : Codable {
    
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
    let user_id : String?
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
    let recommended_by : Int?
    let recommended_mobile : String?
    let distance : String?
    let duration : String?
    let duration_sec : Int?
    let base_url: String?
    let is_liked: Int?
    let offer: Int?
    let user_rating: Int? // to add in api
    let cibil_score_image: String?
    let cibil_score: String?
    let cibil_score_colour: String?
    
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
        case recommended_by = "recommended_by"
        case recommended_mobile = "recommended_mobile"
        case distance = "distance"
        case duration = "duration"
        case duration_sec = "duration_sec"
        case base_url = "base_url"
        case is_liked  = "is_liked"
        case offer = "offer"
        case user_rating = "user_rating" //to add in api
        case cibil_score_image = "cibil_score_image"
        case cibil_score_colour = "cibil_score_colour"
        case cibil_score = "cibil_score"
        
    }
    
}
