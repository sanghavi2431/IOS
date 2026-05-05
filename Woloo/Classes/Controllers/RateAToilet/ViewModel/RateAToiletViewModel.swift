//
//  RateAToiletViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 20/01/25.
//

import Foundation

//StatusSuccessResponseModel
protocol RateAToiletViewModelProtocol: NSObjectProtocol {
    
    func didReceievCreateWolooWithRateToiletSuccess(objResponse: BaseResponse<StatusSuccessResponseModel>)
    
    func didReceivecreteWolooWithRateToiletError(strError: String)
    
    func didReceiveCreditUserCoinsResponse(objResponse: CoinsWrapper)
    
    func didReceiceCreditUserCoinsError(strError: String)
}

struct RateAToiletViewModel{
    
    var delegate : RateAToiletViewModelProtocol?
    
    func createWolooWithRateToilet(rating: Int, strReviewDescription: String?, strName: String?, strAddress: String?, strCity: String?, lat: Double?, lng: Double?, strPincode: String?){
        WolooHostAPI().createWolooWithRateToilet(rating: rating, strReviewDescription: strReviewDescription, strName: strName, strAddress: strAddress, strCity: strCity, lat: lat, lng: lng, strPincode: strPincode) { objCommonWrapper in
            self.delegate?.didReceievCreateWolooWithRateToiletSuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceivecreteWolooWithRateToiletError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func creditUserCoins(blogId: Int?,coins: Int?, isGift: Int?, strRemarks: String?,strType: String?, woloo_id: Int?, wolooCoins: Int?){
        
        WolooGuestAPI().creditUserCoins(blogId: blogId ?? 0, coins: coins ?? 0, isGift: isGift ?? 0, strRemarks: strRemarks ?? "", strType: strType ?? "", woloo_id: woloo_id ?? 0, wolooCoins: wolooCoins ?? 0) { objCommonWrapper in
            self.delegate?.didReceiveCreditUserCoinsResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiceCreditUserCoinsError(strError: error?.localizedDescription ?? "")
        }

    }
    
    
}
