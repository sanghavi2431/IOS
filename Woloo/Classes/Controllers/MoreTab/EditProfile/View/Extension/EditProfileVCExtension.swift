//
//  EditProfileVCExtension.swift
//  Woloo
//
//  Created by CEPL on 24/02/25.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource, GenderSelectionCellDelegate, EditProfileTxtCellProtocol{
    
    //MARK: - EditProfileTxtCellProtocol
    func didTextFieldChanged(objUserProfileModel: UserProfileModel?) {
        self.userDataV2 = objUserProfileModel ?? UserProfileModel()
    }
    
    
    //MARK: - GenderSelectionCellDelegate
    func didChangeGender(strGender: String?) {
        self.userDataV2?.profile?.gender = strGender
        self.editTableView.reloadData()
    }
    
    
    //MARK: - UItableview delegate and data source methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 8{
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
        else if indexPath.row == 7{
            var cell: SubmitButtonCell? = tableView.dequeueReusableCell(withIdentifier: "SubmitButtonCell") as! SubmitButtonCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("SubmitButtonCell", owner: self, options: nil)?.last as? SubmitButtonCell)
            }
            
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
        else if indexPath.row == 6{
            var cell: GenderSelectionCell? = tableView.dequeueReusableCell(withIdentifier: "GenderSelectionCell") as! GenderSelectionCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("GenderSelectionCell", owner: self, options: nil)?.last as? GenderSelectionCell)
            }
          
            cell?.delegate = self
            cell?.configureGenderSelectionCell(userData: self.userDataV2)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else{
            var cell: EditProfileTxtCell? = tableView.dequeueReusableCell(withIdentifier: "EditProfileTxtCell") as! EditProfileTxtCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("EditProfileTxtCell", owner: self, options: nil)?.last as? EditProfileTxtCell)
            }
          
            cell?.delegate = self
            cell?.configureEditProfileTxtCell(indexPath: indexPath , userData: self.userDataV2)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
            if indexPath.row == 5{
                
                let selectedDate = Date()
                var strTitle: String? = ""
                strTitle = "Select DOB"
                let datePicker = ActionSheetDatePicker(title: strTitle, datePickerMode: .date, selectedDate: selectedDate, doneBlock: { [self] picker, value, index in
                    print(value ?? Date())
                    self.userDataV2?.profile?.dob = self.formatDateString(from: value as? Date)
                    
                    self.editTableView.reloadData()
                    return
                }, cancel: {ActionStringCancelBlock in return }, origin: self.view)
                
                datePicker?.maximumDate = Date()
                datePicker?.setDoneButton(UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil))
                datePicker?.setCancelButton(UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil))
                datePicker?.show()
            }
            else if indexPath.row == 7{
                Global.showIndicator()
                self.objEditProfileViewModel.editProfileAPI(objProfile: self.userDataV2?.profile)
            }
            
        }
    }
    
        //MARK: - Show date picker
    func showDatePicker() {
        let alert = UIAlertController(title: "Select Date of Birth", message: nil, preferredStyle: .actionSheet)

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        alert.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true

        let okAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.handleDOBSelection(datePicker)
        }
        
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
    
    
    func formatDateString(from date: Date?) -> String {
        guard let date = date else { return "" } // Handle nil case

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Desired output format
        formatter.timeZone = TimeZone.current // Ensure it converts to local time
        
        return formatter.string(from: date)
    }
}


/*
 var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
 
 if cell == nil{
     cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
 }
 
 cell?.selectionStyle = UITableViewCell .SelectionStyle.none
return cell!
 */
