//
//  ShopCheckoutPopUpVWExtension.swift
//  Woloo
//
//  Created by CEPL on 10/03/25.
//

import Foundation
import UIKit

extension ShopCheckoutPopUpVC: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            var cell: CheckoutAddressCell? = tableView.dequeueReusableCell(withIdentifier: "CheckoutAddressCell") as! CheckoutAddressCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("CheckoutAddressCell", owner: self, options: nil)?.last as? CheckoutAddressCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else{
            var cell: CheckoutPaymentDetailCell? = tableView.dequeueReusableCell(withIdentifier: "CheckoutPaymentDetailCell") as! CheckoutPaymentDetailCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("CheckoutPaymentDetailCell", owner: self, options: nil)?.last as? CheckoutPaymentDetailCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
    }
}
