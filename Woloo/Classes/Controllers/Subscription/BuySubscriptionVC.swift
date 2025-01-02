//
//  BuySubscriptionVC.swift
//  Woloo
//
//  Created by Vivek shinde on 21/12/20.
//

import UIKit
import Razorpay
import PassKit
import MessageUI
import Alamofire

class BuySubscriptionVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwFutureSubscription: UIView!
    @IBOutlet weak var vwRenewSubscription: UIView!
    @IBOutlet weak var vwPaymentSuccess: UIView!
    
    @IBOutlet weak var btnRenewLater: UIButton!
    @IBOutlet weak var btnRenewNow: UIButton!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var vwCancelSubscription: UIView!
    @IBOutlet weak var vwDiscontinueMembership: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var vwCancelReason: UIView!
    @IBOutlet weak var txtReasonToCancel: UITextField!
    @IBOutlet weak var txtCommentsToCancel: UITextView!
    @IBOutlet weak var noDataImage: UIView!
    
    @IBOutlet weak var giftPointView: UIView!
    
    
    @IBOutlet weak var bottomPaymentView: UIView!
    @IBOutlet weak var giftVoucherBtn: UIButton!
    @IBOutlet weak var razorpayPaymentBtn: UIButton!
    @IBOutlet weak var giftVoucherPointLbl: UILabel!
    
    @IBOutlet weak var giftVoucherAmountLbl: UILabel!
    
    @IBOutlet weak var bottomContainerPaymentView: UIView!
    @IBOutlet weak var bottomPaymentBtn: UIButton!
    
    var subscriptionData = [WolooPlanModel]()
    var razorpay: RazorpayCheckout!
    var selectedPlan: WolooPlanModel?
    var selectedPlanV2: GetPlanModel?
    var subscriptionId = ""
    var isAlreadyUnsubscribed = false
    var isFreeTrial = false
    var isMyPlan = false
    var showUnsubscribe = false
    var selectedIndex = -1
    var activePlanSubscription: WolooPlanModel?
    var activePlanSubscriptionV2: GetPlanModel?
    
    var futurePlanSubscription: WolooPlanModel?
    var futurePlanSubscriptionV2: [GetPlanModel]?
    var purchaseBy = ""
    var cancelReasonArray = [String]()
    let cancelReasonPicker = UIPickerView()
    var getAllPlans = [GetPlanModel]()
    let rupee = "\u{20B9}"
    var subscriptionPrice: Int?
    var voucherAmount: Int?
    var planIdSelected: String?
    
    var initSubscriptionOrder: InitSubscriptionByOrderModel?
    var objUser = UserProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = isMyPlan ? "My Subscription" : "Woloo Premium"
        tableView.register(SubscriptionCell.nib, forCellReuseIdentifier: SubscriptionCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        txtReasonToCancel.inputView = cancelReasonPicker
        cancelReasonPicker.delegate = self
        cancelReasonArray = AppConfig.getAppConfigInfo()?.customMessage?.cancelSubscriptionReasons?.components(separatedBy: ",") ?? ["No reason to cancel"]
        razorpay = RazorpayCheckout.initWithKey(UserDefaultsManager.fetchAppConfigData()?.RZ_CRED?.key ?? "", andDelegateWithData: self)
        
        if isMyPlan {
            vwCancelSubscription.isHidden = false
            //getMySubscription()
            getMySubscriptionV2()
          //  getMoreProfile(false)
            giftPointView.isHidden = true
        } else {
            //            InAppPurchase.shared.refreshReceipt()
            //getPlans()
            getPlansV2()
            vwCancelSubscription.isHidden = true
            giftPointView.isHidden = false
        }
        
        if showUnsubscribe {
            if isAlreadyUnsubscribed {
                alertViewAlreadyCancel()
            } else {
                vwDiscontinueMembership.isHidden = false
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getPlansRefresh), name: NSNotification.Name.init("GetPlans"), object: nil)
        
        self.giftVoucherBtn.isSelected = true
        self.razorpayPaymentBtn.isSelected = false
        
        self.bottomPaymentView.clipsToBounds = true
        self.bottomPaymentView.layer.cornerRadius = 40
        self.bottomPaymentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
      //  IAPManager.shared.fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //   DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        self.giftVoucherAmountLbl.text = "\(UserDefaultsManager.fetchUserData()?.totalCoins?.gift_coins ?? 0)"
        self.giftVoucherPointLbl.text = "\(self.rupee) \(UserDefaultsManager.fetchUserData()?.totalCoins?.gift_coins ?? 0)"
        self.voucherAmount = UserDefaultsManager.fetchUserData()?.totalCoins?.gift_coins ?? 0
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // DELEGATE.rootVC?.tabBarVc?.showTabBar()
    }
    
    // MARK: - @IBAction's
    
    @IBAction func closeFutureSubscriptionAction(_ sender: Any) {
        vwFutureSubscription.isHidden = true
    }
    
    
    
    @IBAction func okayPaymentSuccessAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.vwPaymentSuccess.isHidden = true
    }
    
    
    @IBAction func renewLaterAction(_ sender: Any) {
        btnRenewLater.isSelected = true
        btnRenewNow.isSelected = false
    }
    @IBAction func renewNowAction(_ sender: Any) {
        btnRenewLater.isSelected = false
        btnRenewNow.isSelected = true
    }
    
    @IBAction func okayRenewSubscription(_ sender: Any) {
        
        bottomPaymentBtn.isHidden = false
        print("Okay renew subscription pressed")
        vwRenewSubscription.isHidden = true
//        print(selectedIndex)
//        //let dict = self.subscriptionData[selectedIndex]
//        let dict = self.getAllPlans[selectedIndex]
//        // In App Purchase
//        self.selectedPlanV2 = dict
//        //        self.openPaymentVC(identifier: dict.appleProductId ?? "")
//        let c: [String: Any] = ["id": dict.id ?? 0, "planId": dict.plan_id ?? "", "future": btnRenewLater.isSelected ? "1" : "0"]
//        //self.subscriptionAPI(param: param)
//
//        //put subscription API by order here
//        self.subscriptionAPIV2(id: dict.id ?? 0, plan_id: dict.plan_id ?? "", future: btnRenewLater.isSelected ? true : false)
        self.bottomPaymentView.isHidden = false
        self.bottomContainerPaymentView.isHidden = false
       // self.giftVoucherPointLbl.text = "\(rupee) 300"
    }
    
    @IBAction func cancelRenewSubscription(_ sender: Any) {
        vwRenewSubscription.isHidden = true
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func keepMembershipAction(_ sender: Any) {
        vwDiscontinueMembership.isHidden = true
    }
    @IBAction func continueCancelMembershipAction(_ sender: Any) {
        
        //self.bottomPaymentView.isHidden = false
        self.bottomContainerPaymentView.isHidden = false
        vwDiscontinueMembership.isHidden = true
        txtCommentsToCancel.text = ""
        txtReasonToCancel.text = ""
        vwCancelReason.isHidden = false

    }
    @IBAction func CAncelSubscriptionAction(_ sender: Any) {
        if isAlreadyUnsubscribed {
            alertViewAlreadyCancel()
        } else if isFreeTrial {
            alertViewFreeTrial()
        } else {
            vwDiscontinueMembership.isHidden = false
        }
    }
    
    @IBAction func submitReasonToCancelAction(_ sender: Any) {
        if txtReasonToCancel.text?.count ?? 0 == 0 {
            self.showToast(message: "Please select reason to cancel")
            return
        }
        else if txtCommentsToCancel.text?.count == 0 {
            self.showToast(message: "Please add comment")
            return
        }
        else {
            vwCancelReason.isHidden = true
            if isAlreadyUnsubscribed {
                alertViewAlreadyCancel()
            } else {
                contactUsToEmail()
                //                cancelSubscription()
            }
        }
    }
    @IBAction func cancelReasonToCancelAction(_ sender: Any) {
        vwCancelReason.isHidden = true
    }
    
    @IBAction func giftVoucherBtnPressed(_ sender: UIButton) {
        giftVoucherBtn.isSelected = true
        razorpayPaymentBtn.isSelected = false
        print("pay through gift")
    }
    
    @IBAction func razorPayBtnPressed(_ sender: UIButton) {
        razorpayPaymentBtn.isSelected = true
        giftVoucherBtn.isSelected = false
        
    }
    
    
    @IBAction func paymentBtnPressed(_ sender: UIButton) {
        //bottomPaymentView.isHidden = true
        bottomPaymentView.isHidden = true
        bottomContainerPaymentView.isHidden = true
        bottomPaymentBtn.isHidden = true
        print(selectedIndex)
        //let dict = self.subscriptionData[selectedIndex]
        let dict = self.getAllPlans[selectedIndex]
//        if let product = IAPManager.shared.products.first(where: { $0.productIdentifier == IAPProduct.oneMonthSubscription.rawValue }) {
//                  IAPManager.shared.purchase(product: product)
//              } else {
//                  print("Product not found")
//              }
        if giftVoucherBtn.isSelected{
            print("Payment through gift voucher")
//            self.subscriptionAPIV2(id: dict.id ?? 0, plan_id: dict.plan_id ?? "", future: btnRenewLater.isSelected ? true : false)
//            self.paymentSuccessAPIV2(payment_id: "", plan_id: dict.plan_id ?? "", order_id: "", future: btnRenewLater.isSelected ? true : false, userGiftPoints: true)
            
            self.paymentSuccessGiftVoucher(plan_id: dict.plan_id ?? "", future: btnRenewLater.isSelected ? true : false, userGiftPoints: true)
            
        }else if razorpayPaymentBtn.isSelected{
            print("Payment through razorpay")
            self.subscriptionAPIV2(id: dict.id ?? 0, plan_id: dict.plan_id ?? "", future: btnRenewLater.isSelected ? true : false)
        }
        
//        let dict = self.getAllPlans[selectedIndex]
//        // In App Purchase
//        self.selectedPlanV2 = dict
     //self.openPaymentVC(identifier: "in.woloo.app.onemonth")
//        let param: [String: Any] = ["id": dict.id ?? 0, "planId": dict.plan_id ?? "", "future": btnRenewLater.isSelected ? "1" : "0"]
//        //self.subscriptionAPI(param: param)
//
//        //put subscription API by order here
//        self.subscriptionAPIV2(id: dict.id ?? 0, plan_id: dict.plan_id ?? "", future: btnRenewLater.isSelected ? true : false)
//        print("pay through razorpay")
    }
    
    
    @IBAction func bottomContainerBtnPressed(_ sender: UIButton) {
        
        print("toggle View")
        
        bottomPaymentView.isHidden = true
        bottomContainerPaymentView.isHidden = true
        bottomPaymentBtn.isHidden = true
    }
    
}

