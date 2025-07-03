//
//  MyAccountVC.swift
//  Woloo
//
//  Created by Vivek shinde on 21/12/20.
//

import UIKit

class MyAccountVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var userCoins = ProfileUserCoins()
    var coinHistory = [HistoryModel?]()
    var coinHistoryV2 = [HistoryModelV2?]()
    var coinHistoryModel = CoinHistoryModel()
    var coinHistoryModelV2 = CoinHistoryModelV2()
    var netcoreEvents = NetcoreEvents()
    var tempCount = 5
    var pageNumber = 1
    
    var objUserCoinModel = UserCoinModel()
    
   override func viewDidLoad() {
        super.viewDidLoad()
//        fatalError()
//        let app = AppConfig.getAppConfigInfo()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
        pageNumber = 1
      //  getUserCoin()
        //getCoinHistory(param: ["pageNumber": pageNumber])
        getCoinHistoryV2(param: ["pageIndex": pageNumber])
        
        Global.addFirebaseEvent(eventName: "my_account_click", param: [:])
        Global.addNetcoreEvent(eventname: self.netcoreEvents.myAccountClick, param: [:])
//        DELEGATE.rootVC?.tabBarVc?.showTabBar()
//        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
        self.getUserCoinsV2()
    }
}

extension MyAccountVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return coinHistoryV2.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountCell", for: indexPath) as? MyAccountCell ?? MyAccountCell()
//            var totCoin = 0
//            if userCoins.totalCoins != nil {
//                totCoin = userCoins.totalCoins ?? 0
//            }
            cell.lblWolooPoints.text = "\(self.objUserCoinModel.totalCoins ?? 0)"
