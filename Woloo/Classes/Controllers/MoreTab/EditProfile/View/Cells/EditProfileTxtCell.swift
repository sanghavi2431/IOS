//
//  EditProfileTxtCell.swift
//  Woloo
//
//  Created by CEPL on 24/02/25.
//

import UIKit

protocol EditProfileTxtCellProtocol: NSObjectProtocol{
    
    func didTextFieldChanged(objUserProfileModel: UserProfileModel?)
    
}

class EditProfileTxtCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwBack: ShadowView!
    @IBOutlet weak var txtFieldLSearchLocation: UITextField!
    
    var currIndexPath = IndexPath()
    var userData: UserProfileModel?
    let datePicker = UIDatePicker()
    weak var delegate: EditProfileTxtCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwBack.layer.cornerRadius = 7.71
        self.txtFieldLSearchLocation.delegate = self
        txtFieldLSearchLocation.font = UIFont(name: "CenturyGothic", size: 12) // Bold
        lblTitle.font = UIFont(name: "CenturyGothic-Bold", size: 12)
        
    }
    
    func configureEditProfileTxtCell(indexPath: IndexPath, userData: UserProfileModel?){
        
        self.userData = userData ?? UserProfileModel()
        self.currIndexPath = indexPath
        switch indexPath.row {
        case 0:
            self.lblTitle.text = "Name"
            
            
            if Utility.isEmpty(self.userData?.profile?.name ?? ""){
                self.txtFieldLSearchLocation.placeholder = "Enter Name"
            }
            else{
                self.txtFieldLSearchLocation.text = self.userData?.profile?.name ?? ""
            }
            
        case 1:
            self.lblTitle.text = "Email"
          
            if Utility.isEmpty(self.userData?.profile?.email ?? ""){
                self.txtFieldLSearchLocation.placeholder = "Enter Email"
            }
            else{
                self.txtFieldLSearchLocation.text = self.userData?.profile?.email ?? ""
            }
            
            
        case 2:
            self.lblTitle.text = "Phone No."
            self.txtFieldLSearchLocation.keyboardType = .numberPad
            
            if Utility.isEmpty("\(self.userData?.profile?.mobile ?? 0)"){
                self.txtFieldLSearchLocation.placeholder = "Enter Phone No."
            }
            else{
                self.txtFieldLSearchLocation.text = "\(self.userData?.profile?.mobile ?? 0)"
            }
           
            
        case 3:
            self.lblTitle.text = "City"
            self.txtFieldLSearchLocation.placeholder = "Enter City"
            //self.txtFieldLSearchLocation.isEnabled = false
            if Utility.isEmpty(self.userData?.profile?.city ?? ""){
                self.txtFieldLSearchLocation.placeholder = "Enter City"
            }
            else{
                self.txtFieldLSearchLocation.text = self.userData?.profile?.city ?? ""
            }
            
        case 4:
            self.lblTitle.text = "Pin Code"
            
            self.txtFieldLSearchLocation.placeholder = "Enter Pin Code"
            
            if Utility.isEmpty(self.userData?.profile?.pincode ?? ""){
                self.txtFieldLSearchLocation.placeholder = "Enter Pin Code"
            }
            else{
                self.txtFieldLSearchLocation.text = self.userData?.profile?.pincode ?? ""
            }
            
        case 5:
            self.lblTitle.text = "Date of Birth"
            self.txtFieldLSearchLocation.placeholder = "Enter Date of Birth"
            self.txtFieldLSearchLocation.isEnabled = false
//
            if Utility.isEmpty(self.userData?.profile?.dob ?? ""){
                self.txtFieldLSearchLocation.placeholder = "Enter DOB"
            }
            else{
                
                if let newDate = self.userData?.profile?.dob {
                    self.txtFieldLSearchLocation.text = self.userData?.profile?.dob?.convertDateFormater(newDate, inputFormate: "yyyy-MM-dd", outputFormate: "dd-MMM-yyyy")
                }
            }
            
        default:
            break
        }
        
        self.txtFieldLSearchLocation.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func handleDOBSelection(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        txtFieldLSearchLocation.text = formatter.string(from: sender.date)
        //dobTextField.text = "\(day)-\(month)-\(year)"
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        switch self.currIndexPath.row {
            
        case 0:
            self.userData?.profile?.name = textField.text
            
            
        case 1:
            self.userData?.profile?.email = textField.text
            
        case 2:
            self.userData?.profile?.mobile = Int(textField.text ?? "")
            
        case 3:
            self.userData?.profile?.city = textField.text
            
        case 4:
            self.userData?.profile?.pincode = textField.text
            
        
        default:
            break
            
        }
        
        if self.delegate != nil {
            self.delegate?.didTextFieldChanged(objUserProfileModel: self.userData)
        }
    }
    
}
