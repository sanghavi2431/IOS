//
//  ProductCollection.swift
//  Woloo
//
//  Created by CEPL on 14/04/25.
//

import Foundation

class ProductCollection: Codable{
    
    
    var id: String? = ""
    var title: String? = ""
    var metadata: ImageMetaData?
}

class ImageMetaData: Codable{
    var image: String? = ""
}
