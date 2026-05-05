//
//  MyHistoryViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 13/09/24.
//

import Foundation

protocol MyHistoryViewModelDelegate {
    
    func didReceiveMyHistoryResponse(objResponse: BaseResponse<MyHistory>)
    
    func didReceiceMyHistoryError(strError: String)
    
}

struct MyHistoryViewModel {
    
    var delegate : MyHistoryViewModelDelegate?
    
    
    func myHistoryAPI(pageNumber: Int?){
        
        WolooHostAPI().wolooRewardHistory(pageNumber: pageNumber) { objCommonWrapper in
            self.delegate?.didReceiveMyHistoryResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiceMyHistoryError(strError: error?.localizedDescription ?? "")
        }
        
    }
}
