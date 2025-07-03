//
//  EditProfileViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 12/09/24.
//

import Foundation

protocol EditProfileViewModelDelegate {
    
    func didReceiveEditProfileResponse(objResponse: BaseResponse<Profile>)
    
    func didReceiceEditProfileError(strError: String)
    
}

struct EditProfileViewModel {
    
    var delegate : EditProfileViewModelDelegate?
    
    func editProfileAPI(objProfile: UserProfileModel.Profile?){
        
        WolooGuestAPI().editProfile(objProfile: objProfile ??  UserProfileModel.Profile()) { objCommonWrapper in
            self.delegate?.didReceiveEditProfileResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiceEditProfileError(strError: error?.localizedDescription ?? "")
        }

    }
    
    func updateShopAddressAPI(objProfile: UserProfileModel.Profile?){
        
        WolooGuestAPI().updateShopAPI(objProfile: objProfile ??  UserProfileModel.Profile()) { objCommonWrapper in
            self.delegate?.didReceiveEditProfileResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiceEditProfileError(strError: error?.localizedDescription ?? "")
        }

    }
}
