//
//  CartItems.swift
//  Woloo
//
//  Created by CEPL on 25/03/25.
//

import Foundation

class CartItems: Codable{
    
    var id: String? = ""
    var thumbnail: String? = ""
    var variant_id: String? = ""
    var product_id: String? = ""
    var product_type_id: String? = ""
    var product_title: String? = ""
    var product_description: String? = ""
    var product_subtitle: String? = ""
    var product_type: String? = ""
    var product_collection: String? = ""
    var product_handle: String? = ""
    var variant_sku: String? = ""
    var variant_barcode: String? = ""
    var variant_title: String? = ""
    var requires_shipping: Bool? = false
    //var metadata
    var created_at: String? = ""
    var updated_at: String? = ""
    var title: String? = ""
    var quantity: Int?
    var unit_price: Int?
    var compare_at_unit_price: Int?
    var is_tax_inclusive: Bool?
    var variant: ProductVariants?
    
}
