//
//  ECommerceDashboardViewController.swift
//  Woloo
//
//  Created by Chandan Sharda on 01/08/21.
//

import UIKit

class ECommerceDashboardViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var pinCodeButton: UIButton!
    @IBOutlet weak var pinCodeLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var profilebutton: UIButton!
    
    //MARK:- Variables
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handleRefresh),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.yellow
        
        return refreshControl
    }()
    
    var persistance: ECommerceDataPersistance? = ECommerceDataPersistance()
    
    //MARK:- Initializers
    deinit { persistance = nil }
    
    //MARK:- View Life Cycles
    override
    func viewDidLoad() {
        super.viewDidLoad()
        
        setUi()
        
        let products = LocalProducts.fetchRequests()
        do {
            let data = try EcommerceModelSingleton.instance?.mainContaxt.fetch(products)
            for dat in data ?? [] {
                EcommerceModelSingleton.instance?.mainContaxt.delete(dat)
            }
        } catch {
            print(error.localizedDescription)
        }        
    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        DELEGATE.rootVC?.tabBarVc?.showTabBar()
        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
        getProfileData()
        getData()
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        cartCountLabel.text = "\(persistance?.getCartQuantityCount() ?? 0)"
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//            self.mainTableView.reloadData()
//        }
    }
    
    override
    func viewDidLayoutSubviews() {
        mainTableView.tableHeaderView = persistance?.headerCollectionView
    }
    
    //MARK:- Custom Funcations
    func setUi() {
        cartCountLabel.clipsToBounds = true
        cartCountLabel.layer.cornerRadius = cartCountLabel.frame.height / 2
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        mainTableView.addSubview(refreshControl)
        mainTableView.register(ECommerceTableViewCell.loadNib(), forCellReuseIdentifier: "ECommerceTableViewCell")
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        pinCodeButton.addTarget(self, action: #selector(tapPinCodeButton), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(tapCartButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(tappedOnSearchbutton), for: .touchUpInside)
        profilebutton.addTarget(self, action: #selector(tappedOnProfileButton), for: .touchUpInside)
        
        setData()
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func getData() {
        getCategories()
        getHomeBanners()
    }
    
    func getProfileData() {
        persistance?.getUserData { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.getCurrentZipCode()
                self.setData()
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    ///getting pin code
    func getCurrentZipCode() {
        persistance?.getCurrentLocation { [weak self] isSuccess, message, zipCode in
            if isSuccess {
                self?.pinCodeLabel.text = zipCode
                self?.persistance?.pinCode = zipCode
                UserDefaults.standard.setValue(zipCode, forKey: "zip_code")
            } else {
                self?.askForPinCode()
            }
        }
    }
    
    func setData() {
        pointsLabel.text = "Points: \(persistance?.profileDetails.totalCoins?.totalCoins ?? 0)"
        nameLabel.text = persistance?.profileDetails.userData?.name ?? "Guest"
        if let avtar = UserModel.user?.avatar, avtar.count > 0 {
            let url = "\(API.environment.baseURL)public/userProfile/\(avtar)"
            profileImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "user_default"))
        } else {
            self.profileImageView.sd_setImage(with: URL(string: kUserPlaceholderURL), completed: nil)
        }
    }
    
    func getProductsCategories() {
        persistance?.getProductsCategories { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.mainTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.mainTableView.reloadData()
                }
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    func getCategories() {
        persistance?.getCategories { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.mainTableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.mainTableView.reloadData()
                }
                self.getProductsCategories()
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    func getCategoriesV2(){
        
        
    }
    
    func getHomeBanners() {
        persistance?.getHomeBanners { [weak self] isSuccess, message in
            guard let self = self else { return }
            if isSuccess {
                self.persistance?.headerCollectionView?.headerView?.homeBanners = self.persistance?.homeBanners
                self.mainTableView.reloadData()
            } else {
                self.showToast(message: message)
            }
        }
    }
    
    func askForPinCode() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "SelectDeliveryAddressViewController") as! SelectDeliveryAddressViewController
        viewController.isModalInPresentation = true
        viewController.persistance?.selectedAddressCompletion = { [weak self] address in
            self?.pinCodeLabel.text = address?.pincode ?? ""
            self?.persistance?.pinCode = address?.pincode ?? ""
            self?.getData()
            UserDefaults.standard.setValue(address?.pincode ?? "", forKey: "zip_code")
            UserDefaults.standard.setValue(address?.pincode ?? "", forKey: "zip_code")
        }
        present(viewController, animated: true, completion: nil)
    }
    
    //MARK:- Action
    
    ///tapping on code button and asking for pincode
    @objc
    func tapPinCodeButton(_ sender: UIButton) {
        Global.addFirebaseEvent(eventName: "delivery_pincode_click", param: [:])
        askForPinCode()
    }
    
    ///tapping on cart button
    @objc
    func tapCartButton(_ sender: UIButton) {
        Global.addFirebaseEvent(eventName: "cart_icon_click", param: [:])
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
    
    ///pull to refresh feature executed
    @objc
    func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.refreshControl.endRefreshing()
        }
        getData()
    }
    
    @objc
    func tappedOnSearchbutton() {
        Global.addFirebaseEvent(eventName: "search_product_icon_click", param: [:])
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchProductViewController") as! SearchProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func tappedOnProfileButton() {
        Global.addFirebaseEvent(eventName: "my_orders_click", param: [:])
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- UITableView Delagate and UItableView DataSource
extension ECommerceDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        persistance?.homeCategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ECommerceTableViewCell") as? ECommerceTableViewCell else { return UITableViewCell() }
        
        cell.headingLabel.text = (persistance?.homeCategories?[indexPath.row].name ?? "").uppercased()
        cell.categories = persistance?.homeCategories?[indexPath.row]
        cell.products = persistance?.homeCategories?[indexPath.row].products ?? []
        cell.images = persistance?.homeCategories?[indexPath.row].images ?? []
        cell.footeViewMain?.mainImage = persistance?.homeCategories?[indexPath.row].getCategoryBannerImages.last
        cell.footeViewMain?.categories = persistance?.homeCategories?[indexPath.row]
        
        return cell
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ECommerceTableViewCell.HEIGHT
    }
}
