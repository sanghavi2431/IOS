//
//  TechnicianAPI.swift
//  Sawin
//
//
//

import UIKit
import Alamofire

class WolooHostAPI: NSObject {

    func addWolooAPI(images : [UIImage], name: String?, address: String? ,city: String?, lat: Double?, long: Double?, pincode: String?,
                                    success: @escaping (_ objCommonWrapper: BaseResponse<StatusSuccessResponseModel>)->Void,
                                    failure: @escaping (Error?)-> Void)
        {
            let parameters = NSMutableDictionary()
            parameters.setValue(name, forKey: "name")
            parameters.setValue(address, forKey: "address")
            parameters.setValue(city, forKey: "city")
            parameters.setValue(String(lat ?? 0.0), forKey: "lat")
            parameters.setValue(String(long ?? 0.0), forKey: "lng")
            parameters.setValue(pincode, forKey: "pincode")
            
            
            let api = WolooHostRouterAPI(params: parameters)
            
            
            api.POSTAction(action: .addWoloo, endValue: "") { multipartFormData in
                // Append each image from the array
                           for (index, image) in images.enumerated() {
                               let imgData = Utility.compressImage(image: image)
                               let fileName = "image_\(index).jpeg"
                               multipartFormData.append(imgData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
                           }

            } completion: { (response) in
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
    
    
    
    func recommendWolooAPI(images : [UIImage], name: String?, address: String? ,city: String?, lat: Double?, long: Double?, pincode: String?,recommendedMobile: String?,
                                    success: @escaping (_ objCommonWrapper: BaseResponse<StatusSuccessResponseModel>)->Void,
                                    failure: @escaping (Error?)-> Void)
        {
            let parameters = NSMutableDictionary()
            parameters.setValue(name, forKey: "name")
            parameters.setValue(address, forKey: "address")
            parameters.setValue(city, forKey: "city")
            parameters.setValue(String(lat ?? 0.0), forKey: "lat")
            parameters.setValue(String(long ?? 0.0), forKey: "lng")
            parameters.setValue(pincode, forKey: "pincode")
            parameters.setValue(recommendedMobile, forKey: "recommended_mobile")
            
            
            let api = WolooHostRouterAPI(params: parameters)
            
            
            api.POSTAction(action: .recommendWoloo, endValue: "") { multipartFormData in
                // Append each image from the array
                           for (index, image) in images.enumerated() {
                               let imgData = Utility.compressImage(image: image)
                               let fileName = "image_\(index).jpeg"
                               multipartFormData.append(imgData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
                           }

            } completion: { (response) in
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
    
    func wolooRewardHistory(pageNumber: Int?,success: @escaping (_ objCommonWrapper: BaseResponse<MyHistory>)->Void,
                            failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(String(pageNumber ?? 0), forKey: "pageNumber")
        
        let api = WolooHostRouterAPI(params: parameters)
        
        api.GETAction(action: .wolooRewardHistory, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<MyHistory>? = BaseResponse<MyHistory>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
}
