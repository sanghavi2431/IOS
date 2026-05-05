//
//  Collection.swift
//  Woloo
//
//  Created by CEPL on 17/03/25.
//

import Foundation

class Collection: Codable{
    var id: String? = ""
    var title: String? = ""
    var handle: String? = ""
    var metadata: ProductImage?
    var created_at: String? = ""
    var updated_at: String? = ""
    var deleted_at: String? = ""
    
    
}

class ProductImage: Codable{
    var image: String? = ""
}
