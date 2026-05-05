//
//  LoginViewModel.swift
//  Woloo
//
//  Created by CEPL on 05/06/25.
//

import Foundation

protocol LoginViewModelDelegate{
    
    func didSendOtpSuccessResponse(objResponse: BaseResponse<SendOtpModel>)
    
    func didSendOtpError(strError: String)
}
    


struct LoginViewModel {
    
    var delegate: LoginViewModelDelegate?
    
    func sendOtp(mobileNumber: String?,referral_code: String?){
        
        WolooGuestAPI().sendOTP(mobileNumber: mobileNumber ?? "", referral_code: referral_code ?? "") { objCommonWrapper in
            self.delegate?.didSendOtpSuccessResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didSendOtpError(strError: error ?? "")
        }


    }
    
}
