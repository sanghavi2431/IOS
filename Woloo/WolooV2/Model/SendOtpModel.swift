//
//  SendOtpModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation

struct SendOtpModel : Codable{
    
    let request_id: String?
    
    
    enum CodingKeys: String, CodingKey{
        
    case request_id = "request_id"
        
    }
    
}
