//
//  PeriodInfoVC.swift
//  Woloo
//
//  Created by ideveloper2 on 30/10/21.
//

import UIKit

class PeriodInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: false) {
            self.view.backgroundColor = UIColor.clear
        }
    }
}