// MARK: - UITableViewDelegate/ UITableViewDataSource
extension BuySubscriptionVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return subscriptionData.count
        print("getAllPlans.count", getAllPlans.count)
        return getAllPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
        fillCell(cell, indexPath.row)
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //                self.performSegue(withIdentifier: "payment", sender: nil)
        //        btnContinue.tag = indexPath.row
        selectedIndex = indexPath.row
        print("Index Postion ->",indexPath.row)
        print("Get All plans subscription amount: \(getAllPlans[indexPath.row].price ?? "")")
        print("selected plan ID: \(getAllPlans[indexPath.row].plan_id)")
        
        planIdSelected = getAllPlans[indexPath.row].plan_id ?? ""
        btnRenewLater.isHidden = false
        btnRenewLater.isSelected = false
        btnRenewNow.isSelected = true
        vwRenewSubscription.isHidden = false
        
        var getAllPlanIndex = Int(getAllPlans[indexPath.row].price ?? "") ?? 0
        
//        if voucherAmount! >= getAllPlanIndex {
//            print("Show the purchase by point")
//            self.giftVoucherBtn.isEnabled = true
//            
//            
//        }else{
//            self.giftVoucherBtn.isEnabled = false
//            print("hide the purchase by point")
//        }
        
        tableView.reloadData()
        
        //        cell.descriptionView.isHidden = self.selectedIndex == row ? false : true
        //        cell.btnUpgrade.isHidden = isMyPlan ? true : self.selectedIndex == row ? false : true
        //        cell.separatorView.isHidden = isMyPlan ? true : self.selectedIndex == row ? false : true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
