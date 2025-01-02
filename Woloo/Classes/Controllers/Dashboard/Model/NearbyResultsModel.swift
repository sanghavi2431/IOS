//
//  NearbyResultsModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

    import Foundation
    struct NearbyResultsModel : Codable {
        var id : Int?
        var code : String? = ""
        var name : String? = ""
        var title : String? = ""
        var image : [String]?
        var opening_hours : String? = ""
        var restaurant : String? = ""
        var segregated : String? = ""
        var address : String? = ""
        var city : String? = ""
        var lat : String? = ""
        var lng : String? = ""
        var user_id : String? = ""
        var status : Int?
        var description : String? = ""
        var created_at : String? = ""
        var updated_at : String? = ""
        var deleted_at : String? = ""
        var is_covid_free : Int?
        var is_safe_space : Int?
        var is_clean_and_hygiene : Int?
        var is_sanitary_pads_available : Int?
        var is_makeup_room_available : Int?
        var is_coffee_available : Int?
        var is_sanitizer_available : Int?
        var is_feeding_room : Int?
        var is_wheelchair_accessible : Int?
        var is_washroom : Int?
        var is_premium : Int?
        var is_franchise : Int?
        var pincode : Int?
        var recommended_by : String? = ""
        var recommended_mobile : String? = ""
        var distance : String? = ""
        var duration : String? = ""
        var duration_sec : Int?
        var base_url: String? = ""
        var is_liked: Int?
        var offer: Int?
        var user_rating: Int? // to add in api
        var cibil_score_image: String? = ""
        var cibil_score: String? = ""
        var cibil_score_colour: String?
        
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


struct NearbyResultsModelV2 : Codable {
    var id : Int?
    var code : String? = ""
    var name : String? = ""
    var title : String? = ""
    var image : String? = ""
    var opening_hours : String? = ""
    var restaurant : String? = ""
    var segregated : String? = ""
    var address : String? = ""
    var city : String? = ""
    var lat : String? = ""
    var lng : String? = ""
    var user_id : Int?
    var status : Int?
    var description : String? = ""
    var created_at : String? = ""
    var updated_at : String? = ""
    var deleted_at : String? = ""
    var is_covid_free : Int?
    var is_safe_space : Int?
    var is_clean_and_hygiene : Int?
    var is_sanitary_pads_available : Int?
    var is_makeup_room_available : Int?
    var is_coffee_available : Int?
    var is_sanitizer_available : Int?
    var is_feeding_room : Int?
    var is_wheelchair_accessible : Int?
    var is_washroom : Int?
    var is_premium : Int?
    var is_franchise : Int?
    var pincode : Int?
    var recommended_by : Int?
    var recommended_mobile : String? = ""
    var distance : String? = ""
    var duration : String? = ""
    var duration_sec : Int?
    var base_url: String? = ""
    var is_liked: Int?
    var offer: Int?
    var user_rating: String? = "" // to add in api
    var rating: Double?
    var cibil_score_image: String? = ""
    var cibil_score: String? = ""
    var cibil_score_colour: String? = ""
    
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
        case rating = "rating"
        case cibil_score_image = "cibil_score_image"
        case cibil_score_colour = "cibil_score_colour"
        case cibil_score = "cibil_score"
        
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




struct WahCertificate : Codable {
    var id : Int?
    var code : String? = ""
    var name : String? = ""
    var title : String? = ""
    var image : [String]?
    var opening_hours : String? = ""
    var restaurant : String? = ""
    var segregated : String? = ""
    var address : String? = ""
    var city : String? = ""
    var lat : String? = ""
    var lng : String? = ""
    var user_id : Int?
    var status : Int?
    var description : String? = ""
    var created_at : String? = ""
    var updated_at : String? = ""
    var deleted_at : String? = ""
    var is_covid_free : Int?
    var is_safe_space : Int?
    var is_clean_and_hygiene : Int?
    var is_sanitary_pads_available : Int?
    var is_makeup_room_available : Int?
    var is_coffee_available : Int?
    var is_sanitizer_available : Int?
    var is_feeding_room : Int?
    var is_wheelchair_accessible : Int?
    var is_washroom : Int?
    var is_premium : Int?
    var is_franchise : Int?
    var pincode : Int?
    var recommended_by : Int?
    var recommended_mobile : String? = ""
    var distance : String? = ""
    var duration : String? = ""
    var duration_sec : Int?
    var base_url: String? = ""
    var is_liked: Int?
    var offer: Int?
    var user_rating: Int? // to add in api
    var cibil_score_image: String? = ""
    var cibil_score: String? = ""
    var cibil_score_colour: String? = ""
    
}


struct UserHistory : Codable {
    var id : Int?
    var code : String? = ""
    var name : String? = ""
    var title : String? = ""
    var image : [String]?
    var opening_hours : String? = ""
    var restaurant : String? = ""
    var segregated : String? = ""
    var address : String? = ""
    var city : String? = ""
    var lat : String? = ""
    var lng : String? = ""
    var user_id : Int?
    var status : Int?
    var description : String? = ""
    var created_at : String? = ""
    var updated_at : String? = ""
    var deleted_at : String? = ""
    var is_covid_free : Int?
    var is_safe_space : Int?
    var is_clean_and_hygiene : Int?
    var is_sanitary_pads_available : Int?
    var is_makeup_room_available : Int?
    var is_coffee_available : Int?
    var is_sanitizer_available : Int?
    var is_feeding_room : Int?
    var is_wheelchair_accessible : Int?
    var is_washroom : Int?
    var is_premium : Int?
    var is_franchise : Int?
    var pincode : Int?
    var recommended_by : String? = ""
    var recommended_mobile : String? = ""
    var distance : String? = ""
    var duration : String? = ""
    var duration_sec : Int?
    var base_url: String? = ""
    var is_liked: Int?
    var offer: Int?
    var user_rating: String? // to add in api
    var cibil_score_image: String? = ""
    var cibil_score: String? = ""
    var cibil_score_colour: String?
    
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
