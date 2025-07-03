//
//  SayItWithWolooVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 20/01/25.
//

import UIKit
import KNContactsPicker

class SayItWithWolooVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var objAddMessageModel = AddMessageModel()
    var selectedImg: UIImage?
    var imgName: String? = ""
    
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
