//
//  OrderItem.swift
//  Woloo
//
//  Created by CEPL on 21/05/25.
//

import Foundation

class OrderItem: Codable{
    
    var id: String? = ""
    var title: String? = ""
    var subtitle: String? = ""
    var thumbnail: String? = ""
    var variant_id: String? = ""
    var product_id: String? = ""
    var product_title: String? = ""
    var product_description: String? = ""
    var product_subtitle: String? = ""
    var product_type: String? = ""
    var product_type_id: String? = ""
    var product_collection: String? = ""
    var product_handle: String? = ""
    var variant_sku: String? = ""
    var variant_barcode: String? = ""
    var variant_title: String? = ""
    var variant_option_values: String? = ""
    var requires_shipping: Bool?
    var is_giftcard: Bool?
    var is_discountable: Bool?
    var is_tax_inclusive: Bool?
    var is_custom_price: Bool?
    var created_at: String? = ""
    var updated_at: String? = ""
    var deleted_at: String? = ""
    var unit_price: Int?
    var quantity: Int?
    var subtotal: Int?
    var total: Int?
    var original_total: Int?
    var discount_total: Int?
    var discount_subtotal: Int?
    var discount_tax_total: Int?
    var tax_total: Int?
    var original_tax_total: Int?
    var refundable_total_per_unit: Int?
    var refundable_total: Int?
    var fulfilled_total: Int?
    
    
}
