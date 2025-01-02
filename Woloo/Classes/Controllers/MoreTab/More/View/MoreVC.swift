//
//  MoreTabVC.swift
//  Woloo
//
//  Created by Vivek shinde on 18/12/20.
//

import UIKit
import Smartech
import MessageUI

enum MoreSectionType: String, CaseIterable {
    case Profile
    case Invite
    case Notification
    case MyCart
    case OffersAndPromotion
    case InviteAFriend
    case MyAccount
    case MyOffer
    case WolooGiftCard
    case BuySubscription
    case MyHistory
    case BecomeAWolooHost
    case ReferAWolooHost
    case AddReview
    case TermsOfUse
    case Unsubscribe
    case Delete
    case About
    case logout
    
    var title: String {
        switch self {
        case .Profile:
            return "Profile"
        case .Invite:
            return "Invite"
        case .Notification:
            return "Notification"
        case .MyCart:
            return "My Cart"
        case .OffersAndPromotion:
            return "OFFERS & PROMOTION"
        case .InviteAFriend:
            return "Invite A Friend"
        case .MyAccount:
            return "My Account"
        case .MyOffer:
            return "Offer Cart"
       case .WolooGiftCard:
            return "Woloo Gift-Card"
        case .BuySubscription:
            return "Buy Peer's club membership"
        case .MyHistory:
            return "My History"
        case .BecomeAWolooHost:
            return "Become A Woloo Host"
        case .ReferAWolooHost:
            return "Refer A Woloo Host"
        case .AddReview:
            return "Add Review"
        case .TermsOfUse:
            return "Terms Of Use"
        case .Unsubscribe:
            return "Discontinue Membership"
        case .Delete:
            return "Delete Your Account"
        case .About:
            return "About"
        case .logout:
            return "Logout"
        
        }
    }
    
    var imageName: String {
        switch self {
        case .Profile:
            return "Profile"
        case .Invite:
            return "ic_Invite"
        case .Notification:
            return "ic_notification"
        case .MyCart:
            return "ic_my_cart"
        case .OffersAndPromotion:
            return "ic_offer"
        case .InviteAFriend:
            return "ic_Invite"
        case .MyAccount:
            return "ic_account"
        case .MyOffer:
            return "ic_account"
       case .WolooGiftCard:
            return "Gift Card"
        case .BuySubscription:
            return "ic_buy_subscription"
        case .MyHistory:
            return "history"
        case .BecomeAWolooHost:
            return "ic_w_host"
        case .ReferAWolooHost:
            return "ic_referHost"
        case .AddReview:
            return "Gift Card"
        case .TermsOfUse:
            return "TermsOfUse"
        case .Unsubscribe:
            return "Discontinue"
        case .Delete:
            return "Discontinue"
        case .About:
            return "about"
        case .logout:
            return "logout"
        
        }
    }
}

class MoreVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var moreDetail: MoreTabDetail?
    var moreDetailV2: MoreTabDetailV2?
    
    var netcoreEvents = NetcoreEvents()
    var objDashboardViewModel = DashboardViewModel()
    var objUser = UserProfileModel()
    var objMoreViewModel = MoreViewModel()
    
    var otherTabList : [MoreSectionType] = [.Profile,
                                            .BuySubscription,
                                            .MyHistory,
                                            .MyOffer,
                                            .WolooGiftCard,
                                            .BecomeAWolooHost,
                                            .ReferAWolooHost,
                                            .Unsubscribe,.Delete,
                                            .About,
                                            .TermsOfUse,
                                            .logout]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objMoreViewModel.delegate = self
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Global.addFirebaseEvent(eventName: "more_search_click", param: [:])
        self.objDashboardViewModel.delegate = self
        Global.showIndicator()
        self.objDashboardViewModel.getUserProfileAPI()
        //getProfile()
        DELEGATE.rootVC?.tabBarVc?.showTabBar()
        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
    }
    
    func updateProfileData() {
        self.tableView.reloadData()
//        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        
    }
    
    func setup() {
        let v1 = Bundle.main.releaseVersionNumber ?? ""
        let b1 = Bundle.main.buildVersionNumber ?? ""
        lblVersion.text = "Version \(v1)(\(b1))"
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.register(MoreSectionCell.nib, forCellReuseIdentifier: MoreSectionCell.identifier)
        
        if let user = UserModel.getAuthorizedUserInfo() {
            self.moreDetail?.userData = user
            if let gid = user.giftSubscriptionId, gid > 0 {
            
                otherTabList = [.Profile,
                                .BuySubscription,
                                .MyHistory,
                                .MyOffer,
                                .WolooGiftCard,
                                .BecomeAWolooHost,
                                .ReferAWolooHost,
                                .About,
                                .TermsOfUse,
                                .logout,.Delete]
                
                
            } else {
                otherTabList = [.Profile,
                                .BuySubscription,
                                .MyHistory,
                                .MyOffer,
                                .WolooGiftCard,
                                .BecomeAWolooHost,
                                .ReferAWolooHost,
                                .Unsubscribe,
                                .About,
                                .TermsOfUse,
                                .logout, .Delete]
            }
           
            updateProfileData()
        }
    }
    func showAlert(message: String, cancelText: String) {
        DispatchQueue.main.async {
            let alert = WolooAlert(frame: self.view.frame, cancelButtonText: cancelText, title: nil, message: message, image: nil, controller: self)
            alert.cancelTappedAction = {
                alert.removeFromSuperview()
            }
            self.view.addSubview(alert)
            self.view.bringSubviewToFront(alert)
        }
    }
}

