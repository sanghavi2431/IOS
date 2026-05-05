//
//  StoreShowAllBrandVC.swift
//  Woloo
//
//  Created by CEPL on 15/04/25.
//

import UIKit
import STPopup


protocol StoreShowAllBrandVCDelegate: NSObjectProtocol {
    func addressUpdated(objAddress: StoreAddress?)
    
}

class StoreShowAllBrandVC: UIViewController{
   

   
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var vwCartCountBack: UIView!
    @IBOutlet weak var lblCartCount: UILabel!
    @IBOutlet weak var lblAdressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var listBrands = [ProductCollection]()
    var listAddress = [StoreAddress]()
    var objSelectedAddress = StoreAddress()
    var objStoreHomePageViewModel = StoreHomePageViewModel()
    var objCartItems = CreateCartDetails()
    var listCartItems = [CartItems]()
    var objCustomerInfo = CustomerCreate()
    var listCategories = [StoreProductCategories]()
    weak var delegate: StoreShowAllBrandVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }

    func loadInitialSettings(){
           
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        self.btnCart.layer.cornerRadius = self.btnCart.frame.size.width / 2
        
        
        self.lblCartCount.text = "\(self.objCartItems.items?.count ?? 0)"
        self.vwCartCountBack.layer.cornerRadius = 8.5
        self.vwCartCountBack.clipsToBounds = true
        self.objStoreHomePageViewModel.delegate = self
        if Utility.isEmpty(self.objSelectedAddress.address_name ?? ""){
            self.lblAdressType.text = "Select Address"
            self.lblAddress.text = "Address not selected"
        }else{
            
            self.lblAdressType.text = objSelectedAddress.address_name ?? "Select Address"
            
            self.lblAddress.text = "\(objSelectedAddress.address_1 ?? "")\(objSelectedAddress.address_2 ?? ""),\(objSelectedAddress.city ?? ""),\(objSelectedAddress.province ?? "")\(objSelectedAddress.postal_code ?? "")"
        }
        self.objStoreHomePageViewModel.getCustomerInfo()
        self.objStoreHomePageViewModel.getCartListingsAPI()
        
        self.collectionview.register(StoreBrandCollectionViewCell.nib, forCellWithReuseIdentifier: StoreBrandCollectionViewCell.identifier)
        self.collectionview.register(StoreBlankHeaderCollectionCell.nib, forCellWithReuseIdentifier: StoreBlankHeaderCollectionCell.identifier)
        self.collectionview.register(AllProductsCollectionCell.nib, forCellWithReuseIdentifier: AllProductsCollectionCell.identifier)
        
        //AllProductsCollectionCell
        if let savedAddress = UserDefaultsManager().getAddressFromUserDefaults() {
            self.objSelectedAddress = savedAddress
            self.lblAddress.text = "\(savedAddress.address_1 ?? "") \(savedAddress.address_2 ?? ""), \(savedAddress.city ?? ""), \(savedAddress.province ?? "") \(savedAddress.postal_code ?? "")"
            self.lblAdressType.text = savedAddress.address_name ?? ""
        }
        
        self.collectionview.reloadData()
        
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
}
