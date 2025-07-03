//
//  ViewController.swift
//  Woloo
//
//  Created by Ashish Khobragade on 17/12/20.
//

import UIKit
import Smartech

class RootVC: UIViewController {
    
   // @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
  //  @IBOutlet weak var optionsTopConstraint: NSLayoutConstraint!
  //  @IBOutlet weak var captionTextTopConstraint: NSLayoutConstraint!
    //@IBOutlet weak var captionText: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
   // @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var nextButton: UIButton!
   // @IBOutlet weak var optionsView2: UIView!
    //@IBOutlet weak var options2TopConstraint: NSLayoutConstraint!
    
    var getAppConfigObserver = AppConfigGetObserver()
    var tabBarVc:TabBarController?
    var languageDict:[String:Any]?
    var appConfigGet = AppConfigGetObserver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DELEGATE.rootVC = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.nextButton.cornerRadius = 25.0
        print("Printing App config data from Root VC: \(UserDefaultsManager.fetchAppConfigData())")
        print("Retrieved Values applicationDidBecomeActive: \(appConfigGet.appConfigGetObserver?.APP_VERSION?.version_code ?? "")")
        var intAppVersionCodeServer = appConfigGet.appConfigGetObserver?.APP_VERSION?.version_code ?? ""
        
        print("Server App config Data Version Code: \(UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.version_code ?? "")")
        print("Server App COnfig Force Update: \(UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.force_update ?? "")")
        
        print("intAppVersionCodeServer \(intAppVersionCodeServer ?? "")")
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("build Version applicationDidBecomeActive:  \(AppBuild!)")
        
        if AppBuild ?? "" < UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.version_code ?? ""{

            if UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.force_update == "1"{
                print("We need to update the app forcefully")
                forceUpdatePopUp()
            }
            else{

                print("We need to soft update the app")
                let alertController = UIAlertController(title: nil, message: "\((UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.update_text ?? ""))", preferredStyle: .alert)

                               // Create the actions
                           let okAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.default) {
                                   UIAlertAction in
                                   NSLog("OK Pressed")
                               let appStoreLink = "https://apps.apple.com/us/app/woloo/id1571476207"

                               guard let url = URL(string: appStoreLink) else { return }
                               UIApplication.shared.open(url)

                               }
                           let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                                   UIAlertAction in
                                   NSLog("Cancel Pressed")

                               print("Update cancelled for now")
                               if UserDefaultsManager.fetchIsUserloggedInStatusSave(){
                                   
                                   print("User login status: \(UserDefaultsManager.fetchIsUserloggedInStatusSave())")
                                   print("Navigating To dashboard from rootVC")
                                   self.performSegue(withIdentifier: Constant.Segue.launchTabBar, sender: nil)

                               }
                               else{
                                   print("Root")
                                   self.animateLogo()
                                   //self.updateDeviceToken()
                                   self.updateDeviceTokenV2()
                                   self.getAppConfig()
                               }

                               }
                               // Add the actions
                               alertController.addAction(okAction)
                               alertController.addAction(cancelAction)

