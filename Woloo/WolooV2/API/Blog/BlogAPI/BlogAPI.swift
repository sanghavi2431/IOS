//
//  BlogAPI.swift
//  Woloo
//
//  Created by Kapil Dongre on 10/09/24.
//

import Foundation
import Alamofire

class BlogAPI: NSObject {
    
    //<BaseResponse<GetAllCategoryModel>
    func getCategories(success: @escaping (_ objCommonWrapper: BaseResponse<[CategoryModel]>)->Void,
                       failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = BlogRouterAPI(params: parameters)
        
        api.GETAction(action: .getCategories, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<[CategoryModel]>? = BaseResponse<[CategoryModel]>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func saveBlogCategory(arrInt: [Int], success: @escaping (_ objCommonWrapper: BaseResponse<StatusSuccessResponseModel>)->Void,
                          failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let stringArray = arrInt.map { String($0) }
        parameters.setValue(stringArray, forKey: "categories")
        
        let api = BlogRouterAPI(params: parameters)
        api.POSTAction(action: .saveUserCategory, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<StatusSuccessResponseModel>? = BaseResponse<StatusSuccessResponseModel>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
        
    }
}
