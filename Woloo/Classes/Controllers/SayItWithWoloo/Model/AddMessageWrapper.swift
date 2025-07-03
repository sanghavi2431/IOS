//
//  AddMessageWrapper.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import Foundation

struct AddMessageWrapper: Codable{
    
    var status: Int?
    var msg: String? = ""
    var MessageId: String? = ""
    var QrId: String? = ""
   // var Type: String? = ""
}
