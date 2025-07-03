
//  WolooDashBoardVC.swift
//  Woloo
//
//  Created on 29/07/21.
//

import UIKit
import Foundation

class WolooDashBoardVC: UIViewController {

    @IBOutlet weak var setFrequencyTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var thirstReminderMainView: UIView!
    @IBOutlet weak var thirstReminderView: UIView!
    @IBOutlet weak var thirstReminderHoursView: UIView!
    @IBOutlet weak var vwOverlay: UIView!
    
    var isFromDashBoard = false
    var isZero: Bool?
    var netCoreEvents = NetcoreEvents()
    var objBlogDetailModel = BlogDetailModel()
    var listGetAllCategory = [CategoryModel]()
    var blogIndex: Int?
    var persistance: ECommerceDataPersistance? = ECommerceDataPersistance()
    var objWolooDashboardViewModel = WolooDashboardViewModel()
    var contextMenuOverlay: TweetContextMenuOverlay?
    var objProduct = Products()
    
    var categories: HomeCategory?
    
     enum DashBoardSection: Int, CaseIterable {
        
//        case profile
//        case locationDetail
       // case banners
        case header
        case trendingBlog
        case list
    }
    
     var dashBoardSections = DashBoardSection.allCases
    //private var userCoins: ProfileUserCoins?
     var userCoins: UserProfileModel.TotalCoins?
     var userSelectedCategory = [CategoryInfo]()
     var bannerInfo = [OfferReponse]()
     var bannerInfoV2 = [NearByLooOfferCountModel]()
     var blogList = [BlogModel]()
     var objBlogModel = BlogModel()
     var selectedCategory = 0
     var selectedBlogList = 0
     var userModel: UserProfileModel.Profile?
    var blogCategoryResponse = BlogDetailModel()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        intialSetUp()
        print("API environment: \(NetworkManager.networkEnvironment)")
//        userJourneyAPI()
        self.objWolooDashboardViewModel.delegate = self
        setFrequencyTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        if self.isFromDashBoard {
            thirstReminderMainView.isHidden = false
            thirstReminderView.isHidden = false
            thirstReminderHoursView.isHidden = true
        } else {
            thirstReminderMainView.isHidden = true
            thirstReminderView.isHidden = true
            thirstReminderHoursView.isHidden = true
        }
        
        let overlayShown = UserDefaults.standard.value(forKey:"overlay_shown") as? Int
        DispatchQueue.main.async {
            if UIDevice.current.userInterfaceIdiom == .phone {
                if overlayShown == 1 {
                    self.vwOverlay.isHidden = true
                } else {
                    self.vwOverlay.isHidden = false
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
       // DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
        //DELEGATE.rootVC?.tabBarVc?.showTabBar()
      
        //offerAndWolooCountAPI()
        nearByLooOfferCount()
        fetchUserProfileV2()
        //fetcUserProfile()
        //fetchUserProfileV2(userID: 39120)
       // getCategoryAPI()
        //getAllCategoryAPIV2()
       // getBloagsAndCategoryAPI(selectedCategory)
        DispatchQueue.main.async {
            //
        }
        getBlogsAndCategoryAPIV2(cat: "All")
        
    }
    
    
    /// UI inital set up.
    private func intialSetUp() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //setupTableView()
    }
    
    fileprivate func isCartAvaialbel() -> Int {
        let fetchrequest = LocalProducts.fetchRequests()
        do {
            let data = try EcommerceModelSingleton.instance?.mainContaxt.fetch(fetchrequest)
            return data?.count ?? 0
        } catch {
            return 0
        }
    }
    
    @IBAction func clickedDoneBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.vwOverlay.isHidden = true
        }
        UserDefaults.standard.set(1, forKey:"overlay_shown")
        UserDefaults.standard.synchronize()
        
    }
    
}





// MARK: - Handle Other controller
extension WolooDashBoardVC {

    fileprivate func openMyOfferVC() {
        let dashboardSB = UIStoryboard(name: "Dashboard", bundle: nil)
        if let myOfferVC = dashboardSB.instantiateViewController(withIdentifier: "SearchLocationViewController") as? SearchLocationViewController {
            myOfferVC.isMyOffer = true
            navigationController?.pushViewController(myOfferVC, animated: true)
        }
    }
    
