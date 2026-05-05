//
//  PowderRoomPassViewModel.swift
//  Woloo
//
//  Created by CEPL on 07/10/25.
//

import Foundation

protocol PowderRoomPassViewModelProtocol: NSObjectProtocol {
    
    func didReceievPowderRoomPaymentSuccess(objResponse: BaseResponse<PowderRoomPass>)
    
    func didReceivePowderRoomPaymentError(strError: String)
    
}

struct PowderRoomPassViewModel{
    var delegate : PowderRoomPassViewModelProtocol?
    
    func getpowderRoomPassPaymentID(powderRoomID: Int?, amount: Int?){
        
        WolooHostAPI().powderRoomPaymentAPI(powderRoomID: powderRoomID ?? 0, amount: amount ?? 0) { objCommonWrapper in
            self.delegate?.didReceievPowderRoomPaymentSuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceivePowderRoomPaymentError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
}
