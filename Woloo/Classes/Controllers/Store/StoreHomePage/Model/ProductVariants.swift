//
//  ProductVariants.swift
//  Woloo
//
//  Created by CEPL on 17/03/25.
//

import Foundation

class ProductVariants: Codable{
    
    var id: String? = ""
    var title: String? = ""
    var sku: String? = ""
    var barcode: String? = ""
    var ean: String? = ""
    var upc: String? = ""
    var allow_backorder: Bool? = false
    var manage_inventory: Bool? = false
    var hs_code: String? = ""
    var origin_country: String? = ""
    var mid_code: String? = ""
    var material: String? = ""
    var weight: Int?
    var length: Int?
    var height: Int?
    var width: Int?
    var metadata: ProductImage?
    var variant_rank: Int?
    var product_id: String? = ""
    var options: [VariantsOptions]?
    var calculated_price: CalculatedPrice?
    var inventory_quantity: Int?
    var has_restock_subscription: Bool? = false
    var has_wishlisted: Bool? = false
}