// MARK: - API
extension BuySubscriptionVC {
    
//MARK: - DashboardViewModelDelegate
    
    @objc func getPlansRefresh() {
        //getPlans()
        
        //MARK: New GetPlans Api
         getPlansV2()
    }
    
//    func getPlans(_ showLoading: Bool? = true) {
//        APIManager.shared.getWolooPlan(param: [:],showLoading: showLoading) { [weak self] (response, message) in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                let filtered = response?.plans?.filter{ $0.name?.count ?? 0 > 0 }
//                self.subscriptionData = filtered ?? [WolooPlanModel]()
//                self.getMoreProfile(false)
//                self.getMySubscription(true)
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    func getPlansV2(_ showLoading: Bool? = true) {
        
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
        
        NetworkManager(headers: headers, url: nil, service: .getPlans, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<[GetPlanModel]>, Error>) in
            switch result {
                
            case .success(let response):
                print("Get plans Response: ", response)
                self.getAllPlans = response.results
//                print("Get plans parsed value: \(self.getAllPlans)")
                //self.getMoreProfile(false)
                //self.getMySubscription(true)
                self.getMySubscriptionV2(true)
                self.tableView.reloadData()
                
            case .failure(let error):
                print("Get plans error: \(error)")
                
                
            }
        }
        
        
        
    }
    
    func subscriptionAPI(param: [String: Any], _ showLoading: Bool? = true) {
        print("param : \(param)")
        APIManager.shared.initSubscription(param: param, showLoading: showLoading) { (result, message) in
            if let receipt = result, let subscriptionId = receipt.subscriptionid {
                self.subscriptionId = subscriptionId
                self.showPaymentForm(id: subscriptionId)
            }
            print(message)
        }
    }
    
    
    func subscriptionAPIV2(id: Int, plan_id: String, future: Bool){
        
        let localeData = ["platform": "ios", "country": "India", "actualCountry": "India"]
        
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
        
        
        
        let data = ["id": id, "plan_id": plan_id, "future": future, "locale": localeData] as [String : Any]
        
        NetworkManager(data: data,headers: headers ,url: nil, service: .initSubscriptionByOrder, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<InitSubscriptionByOrderModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("Init Subscription By Order response: ", response)
                self.initSubscriptionOrder = response.results
                self.showPaymentForm(id: response.results.subscription_id ?? "")
                self.subscriptionId = response.results.subscription_id ?? ""
                
            case .failure(let error):
                print("init subscription by order fail error: \(error)")
            }
        }
        
    }
    
    
    func PaymentSuccessAPI(param: [String: Any]) {
        APIManager.shared.submitSubscriptionPurchase(param: param) { [weak self] (status, message) in
            guard let self = self else { return }
            if status { // Show pop up when payment success.
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Okay", title: "Congratulations", message: AppConfig.getAppConfigInfo()?.customMessage?.paymentSuccessDialogText, image: UIImage(named: "checkmark"), controller: self)
                    alert.cancelTappedAction = {
                        
                        alert.removeFromSuperview()
                        
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                    self.vwPaymentSuccess.isHidden = false
                    self.getPlansV2()
                    //self.getMoreProfile()
                    // In App Purchase
                    //                    self.getPlans()
                }
            }
            print(message)
        }
    }
    
    func paymentSuccessAPIV2(payment_id: String?, plan_id: String?, order_id: String?, future: Bool, userGiftPoints: Bool?){
        
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
        
        let data = ["payment_id": payment_id, "plan_id": plan_id, "order_id": order_id, "future": future, "userGiftPoints": userGiftPoints] as [String : Any]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .submitSubscription, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<SubmitSubscriptionPurchaseModel>, Error>) in
            switch result{
            case .success(let response):
                print("Request submitted successfully")
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Okay", title: "Congratulations", message: AppConfig.getAppConfigInfo()?.customMessage?.paymentSuccessDialogText, image: UIImage(named: "checkmark"), controller: self)
                    alert.cancelTappedAction = {
                        self.navigationController?.popViewController(animated: true)
                        alert.removeFromSuperview()
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                    //self.vwPaymentSuccess.isHidden = false
                   // self.getMoreProfile()
                }
                
                
            case .failure(let error):
                print("Request Submission Error", error)
            }
        }
        
    }
    
    func paymentSuccessGiftVoucher(plan_id: String?, future: Bool?, userGiftPoints: Bool?){
        
        
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
        
        let data = ["plan_id": plan_id,"future": future, "userGiftPoints": userGiftPoints] as [String : Any]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .submitSubscription, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<SubmitSubscriptionPurchaseModel>, Error>) in
            switch result{
            case .success(let response):
                print("Request submitted successfully")
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Okay", title: "Congratulations", message: AppConfig.getAppConfigInfo()?.customMessage?.paymentSuccessDialogText, image: UIImage(named: "checkmark"), controller: self)
                    alert.cancelTappedAction = {
                        alert.removeFromSuperview()
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                    //self.vwPaymentSuccess.isHidden = false
                    //self.getMoreProfile()
                }
                
                
            case .failure(let error):
                print("Request Submission Error", error)
            }
        }
        
    }
    
    
    
    
    func getMySubscription(_ showLoading: Bool? = true) {
        APIManager.shared.mySubscription(param: [:], showLoading: showLoading) { (myPlan, message) in
            if let plan = myPlan {
                print("myPlan: ", myPlan)
                if let expiryDatestr = UserModel.user?.expiryDate  {
                    let expiryDate = expiryDatestr.toDate(format: "yyyy-MM-dd")
                    var dayComponent    = DateComponents()
                    dayComponent.day    = 1
                    let theCalendar     = Calendar.current
                    let e2        = theCalendar.date(byAdding: dayComponent, to: expiryDate)
                    let days = e2?.intervalBetweenDates(ofComponent: .day, fromDate: Date()) ?? 0
                    
                    if days >= 0 {
                        if let activePlan = plan.activeSubscription {
                            self.activePlanSubscription = activePlan
                            if self.isMyPlan {
                                self.subscriptionData.append(activePlan)
                            }
                        }
                        if let future = plan.futureSubscription {
                            self.futurePlanSubscription = future
                            if self.isMyPlan {
                                self.subscriptionData.append(future)
                            }
                        }
                        
                    } else {
                        
                    }
                }
                
                if self.getAllPlans.count == 0 {
                    self.noDataImage.isHidden = false
                }
                self.purchaseBy = myPlan?.purchaseBy ?? ""
                self.tableView.reloadData()
            }
        }
    }
    
    func getMySubscriptionV2(_ showLoading: Bool? = true){
        
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
        
        NetworkManager(headers: headers, url: nil, service: .mySubscription, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<MySubscriptionModel>, Error>) in
            switch result {
                
            case.success(let response):
                print("My subscription Response ", response)
                
                if let expiryDateStr = self.objUser.profile?.expiry_date {
                    let expiryDate = expiryDateStr.toDate(format: "yyyy-MM-dd")
                    var dayComponent    = DateComponents()
                    dayComponent.day    = 1
                    let theCalendar     = Calendar.current
                    
                    let e2 = theCalendar.date(byAdding: dayComponent, to: expiryDate)
                    
                    let days = e2?.intervalBetweenDates(ofComponent: .day, fromDate: Date()) ?? 0
                    
                    if days >= 0 {
                        
                        if let activePlanV2 = response.results.activeSubscription {
                            //self.activePlanSubscriptionV2 = activePlanV2
                            self.activePlanSubscriptionV2 = activePlanV2
                            if self.isMyPlan{
                                //self.getAllPlans.append(activePlanV2)
                                //self.activePlanSubscriptionV2 = activePlanV2
                                
                                print("Active subscription Data: \(self.activePlanSubscriptionV2)")
                                self.getAllPlans.append(activePlanV2)
                                //self.noDataImage.isHidden = true
                                
                            }
                        }
                        
                        if let future = response.results.futureSubscription {
                           // self.futurePlanSubscriptionV2 = future
                            self.futurePlanSubscriptionV2 = future
                            if self.isMyPlan{
                                print("Future subscription Data: \(self.futurePlanSubscriptionV2)")
                                self.getAllPlans.append(contentsOf: future)
                            }
                        }
                        
                    }
                   
                }
                
                if self.getAllPlans.count == 0{
                    
                    self.noDataImage.isHidden = false
                }
                self.purchaseBy = response.results.purchase_by ?? ""
                self.tableView.reloadData()
                
                
            case .failure(let error):
                print("My subscription Error response ", error)
            }
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
        let subject = txtReasonToCancel.text ?? ""
        print("subject ->", subject)
        let message = txtCommentsToCancel.text ?? ""
        print("message ->", message)
        
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([supportEmailUrl])
        mailComposerVC.setSubject(subject)
    
        let messageText = "\(message)"
        
        mailComposerVC.setMessageBody(messageText, isHTML: true)
        
        return mailComposerVC
    }
    
    /*
     func cancelSubscription() {
     if purchaseBy == "apple" {
     if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
     UIApplication.shared.open(url)
     return
     }
     } else if purchaseBy == "razorpay" {
     Global.showIndicator(isInteractionEnable: false)
     let param: [String:Any] = ["cancel_reason":txtReasonToCancel.text ?? "","remark": txtCommentsToCancel.text ?? ""]
     APIManager.shared.cancelSubscription(param: param) { [weak self] (status, message) in
     Global.hideIndicator()
     guard let self = self else { return }
     if let result = status, result.status == .success {
     self.alertView()
     }
     print(message)
     }
     }
     }
     */
    
    
    func getMoreProfile(_ showLoding: Bool? = true) {
        UserModel.apiMoreProfileDetails(showLoading: showLoding) { (userModel) in
            DispatchQueue.main.async {
                
                
                //                UserModel.saveAuthorizedUserInfo(userModel?.userData)
                if let isCancel = userModel?.planData?.isCancel {
                    self.isAlreadyUnsubscribed = isCancel//userModel?.planData?.isCancel
                }
                if (userModel?.planData?.name?.lowercased() ?? "") == "free trial" || userModel?.planData == nil {
                    self.isFreeTrial = true
                }
                if let subscribeId = UserModel.getAuthorizedUserInfo()?.subscriptionId { // When user have any subscription.
                    if let index = self.subscriptionData.firstIndex(where: {$0.pid == subscribeId }) {
                        self.subscriptionData = self.subscriptionData.rearrange(array: self.subscriptionData, fromIndex: index, toIndex: 0)
                    }
                    if let futureData = userModel?.futureSubcription, let index = self.subscriptionData.firstIndex(where: {$0.pid == futureData.id}) {
                        self.subscriptionData = self.subscriptionData.rearrange(array: self.subscriptionData, fromIndex: index, toIndex: 1)
                    }
                }
                if let gid = UserModel.getAuthorizedUserInfo()?.giftSubscriptionId, gid > 0 {
                    if self.isMyPlan {
                        self.vwCancelSubscription.isHidden = false
                    } else {
                        self.vwCancelSubscription.isHidden = true
                    }
                    // In App Purchase
                    //                    self.vwCancelSubscription.isHidden = true
                }
                self.giftVoucherAmountLbl.text = "\(userModel?.totalCoins?.giftCoins ?? 0)"
                self.giftVoucherPointLbl.text = "\(self.rupee) \(userModel?.totalCoins?.giftCoins ?? 0)"
                self.voucherAmount = userModel?.totalCoins?.giftCoins ?? 0
                
            }
        }
    }
}