//            var giftCoins = 0
//            if userCoins.giftCoins != nil {
//                giftCoins = userCoins.giftCoins ?? 0
//            }
            cell.lblGiftPoints.text = "\(self.objUserCoinModel.totalGiftCoins ?? 0)"
          cell.btnShop.addTarget(self, action: #selector(openShopTab(sender:)), for: .touchUpInside)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistroyCell", for: indexPath) as! HistroyCell
            cell.delegate = self
            cell.configureUI()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryDataCell", for: indexPath) as? HistoryDataCell ?? HistoryDataCell()
//            guard let histData = coinHistory[indexPath.row] else { return cell }
            guard let histDataV2 = coinHistoryV2[indexPath.row] else {return cell}
            
            if histDataV2.is_gift == 1 {
                cell.lblPoints.text = " \(histDataV2.value ?? "")"//\u{20B9}
                cell.lblPointsStatic.text = "INR"
            } else {
                cell.lblPoints.text = histDataV2.value
                cell.lblPointsStatic.text = "Points"
            }
            
//            if histData.isGift == 1 {
//                cell.lblPoints.text = " \(histData.value ?? "")"//\u{20B9}
//                cell.lblPointsStatic.text = "INR"
//            } else {
//                cell.lblPoints.text = histData.value
//                cell.lblPointsStatic.text = "Points"
//            }
            
            //cell.fillDataforDescription(histData)
            
            cell.fillDataforDescriptionV2(histDataV2)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss"
            let date = dateFormatter.date(from: histDataV2.created_at ?? "") ?? Date()
            dateFormatter.dateFormat = "dd MMMM"
            cell.lblDate.text =  dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MMMM yyyy"
            cell.lblHeaderDate.text =  dateFormatter.string(from: date)
            if indexPath.row == 0 {
                cell.headerHeight.constant = 40
            } else {
                //let histDataOld = coinHistory[indexPath.row - 1]
                let histDataOldV2 = coinHistoryV2[indexPath.row - 1]
                
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss"
                let cdate = dateFormatter.date(from: histDataOldV2?.created_at ?? "") ?? Date()
                dateFormatter.dateFormat = "MMMM yyyy"
                let monthName = dateFormatter.string(from: cdate)
                if monthName == cell.lblHeaderDate.text {
                    cell.headerHeight.constant = 5
                } else {
                    cell.headerHeight.constant = 40
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let histData = coinHistory[indexPath.row]
//        if coinHistory[indexPath.row]?.isGift == 1 && ((coinHistory[indexPath.row]?.sender) != nil) && histData?.type != "Add Coins" {
//            Global.addFirebaseEvent(eventName: "point_detail_click", param: ["points_id":coinHistory[indexPath.row]?.id ?? "0"])
//
//            Global.addNetcoreEvent(eventname: self.netcoreEvents.pointDetailClick, param: ["points_id":coinHistory[indexPath.row]?.id ?? "0"])
//
//            let vc = UIStoryboard.init(name: "MyAccount", bundle: Bundle.main).instantiateViewController(withIdentifier: "GiftCardDetailVC") as? GiftCardDetailVC
//            vc?.coinHistory = coinHistory[indexPath.row] ?? HistoryModel()
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
        
        let histDataV2 = coinHistoryV2[indexPath.row]
        if coinHistoryV2[indexPath.row]?.is_gift == 1 && ((coinHistoryV2[indexPath.row]?.sender) != nil) && histDataV2?.type != "Add Coins" {
            Global.addFirebaseEvent(eventName: "point_detail_click", param: ["points_id":coinHistoryV2[indexPath.row]?.id ?? "0"])
            
            Global.addNetcoreEvent(eventname: self.netcoreEvents.pointDetailClick, param: ["points_id":coinHistoryV2[indexPath.row]?.id ?? "0"])
//            
//            let vc = UIStoryboard.init(name: "MyAccount", bundle: Bundle.main).instantiateViewController(withIdentifier: "GiftCardDetailVC") as? GiftCardDetailVC
//            vc?.coinHistory = coinHistory[indexPath.row] ?? HistoryModel()
//            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
  
    @objc func openShopTab(sender: UIButton) {
    
        Global.addNetcoreEvent(eventname: self.netcoreEvents.shopClick, param: [:])
//        Global.addFirebaseEvent(eventName: "shop_click", param: [:])
//        let shopeSB = UIStoryboard(name: "Shop", bundle: nil)
//        let shopeVC = shopeSB.instantiateViewController(withIdentifier: "ShopVC")
//        navigationController?.pushViewController(shopeVC, animated: true)
//
        let shopeSB = UIStoryboard(name: "Shop", bundle: nil)
        if let shopeVC = shopeSB.instantiateViewController(withIdentifier: "ECommerceDashboardViewController") as? ECommerceDashboardViewController {
            self.navigationController?.pushViewController(shopeVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if coinHistoryModel.totalCount ?? 0 > coinHistory.count {
                //getCoinHistory(param: ["pageNumber": pageNumber])
                
                getCoinHistoryV2(param: ["pageIndex": pageNumber])
            }
        }
    }
    
}

extension MyAccountVC : HistroyCellDelegate{
    func earningHistroyBtnPressedDelegate(_ sender: UIButton) {
        tempCount = 20
        self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
    func subscriptionBtnPressedDelegate(_ sender: UIButton) {
        tempCount = 5
        self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
}
// MARK: - API
extension MyAccountVC {
    func getUserCoin() {
        UserModel.apiMoreProfileDetails { (response) in
            if let result = response {
                DispatchQueue.main.async {
                    if let coins = result.totalCoins {
                        self.userCoins = coins
                    }
                    self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: .none)
                    //                    self.moreDetail?.userCoin = result
                    //                    self.updateProfileData()
                }
            }
        }
    }
    
    
    func getUserCoinsV2(){
        
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
        
        NetworkManager(headers: headers, url: nil, service: .userCoins, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<UserCoinModel>, Error>) in
            switch result {
                
            case .success(let response):
                print("User coins Output: \(response)")
                self.objUserCoinModel = response.results
                self.tableView.reloadData()
                
                
            case .failure(let error):
                print("User coins error: ", error)
            }
        }
        
    }
    
    
    func getCoinHistory(param:[String:Any]){
        APIManager.shared.getUserCoinsHistory(param:param) { (response, message) in
            if let result = response {
                DispatchQueue.main.async {
                    self.coinHistoryModel = result
                    if result.history?.count ?? 0 > 0 && self.pageNumber != 1 {
                        self.coinHistory.append(contentsOf: result.history ?? [])
                    } else {
                        self.coinHistory = result.history ?? []
                    }
                    self.pageNumber = self.pageNumber + 1
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getCoinHistoryV2(param: [String: Any]){
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
     
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        var data = param
        
        
        NetworkManager(data: data, headers: headers, url: nil, service: .coinHistory, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<CoinHistoryModelV2>, Error>) in
            switch result {
                
            case .success(let response):
                Global.hideIndicator()
                print("Coin history response: \(response)")
                DispatchQueue.main.async {
                    self.coinHistoryModelV2 = response.results
                    if response.results.history?.count ?? 0 > 0 && self.pageNumber != 1 {
                        self.coinHistoryV2.append(contentsOf: response.results.history ?? [])
                    } else {
                        self.coinHistoryV2 = response.results.history ?? []
                    }
                    self.pageNumber = self.pageNumber + 1
                    self.tableView.reloadData()
                    
                }
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("Coin History error: \(error)")
            }
        }
    }
    
}
