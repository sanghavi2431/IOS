//
//  BaseData.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation

struct BaseData<T:Codable>: Codable {
    
    var data: T
    
    enum CodingKeys: String, CodingKey {  case data }
    
}
