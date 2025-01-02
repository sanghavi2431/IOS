//
//  BaseResponse.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation

struct BaseResponse<T: Codable>: Codable{
    
    //var status: Bool
    
    var results: T
    
    
    enum CodingKeys: String, CodingKey {  case results }
}
