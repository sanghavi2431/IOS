//
//  History.swift
//  Woloo
//
//  Created by Kapil Dongre on 13/09/24.
//

import Foundation

struct MyHistory : Codable {
    
    var total_count: Int?
    var last_page: Int?
    var history_count: Int?
    var history = [History]()
    
}
