//
//  MainProductDetails.swift
//  Woloo
//
//  Created by Rahul Patra on 06/08/21.
//

import Foundation


//"featured_pro": null,
//"new_product": null,
//"deal_day": null,
//"related": null,
//"weight": "NA",
//"length": null,
//"breath": null,
//"height": null,
//"hazradous": null,
//"imported": null,
//"safety_warnings": null,
//"volume": null,
//"product_json_data": null,

import Foundation

// MARK: - Address
// MARK: - MainProductDetail
class MainProductDetail: Codable {
    let id, productOf, vendorID, franchiseeID: String?
    let catID, productType, name: String?
    let customerMarginPer, franchiseeMarginPer, hostMarginPer, boxSingleQty: String?
    let boxSingleCustomerMargin, stock, desc, uses: String?
    let shelfLife: String?
    let hsnCode, countryOfOrigin, sku, brand: String?
    let productID, productIDType, batchID, size: String?
    let color, dimensions: String?
    let shortDescription: String?
    let netQuantity: String?
    let quantity: String?
    let mrp, manufacturer, gstType, gstPer: String?
    let manufacturingDate, isProductExpirable, expiryDate, ageGroup: String?
    let searchTerms, videoURL, relationType, variationTheme: String?
    let parentSku, parentage, deliveryTime, dateTime: String?
    let status, vendorName, vendorImage: String?
    let price: Double?
//    let is_pincode_available: Int?
    
    var localQty: Int = 0 {
        didSet {
            updateQtyCompletion?(localQty)
        }
    }
    
    var updateQtyCompletion: ((Int) -> Void)?
    
    var getCustomerMargin: Int {
        get {
            let price = Double(self.price ?? 0.0)
            let customerMargin = Double(customerMarginPer ?? "0.0") ?? 0.0
            
            return Int(((price * customerMargin) / 100).rounded(.up))
        }
    }
    
    
    var getProductDetails: String {
        get {
            var main = ""
            
            main += "Brand Name: \(vendorName ?? "")\n"
            main += "Product ID: \(productID ?? "")\n"
            main += "Size: \(size ?? "")\n"
            main += "Color: \(color ?? "")\n"
            main += "Available Stock: \(stock ?? "")\n\n"
            main += "\((desc ?? "").htmlToAttributedString?.string.replacingOccurrences(of: "</br>", with: "") ?? "")"
            
            return main
        }
    }
    
    
    var getAdditionalInformation: String {
        get {
            var main = ""
            
            main += "Manufacturing Date: \(manufacturingDate ?? "")\n"
            main += "Is Product Expirable: \(productID ?? "")\n"
            main += "Expiry Date: \(expiryDate ?? "")\n"
            return main
        }
    }
    
    var getFeaturesBenefits: String {
        get {
            var main = ""
            main += "\((uses ?? "").replacingOccurrences(of: "</br>", with: ""))"
            return main
        }
    }

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
        case stock, desc, uses
        case shelfLife = "shelf_life"
        case hsnCode = "hsn_code"
        case countryOfOrigin = "country_of_origin"
        case sku, brand
        case productID = "product_id"
        case productIDType = "product_id_type"
        case batchID = "batch_id"
        case size, color, dimensions
        case shortDescription = "short_description"
        case netQuantity = "net_quantity"
        case quantity, mrp, manufacturer
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
        case dateTime = "date_time"
        case status
        case vendorName = "vendor_name"
        case vendorImage = "vendor_image"
//        case is_pincode_available
    }

    init(id: String?, productOf: String?, vendorID: String?, franchiseeID: String?, catID: String?, productType: String?, name: String?, price: Double?, customerMarginPer: String?, franchiseeMarginPer: String?, hostMarginPer: String?, boxSingleQty: String?, boxSingleCustomerMargin: String?, stock: String?, desc: String?, uses: String?, shelfLife: String?, hsnCode: String?, countryOfOrigin: String?, sku: String?, brand: String?, productID: String?, productIDType: String?, batchID: String?, size: String?, color: String?, dimensions: String?, shortDescription: String?, netQuantity: String?, quantity: String?, mrp: String?, manufacturer: String?, gstType: String?, gstPer: String?, manufacturingDate: String?, isProductExpirable: String?, expiryDate: String?, ageGroup: String?, searchTerms: String?, videoURL: String?, relationType: String?, variationTheme: String?, parentSku: String?, parentage: String?, deliveryTime: String?, dateTime: String?, status: String?, vendorName: String?, vendorImage: String?) {
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
        self.shelfLife = shelfLife
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
        self.shortDescription = shortDescription
        self.netQuantity = netQuantity
        self.quantity = quantity
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
        self.dateTime = dateTime
        self.status = status
        self.vendorName = vendorName
        self.vendorImage = vendorImage
//        self.is_pincode_available = is_pincode_available
    }
}

typealias MainProductDetails = [MainProductDetail]


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
