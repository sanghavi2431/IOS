//
//  DashboardViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 06/09/24.
//

import Foundation

protocol DashboardViewModelDelegate{
    
    func didReceievGetUserProfile(objResponse: BaseResponse<UserProfileModel>)
    
    func didReceievGetUserProfileError(strError: String)
    
    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>)
    
    func didReceiceWahCertificateError(strError: String)
}

struct DashboardViewModel {
    
    var delegate : DashboardViewModelDelegate?
    
    func getUserProfileAPI(){
        
        WolooGuestAPI().getUserProfile { objCommonWrapper in
            self.delegate?.didReceievGetUserProfile(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievGetUserProfileError(strError: error?.localizedDescription ?? "")
        }

    }
    
    
    func wahCertificateAPI(wolooID: String?){
        WolooGuestAPI().wahCertificate(wolooId: wolooID ?? "") { objCommonWrapper in
            self.delegate?.didReceiveWahCertificateResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiceWahCertificateError(strError: error?.localizedDescription ?? "")
        }
    }
}
