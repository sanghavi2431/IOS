//
//  Products.swift
//  Woloo
//
//  Created by CEPL on 13/03/25.
//

import Foundation


class Products: Codable{
    
    
    var id: String? = ""
    var title: String? = ""
    var subtitle: String? = ""
    var description: String? = ""
    var handle: String? = ""
    var is_giftcard: Bool? = false
    var discountable: Bool? = false
    var thumbnail: String? = ""
    var collection_id: String? = ""
    var type_id: String? = ""
    var weight: String? = ""
    var length: String? = ""
    var height: String? = ""
    var width: String? = ""
    var hs_code: String? = ""
    var origin_country: String? = ""
    var mid_code: String? = ""
    var material: String? = ""
    var created_at: String? = ""
    var updated_at: String? = ""
    //var type
    var collection: Collection?
    var options: [ProductOptions]?
    var tags: [ProductTags]?
    var images: [StoreProductImages]?
    var variants: [ProductVariants]?
    var quantity: Int? = 0
    var unit_price: Int?
    var average_rating: Double?
    var review_count: Int?
    
    //App use
    
    var isLiked: Bool? = false
    var prodQuantity: Int? = 0
    
}
