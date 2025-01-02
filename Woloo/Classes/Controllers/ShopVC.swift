//
//  ShopVC.swift
//  Woloo
//
//  Created on 03/08/21.
//

import UIKit

class ShopVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DELEGATE.rootVC?.tabBarVc?.hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DELEGATE.rootVC?.tabBarVc?.showTabBar()
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
