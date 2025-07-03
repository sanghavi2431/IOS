//
//  BaseAPI.swift
//  Sawin
//
//
//

import UIKit
import Alamofire

let timeZone = String(format: "%@", Utility.getCurrentTimeZone())

enum APIPostBodyType : Int {
    case APIPostBodyTypeParameters
    case APIPostBodyTypeJson
    case APIPostBodyTypeRawJson
}
enum APIRestAction : Int {
  
    //Add woloo
    case addWoloo = 0
    case recommendWoloo = 1
    case wolooRewardHistory = 2
    case creteWolooWithRateToilet = 3
    case searchWoloo = 4
    
    
    //User Profile
    case profile = 50
    case wolooGuest = 51
    case wahCertificate = 52
    case periodtracker = 53
    case terms = 54
    case about = 55
    
    
    //Blog
    case getCategories = 100
    case saveUserCategory = 101
    case ecomCoinUpdate = 102
    
    //Say it with woloo
    case addMessage = 150
    case fileUpload = 151
    
    
    //Shop Module
    case getProducList = 200
    case getProductCategories = 201
    case userRegister = 202
    case customerCreation = 203
    case emailpass = 204
    case customerMe = 205
    case addAddress = 206
    case editAddress = 207
    case carts = 208
    case getCartListings = 209
    case addItemsToCart = 210
    case removeItemsFromCart = 211
    case addReviewProduct = 212
    case setShippingAndBillingAddress = 213
    case setShippingAndBillingSameAddress = 214
    case getShippingOptions = 215
    case selectShippingMethods = 216
    case getPaymentProviders = 217
    case paymentCollections = 218
    case paymentSessions = 219
    case completeCart = 220
    case orders = 221
    case calculateShippingOptions = 222
    case createCustomerWishlist = 223
    case addWishListItems = 224
    case deleteItemFromWishList = 225
    case getWishList = 226
    case getBrandList = 227
    case delete_payment = 228
    case promotions = 229
    case complete_vendor = 230
    case register = 231
    case getBlogComments = 232
    case addBlogComments = 233
    case getStoreProductDetails = 234
    case blockBlog = 235
    case getProductReviews = 236
}


class BaseAPI: NSObject {
    var postBodyType = APIPostBodyType.APIPostBodyTypeParameters;
    var pathComponents = NSMutableArray()
    var parameters = NSMutableDictionary()
    
    var systemVersion = Utility.getAppversion()
    let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        
    
    convenience init(params dict: NSDictionary?) {
        self.init()
        
        for (_, _) in dict! {
            parameters.addEntries(from: dict as! [AnyHashable : Any]);
        }
    }
    
