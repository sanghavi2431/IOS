//
//  SearchWoloo.swift
//  Woloo
//
//  Created by CEPL on 07/06/25.
//

import Foundation

class SearchWoloo: Codable{
    
    var id: Int?
    var code: String? = ""
    var name: String? = ""
    var title: String? = ""
    var opening_hours: String? = ""
    var restaurant: String? = ""
    var segregated: String? = ""
    var address: String? = ""
    var city: String? = ""
    var lat: String? = ""
    var lng: String? = ""
    var average_rating: String? = ""
    var review_count: Int?
    var pincode: Int?
    var cibil_score: String? = ""
    var cibil_score_image: String? = ""
}
