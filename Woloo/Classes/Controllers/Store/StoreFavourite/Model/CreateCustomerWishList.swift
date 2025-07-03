//
//  CreateCustomerWishList.swift
//  Woloo
//
//  Created by CEPL on 10/04/25.
//

import Foundation

class CreateCustomerWishList: Codable{
    
    var id: String? = ""
    var customer_id: String? = ""
    var sales_channel_id: String? = ""
    var created_at: String? = ""
    var updated_at: String? = ""
    var deleted_at: String? = ""
    var items: [WishListItems]?
}
