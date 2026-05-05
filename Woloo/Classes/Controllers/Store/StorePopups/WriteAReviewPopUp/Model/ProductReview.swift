//
//  ProductReview.swift
//  Woloo
//
//  Created by CEPL on 29/03/25.
//

import Foundation

class ProductReviewWrapper: Codable{
    
    var data: ProductReviewData?
    
}

class ProductReviewData: Codable{
    
    var product_id: String? = ""
    var reviews: [ProductReview]?
}

class ProductReview: Codable{
    
    var id: String? = ""
    var rating: Int?
    var comment: String? = ""
    var approval: Bool? = false
    var created_at: String? = ""
    var updated_at: String? = ""
    var deleted_at: String? = ""
    var customer: CustomerCreate?
}
