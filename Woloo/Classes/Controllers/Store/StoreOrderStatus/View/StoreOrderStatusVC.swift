//
//  StoreOrderStatusVC.swift
//  Woloo
//
//  Created by CEPL on 12/05/25.
//

import UIKit

class StoreOrderStatusVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var objProduct = Products()
    var objOrderListings = OrderListings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadInitialSettings()
    }
    
   
    
    func loadInitialSettings(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        
        if let items = objOrderListings.items {
            objOrderListings.items = items.filter { $0.id != objProduct.id }
        }
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func clickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
