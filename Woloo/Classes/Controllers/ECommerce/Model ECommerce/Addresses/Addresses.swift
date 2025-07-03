//
//  Addresses.swift
//  Woloo
//
//  Created by Rahul Patra on 05/08/21.
//

import Foundation

// MARK: - Address
class Address: Codable {
    let id, userID, name, phone: String?
    let pincode, city, state, area: String?
    let flatBuilding, landmark: String?
    let dateTime, status: String?

    var getAddress: String {
        get {
            var mainAddress = ""
            mainAddress = [flatBuilding, landmark , city , state , pincode].filter { $0 ?? "" != "" }.map { "\($0 ?? "")"}.joined(separator: ", ")
            return mainAddress
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, phone, pincode, city, state, area
        case flatBuilding = "flat_building"
        case landmark
        case dateTime = "date_time"
        case status
    }

    init(id: String?, userID: String?, name: String?, phone: String?, pincode: String?, city: String?, state: String?, area: String?, flatBuilding: String?, landmark: String?, dateTime: String?, status: String?) {
        self.id = id
        self.userID = userID
        self.name = name
        self.phone = phone
        self.pincode = pincode
        self.city = city
        self.state = state
        self.area = area
        self.flatBuilding = flatBuilding
        self.landmark = landmark
        self.dateTime = dateTime
        self.status = status
    }
}

typealias Addresses = [Address]
