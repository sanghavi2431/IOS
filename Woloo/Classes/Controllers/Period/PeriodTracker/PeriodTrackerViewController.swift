//
//  PeriodTrackerViewController.swift
//  Woloo
//
//  Created on 26/07/21.
//

import UIKit

class PeriodTrackerViewController: UIViewController, DailyLogViewControllerDelegate {
  
    @IBOutlet var trackerTableView: UITableView!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var nextButtonHeightConstraint70: NSLayoutConstraint!
    
    //var isFromDashBoard = false
    var dateInCalender = Date()
    var allTrackerInfo = [UserTrackerInfo]()
    var objBlogDetailModel = BlogDetailModel()
    var allTrackerInfov2 = [ViewPeriodTrackerModel]()
    
    private var toggleHandler: (() -> Void)?
    private var selectedLogCategory = DailyLogInfo()
    
    private var periodTrackerSection = PeriodTrackerSection.allCases
    private var blogList = [BlogModel]()
    var blogIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getPeriodTrackerAPIV2()
        //getPeriodTrackerAPI()
        //getBloagsAndCategoryAPI()
        getBlogsAndCategoryAPIV2()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        DELEGATE.rootVC?.tabBarVc?.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private var blogCategoryResponse: BlogDetailModel? {
        didSet {
            self.blogList = blogCategoryResponse?.blogs ?? []
            self.trackerTableView.reloadSections(IndexSet(integer: PeriodTrackerSection.blogs.rawValue), with: .automatic)
        }
    }

    /// Configure UI.
    private func setupUI() {
        setupTableView()
        nextButtonHeightConstraint70.constant = 0//isFromDashBoard ? 0 : 70
        dateTitleLabel.text = "Today, \(Date().convertDateToString("MMMM yyyy"))"
    }
    
    // MARK: - @Objc and @IBAction's
    
    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func toogleCalenderButton(_ sender: Any) {
        toggleHandler?()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        openTopicScreen()
    }
    
    
    
    //MARK: - DailyLogViewControllerDelegate
    func didCalledSetPeriodTrackerAPI() {
        setupUI()
        //getPeriodTrackerAPI()
        //getBloagsAndCategoryAPI()
        getPeriodTrackerAPIV2()
        getBlogsAndCategoryAPIV2()
    }
    
    
}

