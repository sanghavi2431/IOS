//
//  UserProfileView.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 15/03/23.
//

import UIKit
import Alamofire
import StoreKit

class UserProfileView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var displayAdharImg: UIImageView!
    @IBOutlet weak var displayPANImg: UIImageView!
    
    
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var phoneTxtFld: UITextField!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var cityTxtFld: UITextField!
    @IBOutlet weak var stateTxtFld: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var dobTxtFld: UITextField!
    
    var selectedAadharImage =  UIImage()
    var selectedPanImage = UIImage()
    
    let imagePicker = UIImagePickerController()
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTxtFld.text = "\(UserDefaultsManager.fetchUserMob())"
        print("Fetched user ID: \(UserDefaultsManager.fetchUserID())")
        
        //        self.dobTxtFld.datePicker(target: self,
        //                                  doneAction: #selector(doneAction),
        //                                  cancelAction: #selector(cancelAction),
        //                                  datePickerMode: .date)
        //dobTxtFld.addTarget(self, action: #selector(pickDateofBirth), for: .touchDown)
        displayAdharImg.tag = 0
        displayPANImg.tag = 0
        
        // Do any additional setup after loading the view.
        submitBtn.cornerRadius = 15.0
        
        imagePicker.delegate = self
        firstNameTxtFld.delegate = self
        lastNameTxtFld.delegate = self
        emailTxtFld.delegate = self
        phoneTxtFld.delegate = self
        addressTxtFld.delegate = self
        cityTxtFld.delegate = self
        stateTxtFld.delegate = self
        dobTxtFld.delegate = self
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // datePicker.preferredDatePickerStyle = .
            // Fallback on earlier versions
            self.dobTxtFld.datePicker(target: self,
                                      doneAction: #selector(doneAction),
                                      cancelAction: #selector(cancelAction),
                                      datePickerMode: .date)
        }
        datePicker.maximumDate = Date()
        
        dobTxtFld.inputView = datePicker
        dobTxtFld.text = ""
    }
    @objc func dateChange(datePicker: UIDatePicker)
    {
        dobTxtFld.text = formatDate(date: datePicker.date)
    }
    func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    @objc func pickDateofBirth(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonClicked))
        
        toolBar.items = [doneBtn]
        
        dobTxtFld.inputAccessoryView = toolBar
        dobTxtFld.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func doneButtonClicked() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dobTxtFld.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        
    }
    
    @objc
    func cancelAction() {
        self.dobTxtFld.resignFirstResponder()
    }
    
    
    @objc
    func doneAction() {
        if let datePickerView = self.dobTxtFld.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.dobTxtFld.text = dateString
            
            print(datePickerView.date)
            print("Date of birth entered",dateString)
            
            self.dobTxtFld.resignFirstResponder()
        }
    }
    
    @IBAction func uploadAdharBtnPressed(_ sender: UIButton) {
        print("Upload adhar image view")
        displayAdharImg.tag = 1
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "PhotoLibrary", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    
    
    @IBAction func uploadPanBtnPressed(_ sender: UIButton) {
        displayPANImg.tag = 1
        
        print("Upload Pan view")
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "PhotoLibrary", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
        print("Submit all data")
        
        //        showAlert(title: "Empty", message: "-------cannot be blank")
        validateUserForm()
        
        // uploadPhotoV2(media: selectedImage, params: ["id":"\(UserDefaultsManager.fetchUserID() ?? 0)","name": "kapil", "mobile": "1111111111", "pincode": "333333", "address":"behind temple", "city": "pune", "state": "Maharashtra"], fileName: ["aadhar_url","pan_url"])
        
        
    }
    
    func uploadPhotoV2(media: [UIImage], params: [String:String], fileName: [String]){
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        if media[0].jpegData(compressionQuality: 0.5) == nil{
            showAlert(title: "errror", message: "Please select the image")
        }else{
            print("Media images: \(media[0].jpegData(compressionQuality: 0.5))")
            
            var iOS = "IOS"
            var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
            
            print("UserAgent: \(userAgent)")
            
            let headers: HTTPHeaders = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    //import image to request
                    var index = 0
                    for imageUploadData in media{
                        
                        
                        multipartFormData.append(imageUploadData.jpegData(compressionQuality: 0.5)!, withName: "\(fileName[index])", fileName: "\(fileName[index]).jpeg", mimeType: "image/jpeg")
                        
                        print("Image to be uploaded: \(fileName[index])")
                        index = index + 1
                    }
                    
                    //                    multipartFormData.append(media[0].jpegData(
                    //                        compressionQuality: 0.5)!,
                    //                                             withName: fileName[0],
                    //                                             fileName: "\(fileName[0]).jpeg", mimeType: "image/jpeg"
                    //                    )
                    for param in params {
                        let value = param.value.data(using: String.Encoding.utf8)!
                        multipartFormData.append(value, withName: param.key)
                    }
                },
                to: "https://api.woloo.in/api/wolooGuest",
                method: .put ,
                headers: headers
                //Production URL: https://api.woloo.in/api/wolooGuest
                //Dev URL:http://13.127.174.98/api/wolooGuest
            )
            .response { response in
                print("Upload photo response v2: ",response)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
    
    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            print("picked Image: \(pickedImage)")
            
            //self.selectedAadharImage = pickedImage
            
            if displayAdharImg.tag == 1{
                self.selectedAadharImage = pickedImage
                displayAdharImg.contentMode = .scaleAspectFill
                displayAdharImg.image = pickedImage
                displayAdharImg.tag = 0
            }
            else if displayPANImg.tag == 1{
                self.selectedPanImage = pickedImage
                displayPANImg.contentMode = .scaleAspectFill
                displayPANImg.image = pickedImage
                displayPANImg.tag = 0
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
    func validateUserForm(){
        
        guard let emailTxt = emailTxtFld.text else { return }
        guard let firstName = firstNameTxtFld.text else { return }
        guard let lastName = lastNameTxtFld.text else { return }
        guard let phoneNo = phoneTxtFld.text else { return }
       
        guard let streetAddr = addressTxtFld.text else { return }
        guard let city = cityTxtFld.text else { return }
        guard let state = stateTxtFld.text else { return }
        guard let postCode = postalCode.text else { return }
        guard let dob = dobTxtFld.text else { return }
        
        print("retrieved user mob: \(UserDefaultsManager.fetchUserMob())")
        
        if firstName.isEmpty{
            print("Please enter name")
            showAlert(title: "Error!", message: "Please Enter Name")
        } else if lastName.isEmpty{
            print("Please enter Last name")
            showAlert(title: "Error!", message: "Please Enter Last Name")
        }
        else if !emailTxt.isValidEmail(){
            print("InValid Email")
            showAlert(title: "Error!", message: "Please Enter Valid Mail")
        }
//        else if phoneNo.count != 10 {
//            print("Please enter valid number")
//            showAlert(title: "Error!", message: "Please Enter Valid Phone Number")
//        }
        else if streetAddr.isEmpty{
            print("Please enter Address number")
            showAlert(title: "Error!", message: "Please Enter Valid Address")
        }
        else if city.isEmpty {
            showAlert(title: "Error!", message: "Please Enter your state")
        }
        else if state.isEmpty{
            print("Please enter State")
            showAlert(title: "Error!", message: "Please Enter your state")
        }else if  postCode.isEmpty{
            showAlert(title: "Error!", message: "Please Enter Valid Zip/Postal Code")
        }
        else if dob.isEmpty{
            
            showAlert(title: "Error!", message: "Please Enter Valid D.O.B")
            
        }else
        {
            print("Enter DOB is: ",dob)
            print("Data to be uploaded: \(firstName), \(lastName), \(emailTxt), \(streetAddr), \(state) ,\(dob),\(UserDefaultsManager.fetchUserID() ?? 0)")
            
            uploadPhotoV2(media: [selectedAadharImage,selectedPanImage], params: ["id": "\(UserDefaultsManager.fetchUserID() ?? 0)","name": "\(firstName) \(lastName)", "pincode": "\(postCode)", "address":"\(streetAddr))", "city": "\(city)", "state": "\(state)"], fileName: ["aadhar_url","pan_url"])
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension UITextField {
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
