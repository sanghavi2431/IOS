//
//  InviteFriendVC.swift
//  Woloo
//
//  Created by Vivek shinde on 24/12/20.
//

import UIKit
import ContactsUI
import Firebase
import KNContactsPicker

class InviteFriendVC: UIViewController {
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblRewardMessage: UILabel!

    @IBOutlet weak var whtsappBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    var shortLink = ""
    var netcoreEvents = NetcoreEvents()
    var objUserModel: UserProfileModel.Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.addFirebaseEvent(eventName: "invite_click", param: [:])
        Global.addNetcoreEvent(eventname: self.netcoreEvents.inviteClick, param: [:])
        let code = UserModel.getAuthorizedUserInfo()?.referanceCode ?? ""
        //        createReferralCodeLink(code: code)
        callAPIForShortLink(code:code)
        couponLbl.text = code
        lblRewardMessage.text = AppConfig.getAppConfigInfo()?.customMessage?.referralRewardMessage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //addDashBoarder()
        // Ensure the layout is updated before adding the dashed border
        fetchUserProfileV2()
        couponLbl.layoutIfNeeded()
        couponLbl.addDashedBorder()

        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
        DELEGATE.rootVC?.tabBarVc?.showTabBar()
        
        let app = UIApplication.shared
        let appScheme = "whatsapp://app"
        if app.canOpenURL(URL(string: appScheme)!) {
            print("App is install and can be opened")
            self.whtsappBtn.isHidden = false
            self.shareBtn.isHidden = true
        } else {
            print("App in not installed. Go to AppStore")
            self.whtsappBtn.isHidden = true
            self.shareBtn.isHidden = false
        }
        