                               // Present the controller
                           self.present(alertController, animated: true, completion: nil)

            }
        }
        else{
            
            print("App is up to date")
            if UserDefaultsManager.fetchIsUserloggedInStatusSave(){
            
                print("User login status: \(UserDefaultsManager.fetchIsUserloggedInStatusSave())")
                print("Navigating To dashboard from rootVC")
                self.performSegue(withIdentifier: Constant.Segue.launchTabBar, sender: nil)
                Smartech.sharedInstance().setUserIdentity("\(UserDefaultsManager.fetchUserMob() ?? "")")
               // Smartech.sharedInstance().login("\(UserDefaultsManager.fetchUserMob() ?? "")")
            }
            else{
                print("Root")
                animateLogo()
                //updateDeviceToken()
                updateDeviceTokenV2()
                getAppConfig()
            }
            
        }
        

       // self.showUserInsurancepopUp(user_id: "\(UserDefaultsManager.fetchUserID())")
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
//        print("Printing App config data from Root VC: \(UserDefaultsManager.fetchAppConfigData())")
//        print("Retrieved Values applicationDidBecomeActive: \(appConfigGet.appConfigGetObserver?.APP_VERSION?.version_code ?? "")")
//        var intAppVersionCodeServer = appConfigGet.appConfigGetObserver?.APP_VERSION?.version_code ?? ""
//
//        print("Server App config Data Version Code: \(UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.version_code ?? "")")
//        print("Server App COnfig Force Update: \(UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.force_update ?? "")")
//
//        print("intAppVersionCodeServer \(intAppVersionCodeServer ?? "")")
//        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
//        print("build Version applicationDidBecomeActive:  \(AppBuild!)")
//
//        if AppBuild ?? "" <= UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.version_code ?? ""{
//
//
//
//            if UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.force_update == "1"{
//                print("We need to update the app forcefully")
//                forceUpdatePopUp()
//            }
//            else{
//
//                print("We need to soft update the app")
//                let alertController = UIAlertController(title: nil, message: "\((UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.update_text)!)", preferredStyle: .alert)
//
//                               // Create the actions
//                           let okAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.default) {
//                                   UIAlertAction in
//                                   NSLog("OK Pressed")
//                               let appStoreLink = "https://apps.apple.com/us/app/woloo/id1571476207"
//
//                               guard let url = URL(string: appStoreLink) else { return }
//                               UIApplication.shared.open(url)
//
//                               }
//                           let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//                                   UIAlertAction in
//                                   NSLog("Cancel Pressed")
//                               }
//                               // Add the actions
//                               alertController.addAction(okAction)
//                               alertController.addAction(cancelAction)
//
//                               // Present the controller
//                           self.present(alertController, animated: true, completion: nil)
//
//            }
//        }
//        else{
//
//            print("App is up to date")
//            if UserDefaultsManager.fetchIsUserloggedInStatusSave(){
//                print("Navigating To dashboard from rootVC")
//                self.performSegue(withIdentifier: Constant.Segue.launchTabBar, sender: nil)
//
//            }
//            else{
//                print("Root")
//                animateLogo()
//                updateDeviceToken()
//                getAppConfig()
//            }
//
//        }
//
        
//        if AppBuild ?? "" < (UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.version_code)! && (UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.force_update)! == "0"{
//            print("We need to update the app")
//            forceUpdatePopUp()
//            //softUpdatePopUp()
//        }else if AppBuild ?? "" > (UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.version_code)! && (UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.force_update)! == "1"{
//            print("App is updated")
//            // Create the alert controller
//            let alertController = UIAlertController(title: nil, message: "\((UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.update_text)!)", preferredStyle: .alert)
//
//                // Create the actions
//            let okAction = UIAlertAction(title: "Update", style: UIAlertAction.Style.default) {
//                    UIAlertAction in
//                    NSLog("OK Pressed")
//                let appStoreLink = "https://apps.apple.com/us/app/woloo/id1571476207"
//
//                guard let url = URL(string: appStoreLink) else { return }
//                UIApplication.shared.open(url)
//
//                }
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//                    UIAlertAction in
//                    NSLog("Cancel Pressed")
//                }
//
//                // Add the actions
//                alertController.addAction(okAction)
//                alertController.addAction(cancelAction)
//
//                // Present the controller
//            self.present(alertController, animated: true, completion: nil)
//        }
//        if UserDefaultsManager.fetchIsUserloggedInStatusSave() == true{
//            print("Dashboard")
//            self.performSegue(withIdentifier: Constant.Segue.launchTabBar, sender: nil)
//
//
//        }else{
//            print("Root")
//            animateLogo()
//            updateDeviceToken()
//            getAppConfig()
//
//        }
        
      
        
//        if UserModel.isUserLoggedIn(){
//            print("Dashboard")
//            self.performSegue(withIdentifier: Constant.Segue.launchTabBar, sender: nil)
//        }
//        else{
//            print("Root")
//            animateLogo()
//            updateDeviceToken()
//            getAppConfig()
//        }
    }
    
    func getAppConfig(){
        
        getAppConfigObserver.appConfigGet()
    }
    
    fileprivate func updateDeviceToken() {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let deviceToken = UserDefaults.standard.value(forKey:"fcmToken") as? String ?? ""
        let param:  [String : Any] =  [ "deviceSerial": deviceId,
                                        "deviceToken": deviceToken ]
        APIManager.shared.updateDeviceToken(param) {[weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                print(message)
            }
        }
    }
    
    
    fileprivate func updateDeviceTokenV2(){
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": "\(UserDefaultsManager.fetchAuthenticationToken())", "user-agent": userAgent]
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let deviceToken = UserDefaults.standard.value(forKey: "fcmToken") as? String ?? ""
        let data:  [String : Any] =  [ "deviceSerial": deviceId,
                                        "deviceToken": deviceToken ]
        
        NetworkManager(data: data, headers: headers ,url: nil, service: .updateDeviceToken, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<UpdateDeviceTokenModel>, Error>) in
            switch result {
            case .success(let response):
                print("Update Device Token Response: ", response)

                
            case .failure(let error):
                print("Update Device token error: ", error)
            }
        }
        
        
    }

    fileprivate func animateLogo() {
        self.imgLogo.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.5) {
            self.imgLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
               }