//// MARK: - Email Handling
//extension BuySubscriptionVC {
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}

// MARK: - Fill Cell Handling
extension BuySubscriptionVC {
    
    func fillCell(_ cell: SubscriptionCell,_ row: Int) {
        //        cell.descriptionView.isHidden = self.selectedIndex == row ? false : true
        //        cell.btnUpgrade.isHidden = isMyPlan ? true : self.selectedIndex == row ? false : true
        //        cell.separatorView.isHidden = isMyPlan ? true : self.selectedIndex == row ? false : true
//        if let activePlanId = activePlanSubscription?.planId, activePlanId == subscriptionData[row].planId {
//            cell.lblActive.setTitle("Active ✔", for: .normal)
//            cell.lblActive.isHidden = false
//            // In app Purchase
//            //            cell.btnUpgrade.isHidden = true
//            //            cell.separatorView.isHidden = true
//
//            cell.lblBuyNow.isHidden = self.subscriptionData.contains(where: {$0.planId == activePlanId })
//            //            cell.separatorView.isHidden = self.subscriptionData.contains(where: {$0.planId == activePlanId })
//        }
//        else if let futurePlanId = self.futurePlanSubscription?.planId, futurePlanId == subscriptionData[row].planId {
//            cell.lblActive.setTitle("Future ✔", for: .normal)
//            cell.lblActive.isHidden = false
//            cell.lblBuyNow.isHidden = true
//            //            cell.separatorView.isHidden = true
//        }
//        else if isMyPlan {
//            let title = row == 0 ? "Active ✔" :  "Future ✔"
//            cell.lblActive.setTitle(title, for: .normal)
//            cell.lblActive.isHidden = false
//            cell.lblBuyNow.isHidden = true
//            //            cell.separatorView.isHidden = true
//        } else {
//            cell.lblActive.isHidden = true
//        }
        
        if let activePlanId = activePlanSubscriptionV2?.plan_id, activePlanId == getAllPlans[row].plan_id {
            cell.lblActive.setTitle("Active ✔", for: .normal)
            cell.lblActive.isHidden = false
            // In app Purchase
            //            cell.btnUpgrade.isHidden = true
            //            cell.separatorView.isHidden = true

            cell.lblBuyNow.isHidden = self.getAllPlans.contains(where: {$0.plan_id == activePlanId })
            //            cell.separatorView.isHidden = self.subscriptionData.contains(where: {$0.planId == activePlanId })
        }
//        else if let futurePlanId = self.futurePlanSubscriptionV2?.plan_id, futurePlanId == getAllPlans[row].plan_id {
//            cell.lblActive.setTitle("Future ✔", for: .normal)
//            cell.lblActive.isHidden = false
//            cell.lblBuyNow.isHidden = true
//            //            cell.separatorView.isHidden = true
//        }
        else if isMyPlan {
            let title = row == 0 ? "Active ✔" :  "Future ✔"
            cell.lblActive.setTitle(title, for: .normal)
            cell.lblActive.isHidden = false
            cell.lblBuyNow.isHidden = true
            //            cell.separatorView.isHidden = true
        } else {
            cell.lblActive.isHidden = true
        }

        
        
        cell.lblActive.layer.cornerRadius = 7
        //        cell.configureUI(subscriptionData[row].shieldColor ?? "#FFF896", subscriptionBgColorStr: subscriptionData[row].backgroundColor ?? "#FFFFFF")
        //cell.setData(subscriptionData: subscriptionData[row])
        
        cell.setDataV2(subscriptionDataV2: getAllPlans[row])
        //        btnContinue.tag = row
        /*
         cell.upgradeBlock = { [weak self] in // Handle Update click.
         
         guard let self = self else { return }
         self.btnRenewLater.isHidden = false
         self.btnRenewLater.isSelected = false
         self.btnRenewNow.isSelected = true
         self.vwRenewSubscription.isHidden = false
         return
         
         if let expiryDateStr = UserModel.getAuthorizedUserInfo()?.expiryDate {
         let expiryDate = expiryDateStr.convertDateToDate(expiryDateStr, inputFormate: "yyyy-MM-dd", outputFormate: "yyyy-MM-dd")
         if expiryDate > Date() {
         if let lifeTime = UserModel.getAuthorizedUserInfo()?.lifetimeFree, lifeTime == 1 {
         self.btnRenewLater.isHidden = true
         self.btnRenewNow.isSelected = true
         } else {
         self.btnRenewNow.isHidden = false
         self.btnRenewLater.isHidden = false
         self.btnRenewNow.isSelected = true
         self.btnRenewLater.isSelected = false
         }
         self.vwRenewSubscription.isHidden = false
         }
         }
         }
         */
        /*
         cell.popUpViewHandler = { [weak self] in // Handle PopUpView click.
         guard let self = self else { return }
         self.btnRenewLater.isHidden = true
         self.btnRenewNow.isSelected = true
         self.vwRenewSubscription.isHidden = false
         return
         
         if let expiryDateStr = UserModel.getAuthorizedUserInfo()?.expiryDate {
         let expiryDate = expiryDateStr.convertDateToDate(expiryDateStr, inputFormate: "yyyy-MM-dd", outputFormate: "yyyy-MM-dd")
         if expiryDate > Date() {
         if let lifeTime = UserModel.getAuthorizedUserInfo()?.lifetimeFree, lifeTime == 1 {
         self.btnRenewLater.isHidden = true
         self.btnRenewNow.isSelected = true
         } else {
         self.btnRenewNow.isHidden = false
         self.btnRenewLater.isHidden = false
         self.btnRenewNow.isSelected = true
         self.btnRenewLater.isSelected = false
         }
         self.vwRenewSubscription.isHidden = false
         }
         }
         }
         */
    }
}

