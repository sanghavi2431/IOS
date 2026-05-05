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
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var searchListProducts = [Products]()
    var objStoreSearchViewModel = StoreSearchViewModel()
    var listAddress = [StoreAddress]()
    var objSelectedAddress = StoreAddress()
    var listCartItems = [CartItems]()
    var recentSearchProducts = [Products]()
    var strSearch: String? = ""
    
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
        self.recentSearchProducts = UserDefaultsManager().getRecentSearchesFromUserDefaults()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.register(StoreRecentSearchCollectionCell.nib, forCellWithReuseIdentifier: StoreRecentSearchCollectionCell.identifier)
        collectionView.register(StoreMostPurchaseCollectionCell.nib, forCellWithReuseIdentifier: StoreMostPurchaseCollectionCell.identifier)
        
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "CollectionHeaderView")
        self.txtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.collectionView.reloadData()
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.strSearch = textField.text ?? ""
        if Utility.isEmpty(textField.text ?? ""){
            self.tableView.isHidden = true
            self.searchListProducts = [Products]()
        }
        else{
            self.tableView.isHidden = false
            
        }
        self.objStoreSearchViewModel.getSearchProductListAPI(strSearchText: textField.text ?? "")
    }

    @IBAction func clickedBtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
