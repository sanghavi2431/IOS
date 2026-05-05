//
//  InnerProductListWithCategoriesViewController.swift
//  Woloo
//
//  Created by Rahul Patra on 28/08/21.
//

import UIKit

class InnerProductListWithCategoriesViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var mainCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cartCountLabel: UILabel!
    
    //MARK:- Variables
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(handleRefresh),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.yellow
        
        return refreshControl
    }()
    
    var persistance: InnerProductListWithCategoriesPersistance? = InnerProductListWithCategoriesPersistance()
    var eCommercepersistance: ECommerceDataPersistance? = ECommerceDataPersistance()
    
    //MARK:- View Life Cycles
    override
    func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        searchButton.addTarget(self, action: #selector(tappedOnSearchbutton), for: .touchUpInside)
    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        if let tabBarController = self.tabBarController as? TabBarController {
                tabBarController.hideFloatingButton()
            }
        getProductList() //no need to call
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        cartCountLabel.text = "\(eCommercepersistance?.getCartQuantityCount() ?? 0)"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.showFloatingButton()
        }
        
        tabBarController?.tabBar.isHidden = false
    }
    //MARK:- custom functions
    func setViews() {
        cartCountLabel.clipsToBounds = true
        cartCountLabel.layer.cornerRadius = cartCountLabel.frame.height / 2
        
        mainCollectionView.backgroundColor = .white
        mainCollectionView.addSubview(refreshControl)
        titleLabel.text = persistance?.categories?.name ?? ""
        mainCollectionView.register(InnerProductCollectionViewCell.loadNib(), forCellWithReuseIdentifier: "InnerProductCollectionViewCell")
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(tapCartButton), for: .touchUpInside)
        
        bindheaderCollectionView()
    }
    
    func getProductList() {
        persistance?.getHomeCategoriesProduct(catId: 4, { products, images in
            self.persistance?.products = products
            self.persistance?.productDetailsImages = images
        })
        self.mainCollectionView.reloadData()
//        persistance?.getHomeCategoriesProduct{ [weak self] isSuccess, message in
//            if isSuccess {
//                self?.mainCollectionView.reloadData()
//            }
//        }
    }
    
    func bindheaderCollectionView() {
        mainCategoriesCollectionView.register(HeaderCategoriesCollectionViewCell.loadNib(), forCellWithReuseIdentifier: "HeaderCategoriesCollectionViewCell")
        mainCategoriesCollectionView.delegate = persistance?.headerCollectionViewwrapper
        mainCategoriesCollectionView.dataSource = persistance?.headerCollectionViewwrapper
        
        persistance?.headerCollectionViewwrapper.getNumberofRowsInSection({ (collectionView, section) -> Int in
            return self.persistance?.categories?.productCategories.count ?? 0
        })
        
        persistance?.headerCollectionViewwrapper.getCellForItemAt({ (collectionView, indexpath) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCategoriesCollectionViewCell", for: indexpath) as! HeaderCategoriesCollectionViewCell
            cell.product = self.persistance?.categories?.productCategories[indexpath.item]
            return cell
        })
        
        persistance?.headerCollectionViewwrapper.getSizeForItemAt({ (collectionView, layout, indexPath) -> CGSize in
            .init(width: collectionView.frame.height, height: collectionView.frame.height)
        })
        
        persistance?.headerCollectionViewwrapper.getDidSelectItemAt({ (collectionView, indexPath) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InnerProductListViewController") as! InnerProductListViewController
            vc.persistance?.categories = self.persistance?.categories
            vc.persistance?.products = self.persistance?.getProductsAccordintToCategory(withCatId: "\(self.persistance?.categories?.productCategories[indexPath.item].id ?? "-2")")
            vc.persistance?.selectedproductCategory = self.persistance?.categories?.productCategories[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        })
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
        
        if eCommercepersistance?.isCartAvaialbel() ?? 0 == 0 {
            self.showToast(message: "No Products Available in cart.")
        } else {
            
            //log
            let productsInLocal = (eCommercepersistance?.localProducts.map { ["product_name": "\($0.name ?? "")", "product_price": "\($0.price)", "product_id": $0.product_id]})
            
            let data: [String:Any] = ["mobile": eCommercepersistance?.profileDetails.userData?.mobile ?? "",
                        "items_in_shoping_cart": (productsInLocal ?? [])
            ]
            
            Global.addFirebaseEvent(eventName: "click_on_cart_button", param: data)
            
            let viewController = storyboard?.instantiateViewController(withIdentifier: "ECartViewController") as! ECartViewController
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc
    func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.refreshControl.endRefreshing()
        }
        getProductList()
    }
}

extension InnerProductListWithCategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return persistance?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "InnerProductCollectionViewCell", for: indexPath) as! InnerProductCollectionViewCell
        cell.product = persistance?.products?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width / 2, height: ((collectionView.frame.width / 5) + (collectionView.frame.width / 1.5)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.persistance?.product = persistance?.products?[indexPath.item]
        let productId = persistance?.products?[indexPath.item].id ?? ""
        vc.persistance?.productImages = persistance?.productDetailsImages.filter { $0.productID ?? "" == productId  }.map { $0.img ?? "" } ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
