//
//  ShopCartPopUpVWExtension.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import Foundation

extension ShopCartPopUpVC: UITableViewDelegate, UITableViewDataSource{
   
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
            
        }
        else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            var cell: CartListCell? = tableView.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("CartListCell", owner: self, options: nil)?.last as? CartListCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 1{
            if indexPath.row == 0{
                
                var cell: CartListCell? = tableView.dequeueReusableCell(withIdentifier: "CartListCell") as! CartListCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("CartListCell", owner: self, options: nil)?.last as? CartListCell)
                }
                
                
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 1{
                var cell: CartPromoCodeCell? = tableView.dequeueReusableCell(withIdentifier: "CartPromoCodeCell") as! CartPromoCodeCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("CartPromoCodeCell", owner: self, options: nil)?.last as? CartPromoCodeCell)
                }
                
                
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 2{
                var cell: CartTotalCell? = tableView.dequeueReusableCell(withIdentifier: "CartTotalCell") as! CartTotalCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("CartTotalCell", owner: self, options: nil)?.last as? CartTotalCell)
                }
                
                
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
        }
        return UITableViewCell()
    }
    
    
    
}
