//
//  ShopBaseAPI.swift
//  Woloo
//
//  Created by CEPL on 12/03/25.
//


import UIKit
import Alamofire

class ShopBaseAPI: NSObject {
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
        
        let strToken : String = UserDefaultsManager.fetchEmailPassToken()
        let strApiKey = Constant.ApiKey.x_publishable_Shop_key
       // let strCookie = Constant.ApiKey.Cookie_Shop_key
        let userAgent = "\(DEVICE_TYPE)/\(AppBuild ?? "")/\(systemVersion)"
        
        
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strApiKey)){
            headers = [
                "Authorization": String(format: "Bearer %@", strToken),
                "user-agent": userAgent,
                "x-publishable-api-key": strApiKey,
                //"app_version ": Utility.getAppversion(),
//                "Cookie": strCookie,
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
        let strToken : String = UserDefaultsManager.fetchEmailPassToken()
        
        let userAgent = "\(DEVICE_TYPE)/\(AppBuild ?? "")/\(systemVersion)"
        
        let strApiKey = Constant.ApiKey.x_publishable_Shop_key
       // let strCookie = Constant.ApiKey.Cookie_Shop_key
        
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strApiKey)){
            headers = [
                "Authorization": String(format: "Bearer %@", strToken),
                "x-publishable-api-key": strApiKey,
                //"Cookie": strCookie,
                //"app_version ": Utility.getAppversion(),
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
    
    func POSTActionUserRegister(completion: @escaping (AFDataResponse<Any>) -> Void)
    {
        let urlString = self.urlString();
        
        print("POST \(urlString)")
        print("PARAMETERS \(parameters)")
        let strToken : String = UserDefaultsManager.fetchUserShopRegisterToken()
        
        let userAgent = "\(DEVICE_TYPE)/\(AppBuild ?? "")/\(systemVersion)"
        
        let strApiKey = Constant.ApiKey.x_publishable_Shop_key
        //let strCookie = Constant.ApiKey.Cookie_Shop_key
        
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strApiKey)){
            headers = [
                //"user-agent": userAgent,
                "Authorization": String(format: "Bearer %@", strToken),
                "x-publishable-api-key": strApiKey,
               // "Cookie": strCookie,
                //"app_version ": Utility.getAppversion(),
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
    
    func PUTAction(multipartFormDataBlock: @escaping (MultipartFormData) -> Void,completion: @escaping (AFDataResponse<Any>) -> Void)
    {
        let strToken : String = UserDefaultsManager.fetchEmailPassToken()
        
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
        print("POST \(urlString)")
        print("PARAMETERS \(parameters)")
        let strToken : String = UserDefaultsManager.fetchEmailPassToken()
        let strApiKey = Constant.ApiKey.x_publishable_Shop_key
        //let strCookie = Constant.ApiKey.Cookie_Shop_key
        var headers = HTTPHeaders()
        if !(Utility.isEmpty(strToken)){
            headers = [
                "Authorization": String(format: "Bearer %@", strToken),
                "x-publishable-api-key": strApiKey,
               // "Cookie": strCookie,
                //"app_version ": Utility.getAppversion(),
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
        var urlString: String = SHOP_HTTP_BASE_URL
        if pathComponents.count > 0 {
            let path: String = "/" + pathComponents.componentsJoined(by: "/")
            urlString += path
        }
        return urlString
    }
  
 
}

