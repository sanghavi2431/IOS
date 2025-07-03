//
//  SayItWithWolooDetailVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 05/02/25.
//

import Foundation
import UIKit

extension  SayItWithWolooDetailVC: UITableViewDelegate, UITableViewDataSource, SayItWolooDetailBtnCellDelegate{
    
    //MARK: - SayItWolooDetailBtnCellDelegate
    func didClickEditBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didClickSendBtn() {
        print("calling the send msg api")
    }
    
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{// bg img
            var cell: ImageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "ImageHeaderCell") as! ImageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ImageHeaderCell", owner: self, options: nil)?.last as? ImageHeaderCell)
            }
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 1{// gift img
            var cell: SayItWolooImgCell? = tableView.dequeueReusableCell(withIdentifier: "SayItWolooImgCell") as! SayItWolooImgCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("SayItWolooImgCell", owner: self, options: nil)?.last as? SayItWolooImgCell)
            }
            cell?.configureSayItWolooImgCell(selectedImg: imgSelected)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 2{//description
            var cell: txtViewSayItWolooCell? = tableView.dequeueReusableCell(withIdentifier: "txtViewSayItWolooCell") as! txtViewSayItWolooCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("txtViewSayItWolooCell", owner: self, options: nil)?.last as? txtViewSayItWolooCell)
            }
           
            cell?.configureTxtViewSayItWolooCell(obj: self.objAddMessageModel)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 3{//description
            var cell: SayItWolooDetailBtnCell? = tableView.dequeueReusableCell(withIdentifier: "SayItWolooDetailBtnCell") as! SayItWolooDetailBtnCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("SayItWolooDetailBtnCell", owner: self, options: nil)?.last as? SayItWolooDetailBtnCell)
            }
            cell?.delegate = self
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else{
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
    }
    
    
}
