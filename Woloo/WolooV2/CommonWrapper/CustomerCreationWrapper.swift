//
//  CustomerCreationWrapper.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import Foundation

class CustomerCreationWrapper: Codable{
    
    var customer: CustomerCreate?
}


class CustomerCreate: Codable{
    var id: String? = ""
    var email: String? = ""
    var company_name: String? = ""
    var first_name: String? = ""
    var last_name: String? = ""
    var phone: String? = ""
    //var metadata: String? = ""
    var has_account: Bool?
    var deleted_at: String? = ""
    var created_at: String? = ""
    var updated_at: String? = ""
    
    var addresses: [StoreAddress]?
}
