//
//  AdvanceFilterPopUpVWExtension.swift
//  Woloo
//
//  Created by CEPL on 17/04/25.
//

import Foundation
import UIKit

extension AdvanceFilterPopUpVC: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource & UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            //MARK: - Amenities view
            var cell: ShopFilterTableCell? = tableView.dequeueReusableCell(withIdentifier: "ShopFilterTableCell") as! ShopFilterTableCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ShopFilterTableCell", owner: self, options: nil)?.last as? ShopFilterTableCell)
            }
          
            cell?.configureShopFilterTableCell(listProductCategories: self.listCategories)
           // cell?.setDataV2(tags: wolooStoreDOV2?.getAllOfferNameV2 ?? [])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else  if indexPath.row == 1{
            //color cell
            var cell: ProductItemColorCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemColorCell") as! ProductItemColorCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ProductItemColorCell", owner: self, options: nil)?.last as? ProductItemColorCell)
            }
            
            cell?.configureProductItemColorCell()
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else  if indexPath.row == 2{
            //size cell
            //MARK: - Amenities view
            var cell: ProductItemColorCell? = tableView.dequeueReusableCell(withIdentifier: "ProductItemColorCell") as! ProductItemColorCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ProductItemColorCell", owner: self, options: nil)?.last as? ProductItemColorCell)
            }
          
            cell?.configureProductItemSizeCell()
           // cell?.setDataV2(tags: wolooStoreDOV2?.getAllOfferNameV2 ?? [])
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        return UITableViewCell()
    }
}

