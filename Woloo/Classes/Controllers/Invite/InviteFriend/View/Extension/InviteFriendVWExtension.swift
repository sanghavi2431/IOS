//
//  InviteFriendVWExtension.swift
//  Woloo
//
//  Created by CEPL on 13/02/25.
//

import Foundation
//import KNContactsPicker
import UIKit
import FirebaseDynamicLinks

extension InviteFriendVC: UITableViewDelegate, UITableViewDataSource, InviteContactButtonCellDelegate{
    
    //MARK: - InviteContactButtonCellDelegate
    func didClickeBtnInviteContact() {
        Global.addFirebaseEvent(eventName: "invite_contact_click", param: [:])
        Global.addNetcoreEvent(eventname: self.netcoreEvents.inviteContactClick, param: [:])
//        FSCalendar
        
        /*let contactPicker = CNContactPickerViewController()
         contactPicker.delegate = self
         contactPicker.displayedPropertyKeys =
         [CNContactPhoneNumbersKey]
         self.present(contactPicker, animated: true, completion: nil) */

    }
    
    func didClickeBtnWhatsApp() {
        print("share via whatsapp")
        
        // Netcore event
        Global.addNetcoreEvent(eventname: self.netcoreEvents.shareClick, param: [:])
        
        let name = UserDefaultsManager.fetchUserData()?.profile?.name ?? ""
        let phone = String(UserDefaultsManager.fetchUserData()?.profile?.mobile ?? 0)
        let code = UserDefaultsManager.fetchUserData()?.profile?.ref_code ?? ""
        
        // Generate the dynamic link
        createDynamicLink(referralCode: code) { shortURL in
            guard let link = shortURL else { return }
            
            // Prepare message
            var msg = UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.inviteFriendText ?? ""
            msg = msg.replace("{name}", with: name)
            msg = msg.replace("{number}", with: phone)
            msg = msg.replace("{refcode}", with: code)
            msg = msg.replace("{link}", with: link.absoluteString)
            msg = msg.replacingOccurrences(of: "\\n", with: "\n")
            
            // Share via WhatsApp
            let urlWhats = "whatsapp://send?text=\(msg)"
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                } else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    func createDynamicLink(referralCode: String, completion: @escaping (URL?) -> Void) {
        let deepLink = "https://www.woloo.in/referral?code=\(referralCode)"
        guard let link = URL(string: deepLink) else { completion(nil); return }

        let dynamicLink = DynamicLinkComponents(link: link, domainURIPrefix: "https://woloo.page.link")
        dynamicLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: "in.woloo.app")
        dynamicLink?.iOSParameters?.appStoreID = "1571476207"
        dynamicLink?.androidParameters = DynamicLinkAndroidParameters(packageName: "in.woloo.www")
        
        dynamicLink?.shorten { shortURL, warnings, error in
            if let error = error {
                print("Error generating short link: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(shortURL)
            }
        }
    }


    
    func didClickeBtnShare() {
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
                        let phone = String(UserDefaultsManager.fetchUserData()?.profile?.mobile ?? 0)
                         let code = UserModel.getAuthorizedUserInfo()?.referanceCode ?? ""
                    var msg = UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.inviteFriendText ?? ""
                         msg = msg.replace("{name}", with: name)
                         msg = msg.replace("{number}", with: phone)
                         msg = msg.replace("{refcode}", with: code)
                         msg = msg.replace("{link}", with: shortLink)
                         msg = msg.replacingOccurrences(of: "\\n", with: "\n")
                         let items = [msg]
                         let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
                         if UIDevice.current.userInterfaceIdiom == .pad {
                             //ac.popoverPresentationController?.sourceRect = sender.frame
                         }
                         ac.popoverPresentationController?.sourceView = self.view
                         present(ac, animated: true)
                         //        https://woloo.page.link/Hvdig11o1KkYifDK9
                  //   }
             // }
       // }

    }
    
  
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell: InviteFriendHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "InviteFriendHeaderCell") as! InviteFriendHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("InviteFriendHeaderCell", owner: self, options: nil)?.last as? InviteFriendHeaderCell)
            }

            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 1 {
            var cell: InviteFriendImageCell? = tableView.dequeueReusableCell(withIdentifier: "InviteFriendImageCell") as! InviteFriendImageCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("InviteFriendImageCell", owner: self, options: nil)?.last as? InviteFriendImageCell)
            }

            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 2 {
            var cell: InviteFriendUniqueCodeCell? = tableView.dequeueReusableCell(withIdentifier: "InviteFriendUniqueCodeCell") as! InviteFriendUniqueCodeCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("InviteFriendUniqueCodeCell", owner: self, options: nil)?.last as? InviteFriendUniqueCodeCell)
            }

            cell?.configureInviteFriendUniqueCodeCell(strUniqueCode: self.strUniqueCode ?? "")
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 3 {
            var cell: InviteFriendTermsCell? = tableView.dequeueReusableCell(withIdentifier: "InviteFriendTermsCell") as! InviteFriendTermsCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("InviteFriendTermsCell", owner: self, options: nil)?.last as? InviteFriendTermsCell)
            }

            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 4 {
            var cell: InviteContactButtonCell? = tableView.dequeueReusableCell(withIdentifier: "InviteContactButtonCell") as! InviteContactButtonCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("InviteContactButtonCell", owner: self, options: nil)?.last as? InviteContactButtonCell)
            }

            cell?.delegate = self
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else{
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
          
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
    }
}
