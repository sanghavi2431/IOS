//
//  MoreViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 16/09/24.
//

import Foundation


protocol MoreViewModelDelegate{
    
    func didReceiveUploadProfilePhotoResponse(objResponse: BaseResponse<Profile>)
    
    func didUploadProfilePhotoError(strError: String)
}

struct MoreViewModel{
    
    var delegate : MoreViewModelDelegate?
    
    func uploadProfileImage(profileImage : UIImage?){
        
        WolooGuestAPI().uploadProfileImage(profileImage: profileImage ?? UIImage()) { objCommonWrapper in
            self.delegate?.didReceiveUploadProfilePhotoResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didUploadProfilePhotoError(strError: error?.localizedDescription ?? "")
        }

    }
    
}
