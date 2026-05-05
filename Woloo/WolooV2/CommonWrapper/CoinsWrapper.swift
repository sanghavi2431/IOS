//
//  CoinsWrapper.swift
//  Woloo
//
//  Created by CEPL on 26/08/25.
//

import Foundation

class CoinsWrapper: Codable{
    
    var success: Bool? = false
    var results: CreditUserCoins?
    
}

class CreditUserCoins: Codable{
    var message: String? = ""
    var wallet_id: Int?
    var totalCoins: Int?
    var giftCoins: Int?
}
