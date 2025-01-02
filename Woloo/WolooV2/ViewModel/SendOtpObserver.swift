//
//  SendOtpObserver.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation
import UIKit

class SendOtpObserver: BaseObservableObject{
    
    var requestIDReceived: String = ""
    var sendOtpObserver: SendOtpModel? = nil
    
    
    func sendOtp(mobileNumber: String,referral_code: String?, showLoading: Bool? = true){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        if let show = showLoading, show {
            Global.showIndicator()
        }
        
        //MARK: Network Call
        
        let data = ["mobileNumber": mobileNumber, "referral_code": referral_code] as [String : Any]
        //https://api.woloo.in/api/wolooGuest/sendOTP
        //http://13.127.174.98/api/wolooGuest/sendOTP
        NetworkManager(data: data, url: nil, service: .sendOtp, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<SendOtpModel>, Error>) in
            
            switch result{
            case .success(let response):
                self.sendOtpObserver = response.results
                print("Send OTP response -------->",response)
                self.requestIDReceived = response.results.request_id ?? ""

                print("Request ID received",self.requestIDReceived)
                
                apiRequestID = response.results.request_id ?? ""
                
                Global.hideIndicator()
                
                navigateFlag = true
                
            case .failure(let error):
                print("sendOtp error", error)
            }
            
        }
        
    }
    
}

    
    var apiRequestID = ""
var navigateFlag = false