//        UIView.animate(withDuration: 0, delay: 5, animations:{
//            self.performSegue(withIdentifier: Constant.Segue.authentication, sender: nil)
//        }, completion: { (finished) in
//
//        })
    }
    
    fileprivate func addOptionsAnimation() {
        
        UIView.animate(withDuration: 1.0, animations: {
            
           // self.logoTopConstraint.constant = 75
//            self.captionTextTopConstraint.constant = 215
//            self.optionsTopConstraint.constant = 250
//            self.captionText.isHidden = false
//            self.optionsView.isHidden = false
            
            self.view.layoutSubviews()
            
        }) { (isFinish) in
            
            self.nextButton.isHidden = false
        }
    }
    
    fileprivate func addOptions2Animation() {
        
        UIView.animate(withDuration: 1.0, animations: {
//            self.optionsTopConstraint.constant = -700
//            self.options2TopConstraint.constant = 250
//            self.optionsView2.isHidden = false
            
            self.view.layoutSubviews()
            
        }) { (isFinish) in
            
            self.nextButton.isHidden = false
        }
    }
    
    @IBAction func didTapNextButton(_ sender:UIButton){
        NSLog("didTapNextButton:")
        if let boardingStatus = UserDefaults.tutorialScreen, boardingStatus { // For show tutorial screen.
            DELEGATE.window = UIWindow(frame: UIScreen.main.bounds)
            let authentication: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let loginVC: LoginVC = authentication.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController(rootViewController: loginVC)
            DELEGATE.window?.rootViewController = nav
            DELEGATE.window?.makeKeyAndVisible()
            return
        }
        self.performSegue(withIdentifier: Constant.Segue.authentication, sender: nil)
        return
    }
    
    func launchTabBar(_ sender:UIButton){
        performSegue(withIdentifier: Constant.Segue.launchTabBar, sender: nil)
    }
    
    func forceUpdatePopUp() {
        DispatchQueue.main.async {
            if let view = UIApplication.shared.windows.first?.rootViewController?.view, let controller = UIApplication.shared.windows.first?.rootViewController {
                let alert = WolooAlert(frame: view.frame, cancelButtonText: "Update", title: nil, message: "\((UserDefaultsManager.fetchAppConfigData()?.APP_VERSION?.update_text)!)" ?? "Please update to latest version", image: #imageLiteral(resourceName: "logo"), controller: controller)
                alert.cancelTappedAction = {
                    print("navigate user to app store")
                    
                    let appStoreLink = "https://apps.apple.com/us/app/woloo/id1571476207"

                    guard let url = URL(string: appStoreLink) else { return }
                    UIApplication.shared.open(url)
                }
                view.addSubview(alert)
                view.bringSubviewToFront(alert)
            }
        }
    }
    
    func showUserInsurancepopUp(user_id: String){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        let data = ["user_id": user_id] as [String: Any]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
       //https://api.woloo.in/api/wolooGuest/profileStatus?
        NetworkManager(data: data, headers: headers, url: "https://api.woloo.in/api/wolooGuest/profileStatus?", service: nil, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<UserInsuranceStatusModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("Show insurance pop up: ", response)
                print("show user form: ",response.results.isShowProfileForm!)
                if response.results.isShowProfileForm == true
                {
                    
                    let dashboardSB = UIStoryboard(name: "Dashboard", bundle: nil)
                    
                    if let dashboardVC = dashboardSB.instantiateViewController(withIdentifier: "UserProfileView") as? UserProfileView {
            //            trackerVC.isFromDashBoard = true
                        self.navigationController?.pushViewController(dashboardVC, animated: true)
                    }
                    
                }
                
                
            case .failure(let error):
                print("Show insurance pop up failed: ", error)
            }
        }
    }
}

/*  let dashboardSB = UIStoryboard(name: "Dashboard", bundle: nil)
 if let myOfferVC = dashboardSB.instantiateViewController(withIdentifier: "SearchLocationViewController") as? SearchLocationViewController {
     myOfferVC.isMyOffer = true
     navigationController?.pushViewController(myOfferVC, animated: true)
 }*/
