//
//  SelectAddressPopUpViewModel.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import Foundation

protocol SelectAddressPopUpViewModelDelegate: NSObjectProtocol{
  
    func didReceievDeleteAddressAPIError(strError: String)
  
    func didReceievDeleteAddressAPISuccess(objResponse: DeleteAddress)
}

struct SelectAddressPopUpViewModel{
    
    var delegate: SelectAddressPopUpViewModelDelegate?
    
    func deleteAddressAPI(objAddress: StoreAddress?)
    {
        
        ShopHostAPI().deleteAddress(objAddress: objAddress ?? StoreAddress()) { objCommonWrapper in
            self.delegate?.didReceievDeleteAddressAPISuccess(objResponse: objCommonWrapper)
        } failure: { error in
            self.delegate?.didReceievDeleteAddressAPIError(strError: error?.localizedDescription ?? "")
        }


        
    }
    
}
