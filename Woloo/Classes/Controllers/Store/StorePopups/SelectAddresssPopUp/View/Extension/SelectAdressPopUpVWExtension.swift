//
//  SelectAdressPopUpVWExtension.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import Foundation
import UIKit

extension SelectAdressPopUpViewController: UITableViewDelegate, UITableViewDataSource, SelectEditAdressCellDelegate, SelectAddressPopUpViewModelDelegate{
    
    
    
    func didClickedRadioBtn(objAddress: StoreAddress?) {
        guard let objAddress = objAddress else { return }

        for i in 0..<(self.listAddress.count) {
            if self.listAddress[i].id == objAddress.id {
                self.listAddress[i] = objAddress
                self.objAddress = objAddress
            }
            else{
                self.listAddress[i].isSelected = false
            }
        }
        self.tableView.reloadData()
    }

    
    //MARK: - SelectAddressPopUpViewModelDelegate
    func didReceievDeleteAddressAPISuccess(objResponse: DeleteAddress) {
        
        if self.delegate != nil
    {
            self.delegate?.didAddressDeleted()
            self.dismiss(animated: true)
        }
    }
    
    func didReceievDeleteAddressAPIError(strError: String) {
        //
    }
    
   
  
   
    //MARK: - SelectEditAdressCellDelegate
    func didClickedOnEditAdress(objAddress: StoreAddress?) {
        
        if self.delegate != nil{
            self.delegate?.didChangesAdress(objAddress: objAddress ?? StoreAddress())
        }
        
        self.dismiss(animated: true)
    }
    
    
    func didClickedOnDeleteAddress(objAddress: StoreAddress?) {
        self.objSelectAddressPopUpViewModel.deleteAddressAPI(objAddress: objAddress)
        self.dismiss(animated: true)
    }
    
   
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SelectEditAdressCell? = tableView.dequeueReusableCell(withIdentifier: "SelectEditAdressCell") as! SelectEditAdressCell?
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("SelectEditAdressCell", owner: self, options: nil)?.last as? SelectEditAdressCell)
        }
        
        cell?.delegate = self
        cell?.configureSelectEditAdressCell(objAddress: self.listAddress[indexPath.row])
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}
