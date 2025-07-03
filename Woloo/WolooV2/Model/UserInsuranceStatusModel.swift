//
//  userInsuranceStatusModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 24/03/23.
//

import Foundation

struct UserInsuranceStatusModel: Codable, Hashable {
    
    let isShowProfileForm: Bool?
    
    enum CodingKeys: String, CodingKey{
        
        case isShowProfileForm
    }
    
}
