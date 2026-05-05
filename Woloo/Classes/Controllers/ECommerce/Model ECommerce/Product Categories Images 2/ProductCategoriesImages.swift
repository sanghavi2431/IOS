//
//  ProductCategoriesImages.swift
//  Woloo
//
//  Created by Rahul Patra on 28/08/21.
//

import Foundation

// MARK: - ProductCategoriesImage
class ProductCategoriesImage: Codable {
    let id, productID: String?
    let img: String?
    let dateTime: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case img
        case dateTime = "date_time"
        case status
    }

    init(id: String?, productID: String?, img: String?, dateTime: String?, status: String?) {
        self.id = id
        self.productID = productID
        self.img = img
        self.dateTime = dateTime
        self.status = status
    }
}

typealias ProductCategoriesImages = [ProductCategoriesImage]
