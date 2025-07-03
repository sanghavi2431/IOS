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
         return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3{
            return self.objOrderListings.items?.count ?? 0
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
            var cell: StoreOrderDetailCell? = tableView.dequeueReusableCell(withIdentifier: "StoreOrderDetailCell") as! StoreOrderDetailCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreOrderDetailCell", owner: self, options: nil)?.last as? StoreOrderDetailCell)
            }
            
            cell?.configureStoreOrderDetailCell(objProduct: self.objProduct, objStoreItems: self.objOrderListings)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
           
        }
        //
        else if indexPath.section == 2{
            //OtherItemsTitleCell
            var cell: OtherItemsTitleCell? = tableView.dequeueReusableCell(withIdentifier: "OtherItemsTitleCell") as! OtherItemsTitleCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("OtherItemsTitleCell", owner: self, options: nil)?.last as? OtherItemsTitleCell)
            }
            
          
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
          
        }
        else if indexPath.section == 3{
            //OtherItems list
            var cell: OtherItemListCell? = tableView.dequeueReusableCell(withIdentifier: "OtherItemListCell") as! OtherItemListCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("OtherItemListCell", owner: self, options: nil)?.last as? OtherItemListCell)
            }
            
            cell?.configureOrderDetailProdItemCell(objProducts: self.objOrderListings.items?[indexPath.row])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
          
        }
        else if indexPath.section == 4{
            //help and support cell
            var cell: HelpAndSupportBtnCell? = tableView.dequeueReusableCell(withIdentifier: "HelpAndSupportBtnCell") as! HelpAndSupportBtnCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("HelpAndSupportBtnCell", owner: self, options: nil)?.last as? HelpAndSupportBtnCell)
            }
            
            cell?.delegate = self
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
          
        }
        else if indexPath.section == 5{
            //help and support cell
            var cell: RateYourExperienceCell? = tableView.dequeueReusableCell(withIdentifier: "RateYourExperienceCell") as! RateYourExperienceCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("RateYourExperienceCell", owner: self, options: nil)?.last as? RateYourExperienceCell)
            }
            cell?.delegate = self
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 6{
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
