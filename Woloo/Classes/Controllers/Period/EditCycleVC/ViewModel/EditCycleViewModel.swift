//
//  EditCycleViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 16/09/24.
//

import Foundation

protocol EditCycleViewModelDelegate{
    
    func didReceivePeriodTrackerResponse(objResponse: BaseResponse<ViewPeriodTrackerModel>)
    
    func didReceievPeriodTrackerError(strError: String)
    
    func didReceiveCreditUserCoinsResponse(objResponse: CoinsWrapper)
    
    func didReceiceCreditUserCoinsError(strError: String)
    
}

struct EditCycleViewModel{
    
    var delegate: EditCycleViewModelDelegate?
    
    func setPeriodTracker(objPeriodTracker: ViewPeriodTrackerModel?){
        
        WolooGuestAPI().setPeriodTracker(objPeriodTracker: objPeriodTracker ?? ViewPeriodTrackerModel()) { objCommonWrapper in
            self.delegate?.didReceivePeriodTrackerResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievPeriodTrackerError(strError: error?.localizedDescription ?? "")
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
