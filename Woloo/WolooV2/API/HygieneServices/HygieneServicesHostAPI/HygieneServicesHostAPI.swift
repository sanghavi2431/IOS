//
//  HygieneServicesHostAPI.swift
//  Woloo
//
//  Created by CEPL on 09/07/25.
//

import Foundation
import Alamofire

class HygieneServicesHostAPI: NSObject{
    
    func getServiceCategories(success: @escaping (_ objCommonWrapper: ProductcategoryWrapper)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = HygieneServicesHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getProductCategories, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : ProductcategoryWrapper? = ProductcategoryWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    
    func getProductListOnCategoryID(strCategoryId: String?,success: @escaping (_ objCommonWrapper: ProductListWrapper)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue("*variants.calculated_price, variants.inventory_quantity,*categories", forKey: "fields")
        parameters.setValue(strCategoryId ?? "", forKey: "category_id")
        
       
        let api = HygieneServicesHostRouterAPI(params: parameters)
        
        api.GETAction(action: .getProducList, endValue1: "", endValue2: "") { (response) in
            
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : ProductListWrapper? = ProductListWrapper.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    func getProductReviews(strProductId: String?,success: @escaping (_ objCommonWrapper: ProductReviewWrapper)->Void,
                      failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        
        let api = HygieneServicesHostRouterAPI(params: parameters)
        api.GETAction(action: .getProductReviews, endValue1: "\(strProductId ?? "")", endValue2: "all") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : ProductReviewWrapper? = ProductReviewWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
        
    }
}
