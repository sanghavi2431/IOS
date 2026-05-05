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
    func addressUpdated(objAddress: StoreAddress?)
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
    var cpylistProducts = [Products]()
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
        
        
        if Utility.isEmpty(self.objSelectedAddress.address_name ?? ""){
            self.lblAdressType.text = "Select Address"
            self.lblAddress.text = "Address not selected"
        }else{
            
            self.lblAdressType.text = objSelectedAddress.address_name ?? "Select Address"
            
            self.lblAddress.text = "\(objSelectedAddress.address_1 ?? "")\(objSelectedAddress.address_2 ?? ""),\(objSelectedAddress.city ?? ""),\(objSelectedAddress.province ?? "")\(objSelectedAddress.postal_code ?? "")"
        }
        
       
        
        
       
        
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
            self.objStoreHomePageViewModel.getProductListAPI()
        }
        else{
            self.objStoreHomePageViewModel.getProductListAPI()
        }
        self.objStoreHomePageViewModel.getCustomerInfo()
       
        if let savedAddress = UserDefaultsManager().getAddressFromUserDefaults() {
            self.objSelectedAddress = savedAddress
            self.lblAddress.text = "\(savedAddress.address_1 ?? "") \(savedAddress.address_2 ?? ""), \(savedAddress.city ?? ""), \(savedAddress.province ?? "") \(savedAddress.postal_code ?? "")"
            self.lblAdressType.text = savedAddress.address_name ?? ""
        }
        
        self.collectionview.reloadData()
        
        }
    
    //MARK: - Button action methods
    
    @IBAction func clickedFilterBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            
            let objController = AdvanceFilterPopUpVC(nibName: "AdvanceFilterPopUpVC", bundle: nil)
            objController.delegate = self
            objController.listProducts = self.cpylistProducts
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
