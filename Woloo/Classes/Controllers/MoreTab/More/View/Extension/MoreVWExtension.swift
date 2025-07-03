////
////  MoreVWExtension.swift
////  Woloo
////
////  Created by Kapil Dongre on 24/10/24.
////
//
import Foundation
import UIKit
import Smartech
import STPopup

extension MoreVC: UITableViewDelegate, UITableViewDataSource, DashboardViewModelDelegate, MoreViewModelDelegate, MoreGridTableCellProtocol, LogOutBtnCellProtocol, EditThirstReminderPopUpDelegate, SetThirstReminderPopUpDelegate, EditCycleViewModelDelegate, EditPeriodTrackerPopUpDelegate, LogOutPopUpVCDelegate{
    
    //MARK: LogOutPopUpVCDelegate
    func didSelectLogOutYes() {
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

    }
    
    
    
    
    //MARK: - EditPeriodTrackerPopUpDelegate
    func didUpdatePeriodTracker(objViewPeriodTrackerModel: ViewPeriodTrackerModel?) {
        Global.showIndicator()
        self.objPeriodTrackerViewModel.setPeriodTracker(objPeriodTracker: objViewPeriodTrackerModel ?? ViewPeriodTrackerModel())
    }
    
    
    //MARK: - API call edit period cycle
    func didReceivePeriodTrackerResponse(objResponse: BaseResponse<ViewPeriodTrackerModel>) {
        Global.hideIndicator()
        self.openTrackerVC()
    }
    
    func didReceievPeriodTrackerError(strError: String) {
        Global.hideIndicator()
    }
    
    
    
    //MARK: - SetThirstReminderPopUpDelegate
    func didSelectMinutes(minutes: String?) {
        self.setFrequency = minutes ?? ""
        self.thirstReminderYesV2()
    }
    
    
    //MARK: - EditThirstReminderPopUpDelegate
    func setThirstReminder() {
        DispatchQueue.main.async{
            let objController = SetThirstReminderPopUpVC(nibName: "SetThirstReminderPopUpVC", bundle: nil)
            objController.delegate = self
            let popup = STPopupController(rootViewController: objController)
            popup.present(in: self)
        }
    }
    
    
    //MARK: - LogOutBtnCellProtocol
    func didSelectLogOutBtn() {

        let objController = LogOutPopUpVC.init(nibName: "LogOutPopUpVC", bundle: nil)
             objController.delegate = self
        let popup = STPopupController.init(rootViewController: objController)
        popup.present(in: self)
    }
    
    
    //MARK: - MoreGridTableCellProtocol
    func didClickedPeriodManagement() {
//        let vc = UIStoryboard.init(name: "Tracker", bundle: Bundle.main).instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController
        
//        self.navigationController?.pushViewController(vc!, animated: true)
//
        
        if self.openViewCycle == true{
            self.openTrackerVC()
        }
        else{
            let objController = EditPeriodTrackerPopUp.init(nibName: "EditPeriodTrackerPopUp", bundle: nil)
            objController.delegate = self
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
        }
    }
    
    func didClickedThirstReminder() {
        let objController = EditThirstReminderPopUpVC.init(nibName: "EditThirstReminderPopUpVC", bundle: nil)
        objController.delegate = self
        let popup = STPopupController.init(rootViewController: objController)
        popup.present(in: self)
        
    }
    
