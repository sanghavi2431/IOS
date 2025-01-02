//
//  OTPVerificationVC.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//

import UIKit
import SwiftyJSON
import Smartech


class OTPVerificationVC: UIViewController {
    
    @IBOutlet weak var otpView: OTPFieldView!
    @IBOutlet weak var otpTimerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var notYouButton: UIButton!
    @IBOutlet weak var imgTrial: UIImageView!
    @IBOutlet weak var vwTrial: UIView!
    @IBOutlet weak var lblTrial: UILabel!
    @IBOutlet weak var daysTrialLbl: UILabel!
    @IBOutlet weak var trialLblStatus: UILabel!
    
    var loginDO:Login?
    var count = 60
    var timer:Timer!
    var otpCount = 0
    
    var verifyOtpV2 = VerifyOtpObserver()
    var sendOtpV2 = SendOtpObserver()
    
    // var resendOtpv2: SendOtpObserver?
    
    var enteredMobileNumber: String?
    //------------------------------------------------->
    var verifyOtpObserver: VerifyOtpModel? = nil
    
    var appConfigGetObserverV2: AppCofigGetModel? = nil
    //-------------------------------------------------->
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Passed Mobile Number: \(loginDO?.userMobile ?? "")")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appConfigGetV2()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureUI()
    }
    func configureUI()  {
        
        notYouButton.setAttributedTitle("Not You?".getUnderlinedString(textColor: .main, underlineColor: .main), for: .normal)
        resendButton.setAttributedTitle("Resend Code".getUnderlinedString(textColor: .textColor, underlineColor: .textColor), for: .normal)
        
        setupOtpView()
        enableDisableDoneButton(enable: false)
        enableDisableResendButton(enable:false)
        startTimer()
        configureMessage()
    }
    
    func configureMessage() {
        
        
        
        guard let login = loginDO else { return }
        
        if let email = login.userEmail{
            
            messageLabel.text = "Please enter the verification code sent on your registered e-mail \(email.addEmailXXX()) below"
        }
        else if let mobile = login.userMobile{
            
            messageLabel.text = "Please enter the verification code sent on your registered mobile \(mobile.addMobileXXX()) below"
        }
    }
    
    func setupOtpView(){
        self.otpView.fieldsCount = 4
        self.otpView.filledBackgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.otpView.defaultBackgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.otpView.fieldFont = ThemeManager.Font.OpenSans_bold(size: 16)
        self.otpView.textColor = .white
        self.otpView.fieldBorderWidth = 1
        self.otpView.defaultBorderColor = .textColor
        self.otpView.filledBorderColor = .main
        self.otpView.cursorColor = .main
        self.otpView.displayType = .roundedCorner
        self.otpView.fieldSize = 40
        self.otpView.separatorSpace = 10
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.initializeUI()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func didTapVerifyAndProceed(_ sender:UIButton){
        //        self.performSegue(withIdentifier: Constant.Segue.launchTabBar, sender: nil)
        //verifyOTP()
        //verifyOTPV2()
        guard var request = loginDO else { return }
        request.otp = Int(otpView.finalOtpString!)
        print("OTP entered: ",request.otp ?? 0)
        
        var requestID = apiRequestID
        print("sendOtpV2.requestIDReceived: \(sendOtpV2.requestIDReceived)")
        print("Request ID retrieved: ", requestID)
        
        verifyOTPV3(request_id: "\(requestID)", otp: "\(request.otp ?? 0)")
    }
    
    @IBAction func didTapResendButton(_ sender: Any) {
        //resendOtp()
        resendOtpWolooV2()
    }
    
    @IBAction func popupOkayClick(_ sender: Any) {
        // openGenderVC()
        if self.verifyOtpObserver?.user?.gender ?? "" == "" {// user haven't done gender selection.
            self.openGenderVC()
            
        } else { // user has done gender selection.
            self.openTopicScreen()
            
        }
        
        //self.performSegue(withIdentifier: Constant.Segue.launchTabBar, sender: nil)
    }
    // MARK: - Private Methods
    
    func enableDisableDoneButton(enable:Bool) {
        
        if enable{
            
            doneButton.backgroundColor = .main
            doneButton.setTitleColor(.black, for: .normal)
            doneButton.isEnabled = true
            doneButton.alpha = 1.0
        }
        else{
            doneButton.backgroundColor = .clear
            doneButton.setTitleColor(.main, for: .normal)
            doneButton.isEnabled = false
            doneButton.alpha = 0.5
        }
    }
    
    func enableDisableResendButton(enable:Bool) {
        
        if enable{
            
            resendButton.isEnabled = true
            resendButton.alpha = 1.0
        }
        else{
            resendButton.isEnabled = false
            resendButton.alpha = 0.5
        }
    }
    
    
    @objc func updateTimer(){
        
        count = count - 1
        
        self.otpTimerLabel.text = "\(count)s"
        
        if count == 0{
            self.otpTimerLabel.text = ""
            timer.invalidate()
            enableDisableResendButton(enable:true)
        }
    }
    
    fileprivate func startTimer() {
        count = 60
        self.otpTimerLabel.text = "\(count)s"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func forceUpdatePopUp() {
        DispatchQueue.main.async {
            if let view = UIApplication.shared.windows.first?.rootViewController?.view, let controller = UIApplication.shared.windows.first?.rootViewController {
                let alert = WolooAlert(frame: view.frame, cancelButtonText: "Update", title: nil, message: "Otp Verification Issue", image: #imageLiteral(resourceName: "logo"), controller: controller)
                alert.cancelTappedAction = {
                    print("navigate user to app store")
                    
                    alert.isHidden = true
                }
                view.addSubview(alert)
                view.bringSubviewToFront(alert)
            }
            
        }
    }
}


// MARK: - API Calls

extension OTPVerificationVC{
    
    func verifyOTP()  {
        
        guard var request = loginDO else { return }
        
        request.otp = Int(otpView.finalOtpString!)
        APIManager.shared.verifyOTP(request: request) { (userModel, message) in
            
            print("USerModel------->", userModel)
            print("USerMessage------->", message)
            
            if let userModel = userModel{
                UserModel.saveAuthorizedUserInfo(userModel)
                UserModel.setUserLoggedInStatus(status: true)
                UserModel.user = userModel
                //                self.showToast(message: "Welcome")
                if userModel.isFirstSession == 1 {
                    self.vwTrial.isHidden = false
                    //                    self.imgTrial.sd_setImage(with: URL(string: AppConfig.getAppConfigInfo()?.urls?.freeTrialImageURL ?? ""), completed: nil)
                    //                    self.lblTrial.text = AppConfig.getAppConfigInfo()?.customMessage?.freeTrialDialogText
                } else {
                    //self.performSegue(withIdentifier: Constant.Segue.launchTabBar, sender: nil)
                    
                    if let gender = userModel.gender {
                        self.openTopicScreen()
                    } else { // user haven't done gender selection.
                        self.openGenderVC()
                    }
                    
                }
            } else {
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "OKAY", title: nil, message: message, image: #imageLiteral(resourceName: "logo"), controller: self)
                    alert.cancelTappedAction = {
                        alert.removeFromSuperview()
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                }
                //                self.errorLabel.textColor = .red
                //                self.errorLabel.text = message
            }
        }
    }
    
    //Custom verify otp response
    //func verifyOTPV3(){
    
    func verifyOTPV3(request_id: String, otp: String){
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        let data = ["request_id": request_id, "otp": otp] as [String : Any]
        
        NetworkManager(data: data, url: nil, service: .verifyOtp, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<VerifyOtpModel>, Error>) in
            switch result{
            case .success(let response):
                self.verifyOtpObserver = response.results
                print("Verify Otp response ------>",response)
                //gender = response.results.user?.gender ?? ""
                userFirstSession = response.results.user?.is_first_session ?? 0
                
                
                
                //Saving the authentication token
                UserDefaultsManager.storeAuthenticationToken(value: response.results.token ?? "")
                UserDefaultsManager.isUserloggedInStatusSave(value: true)
                print("Saved User ID \(response.results.user?.id)")
                //print("Retrieve id: \(response.results.id)")
                UserDefaultsManager.saveUserID(value: response.results.user_id ?? 0)
                
                print("Saving user Mobile: \(response.results.user?.mobile ?? "")")
                print("Printing app config data: \(UserDefaultsManager.fetchAppConfigData())")
                
                let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
                print("App version: \(AppVersion)")
                UserDefaultsManager.storeUserMob(value: response.results.user?.mobile ?? "")
                
                //                    if self.verifyOtpObserver?.user?.is_first_session == 1{
                //                        self.vwTrial.isHidden = false
                //                        self.imgTrial.image = #imageLiteral(resourceName: "FreeVoucher")
                //                        self.lblTrial.text = "Custom text Input"
                //                        var freeDays = 30
                //                        self.daysTrialLbl.text = "\(freeDays) \n Days"
                //                    }
//                if self.verifyOtpObserver?.user?.isFreeTrial ?? 0 == 1{
//                    self.vwTrial.isHidden = false
//                    self.imgTrial.image = #imageLiteral(resourceName: "woloo_empty")
//                    self.lblTrial.text = UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.freeTrialDialogText ?? ""
//                    self.daysTrialLbl.text = "\(UserDefaultsManager.fetchAppConfigData()?.free_trial_period_days ?? "") \n Days"
//
//                    self.trialLblStatus.text = "\(UserDefaultsManager.fetchAppConfigData()?.free_trial_text ?? "")"
//                }
               // else{
                    
                    if self.verifyOtpObserver?.user?.gender ?? "" == "" && self.verifyOtpObserver?.user?.isFreeTrial ?? 0 == 1{// user haven't done gender selection.
                        //self.openGenderVC()
//                        Smartech.sharedInstance().login("\(response.results.user?.mobile ?? "")")
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let date = dateFormatter.date(from: "\(response.results.user?.expiry_date ?? "")")
                        
                       
                        
                        Smartech.sharedInstance().login("\(response.results.user?.mobile ?? "")")
                        let profilePushDictionary = ["MOBILE_NO": "\(response.results.user?.mobile ?? "")","ROLE_ID": "\(String(describing: response.results.user?.role_id ?? nil))", "NAME": "\(response.results.user?.name ?? "")","GENDER": "\(response.results.user?.gender ?? "")", "USER_ID": "\(response.results.user?.id ?? 0)", "DOB": "\(response.results.user?.dob ?? "")", "EXPIRY_DATE" : "\(date!)", "APP_VERSION": "\(AppVersion ?? "")"]
                        print("Exppiry date: \(date!)")
                        print("Netcore DOB test: \(response.results.user?.dob ?? "")")
                        Smartech.sharedInstance().updateUserProfile(profilePushDictionary)
                        Smartech.sharedInstance().trackEvent("User_Registration_Success", andPayload: ["MOBILE_NO": "\(response.results.user?.mobile ?? "")"])
                        Hansel.getUser()?.setUserId("\(response.results.user?.mobile ?? "")")
                        
                        
                        self.vwTrial.isHidden = false
                        self.imgTrial.image = #imageLiteral(resourceName: "woloo_empty")
                        self.lblTrial.text = UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.freeTrialDialogText ?? ""
                        self.daysTrialLbl.text = "\(UserDefaultsManager.fetchAppConfigData()?.free_trial_period_days ?? "") \n Days"
                        
                        self.trialLblStatus.text = "\(UserDefaultsManager.fetchAppConfigData()?.free_trial_text ?? "")"
                        
                    } else { // user has done gender selection.
                        //self.openTopicScreen()
                        //existing user
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        var expireTrialDate: Date?
                        if let expiryDate = dateFormatter.date(from: "\(response.results.user?.expiry_date ?? "")") {
                            
                            expireTrialDate = expiryDate
                            
                        }
                        let date = expireTrialDate
                        
                        
                        
                        
                        if response.results.user?.role_id == 0{
                            
                            Hansel.getUser()?.putAttribute("registered_users", forKey: "user_type")
                        }
                        else{
                            
                            Hansel.getUser()?.putAttribute("woloo_host", forKey: "user_type")
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            Smartech.sharedInstance().login("\(response.results.user?.mobile ?? "")")
                        }
                        
                       
                        Hansel.getUser()?.setUserId("\(response.results.user?.mobile ?? "")")
                        
                        let profilePushDictionary = ["MOBILE_NO": "\(response.results.user?.mobile ?? "")","ROLE_ID": "\(String(describing: response.results.user?.role_id ?? nil))", "NAME": "\(response.results.user?.name ?? "")","GENDER": "\(response.results.user?.gender ?? "")", "USER_ID": "\(response.results.user?.id ?? 0)", "DOB": "\(response.results.user?.dob ?? "")", "EXPIRY_DATE" : "\(date!)", "APP_VERSION": "\(AppVersion ?? "")"]
                        print("Exppiry date: \(date!)")
                        Smartech.sharedInstance().updateUserProfile(profilePushDictionary)
                        Smartech.sharedInstance().trackEvent("User_Login_Success", andPayload: ["MOBILE_NO": "\(response.results.user?.mobile ?? "")"])
                        self.openMainTab()

                    }
                    
                    //                        let tabSB = UIStoryboard(name: "TabBar", bundle: nil)
                    //                        if let main = tabSB.instantiateInitialViewController() {
                    //                            self.navigationController?.pushViewController(main, animated: true)
                    //                        }
              //  }
                
            case .failure(let error):
                print("Verify otp failed\(error)")
                self.wrongOtpPopUp()
            }
        }
    }
    
    
    func appConfigGetV2(){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        //MARK: Network Call
        
       let localeData = [ "language" : "en",
                      "platform" : "ios",
                      "country" : "IN",
                      "segment" : "",
                      "version" : "1",
                      "packageName":"in.woloo.www"] as [String : String]
        
        
        
        
        let data = ["locale": localeData] as [String : Any]
        
        //http://13.127.174.98/api/wolooGuest/appConfig
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .appConifgGet, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<AppCofigGetModel>, Error>) in
            switch result{
                
            case .success(let response):
                self.appConfigGetObserverV2 = response.results
                print("App Config get response: ",response)
                UserDefaultsManager.storeAppConfigData(value: response.results)
            
                
            case .failure(let error):
                print("App config error", error)
                
            }
        }
    }
    
    //}
    
    func resendOtp()  {
        otpCount = otpCount + 1
        if otpCount >= 3 {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "OKAY", title: nil, message: "There seems some problem with the OTP service.\n\nPlease check at your end if the messages are recieved and also try to login after sometime.\n\nSoon Wooloo team will be in touch with you for the same.", image: #imageLiteral(resourceName: "logo"), controller: self)
                alert.cancelTappedAction = {
                    alert.removeFromSuperview()
                }
                self.view.addSubview(alert)
                self.view.bringSubviewToFront(alert)
            }
        }
        guard let request = loginDO else { return }
        ///------------
        APIManager.shared.loginCustom(request: request) { (status, response) in
            if status{
                self.enableDisableResendButton(enable:false)
                self.startTimer()
                // self.showToast(message: response.message ?? "")
            }
            
        }
    }
    
    func resendOtpWolooV2(){
        otpCount = otpCount + 1
        if otpCount >= 3 {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "OKAY", title: nil, message: "There seems some problem with the OTP service.\n\nPlease check at your end if the messages are recieved and also try to login after sometime.\n\nSoon Wooloo team will be in touch with you for the same.", image: #imageLiteral(resourceName: "logo"), controller: self)
                alert.cancelTappedAction = {
                    alert.removeFromSuperview()
                }
                self.view.addSubview(alert)
                self.view.bringSubviewToFront(alert)
            }
            guard let request = loginDO else { return }
            
        }
        //resendOtpv2?.sendOtp(mobileNumber: loginDO?.userMobile ?? "")
        sendOtpV2.sendOtp(mobileNumber: loginDO?.userMobile ?? "", referral_code: "\(UserDefaults.referralCode ?? "")")
        
        
        self.startTimer()
    }
    
    func wrongOtpPopUp(){
        
        let alertController = UIAlertController(title: nil, message: "Incorrect Otp", preferredStyle: .alert)
        //Create the actions
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            
        }
        
        // Add the actions
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
}