// MARK: -
extension MoreVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return otherTabList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
            //cell.configureUI(moreDetail)
            cell.configureUIV2(moreDetailV2)
            
            cell.handlePrimiumClickEvent = { [weak self] in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "SubscriptionVC", sender: true)     
            }
            
            cell.editProfileClickEvent = { [weak self] () in
                guard let self = self else { return }
                
               // self.performSegue(withIdentifier: Segues.editProfile, sender: nil)
                let vc = (UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController)!
                vc.userDataV2 = self.objUser
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.editProfilePicClickEvent = { [weak self] () in
                guard let self = self else { return }
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.allowsEditing = true
                pickerController.mediaTypes = ["public.image"]
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        
            return cell
        } /*else if indexPath.section == 1 {
         let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath)
         return cell
         }*/ else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MoreSectionCell.identifier, for: indexPath) as! MoreSectionCell
            cell.sectionType = otherTabList[indexPath.section]
            return cell
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch otherTabList[indexPath.section] {
        
        case .Notification:
            break;
        case .MyCart:
            break;
        case .OffersAndPromotion:
            break;
        case .BecomeAWolooHost:
            Global.addFirebaseEvent(eventName: "become_host_click", param: [:])
            Global.addNetcoreEvent(eventname: self.netcoreEvents.becomeHostClick, param: [:])
            
            self.performSegue(withIdentifier: "BecomeHostVC", sender: nil)
            break;
        case .ReferAWolooHost:
            Global.addFirebaseEvent(eventName: "refer_host_click", param: [:])
            Global.addNetcoreEvent(eventname: self.netcoreEvents.referHostClick, param: [:])
            self.performSegue(withIdentifier: "ReferHostVC", sender: true)
            break;
        case .TermsOfUse:
            Global.addFirebaseEvent(eventName: "terms_click", param: [:])
            Global.addNetcoreEvent(eventname: self.netcoreEvents.termsClick, param: [:])
            self.performSegue(withIdentifier: "TermsVC", sender: nil)
            break;
        case .MyHistory:
            Global.addFirebaseEvent(eventName: "my_history_click", param: [:])
            Global.addNetcoreEvent(eventname: self.netcoreEvents.myHistoryClick, param: [:])
            self.performSegue(withIdentifier: "HistoryVC", sender: nil)
            break;
        case .About:
            Global.addFirebaseEvent(eventName: "about_click", param: [:])
            Global.addNetcoreEvent(eventname: self.netcoreEvents.aboutClick, param: [:])
            self.performSegue(withIdentifier: "AboutVC", sender: nil)
            break;
        case .InviteAFriend:
            self.performSegue(withIdentifier: "InviteFriendsVC", sender: nil)
            break;
        case .MyAccount:
            self.performSegue(withIdentifier: "MyAccountVC", sender: nil)
            break;
        case .MyOffer:
            self.performSegue(withIdentifier: "MyOfferVC", sender: nil)
            break;
        case .AddReview:
            self.performSegue(withIdentifier: "ReviewVC", sender: nil)
            break;
        case .BuySubscription:
            Global.addFirebaseEvent(eventName: "upgrade_click", param: ["current_membership_id":UserModel.user?.subscriptionId ?? "0"])
            
            Global.addNetcoreEvent(eventname: self.netcoreEvents.upgradeClick, param: ["current_membership_id":UserModel.user?.subscriptionId ?? "0"])
            self.performSegue(withIdentifier: "SubscriptionVC", sender: nil)
            break;
        case .Unsubscribe:
            Global.addFirebaseEvent(eventName: "discontinue_click", param: [:])
            Global.addNetcoreEvent(eventname: self.netcoreEvents.discontinueClick, param: [:])
            if (moreDetail?.subscriptionData?.name?.lowercased() ?? "") == "free trial" || moreDetail?.subscriptionData == nil {
                showAlert(message: "You don't have an active membership", cancelText: "Close")
            } else if moreDetail?.subscriptionData?.isCancel == true {
                showAlert(message: "You have already Unsubscribe the membership", cancelText: "Close")
            } else {
                self.performSegue(withIdentifier: "SubscriptionVC", sender: "unsubscribe")
            }
            break
        case .WolooGiftCard:
            Global.addFirebaseEvent(eventName: "woloo_gift_card_click", param: [:])
            Global.addNetcoreEvent(eventname: self.netcoreEvents.wolooGiftCardClick, param: [:])
            self.performSegue(withIdentifier: "AddGiftCardVC", sender: nil)
            break;
        case .logout:
            Global.showOkCancelAlertMessage(title: "Confirm", message: AppConfig.getAppConfigInfo()?.customMessage?.logoutDialog ?? "") { (isOK, isCancel) in
                if isOK {
                    Global.addFirebaseEvent(eventName: "logout_click", param: [:])
                    Global.addNetcoreEvent(eventname: self.netcoreEvents.userLogoutSuccess, param: [:])
                    Global.addNetcoreEvent(eventname: self.netcoreEvents.logoutClick, param: [:])
                    Hansel.getUser()?.clear()
                    UserDefaultsManager.isUserloggedInStatusSave(value: false)
                    UserModel.setUserLoggedInStatus(status: false)
                    UserDefaults.userTransportMode = nil
                    UserModel.resetUserData()
                    UserDefaults.standard.resetDefaults()
                    UserDefaults.tutorialScreen = true
                    Global.shared.launchAuthBoard()
                    //Delay to call system event of netcore
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                        Smartech.sharedInstance().logoutAndClearUserIdentity(true)
//                        Smartech.sharedInstance().trackEvent("User_logout_success", andPayload: ["":""])
                        
                    }
                    //Smartech.sharedInstance().trackEvent("User_logout_success", andPayload: ["":""])
                    //have to add the delay of one second
                    
                    
                }
            }
        case .Delete:
            Global.showOkCancelAlertMessage(title: "Delete Account", message: "Are you sure you want to delete your account? This will permanently erase your account. It will take around 48 hrs to delete your data") { (isOK, isCancel) in
                if isOK {
                   // self.contactUsToEmail()
                    
                    //Delay to call system event of netcore
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        Global.addFirebaseEvent(eventName: "logout_click", param: [:])
                        Global.addNetcoreEvent(eventname: self.netcoreEvents.userLogoutSuccess, param: [:])
                        Global.addNetcoreEvent(eventname: self.netcoreEvents.logoutClick, param: [:])
                        Hansel.getUser()?.clear()
                        UserDefaultsManager.isUserloggedInStatusSave(value: false)
                        UserModel.setUserLoggedInStatus(status: false)
                        UserDefaults.userTransportMode = nil
                        UserModel.resetUserData()
                        UserDefaults.standard.resetDefaults()
                        UserDefaults.tutorialScreen = true
                        Global.shared.launchAuthBoard()
                        Smartech.sharedInstance().logoutAndClearUserIdentity(true)
                        //                        Smartech.sharedInstance().trackEvent("User_logout_success", andPayload: ["":""])
                        
                    }
                    //Smartech.sharedInstance().trackEvent("User_logout_success", andPayload: ["":""])
                    //have to add the delay of one second
                    
                    
                }
            }

        default:
            break
        }
    }
    func contactUsToEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        self.showToast(message: "Your device could not send e-mail.")
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let mailComposerVC = MFMailComposeViewController()
        let supportEmailUrl = AppConfig.getAppConfigInfo()?.supportEmail?.key ?? ""
        print("Support URL ->", supportEmailUrl)
