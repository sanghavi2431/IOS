//
//  AddReviewVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 09/11/24.
//

import Foundation
import UIKit
import STPopup

extension AddReviewVC: UITableViewDelegate, UITableViewDataSource, AddReviewSliderCellDelegate, AddReviewStarCellDelegate, AddReviewDescriptionCellDelegate, AddReviewSubmitBtnCellProtocol, WolooAlertPopUpViewDelegate{
    
    //MARK: - WolooAlertPopUpViewDelegate
    func closePopUp() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK: - AddReviewSubmitBtnCellProtocol
    func didTappedSubmitRequestBtn() {
        
        if !Utility.isEmpty(self.feedBack){
            submitReviewAPIV2()
        }
        else{
            self.showToast(message: "Please enter description.")
        }
       
    }
    
    
    //MARK: - AddReviewDescriptionCellDelegate
    func didAddReview(feedback: String?) {
        print("feedback: ", feedback ?? "")
        self.feedBack = feedback ?? ""
    }
    
    
    
    //MARK: - AddReviewStarCellDelegate
    func didChangedStarValue(value: Float?) {
        self.rating = value ?? 0.0
        print("Rating: ", self.rating ?? 0.0)
        self.tblView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        self.tblView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        self.tblView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
    }
    
    //MARK: - AddReviewSliderCellDelegate
    func didChangedSliderValue(value: Float?) {
        print("slider value: ", value ?? 0.0)
        
        if value ?? 0.0 < 1{
            print("poor score")
            
        }
        else if value ?? 0.0 < 2{
            print("fair score")
            
        }
        else if value ?? 0.0 < 3{
            print("Good score")
        }
        else if value ?? 0.0 < 4{
            print("Very Good score")
        }
        else if value ?? 0.0 <= 5{
            print("Excllent score")
        }
        
        self.rating = value ?? 0.0
        self.tblView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        self.tblView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
    }
    
    
   
    
    //MARK: - UITableviewdelegate and data source mthods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            var cell: AddReviewCibilImgViewCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewCibilImgViewCell") as! AddReviewCibilImgViewCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewCibilImgViewCell", owner: self, options: nil)?.last as? AddReviewCibilImgViewCell)
            }
          
            cell?.configureAddReviewCibilImgViewCell(rating: self.rating)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 1 {
            var cell: AddReviewSliderCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewSliderCell") as! AddReviewSliderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewSliderCell", owner: self, options: nil)?.last as? AddReviewSliderCell)
            }
          
            // Capture slider value changes
            cell?.delegate = self
            cell?.configureAddReviewSliderCell(value: self.rating)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 2 {
            var cell: AddReviewSeparatorCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewSeparatorCell") as! AddReviewSeparatorCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewSeparatorCell", owner: self, options: nil)?.last as? AddReviewSeparatorCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 3 {
            var cell: AddReviewStarCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewStarCell") as! AddReviewStarCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewStarCell", owner: self, options: nil)?.last as? AddReviewStarCell)
            }
            cell?.delegate = self
            cell?.configureAddReviewStarCell(rating: self.rating)
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 4 {
            var cell: AddReviewDescriptionCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewDescriptionCell") as! AddReviewDescriptionCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewDescriptionCell", owner: self, options: nil)?.last as? AddReviewDescriptionCell)
            }
          
            cell?.delegate = self
            
            cell?.configureAddReviewDescriptionCell(feedBack: self.feedBack)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 5 {
            var cell: AddReviewSubmitBtnCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewSubmitBtnCell") as! AddReviewSubmitBtnCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewSubmitBtnCell", owner: self, options: nil)?.last as? AddReviewSubmitBtnCell)
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
