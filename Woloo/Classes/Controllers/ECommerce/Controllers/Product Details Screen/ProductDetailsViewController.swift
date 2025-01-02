//
//  ProductDetailsViewController.swift
//  Woloo
//
//  Created by Rahul Patra on 03/08/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    enum CurrentState {
        case getThisbyPrice, getThisbyCoins , none
    }
    
    //MARK:- Outlets
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var productDetailsLabel: UILabel!
    @IBOutlet weak var productDetailsDescriptionLabel: UILabel!
    @IBOutlet weak var featuresLabel: UILabel!
    @IBOutlet weak var featuresDescriptionLabel: UILabel!
    @IBOutlet weak var additionalLabel: UILabel!
    @IBOutlet weak var additionalDescriptionLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var getThisbyPointsMainButton: UIButton!
    @IBOutlet weak var pointsButton: UIButton!
    @IBOutlet weak var getThisPriceMainButton: UIButton!
    @IBOutlet weak var cashButton: UIButton!
    
    @IBOutlet weak var withoutPointView: UIView!
    @IBOutlet weak var pointView: UIView!
    
    @IBOutlet weak var cartCountLabel: UILabel!
    
    //MARK:- Variables
    var currentState: CurrentState = .none {
        didSet {
            switch currentState {
            case .getThisbyCoins:
                
                if Int(persistance?.mainProductDetails?.getCustomerMargin ?? 0) > (persistance?.isUserhasPoints() ?? 0) {
                    self.showToast(message: "Opps not enough points.")
                    currentState = .getThisbyPrice
                    return
                }
                
                pointsButton.setImage(UIImage(named: "filledRadio"), for: .normal)
                cashButton.setImage(UIImage(named: "unfillRadio"), for: .normal)
            case .getThisbyPrice:
                pointsButton.setImage(UIImage(named: "unfillRadio"), for: .normal)
                cashButton.setImage(UIImage(named: "filledRadio"), for: .normal)
            case .none:
                pointsButton.setImage(UIImage(named: "unfillRadio"), for: .normal)
                cashButton.setImage(UIImage(named: "unfillRadio"), for: .normal)
            }
        }
    }
    var persistance: ProductDetailspersistance? = ProductDetailspersistance()
    var eCommercepersistance: ECommerceDataPersistance? = ECommerceDataPersistance()
    
    //MARK:- Life Cycles
    override
    func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setViews()
        searchButton.addTarget(self, action: #selector(tappedOnSearchbutton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        countLabel.text = "\(persistance?.getQuantutyOfProduct() ?? 0)"
        cartCountLabel.text = "\(eCommercepersistance?.getCartQuantityCount() ?? 0)"
    }
    
    func setUI() {
        pointView.layer.cornerRadius = 8
        pointView.borderWidth = 1
        pointView.borderColor = .lightGray
        pointView.layer.masksToBounds = true
        
        withoutPointView.layer.cornerRadius = 8
        withoutPointView.borderWidth = 1
        withoutPointView.borderColor = .lightGray
        withoutPointView.layer.masksToBounds = true
        getProfileData()
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:- Custom functions
    func setViews() {
        
        cartCountLabel.clipsToBounds = true
        cartCountLabel.layer.cornerRadius = cartCountLabel.frame.height / 2
        
        countLabel.text = "\(persistance?.mainProductDetails?.localQty ?? 0)"
        pageControl.numberOfPages = persistance?.productImages.count ?? 0
        pageControl.currentPage = 0
        proceedButton.layer.cornerRadius = 8
        headingLabel.text = persistance?.mainProductDetails?.name ?? ""
        
        mainCollectionView.isPagingEnabled = true
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(tapCartButton), for: .touchUpInside)
        proceedButton.addTarget(self, action: #selector(tapProceedButton), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(tapPlusButton), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(tapMinusButton), for: .touchUpInside)
        getThisbyPointsMainButton.addTarget(self, action: #selector(tappedOngetThisByMainPointbutton), for: .touchUpInside)
        getThisPriceMainButton.addTarget(self, action: #selector(getThisbyPricebutton), for: .touchUpInside)
    }
    
    /// Getting product detals
    func getproductdetails() {
        persistance?.getproductDetails { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.setData()
                self.bindQty()
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    /// Setting Data
    func setData() {
        cashLabel.text = "Get this for Rs.\(Int(persistance?.mainProductDetails?.price ?? 0.0))"
        
        let points = persistance?.profileDetails.totalCoins?.totalCoins ?? 0
        let price = Double(persistance?.mainProductDetails?.price ?? 0.0) ?? 0.0
        let customermargin = persistance?.mainProductDetails?.getCustomerMargin ?? 0
        
        if customermargin < points {
            pointsLabel.text = "Get this for Rs.\(price - Double(customermargin)) By Using \(customermargin) points"
        } else {
            pointsLabel.text = "Get this for Rs.\(price) By Using \(0) points"
        }
        pointsLabel.text = "Get this for Rs.\(price - Double(customermargin)) By Using \(customermargin) points"
        
        headingLabel.text = persistance?.mainProductDetails?.name ?? ""
        priceLabel.text = "Rs.\(persistance?.mainProductDetails?.price ?? 0.0)"
        productNameLabel.text = "\(persistance?.mainProductDetails?.name ?? "")"
        taxLabel.text = "Inclusive of all Taxes"
        productDetailsDescriptionLabel?.text = persistance?.mainProductDetails?.getProductDetails ?? ""
        featuresDescriptionLabel.text = persistance?.mainProductDetails?.getFeaturesBenefits ?? ""
        additionalDescriptionLabel.text = persistance?.mainProductDetails?.getAdditionalInformation ?? ""
    }
    
    //one way binding
    func bindQty() {
        //one way qty binding
        persistance?.mainProductDetails?.updateQtyCompletion = { [weak self] newQty in
            self?.countLabel.text = "\(newQty)"
        }
    }
    
    /// Getting Profile Details
    func getProfileData() {
        persistance?.getUserData { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.getproductdetails()
                return
            }
            self.getproductdetails()
        }
    }
    
    //MARK:- Action
    
    @objc
    func tappedOnSearchbutton() {
        Global.addFirebaseEvent(eventName: "search_product_icon_click", param: [:])
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchProductViewController") as! SearchProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func tapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func tapCartButton(_ sender: UIButton) {
        
        if persistance?.isCartAvaialbel() ?? 0 == 0 {
            self.showToast(message: "No Products Available in cart.")
        } else {
            
            //log
            let productsInLocal = (persistance?.localProducts.map { ["product_name": "\($0.name ?? "")", "product_price": "\($0.price)", "product_id": $0.product_id]})
            
            let data: [String:Any] = ["mobile": persistance?.profileDetails.userData?.mobile ?? "",
                                      "items_in_shoping_cart": (productsInLocal ?? [])
            ]
            
            Global.addFirebaseEvent(eventName: "click_on_cart_button", param: data)
            
            let viewController = storyboard?.instantiateViewController(withIdentifier: "ECartViewController") as! ECartViewController
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc
    func tapProceedButton(_ sender: UIButton) {
        
        if currentState == .none {
            self.showToast(message: "Please select one options.")
            return
        }
        
        if (Int(persistance?.mainProductDetails?.stock ?? "0") ?? 0) < persistance?.mainProductDetails?.localQty ?? 0 {
            self.showToast(message: "Out Of Stocks.")
            return
        }
        
        if persistance?.isProductAvaiable ?? 0 == 0 {
            self.showToast(message: "Product is not available at pincode")
            return
        }
        
        if persistance?.mainProductDetails?.localQty ?? 0 == 0 {
            self.showToast(message: "Quantity should not be 0")
            return
        }
        let coinsused = (Int(persistance?.mainProductDetails?.getCustomerMargin ?? 0)) * (Int(countLabel.text ?? "0") ?? 0)
        
        if currentState == .getThisbyCoins ? true : false {
            if (persistance!.profileDetails.totalCoins!.totalCoins ?? 0) < coinsused {
                self.showToast(message: "Sorry insuffucient points")
                return
            }
        }
        
        
        let isPointsUsed = currentState == .getThisbyCoins ? true : false
        persistance?.addProductToLocal(isPointsused: isPointsUsed)
        
        switch currentState {
        case .getThisbyCoins:
            let selectedProduct = persistance?.mainProductDetails!
            let data = ["product_name": "\(selectedProduct?.name ?? "")", "product_price": "\(selectedProduct?.price ?? 0.0)", "product_id": selectedProduct?.productID ?? "", "qty": "\(selectedProduct?.localQty ?? 0)", "points_used": "\(coinsused)"]
            Global.addFirebaseEvent(eventName: "purchase_option_points_used", param: data)
            
        case .getThisbyPrice:
            let selectedProduct = persistance?.mainProductDetails!
            let data = ["product_name": "\(selectedProduct?.name ?? "")", "product_price": "\(selectedProduct?.price ?? 0.0)", "product_id": selectedProduct?.productID ?? "", "qty": "\(selectedProduct?.localQty ?? 0)"]
            Global.addFirebaseEvent(eventName: "purchase_option_no_points_used", param: data)
            
        default:
            print("")
        }
        
        //Log
        _ = persistance?.isCartAvaialbel()
        let productsInLocal = (persistance?.localProducts.map { ["product_name": "\($0.name ?? "")", "product_price": "\($0.price)", "product_id": $0.product_id]})
        //log
        let data: [String:Any] = ["mobile": persistance?.profileDetails.userData?.mobile ?? "",
                                  "items_in_shoping_cart": (productsInLocal ?? [])
        ]
        Global.addFirebaseEvent(eventName: "click_on_cart_button", param: data)
        Global.addFirebaseEvent(eventName: "add_to_cart", param: data)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ECartViewController") as! ECartViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func tapPlusButton(_ sender: UIButton) {
        persistance?.mainProductDetails?.localQty += 1
    }
    
    @objc
    func tapMinusButton(_ sender: UIButton) {
        persistance?.mainProductDetails?.localQty -= 1
        
        if persistance?.mainProductDetails?.localQty ?? 0 < 0 {
            persistance?.mainProductDetails?.localQty = 0
            self.showToast(message: "QTY should not be less then zero.")
        }
    }
    
    @objc
    func tappedOngetThisByMainPointbutton() {
        currentState = .getThisbyCoins
    }
    
    @objc
    func getThisbyPricebutton() {
        currentState = .getThisbyPrice
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persistance?.productImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
        cell.image = persistance?.productImages[indexPath.item] ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