// MARK: - UITableViewDelegate/ UITableViewDataSource
extension PeriodTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Setup Tableview operations.
    private func setupTableView() {
        trackerTableView.delegate = self
        trackerTableView.dataSource = self
        trackerTableView.rowHeight = UITableView.automaticDimension
        trackerTableView.register(UINib(nibName: TrackerCalenderCell.identifier, bundle: nil), forCellReuseIdentifier: TrackerCalenderCell.identifier)
        trackerTableView.register(UINib(nibName: Cell.trackeLogListCell, bundle: nil), forCellReuseIdentifier: Cell.trackeLogListCell)
        trackerTableView.register(UINib(nibName: Cell.trendingListCell, bundle: nil), forCellReuseIdentifier: Cell.trendingListCell)
        trackerTableView.register(UINib(nibName: Cell.blogDetailCell, bundle: nil), forCellReuseIdentifier: Cell.blogDetailCell)
        trackerTableView.register(UINib(nibName: Cell.articleListCell, bundle: nil), forCellReuseIdentifier: Cell.articleListCell)
        trackerTableView.register(UINib(nibName: Cell.periodCalenderCell, bundle: nil), forCellReuseIdentifier: Cell.periodCalenderCell)
        trackerTableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        periodTrackerSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch periodTrackerSection[section] {
        case .blogs:
            return blogList.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch PeriodTrackerSection.allCases[indexPath.section] {
        case .calenders:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrackerCalenderCell.identifier, for: indexPath) as? TrackerCalenderCell ?? TrackerCalenderCell()
            // When click on navigation bar right button
            toggleHandler = {
                cell.toogleButton?()
                tableView.reloadData()
            }
            //cell.allMonthtrackerInfo = self.allTrackerInfo
            cell.allMonthtrackerInfoV2 = self.allTrackerInfov2
            cell.monthChange = { [weak self] in
                guard let weak = self else { return }
                if Date().convertDateToString("MMMM yyyy") == cell.calenderView.currentPage.convertDateToString("MMMM yyyy") {
                    weak.dateTitleLabel.text = "Today, \(cell.calenderView.currentPage.convertDateToString("MMMM yyyy"))"
                } else {
                    weak.dateTitleLabel.text = "\(cell.calenderView.currentPage.convertDateToString("MMMM yyyy"))"
                }
                weak.dateInCalender = cell.calenderView.currentPage
                tableView.reloadData()
            }
            return cell
        case .circularView:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.periodCalenderCell, for: indexPath) as? PeriodCalenderCell ?? PeriodCalenderCell()
            cell.circularView.delegate = self
            cell.infoHandler = { [weak self] in
                guard let weak = self else { return }
                print("Period Info")
                weak.openPeriodInfoVC()
            }
            
//            let value = allTrackerInfo.first?.periodDate ?? ""
//            let valueSet = "Your last period cycle ended on \(value), You are currently in Ovulation phase."
//            cell.lastPeriodDateLabel.text = valueSet
            
            //          cell.setData(allTrackerInfo[indexPath.row])
            
            cell.allMonthtrackerInfoV2 = self.allTrackerInfov2
            //cell.allMonthtrackerInfo = self.allTrackerInfo //.filter({$0.periodDate?.toDate().get(.month) == Date().get(.month)})
            //cell.setDays()
            cell.setDaysV2()
            return cell
        case .dailyLogs:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.trackeLogListCell, for: indexPath) as? TrackeLogListCell ?? TrackeLogListCell()
            cell.selectedCategories = selectedLogCategory
            cell.righButtonHandle = { [weak self] in
                guard let weak = self else { return }
                weak.openDailyLogScreen()
            }
            return cell
        case .article:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.articleListCell, for: indexPath) as? ArticleListCell ?? ArticleListCell()
            return cell
        case .blogs:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.blogDetailCell, for: indexPath) as? BlogDetailCell ?? BlogDetailCell()
            cell.setData(blogList[indexPath.row])
            
            [cell.shareButton, cell.likeButton, cell.favouriteButton].forEach { button in
                button?.tag = indexPath.row
            }

            // Handle All Action
            cell.handleActionForLike = { [unowned self] index in
                let selectedBlogLike = self.blogList[indexPath.row]
                //self.likeDislikeBLOG(selectedBlogLike.id ?? 0)
                self.likeDislikeBlogV2(selectedBlogLike.id ?? 0)
            }
        
            cell.handleActionForFavourite = { [unowned self] index in
                let selectedBlogFav = self.blogList[indexPath.row]
                //self.favouriteBLOG(selectedBlogFav.id ?? 0)
                self.favouriteBLOGV2(selectedBlogFav.id ?? 0)
            }

            cell.handleActionForShare = { index in // Share action
                self.openshare(index)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch periodTrackerSection[indexPath.section] {
        case .blogs:
            openBlogDetailVC(index: indexPath.row)
        default:
            break
        }
    }
}

// MARK: - Handle Other Controllers
extension PeriodTrackerViewController {

    fileprivate func openBlogDetailVC(index: Int) {
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
    
    private func openPeriodInfoVC() {
        let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let periodInfoVC = trackerSB.instantiateViewController(withIdentifier: "PeriodInfoVC") as? PeriodInfoVC {
            periodInfoVC.modalPresentationStyle = .overCurrentContext
            periodInfoVC.view.isOpaque = false
            self.present(periodInfoVC, animated: true,completion: {
                periodInfoVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })
        }
    }
    
    private func openTopicScreen() {
        let topicSB = UIStoryboard(name: "Authentication", bundle: nil)
        if let topicVC = topicSB.instantiateViewController(withIdentifier: "IntrestedTopicVC") as? IntrestedTopicVC {
            navigationController?.pushViewController(topicVC, animated: true)
        }
    }
    
    private func openDailyLogScreen() {
        let topicSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let logVC = topicSB.instantiateViewController(withIdentifier: "DailyLogViewController") as? DailyLogViewController {
            logVC.delegate = self
            logVC.selectedCategory = selectedLogCategory
            logVC.trackerInfo = allTrackerInfov2.first
            logVC.handleSelectedCategory = { [weak self] category in
                guard let weak = self else { return }
                if let dailyLog = category {
                    weak.selectedLogCategory = dailyLog
                }
                self?.trackerTableView.reloadData()
            }
            navigationController?.pushViewController(logVC, animated: true)
        }
    }
    
    private func editCycleScreen() {
        let editCycleSB = UIStoryboard(name: "Tracker", bundle: nil)
        if let editCycleVc = editCycleSB.instantiateViewController(withIdentifier: "EditCycleViewController") as? EditCycleViewController {
            if let tf = allTrackerInfov2.first {
                editCycleVc.selectedDate = tf.periodDate?.toDate()
                editCycleVc.cycleLength = tf.cycleLength ?? 28
                editCycleVc.periodLength = tf.periodLength ?? 4
                editCycleVc.loginfo = tf.log
            }
            editCycleVc.isEditScreen = true
            editCycleVc.handleEditCycle = { [weak self] (info) in
                guard let weak = self else { return }
                weak.make3monthCyclev2(info)
                weak.trackerTableView.reloadData()
            }
            navigationController?.pushViewController(editCycleVc, animated: true)
        }
    }
    
}

// MARK: - PeriodCalendarViewDelegate
extension PeriodTrackerViewController: PeriodCalendarViewDelegate {
    func onEdit() { // open editCycleScreen
        editCycleScreen()
    }
}

// MARK: - API's Calling
extension PeriodTrackerViewController {
    