// MARK: - RazorpayProtocol
extension BuySubscriptionVC: RazorpayPaymentCompletionProtocolWithData {
    
    func showPaymentForm(id: String) {
        
        let userInfo = UserDefaultsManager.fetchUserData()
        
        let options: [String:Any] = [
            "order_id": id,
            "name": "Woloo",
            // "image": "https://s3.amazonaws.com/rzp-mobile/images/rzp.png",
            "currency": "INR",
            "description": "Woloo Pee’rs Club Membership",
            "prefill": [
                "contact": String(userInfo?.profile?.mobile ?? 0),
                "email": userInfo?.profile?.email ?? "",
            ],
        ]
        //        DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        razorpay.open(options, displayController: self)
    }
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("error: ", code)
        //        DELEGATE.rootVC?.tabBarVc?.showTabBar()
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("success: ", payment_id)
        let param: [String: Any] = ["paymentId" : payment_id,
                                    "planId": self.selectedPlan?.planId ?? "",
                                    "subscriptionId": subscriptionId,
                                    "paymentSignature": response?["razorpay_signature"] as? String ?? "",
                                    "future": btnRenewLater.isSelected ? "1" : "0"
        ]
        //self.PaymentSuccessAPI(param: param)
        
        self.paymentSuccessAPIV2(payment_id: payment_id , plan_id: planIdSelected ?? "", order_id: subscriptionId, future: btnRenewLater.isSelected ? true : false, userGiftPoints: giftVoucherBtn.isSelected ? true : false)
        
