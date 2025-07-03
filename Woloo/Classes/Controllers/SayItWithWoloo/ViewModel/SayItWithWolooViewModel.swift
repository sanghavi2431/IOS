//
//  SayItWithWolooViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 23/01/25.
//

import Foundation

protocol SayItWithWolooViewModelDelegate{
    
    func didReceiveFileUploadResponse(objResponse: FileUploadWrapper)
    
    func didUploadFileUploadError(strError: String)
    
    func didReceiveAddMessageResponse(objResponse: AddMessageWrapper)
    
    func didReceiveAddMessageError(strError: String)
}

struct SayItWithWolooViewModel {
    var delegate: SayItWithWolooViewModelDelegate?
    
    func fileUpload(image : UIImage, QrId: String?){
        
        SayItWithWolooAPI().fileUpload(image: image, QrId: QrId ?? "") { objCommonWrapper in
            self.delegate?.didReceiveFileUploadResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didUploadFileUploadError(strError: error?.localizedDescription ?? "")
        }
    }
    
    func addMessage(objAddMesage: AddMessageModel?){
        SayItWithWolooAPI().addMessage(objAddMesage: objAddMesage ?? AddMessageModel()) { objCommonWrapper in
            self.delegate?.didReceiveAddMessageResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiveAddMessageError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
}
