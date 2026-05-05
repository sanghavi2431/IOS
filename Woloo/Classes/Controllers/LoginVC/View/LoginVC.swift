//
//  LoginVC.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//

import UIKit
import AppTrackingTransparency
import SafariServices
class LoginVC: UIViewController {

    @IBOutlet weak var authenticationIdText: UITextField!
    @IBOutlet weak var sendOtpButton: UIButton!
    
    @IBOutlet weak var socialLoginStack: UIStackView!
    
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    
    
    @IBOutlet weak var termsLabel: UILabel!
    
    var sendOtp = SendOtpObserver()
    
    var netcoreEvents = NetcoreEvents()
    var someVar: String = ""
    var objLoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureAppsFlyer()
        
        print("App config from user defaults: ", UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")
    }
    
    func configureUI()  {
        
        self.objLoginViewModel.delegate = self
        self.navigationController?.navigationBar.isHidden = true
     
        //enableDisableSendOtpButton(enable:false)
      
        #if DEBUG
       // authenticationIdText.text = "1237891231"
        //enableDisableSendOtpButton(enable:true)
        #endif
        
        let fullText = "Please read our Terms & Conditions and our Privacy Policy"
            let attributedString = NSMutableAttributedString(string: fullText)

            // Mark "Terms & Conditions" as clickable (blue & underlined)
            if let termsRange = fullText.range(of: "Terms & Conditions") {
                let nsRange = NSRange(termsRange, in: fullText)
                attributedString.addAttributes([
                    .foregroundColor: UIColor.systemBlue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ], range: nsRange)
            }

            // Mark "Privacy Policy" as clickable
            if let privacyRange = fullText.range(of: "Privacy Policy") {
                let nsRange = NSRange(privacyRange, in: fullText)
                attributedString.addAttributes([
                    .foregroundColor: UIColor.systemBlue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ], range: nsRange)
            }

            termsLabel.attributedText = attributedString
            termsLabel.isUserInteractionEnabled = true

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(_:)))
            termsLabel.addGestureRecognizer(tapGesture)
    }
    
    
    
    @objc func didTapLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = termsLabel.attributedText?.string else { return }

        let tapLocation = gesture.location(in: termsLabel)
        if let index = indexOfCharacterAtPoint(tapLocation) {

            if let termsRange = text.range(of: "Terms & Conditions"),
               NSRange(termsRange, in: text).contains(index) {
                openTermsAndConditions()
            } else if let privacyRange = text.range(of: "Privacy Policy"),
                      NSRange(privacyRange, in: text).contains(index) {
                openPrivacyPolicy()
            }
        }
    }
    
    // Helper function: get tapped character index
    func indexOfCharacterAtPoint(_ point: CGPoint) -> Int? {
        guard let attributedText = termsLabel.attributedText else { return nil }
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: termsLabel.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = termsLabel.numberOfLines
        textContainer.lineBreakMode = termsLabel.lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let index = layoutManager.characterIndex(
            for: point,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        return index
    }
    
    // Actions
    func openTermsAndConditions() {
        print("Terms & Conditions tapped")
        // e.g., push a webview
        guard let url = URL(string: "https://woloo.in/terms-condition/") else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
    }

    func openPrivacyPolicy() {
        print("Privacy Policy tapped")
        // e.g., push a webview
        print("Navigating to OTP verification vc")
            print("Navigation flag is true")
            self.performSegue(withIdentifier: Constant.Segue.privacyPolicySegue, sender: nil)
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
                Global.showAlert(title: "", message: "Please Enter Valid Phone Number")
                print("Please enter number 10 digit number")
               // print("Please enter valid mobile Number")
              
            }
            
        }
    }


    
    @IBAction func privacyPolicyBtnPressed(_ sender: UIButton) {
        
        print("Navigating to OTP verification vc")
            print("Navigation flag is true")
            self.performSegue(withIdentifier: Constant.Segue.privacyPolicySegue, sender: nil)
    }
    
    // MARK: - Private Methods
    
    func enableDisableSendOtpButton(enable:Bool) {
        
        if enable{
            sendOtpButton.backgroundColor = .white
            sendOtpButton.setTitleColor(.black, for: .normal)
            sendOtpButton.isEnabled = true
            //sendOtpButton.alpha = 1.0
        }
        else{
            sendOtpButton.backgroundColor = .white
            sendOtpButton.setTitleColor(.black, for: .normal)
            sendOtpButton.isEnabled = false
           // sendOtpButton.alpha = 0.5
        }
    }
    
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
    //            self.sendOtp.sendOtp(mobileNumber: request.userMobile ?? "", referral_code: "\(UserDefaults.referralCode ?? "")")
                
                if !Utility.isEmpty(UserDefaultsManager.fetchReferralID()){
                    self.objLoginViewModel.sendOtp(mobileNumber: request.userMobile ?? "", referral_code: UserDefaultsManager.fetchReferralID())
                }
                else {
                    self.objLoginViewModel.sendOtp(mobileNumber: request.userMobile ?? "", referral_code: "")
                }
                
                print("Navigating to OTP verification vc")
                    print("Navigation flag is true")
                  //  self.performSegue(withIdentifier: Constant.Segue.otpSegue, sender: request)
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

// MARK: - API Calls
class TestLoginVC: LoginVC {
    var testSendOtp: SendOtpObserver?
    override var sendOtp: SendOtpObserver {
        get { testSendOtp ?? super.sendOtp }
        set { testSendOtp = newValue }
    }
}


// MARK: - UI

extension LoginVC:UITextFieldDelegate, LoginViewModelDelegate{
    
    
    func didSendOtpSuccessResponse(objResponse: BaseResponse<SendOtpModel>) {
            print("send otp success response")
            apiRequestID = objResponse.results.request_id ?? ""
            guard let username = authenticationIdText.text else { return }
            var request = Login()
            var isEmail:Bool = false
            
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
            self.performSegue(withIdentifier: Constant.Segue.otpSegue, sender: request)
        }
    
    func didSendOtpError(strError: String) {
            print("error: ", strError)
            Global.showAlert(title: "Error..!!", message: strError)
        }
    
    
    //MARK: - LoginViewModelDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > 5{
            
            //enableDisableSendOtpButton(enable:true)
        }
        else{
            //enableDisableSendOtpButton(enable:false)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let authenticationId = textField.text else { return }
        
        if authenticationId.count > 5{
            
           // enableDisableSendOtpButton(enable:true)
        }
        else{
            //enableDisableSendOtpButton(enable:false)
        }
    }
}
