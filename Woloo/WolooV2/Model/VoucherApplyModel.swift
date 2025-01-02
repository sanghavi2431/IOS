//
//  VoucherApplyModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 13/03/23.
//

import Foundation

struct VoucherApplyModel: Codable, Hashable {
    
    let message: String?
    let isAlreadyApplied: Bool?
    let days: Int?
    let isLifetime: Int?
    let typeOfVoucher: String?
    var isAlreadyConsumed: Bool?
    var expiryNote: String?
    
    enum CodingKeys: String, CodingKey {
        
        case message
        case isAlreadyApplied
        case days
        case isLifetime
        case typeOfVoucher
        case isAlreadyConsumed
        case expiryNote
    }
}
