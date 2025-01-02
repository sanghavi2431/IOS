//
//  NearByLoo&OfferCountModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 22/05/23.
//

import Foundation

struct NearByLooOfferCountModel: Codable {
    
    let wolooCount: Int?
    let offerCount: Int?
    //let shopOffer: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case wolooCount = "wolooCount"
        case offerCount = "offerCount"
        //case shopOffer = "shopOffer"
    }
    
}
