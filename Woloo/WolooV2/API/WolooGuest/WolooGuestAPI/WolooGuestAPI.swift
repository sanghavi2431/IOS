//
//  WolooGuestAPI.swift
//  Woloo
//
//  Created by Kapil Dongre on 06/09/24.
//

import Foundation
import Alamofire

class WolooGuestAPI: NSObject {
    
    func getUserProfile(success: @escaping (_ objCommonWrapper: BaseResponse<UserProfileModel>)->Void,
                        failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        let api = WolooGuestRouterAPI(params: parameters)
        
        api.GETAction(action: .profile, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<UserProfileModel>? = BaseResponse<UserProfileModel>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
        
    }
    
    func editProfileGender(gender: String?, success: @escaping (_ objCommonWrapper: BaseResponse<Profile>)->Void,
                     failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(gender ?? "", forKey: "gender")
        parameters.setValue(String(UserDefaultsManager.fetchUserID()), forKey: "id")
       
        let api = WolooGuestRouterAPI(params: parameters)
        api.PUTAction(action: .wolooGuest, endValue: "") { multipartFormData in
            //
        } completion: { (response) in
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : BaseResponse<Profile>? = BaseResponse<Profile>.decode(data){
                    success(objParsed!)
                }
            }
        }

    }
    
    
    func editProfile(objProfile:  UserProfileModel.Profile?, success: @escaping (_ objCommonWrapper: BaseResponse<Profile>)->Void,
                     failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(String(UserDefaultsManager.fetchUserID()), forKey: "id")
        parameters.setValue(objProfile?.name ?? "", forKey: "name")
        parameters.setValue(objProfile?.email ?? "", forKey: "email")
        parameters.setValue(objProfile?.address ?? "", forKey: "address")
        parameters.setValue(objProfile?.city ?? "", forKey: "city")
        parameters.setValue(objProfile?.pincode ?? "", forKey: "pincode")
        parameters.setValue(objProfile?.dob ?? "", forKey: "dob")
        parameters.setValue(objProfile?.gender ?? "", forKey: "gender")
        
        let api = WolooGuestRouterAPI(params: parameters)
        api.PUTAction(action: .wolooGuest, endValue: "") { multipartFormData in
            //
        } completion: { (response) in
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : BaseResponse<Profile>? = BaseResponse<Profile>.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    
    func updateShopAPI(objProfile:  UserProfileModel.Profile?, success: @escaping (_ objCommonWrapper: BaseResponse<Profile>)->Void,
                     failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(String(UserDefaultsManager.fetchUserID()), forKey: "id")
        
        parameters.setValue(objProfile?.address ?? "", forKey: "address")
        parameters.setValue(objProfile?.city ?? "", forKey: "city")
        parameters.setValue(objProfile?.pincode ?? "", forKey: "pincode")
       
        let api = WolooGuestRouterAPI(params: parameters)
        api.PUTAction(action: .wolooGuest, endValue: "") { multipartFormData in
            //
        } completion: { (response) in
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : BaseResponse<Profile>? = BaseResponse<Profile>.decode(data){
                    success(objParsed!)
                }
            }
        }
    }
    
    func uploadProfileImage(profileImage: UIImage?, success: @escaping (_ objCommonWrapper: BaseResponse<Profile>)->Void,
                            failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(String(UserDefaultsManager.fetchUserID()), forKey: "id")
        let api = WolooGuestRouterAPI(params: parameters)
        
        api.PUTAction(action: .wolooGuest, endValue: "") { multipartFormData in
            let imgData = Utility.compressImage(image: profileImage ?? UIImage())
            
            let fileName = "profileimage.jpeg"
            
            multipartFormData.append(imgData, withName: "avatar", fileName: fileName, mimeType: "image/jpeg")
            
        } completion: { (response) in
            if(SSError.isErrorReponse(operation: response.response))
            {
                let error = SSError.errorWithData(data:response)
                failure(SSError.getErrorMessage(error) as? Error)
            }
            else
            {
                guard let data = response.data else { return }
                if let objParsed : BaseResponse<Profile>? = BaseResponse<Profile>.decode(data){
                    success(objParsed!)
                }
            }
        }
        
    }
    
    func wahCertificate(wolooId: String?,success: @escaping (_ objCommonWrapper: BaseResponse<WahCertificate>)->Void,
                        failure: @escaping (Error?)-> Void){
     
        let parameters = NSMutableDictionary()
        parameters.setValue(wolooId ?? "", forKey: "woloo_id")
        
        let api = WolooGuestRouterAPI(params: parameters)
        
        api.GETAction(action: .wahCertificate, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<WahCertificate>? = BaseResponse<WahCertificate>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func setPeriodTracker(objPeriodTracker: ViewPeriodTrackerModel?, success: @escaping (_ objCommonWrapper: BaseResponse<ViewPeriodTrackerModel>)->Void,
                          failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(objPeriodTracker?.periodDate, forKey: "period_date")
        parameters.setValue(objPeriodTracker?.cycleLength, forKey: "cycle_length")
        parameters.setValue(objPeriodTracker?.periodLength, forKey: "period_length")
        parameters.setValue(objPeriodTracker?.lutealLength, forKey: "luteal_length")
        parameters.setValue(objPeriodTracker?.log, forKey: "log")
        
        let api = WolooGuestRouterAPI(params: parameters)
        
        
        api.POSTAction(action: .periodtracker, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<ViewPeriodTrackerModel>? = BaseResponse<ViewPeriodTrackerModel>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func getTermsPage(success: @escaping (_ objCommonWrapper: BaseResponse<TermsModel>)->Void,
                          failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
       
        
        let api = WolooGuestRouterAPI(params: parameters)
        
        
        api.GETAction(action: .terms, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<TermsModel>? = BaseResponse<TermsModel>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
   
    func getAboutPage(success: @escaping (_ objCommonWrapper: BaseResponse<TermsModel>)->Void,
                          failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
       
        
        let api = WolooGuestRouterAPI(params: parameters)
        
        
        api.GETAction(action: .about, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : BaseResponse<TermsModel>? = BaseResponse<TermsModel>.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    func registerAPI(success: @escaping (_ objCommonWrapper: RegisterWrapper)->Void,
                          failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
       
        
        let api = WolooGuestRouterAPI(params: parameters)
        
        
        api.PATCHAction(action: .register, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : RegisterWrapper? = RegisterWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
}

