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
            return "icon_offer"
        case .InviteAFriend:
            return "ic_Invite"
        case .MyAccount:
            return "ic_account"
        case .MyOffer:
            return "ic_account"
       case .WolooGiftCard:
            return "icon_giftCard"
        case .BuySubscription:
            return "icon_buy_membership"
        case .MyHistory:
            return "icon_history"
        case .BecomeAWolooHost:
            return "icon_wolooHost"
        case .ReferAWolooHost:
            return "icon_referWolooHost"
        case .AddReview:
            return "Gift Card"
        case .TermsOfUse:
            return "icon_terms"
        case .Unsubscribe:
            return "Discontinue"
        case .Delete:
            return "Discontinue"
        case .About:
            return "icon_About"
        case .logout:
            return "icon_logout"
        
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
    var setFrequency: String? = ""
    var objPeriodTrackerViewModel = EditCycleViewModel()
    var openViewCycle: Bool? = false
    var selectedProfileImage: UIImage?
    
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
        self.objPeriodTrackerViewModel.delegate = self
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Global.addFirebaseEvent(eventName: "more_search_click", param: [:])
        self.objDashboardViewModel.delegate = self
        Global.showIndicator()
        self.objDashboardViewModel.getUserProfileAPI()
        //getProfile()
//        DELEGATE.rootVC?.tabBarVc?.showTabBar()
        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
        self.getPeriodTrackerV2()
        
    }
    
    func openTrackerVC() {
            let vc = UIStoryboard.init(name: "Tracker", bundle: Bundle.main).instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController
            
            self.navigationController?.pushViewController(vc!, animated: true)
    
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
    
    private func getPeriodTrackerV2(){
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(headers: headers, url: nil, service: .viewperiodtracker, method: .get, isJSONRequest: false).executeQuery {(result: Result<BaseResponse<ViewPeriodTrackerModel>, Error>) in
            switch result{
                
            case .success(let response):
                Global.hideIndicator()
                print("View period tracker: ", response.results)
                if response.results.id == nil{
                    
                    print("open edit cycle")
                   // self.openEditCycleVC(info: response.results)
                }else if let date = response.results.periodDate?.toDate(), let dateLast35Days = Calendar.current.date(byAdding: .day, value: -35, to: Date()) {
                    
                    let days = Calendar.current.dateComponents([.day], from: dateLast35Days, to: date).day ?? 0
                    if days < 0 {
                        print("open edit cycle")
                       
                        self.openViewCycle = false
                        
                        return
                    } else {
                        self.openViewCycle = true
                       
                        return
                    }
                }
                else {
                   
                    self.openViewCycle = false
                   
                    return
                }
                
                
                
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("View periodTracker API failed: ", error)
            }
        }
    }
    
    func openEditCycleVC(info: ViewPeriodTrackerModel?){
        let vc = UIStoryboard.init(name: "Tracker", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController
        vc?.isEditScreen = false
       // if let editCycleInfo = info {
        vc?.selectedDate = info?.periodDate?.toDate() ?? Date()
        print("period date: ", info?.periodDate?.toDate() ?? Date())
            
        vc?.cycleLength = info?.cycleLength ?? 28
        vc?.periodLength = info?.periodLength ?? 4
        vc?.loginfo = info?.log
        
        self.navigationController?.pushViewController(vc!, animated: true)
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
//extension MoreVC: DashboardViewModelDelegate , MoreViewModelDelegate{
//    //MARK: - MoreViewModelDelegate
//    
//    
//    func didReceiveUploadProfilePhotoResponse(objResponse: BaseResponse<Profile>) {
//        Global.hideIndicator()
//        self.objDashboardViewModel.getUserProfileAPI()
//    }
//    
//    func didUploadProfilePhotoError(strError: String) {
//        Global.hideIndicator()
//    }
//    
//    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>) {
//        //
//    }
//    
//    func didReceiceWahCertificateError(strError: String) {
//        //
//    }
//    
//   
//    //    func getUserMoreProfile() {
//    //        UserModel.apiMoreProfileDetails { (profileMoreResponse) in
//    //            return
//    //        }
//    //    }
//    //MARK: - DashboardViewModelDelegate
//    func didReceievGetUserProfile(objResponse: BaseResponse<UserProfileModel>) {
//        Global.hideIndicator()
//        UserDefaultsManager.storeUserData(value: objResponse.results)
//        if self.moreDetailV2 == nil {
//            self.moreDetailV2 = MoreTabDetailV2()
//        }
//        objUser = objResponse.results
//        self.moreDetailV2?.userData = objUser.profile
//        self.moreDetailV2?.userCoin = objUser.totalCoins
//        self.moreDetailV2?.subscriptionData = objUser.planData
//        self.updateProfileData()
//        
//    }
//    
//    func didReceievGetUserProfileError(strError: String) {
//        Global.hideIndicator()
//    }
//    
//    
//    
//    func getProfile() {
//        UserModel.apiMoreProfileDetails { (userModel) in
//            DispatchQueue.main.async {
//                if self.moreDetail == nil {
//                    self.moreDetail = MoreTabDetail()
//                }
//                //                UserModel.saveAuthorizedUserInfo(userModel?.userData)
//                self.moreDetail?.userData = userModel?.userData
//                self.moreDetail?.userCoin = userModel?.totalCoins
//                self.moreDetail?.subscriptionData = userModel?.planData
//                self.updateProfileData()
//            }
//        }
//    }
//}

extension MoreVC: UIImagePickerControllerDelegate,
                  UINavigationControllerDelegate {
    
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true) {
//            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                
//                print("Picked Image: ", pickedImage)
//                Global.showOkCancelAlertMessage(title: "Confirm", message:"Are you sure you want to change picture?") { (isOK, isCancel) in
//                    if isOK {
//                        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileCell {
//                            print("picked image")
//                            cell.profileImageView.image = pickedImage
//                            
//                            Global.showIndicator()
//                            DispatchQueue.main.async {
//                                self.objMoreViewModel.uploadProfileImage(profileImage: pickedImage)
//                            }
//                        }
//                    }
//                    
//                }
//            }
//        }
//    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            if let pickedImage = info[.originalImage] as? UIImage {
                Global.showOkCancelAlertMessage(title: "Confirm", message: "Are you sure you want to change picture?") { (isOK, isCancel) in
                    if isOK {
                        self.selectedProfileImage = pickedImage  // Store the selected image
                        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)

                        Global.showIndicator()
                        DispatchQueue.main.async {
                            self.objMoreViewModel.uploadProfileImage(profileImage: pickedImage)
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
