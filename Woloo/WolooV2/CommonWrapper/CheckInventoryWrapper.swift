//
//  CheckInventoryWrapper.swift
//  Woloo
//
//  Created by CEPL on 27/06/25.
//

import Foundation

class CheckInventoryWrapper: Codable{
    
    var success: Bool? =  false
    var message: String? = ""
    //var data: [Items]?
    var errors: [Errors]?
    
}


class Errors: Codable{
    var variant_id: String? = ""
    var title: String? = ""
    var requested_quantity: Int?
    var available_quantity: Int?
}


class Items: Codable{
    var items: [ItemsRestock]?
}

class ItemsRestock: Codable{
    var id: String? = ""
}