        //        let code = UserModel.getAuthorizedUserInfo()?.referanceCode ?? ""
        //        createReferralCodeLink(code: code)
    }
    
    func fetchUserProfileV2(){
    //'https://api.woloo.in/api/wolooGuest/profile?id=39120'
    //https://api.woloo.in/api/wolooGuest/profile?id
    
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
    
    let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
            
    NetworkManager(headers: headers, url: nil, service: .userProfile, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<UserProfileModel>, Error>) in
        switch result {
            
        case .success(let response):
            print("User Profile API response: ", response)
            UserDefaultsManager.storeUserData(value: response.results)
            DispatchQueue.main.async {
                self.objUserModel = response.results.profile
                self.couponLbl.text = response.results.profile?.ref_code
            }
    
        case .failure(let error):
            print("User Profile error: ", error)
            
        }
    }
}
    
    @IBAction func termsBtnPressed(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "TermsVC") as? TermsVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func inviteContactPressed(_ sender: UIButton) {
        Global.addFirebaseEvent(eventName: "invite_contact_click", param: [:])
        Global.addNetcoreEvent(eventname: self.netcoreEvents.inviteContactClick, param: [:])
        var settings = KNPickerSettings()
        settings.selectionMode = .multiple
        settings.displayContactsSortedBy = .givenName
        let controller = KNContactsPicker(delegate: self, settings:settings)
        requestAccess { (staus) in
            if staus {
                DispatchQueue.main.async {
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        
        /*let contactPicker = CNContactPickerViewController()
         contactPicker.delegate = self
         contactPicker.displayedPropertyKeys =
         [CNContactPhoneNumbersKey]
         self.present(contactPicker, animated: true, completion: nil) */
    }
    @IBAction func sharePressed(_ sender: UIButton) {
        Global.addFirebaseEvent(eventName: "share_click", param: [:])
        Global.addNetcoreEvent(eventname: self.netcoreEvents.shareClick, param: [:])
       
//        UIApplication.shared.openURL(NSURL(string: "whatsapp://")! as URL)
//        
//        let urlWhats = "whatsapp://send?text=\("Hello World")"
       // if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            //  if let whatsappURL = NSURL(string: urlString) {
//                    if UIApplication.shared.canOpenURL(whatsappURL as URL) {
//                         UIApplication.shared.open(whatsappURL as URL)
//                     }
                    // else {
                         //print("please install watsapp")
                         let name = UserModel.getAuthorizedUserInfo()?.name ?? ""
                        let phone = UserModel.getAuthorizedUserInfo()?.mobile ?? ""
                         let code = UserModel.getAuthorizedUserInfo()?.referanceCode ?? ""
                         var msg = AppConfig.getAppConfigInfo()?.customMessage?.inviteFriendText
                         msg = msg?.replace("{name}", with: name)
                         msg = msg?.replace("{number}", with: phone)
                         msg = msg?.replace("{refcode}", with: code)
                         msg = msg?.replace("{link}", with: shortLink)
                         msg = msg?.replacingOccurrences(of: "\\n", with: "\n")
                         let items = [msg]
                         let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
                         if UIDevice.current.userInterfaceIdiom == .pad {
                             ac.popoverPresentationController?.sourceRect = sender.frame
                         }
                         ac.popoverPresentationController?.sourceView = self.view
                         present(ac, animated: true)
                         //        https://woloo.page.link/Hvdig11o1KkYifDK9
                  //   }
             // }
       // }
       
    }
    
    @IBAction func shareWhatsappPressed(_ sender: UIButton) {
        print("share via whatsapp")
        Global.addNetcoreEvent(eventname: self.netcoreEvents.shareClick, param: [:])
        let name = UserModel.getAuthorizedUserInfo()?.name ?? ""
       let phone = UserModel.getAuthorizedUserInfo()?.mobile ?? ""
        let code = UserModel.getAuthorizedUserInfo()?.referanceCode ?? ""
        var msg = UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.inviteFriendText ?? ""
        msg = msg.replace("{name}", with: name)
        msg = msg.replace("{number}", with: phone)
        msg = msg.replace("{refcode}", with: code)
        msg = msg.replace("{link}", with: shortLink)
        msg = msg.replacingOccurrences(of: "\\n", with: "\n")
        let items = msg
        /*"Your friend Digitalflake Kapil 8999153610 has gifted you a Month’s Membership of Woloo as a gesture of care & concern for you. \n\n Woloo App empowers women with their Hygiene Dignity by helping them locate nearest clean, safe & hygienic washrooms. The App also enables purchase of Feminine products from a uniquely curated brand mix. \n\n Go Bindass! \n #WolooHaiNa \n\n Download App -\n https://woloo.page.link/Gk3N6bkfM78qXZ4r5 \n - LOOM & WEAVER RETAIL\n\n\n\n " */
        print("items: ",items)
        let urlWhats = "whatsapp://send?text=\(items ?? "")"
               if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                   if let whatsappURL = URL(string: urlString) {
                       if UIApplication.shared.canOpenURL(whatsappURL){
                           if #available(iOS 10.0, *) {
                               UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                           } else {
                               UIApplication.shared.openURL(whatsappURL)
                           }
                       }
                       else {
                           print("Install Whatsapp")
                       }
                   }
               }
    }
    
    
    func addDashBoarder()  {
        if UIDevice.current.userInterfaceIdiom == .pad {
            couponLbl.layer.borderColor = UIColor.main.cgColor
            couponLbl.layer.borderWidth = 1
            return
        }
        let lblBorder = CAShapeLayer()
        lblBorder.strokeColor = #colorLiteral(red: 0.9960784314, green: 0.9294117647, blue: 0.0431372549, alpha: 1).cgColor
        lblBorder.lineDashPattern = [6, 2]
        lblBorder.frame = couponLbl.bounds
        lblBorder.fillColor = nil
        lblBorder.path = UIBezierPath(rect: couponLbl.bounds).cgPath
        couponLbl.layer.addSublayer(lblBorder)
    }
}

