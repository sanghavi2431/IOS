//
//  StoreOrderDetailsVWExtension.swift
//  Woloo
//
//  Created by CEPL on 08/03/25.
//

import Foundation
import UIKit
import STPopup

extension StoreOrderDetailsVC: UITableViewDelegate, UITableViewDataSource, StoreOrderDetailsViewModelDelegate, OrderDetailTableCellDelegate{
    
    
    //MARK: - OrderDetailTableCellDelegate
    func didSelectCheckStatus(objProducts: Products?, objOrder: OrderListings?) {
        print("Check status")
        let objController = StoreOrderStatusVC.init(nibName: "StoreOrderStatusVC", bundle: nil)
        
        objController.objProduct = objProducts ?? Products()
        objController.objOrderListings = objOrder ?? OrderListings()
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    func didClickedAddRating(objProducts: Products?) {
        let objController = WriteAReviewPopUpVC(nibName: "WriteAReviewPopUpVC", bundle: nil)
       // objController.delegate = self
        let popup = STPopupController(rootViewController: objController)
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
    }
    
    //MARK: - StoreOrderDetailsViewModelDelegate
    func didReceievGetOrderListingAPISuccess(objResponse: OrderListingsWrapper) {
        Global.hideIndicator()
        self.objStoreItems = objResponse.order_sets ?? [OrderSets]()
        print("get order list api successget order list api success", self.objStoreItems.count)
        self.tableView.reloadData()
    }
    
    func didReceievGetOrderListingAPIError(strError: String) {
        print("get order list api error", strError)
    }
    
    
    //MARK: - RateYourExperienceCellDelegate
    func didClickedWriteAReview() {
        
        let objController = WriteAReviewPopUpVC(nibName: "WriteAReviewPopUpVC", bundle: nil)
       // objController.delegate = self
        let popup = STPopupController(rootViewController: objController)
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
    }
    
    //AMRK: - HelpAndSupportBtnCellDelegate
    func didClickedHelpAndSupportBtn() {
        let objController = HelpAndSupportPopUpVC(nibName: "HelpAndSupportPopUpVC", bundle: nil)
       // objController.delegate = self
        let popup = STPopupController(rootViewController: objController)
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
    }
    
    
    //MARK: - UITableViewDelegate and UITableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return self.objStoreItems.count
        }
        else{
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            if indexPath.row == 0{
                var cell: CartHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "CartHeaderCell") as! CartHeaderCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("CartHeaderCell", owner: self, options: nil)?.last as? CartHeaderCell)
                }
                
                cell?.configureStoreOrderHeaderListCell()
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
           
        }
        else if indexPath.section == 1{
            //order status cell
            var cell: OrderDetailTableCell? = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableCell") as! OrderDetailTableCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("OrderDetailTableCell", owner: self, options: nil)?.last as? OrderDetailTableCell)
            }
           
            cell?.delegate = self
            cell?.configureOrderDetailTableCell(objStoreItems: self.objStoreItems[indexPath.row])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 4{
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        return UITableViewCell()
    }

}
