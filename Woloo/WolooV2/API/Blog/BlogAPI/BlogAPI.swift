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
    
    func ecomcoinUpdateAPI(strOrderID: String?, success: @escaping (_ objCommonWrapper: BaseResponse<StatusSuccessResponseModel>)->Void,
                           failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue("points", forKey: "type")
        parameters.setValue(10, forKey: "coins")
        parameters.setValue(strOrderID ?? "", forKey: "orderid")
        
        let api = BlogRouterAPI(params: parameters)
        
        api.POSTAction(action: .ecomCoinUpdate, endValue: "") { (response) in
                    
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
    
    func getBlogCommentsAPI(strBlogID: Int?, success: @escaping (_ objCommonWrapper: BaseResponse<[GetBlogComments]>)->Void,
                           failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
      
        let api = BlogRouterAPI(params: parameters)
        
        api.GETAction(action: .getBlogComments, endValue: "\(strBlogID ?? 0)") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<[GetBlogComments]>? = BaseResponse<[GetBlogComments]>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func addBlogComments(blogID: Int?, strComment: String?, success: @escaping (_ objCommonWrapper: BaseResponse<BlogAddComment>)->Void,
                         failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        
        
        parameters.setValue(String(blogID ?? 0), forKey: "blog_id")
        parameters.setValue(String(UserDefaultsManager.fetchUserID()), forKey: "user_id")
        parameters.setValue(strComment ?? "", forKey: "comment_text")
      
        let api = BlogRouterAPI(params: parameters)
        
        api.POSTAction(action: .addBlogComments, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<BlogAddComment>? = BaseResponse<BlogAddComment>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func blockBlogs(blogID: Int?,success: @escaping (_ objCommonWrapper: BaseResponse<BlogWrapper>)->Void,
                         failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        
        
        parameters.setValue(String(blogID ?? 0), forKey: "blog_id")
        parameters.setValue(String(UserDefaultsManager.fetchUserID()), forKey: "user_id")
      
        let api = BlogRouterAPI(params: parameters)
        
        api.POSTAction(action: .blockBlog, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<BlogWrapper>? = BaseResponse<BlogWrapper>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
}
