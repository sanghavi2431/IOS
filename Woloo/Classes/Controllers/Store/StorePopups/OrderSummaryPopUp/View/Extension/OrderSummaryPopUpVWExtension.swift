//
//  OrderSummaryPopUpVWExtension.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import Foundation
import UIKit

extension OrderSummaryPopUpVC: UITableViewDelegate, UITableViewDataSource, OrderSummaryAddressCellDelegate, OrderSummaryPaymentCellDelegate{
    
  
    func didChangePaymentMode() {
        if self.delegate != nil{
            self.delegate?.didChangePaymentType()
            self.dismiss(animated: true)
        }
    }
    
    
    //MARK: - OrderSummaryPaymentCellDelegate
    
    
    //MARK: - OrderSummaryAddressCellDelegate
    func didClickedEditBtn(objAddress: StoreAddress?) {
        if self.delegate != nil{
            self.objSelectedAddress = objAddress ?? StoreAddress()
            self.delegate?.didClickedEditAddressCartBtn(objAddress: self.objSelectedAddress)
            self.dismiss(animated: true)
        }
    }
    
    
    
    //MARK: UITableViewDelegate & UITableViewDatasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.objCartItems.items?.count ?? 0
        }
        else{
            return 2
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            var cell: OrderSummaryItemListCell? = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryItemListCell") as! OrderSummaryItemListCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("OrderSummaryItemListCell", owner: self, options: nil)?.last as? OrderSummaryItemListCell)
            }
            
            cell?.configureOrderSummaryItemListCell(objCartItems: self.objCartItems.items?[indexPath.row])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 1{
            

            if indexPath.row == 0{
                
                var cell: OrderSummaryAddressCell? = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryItemListCell") as! OrderSummaryAddressCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("OrderSummaryAddressCell", owner: self, options: nil)?.last as? OrderSummaryAddressCell)
                }
                
                cell?.delegate = self
                cell?.configureOrderSummaryAddressCell(objAddress: self.objSelectedAddress)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 2{
                
                var cell: OrderSummaryPaymentCell? = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryPaymentCell") as! OrderSummaryPaymentCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("OrderSummaryPaymentCell", owner: self, options: nil)?.last as? OrderSummaryPaymentCell)
                }
                
                cell?.delegate = self
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 1{
                
                var cell: OrderSummaryDescCell? = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryDescCell") as! OrderSummaryDescCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("OrderSummaryDescCell", owner: self, options: nil)?.last as? OrderSummaryDescCell)
                }
                
                cell?.configureCartTotalCell(objcart: self.objCartItems)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
          
        }
        return UITableViewCell()
    }
}
