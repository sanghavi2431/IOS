//
//  OrderHistoryPopUpVWExtension.swift
//  Woloo
//
//  Created by CEPL on 02/07/25.
//

import Foundation


extension OrderHistoryPopUpVC: UITableViewDelegate, UITableViewDataSource, OrderDetailProdItemCellProtocol{
    
    //MARK: - OrderDetailProdItemCellProtocol
    func didClickedCheckStatus(objProducts: OrderItem?, at indexPath: IndexPath?) {
        DispatchQueue.main.async {
            guard let tappedItem = objProducts else {
                print("❌ objProducts is nil")
                return
            }

            // Find the order this item belongs to
            guard let matchingOrder = self.objOrderSets.orders?.first(where: {
                $0.items?.contains(where: { $0.id == tappedItem.id }) == true
            }) else {
                print("❌ No matching order found for item id: \(tappedItem.id ?? "nil")")
                return
            }

            if self.delegate != nil {
                self.delegate?.didClickedCheckStatus(objorders: matchingOrder, objOrderSet: self.objOrderSets)
                self.dismiss(animated: true)
            }
        }
    }
    
    func didClickedAddRating(objProducts: OrderItem?) {
        if self.delegate != nil {
            self.delegate?.didClickedAddRating(objProducts: objProducts)
            self.dismiss(animated: true)
        }
    }
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return flattenedOrderItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            if indexPath.row == 0{
                
                var cell: OrderHistoryTitleCell? = tableView.dequeueReusableCell(withIdentifier: "OtherItemsTitleCell") as! OrderHistoryTitleCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("OrderHistoryTitleCell", owner: self, options: nil)?.last as? OrderHistoryTitleCell)
                }
                
                cell?.configureOrderSetTitle(strID: self.objOrderSets.id)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 1{
                var cell: OrderHistoryAddressCell? = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryAddressCell") as! OrderHistoryAddressCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("OrderHistoryAddressCell", owner: self, options: nil)?.last as? OrderHistoryAddressCell)
                }
                
                cell?.configureOrderHistoryAddressCell(objOrderSets: self.objOrderSets)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 2{
                var cell: OrderHistoryStatusCell? = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryStatusCell") as! OrderHistoryStatusCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("OrderHistoryStatusCell", owner: self, options: nil)?.last as? OrderHistoryStatusCell)
                }
                
                cell?.configureOrderHistoryStatusCell(objOrderSets: self.objOrderSets)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 3{
                var cell: OrderHistoryTotalCell? = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTotalCell") as! OrderHistoryTotalCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("OrderHistoryTotalCell", owner: self, options: nil)?.last as? OrderHistoryTotalCell)
                }
                
                cell?.configureOrderHistoryTotalCell(objOrderSets: self.objOrderSets)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
        }
        else{
            
            var cell: OrderDetailProdItemCell? = tableView.dequeueReusableCell(withIdentifier: "OrderDetailProdItemCell") as! OrderDetailProdItemCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("OrderDetailProdItemCell", owner: self, options: nil)?.last as? OrderDetailProdItemCell)
            }
            
            cell?.delegate = self
            cell?.vwBackConstraint.constant = 16
            cell?.vwBackLeadingConstraint.constant = 16
            cell?.configureOrderDetailProdItemCell(objProducts: flattenedOrderItems[indexPath.row])
            cell?.indexPath = indexPath
                cell?.selectionStyle = .none
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
      
            return UITableViewCell()

    }
    
}
