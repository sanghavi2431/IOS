//
//  OrderSummaryPopUpViewModel.swift
//  Woloo
//
//  Created by CEPL on 18/04/25.
//

import Foundation

protocol OrderSummaryPopUpViewModelDelegate: NSObject{
    
    func didReceievEcomCoinUpdateAPISuccess(objResponse: BaseResponse<StatusSuccessResponseModel>)
    
    func didReceievEcomCoinUpdateAPIAPIError(strError: String)
    
}

struct OrderSummaryPopUpViewModel{
    
    var delegate: OrderSummaryPopUpViewModelDelegate?
    
    func ecomCoinUpdateAPI(strOrderID: String?){
        
        BlogAPI().ecomcoinUpdateAPI(strOrderID: strOrderID ?? "") { objCommonWrapper in
            self.delegate?.didReceievEcomCoinUpdateAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievEcomCoinUpdateAPIAPIError(strError: error?.localizedDescription ?? "")
        }

    }
}
