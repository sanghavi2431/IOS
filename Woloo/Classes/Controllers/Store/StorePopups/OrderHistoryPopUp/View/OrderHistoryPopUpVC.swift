//
//  OrderHistoryPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 02/07/25.
//

import UIKit

protocol OrderHistoryPopUpVCDelegate: NSObject{
    func didClickedCheckStatus(objorders: Orders?, objOrderSet: OrderSets?)
    func didClickedAddRating(objProducts: OrderItem?)
}

class OrderHistoryPopUpVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    var objOrderSets = OrderSets()
    // 🔽 Place this here
        var flattenedOrderItems: [OrderItem] {
            return objOrderSets.orders?.flatMap { $0.items ?? [] } ?? []
        }
    weak var delegate: OrderHistoryPopUpVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.85)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }


}
