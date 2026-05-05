//
//  DeleteAddress.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import Foundation

class DeleteAddress: Codable{
    
    var id: String? = ""
    var object: String? = ""
    var deleted: Bool? = false
    var parent: Parent?
}

class Parent: Codable{
    var id: String? = ""
    var first_name: String? = ""
    var last_name: String? = ""
    var phone: String? = ""
}
