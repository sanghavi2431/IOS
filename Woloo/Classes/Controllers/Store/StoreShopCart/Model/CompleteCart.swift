//
//  CompleteCart.swift
//  Woloo
//
//  Created by CEPL on 03/04/25.
//

import Foundation

class CompleteCart: Codable{
    
    
    var type: String? = ""
    var order_set: OrderSets
}

class CartOrder: Codable{
    
    var id: String? = ""
    
}
