//
//  SayItWithWolooDetailVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 05/02/25.
//

import UIKit

class SayItWithWolooDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var imgSelected: UIImage?
    var strMessage: String? = ""
    var objAddMessageModel = AddMessageModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }

    func loadInitialSettings(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
    @IBAction func clickedBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
