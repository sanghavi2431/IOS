//
//  LoginVC.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//

import UIKit
import AppTrackingTransparency
class LoginVC: UIViewController {

    @IBOutlet weak var authenticationIdText: UITextField!
    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var socialLoginStack: UIStackView!
    
    var sendOtp = SendOtpObserver()
    var netcoreEvents = NetcoreEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureAppsFlyer()
        
        print("App config from user defaults: ", UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")
    }
    
    func configureUI()  {
        self.navigationController?.navigationBar.isHidden = true
        if AppConfig.getAppConfigInfo()?.customMessage?.isSocialLoginEnable == "true" {
            socialLoginStack.isHidden = false
        } else {
            socialLoginStack.isHidden = true
        }
        enableDisableSendOtpButton(enable:false)
      
        #if DEBUG
       // authenticationIdText.text = "1237891231"
        enableDisableSendOtpButton(enable:true)
        #endif
    }

    func configureAppsFlyer(){
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in }
          }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constant.Segue.otpSegue,let login = sender as? Login {
            
            if let verificationVC = segue.destination as? OTPVerificationVC{
                verificationVC.loginDO = login
            }
        }
    }
  
    
    
    @IBAction func didTapLoginButton(_ sender: Any) {
 
        guard let username = authenticationIdText.text else { return }
        
        if username.contains("@"){
            
            if username.isValidEmail() {
//                self.performSegue(withIdentifier: Constant.Segue.otpSegue, sender: nil)
                print("Valid Email")
                signIn(username: username, isEmail: true)
            }
            else{
                print("Invalid Email")
                self.showToast(message: LocalizedString(key: StringConstants.validEmailIdMessage, value: ""))
            }
        }
        else{
            if username.count == 10 {
                print("valid mobile number entered")
                signIn(username: username, isEmail: false)
            } else {
                self.showToast(message: "Please enter 10 digit mobile number.")
                print("Please enter number 10 digit number")
               // print("Please enter valid mobile Number")
               
            }
            
        }
    }

    @IBAction func unwindToLoginVC(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    @IBAction func privacyPolicyBtnPressed(_ sender: UIButton) {
        
        print("Navigating to OTP verification vc")
            print("Navigation flag is true")
            self.performSegue(withIdentifier: Constant.Segue.privacyPolicySegue, sender: nil)
    }
    
    // MARK: - Private Methods
    
    func enableDisableSendOtpButton(enable:Bool) {
        
        if enable{
            sendOtpButton.backgroundColor = .main
            sendOtpButton.setTitleColor(.black, for: .normal)
            sendOtpButton.isEnabled = true
            sendOtpButton.alpha = 1.0
        }
        else{
            sendOtpButton.backgroundColor = .clear
            sendOtpButton.setTitleColor(.main, for: .normal)
            sendOtpButton.isEnabled = false
            sendOtpButton.alpha = 0.5
        }
    }
}

// MARK: - API Calls

extension LoginVC{
    
    func signIn(username:String,isEmail:Bool)  {
        Global.addNetcoreEvent(eventname: self.netcoreEvents.mobileInsert, param: ["mobile":username])
        Global.addFirebaseEvent(eventName: "mobile_insert", param: ["mobile":username])
        var request = Login()
        
        if isEmail{
            
            request.userEmail = username
            
        }
        else{
            request.userMobile = username
            print("Entered Mobile Number to be passed: \(request.userMobile ?? "")")
            
        }
   
        if UserDefaults.referralCode != nil {
            print("referral code: \(request.referralCode)")
            request.referralCode = UserDefaults.referralCode
        }
        
        //To call the sendOtp
        
        if request.userMobile?.count == 10 {
            self.sendOtp.sendOtp(mobileNumber: request.userMobile ?? "", referral_code: "\(UserDefaults.referralCode ?? "")")
            
            print("Navigating to OTP verification vc")
                print("Navigation flag is true")
                self.performSegue(withIdentifier: Constant.Segue.otpSegue, sender: request)
                //OTPVerificationVC storyboard ID
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
//                vc.enteredMobileNumber = request.userMobile ?? ""
//                self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            print("Please enter number 10 digit number")
        }
        
        ///Existing code of to call the sendOtp API
//        APIManager.shared.loginCustom(request: request) { (status, response) in
//            if status{
//                if response.status?.lowercased() == "failed" {
//                    DispatchQueue.main.async {
//                        let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Okay", title: nil, message: AppConfig.getAppConfigInfo()?.maintenanceSetting?.maintenanceMessage ?? "Under maintainence", image: #imageLiteral(resourceName: "logo"), controller: self)
//                            alert.cancelTappedAction = {
//                                alert.removeFromSuperview()
//                            }
//                        self.view.addSubview(alert)
//                        self.view.bringSubviewToFront(alert)
//                    }
//                } else {
//
//                self.performSegue(withIdentifier: Constant.Segue.otpSegue, sender: request)
//                }
//            }
//            else{
//                self.showToast(message: response.message ?? "")
//            }
//        }
    }
}

// MARK: - UI

extension LoginVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > 5{
            
            enableDisableSendOtpButton(enable:true)
        }
        else{
            enableDisableSendOtpButton(enable:false)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let authenticationId = textField.text else { return }
        
        if authenticationId.count > 5{
            
            enableDisableSendOtpButton(enable:true)
        }
        else{
            enableDisableSendOtpButton(enable:false)
        }
    }
}
