//
//  ECartViewController.swift
//  Woloo
//
//  Created by Rahul Patra on 03/08/21.
//

import UIKit
import Razorpay

class ECartViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var deliveryAddressButton: UIButton!
    @IBOutlet weak var selectedDelieveryAddressLabel: UILabel!
    
    @IBOutlet weak var selectAddressRadioButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var pickupStoreRadioButton: UIButton!
    @IBOutlet weak var pickupStoreLabel: UILabel!
    @IBOutlet weak var pickupStoreButton: UIButton!
    @IBOutlet weak var pickupStoreStack: UIStackView!
    
    //MARK:- Variables
    var persistance: ECartPersistance? = ECartPersistance()
    var razorPay: RazorpayCheckout!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        pickupStoreStack.isHidden = true
        
        setViews()
        getProfileData()
        getShippingCharges()
        getAddresses()
        getCouponsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainTableView.reloadData()
        persistance?.setData()
    }
    
    //MARK:- Custom functions
    func setViews() {
        let zipCode = UserDefaults.standard.value(forKey: "zip_code") as? String ?? ""
        selectedDelieveryAddressLabel.text = "Ship to: \(zipCode) (Select Address)"
        selectAddressRadioButton.tintColor = UIColor(named: "Woloo_Yellow")
        mainTableView.register(CartTableViewCell.loadNib(), forCellReuseIdentifier: "CartTableViewCell")
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        deliveryAddressButton.addTarget(self, action: #selector(tapDeliveryAddressButton), for: .touchUpInside)
        checkoutButton.addTarget(self, action: #selector(tapCheckoutButton), for: .touchUpInside)
        persistance?.footerView?.applyCoupenCodeButton.addTarget(self, action: #selector(tappedOnApplyButton), for: .touchUpInside)
        
        pickupStoreButton.addTarget(self, action: #selector(tapPickupStoreButton), for: .touchUpInside)
        
        persistance?.footerView?.minusCouponButton.addTarget(self, action: #selector(tappedOnMinusButton), for: .touchUpInside)
        
        changeTotal()
    }
    
    func getAddresses() {
        persistance?.getAddressList{ [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.selectedDelieveryAddressLabel.text = self.persistance?.selectedAddress?.getAddress ?? ""
                if self.persistance?.selectedAddress == nil {
                    //                    self.selectAddressRadioButton.setImage(UIImage(named: "unfillRadio"), for: .normal)
                    self.selectAddressRadioButton.setImage(UIImage(named: "filledRadio"), for: .normal)
                    let zipCode = UserDefaults.standard.value(forKey: "zip_code") as? String ?? ""
                    self.selectedDelieveryAddressLabel.text = "Ship to: \(zipCode) (Select Address)"
                } else {
                    self.selectAddressRadioButton.setImage(UIImage(named: "filledRadio"), for: .normal)
                }
                
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    func changeTotal() {
        totalLabel.text = "Rs. \(persistance?.getGradTotalPrice ?? 0.0)"
    }
    
    func getProfileData() {
        persistance?.getUserData { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.changeTotal()
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    func getCouponsList() {
        persistance?.getCouponsList(completion: { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                
            } else {
                self.showToast(message: message)
            }
        })
    }
    
    func getShippingCharges() {
        persistance?.getShippingCharges{ [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    func saveOrder() {
        let id = persistance?.profileDetails.userData?.userId ?? 0
        let amount = Double((self.totalLabel.text ?? "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "Rs.", with: "")) ?? 0.0
        let shippingCharges = Int((self.persistance?.footerView?.shippingChargesLabel.text ?? "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "Rs.", with: "")) ?? 0
        
        var couponCode = ""
        var couponAppliedAmount = persistance?.getCouponAppiledAmount ?? 0.0
        if persistance?.isCouponApplied ?? false {
            couponCode = persistance?.couponCode ?? ""
        } else {
            couponAppliedAmount = 0.0
        }
        
        let userName = UserDefaults.standard.value(forKey: "username_") as? String ?? "Guest"
        
        let order = Order(userID: "\(id)", name: userName, totalAmount: "\(Int(amount))", address: persistance?.selectedAddress?.getAddress ?? "", email: persistance?.profileDetails.userData?.email ?? "null", mobile: persistance?.profileDetails.userData?.mobile ?? "null", shippingCharges: "\(shippingCharges)", userType: "customer", giftCardUsedValue: "0", couponCode: couponCode, couponDiscount: (Int(couponAppliedAmount)))
        
        var products: [SaveProduct] = []
        for pro in persistance?.localProducts ?? [] {
            products.append(SaveProduct(proID: "\(pro.product_id)", proName: pro.name, qty: "\(pro.qty)", price: "\(Int(pro.price))", customerMarginPer: "\(Int(pro.points))", pointUsed: "\(Int(pro.getFinalusedCoins))", amount: "\(Int(pro.price))"))
        }
        persistance?.saveOrder(withOrder: order, andProducts: products) { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                for con in self.navigationController?.viewControllers ?? [] {
                    if con.isKind(of: ECommerceDashboardViewController.self) {
                        self.navigationController?.popToViewController(con, animated: true)
                    }
                }
                self.showToast(message: "Successfully placed your order\n Order Id: \(self.persistance?.orderId ?? "")")
            }
        }
    }
    
    //MARK:- @objc functions
    @objc
    func tapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func tapDeliveryAddressButton(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "DeliveryAddressViewController") as! DeliveryAddressViewController
        viewController.persistance?.selectedAddressCompletion = { [weak self] address in
            guard let self = self else { return }
            self.persistance?.selectedAddress = address
            self.selectedDelieveryAddressLabel.text = address?.getAddress ?? ""
            self.selectAddressRadioButton.setImage(UIImage(named: "filledRadio"), for: .normal)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    func tapCheckoutButton(_ sender: UIButton) {
        
        if persistance?.selectedAddress == nil {
            self.showToast(message: "Please select address")
            return
        }
        
        if (persistance?.localProducts.count ?? 0) == 0 {
            self.showToast(message: "Please add product to continue.")
            return
        }
        
        let availableProductsAtPinCode = persistance?.localProducts.allSatisfy { $0.is_pincod_availabel } ?? false
        if !availableProductsAtPinCode {
            for pro in persistance?.localProducts ?? [] {
                pro.errorMessage = "Product is not available at your pincode"
                pro.isErrorShown = true
            }
            mainTableView.reloadData()
            return
        }
        
        let vc = WebViewController()
        vc.isModalInPresentation = true
        let amount = (self.totalLabel.text ?? "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "Rs.", with: "")
        let email = persistance?.profileDetails.userData?.email ?? ""
        let mobilenumber = persistance?.profileDetails.userData?.mobile ?? ""
        let userId = "\(persistance?.profileDetails.userData?.userId ?? 0)"
        let name =  (persistance?.profileDetails.userData?.name ?? "").replacingOccurrences(of: " ", with: "")
        
        
        let amounts = Int(Double(amount) ?? 0.0)
        var webViewLink = "\(API.environment.shoopingBaseUrl)payment_webview.php?"
        webViewLink += "amount=\(amounts)&user_id=\(userId)&name=\(name)&mobile=\(mobilenumber)&address=\((self.persistance?.selectedAddress?.getAddress ?? "").replacingOccurrences(of: " ", with: ""))"
        
        vc.successCompletion = { [self] pay in
            let productsInLocal = (persistance?.localProducts.map { ["product_name": "\($0.name ?? "")", "product_price": "\($0.price)", "product_id": $0.product_id]})
            
            let data: [String:Any] = ["mobile": persistance?.profileDetails.userData?.mobile ?? "",
                                      "date": "\(Date())",
                                      "items_in_shoping_cart": (productsInLocal ?? [])
            ]
            Global.addFirebaseEvent(eventName: "click_on_check_out", param: data)
            Global.addFirebaseEvent(eventName: "checkout_click", param: data)
            self.saveOrder()
        }
        
        vc.faliurCompletion = {
            self.showToast(message: "Something went wrong.")
        }
        
        vc.webViewLink = webViewLink
        
        persistance?.leftButtonTouchUpInside = { sener in
            vc.dismiss(animated: true, completion: nil)
        }
        //        saveOrder()
        let nav = UINavigationController(rootViewController: vc)
        vc.navigationItem.rightBarButtonItem = persistance?.leftBarButton
        self.present(nav, animated: true, completion: nil)
        //                saveOrder()
    }
    
    @objc
    func tappedOnApplyButton() {
        let couponCode = persistance?.footerView?.enterCoupenCodeTextfield.text ?? ""
        let couupon = persistance?.getCouponObjectIfPresent(withCode: couponCode)
        
        if couupon == nil {
            self.showToast(message: "Invalid Coupon Code")
            return
        }
        
        for productId in couupon?.getProductsIds ?? [] {
            for localP in persistance?.localProducts ?? [] {
                if productId == "\(localP.product_id)" {
                    localP.coupon_applied = true
                    localP.coupon_code = couponCode
                    localP.coupon_value = Double(couupon?.value ?? "0") ?? 0.0
                    localP.coupon_value_unit = couupon?.valueUnit ?? ""
                }
            }
        }
        
        let ff = persistance?.localProducts.filter { $0.coupon_applied } ?? []
        if ff.count == 0 {
            self.showToast(message: "Invalid Coupon Code")
            return
        }
        
        persistance?.isCouponApplied = true
        persistance?.couponCode = couponCode
        persistance?.footerView?.coupensBackView.isHidden = true
        persistance?.footerView?.appliedCouponView.isHidden = false
        persistance?.footerView?.couponAppliedLabel.text = "\(couponCode) Coupon Applied \n\(couupon?.value ?? "0")% discount on a product"
        mainTableView.reloadData()
        persistance?.setData()
        changeTotal()
    }
    
    @objc
    func tappedOnMinusButton(_ sender: UIButton) {
        
        persistance?.footerView?.coupensBackView.isHidden = false
        persistance?.footerView?.appliedCouponView.isHidden = true
        persistance?.footerView?.enterCoupenCodeTextfield.text = ""
        
        persistance?.localProducts.forEach { $0.coupon_applied = false; $0.coupon_code = ""; $0.coupon_value = 0.0; $0.coupon_value_unit = ""}
        mainTableView.reloadData()
        persistance?.setData()
        changeTotal()
    }
    
    @objc
    func tapPickupStoreButton(_ sender: UIButton) {
        
    }
}

//MARK:- tableView delegate and datasources
extension ECartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persistance?.localProducts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 460
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return persistance?.footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.prodyct = persistance?.localProducts[indexPath.row]
        
        cell.addRemoveCompletion = { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .add:
                self.persistance?.setData()
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
            case .minus:
                self.persistance?.setData()
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
            case .delete:
                self.persistance?.getSetProducts()
                self.persistance?.setData()
                self.mainTableView.reloadData()
            }
            
            self.totalLabel.text = "Rs. \(self.persistance?.getGradTotalPrice ?? 0.0)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CartTableViewCell.HEIGHT
    }
}

extension String {
    
    func getNeededText(for url: String) -> String {
        guard range(of: url) != nil else { return "" }
        return replacingOccurrences(of: url, with: "")
    }
}

