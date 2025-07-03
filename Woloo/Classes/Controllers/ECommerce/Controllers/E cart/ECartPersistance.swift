//
//  ECartPersistance.swift
//  Woloo
//
//  Created by Rahul Patra on 08/08/21.
//

import Foundation
import UIKit

class ECartPersistance {
    
    //MARK:- Variables
    var localProducts: [LocalProducts] = []
    var profileDetails = ProfileMoreResponse()
    var selectedAddress: Address?
    var footerView = CartFooterView.loadNib()
    var totalPoints: Int = 0
    var mainTotalPrice: Int = 0
    var shippingCharges: ShippingCharge?
    var orderId: String?
    var coupons: Coupons?
    
    var isCouponApplied: Bool = false
    var couponCode: String = ""
    
    lazy var leftBarButton: UIBarButtonItem = {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor) ,
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor) ,
            button.topAnchor.constraint(equalTo: view.topAnchor) ,
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        button.setImage(UIImage(named: "darkCross"), for: .normal)
        button.addTarget(self, action: #selector(tappedOnLeftButton(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: view)
        return barButton
    }()
    
    var leftButtonTouchUpInside: ((UIButton) -> Void)?
    
    @objc private
    func tappedOnLeftButton(_ sender: UIButton) {
        leftButtonTouchUpInside?(sender)
    }
    
    //MARK:- Computed properties
    var getusedPoints: Int {
        get {
            let points = localProducts.map { $0.getFinalusedCoins }.reduce(0, +).rounded(.up)
            return Int(points)
        }
    }
    
    var getTotalPointsLeft: Double {
        get {
            print(Double(totalPoints - localProducts.map { Int($0.getFinalusedCoins) }.reduce(0, +)).rounded())
            return Double(totalPoints - localProducts.map { Int($0.getFinalusedCoins) }.reduce(0, +)).rounded()
        }
    }
    
    var getTotalPriceOfProductsAddedinCart: Double  {
        get {
            Double(localProducts.map { Int($0.productPrice) * Int($0.qty) }.reduce(0, +))
        }
    }
    
    var getPointsLeft: Int {
        get {
            totalPoints //- getusedPoints
        }
    }
    
    var getTotalPayableAmount: Double {
        get {
            Double(localProducts.map { Int($0.price) }.reduce(0, +))
        }
    }
    
    var getGradTotalPrice: Double {
        get {
            let shipPrice = shippingCharges?.getShippingChargesprice(withfinalPrice: self.getTotalPayableAmount) ?? 0.0
            return (getTotalPayableAmount + shipPrice) - getCouponAppiledAmount
        }
    }
    
    
    var getCouponAppiledAmount: Double {
        get {
            localProducts.map { $0.getCouponAppliedPrice }.reduce(0, +)
        }
    }
    
    //MARK:- initializers and deinits
    //Initiaizers
    init() { getSetProducts() }
    
    //MARK:- Custom functions
    //function setting data if existss in local storage
    func setData() {
        self.footerView?.bagTotalLabel.text = "Rs. \(getTotalPriceOfProductsAddedinCart)"
        self.footerView?.giftCardusedLabel.text = "\(0) Pts."
        self.footerView?.totalPointsusedLabel.text = "\(getusedPoints) Pts."
        self.footerView?.totalPaybleLabel.text = "Rs. \(Int(getGradTotalPrice))"
        
        if localProducts.count == 0 {
            self.footerView?.shippingChargesLabel.text = "Rs. 0"
            self.footerView?.bagSubTotalLabel.text = "Rs. \(getTotalPriceOfProductsAddedinCart)"
        } else {
            self.footerView?.shippingChargesLabel.text = self.shippingCharges?.getShippingCharges(withfinalPrice: getTotalPayableAmount)
            let pricc = self.shippingCharges?.getShippingChargesprice(withfinalPrice: getTotalPayableAmount)
            self.footerView?.bagSubTotalLabel.text = "Rs. \(Int(getTotalPriceOfProductsAddedinCart + (pricc ?? 0.0)))"
        }
        
        if isCouponApplied {
            footerView?.couponDiscountLabel.text = "Rs. \(Int(getCouponAppiledAmount))"
        } else {
            footerView?.couponDiscountLabel.text = "Rs. \(0)"
        }
        
        
        self.footerView?.totalPointsLeftLabel.text = "\(mainTotalPrice - getusedPoints) Pts."
        totalPoints = getPointsLeft
    }
    
    /// Functon used to get user profile data
    func getUserData(_ completion: @escaping FinalCompletion) {
        UserModel.apiMoreProfileDetails { [weak self] (response) in
            guard let self = self else { return }
            if let result = response {
                DispatchQueue.main.async {
                    self.profileDetails = result
                    self.totalPoints = (result.totalCoins?.totalCoins ?? 0) //- self.getusedPoints
                    self.mainTotalPrice = self.totalPoints
                    self.setData()
                    completion(true, "Success")
                }
            } else {
                completion(false, "No Data found.")
            }
        }
    }
    
    //apply coupons
    func applyCouponCode() {
        
    }
    
    func getCouponObjectIfPresent(withCode code: String) -> Coupon? {
        coupons?.filter({ $0.couponCode ?? "" == code }).first
    }
    
    /// Gettign lists of coupons code
    func getCouponsList(completion: @escaping FinalCompletion) {
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getCouponLists, params: [:], headers: [:], method: .get, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let decodedJson = try JSONDecoder().decode(Coupons.self, from: data)
                    self.coupons = decodedJson
                    completion(true, "Success")
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    ///Get Shipping Charges
    func getShippingCharges(_ completion: @escaping FinalCompletion) {
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getShippingCharges, params: [:], headers: [:], method: .get, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let decodedJson = try JSONDecoder().decode(ShippingCharges.self, from: data)
                    self.shippingCharges = decodedJson.first
                    self.footerView?.shippingChargesLabel.text = "Rs. \(self.shippingCharges?.shippingCharges ?? "")"
                    completion(true, "Success")
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
    
    ///getting and setting products from local storage
    func getSetProducts() {
        let products = LocalProducts.fetchRequests()
        do {
            let data = try EcommerceModelSingleton.instance?.mainContaxt.fetch(products)
            localProducts = data ?? []
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    ///Api to save order in backend server
    func saveOrder(withOrder order: Order, andProducts: [SaveProduct], completion: @escaping FinalCompletion) {
        
        let finalSave = FinalSaveProduct(order: [order], orderProduct: andProducts)
        let data = try? JSONEncoder().encode(andProducts)
        
        var productsArray = ""
        var finalProduct = "["
        
        var p_p: [String] = []
        for pro in andProducts {
            let dd = """
            {"pro_id":"\(pro.proID ?? "")","pro_name":"\(pro.proName ?? "")","qty":"\(pro.qty ?? "")","price":"\(pro.price ?? "")","customer_margin_per":"\(pro.customerMarginPer ?? "")","point_used":"\(pro.pointUsed ?? "")","amount":"\(pro.amount ?? "")"}
            """
            p_p.append(dd)
        }
        finalProduct += p_p.joined(separator: ",")
        finalProduct += "]"
        
        
        let parameters = """
        {"order":[{"user_id":"\(order.userID ?? "")","name":"\(order.name ?? "")","total_amount":"\(order.totalAmount ?? "")","address":"\(order.address ?? "")","email":"\(order.email ?? "")","mobile":"\(order.mobile ?? "")","shipping_charges":"\(order.shippingCharges ?? "")","user_type":"customer","gift_card_used_value":"0","coupon_code":"\(order.couponCode ?? "")","coupon_discount":\(order.couponDiscount ?? 0)}],"order_product":\(finalProduct)}
        """
        
        let postData = parameters.data(using: .utf8)
        
        let baseUrl = API.environment.shoopingBaseUrl
        let endpoint = ShoppingApisEndPoint.saveOrderApi.getDescription
        let finalurl = "\(baseUrl + endpoint)"
        
        var request = URLRequest(url: URL(string: finalurl)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                DispatchQueue.main.async {
                    completion(false, error?.localizedDescription ?? "")
                }
                return
            }
            
            DispatchQueue.main.async {
                print(String(data: data, encoding: .utf8) ?? "")
                let decodedJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                self.orderId = (decodedJson as? [String:Any])?["orderid"] as? String ?? ""
                let products = LocalProducts.fetchRequests()
                do {
                    let data = try EcommerceModelSingleton.instance?.mainContaxt.fetch(products)
                    for dat in data ?? [] {
                        EcommerceModelSingleton.instance?.mainContaxt.delete(dat)
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(true, "Success")
                print(String(data: data, encoding: .utf8)!)
                return
            }
        }
        
        task.resume()
    }
    
    ///Getting Addresses
    func getAddressList(_ completion: @escaping FinalCompletion) {
        let id = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        ShoppingApiManager.shared.apiMappableRequest(withEndPoint: .getAddressList("\(id)"), params: [:], headers: [:], method: .post, completion: { [weak self]  result in
            switch result {
            case .success(let data):
                do {
                    let decodedJson = try JSONDecoder().decode(Addresses.self, from: data)
                    self?.selectedAddress = decodedJson.first
                    completion(true, "Success")
                } catch {
                    completion(false, error.localizedDescription)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }, activity: true)
    }
}
