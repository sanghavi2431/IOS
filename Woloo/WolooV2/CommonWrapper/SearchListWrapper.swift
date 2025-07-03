//
//  SearchListWrapper.swift
//  Woloo
//
//  Created by CEPL on 07/06/25.
//

import Foundation


class SearchListWrapper: Codable{
    var data: [SearchWoloo]?
    var total: Int?
    var page: Int?
    var limit: Int?
    var totalPages: Int?
}
