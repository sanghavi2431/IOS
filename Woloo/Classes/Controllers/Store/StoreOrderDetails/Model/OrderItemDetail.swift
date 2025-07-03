//
//  OrderItemDetail.swift
//  Woloo
//
//  Created by CEPL on 21/05/25.
//

import Foundation

class OrderItemDetail: Codable{
    
    var id: String? = ""
    var orderID: String? = ""
    var temID: String? = ""
    var quantity: Int?
    var shippedQuantity: Int?
    var fulfilledQuantity: Int?
    var returnRequestedQuantity: Int?
    var returnReceivedQuantity: Int?
    var writtenOffQuantity: Int?
    var returnDismissedQuantity: Int?
    var deliveredQuantity: Int?
    var updatedAt: String? = ""
    var createdAt: String? = ""
       // let rawUnitPrice: RawAmount?
    var version: Int?
}
