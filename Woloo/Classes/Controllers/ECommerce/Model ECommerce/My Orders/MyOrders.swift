//
//  MyOrders.swift
//  Woloo
//
//  Created by Rahul Patra on 01/09/21.
//

import Foundation

// MARK: - MyOrder
class MyOrder: Codable {
    let id, orderID, productID, proPrice: String?
    let qty, amount, pointUsed, sentShipmentDateTime: String?
    let deliveredDateTime, returnRequestDateTime: String?
    let returnDateTime: String?
    let dateTime, status: String?
    let image: String?
    let price, proID, name, desc: String?
    let canReturn, canCancel: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case productID = "product_id"
        case proPrice = "pro_price"
        case qty, amount
        case pointUsed = "point_used"
        case sentShipmentDateTime = "sent_shipment_date_time"
        case deliveredDateTime = "delivered_date_time"
        case returnRequestDateTime = "return_request_date_time"
        case returnDateTime = "return_date_time"
        case dateTime = "date_time"
        case status, image, price
        case proID = "pro_id"
        case name, desc
        case canReturn = "can_return"
        case canCancel = "can_cancel"
    }

    init(id: String?, orderID: String?, productID: String?, proPrice: String?, qty: String?, amount: String?, pointUsed: String?, sentShipmentDateTime: String?, deliveredDateTime: String?, returnRequestDateTime: String?, returnDateTime: String?, dateTime: String?, status: String?, image: String?, price: String?, proID: String?, name: String?, desc: String?, canReturn: String?, canCancel: String?) {
        self.id = id
        self.orderID = orderID
        self.productID = productID
        self.proPrice = proPrice
        self.qty = qty
        self.amount = amount
        self.pointUsed = pointUsed
        self.sentShipmentDateTime = sentShipmentDateTime
        self.deliveredDateTime = deliveredDateTime
        self.returnRequestDateTime = returnRequestDateTime
        self.returnDateTime = returnDateTime
        self.dateTime = dateTime
        self.status = status
        self.image = image
        self.price = price
        self.proID = proID
        self.name = name
        self.desc = desc
        self.canReturn = canReturn
        self.canCancel = canCancel
    }
}

typealias MyOrders = [[MyOrder]]
