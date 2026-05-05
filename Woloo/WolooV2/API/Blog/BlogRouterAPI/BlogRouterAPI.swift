//
//  BlogRouterAPI.swift
//  Woloo
//
//  Created by Kapil Dongre on 10/09/24.
//

import Foundation
import Alamofire

class BlogRouterAPI: BaseAPI {
    var baseComponent: String {
        return "api/blog"
    }
    
    func POSTAction(action : APIRestAction, endValue:String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        self.setupPathComponents(action, strVal: endValue)
        super.POSTAction(completion: completion)
    }
    
    func PUTAction(action : APIRestAction, endValue:String, multipartFormData: @escaping (MultipartFormData) -> Void, completion: @escaping (AFDataResponse<Any>)  -> Void) {
        self.setupPathComponents(action, strVal: endValue)
        super.PUTAction(multipartFormDataBlock: multipartFormData, completion: completion)
    }
    
    func GETAction(action : APIRestAction, endValue:String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        self.setupPathComponents(action, strVal: endValue)
        super.GETAction(completion: completion)
    }
    
    func DELETEAction(action : APIRestAction, endValue:String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        self.setupPathComponents(action, strVal: endValue)
        super.DELETEAction(completion: completion)
    }
    
    func POSTAction(action : APIRestAction, endValue:String, multipartFormData: @escaping (MultipartFormData) -> Void, completion: @escaping (AFDataResponse<Any>)  -> Void) {
        self.setupPathComponents(action, strVal: endValue)
        super.upload(multipartFormDataBlock: multipartFormData, completion: completion)
    }
 
    func setupPathComponents(_ action: APIRestAction, strVal:String) {
        var subPath: NSArray?

        if action == .getCategories{
            subPath = ["\(baseComponent)/getCategories"]
        }
        
        if action == .saveUserCategory{
            subPath = ["\(baseComponent)/saveUserCategory"]
        }
        
        if action == .ecomCoinUpdate{
            subPath = ["\(baseComponent)/ecomCoinUpdate"]
        }
        
        if action == .getBlogComments{
            subPath = ["\(baseComponent)/\(strVal)/comments"]
        }
        
        if action == .addBlogComments{
            subPath = ["\(baseComponent)/comments"]
        }
        
        
        if action == .addBlogComments{
            subPath = ["\(baseComponent)/comments"]
        }
        
       
        if action == .blockBlog{
            subPath = ["\(baseComponent)/blockBlog"]
        }
        
        if (subPath?.count)! > 0 {
            pathComponents.addObjects(from: subPath as! [Any])
        }
    }
}