    fileprivate func openTrackerVC() {
        let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let trackerVC = trackerSB.instantiateViewController(withIdentifier: "PeriodTrackerViewController") as? PeriodTrackerViewController {
            //            trackerVC.isFromDashBoard = true
            navigationController?.pushViewController(trackerVC, animated: true)
        }
    }
    
    fileprivate func openVisiteOfferVC() {
        let visitOfferSB = UIStoryboard(name: "WolooDashBoard", bundle: nil)
        if let visitOfferVC = visitOfferSB.instantiateViewController(withIdentifier: "VisitOfferVC") as? VisitOfferVC {
            visitOfferVC.modalPresentationStyle = .overCurrentContext
            visitOfferVC.view.isOpaque = false
            DELEGATE.rootVC?.tabBarVc?.present(visitOfferVC, animated: true,completion: {
                visitOfferVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })
        }
    }
    
    fileprivate func editCycleVC() {
        let editCycleSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let editCycleVc = editCycleSB.instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController {
            editCycleVc.isEditScreen = false
            editCycleVc.selectedDate = Date()
            navigationController?.pushViewController(editCycleVc, animated: true)
        }
        
    }
    
     func openBlogDetailVC(index: Int) {
        self.blogIndex = 0
        if blogList[index].isBlogRead == 0 {
            print(index)
            self.blogIndex = index
            blogReadV2(index: blogList[index].id ?? 0)
        } else {
            let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
            if let detailVC = trackerSB.instantiateViewController(withIdentifier: "BlogDetailViewController") as? BlogDetailViewController {
                detailVC.detailBLogLink = blogList[index].detailedShortLink ?? ""
                detailVC.detailBlogTitle = blogList[index].title ?? ""
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
     func openSearchVC() {
        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        if let searchVC = sb.instantiateViewController(withIdentifier: "SearchLocationViewController") as? SearchLocationViewController {
            searchVC.transportMode = .car
            searchVC.isOffer = true
            navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    private func openTopicScreen() {
        let topicSB = UIStoryboard(name: "Authentication", bundle: nil)
        if let topicVC = topicSB.instantiateViewController(withIdentifier: "IntrestedTopicVC") as? IntrestedTopicVC {
            navigationController?.pushViewController(topicVC, animated: true)
        }
    }
}

// MARK: - Action's
extension WolooDashBoardVC {
    
    @IBAction func closeThirstReminderAction(_ sender: Any) {
        thirstReminderMainView.isHidden = true
    }
    
    @IBAction func yesThirstReminderAction(_ sender: Any) {
        thirstReminderHoursView.isHidden = false
    }
    
    @IBAction func noThirstReminderAction(_ sender: Any) {
       // thirstReminderNo()
        thirstReminderNoV2()
        
    }
    
    @IBAction func closethirstReminderHoursAction(_ sender: Any) {
        thirstReminderMainView.isHidden = true
        
    }
    
    @IBAction func savethirstReminderHoursAction(_ sender: Any) {
        //thirstReminderYes()
        if isZero == true{
            self.showToast(message: "Can't enter Zero as hours")
            
        }else{
            thirstReminderYesV2()
        }
        
       
    }
    
}

// MARK: - API's Calling
extension WolooDashBoardVC {
//    fileprivate func fetcUserProfile() {
//        UserModel.apiMoreProfileDetails { [weak self] (userInfo) in
//            guard let weak = self else { return }
//            if let info = userInfo {
//                weak.userCoins = info.totalCoins
//                UserModel.saveAuthorizedUserInfo(info.userData)
//                weak.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//            }
//        }
//    }
    

    
    func nearByLooOfferCount(){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        var param: [String: Any] = [:]
        if let currentLocation = DELEGATE.locationManager.location  {
            param  = ["lat" : currentLocation.coordinate.latitude,
                      "lng": currentLocation.coordinate.longitude,"package_name": "in.woloo.app"]
        } else {
            param  = ["lat" : "0.0", "lng": "0.0","package_name": "in.woloo.app"]
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
  
        
        NetworkManager(data: param,headers: headers ,url: nil, service: .nearByWolooAndOfferCount, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<NearByLooOfferCountModel>, Error>) in
            switch result{
            case .success(let response):
                print("Response nearbyLooAndOfferCount: \(response.results.wolooCount ?? 0)")
               // self.wolooOfferInfoV2 = response.results
                
            case .failure(let error):
                print("Error nearbyLooAndOfferCount:",error)
                
            }
        }
        
    }
    
    fileprivate func getCategoryAPI() {
        APIManager.shared.getCategoryAPI([:]) { [weak self] list, message in
            guard let weak = self else { return }
            if let `list` = list?.categories {
              //  weak.listOFCategories = list
            }
        }
    }
    
    
    fileprivate func getAllCategoryAPIV2(){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        let sortData = [ "key" : "",
                         "order" : ""] as [String : Any]
        
        
        let localeData = [ "pageIndex" : 1,
                           "pageSize" : 10,
                           "query" : "",
                           "sort": sortData] as [String : Any]

        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        let systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        let iOS = "IOS"
        let userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: localeData, headers: headers, url: nil, service: .getAllCategories, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<GetAllCategoryModel>, Error>) in
            switch result{
                
            case .success(let response):
               // self.listGetAllCategory = response.results.data ?? [DataAllBlog]()
                self.tableView.reloadData()
    
            case .failure(let error):
                print("getAll categories error", error)
                
            }
        }

        
        
    }
    
    fileprivate func getBloagsAndCategoryAPI(_ categoryIndex: Int) {
        let categoryValue = categoryIndex == 0 ? "all" : "\(categoryIndex)"
        let param:  [String : Any] =  [ "category": categoryValue ,
                                        "page": 1 ,
                                        "non_saved_category": true ]
        APIManager.shared.getBlogsForUserByCategoryAPI(param) { [weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response {
                //weak.blogCategoryResponse = response
            }
            print(message)
        }
    }
    
    //MARK: - getBloagsAndCategoryAPIV2 API Call
    func getBlogsAndCategoryAPIV2(cat: String?){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        let localeData = [ "category" : "\(cat ?? "")",
                           "page" : "0","shop_display": "shop"] as [String : Any]

        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        let systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        let iOS = "IOS"
        let userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: localeData, headers: headers, url: nil, service: .getBlogsForShop, method: .post, isJSONRequest: true).executeQuery { [self] (result: Result<BaseResponse<BlogDetailModel>, Error>) in
            switch result{
                
            case .success(let response):
                
                self.objBlogDetailModel.blogs = response.results.blogs
                    print("getBlogsForShop response: ",response)
                    self.blogCategoryResponse = response.results
                
                self.objBlogDetailModel.baseUrl = response.results.baseUrl ?? ""
                
                if self.objBlogDetailModel.categories.count == 0 {
                    self.objBlogDetailModel.categories = response.results.categories
                }
                
                  

                //'https://staging-api.woloo.in/api/blog/getBlogsForUserByCategory'
            case .failure(let error):
                print("getBlogsForShop error", error)
                
            }
            self.tableView.reloadData()
        }
    }
    
    fileprivate func likeDislikeBLOG(_ id: Int) {
        APIManager.shared.likeDislikeBLOGS(id) { [weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                weak.getBloagsAndCategoryAPI(weak.selectedCategory)
            }
            print(message)
        }
    }
    
     func likeDislikeBlogV2(_ id: Int){
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        print("UserAgent: \(userAgent)")
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        let data = ["blog_id": id]
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        NetworkManager(data: data, headers: headers, url: nil, service: .ctaLikes, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<ctaLikesModel>, Error>) in
            
            switch result {
            case .success(let response):
                Global.hideIndicator()
                print("CTA likes response: \(response)")
                self.getBlogsAndCategoryAPIV2(cat: "All")
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("CTA likes error: \(error)")
                
            }
        }
        
        
    }
    
    fileprivate func favouriteBLOG(_ id: Int) {
        APIManager.shared.FavouriteBLOGS(id) { [weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                weak.getBloagsAndCategoryAPI(weak.selectedCategory)
            }
            print(message)
        }
    }
    
     func favouriteBLOGV2(_ id: Int){
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        print("UserAgent: \(userAgent)")
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        let data = ["blog_id": id]
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        
        NetworkManager(data: data, headers: headers, url: nil, service: .ctaFavourite, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<ctaFavouriteModel>, Error>) in
            
            switch result{
                
            case .success(let response):
                Global.hideIndicator()
                print("CTA favourite response: \(response)")
                self.getBlogsAndCategoryAPIV2(cat: "All")
                
            case .failure(let error):
                Global.hideIndicator()
                print("CTA favourite error: \(error)")
                
                
            }
        }
        
        
    }
    
    fileprivate func thirstReminderYes() {
        let setFrequency = setFrequencyTextField.text
        let param:  [String : Any] =  [ "is_thirst_reminder": "1" ,
                                        "thirst_reminder_hours": setFrequency]
        APIManager.shared.thirstReminder(param) {[weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                weak.thirstReminderMainView.isHidden = true
                print(message)
                self!.showToast(message: message)
                
                // Local Notification
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Thirst reminder", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "It's time to drink water!", arguments: nil)
                content.sound = UNNotificationSound.default // Deliver the notification in five seconds.
                let setFrequencyTime =  60 * 60 * Int(setFrequency ?? "")!
                print(setFrequencyTime)
//                var setTimeInterval = Int(setFrequencyTime)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(setFrequencyTime), repeats: false)
                let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
                let center = UNUserNotificationCenter.current()
                center.add(request)
            }
        }
    }
    
    fileprivate func thirstReminderYesV2() {
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        let setFrequency = setFrequencyTextField.text
        let param:  [String : Any] =  [ "is_thirst_reminder": "1" ,
                                        "thirst_reminder_hours": setFrequency]
        
        NetworkManager(data: param, headers: headers, url: nil, service: .thirstReminder, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ThirstReminderModel>, Error>) in
            switch result{
            case .success(let response):
                print("Thirst reminder response: \(response)")
                self.thirstReminderMainView.isHidden = true
                self.showToast(message: "THIRST REMINDER SUCCESSFULLY ADDED !")
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
                param
                
                Global.addNetcoreEvent(eventname: self.netCoreEvents.thirstReminderClick, param: ["is_thirst_reminder": "1", "thirst_reminder_hours": setFrequency, "user_id": UserModel.user?.userId ?? 0, "platform": "iOS"])
                
            case .failure(let error):
                print("Error thirst reminder \(error)")
            }
        }
        
    }
    
