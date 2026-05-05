//
//  ProductOptionValue.swift
//  Woloo
//
//  Created by CEPL on 13/03/25.
//

import Foundation

class ProductOptionValue: Codable{
    
    var id: String? = ""
    var value: String? = ""
    var metadata: String? = ""
    
    //App use
    var isSelected: Bool? = false
}
