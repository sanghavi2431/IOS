//
//  StoreHomePageVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 29/01/25.
//

import UIKit
import STPopup

class StoreHomePageVC: UIViewController {

    @IBOutlet weak var vwBackTxtField: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwCartCountBack: UIView!
    @IBOutlet weak var lblCartCount: UILabel!
    
    
    @IBOutlet weak var lblAdressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var vwBack: UIView!
    
    
    var showAllProductList:Bool? = false
    var objStoreHomePageViewModel = StoreHomePageViewModel()
    var listProductCategories = [StoreProductCategories]()
    var listProducts = [Products]()
    var cpyListProducts = [Products]()
    var newBrandList = [Products]()
    var listPeriodessentials = [StoreProductCategories]()
    var objCustomerInfo = CustomerCreate()
    var objEditProfileViewModel = EditProfileViewModel()
    var objUserProfile = UserProfileModel.Profile()
    var objSelectedAddress = StoreAddress()
    var objCartItems = CreateCartDetails()
    var listCartItems = [CartItems]()
    var listWishList = CreateCustomerWishList()
    var listLikedWishList = [Products]()
    var lisBrand = [ProductCollection]()
    var cpyLisBrand = [ProductCollection]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }
    
  
    func loadInitialSettings(){
        
//        DispatchQueue.main.async{
//            let objController = ServicesPopUpVC(nibName: "ServicesPopUpVC", bundle: nil)
//            objController.delegate = self
//            let popup = STPopupController(rootViewController: objController)
//            popup.present(in: self)
//        }
           
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.objEditProfileViewModel.delegate = self
        self.btnCart.layer.cornerRadius = self.btnCart.frame.size.width / 2
        self.vwCartCountBack.layer.cornerRadius = 8.5
        self.vwCartCountBack.clipsToBounds = true
        
        self.objStoreHomePageViewModel.delegate = self
        let strMail = "\(UserDefaultsManager.fetchUserMob())@gmail.com"
        
        print("home screen user password: \(UserDefaultsManager.fetchShopPassword())")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Code to execute after a 0.3 second delay
            self.objStoreHomePageViewModel.emailPassAPI(strMail: strMail, strPwd: "\(UserDefaultsManager.fetchShopPassword())")
        }
        
        
        self.objStoreHomePageViewModel.getProductListAPI()
        self.objStoreHomePageViewModel.getProductCategoriesListAPI()
        self.objStoreHomePageViewModel.getCartListingsAPI()
        self.objStoreHomePageViewModel.getBrandCollectionList()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl
        self.objStoreHomePageViewModel.getCustomerInfo()
        
       // self.objStoreHomePageViewModel.getCustomerWishListAPICall()
        }
    
    @objc func refreshData() {
        // Update your data here
        self.objStoreHomePageViewModel.getProductListAPI()
        self.objStoreHomePageViewModel.getProductCategoriesListAPI()
        self.objStoreHomePageViewModel.getCartListingsAPI()
        self.objStoreHomePageViewModel.getBrandCollectionList()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    @IBAction func clickedBtnOpenSearch(_ sender: UIButton) {
        let objController = StoreSearchViewController.init(nibName: "StoreSearchViewController", bundle: nil)
       
        objController.listAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
        objController.objSelectedAddress = self.objSelectedAddress
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    @IBAction func clickedBtnCart(_ sender: Any) {
        
        if self.objCartItems.items?.count ?? 0 == 0{
            
            let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                
            objController.isComeFrom = "EmptyCart"
            //objController.delegate = self
          
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
        }
        else{
            let objController = StoreShopCartVC.init(nibName: "StoreShopCartVC", bundle: nil)
            objController.delegate = self
            objController.listAddress = self.objCustomerInfo.addresses ??  [StoreAddress]()
            objController.objSelectedAddress = self.objSelectedAddress
            self.navigationController?.pushViewController(objController, animated: true)
        }
    }
    
    
    @IBAction func clickedAddressDropdown(_ sender: UIButton) {
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
