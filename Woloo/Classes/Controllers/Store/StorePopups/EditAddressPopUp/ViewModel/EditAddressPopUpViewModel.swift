//
//  EditAddressPopUpViewModel.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import Foundation


protocol EditAddressPopUpViewModelDelegate: NSObjectProtocol{
    
    func didReceievAddAddressAPISuccess(objResponse: CustomerCreationWrapper)
    func didReceievAddAddressAPIError(strError: String)
    
    
    func didReceievEditAddressAPISuccess(objResponse: CustomerCreationWrapper)
}

struct EditAddressPopUpViewModel{
    
    var delegate: EditAddressPopUpViewModelDelegate?
    
    func addAddressAPI(objAddress: StoreAddress?)
    {
        
        ShopHostAPI().addAddress(objAddress: objAddress ?? StoreAddress()) { objCommonWrapper in
            self.delegate?.didReceievAddAddressAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievAddAddressAPIError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
    func editAddressAPI(objAddress: StoreAddress?)
    {
        
        ShopHostAPI().editAddress(objAddress: objAddress ?? StoreAddress()) { objCommonWrapper in
            self.delegate?.didReceievEditAddressAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievAddAddressAPIError(strError: error?.localizedDescription ?? "")
        }

        
    }
    
    
}
