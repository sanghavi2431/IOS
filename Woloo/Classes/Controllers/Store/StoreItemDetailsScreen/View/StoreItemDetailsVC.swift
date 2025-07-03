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
    
    
    
    
    var objProduct = Products()
    var objStoreItemDetailViewModel = StoreItemDetailViewModel()
     weak var delegate: StoreItemDetailsVCDelegate?
    var listAddress = [StoreAddress]()
    var objSelectedAddress = StoreAddress()
    var objCustomerWishList = CreateCustomerWishList()
    var strProductID: String?
    var listProductReviews = [ProductReview]()
    
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
            self.objStoreItemDetailViewModel.getStoreItemDetails(strProductID: strProductID ?? "")
            self.objStoreItemDetailViewModel.getProductReviews(strProductID: strProductID)
        }
       
        
        
        if !Utility.isEmpty(objProduct.id ?? ""){
            self.objStoreItemDetailViewModel.getProductReviews(strProductID: objProduct.id ?? "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
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
