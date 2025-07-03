//
//  Products+CoreDataProperties.swift
//  Woloo
//
//  Created by Rahul Patra on 08/08/21.
//
//

import Foundation
import CoreData


extension LocalProducts {

    @nonobjc public class func fetchRequests() -> NSFetchRequest<LocalProducts> {
        return NSFetchRequest<LocalProducts>(entityName: "LocalProducts")
    }

    @NSManaged public var name: String?
    @NSManaged public var vendorName: String?
    @NSManaged public var product_id: Int32
    @NSManaged public var vendor_id: Int32
    @NSManaged public var price: Double
    @NSManaged public var odderPrice: Double
    @NSManaged public var points: Double
    @NSManaged public var productPrice: Double
    @NSManaged public var offPoints: Double
    @NSManaged public var desc: String?
    @NSManaged public var qty: Int32
    @NSManaged public var productImage: String?
    @NSManaged public var isPointsUsed: Bool
    @NSManaged public var stock: Int32
    @NSManaged public var coupon_value: Double
    @NSManaged public var coupon_applied: Bool
    @NSManaged public var coupon_code: String
    @NSManaged public var coupon_value_unit: String
    @NSManaged public var is_pincod_availabel: Bool

}

extension LocalProducts : Identifiable {

}
