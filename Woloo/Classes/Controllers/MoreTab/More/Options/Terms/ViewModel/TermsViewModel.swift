//
//  TermsViewModel.swift
//  Woloo
//
//  Created by CEPL on 12/02/25.
//

import Foundation


protocol TermsViewModelDelegate{
    
    func didRecieveTermsSucess(objResponse: BaseResponse<TermsModel>)
    func didRecieveTermsError(strError:String)
    
}

struct TermsViewModel{
    
    var delegate: TermsViewModelDelegate?
    
    func getTermsAndConditionsAPI(){
        
        WolooGuestAPI().getTermsPage { objCommonWrapper in
            self.delegate?.didRecieveTermsSucess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveTermsError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
}
