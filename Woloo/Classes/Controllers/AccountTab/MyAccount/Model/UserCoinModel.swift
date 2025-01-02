//
//  UserCoinModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 29/06/23.
//

import Foundation

struct UserCoinModel: Codable{
    
    var totalCoins: Int?
    var totalGiftCoins: Int?
    
    
    enum CodingKeys: String, CodingKey {
        
        case totalCoins = "totalCoins"
        case totalGiftCoins = "totalGiftCoins"
        
    }
}