    private func getBloagsAndCategoryAPI() {
        let param:  [String : Any] =  [ "category": "all" ,
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
    fileprivate func getBlogsAndCategoryAPIV2(){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        let localeData = [ "category" : "all",
                           "page" : "1"] as [String : Any]

        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        let systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        let iOS = "IOS"
        let userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: localeData, headers: headers, url: nil, service: .getBlogsForUserByCategory, method: .post, isJSONRequest: true).executeQuery { [self] (result: Result<BaseResponse<BlogDetailModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("getBlogsForUserByCategory response: ",response)
                blogCategoryResponse = response.results
                self.trackerTableView.reloadSections(IndexSet(integer: PeriodTrackerSection.blogs.rawValue), with: .automatic)
                //'https://staging-api.woloo.in/api/blog/getBlogsForUserByCategory'
            case .failure(let error):
                print("getBlogsForUserByCategory error", error)
                
            }
        }
    }
    
    fileprivate func likeDislikeBLOG(_ id: Int) {
        APIManager.shared.likeDislikeBLOGS(id) { [weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
            }
            print(message)
        }
    }
    
    
    
    fileprivate func likeDislikeBlogV2(_ id: Int){
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
                self.getBlogsAndCategoryAPIV2()
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("CTA likes error: \(error)")
                
            }
        }
        
        
    }
    
    fileprivate func favouriteBLOGV2(_ id: Int){
        
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
                self.getBlogsAndCategoryAPIV2()
                
            case .failure(let error):
                Global.hideIndicator()
                print("CTA favourite error: \(error)")
                
                
            }
        }
        
        
    }
    
    fileprivate func favouriteBLOG(_ id: Int) {
        APIManager.shared.FavouriteBLOGS(id) { [weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
            }
            print(message)
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
    
    fileprivate func openshare(_ id: Int) {
        let urlStr = blogList[id].detailedBlogLink ?? ""
        let blogTitle = blogList[id].title ?? ""
        let text = "\(blogTitle) \n\n\(urlStr)"
        let myWebsite = NSURL(string: "")
        let shareAll = [text, myWebsite as Any]
        let activityVC = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func getPeriodTrackerAPIV2(){
            
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
                    self.selectedLogCategory = response.results.dailyLogData ?? DailyLogInfo()
                    self.make3monthCyclev2(response.results)
                    self.trackerTableView.reloadData()
                   
                    
                case .failure(let error):
                    Global.hideIndicator()
                    print("View periodTracker API failed: ", error)
                }
            }
    }
    
    fileprivate func blogReadV2(index: Int) {
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
                self.blogReadpointV2(index: self.blogList[self.blogIndex ?? 0].id ?? 0)
                
            case .failure(let error):
                Global.hideIndicator()
                print("CTA Blog read error: \(error)")
                
            }
        }
        
    }
    
    
    fileprivate func blogReadpointV2(index: Int) {
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
                let trackerSB = UIStoryboard(name: "Tracker", bundle: nil)
                if let detailVC = trackerSB.instantiateViewController(withIdentifier: "BlogDetailViewController") as? BlogDetailViewController {
                    detailVC.detailBLogLink = self.blogList[self.blogIndex ?? 0].detailedShortLink ?? ""
                    detailVC.detailBlogTitle = self.blogList[self.blogIndex ?? 0].title ?? ""
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("CTA Blog read point error: \(error)")
                
            }
        }
        
    }
    
    private func getPeriodTrackerAPI() {
        APIManager.shared.getPeriodTracker { [weak self] (trackerInfo, message) in
            guard let weak = self else { return }
            if let info = trackerInfo {
                weak.selectedLogCategory = info.dailyLogData ?? DailyLogInfo()
                print(info.toJSONString() ?? "")
                weak.make3monthCycle(info)
            }
            print(message)
        }
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.trackerTableView.reloadData()
        }
        
    }
    
