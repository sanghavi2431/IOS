//
//  ShopCheckoutPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 10/03/25.
//

import UIKit

protocol ShopCheckoutPopUpVCDelegate: NSObjectProtocol {
    
    func didClickedReviewOrder()
}

class ShopCheckoutPopUpVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ShopCheckoutPopUpVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }


    func loadInitialSettings(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)
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
    
    @IBAction func clickedBtnReviewOrder(_ sender: UIButton) {
        if self.delegate != nil {
            self.delegate?.didClickedReviewOrder()
            self.dismiss(animated: true)
        }
    }
    
}
