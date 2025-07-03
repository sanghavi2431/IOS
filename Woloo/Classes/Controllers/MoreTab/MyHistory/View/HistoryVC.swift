//
//  HistoryVC.swift
//  Woloo
//
//  Created on 25/04/21.
//

import UIKit

class HistoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataImage: UIView!
    
    var historyResponse: WolooRewardHistoryResponse?
    var historyData = [WolooHistory]()
    var pageNumber = 1
    var isMoreDataExist = false
    
    var objMyHistoryViewModel = MyHistoryViewModel()
    
    var objHistory = MyHistory()
    var objHistoryData = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isMoreDataExist = true
        self.self.objMyHistoryViewModel.delegate = self
        self.getHistoryAPICall()
       //getHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
//        DELEGATE.rootVC?.tabBarVc?.showTabBar()
//        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
//        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
    }
    
    func setupUI() {
        setupTableView()
    }
    
    func getHistoryAPICall(){
       // Global.showIndicator()
        self.objMyHistoryViewModel.myHistoryAPI(pageNumber: 1)
    }
}

// MARK: - @IBAction
extension HistoryVC {
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension HistoryVC : UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func setupTableView() {
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.objHistoryData.count == 0 {
            noDataImage.isHidden = false
        } else {
            noDataImage.isHidden = true
        }
        return self.objHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: HistoryTableCell? = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell") as! HistoryTableCell?
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("HistoryTableCell", owner: self, options: nil)?.last as? HistoryTableCell)
        }
        cell?.configureHistoryTableCell(objhistory: self.objHistoryData[indexPath.row])
        cell?.delegateHistory = self
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if  indexPath.row == lastRowIndex  {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            spinner.startAnimating()
            self.tableView.tableFooterView = spinner
            return
        }
        self.tableView.tableFooterView = nil
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if historyData.count == 0 {
            return
        }
        if isMoreDataExist { // Call API
            self.pageNumber += 1
            self.getHistory()
        }
    }
}
// MARK: - API
extension HistoryVC: MyHistoryViewModelDelegate, HistoryTableCellDelegate {
  
    //MARK: - HistoryTableCellDelegate
    func didClickedNavigate(obj: History) {
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.destLat = Double(obj.woloo_details.lat ?? "")
        objController.destLong = Double(obj.woloo_details.lng ?? "")
        objController.strIsComeFrom = "Navigation"
        objController.strDestination = "\(obj.woloo_details.name  ?? "")"
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    //MARK: - MyHistoryViewModelDelegate
    func didReceiveMyHistoryResponse(objResponse: BaseResponse<MyHistory>) {
        Global.hideIndicator()
        self.objHistory = objResponse.results
        self.objHistoryData = objResponse.results.history
        self.tableView.reloadData()
    }
    
    func didReceiceMyHistoryError(strError: String) {
        Global.hideIndicator()
       // Global.showAlert(title: "Message", message: strError)
    }
    
    //MARK: - MyHistoryViewModelDelegate
    
    
    
    func getHistory() {
        if isMoreDataExist {
            APIManager.shared.getWolooRewardHistory(param: ["pageNumber":"\(self.pageNumber)"]) { [weak self] (response, message) in
                guard let self = self else { return }
                if let response = response {
                    self.historyResponse = response
                    if response.history?.count == 0 || response.history == nil && self.pageNumber == 1 {
                        self.tableView.isHidden = response.history == nil
                        self.isMoreDataExist = false
                        return
                    } else if (response.history?.count ?? 0) == 0 || response.history  == nil {
                        self.isMoreDataExist = false
                        self.tableView.reloadData()
                        return
                    }
                    self.historyData.append(contentsOf: response.history ?? [])
                    self.isMoreDataExist = true
                    self.tableView.reloadData()
                    return
                }
                
                print(message)
            }
        }
    }
    
    
    
}

// MARK: - Other Controller Handling.
extension HistoryVC {
    func openReviewScreen(_ store: WolooStore) {
        if let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC {
            reviewVC.wolooStore = store
            self.navigationController?.pushViewController(reviewVC, animated: true)
        }
    }
}
