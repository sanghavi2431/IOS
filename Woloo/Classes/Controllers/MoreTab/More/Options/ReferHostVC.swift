//
//  ReferHostVC.swift
//  Woloo
//
//  Created on 22/06/21.
//

import UIKit

class ReferHostVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    var isAddOptionShow = false
    
    var storeList = [WolooStore]()
    var storeListV2 = [EnrouteListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        
//            DELEGATE.rootVC?.tabBarVc?.showTabBar()
//            DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
//            DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
    
    }
    private func setupUI() {
      //referWolooListAPI()
        referWolooListAPIV2()
        setupTableView()
    }
    
    
    @IBAction func clickedBtnGetStarted(_ sender: UIButton) {
        self.addhostAction()
    }
}
// MARK: - @IBAction
extension ReferHostVC {
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addhostAction() {
            let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "BecomeHostFormVC") as? BecomeHostFormVC
            vc?.isReferHost = true
            self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
}

// MARK: - UITableViewDelegate / UITableViewDataSource
extension ReferHostVC: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        tableView.register(UINib(nibName: Cell.referHostCell, bundle: nil), forCellReuseIdentifier: Cell.referHostCell)
        tableView.register(UINib(nibName: "AddHostCell", bundle: nil), forCellReuseIdentifier: "AddHostCell")
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return section == 0 ?  1 : storeListV2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {// AddHostCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddHostCell", for: indexPath) as? AddHostCell else { return UITableViewCell() }
           // cell.lblReferWoloo.text = "\(AppConfig.getAppConfigInfo()?.customMessage?.wolooReferHostText ?? "")\n\nYou can refer only upto 3 Host."
            cell.addWolooAction = {
                self.addhostAction()
            }
            if isAddOptionShow {
                //cell.addButttonHeight.constant = 50
            } else {
              //  cell.addButttonHeight.constant = 0
            }
          //  cell.layoutIfNeeded()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.referHostCell, for: indexPath) as? ReferHostCell else { return UITableViewCell() }
            //fillCell(cell,indexPath)
            fillCellV2(cell, indexPath)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - TableviewCell Handler
extension ReferHostVC {
    private func fillCell(_ cell: ReferHostCell,_ indexPath: IndexPath) {
        let dict = self.storeList[indexPath.row]
        cell.wolooStore = dict
    }
    
    private func fillCellV2(_ cell: ReferHostCell, _ indexPath: IndexPath) {
        let dict = self.storeListV2[indexPath.row]
        cell.wolooStoreV2 = dict
    }
    
}

// MARK: - API Calling
extension ReferHostVC {
    func referWolooListAPI() {
        Global.showIndicator()
        APIManager.shared.recommedWolooListAPI { [weak self] (response, message) in
            Global.hideIndicator()
            guard let self = self else { return }
            if response != nil {
                self.storeList = response?.stores ?? []
//                if self.storeList.count >= 3 {
//                    self.isAddOptionShow = true
//                }
                let ar = self.storeList.filter({$0.status == 0})
                self.isAddOptionShow = ar.count < 3
                self.tableView.reloadData()
            }
            print(message)
        }
    }
    
    func referWolooListAPIV2(){
         
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild ?? "")")
        
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(headers: headers,url: nil, service: .userRecommendWoloo, method: .post, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<[EnrouteListModel]>, Error>) in
            switch result{
            case .success(let response):
                Global.hideIndicator()
                print("User reccomend woloo: ", response)
                
                if response != nil {
                    self.storeListV2 = response.results
                    let ar = self.storeListV2.filter({$0.status == 0})
                    self.isAddOptionShow = ar.count < 3
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                Global.hideIndicator()
                print("Error user recommend Woloo: ", error)
                
            }
        }
    }
}
