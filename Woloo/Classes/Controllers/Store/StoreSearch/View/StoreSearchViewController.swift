//
//  StoreSearchViewController.swift
//  Woloo
//
//  Created by Kapil Dongre on 30/01/25.
//

import UIKit

class StoreSearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var vwBackTxtField: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var searchListProducts = [Products]()
    var objStoreSearchViewModel = StoreSearchViewModel()
    var listAddress = [StoreAddress]()
    var objSelectedAddress = StoreAddress()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }

    func loadInitialSettings(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.txtField.delegate = self
        self.objStoreSearchViewModel.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.txtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        self.objStoreSearchViewModel.getSearchProductListAPI(strSearchText: textField.text ?? "")
    }

    @IBAction func clickedBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
