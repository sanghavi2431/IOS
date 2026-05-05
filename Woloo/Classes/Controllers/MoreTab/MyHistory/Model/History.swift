//
//  History.swift
//  Woloo
//
//  Created by Kapil Dongre on 13/09/24.
//

import Foundation

struct History : Codable {
    
    var id: Int?
    var woloo_id: Int?
    var user_id: Int?
    var amount: String? = ""
    var type: String? = ""
    var is_review_pending: Int?
    var created_at: String? = ""
    var updated_at: String? = ""
    var woloo_details = UserHistory()
}
