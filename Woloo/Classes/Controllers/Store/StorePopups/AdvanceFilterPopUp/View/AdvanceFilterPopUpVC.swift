//
//  AdvanceFilterPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 17/04/25.
//

import UIKit

class AdvanceFilterPopUpVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listCategories = [StoreProductCategories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
        print("list categories count: ", self.listCategories.count)
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
}


