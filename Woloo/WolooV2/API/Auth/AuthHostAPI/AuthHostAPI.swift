//
//  AuthHostAPI.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import Foundation
import Alamofire

class AuthHostAPI: NSObject
{
    
    func userRegisterAPI(strMail: String?, strPassword: String?, success: @escaping (_ objCommonWrapper: UserRegisterWrapper)->Void,
                         failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strMail ?? "", forKey: "email")
        parameters.setValue(strPassword ?? "", forKey: "password")
        
        let api = AuthHostRouterAPI(params: parameters)
        
        api.POSTAction(action: .userRegister, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : UserRegisterWrapper? = UserRegisterWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
    
    func emailPassAPI(strMail: String?, strPassword: String?, success: @escaping (_ objCommonWrapper: UserRegisterWrapper)->Void,
                         failure: @escaping (Error?)-> Void){
        
        let parameters = NSMutableDictionary()
        parameters.setValue(strMail ?? "", forKey: "email")
        parameters.setValue("\(strPassword ?? "")", forKey: "password")
        
        let api = AuthHostRouterAPI(params: parameters)
        
        api.POSTActionUserRegister(action: .emailpass, endValue: "") { (response) in
                    
                    if(SSError.isErrorReponse(operation: response.response))
                    {
                        let error = SSError.errorWithData(data:response)
                        failure(SSError.getErrorMessage(error) as? Error)
                    }
                    else
                    {
                        guard let data = response.data else { return }
                        if let objParsed : UserRegisterWrapper? = UserRegisterWrapper.decode(data){
                            success(objParsed!)
                        }
                    }
                }
    }
    
}
