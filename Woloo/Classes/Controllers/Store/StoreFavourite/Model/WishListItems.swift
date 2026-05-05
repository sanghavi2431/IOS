//
//  WishListItems.swift
//  Woloo
//
//  Created by CEPL on 11/04/25.
//

import Foundation

class WishListItems: Codable{
    
    var id: String? = ""
    var product_variant_id: String? = ""
    var wishlist_id: String? = ""
    var created_at: String? = ""
    var updated_at: String? = ""
    var deleted_at: String? = ""
    var product_variant: ProductVariants?
}
