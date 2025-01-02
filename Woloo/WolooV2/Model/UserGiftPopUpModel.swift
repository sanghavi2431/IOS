//
//  UserGiftPopUpModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 12/05/23.
//

import Foundation

struct UserGiftPopUpModel: Codable{
    
    let message : String?
    let showPopUp : Int?
    
    enum CodingKeys: String, CodingKey{
        
        case message = "message"
        case showPopUp = "showPopUp"
    }
    
}
