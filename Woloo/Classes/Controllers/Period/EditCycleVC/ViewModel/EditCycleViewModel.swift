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
}
