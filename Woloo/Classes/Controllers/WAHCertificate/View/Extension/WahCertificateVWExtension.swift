//
//  WahCertificateVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 08/11/24.
//

import Foundation
import UIKit

extension WahCertificateVC: UITableViewDelegate, UITableViewDataSource{
  
    //MARK: UITableView Delegate and Datasource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            var cell: WAHLogoCell? = tableView.dequeueReusableCell(withIdentifier: "WAHLogoCell") as! WAHLogoCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("WAHLogoCell", owner: self, options: nil)?.last as? WAHLogoCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 1 {
            var cell: WAHRestaurantName? = tableView.dequeueReusableCell(withIdentifier: "WAHRestaurantName") as! WAHRestaurantName?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("WAHRestaurantName", owner: self, options: nil)?.last as? WAHRestaurantName)
            }
            cell?.configureWAHRestaurantName(objWahCertificate: objWahCertificate)
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 2
                    {
            var cell: WAHInfoName? = tableView.dequeueReusableCell(withIdentifier: "WAHInfoName") as! WAHInfoName?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("WAHInfoName", owner: self, options: nil)?.last as? WAHInfoName)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 3
                    {
            var cell: WAHCertificateNoCell? = tableView.dequeueReusableCell(withIdentifier: "WAHCertificateNoCell") as! WAHCertificateNoCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("WAHCertificateNoCell", owner: self, options: nil)?.last as? WAHCertificateNoCell)
            }
          
            cell?.configureWahCertificateNumber(objWahCertificate: objWahCertificate)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 4
                    {
            var cell: WAHCertificateNoCell? = tableView.dequeueReusableCell(withIdentifier: "WAHCertificateNoCell") as! WAHCertificateNoCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("WAHCertificateNoCell", owner: self, options: nil)?.last as? WAHCertificateNoCell)
            }
          
            cell?.configureWahCertificateDate(objWahCertificate: objWahCertificate)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        
        else if indexPath.row == 5
                    {
            var cell: WAHCertifiedCell? = tableView.dequeueReusableCell(withIdentifier: "WAHCertifiedCell") as! WAHCertifiedCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("WAHCertifiedCell", owner: self, options: nil)?.last as? WAHCertifiedCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        
        return UITableViewCell()
    }
    
    
    
}