    func GETAction(completion: @escaping (AFDataResponse<Any>) -> Void)
    {
        let urlString = self.urlString();
        
        // print("HEADERS \(headers)")
        print("GET \(urlString)")
        print("PARAMETERS \(parameters)")
//        parameters.setValue(Utility.selectedLanguageCode(), forKey: "lang_code")
//        parameters.setValue(DEVICE_TYPE, forKey: "platform")
        
        let strToken : String = UserDefaultsManager.fetchAuthenticationToken()
        var userAgent = "\(DEVICE_TYPE)/\(AppBuild ?? "")/\(systemVersion)"
        
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strToken)){
            headers = [
                "user-agent": userAgent,
                "x-woloo-token": strToken,
                "app_version ": Utility.getAppversion(),
            ]
        }else{
            headers = [
                "user-agent": userAgent,
            ]
        }
        
        
        AF.request(urlString, method: HTTPMethod.get, parameters: (self.parameters as NSDictionary) as? Parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (response) in
            switch (response.result) {
            case .success:
                //do json stuff
                completion(response)
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    //print(response)
                    //completion(response)
                }
             
                else{
                    completion(response)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
    
    func POSTAction(completion: @escaping (AFDataResponse<Any>) -> Void)
    {
        let urlString = self.urlString();
        
        print("POST \(urlString)")
        print("PARAMETERS \(parameters)")
        let strToken : String = UserDefaultsManager.fetchAuthenticationToken()
        
        var userAgent = "\(DEVICE_TYPE)/\(AppBuild ?? "")/\(systemVersion)"
        
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strToken)){
            headers = [
                "user-agent": userAgent,
                "x-woloo-token": strToken,
                "app_version ": Utility.getAppversion(),
            ]
        }else{
            headers = [
                "user-agent": userAgent,
            ]
        }
        
        
        AF.request(urlString, method: HTTPMethod.post, parameters: (self.parameters as NSDictionary) as? Parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            switch (response.result) {
            case .success:
                //do json stuff
                completion(response)
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
                }
               
                else{
                    completion(response)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
    
    func PATCHAction(completion: @escaping (AFDataResponse<Any>) -> Void)
    {
        let urlString = self.urlString();
        
        print("POST \(urlString)")
        print("PARAMETERS \(parameters)")
        let strToken : String = UserDefaultsManager.fetchAuthenticationToken()
        
        var userAgent = "\(DEVICE_TYPE)/\(AppBuild ?? "")/\(systemVersion)"
        
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strToken)){
            headers = [
                "user-agent": userAgent,
                "x-woloo-token": strToken,
                "app_version ": Utility.getAppversion(),
            ]
        }else{
            headers = [
                "user-agent": userAgent,
            ]
        }
        
        
        AF.request(urlString, method: HTTPMethod.patch, parameters: (self.parameters as NSDictionary) as? Parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            switch (response.result) {
            case .success:
                //do json stuff
                completion(response)
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
                }
               
                else{
                    completion(response)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
        }
    }
    
    func PUTAction(multipartFormDataBlock: @escaping (MultipartFormData) -> Void,completion: @escaping (AFDataResponse<Any>) -> Void)
    {
        let strToken : String = UserDefaultsManager.fetchAuthenticationToken()
        
        var userAgent = "\(DEVICE_TYPE)/\(AppBuild ?? "")/\(systemVersion)"
        
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strToken)){
            headers = [
                "user-agent": userAgent,
                "x-woloo-token": strToken,
                "app_version ": Utility.getAppversion(),
            ]
        }else{
            headers = [
                "user-agent": userAgent,
            ]
        }
        
        AF.uploadProfile(multipartFormData: { multipartFormData in
            for (key, value) in self.parameters {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
            multipartFormDataBlock(multipartFormData)
            
        }, to: urlString(),headers:headers)
        
        .responseJSON { response in
            debugPrint(response)
            switch (response.result) {
            case .success:
                //do json stuff
                completion(response)
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
                }
                else{
                    completion(response)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
           // completion(response)
        }
    }
    
    func DELETEAction(completion: @escaping (AFDataResponse<Any>) -> Void)
    {
        let urlString = self.urlString();
        
        // print("HEADERS \(headers)")
        print("DELETE \(urlString)")
        print("PARAMETERS \(parameters)")
        var userAgent = "\(DEVICE_TYPE)/\(AppBuild ?? "")/\(systemVersion)"
        let strToken : String = UserDefaultsManager.fetchAuthenticationToken()
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strToken)){
            headers = [
                "user-agent": userAgent,
                "x-woloo-token": strToken,
            ]
        }else{
            headers = [
                "user-agent": userAgent,
            ]
        }
        
        AF.request(urlString, method: HTTPMethod.delete, parameters: (self.parameters as NSDictionary) as? Parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response:AFDataResponse<Any>) in
            completion(response)
        }
    }
    
    func upload (multipartFormDataBlock: @escaping (MultipartFormData) -> Void,completion: @escaping (AFDataResponse<Any>) -> Void) {
        let strToken : String = UserDefaultsManager.fetchAuthenticationToken()
        
        var userAgent = "\(DEVICE_TYPE)/\(AppBuild ?? "")/\(systemVersion)"
        
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strToken)){
            headers = [
                "user-agent": userAgent,
                "x-woloo-token": strToken,
            ]
        }else{
            headers = [
                "user-agent": userAgent,
            ]
        }
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in self.parameters {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
            multipartFormDataBlock(multipartFormData)
            
        }, to: urlString(),headers:headers)
        
        .responseJSON { response in
            debugPrint(response)
            switch (response.result) {
            case .success:
                //do json stuff
                completion(response)
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    //HANDLE TIMEOUT HERE
                    
                }
                else{
                    completion(response)
                }
                print("\n\nAuth request failed with error:\n \(error)")
                break
            }
           // completion(response)
        }
    }
    
    func urlString() -> String {
        var urlString: String = BASE_URL
        if pathComponents.count > 0 {
            let path: String = "/" + pathComponents.componentsJoined(by: "/")
            urlString += path
        }
        return urlString
    }
  
 
}
