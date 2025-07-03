//
//  EditAddressPopUpVWExtension.swift
//  Woloo
//
//  Created by CEPL on 24/03/25.
//

import Foundation
import STPopup

extension EditAddressPopUpViewController: UITextFieldDelegate, EditAddressPopUpViewModelDelegate {
    
    //MARK: TextFieldMethods
    
    @objc func txtFldFlatNoDidChange(_ textField: UITextField) {
        
//
    }
    
    @objc func txtFldLocalityDidChange(_ textField: UITextField) {
        self.objEditAddressSave.city = textField.text ?? ""
    }
    
    @objc func txtFldApartmentDidChange(_ textField: UITextField) {
    self.objEditAddressSave.address_1 = textField.text ?? ""
    }
    
    @objc func txtFldPinCodeDidChange(_ textField: UITextField) {
        self.objEditAddressSave.postal_code = textField.text ?? ""
    }
    
    @objc func txtFldAddressTypeDidChange(_ textField: UITextField) {
        self.objEditAddressSave.address_name = textField.text ?? ""
    }
    
    //MARK: - EditAddressPopUpViewModelDelegate
    func didReceievAddAddressAPISuccess(objResponse: CustomerCreationWrapper) {
    
        if self.delegate != nil {
            self.delegate?.didAddressUpdated()
            self.dismiss(animated: true)
        }
    }
    
    func didReceievAddAddressAPIError(strError: String) {
        //
    }
    
    func didReceievEditAddressAPISuccess(objResponse: CustomerCreationWrapper) {
        if self.delegate != nil {
            self.delegate?.didAddressUpdated()
            self.dismiss(animated: true)
        }
    }
   
}
