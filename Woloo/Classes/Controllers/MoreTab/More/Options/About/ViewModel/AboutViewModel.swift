//
//  AboutViewModel.swift
//  Woloo
//
//  Created by CEPL on 12/02/25.
//

import Foundation

protocol AboutViewModelDelegate{
    
    func didRecieveAboutSucess(objResponse: BaseResponse<TermsModel>)
    func didRecieveAboutError(strError:String)
    
}


struct AboutViewModel{
    
    var delegate: AboutViewModelDelegate?
    
    func getAboutAPI(){
        
        WolooGuestAPI().getAboutPage { objCommonWrapper in
            self.delegate?.didRecieveAboutSucess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveAboutError(strError: error?.localizedDescription ?? "")
        }

    }
    
}
