//
//  InviteMessageVC.swift
//  Woloo
//
//  Created on 27/04/21.
//

import UIKit
import ContactsUI
import Firebase

class InviteMessageVC: UIViewController {
    
    
    @IBOutlet weak var msgTxtVw: UITextView!
    var contacts = [CNContact]()
    var shortLink = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Name: ", UserDefaultsManager.fetchUserData()?.profile?.name ?? "")
        
        let name = UserDefaultsManager.fetchUserData()?.profile?.name ?? ""
        let phone = UserDefaultsManager.fetchUserData()?.profile?.mobile ?? 0
        let code = UserDefaultsManager.fetchUserData()?.profile?.ref_code ?? ""
        
        msgTxtVw.text = "\(name) (\(phone)) has gifted you a Month’s Membership of Woloo as a gesture of care & concern for you.\nWoloo App empowers women with their Hygiene Dignity by helping them locate nearest clean, safe & hygienic washrooms. The App also enables purchase of Feminine products from a uniquely curated brand mix.\n\nUse Referral Code: \(code) during your Sign-Up process & avail one month free membership.\n\nGo Bindass!\n#WolooHaiNa\n\nDownload App -\n\(shortLink)\n- LOOM & WEAVER RETAIL"
        
        var msg = UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.inviteFriendText ?? ""
        msg = msg.replace("{name}", with: name)
        msg = msg.replace("{number}", with: String(phone))
        msg = msg.replace("{refcode}", with: code)
        msg = msg.replace("{link}", with: shortLink)
        msg = msg.replacingOccurrences(of: "\\n", with: "\n")
        msgTxtVw.text = msg
        
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func backSubmitPressed(_ sender: UIButton) {
        var numbers = [String]()
        for contact in contacts {
//            let phoneNumber = contact.value(forKey:CNContactPhoneNumbersKey)
            let p = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String ?? ""
            if p.count > 0 {
                numbers.append(p)
            }
        }
        var param = [String:Any]()
        param["mobile_numbers"] = [numbers.joined(separator: ",")]
        param["message"] = msgTxtVw.text
        param["shareUrl"] = shortLink
        //sendMessageAPI(param: param)
        sendMessageAPIV2(param: param)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//API
extension InviteMessageVC {
    func sendMessageAPI(param:[String:Any]) {
        APIManager.shared.inviteFriends(param: param) { (isSuccess, message) in
//            self.showToast(message: message)
            if isSuccess{
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Close", title: "", message: message, image: nil, controller: self)
                    alert.cancelTappedAction = {
                        alert.removeFromSuperview()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                }
            }
        }
    }
    
    func sendMessageAPIV2(param:[String:Any]) {
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: param, headers: headers, url: nil, service: .invite, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<InviteModel>, Error>) in
            switch result {
                
            case .success(let response):
                print("invite User Response: \(response)")
                self.showToast(message: response.results.MESSAGE ?? "")
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                self.showToast(message: error.localizedDescription)
                print("Invite user failure: \(error)")
                
            }
        }
        
    }
}
