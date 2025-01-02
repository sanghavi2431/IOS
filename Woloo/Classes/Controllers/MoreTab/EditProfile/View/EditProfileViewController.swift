//
//  EditProfileViewController.swift
//  Woloo
//
//  Created by ideveloper1 on 22/04/21.


import UIKit
import DLRadioButton
import SmartPush
import Smartech

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    let datePicker = UIDatePicker()
    var userData: UserModel?
    var selectedGender = 0
    
    var userDataV2: UserProfileModel?
    var objEditProfileViewModel = EditProfileViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        DispatchQueue.main.async {
        // self.setupUI()
        self.setupUIV2()
        //        }
    }
    
    func setupUI() {
        [nameTextField, emailTextField, phoneTextField, cityTextField, pincodeTextField, addressTextField].forEach { (field) in
            field?.delegate = self
        }
        
        nameTextField.text = userData?.name ?? ""
        phoneTextField.text = userData?.mobile ?? ""
        if let mobile = userData?.mobile, mobile.count == 10 {
            self.phoneTextField.isUserInteractionEnabled = false
        }
        cityTextField.text = userData?.city ?? ""
        pincodeTextField.text = userData?.pincode ?? ""
        addressTextField.text = userData?.address ?? ""
        if let newDate = userData?.dob {
            dobTextField.text = userData?.dob?.convertDateFormater(newDate, inputFormate: "yyyy-MM-dd", outputFormate: "dd-MMM-yyyy")
        }
        if userData?.gender?.lowercased() == "male"
        {
            selectedGender = 0
            genderAction(maleButton)
        } else {
            selectedGender = 1
            genderAction(femaleButton)
        }
        if userData?.gender?.lowercased().count ?? 0 > 0
        {
            //            maleButton.isUserInteractionEnabled = false
            //            femaleButton.isUserInteractionEnabled = false
        }
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        dobTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDOBSelection), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupUIV2() {
        self.objEditProfileViewModel.delegate = self
        
        [nameTextField, emailTextField, phoneTextField, cityTextField, pincodeTextField, addressTextField].forEach { (field) in
            field?.delegate = self
        }
        
        nameTextField.text = userDataV2?.profile?.name ?? ""
        phoneTextField.text = String(userDataV2?.profile?.mobile ?? 0)
        let mobileStr = String(userDataV2?.profile?.mobile ?? 0)
        
        
        if mobileStr.count == 10 {
            self.phoneTextField.isUserInteractionEnabled = false
        }
        cityTextField.text = userDataV2?.profile?.city ?? ""
        pincodeTextField.text = userDataV2?.profile?.pincode ?? ""
        addressTextField.text = userDataV2?.profile?.address ?? ""
        emailTextField.text = userDataV2?.profile?.email ?? ""
        if let newDate = userDataV2?.profile?.dob {
            dobTextField.text = userDataV2?.profile?.dob?.convertDateFormater(newDate, inputFormate: "yyyy-MM-dd", outputFormate: "dd-MMM-yyyy")
        }
        if userDataV2?.profile?.gender?.lowercased() == "male"
        {
            selectedGender = 0
            genderAction(maleButton)
        } else {
            selectedGender = 1
            genderAction(femaleButton)
        }
        if userDataV2?.profile?.gender?.lowercased().count ?? 0 > 0
        {
            //            maleButton.isUserInteractionEnabled = false
            //            femaleButton.isUserInteractionEnabled = false
        }
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        dobTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDOBSelection), for: .valueChanged)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: - Actions
extension EditProfileViewController {
    @IBAction func submitButtonAction() {
        //editProfileAPI()
        editProfileV2()
    }
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func cityAction() {
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchLocationViewController") as? SearchLocationViewController
        vc?.isFromEditProfile = true
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func genderAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            selectedGender = 0
            maleButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            femaleButton.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
            print("male selected \(self.maleButton.isSelected)")
        } else if sender.tag == 2 {
            selectedGender = 1
            femaleButton.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            maleButton.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
            print("female selected \(self.femaleButton.isSelected)")
        }
    }
    @objc func handleDOBSelection(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        dobTextField.text = formatter.string(from: sender.date)
        //dobTextField.text = "\(day)-\(month)-\(year)"
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - API
extension EditProfileViewController {
    func editProfileAPI() {
        let name = nameTextField.text
        let email = emailTextField.text
        let city = cityTextField.text
        let pincode = pincodeTextField.text
        let address = addressTextField.text
        if !(name?.isEmpty ?? false) && !(city?.isEmpty ?? false) && !(pincode?.isEmpty ?? false) && !(address?.isEmpty ?? false) {
            /* if !(phoneTextField.text?.isValidPhoneNumber() ?? false) {
             Global.showAlert(title: "", message: "Please enter a valid number!!!")
             return
             }
             let number = phoneTextField.text*/
            var dob = "01-Jan-2021"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let myDate = dateFormatter.date(from: dobTextField.text ?? "2021-01-01") {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dob = dateFormatter.string(from: myDate)
            }
            
            let param = [Key.name: name, Key.email: email, Key.city: city, Key.pincode: pincode, Key.address: address, "gender": selectedGender == 0 ? "Male" : "Female", "dob":dob]
            
            print("Edited profile: \(name)")
            
            let profilePushDictionary = ["NAME": "\(name ?? "")","GENDER": selectedGender == 0 ? "Male" : "Female"]
            
            
            Smartech.sharedInstance().updateUserProfile(profilePushDictionary)
            
            Global.showIndicator()
            APIManager.shared.postEditProfileData(param: param as [String : Any]) { (result, errorMessage) in
                DispatchQueue.main.async {
                    Global.hideIndicator()
                    
                }
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            if let nameEmpty = nameTextField.text?.isEmpty, nameEmpty {
                self.showToast(message: "Please enter Name.")
            } else if let cityEmpty = cityTextField.text?.isEmpty, cityEmpty {
                self.showToast(message: "Please enter City.")
            } else if let pinEmpty = pincodeTextField.text?.isEmpty, pinEmpty {
                self.showToast(message: "Please enter Pincode.")
            } else if let addressEmpty = addressTextField.text?.isEmpty, addressEmpty {
                self.showToast(message: "Please enter Address.")
            }
        }
    }
    
    func editProfileV2(){
        let name = nameTextField.text
        let email = emailTextField.text
        let city = cityTextField.text
        let pincode = pincodeTextField.text
        let address = addressTextField.text
        
        if !(name?.isEmpty ?? false) && !(city?.isEmpty ?? false) && !(pincode?.isEmpty ?? false) && !(address?.isEmpty ?? false) && !(email?.isEmpty ?? false){
            /* if !(phoneTextField.text?.isValidPhoneNumber() ?? false) {
             Global.showAlert(title: "", message: "Please enter a valid number!!!")
             return
             }
             let number = phoneTextField.text*/
            var dob = "2021-01-01"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            if let myDate = dateFormatter.date(from: dobTextField.text ?? "01-Jan-2021") {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dob = dateFormatter.string(from: myDate)
            }
            
            self.userDataV2?.profile?.name = name
            self.userDataV2?.profile?.email = email
            self.userDataV2?.profile?.city = city
            self.userDataV2?.profile?.pincode = pincode
            self.userDataV2?.profile?.address = address
            self.userDataV2?.profile?.gender = selectedGender == 0 ? "Male" : "Female"
            self.userDataV2?.profile?.dob = dob
            
            
            print("Edited profile: \(name ?? "")")
            
            let profilePushDictionary = ["NAME": "\(name ?? "")","GENDER": selectedGender == 0 ? "Male" : "Female"]
            
            
            Smartech.sharedInstance().updateUserProfile(profilePushDictionary)
            
            Global.showIndicator()
            self.objEditProfileViewModel.editProfileAPI(objProfile: self.userDataV2?.profile)

        }
        else {
            if let nameEmpty = nameTextField.text?.isEmpty, nameEmpty {
                self.showToast(message: "Please enter Name.")
            } else if let cityEmpty = cityTextField.text?.isEmpty, cityEmpty {
                self.showToast(message: "Please enter City.")
            } else if let pinEmpty = pincodeTextField.text?.isEmpty, pinEmpty {
                self.showToast(message: "Please enter Pincode.")
            } else if let addressEmpty = addressTextField.text?.isEmpty, addressEmpty {
                self.showToast(message: "Please enter Address.")
            }
            else if let email = emailTextField.text?.isEmpty, email {
                self.showToast(message: "Please enter email.")
            }
        }
        
    }
}
extension EditProfileViewController : SearchLocationDelegate {
    func onCitySelected(cityName: String) {
        cityTextField.text = cityName
    }
}

extension EditProfileViewController: EditProfileViewModelDelegate {
    
    //MARK: - EditProfileViewModelDelegate
    func didReceiveEditProfileResponse(objResponse: BaseResponse<Profile>) {
        Global.hideIndicator()
        UserDefaultsManager.storeUserProfile(value: objResponse.results)
        self.navigationController?.popViewController(animated: true)
    }
    
    func didReceiceEditProfileError(strError: String) {
        Global.hideIndicator()
    }
    
    
    
}
