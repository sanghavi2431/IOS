//
//  StoreOrderDetailsVC.swift
//  Woloo
//
//  Created by CEPL on 08/03/25.
//

import UIKit
import STPopup

class StoreOrderDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var objStoreOrderDetailsViewModel = StoreOrderDetailsViewModel()
    let refreshControl = UIRefreshControl()
    
    var objStoreItems = [OrderSets]()
    var orderId: String? = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // self.loadInitialSettings()
    }

    func loadInitialSettings(){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.objStoreOrderDetailsViewModel.delegate = self
//        
//        self.objStoreOrderDetailsViewModel.getOrderListingAPI(strOrderID:  UserDefaultsManager.fetchOrderID())
        Global.showIndicator()
        self.objStoreOrderDetailsViewModel.getOrderListingAPI(strOrderID: "")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadInitialSettings()
    }
    
    @objc func refreshData() {
        // Update your data here
        self.objStoreOrderDetailsViewModel.getOrderListingAPI(strOrderID: "")
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func clickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
}
