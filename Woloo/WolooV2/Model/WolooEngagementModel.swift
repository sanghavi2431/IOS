//
//  WolooEngagementModel.swift
//  MySDK
//
//  Created by DigitalFlake Kapil Dongre on 09/08/23.
//

import Foundation

struct WolooEngagementModel: Codable{
    
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}
