//
//  ListWrapperRestock.swift
//  Woloo
//
//  Created by CEPL on 27/06/25.
//

import Foundation

struct ListWrapperRestock<T: Codable>: Codable{
    
    var status: Bool?
    
    var result: T
    
    var success: Bool?
    
    
    enum CodingKeys: String, CodingKey {  case result }
}
