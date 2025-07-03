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
    
    
}