/*extension InviteFriendVC : CNContactPickerDelegate {
 func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
 //        for contact in contacts {
 //            let phoneNumber = contact.value(forKey:CNContactPhoneNumbersKey)
 //            let p = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
 //            print(contact.givenName)
 //            print(phoneNumber)
 //        }
 if contacts.count > 0 {
 self.performSegue(withIdentifier: "InviteMessageSegue", sender: contacts)
 }
 }
 func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
 print(contact)
 }
 } */

// MARK: - Navigation
extension InviteFriendVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InviteMessageSegue" {
            if let vc = segue.destination as? InviteMessageVC {
                vc.contacts = sender as? [CNContact] ?? [CNContact]()
                vc.shortLink = shortLink
            }
        }
    }
}

// MARK: - CreateDynamic Link
extension InviteFriendVC {
    func callAPIForShortLink(code:String){
        Global.showIndicator()
        let url = URL(string: "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyDyJDAP9AhZDNDvFxB82N816xjWG9Lmji0")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "longDynamicLink":  "https://woloo.page.link/?link=\(AppConfig.getAppConfigInfo()?.urls?.appShareURL ?? "")/?referral_code=\(code)?apn=in.woloo.www&amv=1.0&ibi=in.woloo.app&isi=1571476207&ius=woloo.page.link"
        ]
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            Global.hideIndicator()
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    if let link = json["shortLink"] as? String {
                        self.shortLink = link
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            //            let responseString = String(data: data, encoding: .utf8)
            //            print("responseString = \(responseString)")
            
            
            
        }
        
        task.resume()
    }
    func createReferralCodeLink(code: String) { // URL(string: "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyAnqhrBVa89ey6O8b6xGvlx2UOmD6Np6Go")
        guard let link = URL(string: "\(AppConfig.getAppConfigInfo()?.urls?.appShareURL ?? "")/?referral_code=\(code)") else { return }
        let dynamicLinksDomainURIPrefix = "https://woloo.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: Bundle.main.bundleIdentifier ?? "in.woloo.app")
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "in.woloo.www")
        linkBuilder?.options = DynamicLinkComponentsOptions()
        linkBuilder?.options?.pathLength = .unguessable
        
        guard let longDynamicLink = linkBuilder?.url else { return }
        //        self.shortLink = longDynamicLink.absoluteString
        //        return
        
        linkBuilder?.shorten() { url, warnings, error in
            guard let url = url, error != nil else { return }
            print("The short URL is: \(url)")
        }
        
        Global.showIndicator()
        DynamicLinks.dynamicLinks().dynamicLink(fromUniversalLink: longDynamicLink, completion: { (dynamicLink, error) in
            Global.hideIndicator()
            if let link = dynamicLink?.url {
                if DynamicLinks.dynamicLinks().matchesShortLinkFormat(link) {
                    self.shortLink = link.absoluteString
                }
            }
        })
        
    }
}
extension InviteFriendVC: KNContactPickingDelegate {
    func contactPicker(didFailPicking error: Error) {
        print(error)
    }
    func contactPicker(didCancel error: Error) {
        print(error)
    }
    func contactPicker(didSelect contact: CNContact) {
        self.performSegue(withIdentifier: "InviteMessageSegue", sender: [contact])
    }
    
    func contactPicker(didSelect contacts: [CNContact]) {
        if contacts.count > 0 {
            self.performSegue(withIdentifier: "InviteMessageSegue", sender: contacts)
        }
    }
}

// MARK: - Contact Permission
extension InviteFriendVC {
    private func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Go to Settings to grant access.", preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
                completionHandler(false)
                UIApplication.shared.open(settings)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
}
extension UIView {
    func addDashedBorder() {
        let color = UIColor.yellow.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 3]
        shapeLayer.fillColor = UIColor.clear.cgColor

        // Ensure the layout is updated before setting the path
        self.layoutIfNeeded()

        let frameSize = self.bounds.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        
        // Remove any existing dashed border before adding a new one
        self.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        
        self.layer.addSublayer(shapeLayer)
    }
}