    func didClickedSayItWoloo() {
        let objController = SayItWithWolooVC.init(nibName: "SayItWithWolooVC", bundle: nil)
       
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    func didClickedPeersClubMembership() {

        let viewController = UIStoryboard(name: "Subscription", bundle: .main).instantiateViewController(withIdentifier: "BuySubscriptionVC") as! BuySubscriptionVC
       
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didClickedRefer() {
        let vc = UIStoryboard.init(name: "InviteFriend", bundle: Bundle.main).instantiateViewController(withIdentifier: "InviteFriendVC") as? InviteFriendVC
      
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func didClickedMyHistory() {
        self.performSegue(withIdentifier: "HistoryVC", sender: nil)
    }
    
    func didClickedOfferCart() {
        self.performSegue(withIdentifier: "MyOfferVC", sender: nil)
    }
    
    func didClickedWolooGiftCard() {
        self.performSegue(withIdentifier: "AddGiftCardVC", sender: nil)
    }
    
    func didClickedBecomeAWolooHost() {
        self.performSegue(withIdentifier: "BecomeHostVC", sender: nil)
    }
    
    func didClickedReferAWolooHost() {
        self.performSegue(withIdentifier: "ReferHostVC", sender: true)
    }
    
    func didClickedAbout() {
        self.performSegue(withIdentifier: "AboutVC", sender: nil)
    }
    
    func didClickedTermsOfUse() {
        self.performSegue(withIdentifier: "TermsVC", sender: nil)
    }
    
    
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
    
    //MARK: - UITableViewDelegate & UITableViewDelegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0{
//            var cell: HeaderProfileCell? = tableView.dequeueReusableCell(withIdentifier: "HeaderProfileCell") as! HeaderProfileCell?
//            
//            if cell == nil{
//                cell = (Bundle.main.loadNibNamed("HeaderProfileCell", owner: self, options: nil)?.last as? HeaderProfileCell)
//            }
//            
//           
//            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
//        return cell!
//        }
        if indexPath.section == 0{
            var cell: UserProfileTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "UserProfileTableViewCell") as! UserProfileTableViewCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("UserProfileTableViewCell", owner: self, options: nil)?.last as? UserProfileTableViewCell)
            }
            
            cell?.editProfileClickEvent = { [weak self] () in
                guard let self = self else { return }
                
               // self.performSegue(withIdentifier: Segues.editProfile, sender: nil)
                let vc = (UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController)!
                vc.userDataV2 = self.objUser
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell?.editProfilePicClickEvent = { [weak self] () in
                guard let self = self else { return }
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.allowsEditing = true
                pickerController.mediaTypes = ["public.image"]
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
            
            cell?.openAccountClickEvent = { [weak self] () in
                guard let self = self else { return }
                
               // self.performSegue(withIdentifier: Segues.editProfile, sender: nil)
                let vc = (UIStoryboard.init(name: "MyAccount", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountVC)!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if let selectedImage = selectedProfileImage {
                    cell?.updateProfileImage(image: selectedImage)
                }
            cell?.configureUserProfileTableViewCell(objUser: self.moreDetailV2)
            
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
        
        else if indexPath.section == 1{
            var cell: MoreGridTableCell? = tableView.dequeueReusableCell(withIdentifier: "MoreGridTableCell") as! MoreGridTableCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("MoreGridTableCell", owner: self, options: nil)?.last as? MoreGridTableCell)
            }
            cell?.delegate = self
            
           
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
        
      else if indexPath.section == 2{
            var cell: LogOutBtnCell? = tableView.dequeueReusableCell(withIdentifier: "LogOutBtnCell") as! LogOutBtnCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("LogOutBtnCell", owner: self, options: nil)?.last as? LogOutBtnCell)
            }
            cell?.delegate = self
            
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
        else{
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
            
            cell?.selectionStyle = UITableViewCell .SelectionStyle.none
        return cell!
        }
        
        //
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
        }
        else{
            
            if indexPath.row == 0{
                //Buy peer's club membership
                Global.addFirebaseEvent(eventName: "upgrade_click", param: ["current_membership_id":UserModel.user?.subscriptionId ?? "0"])
                
                Global.addNetcoreEvent(eventname: self.netcoreEvents.upgradeClick, param: ["current_membership_id":UserModel.user?.subscriptionId ?? "0"])
                
                self.performSegue(withIdentifier: "SubscriptionVC", sender: nil)
                
            }else if indexPath.row == 1{
                //Refer a friend
                let vc = UIStoryboard.init(name: "InviteFriend", bundle: Bundle.main).instantiateViewController(withIdentifier: "InviteFriendVC") as? InviteFriendVC
              
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
            else if indexPath.row == 2{
                
                //History
                Global.addFirebaseEvent(eventName: "my_history_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.myHistoryClick, param: [:])
                self.performSegue(withIdentifier: "HistoryVC", sender: nil)
            }
            else if indexPath.row == 3{
                //Offer
                self.performSegue(withIdentifier: "MyOfferVC", sender: nil)
                
            }
            else if indexPath.row == 4{
                //woloo gift card
                Global.addFirebaseEvent(eventName: "woloo_gift_card_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.wolooGiftCardClick, param: [:])
                self.performSegue(withIdentifier: "AddGiftCardVC", sender: nil)
                
            }
            else if indexPath.row == 5{
                //Become a woloo host
                
                Global.addFirebaseEvent(eventName: "become_host_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.becomeHostClick, param: [:])
                
                self.performSegue(withIdentifier: "BecomeHostVC", sender: nil)
            }
            else if indexPath.row == 6{
                //refer_host_click
                Global.addFirebaseEvent(eventName: "refer_host_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.referHostClick, param: [:])
                self.performSegue(withIdentifier: "ReferHostVC", sender: true)
                
            }
            else if indexPath.row == 7{
                //About
                Global.addFirebaseEvent(eventName: "about_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.aboutClick, param: [:])
                self.performSegue(withIdentifier: "AboutVC", sender: nil)
                
            }
            else if indexPath.row == 8{
                //terms Of use
                Global.addFirebaseEvent(eventName: "terms_click", param: [:])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.termsClick, param: [:])
                self.performSegue(withIdentifier: "TermsVC", sender: nil)
                
            }
            else if indexPath.row == 9{
                //log out
//                Global.showOkCancelAlertMessage(title: "Confirm", message: AppConfig.getAppConfigInfo()?.customMessage?.logoutDialog ?? "") { (isOK, isCancel) in
//                    if isOK {
//                        Global.addFirebaseEvent(eventName: "logout_click", param: [:])
//                        Global.addNetcoreEvent(eventname: self.netcoreEvents.userLogoutSuccess, param: [:])
//                        Global.addNetcoreEvent(eventname: self.netcoreEvents.logoutClick, param: [:])
//                        Hansel.getUser()?.clear()
//                        UserDefaultsManager.isUserloggedInStatusSave(value: false)
//                        UserModel.setUserLoggedInStatus(status: false)
//                        UserDefaults.userTransportMode = nil
//                        UserModel.resetUserData()
//                        UserDefaults.standard.resetDefaults()
//                        UserDefaults.tutorialScreen = true
//                        Global.shared.launchAuthBoard()
//                        //Delay to call system event of netcore
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//
//                            Smartech.sharedInstance().logoutAndClearUserIdentity(true)
//    //                        Smartech.sharedInstance().trackEvent("User_logout_success", andPayload: ["":""])
//                            
//                        }
//                        //Smartech.sharedInstance().trackEvent("User_logout_success", andPayload: ["":""])
//                        //have to add the delay of one second
//                        
//                        
//                    }
//                }
                
                
                
            }
            
        }
    }
    
    
    //MARK: - API call
    func thirstReminderYesV2() {
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        let iOS = "IOS"
        let userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        let setFrequency = setFrequency
        let param:  [String : Any] =  [ "is_thirst_reminder": "1" ,
                                        "thirst_reminder_hours": Int(setFrequency ?? "5") ?? 0]
        
        NetworkManager(data: param, headers: headers, url: nil, service: .thirstReminder, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ThirstReminderModel>, Error>) in
            switch result{
            case .success(let response):
                print("Thirst reminder response: \(response)")
                //self.thirstReminderMainView.isHidden = true
                //self.showToast(message: "THIRST REMINDER SUCCESSFULLY ADDED !")
                DispatchQueue.main.async {

                    let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                        
                    objController.isComeFrom = "Thirst_Reminder"
                    //objController.delegate = self
                   
                    objController.setFrequency = setFrequency ?? ""
                    let popup = STPopupController.init(rootViewController: objController)
                    popup.present(in: self)
                    
                }
                // Local Notification
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Thirst reminder", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "It's time to drink water!", arguments: nil)
                content.sound = UNNotificationSound.default // Deliver the notification in five seconds.
                
                
                let setFrequencyTime =  60 * 60 * Int(setFrequency ?? "")!
                //let setFrequencyTime = 60 * Int(setFrequency ?? "")!
                print("Thirst reminder frequency time set: ",setFrequencyTime)
                var setTimeInterval = Int(setFrequencyTime)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(setFrequencyTime), repeats: true)
                let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
                
                let center = UNUserNotificationCenter.current()
                center.add(request)
                
                
                Global.addNetcoreEvent(eventname: self.netcoreEvents.thirstReminderClick, param: ["is_thirst_reminder": "1", "thirst_reminder_hours": setFrequency, "user_id": UserModel.user?.userId ?? 0, "platform": "iOS"])
                
            case .failure(let error):
                print("Error thirst reminder \(error)")
            }
        }
        
    }
}

