//
//  ShoppingApisManager.swift
//  Woloo
//
//  Created by Rahul Patra on 04/08/21.
//

import Foundation
import UIKit
import MobileCoreServices
import ObjectMapper

enum ShoppingApisEndPoint {
    
    //MARK:- All the typealias
    typealias CategoryId = Int
    typealias UserType = String
    typealias PINCODE = String
    typealias UserID = String
    typealias ProductID = String
    typealias OrderID = String
    typealias TEXT = String
    
    
    //MARK:- Type Ends
    case IMAGE_URL(String)
    
    //MARK:- End Points
    case getHomeCategories
    case getHomeBanners
    case getHomeProductListingAccordingToCategories(CategoryId, UserType, PINCODE)
    case saveAddress
    case getAddressList(UserID)
    case getProductDetails(ProductID, UserType, PINCODE)
    case deleteAddress(Int)
    case getShippingCharges
    case saveOrderApi
    case homeProductCategoriesApi
    case getMyOrders(UserID)
    case returnOrders(UserID, OrderID)
    case getSearchList
    case searchProduct(UserID,TEXT, PINCODE)
    
    //Coupons
    case getTotalCoupensCount
    case getCouponLists
    case getCouponsCodeDetails
    
    //MARK:- Getters
    var getDescription: String {
        get {
            switch self {
            
            case .IMAGE_URL(let endPoint):
                return API.environment.shoopingImageUrl + endPoint
            
            case .getHomeCategories:
                return "get_category_api"
                
            case .getHomeBanners:
                return "get_home_banner_api.php"
                
            case .getHomeProductListingAccordingToCategories(let catId, let userType, let pincode):
                return "get_product_list_api.php?cat_id=\(catId)&user_type=\(userType)&pincode=\(pincode)"
                
            case .saveAddress:
                return "save_address_api.php"
                
            case .getAddressList(let userId):
                return "get_address_list_api.php?user_id=\(userId)"
                
            case .getProductDetails(let productId, let userType, let pincode):
                return "get_product_details_api.php?product_id=\(productId)&user_type=\(userType)&pincode=\(pincode)"
                
            case .deleteAddress(let addressId):
                return "delete_address_api.php?delete_id=\(addressId)"
                
            case .getShippingCharges:
                return "get_shipping_charges_api.php"
                
            case .saveOrderApi:
                return "save_order_api.php"
                
            case .homeProductCategoriesApi: //new
                return "get_home_category_product_api.php"
                
            case .getTotalCoupensCount:
                return "get_total_coupon_code_count_api.php"
                
            case .getCouponLists:
                return "get_coupon_code_list_api.php"
                
            case .getCouponsCodeDetails:
                return "get_coupon_code_details_api.php"
                
            case .getMyOrders(let userId):
                return "get_my_orders_api.php?user_id=\(userId)"
                
            case .returnOrders(let userId, let orderId):
                return "return_order_api.php?user_id=\(userId)&order_id=\(orderId)"
                
            case .getSearchList:
                return "get_search_list_api.php"
                
            case .searchProduct(let userid, let searchtext, let pincode):
                return "get_search_list_api.php?user_id=\(userid)&keyword=\(searchtext)&pincode=\(pincode)"
            }
        }
    }
}


final class ShoppingApiManager {
    static let shared: ShoppingApiManager = ShoppingApiManager()
    
    
    public func apiMappableRequest(withEndPoint endPoint: ShoppingApisEndPoint ,params:[String:Any], headers: [String:String], method: APIRestClient.HTTPMethod, completion: @escaping (_ result:Result<(Data), Error>) -> Void, activity:Bool? = nil) {

        let baseUrl = API.environment.shoopingBaseUrl
        let endpoint = endPoint.getDescription
        let finalurl = "\(baseUrl + endpoint)"
        
        guard let mainUrl = URL(string: finalurl) else { return }
        
        let task = APIRestClient.shared.apiDataTask(url: mainUrl, method: method, headers: headers, parameters: params) { result in
         
            switch result {
            case .success(let data):
                print("Coming Data -> \(String(data: data.1, encoding: .utf8) ?? "")")
                completion(.success(data.1))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
