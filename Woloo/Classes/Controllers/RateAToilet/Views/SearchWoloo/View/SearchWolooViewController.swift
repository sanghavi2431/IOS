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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }

    
    func loadInitialSettings(){
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        self.didSearchWoloo(strQuery: textField.text ?? "")
    }
    
    func didSearchWoloo(strQuery: String?){
        self.objSearchWolooViewModel.searchWoloo(strQuery: strQuery ?? "", page: 1)
    }
    
    @IBAction func clickedBackbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
}
