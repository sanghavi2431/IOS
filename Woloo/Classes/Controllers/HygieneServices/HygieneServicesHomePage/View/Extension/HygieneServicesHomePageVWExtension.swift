//
//  HygieneServicesHomePageVWExtension.swift
//  Woloo
//
//  Created by CEPL on 26/04/25.
//

import Foundation


extension HygieneServicesHomePageVC: UITableViewDelegate, UITableViewDataSource{
   
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.section == 1{
            var cell: AllServicesTableCell? = tableView.dequeueReusableCell(withIdentifier: "AllServicesTableCell") as! AllServicesTableCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AllServicesTableCell", owner: self, options: nil)?.last as? AllServicesTableCell)
            }
            
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        return UITableViewCell()
    }

}
