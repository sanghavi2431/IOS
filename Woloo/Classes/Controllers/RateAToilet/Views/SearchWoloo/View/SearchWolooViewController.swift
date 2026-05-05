//
//  SearchWolooViewController.swift
//  Woloo
//
//  Created by CEPL on 07/06/25.
//

import UIKit

protocol SearchWolooViewControllerDelegate: NSObjectProtocol {
    func didSelectSearchedWoloos(objSearchWoloo: SearchWoloo?)
}

class SearchWolooViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtFieldSearchWoloo: UITextField!
    
    var objSearchWolooViewModel = SearchWolooViewModel()
    var listSearchWoloo = [SearchWoloo]()
    var delegate: SearchWolooViewControllerDelegate?
    
    // Pagination variables
    var currentPage = 1
    var isMoreDataExist = false
    var isLoading = false
    var currentSearchQuery: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }

    
    func loadInitialSettings(){
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        self.objSearchWolooViewModel.delegtae = self
        self.txtFieldSearchWoloo.delegate = self
        self.txtFieldSearchWoloo.addTarget(self, action: #selector(textDidChangedWoloo(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func textDidChangedWoloo(_ textField: UITextField) {
        print("Search for", textField.text ?? "")
        let query = textField.text ?? ""
        
        // Reset pagination for new search
        if query != currentSearchQuery {
            currentSearchQuery = query
            currentPage = 1
            isMoreDataExist = false
            listSearchWoloo.removeAll()
            tableView.reloadData()
        }
        
        self.didSearchWoloo(strQuery: query)
    }
    
    func didSearchWoloo(strQuery: String?){
        guard !isLoading else { return }
        
        isLoading = true
        Global.showIndicator()
        self.objSearchWolooViewModel.searchWoloo(strQuery: strQuery, page: currentPage, lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, long: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829)
    }
    
    func loadMoreData() {
        guard !isLoading && isMoreDataExist else { return }
        
        currentPage += 1
        didSearchWoloo(strQuery: currentSearchQuery)
    }
    
    @IBAction func clickedBackbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
}
