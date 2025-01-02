//
//  MyOfferVC.swift
//  Woloo
//
//  Created on 25/04/21.
//

import UIKit

class MyOfferVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataImage: UIView!
    
    var offerResponse: NearByStoreResponse?
    var offerData = [WolooStore]()
    var pageNumber = 1
    var isMoreDataExist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        userJourneyAPI()
        isMoreDataExist = true
      // getHistory()
    }
    
    func setupUI() {
        setupTableView()
    }
}

// MARK: - @IBAction
extension MyOfferVC {
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyOfferVC : UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
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
        if offerData.count == 0 {
            noDataImage.isHidden = false
        } else {
            noDataImage.isHidden = true
        }
        return offerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell ?? HistoryCell()
        let dict = self.offerData[indexPath.row]
        cell.fillOfferDetail(dict)
        return cell
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
        if offerData.count == 0 {
            return
        }
        if isMoreDataExist { // Call API
            self.pageNumber += 1
            self.getHistory()
        }
    }
}
// MARK: - API
extension MyOfferVC {
    
    func getHistory() {
        if isMoreDataExist {
            APIManager.shared.getMyOffer(param: ["pageNumber":"\(self.pageNumber)"]) { [weak self] (response, message) in
                guard let self = self else { return }
                if let response = response {
                    self.offerResponse = response
                    if response.stores?.count == 0 || response.stores == nil && self.pageNumber == 1 {
                        self.tableView.isHidden = response.stores == nil
                        self.isMoreDataExist = false
                        return
                    } else if (response.stores?.count ?? 0) == 0 || response.stores  == nil {
                        self.isMoreDataExist = false
                        self.tableView.reloadData()
                        return
                    }
                    self.offerData.append(contentsOf: response.stores ?? [])
                    self.isMoreDataExist = true
                    self.tableView.reloadData()
                    return
                }
                
                print(message)
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
}

// MARK: - Other Controller Handling.
extension MyOfferVC {
    func openReviewScreen(_ store: WolooStore) {
        if let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC {
            reviewVC.wolooStore = store
            self.navigationController?.pushViewController(reviewVC, animated: true)
        }
    }
}