//        let subject = txtReasonToCancel.text ?? ""
//        print("subject ->", subject)
//        let message = txtCommentsToCancel.text ?? ""
//        print("message ->", message)
        
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([supportEmailUrl])
      //  mailComposerVC.setSubject(subject)
    
        //let messageText = "\(message)"
        
        //mailComposerVC.setMessageBody(messageText, isHTML: true)
        
        return mailComposerVC
    }
}

// MARK: - Navigation
extension MoreVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.editProfile {
            if let vc = segue.destination as? EditProfileViewController {
                vc.userData = self.moreDetail?.userData
            }
        } else if segue.identifier == Segues.subscriptionVC {
            if let vc = segue.destination as? BuySubscriptionVC {
                vc.objUser = self.objUser
                if let isUnsubscribe = sender as? String, isUnsubscribe == "unsubscribe" {
                    vc.showUnsubscribe = true
                    //isCancel not used now
                    if let isCancel = self.moreDetail?.subscriptionData?.isCancel {
                        vc.isAlreadyUnsubscribed = isCancel//userModel?.planData?.isCancel
                    }
                } else if let isMyPlan = sender as? Bool, isMyPlan {
                    vc.isMyPlan = isMyPlan
                }
            }
        }
    }
}

// MARK: - API
extension MoreVC: DashboardViewModelDelegate , MoreViewModelDelegate{
    //MARK: - MoreViewModelDelegate
    
    
    func didReceiveUploadProfilePhotoResponse(objResponse: BaseResponse<Profile>) {
        Global.hideIndicator()
        self.objDashboardViewModel.getUserProfileAPI()
    }
    
