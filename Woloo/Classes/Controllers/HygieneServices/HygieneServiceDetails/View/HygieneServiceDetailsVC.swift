//
//  HygieneServiceDetailsVC.swift
//  Woloo
//
//  Created by CEPL on 23/07/25.
//

import UIKit

class HygieneServiceDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwBackBtn: UIView!
    @IBOutlet weak var btnAddToCart: ShadowViewButton!
    @IBOutlet weak var lblVariant: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    
    var objProduct = Products()
    var listAddress = [StoreAddress]()
    var objSelectedAddress = StoreAddress()
    var objCustomerWishList = CreateCustomerWishList()
    var strProductID: String?
    var listProductReviews = [ProductReview]()
    var selectedOptions: [String: String] = [:]
    var listProducts = [Products]()
    var objHygieneServiceDetailsViewModel = HygieneServiceDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettigs()
    }


    func loadInitialSettigs(){
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.vwBackBtn.layer.cornerRadius = 5.26
        self.objHygieneServiceDetailsViewModel.delegate = self
        
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
        
        if !Utility.isEmpty(objProduct.id ?? ""){
            self.objHygieneServiceDetailsViewModel.getProductReviews(strProductID: objProduct.id ?? "")
        }
        
        if Utility.isEmpty(self.objProduct.categories?.first?.id ?? ""){
            self.objHygieneServiceDetailsViewModel.getProductListOnCategoryID(strCategoryId: "pcat_01JPH87GB9WK1QFCPD52MMSR9Y")
        }
        else{
            self.objHygieneServiceDetailsViewModel.getProductListOnCategoryID(strCategoryId: self.objProduct.categories?.first?.id ?? "")
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
    
    @IBAction func clickedBuyNowBtn(_ sender: UIButton) {
        
    }
}
