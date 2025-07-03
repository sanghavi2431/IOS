//
//  TechnicianRouterAPI.swift
//  Sawin
//
//
//

import UIKit
import Alamofire

class WolooHostRouterAPI: BaseAPI {
    var baseComponent: String {
        return "api/wolooHost"
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

        if action == .addWoloo{
            subPath = ["\(baseComponent)/addWoloo"]
        }
        
        if action == .recommendWoloo{
            subPath = ["\(baseComponent)/recommendWoloo"]
        }
        
        if action == .wolooRewardHistory{
            subPath = ["\(baseComponent)/wolooRewardHistory"]
        }
        
        if action == .creteWolooWithRateToilet{
            subPath = ["\(baseComponent)/creteWolooWithRateToilet"]
        }
        
        if action == .searchWoloo{
            subPath = ["\(baseComponent)/search"]
        }
        
        if (subPath?.count)! > 0 {
            pathComponents.addObjects(from: subPath as! [Any])
        }
    }
}
