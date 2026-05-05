//
//  CheckInventoryPopUpVWExtesnion.swift
//  Woloo
//
//  Created by CEPL on 27/06/25.
//

import Foundation
import UIKit

extension CheckInventoryPopUpVC: UITableViewDelegate, UITableViewDataSource, CheckInventoryPopUpTblCellDelegate{
    
    
    //MARK: - CheckInventoryPopUpDelegate
    func didClickedBtnNotify(objCartItems: CartItems) {
        if self.delegate != nil {
            self.delegate?.didClickedBtnNotify(objCartItems: objCartItems)
            self.dismiss(animated: true)
        }
    }
    
    
    //MARK: - UITableViewDelegate, UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listCartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CheckInventoryPopUpTblCell? = tableView.dequeueReusableCell(withIdentifier: "CheckInventoryPopUpTblCell") as! CheckInventoryPopUpTblCell?
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("CheckInventoryPopUpTblCell", owner: self, options: nil)?.last as? CheckInventoryPopUpTblCell)
        }
        cell?.delegate = self
        cell?.configureCheckInventoryPopUpTblCell(objCartItems: self.listCartItems[indexPath.row])
       
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}