extension OTPVerificationVC: OTPFieldViewDelegate {
    
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        enableDisableDoneButton(enable: hasEntered)
        
        if !hasEntered{
            self.errorLabel.textColor = .textColor
            self.errorLabel.text = "Didn’t receive OTP code?"
        }
        
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
    }
}

// MARK: - Handle Other Controller
extension OTPVerificationVC {
    private func openGenderVC() {
        let authenticationSB = UIStoryboard(name: "Authentication", bundle: nil)
        if let genderVC = authenticationSB.instantiateViewController(withIdentifier: "GenderSelectionController") as? GenderSelectionController {
            navigationController?.pushViewController(genderVC, animated: true)
        }
    }
    
    private func openTopicScreen() {
        let topicSB = UIStoryboard(name: "Authentication", bundle: nil)
        if let topicVC = topicSB.instantiateViewController(withIdentifier: "IntrestedTopicVC") as? IntrestedTopicVC {
            navigationController?.pushViewController(topicVC, animated: true)
        }
    }
    
    private func openTrackerScreen() {
        let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let trackerVC = trackerSB.instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController {
            navigationController?.pushViewController(trackerVC, animated: true)
        }
    }
    
    private func openMainTab() {
        let tabSB = UIStoryboard(name: "TabBar", bundle: nil)
        if let main = tabSB.instantiateInitialViewController() {
            navigationController?.pushViewController(main, animated: true)
        }
    }
    
}




