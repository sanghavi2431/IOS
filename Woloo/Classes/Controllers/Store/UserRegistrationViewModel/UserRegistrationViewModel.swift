//
//  UserRegistrationViewModel.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import Foundation

protocol UserRegistrationViewModelDelegate{
    
    func didRecieveRegistrationResponse(response: UserRegisterWrapper)
    func didRecieveRegistrationError(error: String)
    
    func didRecieveCustomerCreationResponse(response: CustomerCreationWrapper)
    func didRecieveCustomerCreationError(error: String)
    
    func didRecieveemailpassResponse(response: UserRegisterWrapper)
    func didRecieveemailpassError(error: String)
    
    func didRecieveCreateResponse(response: CreateCart)
    func didRecieveCreateCartError(error: String)
    
    func didRecieveCreateWishList(response: WishListWrapper)
    func didRecieveCreateWishListError(error: String)
    
    func didRecieveChangeRegisterStatusAPI(response: RegisterWrapper)
    func didRecieveChangeRegisterStatusError(error: String)
    
}

struct UserRegistrationViewModel{
    
    var delegate: UserRegistrationViewModelDelegate?
    
    func userRegistrationAPI(strEmail: String?, strPassword: String?){
        
        AuthHostAPI().userRegisterAPI(strMail: strEmail ?? "", strPassword: strPassword ?? "") { objCommonWrapper in
            self.delegate?.didRecieveRegistrationResponse(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveRegistrationError(error: error?.localizedDescription ?? "")
        }


    }
    
    
    func customerCreation(strMail: String?, strPhone: String?){
        
        ShopHostAPI().customerCreationAPI(strMail: strMail, strPhone: strPhone) { objCommonWrapper in
            self.delegate?.didRecieveCustomerCreationResponse(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveRegistrationError(error: error?.localizedDescription ??
            "")
        }

    }
    
    func emailPassAPI(strMail: String?, strPwd: String?){
    
        AuthHostAPI().emailPassAPI(strMail: strMail ?? "", strPassword: strPwd ?? "") { objCommonWrapper in
            self.delegate?.didRecieveemailpassResponse(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveemailpassError(error: error?.localizedDescription ?? "")
        }


    }
    
    func changeUserRegisterStatus(){
        WolooGuestAPI().registerAPI { objCommonWrapper in
            self.delegate?.didRecieveChangeRegisterStatusAPI(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveChangeRegisterStatusError(error: error?.localizedDescription ?? "")
        }

    }
    
    
    func createCartAPI(strRegionID: String?){
    
        ShopHostAPI().createCartAPI(strRegionID: strRegionID ?? "") { objCommonWrapper in
            self.delegate?.didRecieveCreateResponse(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveCreateCartError(error: error?.localizedDescription ?? "")
        }


    }
    
    func createWishListAPI(){
        
        ShopHostAPI().createWishListAPI { objCommonWrapper in
            self.delegate?.didRecieveCreateWishList(response: objCommonWrapper)
        } failure: { error in
            self.delegate?.didRecieveCreateWishListError(error: error?.localizedDescription ?? "")
        }

    }
    
}
