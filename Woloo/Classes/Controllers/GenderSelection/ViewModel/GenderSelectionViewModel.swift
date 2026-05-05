//
//  GenderSelectionViewModel.swift
//  Woloo
//
//  Created by Kapil Dongre on 10/09/24.
//

import Foundation

protocol GenderSelectionViewModelDelegate{
    
    func didReceiveEditProfileResponse(objResponse: BaseResponse<Profile>)
    
    func didReceiceEditProfileError(strError: String)
}

struct GenderSelectionViewModel {
    
    var delegate : GenderSelectionViewModelDelegate?
    
    func editProfileGenderAPI(gender: String?){
        
        WolooGuestAPI().editProfileGender(gender: gender ?? "") { objCommonWrapper in
            self.delegate?.didReceiveEditProfileResponse(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceiceEditProfileError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
}