//    /// Make Cycle for next 3 month based on first Period tracker.
//    /// - Parameter trackerInfo: **UserTrackerInfo**
    private func make3monthCycle(_ trackerInfo: UserTrackerInfo) {
        self.allTrackerInfo.removeAll()
        self.allTrackerInfo.append(trackerInfo) //add original object
        
        var newObject = trackerInfo
        if let oldStartDate = trackerInfo.periodDate?.toDate() {
            var dayComponent    = DateComponents()
            dayComponent.day    = trackerInfo.cycleLength ?? 28
            let theCalendar     = Calendar.current
            if let newStartDate = theCalendar.date(byAdding: dayComponent, to: oldStartDate) {
                newObject.periodDate = newStartDate.convertDateToString("yyyy-MM-dd")
                self.allTrackerInfo.append(newObject)
                
                if let newStartDate2 = theCalendar.date(byAdding: dayComponent, to: newStartDate) {
                    newObject.periodDate = newStartDate2.convertDateToString("yyyy-MM-dd")
                    self.allTrackerInfo.append(newObject)
                }
                
                
            }
        }
        trackerTableView.reloadData()
    }
    
    private func make3monthCyclev2(_ trackerInfo: ViewPeriodTrackerModel?) {
        self.allTrackerInfo.removeAll()//add original object
        self.allTrackerInfov2.append(trackerInfo ?? ViewPeriodTrackerModel())
        
        var newObject = trackerInfo
        if let oldStartDate = trackerInfo?.periodDate?.toDate() {
            var dayComponent    = DateComponents()
            dayComponent.day    = trackerInfo?.cycleLength ?? 28
            let theCalendar     = Calendar.current
            if let newStartDate = theCalendar.date(byAdding: dayComponent, to: oldStartDate) {
                newObject?.periodDate = newStartDate.convertDateToString("yyyy-MM-dd")
                self.allTrackerInfov2.append(newObject ?? ViewPeriodTrackerModel())
                
                if let newStartDate2 = theCalendar.date(byAdding: dayComponent, to: newStartDate) {
                    newObject?.periodDate = newStartDate2.convertDateToString("yyyy-MM-dd")
                    self.allTrackerInfov2.append(newObject ?? ViewPeriodTrackerModel())
                }
                
                
            }
        }
        trackerTableView.reloadData()
    }
    
    /// Make Cycle for next 6 months based on the first Period tracker.
    /// - Parameter trackerInfo: **UserTrackerInfo**
    /// Make Cycle from the first period date until the current date and for the next 6 months.
    /// - Parameter trackerInfo: **UserTrackerInfo**
//    private func make3monthCycle(_ trackerInfo: UserTrackerInfo) {
//        self.allTrackerInfo.removeAll()
//        self.allTrackerInfo.append(trackerInfo) // Add the original object
//        
//        var newObject = trackerInfo
//        if let oldStartDate = trackerInfo.periodDate?.toDate() {
//            let dayComponent = DateComponents(day: trackerInfo.cycleLength ?? 28)
//            let theCalendar = Calendar.current
//            var currentStartDate = oldStartDate
//            let currentDate = Date()
//            
//            // Generate cycles until the current date
//            while currentStartDate <= currentDate {
//                if let newStartDate = theCalendar.date(byAdding: dayComponent, to: currentStartDate) {
//                    newObject.periodDate = newStartDate.convertDateToString("yyyy-MM-dd")
//                    self.allTrackerInfo.append(newObject)
//                    currentStartDate = newStartDate
//                }
//            }
//            
//            // Generate cycles for the next 6 months from the current date
//            for _ in 1...3 {
//                if let newStartDate = theCalendar.date(byAdding: dayComponent, to: currentStartDate) {
//                    newObject.periodDate = newStartDate.convertDateToString("yyyy-MM-dd")
//                    self.allTrackerInfo.append(newObject)
//                    currentStartDate = newStartDate
//                }
//            }
//        }
//        
//        trackerTableView.reloadData()
//    }


}
