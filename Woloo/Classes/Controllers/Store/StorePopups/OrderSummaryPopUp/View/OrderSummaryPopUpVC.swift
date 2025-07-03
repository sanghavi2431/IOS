//
//  OrderSummaryPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import UIKit

protocol OrderSummaryPopUpVCDelegate: NSObjectProtocol{
    func didClickedPayViaBtn()
    func didClickedEditAddressCartBtn(objAddress: StoreAddress?)
    
    func didChangePaymentType()
}

class OrderSummaryPopUpVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var objCartItems = CreateCartDetails()
    var listAddress = [StoreAddress]()
    var objSelectedAddress = StoreAddress()
    weak var delegate: OrderSummaryPopUpVCDelegate?
    var objOrderSummaryPopUpViewModel = OrderSummaryPopUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.objOrderSummaryPopUpViewModel.delegate = self
        
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.85)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func clickedPayViaBtn(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didClickedPayViaBtn()
            self.dismiss(animated: true)
        }
        
    }
}
