//
//  SayItWithWolooModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import Foundation

struct GetMessage: Codable {
    
    var status: Int?
    var MessageId: Int?
    var Name: String? = ""
    var Number: String? = ""
    var Message: String? = ""
    var AttachmentURL: String? = ""
    var isAttachmentURL: String? = ""
}
