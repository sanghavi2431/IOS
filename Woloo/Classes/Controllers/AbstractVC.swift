//
//  AbstractVC.swift
//  Woloo
//
//  Created by Ashish Khobragade on 28/12/20.
//

import UIKit

class AbstractVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonUI()
    }

    func configureCommonUI()  {
        self.navigationController?.navigationBar.setNavigationCenterImage(image: "logo")
    }
}
