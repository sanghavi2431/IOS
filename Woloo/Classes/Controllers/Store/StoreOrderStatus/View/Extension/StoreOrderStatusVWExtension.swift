//
//  StoreOrderStatusVWExtension.swift
//  Woloo
//
//  Created by CEPL on 12/05/25.
//

import Foundation
import UIKit
import STPopup

extension StoreOrderStatusVC: UITableViewDelegate, UITableViewDataSource, HelpAndSupportBtnCellDelegate, RateYourExperienceCellDelegate{
    
    
    //MARK: - RateYourExperienceCellDelegate
    func didClickedWriteAReview() {
        let objController = WriteAReviewPopUpVC(nibName: "WriteAReviewPopUpVC", bundle: nil)
       // objController.delegate = self
      
        let popup = STPopupController(rootViewController: objController)
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
    }
    
    
    //MARK: - HelpAndSupportBtnCellDelegate
    func didClickedHelpAndSupportBtn() {
        let objController = HelpAndSupportPopUpVC(nibName: "HelpAndSupportPopUpVC", bundle: nil)
       // objController.delegate = self
        let popup = STPopupController(rootViewController: objController)
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
    }
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return self.objOrder.items?.count ?? 0
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            var cell: CartHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "CartHeaderCell") as! CartHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("CartHeaderCell", owner: self, options: nil)?.last as? CartHeaderCell)
            }
            
            cell?.configureStoreOrderHeaderCell()
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 1{
            //OtherItems list
            var cell: OrderSummaryItemListCell? = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryItemListCell") as! OrderSummaryItemListCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("OrderSummaryItemListCell", owner: self, options: nil)?.last as? OrderSummaryItemListCell)
            }
            
            cell?.configureStoreOrderStatusListCell(objOrderItem: self.objOrder.items?[indexPath.row])
            
           // cell?.configureOrderDetailProdItemCell(objProducts: self.objOrderListings.items?[indexPath.row])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
           
        }else if indexPath.section == 2{
            var cell: OrderStatusTableCell? = tableView.dequeueReusableCell(withIdentifier: "OrderStatusTableCell") as! OrderStatusTableCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("OrderStatusTableCell", owner: self, options: nil)?.last as? OrderStatusTableCell)
            }
            
            cell?.configureOrderStatusTableCell(objOrders: self.objOrder)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else {
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
    }
    
}
