//
//  StoreShowAllProductVC.swift
//  Woloo
//
//  Created by CEPL on 07/03/25.
//

import UIKit
import STPopup

protocol StoreShowAllProductVCDelegate: NSObject{
    func didChangeValues()
}

class StoreShowAllProductVC: UIViewController {

    @IBOutlet weak var vwBackTxtField: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var vwCartCountBack: UIView!
    @IBOutlet weak var lblCartCount: UILabel!
    @IBOutlet weak var vwBackFilter: ShadowView!
    
    @IBOutlet weak var lblAdressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var listProducts = [Products]()
    var objBrands = ProductCollection()
    var objStoreShowAllProductViewModel = StoreShowAllProductViewModel()
    var strIsComeFrom: String? = ""
    var objStoreProductCategories = StoreProductCategories()
    var listCategories = [StoreProductCategories]()
    var objSelectedAddress = StoreAddress()
    var objCustomerInfo = CustomerCreate()
    var objStoreHomePageViewModel = StoreHomePageViewModel()
    var objCartItems = CreateCartDetails()
    var listCartItems = [CartItems]()
    var delegate: StoreShowAllProductVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
        print("listCategories count", self.listCategories.count)
    }

    func loadInitialSettings(){
           
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.objStoreHomePageViewModel.delegate = self
        self.objStoreShowAllProductViewModel.delegate = self
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        self.btnCart.layer.cornerRadius = self.btnCart.frame.size.width / 2
        
        self.vwBackFilter.layer.cornerRadius = self.vwBackFilter.frame.size.width / 2
        
        self.vwCartCountBack.layer.cornerRadius = 8.5
        self.vwCartCountBack.clipsToBounds = true
        
        self.collectionview.register(StoreMostPurchaseCollectionCell.nib, forCellWithReuseIdentifier: StoreMostPurchaseCollectionCell.identifier)
        self.collectionview.register(StoreBlankHeaderCollectionCell.nib, forCellWithReuseIdentifier: StoreBlankHeaderCollectionCell.identifier)
        self.collectionview.register(AllProductsCollectionCell.nib, forCellWithReuseIdentifier: AllProductsCollectionCell.identifier)
        
        //AllProductsCollectionCell
        if self.strIsComeFrom == "BRANDS"{
            self.objStoreShowAllProductViewModel.getProductListAPI(strCollectionId: self.objBrands.id ?? "")
        }
        else if self.strIsComeFrom == "CATEGORIES"{
            self.objStoreShowAllProductViewModel.getCategoriesProductListAPI(strCategoryId: self.objStoreProductCategories.id ?? "")
        }
        else if self.strIsComeFrom == "FAVOURITES"{
            self.objStoreHomePageViewModel.getCartListingsAPI()
        }
        else{
            self.objStoreHomePageViewModel.getProductListAPI()
        }
        self.objStoreHomePageViewModel.getCustomerInfo()
       
        self.collectionview.reloadData()
        
        }
    
    //MARK: - Button action methods
    
    @IBAction func clickedFilterBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            
            let objController = AdvanceFilterPopUpVC(nibName: "AdvanceFilterPopUpVC", bundle: nil)
           // objController.delegate = self
            objController.listCategories = self.listCategories
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
        
    }
    
    @IBAction func clickedBtnCart(_ sender: Any) {
        let objController = StoreShopCartVC.init(nibName: "StoreShopCartVC", bundle: nil)
        objController.delegate = self
        objController.listAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
        objController.objSelectedAddress = self.objSelectedAddress
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    @IBAction func clickedBtnAddress(_ sender: UIButton) {
        let objController = SelectAdressPopUpViewController(nibName: "SelectAdressPopUpViewController", bundle: nil)
        objController.delegate = self
        objController.objAddress = self.objSelectedAddress
        objController.objSelectedAddress = self.objSelectedAddress
        objController.listAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
        let popup = STPopupController(rootViewController: objController)
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
        
        
    }
    
    @IBAction func clickedBtnOpenSearch(_ sender: UIButton) {
        let objController = StoreSearchViewController.init(nibName: "StoreSearchViewController", bundle: nil)
       
        objController.listAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
        objController.objSelectedAddress = self.objSelectedAddress
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
}
