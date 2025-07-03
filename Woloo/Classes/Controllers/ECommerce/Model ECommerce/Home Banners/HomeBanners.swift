//
//  HomeBanners.swift
//  Woloo
//
//  Created by Rahul Patra on 04/08/21.
//

import Foundation

// MARK: - HomeBanner
class HomeBanner: Codable {
    let id, image, dateTime, status: String?

    enum CodingKeys: String, CodingKey {
        case id, image
        case dateTime = "date_time"
        case status
    }

    init(id: String?, image: String?, dateTime: String?, status: String?) {
        self.id = id
        self.image = image
        self.dateTime = dateTime
        self.status = status
    }
}

typealias HomeBanners = [HomeBanner]
