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
    
    func didReceiveCreditUserCoinsResponse(objResponse: CoinsWrapper)
    
    func didReceiceCreditUserCoinsError(strError: String)
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
    
    func creditUserCoins(blogId: Int?,coins: Int?, isGift: Int?, strRemarks: String?,strType: String?, woloo_id: Int?,  wolooCoins: Int?){
        
        WolooGuestAPI().creditUserCoins(blogId: blogId ?? 0, coins: coins ?? 0, isGift: isGift ?? 0, strRemarks: strRemarks ?? "", strType: strType ?? "",woloo_id: woloo_id ?? 0, wolooCoins: wolooCoins ?? 0) { objCommonWrapper in
            self.delegate?.didReceiveCreditUserCoinsResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiceCreditUserCoinsError(strError: error?.localizedDescription ?? "")
        }

    }
}
