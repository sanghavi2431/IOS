//
//  BookmarkedVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 19/11/24.
//

import UIKit

class BookmarkedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listNearByLoos = [NearbyResultsModel]()
    var listBookmarkedLoos = [NearbyResultsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }


    func loadInitialSettings(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.listBookmarkedLoos = listNearByLoos.filter { $0.is_liked == 1 }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
    }

    
    //MARK: - Button action methods
    
    @IBAction func clickedBackButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
