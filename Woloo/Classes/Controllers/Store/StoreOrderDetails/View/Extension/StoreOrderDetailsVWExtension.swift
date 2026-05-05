//
//  StoreOrderDetailsVWExtension.swift
//  Woloo
//
//  Created by CEPL on 08/03/25.
//

import Foundation
import UIKit
import STPopup

extension StoreOrderDetailsVC: UITableViewDelegate, UITableViewDataSource, StoreOrderDetailsViewModelDelegate, OrderDetailTableCellDelegate, OrderHistoryPopUpVCDelegate{
    
    
   
    //MARK: - OrderHistoryPopUpVCDelegate
    func didClickedCheckStatus(objorders: Orders?, objOrderSet: OrderSets?) {
        
        DispatchQueue.main.async {
            let objController = StoreOrderStatusVC(nibName: "StoreOrderStatusVC", bundle: nil)
            objController.objOrderSets = objOrderSet ?? OrderSets()
            objController.objOrder = objorders ?? Orders()

            self.navigationController?.pushViewController(objController, animated: true)
        }
    }
   
    //MARK: - OrderDetailTableCellDelegate
    
    //Open order summary pop up
    func didClickedOrderID(objOrderSets: OrderSets?) {
        print("order set clicked: ",objOrderSets?.id ?? "")
        print("first name: ", objOrderSets?.cart?.shipping_address?.first_name ?? "")
        let objController = OrderHistoryPopUpVC(nibName: "OrderHistoryPopUpVC", bundle: nil)
        objController.delegate = self
        objController.objOrderSets = objOrderSets ?? OrderSets()
        let popup = STPopupController(rootViewController: objController)
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
    }
    
    func didSelectCheckStatus(objOrderSets: OrderSets?, objOrder: Orders?) {
        print("Check status")
        let objController = StoreOrderStatusVC.init(nibName: "StoreOrderStatusVC", bundle: nil)
        objController.objOrderSets = objOrderSets ?? OrderSets()
        objController.objOrder = objOrder ?? Orders()
      
        self.navigationController?.pushViewController(objController, animated: true)
    }
   
    
    func didClickedAddRating(objProducts: OrderItem?) {
        
        DispatchQueue.main.async {
            let objController = WriteAReviewPopUpVC(nibName: "WriteAReviewPopUpVC", bundle: nil)
           // objController.delegate = self
            objController.strProductID = objProducts?.product_id ?? ""
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
       
    }
    
    //MARK: - StoreOrderDetailsViewModelDelegate
    func didReceievGetOrderListingAPISuccess(objResponse: OrderListingsWrapper) {
        Global.hideIndicator()
        self.objStoreItems = (objResponse.order_sets ?? [OrderSets]()).reversed()
        print("get order list api successget order list api success", self.objStoreItems.count)
        self.tableView.reloadData()
    }
    
    func didReceievGetOrderListingAPISuccess(objResponse: CompleteCart) {
        
        let orderArray = [objResponse.order_set]
        
        self.objStoreItems = orderArray
        
        self.tableView.reloadData()
    }
    
    
    func didReceievGetOrderListingAPIError(strError: String) {
        Global.hideIndicator()
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

}
