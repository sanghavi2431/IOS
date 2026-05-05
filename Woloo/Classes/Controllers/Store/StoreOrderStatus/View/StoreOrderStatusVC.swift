//
//  StoreOrderStatusVC.swift
//  Woloo
//
//  Created by CEPL on 12/05/25.
//

import UIKit
import STPopup

class StoreOrderStatusVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnHelpAndSupport: UIButton!
    
    var objProduct = Products()
    var objOrderListings = OrderListings()
    
    var objOrderSets = OrderSets()
    var objOrder = Orders()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadInitialSettings()
    }
    
   
    
    func loadInitialSettings(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.btnHelpAndSupport.layer.cornerRadius = 5.0
        if let items = objOrderListings.items {
            objOrderListings.items = items.filter { $0.id != objProduct.id }
        }
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func clickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickedHelpAndSupportBtn(_ sender: UIButton) {
        let objController = HelpAndSupportPopUpVC(nibName: "HelpAndSupportPopUpVC", bundle: nil)
        let popup = STPopupController(rootViewController: objController)

        objController.strOrder = self.objOrder.id ?? ""
        
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
    }
    
}
