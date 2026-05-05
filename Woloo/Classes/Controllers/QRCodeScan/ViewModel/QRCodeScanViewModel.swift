//
//  QRCodeScanViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 12/09/24.
//

import Foundation

protocol QRCodeScanViewModelDelegate {
    
    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>)
    
    func didReceiceWahCertificateError(strError: String)
}

struct QRCodeScanViewModel{
    
    var delegate : QRCodeScanViewModelDelegate?
    
    
    func wahCertificateAPI(wolooID: String?){
        WolooGuestAPI().wahCertificate(wolooId: wolooID ?? "") { objCommonWrapper in
            self.delegate?.didReceiveWahCertificateResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiceWahCertificateError(strError: error?.localizedDescription ?? "")
        }

        
    }
}
