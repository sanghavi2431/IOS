//
//  ProductCategories.swift
//  Woloo
//
//  Created by Rahul Patra on 28/08/21.
//

import Foundation

// MARK: - ProductCategory
class ProductCategory: Codable {
    let id, categoryID, name, image: String?
    let dateTime, status: String?
    
    var getFinalImage: String {
        get {
            API.environment.shoopingImageUrl + (image ?? "")
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case name, image
        case dateTime = "date_time"
        case status
    }

    init(id: String?, categoryID: String?, name: String?, image: String?, dateTime: String?, status: String?) {
        self.id = id
        self.categoryID = categoryID
        self.name = name
        self.image = image
        self.dateTime = dateTime
        self.status = status
    }
}

typealias ProductCategories = [ProductCategory]