    fileprivate func thirstReminderNo() {
        let param:  [String : Any] =  [ "is_thirst_reminder": "0" ,
                                        "thirst_reminder_hours": "0"]
        APIManager.shared.thirstReminder(param) {[weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                weak.thirstReminderMainView.isHidden = true
                print(message)
            }
        }
    }
    
    fileprivate func thirstReminderNoV2() {
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        let setFrequency = setFrequencyTextField.text
        let param:  [String : Any] =  [ "is_thirst_reminder": "0" ,
                                        "thirst_reminder_hours": "0"]
        
        NetworkManager(data: param, headers: headers, url: nil, service: .thirstReminder, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ThirstReminderModel>, Error>) in
            switch result{
            case .success(let response):
                print("Thirst reminder response: \(response)")
                DispatchQueue.main.async {
                    self.thirstReminderMainView.isHidden = true
                    
                    let center = UNUserNotificationCenter.current()
                    center.removeDeliveredNotifications(withIdentifiers: ["FiveSecond"])
                    center.removePendingNotificationRequests(withIdentifiers: ["FiveSecond"])
                }
                Global.addNetcoreEvent(eventname: self.netCoreEvents.thirstReminderClick, param: ["is_thirst_reminder": "0", "thirst_reminder_hours": 0, "user_id": UserModel.user?.userId ?? 0, "platform": "iOS"])
               // self.thirstReminderMainView.isHidden = true
                
            case .failure(let error):
                print("Error thirst reminder")
            }
        }
        
        
        
    }
    
    fileprivate func blogRead(index: Int) {
        let param:  [String : Any] =  [ "blog_id": index ]
        APIManager.shared.ctaBlogRead(param) {[weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                
            }
            print(message)
            self!.blogReadPoint(index: index)
        }
    }
    
    
     func blogReadV2(index: Int) {
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        print("UserAgent: \(userAgent)")
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        let data:  [String : Any] =  [ "blog_id": index ]
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        NetworkManager(data: data, headers: headers, url: nil, service: .ctaBlogRead, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<ctaBlogReadModel>, Error>) in
            switch result {
                
            case .success(let response):
                Global.hideIndicator()
                print("CTA Blog read response: \(response)")
                
                
                self.blogReadpointV2(index: index)
                
            case .failure(let error):
                Global.hideIndicator()
                print("CTA Blog read error: \(error)")
                
            }
        }
        
    }
    
     func blogReadpointV2(index: Int) {
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        print("UserAgent: \(userAgent)")
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        let data:  [String : Any] =  [ "blog_id": index ]
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        NetworkManager(data: data, headers: headers, url: nil, service: .blogReadPoint, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<ctaBlogReadModel>, Error>) in
            switch result {
                
            case .success(let response):
                Global.hideIndicator()
                print("CTA Blog read point response: \(response)")
//                let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
//                if let detailVC = trackerSB.instantiateViewController(withIdentifier: "BlogDetailViewController") as? BlogDetailViewController {
//                    detailVC.detailBLogLink = self.blogList[self.blogIndex ?? 0].detailedShortLink ?? ""
//                    detailVC.detailBlogTitle = self.blogList[self.blogIndex ?? 0].title ?? ""
//                    self.navigationController?.pushViewController(detailVC, animated: true)
                let objController = BlogDetailPopUpVC(nibName: "BlogDetailPopUpVC", bundle: nil)
                objController.delegate = self
                if self.objBlogDetailModel.blogs[self.blogIndex ?? 0].main_video?.count ?? 0 > 0{
                    objController.detailType = "VIDEO"
                }
                objController.objBlogModel = self.objBlogDetailModel.blogs[self.blogIndex ?? 0]
                objController.baseUrl = self.objBlogDetailModel.baseUrl
                
                self.navigationController?.pushViewController(objController, animated: true)
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("CTA Blog read point error: \(error)")
                
            }
        }
        
    }
    
    fileprivate func blogReadPoint(index: Int) {
        let param:  [String : Any] =  [ "blog_id": index ]
        APIManager.shared.blogReadPoint(param) {[weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                
            }
            print(message)
            let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
            if let detailVC = trackerSB.instantiateViewController(withIdentifier: "BlogDetailViewController") as? BlogDetailViewController {
                detailVC.detailBLogLink = self?.blogList[index].detailedShortLink ?? ""
                detailVC.detailBlogTitle = self?.blogList[index].title ?? ""
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    fileprivate func userJourneyAPI() {
        let param:  [String : Any] =  [ "event_name": "user Login" ,
                                        "event_data": "user"]
        APIManager.shared.userJourney(param) {[weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                
            }
            print(message)
        }
    }

     func openshare(_ id: Int) {
         
         let urlStr = self.objBlogDetailModel.blogs[id].detailedShortLink ?? ""
         let blogTitle = self.objBlogDetailModel.blogs[id].title ?? ""
         //let imageUrl = "\(API.environment.baseURL)public/blog/\(self.objBlogDetailModel.blogs[id].mainImage?[0] ?? "")"
       // let image = UIImage(contentsOfFile: imageUrl)
      //  let imageToShare = [image]
        let text = "\(blogTitle) \n\n\(urlStr)"
        let shareAll = [text as Any]
        let activityVC = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    
    //func fetchUserProfileV2(userID: Int){
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
                self.userModel = response.results.profile
                self.userCoins?.total_coins = response.results.totalCoins?.total_coins ?? 0
                print(" self.userCoins?.total_coins: \(response.results.totalCoins?.total_coins)")
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self.tableView.reloadData()

                
            case .failure(let error):
                print("User Profile error: ", error)
                
            }
        }
    }
    
    
    @objc func textDidChanged(_ textField: UITextField) {
        print("Hrs added: \(textField.text)")
        if textField.text == "0"{
            self.isZero = true
            print("can't enter 0 as hours")
        }
        else{
            self.isZero = false
        }
        
    }
}
