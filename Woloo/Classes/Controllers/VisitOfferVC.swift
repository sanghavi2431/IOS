//
//  VisitOfferVC.swift
//  Woloo
//
//  Created on 13/08/21.
//

import UIKit

class VisitOfferVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: false) {
            self.view.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        dismiss(animated: false) {
            self.view.backgroundColor = UIColor.clear
            DELEGATE.rootVC?.tabBarVc?.selectedIndex = 2
        }
    }
}
