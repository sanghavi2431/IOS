//
//  HygieneServicesHomePageVC.swift
//  Woloo
//
//  Created by CEPL on 26/04/25.
//

import UIKit

class HygieneServicesHomePageVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }


    func  loadInitialSettings() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

}
