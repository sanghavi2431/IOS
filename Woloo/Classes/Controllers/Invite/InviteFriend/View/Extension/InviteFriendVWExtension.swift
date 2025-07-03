//
//  InviteFriendVWExtension.swift
//  Woloo
//
//  Created by CEPL on 13/02/25.
//

import Foundation
import KNContactsPicker
import UIKit

extension InviteFriendVC: UITableViewDelegate, UITableViewDataSource, InviteContactButtonCellDelegate{
    
    //MARK: - InviteContactButtonCellDelegate
    func didClickeBtnInviteContact() {
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
    
    func didClickeBtnWhatsApp() {
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
        return 5
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
            return UITableViewCell()
        }
    }
    
    
    
    
}
