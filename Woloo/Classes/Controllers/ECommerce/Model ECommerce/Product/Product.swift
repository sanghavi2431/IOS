//
//  Product.swift
//  Woloo
//
//  Created by Rahul Patra on 04/08/21.
//

import Foundation

// MARK: - Product
class Product: Codable {
    let id, productOf, vendorID, franchiseeID: String?
    let catID, productType, name: String?
    let customerMarginPer, franchiseeMarginPer, hostMarginPer, boxSingleQty: String?
    let boxSingleCustomerMargin, stock, desc, uses: String?
    let weight, hsnCode, countryOfOrigin, sku: String?
    let brand, productID, productIDType, batchID: String?
    let size, color, dimensions, netQuantity: String?
    let mrp, manufacturer, gstType, gstPer: String?
    let manufacturingDate, isProductExpirable, expiryDate, ageGroup: String?
    let searchTerms, videoURL, relationType, variationTheme: String?
    let parentSku, parentage, deliveryTime: String?
    let productJSONData: String?
    let dateTime, status: String?
    let image: String?
    let sub_cat_id: String?
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productOf = "product_of"
        case vendorID = "vendor_id"
        case franchiseeID = "franchisee_id"
        case catID = "cat_id"
        case productType = "product_type"
        case name, price
        case customerMarginPer = "customer_margin_per"
        case franchiseeMarginPer = "franchisee_margin_per"
        case hostMarginPer = "host_margin_per"
        case boxSingleQty = "box_single_qty"
        case boxSingleCustomerMargin = "box_single_customer_margin"
        case stock, desc, uses, weight
        case hsnCode = "hsn_code"
        case countryOfOrigin = "country_of_origin"
        case sku, brand
        case productID = "product_id"
        case productIDType = "product_id_type"
        case batchID = "batch_id"
        case size, color, dimensions
        case netQuantity = "net_quantity"
        case mrp, manufacturer
        case gstType = "gst_type"
        case gstPer = "gst_per"
        case manufacturingDate = "manufacturing_date"
        case isProductExpirable = "is_product_expirable"
        case expiryDate = "expiry_date"
        case ageGroup = "age_group"
        case searchTerms = "search_terms"
        case videoURL = "video_url"
        case relationType = "relation_type"
        case variationTheme = "variation_theme"
        case parentSku = "parent_sku"
        case parentage
        case deliveryTime = "delivery_time"
        case productJSONData = "product_json_data"
        case dateTime = "date_time"
        case status, image, sub_cat_id
    }
    
    init(id: String?, productOf: String?, vendorID: String?, franchiseeID: String?, catID: String?, productType: String?, name: String?, price: Double?, customerMarginPer: String?, franchiseeMarginPer: String?, hostMarginPer: String?, boxSingleQty: String?, boxSingleCustomerMargin: String?, stock: String?, desc: String?, uses: String?, weight: String?, hsnCode: String?, countryOfOrigin: String?, sku: String?, brand: String?, productID: String?, productIDType: String?, batchID: String?, size: String?, color: String?, dimensions: String?, netQuantity: String?, mrp: String?, manufacturer: String?, gstType: String?, gstPer: String?, manufacturingDate: String?, isProductExpirable: String?, expiryDate: String?, ageGroup: String?, searchTerms: String?, videoURL: String?, relationType: String?, variationTheme: String?, parentSku: String?, parentage: String?, deliveryTime: String?, productJSONData: String?, dateTime: String?, status: String?, image: String?, sub_cat_id: String?) {
        self.id = id
        self.productOf = productOf
        self.vendorID = vendorID
        self.franchiseeID = franchiseeID
        self.catID = catID
        self.productType = productType
        self.name = name
        self.price = price
        self.customerMarginPer = customerMarginPer
        self.franchiseeMarginPer = franchiseeMarginPer
        self.hostMarginPer = hostMarginPer
        self.boxSingleQty = boxSingleQty
        self.boxSingleCustomerMargin = boxSingleCustomerMargin
        self.stock = stock
        self.desc = desc
        self.uses = uses
        self.weight = weight
        self.hsnCode = hsnCode
        self.countryOfOrigin = countryOfOrigin
        self.sku = sku
        self.brand = brand
        self.productID = productID
        self.productIDType = productIDType
        self.batchID = batchID
        self.size = size
        self.color = color
        self.dimensions = dimensions
        self.netQuantity = netQuantity
        self.mrp = mrp
        self.manufacturer = manufacturer
        self.gstType = gstType
        self.gstPer = gstPer
        self.manufacturingDate = manufacturingDate
        self.isProductExpirable = isProductExpirable
        self.expiryDate = expiryDate
        self.ageGroup = ageGroup
        self.searchTerms = searchTerms
        self.videoURL = videoURL
        self.relationType = relationType
        self.variationTheme = variationTheme
        self.parentSku = parentSku
        self.parentage = parentage
        self.deliveryTime = deliveryTime
        self.productJSONData = productJSONData
        self.dateTime = dateTime
        self.status = status
        self.image = image
        self.sub_cat_id = sub_cat_id
    }
}


/**
 
 "quantity": null,
 "short_description": null,
 "featured_pro": null,
 "new_product": null,
 "deal_day": null,
 "related": null,
 "length": null,
 "breath": null,
 "height": null,
 "hazradous": null,
 "imported": null,
 "safety_warnings": null,
 "volume": null,
 "shelf_life": null,
 
 
 
 */