        //        DELEGATE.rootVC?.tabBarVc?.showTabBar()
    }
}

// MARK: - Alert Actions
extension BuySubscriptionVC {
    func alertView() {
        let alert = WolooAlert(frame: view.frame, cancelButtonText: "Close", title: nil, message: "Membership cancelled successfully.", image: nil, controller: self)
        alert.cancelTappedAction = {
            self.navigationController?.popViewController(animated: true)
            alert.removeFromSuperview()
        }
        self.view.addSubview(alert)
        self.view.bringSubviewToFront(alert)
    }
    func alertViewAlreadyCancel() {
        let alert = WolooAlert(frame: view.frame, cancelButtonText: "Close", title: nil, message: "You have already Unsubscribe the membership", image: nil, controller: self)
        alert.cancelTappedAction = {
            alert.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(alert)
        self.view.bringSubviewToFront(alert)
    }
    func alertViewFreeTrial() {
        let alert = WolooAlert(frame: view.frame, cancelButtonText: "Close", title: nil, message: "You don't have an active membership", image: nil, controller: self)
        alert.cancelTappedAction = {
            alert.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(alert)
        self.view.bringSubviewToFront(alert)
    }
    //not used
    func alertViewRestore() {
        let alert = WolooAlert(frame: view.frame, cancelButtonText: "Close", title: nil, message:  "You already have this subscription.", image: nil, controller: self)
        alert.cancelTappedAction = {
            alert.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(alert)
        self.view.bringSubviewToFront(alert)
    }
}
// MARK: UIPickerView Delegation
extension BuySubscriptionVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cancelReasonArray.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cancelReasonArray[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtReasonToCancel.text = cancelReasonArray[row]
    }
}

extension BuySubscriptionVC {
    private func openPaymentVC(identifier: String) {
        //        Global.showIndicator(isInteractionDisable: true)
        InAppPurchase.shared.productPurchase(productIdentifier: identifier, toGetPrice: false, controller: self)
                InAppPurchase.shared.getAllProducts()
                InAppPurchase.shared.restoreInAppPurchase()
                InAppPurchase.shared.handleRestoreCompletion = { [weak self] (status) in
                    guard let weak = self else { return }
                    if !status { // No previous payment.
                        InAppPurchase.shared.productPurchase(productIdentifier: identifier, toGetPrice: false, controller: weak)
                    } else {
                        weak.alertViewRestore()
                    }
                }
        
    }
}