    func didUploadProfilePhotoError(strError: String) {
        Global.hideIndicator()
    }
    
    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>) {
        //
    }
    
    func didReceiceWahCertificateError(strError: String) {
        //
    }
    
   
    //    func getUserMoreProfile() {
    //        UserModel.apiMoreProfileDetails { (profileMoreResponse) in
    //            return
    //        }
    //    }
    //MARK: - DashboardViewModelDelegate
    func didReceievGetUserProfile(objResponse: BaseResponse<UserProfileModel>) {
        Global.hideIndicator()
        UserDefaultsManager.storeUserData(value: objResponse.results)
        if self.moreDetailV2 == nil {
            self.moreDetailV2 = MoreTabDetailV2()
        }
        objUser = objResponse.results
        self.moreDetailV2?.userData = objUser.profile
        self.moreDetailV2?.userCoin = objUser.totalCoins
        self.moreDetailV2?.subscriptionData = objUser.planData
        self.updateProfileData()
        
    }
    
    func didReceievGetUserProfileError(strError: String) {
        Global.hideIndicator()
    }
    
    
    
    func getProfile() {
        UserModel.apiMoreProfileDetails { (userModel) in
            DispatchQueue.main.async {
                if self.moreDetail == nil {
                    self.moreDetail = MoreTabDetail()
                }
                //                UserModel.saveAuthorizedUserInfo(userModel?.userData)
                self.moreDetail?.userData = userModel?.userData
                self.moreDetail?.userCoin = userModel?.totalCoins
                self.moreDetail?.subscriptionData = userModel?.planData
                self.updateProfileData()
            }
        }
    }
}

extension MoreVC: UIImagePickerControllerDelegate,
                  UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                Global.showOkCancelAlertMessage(title: "Confirm", message:"Are you sure you want to change picture?") { (isOK, isCancel) in
                    if isOK {
                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileCell {
                            print("picked image")
                            cell.profileImageView.image = pickedImage
                            
                            Global.showIndicator()
                            self.objMoreViewModel.uploadProfileImage(profileImage: pickedImage)
                            
//                            APIManager.shared.imageFileUpload(param: ["type":"userProfile"], image: pickedImage){(response, message) in
//                                // print(response)
//                                if let res = response {
//                                    let param = ["filenames": res.convertedName,"path": res.path]
//                                    APIManager.shared.postEditProfileData(param: param as [String : Any]) { (usermodel, message) in
//                                        //print(usermodel)
//                                    }
//                                }
//                            }
                            
                            DispatchQueue.main.async {
                                //                                    if self.moreDetail == nil {
                                //                                        self.moreDetail = MoreTabDetail()
                                //                                    }
                                //                                    self.moreDetail?.userCoin = result
                                //                                    self.updateProfileData()
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
