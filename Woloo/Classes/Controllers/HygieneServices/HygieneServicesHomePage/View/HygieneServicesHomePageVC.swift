//
//  HygieneServicesHomePageVC.swift
//  Woloo
//
//  Created by CEPL on 26/04/25.
//

import UIKit
import STPopup

class HygieneServicesHomePageVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwBackTxtField: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var vwCartCountBack: UIView!
    @IBOutlet weak var lblCartCount: UILabel!
    
    
    @IBOutlet weak var lblAdressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var vwBack: UIView!
    
    var listServicesCategories = [StoreProductCategories]()
    var objHygieneServicesHomeViewModel = HygieneServicesHomeViewModel()
    var categoriesVideosList: [TakeSneakPeekServiceItem] = []
    var listProducts = [Products]()
    var cpyListProducts = [Products]()
    var newBrandList = [Products]()
    var listPeriodessentials = [StoreProductCategories]()
    var listFilterCategories = [StoreProductCategories]()
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
    var listNewInStores = [StoreProductCategories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }


    func  loadInitialSettings() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.objHygieneServicesHomeViewModel.delegate = self
        self.objEditProfileViewModel.delegate = self
        
        self.btnCart.layer.cornerRadius = self.btnCart.frame.size.width / 2
        self.vwCartCountBack.layer.cornerRadius = 8.5
        self.vwCartCountBack.clipsToBounds = true
        
        self.objHygieneServicesHomeViewModel.getProductCategoriesListAPI()
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
            //objController.delegate = self
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
