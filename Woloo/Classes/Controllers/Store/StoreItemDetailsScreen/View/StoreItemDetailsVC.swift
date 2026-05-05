//
//  StoreItemDetailsVC.swift
//  Woloo
//
//  Created by CEPL on 05/03/25.
//

import UIKit
import STPopup

protocol StoreItemDetailsVCDelegate: NSObjectProtocol{
    func didPartItemUpdated()
    
    func didWishListUpdated()
}

class StoreItemDetailsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwBackBtn: UIView!
    @IBOutlet weak var btnAddToCart: ShadowViewButton!
    @IBOutlet weak var lblVariant: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    @IBOutlet weak var vwShopBtn: UIView!
    
    
    
    
    
    var objProduct = Products()
    var objStoreItemDetailViewModel = StoreItemDetailViewModel()
     weak var delegate: StoreItemDetailsVCDelegate?
    var listAddress = [StoreAddress]()
    var objSelectedAddress = StoreAddress()
    var objCustomerWishList = CreateCustomerWishList()
    var strProductID: String?
    var listProductReviews = [ProductReview]()
    var selectedOptions: [String: String] = [:]
    var listProducts = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadInitialSettings()
    }
    
    
    func loadInitialSettings(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.objStoreItemDetailViewModel.delegate = self
        self.vwBackBtn.layer.cornerRadius = 5.26
        self.vwShopBtn.layer.cornerRadius = 5.26
        
        self.lblPrice.text = String(format: "%@%d/-","\u{20B9}",self.objProduct.variants?[0].calculated_price?.calculated_amount ?? 0)
        let originalAmount = self.objProduct.variants?.first?.calculated_price?.original_amount ?? 0
        self.lblVariant.text = self.objProduct.variants?.first?.options?.first?.value ?? ""
        
        
        let priceText = String(format: "MRP \u{20B9}%d/-", originalAmount)

        let attributedString = NSAttributedString(
            string: priceText,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            ]
        )

        self.lblOriginalPrice.attributedText = attributedString
        
        
        
        if !Utility.isEmpty(strProductID ?? ""){
            Global.showIndicator()
            
            self.tableView.isHidden = true
            self.vwShopBtn.isHidden = false
            self.objStoreItemDetailViewModel.getStoreItemDetails(strProductID: strProductID ?? "")
            self.objStoreItemDetailViewModel.getProductReviews(strProductID: strProductID)
        }
        else{
            if self.objProduct.variants?.first?.inventory_quantity == 0{
                self.btnAddToCart.isUserInteractionEnabled = false
                self.btnAddToCart.setTitle("Out of Stock", for: .normal)
                self.btnAddToCart.setTitle("Out of Stock", for: .highlighted)
                self.btnAddToCart.setTitle("Out of Stock", for: .selected)
                self.btnAddToCart.backgroundColor = UIColor.white
            }
            else{
                self.btnAddToCart.isUserInteractionEnabled = true
                self.btnAddToCart.setTitle("Add to Cart", for: .normal)
                self.btnAddToCart.setTitle("Add to Cart", for: .highlighted)
                self.btnAddToCart.setTitle("Add to Cart", for: .selected)
                self.btnAddToCart.backgroundColor = UIColor(named: "Woloo_Yellow")
            }
            
            if Utility.isEmpty(self.objProduct.categories?.first?.id ?? ""){
                self.objStoreItemDetailViewModel.getProductListOnCategoryID(strCategoryId: "pcat_01JPH87GB9WK1QFCPD52MMSR9Y")
            }
            else{
                self.objStoreItemDetailViewModel.getProductListOnCategoryID(strCategoryId: self.objProduct.categories?.first?.id ?? "")
            }
            
            if let savedAddress = UserDefaultsManager().getAddressFromUserDefaults() {
                self.objSelectedAddress = savedAddress
            }
            
           
        }
        if !Utility.isEmpty(objProduct.id ?? ""){
            self.objStoreItemDetailViewModel.getProductReviews(strProductID: objProduct.id ?? "")
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    @IBAction func clickedShopBtn(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    @IBAction func clickedBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func clickedAddToCartBtn(_ sender: UIButton) {
//        let objController = ShopCartPopUpVC(nibName: "ShopCartPopUpVC", bundle: nil)
//        objController.delegate = self
//        let popup = STPopupController(rootViewController: objController)
//        popup.style = .bottomSheet
//        popup.present(in: DELEGATE.window?.rootViewController ?? self)
//    }
    
    @IBAction func clickedBuyNowBtn(_ sender: UIButton) {
        
        self.objStoreItemDetailViewModel.addItemsToCart(strVariantID: self.objProduct.variants?[0].id ?? "", quantity: 1)
    }
}
