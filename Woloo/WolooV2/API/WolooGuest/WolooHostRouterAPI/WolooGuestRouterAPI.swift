//
//  WolooHostRouterAPI.swift
//  Woloo
//
//  Created by Kapil Dongre on 06/09/24.
//

import Foundation
import Alamofire

class WolooGuestRouterAPI: BaseAPI {
    var baseComponent: String {
        return "api/wolooGuest"
    }
    
    func POSTAction(action : APIRestAction, endValue:String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        self.setupPathComponents(action, strVal: endValue)
        super.POSTAction(completion: completion)
    }
    
    func PATCHAction(action : APIRestAction, endValue:String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        self.setupPathComponents(action, strVal: endValue)
        super.PATCHAction(completion: completion)
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

        if action == .profile{
            subPath = ["\(baseComponent)/profile"]
        }
        
        if action == .wolooGuest{
            subPath = ["\(baseComponent)"]
        }
        
        if action == .wahCertificate{
            subPath = ["\(baseComponent)/wahcertificate"]
        }
        
        if action == .periodtracker{
            subPath = ["\(baseComponent)/periodtracker"]
        }
        
        if action == .terms{
            subPath = ["\(baseComponent)/terms"]
        }
        
        if action == .about{
            subPath = ["\(baseComponent)/about"]
        }
        
        if action == .register{
            subPath = ["\(baseComponent)/register"]
        }
        
        if (subPath?.count)! > 0 {
            pathComponents.addObjects(from: subPath as! [Any])
        }
    }
}
