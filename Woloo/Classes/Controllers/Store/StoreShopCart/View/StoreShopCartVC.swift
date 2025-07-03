//
//  StoreShopCartVC.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit
import STPopup
import Razorpay

protocol StoreShopCartVCDelegate: NSObject{
    func didUpdatedCart()
    
}

class StoreShopCartVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwBottom: ShadowView!
    
    
    var objStoreShopCartViewModel = StoreShopCartViewModel()
    var objCartItems = CreateCartDetails()
    weak var delegate: StoreShopCartVCDelegate?
    var listAddress = [StoreAddress]()
    var objSelectedAddress = StoreAddress()
    var razorpay: RazorpayCheckout!
    var objShippingOptions = [ShippingOptions]()
    var objSelectShippingOption = CreateCartDetails()
    var objPaymentProviderWrapper = PaymentProviderWrapper()
    var objPaymentCollectionId = PaymentCollections()
    var objCalculateShippingOption = ShippingOptions()
    var objPaymentSessionID:  String? = ""
    var objUserCoinModel = UserCoinModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }


    func loadInitialSettings() {
        print("Shop Token: ", UserDefaultsManager.fetchUserShopRegisterToken())
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.objStoreShopCartViewModel.delegate = self
        
        self.getUserCoinsV2()
        Global.showIndicator()
        self.vwBottom.isHidden = true
        self.tableView.isHidden = true
        self.objStoreShopCartViewModel.getCartListingsAPI()
        self.objStoreShopCartViewModel.setShippingAndBillingAddressAPI(strCartId: UserDefaultsManager.fetchUserCartID(), objAddress: self.objSelectedAddress)
        
        self.objStoreShopCartViewModel.getShippingOptions(strCartId: UserDefaultsManager.fetchUserCartID())
        
        
        
        self.objStoreShopCartViewModel.getPaymentProviders(strRegionID: "reg_01JPH693TAM20TXZEJNBJ5QBV4")
        
        razorpay = RazorpayCheckout.initWithKey(UserDefaultsManager.fetchAppConfigData()?.RZ_CRED?.key ?? "", andDelegateWithData: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @IBAction func clickedBackBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedCheckOutBtn(_ sender: UIButton) {
        
//        self.objStoreShopCartViewModel.paymentSessionsAPI(strPayCollectionID: self.objPaymentCollectionId.id ?? "", strProviderId: self.objPaymentProviderWrapper.payment_providers?[0].id ?? "")
        
        let objController = OrderSummaryPopUpVC(nibName: "OrderSummaryPopUpVC", bundle: nil)
        objController.delegate = self
        objController.objCartItems = self.objCartItems
        objController.listAddress = self.listAddress
        objController.objSelectedAddress = self.objSelectedAddress
        let popup = STPopupController(rootViewController: objController)
        popup.style = .bottomSheet
        popup.present(in: DELEGATE.window?.rootViewController ?? self)
        
        
    }
    
    func getUserCoinsV2(){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(headers: headers, url: nil, service: .userCoins, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<UserCoinModel>, Error>) in
            switch result {
                
            case .success(let response):
                print("User coins Output: \(response)")
                self.objUserCoinModel = response.results
                
                self.tableView.reloadData()
                
                
            case .failure(let error):
                print("User coins error: ", error)
            }
        }
        
    }
    
}

