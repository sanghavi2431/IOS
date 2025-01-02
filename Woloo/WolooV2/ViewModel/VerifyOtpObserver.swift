//
//  VerifyOtpObserver.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation

class VerifyOtpObserver: BaseObservableObject{
    
    var verifyOtpObserver: VerifyOtpModel? = nil
    
    func verifyOtp(request_id: String, otp: String){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        //MARK: Network Call
        
        let data = ["request_id": request_id, "otp": otp] as [String : Any]
        //http://13.127.174.98/api/wolooGuest/verifyOTP
        NetworkManager(data: data, url: nil, service: .verifyOtp, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<VerifyOtpModel>, Error>) in
            switch result{
            case .success(let response):
                self.verifyOtpObserver = response.results
                print("Verify Otp response ------>",response)
                naviagteFlagOtpVerify = true
                gender = response.results.user?.gender ?? ""
                userFirstSession = response.results.user?.is_first_session ?? 0
                
                //Saving the authentication token
                UserDefaultsManager.storeAuthenticationToken(value: response.results.token ?? "")
                UserDefaultsManager.isUserloggedInStatusSave(value: true)
                
                
                
            case .failure(let error):
                print("verify Otp observer localized description", error.localizedDescription)
                print("Verify Otp error", error)
                
                naviagteFlagOtpVerify = false
                
            }
        }
        
    }
    
}

var gender = ""
var naviagteFlagOtpVerify = false
var userFirstSession: Int?
var verifyUserToken: String?

