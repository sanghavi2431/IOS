//
//  ProductOptions.swift
//  Woloo
//
//  Created by CEPL on 13/03/25.
//

import Foundation

class ProductOptions: Codable{
    
    var id: String? = ""
    var title: String? = ""
    var metadata: String? = ""
    var product_id: String? = ""
    var values: [ProductOptionValue]?
}
