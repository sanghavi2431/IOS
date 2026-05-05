//
//  ECommerceTableViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 02/08/21.
//

import UIKit

class ECommerceTableViewCell: UITableViewCell {
    
    static var HEIGHT: CGFloat = 900//UITableView.automaticDimension//900
    
    //MARK:- OUTlets
    @IBOutlet weak var productCategoriedCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionViewheight: NSLayoutConstraint! // 180
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    
    //MARK:- view Variables
    let footeViewMain = ShopSectionFooterView.loadNib()
    var productCategoriesCollectionView: GenericCollectionViewHelper = GenericCollectionViewHelper()
    var productCollectionViewWrapper: GenericCollectionViewHelper = GenericCollectionViewHelper()
    var categoriesCollectionViewWrapper: GenericCollectionViewHelper = GenericCollectionViewHelper()
    
    //MARK:- view
    var images: [ProductImages]?
    var categories: HomeCategory? {
        didSet {
            categoriesCollectionView.reloadData()
            productCategoriedCollectionView.reloadData()
            footeViewMain?.categories = categories
            
            if categories?.productCategories.count ?? 0  == 0 {
                productCategoriedCollectionView.isHidden = true
                ECommerceTableViewCell.HEIGHT = 740
            } else {
                productCategoriedCollectionView.isHidden = false
                ECommerceTableViewCell.HEIGHT = 900
            }
        }
    }
    
    var products: [Product]? {
        didSet {
            if products?.count ?? 0 == 0 {
                productCollectionView.isHidden = true
                ECommerceTableViewCell.HEIGHT = ECommerceTableViewCell.HEIGHT - 180
            } else {
                productCollectionView.isHidden = false
                ECommerceTableViewCell.HEIGHT = ECommerceTableViewCell.HEIGHT
                
            }
            productCollectionView.reloadData()
        }
    }
    
    //MARK:- Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setViews()
    }
    
    //MARK:- Custom Functions
    func setViews() {
        setCategoriesColelctionView()
        setProductColelctionView()
        bindProductCategoriesCollectionView()
        
        viewAllButton.addTarget(self, action: #selector(tappedOnSeeAllButton), for: .touchUpInside)
        
        footerView.addSubview(footeViewMain!)
        footeViewMain?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footeViewMain!.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            footeViewMain!.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            footeViewMain!.topAnchor.constraint(equalTo: footerView.topAnchor),
            footeViewMain!.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        ])
    }
    
    //MARK:- OBJC functions
    @objc
    func tappedOnSeeAllButton() {
        let data = [
            "category_name": categories?.name ?? "",
            "count": "\(1)"
        ]
        Global.addFirebaseEvent(eventName: "category_view_all_click", param: data)
        
        let vc = self.iq.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "InnerProductListWithCategoriesViewController") as! InnerProductListWithCategoriesViewController
        vc.persistance?.categories = categories
        self.iq.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "ECommerceTableViewCell", bundle: .main)
    }
    
    
    func getProductsAccordintToCategory(withCatId: String) -> [Product] {
        products?.filter { $0.sub_cat_id ?? "-1" == withCatId} ?? []
    }
}

//MARK:- Categories CollectionView Wrapper
extension ECommerceTableViewCell {
    
    func setCategoriesColelctionView() {
        
        categoriesCollectionView.register(BannerImageCollectionViewCell.self, forCellWithReuseIdentifier: "BannerImageCollectionViewCell")
        categoriesCollectionView.delegate = categoriesCollectionViewWrapper
        categoriesCollectionView.dataSource = categoriesCollectionViewWrapper
        
        categoriesCollectionViewWrapper.getNumberofRowsInSection { [weak self] collectionView, section in
            return self?.categories?.getCategoryBannerImagesTwo.count ?? 0
        }
        
        categoriesCollectionViewWrapper.getCellForItemAt { [weak self] collectionView, indexPath in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCollectionViewCell", for: indexPath) as? BannerImageCollectionViewCell else { return UICollectionViewCell() }
            
            cell.mainImageView.layer.cornerRadius = 15
            cell.mainImageView.clipsToBounds = true
            cell.bannerImage = self?.categories?.getCategoryBannerImagesTwo[indexPath.item]
            
            return cell
        }
        
        categoriesCollectionViewWrapper.getSizeForItemAt { collectionView, collectionViewLayout, indexPath in
            .init(width: (collectionView.frame.width / 2) - 2, height: collectionView.frame.height)
        }
        
        categoriesCollectionViewWrapper.getDidSelectItemAt { [self] collectionView, indexPath in
            let categoryName = categories?.name ?? ""
            let superCon = (self.iq.viewContainingController() as? ECommerceDashboardViewController)?.persistance?.profileDetails
            let data = [
                "category_name": categoryName,
                "mobile_number": superCon?.userData?.mobile ?? "",
                "date_time": "\(Date())",
            ]
            
            Global.addFirebaseEvent(eventName: "click_on_top_catrgory", param: data)
            /* let vc = self.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "InnerProductListViewController") as! InnerProductListViewController
             vc.persistance?.categories = categories
             self.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)*/
            let vc = self.iq.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "InnerProductListWithCategoriesViewController") as! InnerProductListWithCategoriesViewController
            vc.persistance?.categories = categories
            self.iq.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:- Product CollectionView Wrapper
extension ECommerceTableViewCell {
    
    func setProductColelctionView() {
        
        //setup collection view
        productCollectionView.register(ProductCollectionViewCell.loadNib(), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        productCollectionView.delegate = productCollectionViewWrapper
        productCollectionView.dataSource = productCollectionViewWrapper
        
        //one way binding collection view wrapper
        productCollectionViewWrapper.getNumberofRowsInSection { [weak self] collectionView, section in
            if self?.products?.count ?? 0 == 0 {
                collectionView.setErrorSuccessMessage(withErrorType: .error("No Products Found."))
            } else {
                collectionView.setErrorSuccessMessage(withErrorType: .removeMessage)
            }
            return self?.products?.count ?? 0
        }
        
        productCollectionViewWrapper.getCellForItemAt { [weak self] collectionView, indexPath in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
            cell.product = self?.products?[indexPath.item]
            return cell
        }
        
        productCollectionViewWrapper.getSizeForItemAt { collectionView, collectionViewLayout, indexPath in
            .init(width: (collectionView.frame.width / 2.4) - 2, height: collectionView.frame.height)
        }
        
        productCollectionViewWrapper.getDidSelectItemAt { [weak self] collectionView, indexPath in
            guard let self = self else { return }
            
            let categoryName = self.products?[indexPath.item].name ?? ""
            let superCon = (self.iq.viewContainingController() as? ECommerceDashboardViewController)?.persistance?.profileDetails
            let data = [
                "product_name": categoryName,
                "product_id": self.products?[indexPath.item].id ?? "",
                "mobile_number": superCon?.userData?.mobile ?? "",
                "date_time": "\(Date())",
            ]
            
            Global.addFirebaseEvent(eventName: "click_on_product_item", param: data)
            
            let clickProductLogData = [
                "product_name": categoryName,
                "product_id": self.products?[indexPath.item].id ?? "",
                "mobile_number": superCon?.userData?.mobile ?? "",
                "category_name": self.categories?.name ?? "",
                "count": "\(1)"
            ]
            Global.addFirebaseEvent(eventName: "product_click_home_click", param: clickProductLogData)
            
            let vc = self.iq.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.persistance?.product = self.products?[indexPath.item]
            let productId = self.products?[indexPath.item].id ?? ""
            vc.persistance?.productImages = self.images?.filter { $0.productID ?? "" == productId  }.map { $0.img ?? "" } ?? []
            self.iq.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

///Top product categories collection view
extension ECommerceTableViewCell {
    
    func bindProductCategoriesCollectionView() {
        productCategoriedCollectionView.register(ProductCategoriesCollectionViewCell.loadNib(), forCellWithReuseIdentifier: "ProductCategoriesCollectionViewCell")
        productCategoriedCollectionView.delegate = productCategoriesCollectionView
        productCategoriedCollectionView.dataSource = productCategoriesCollectionView
        
        //one way binding collection view wrapper
        productCategoriesCollectionView.getNumberofRowsInSection { [weak self] collectionView, section in
            if self?.products?.count ?? 0 == 0 {
                collectionView.setErrorSuccessMessage(withErrorType: .error("No Products Found."))
            } else {
                collectionView.setErrorSuccessMessage(withErrorType: .removeMessage)
            }
            return self?.categories?.productCategories.count ?? 0
        }
        
        productCategoriesCollectionView.getCellForItemAt { [weak self] collectionView, indexPath in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoriesCollectionViewCell", for: indexPath) as? ProductCategoriesCollectionViewCell else { return UICollectionViewCell() }
            cell.productCategories = self?.categories?.productCategories[indexPath.item]
            return cell
        }
        
        productCategoriesCollectionView.getSizeForItemAt { collectionView, collectionViewLayout, indexPath in
            .init(width: (collectionView.frame.width / 2.4) - 2, height: collectionView.frame.height)
        }
        
        productCategoriesCollectionView.getDidSelectItemAt { collectionView, indexPath in
            
            //Logging
            let data = [
                "category_name": self.categories?.name ?? "",
                "sub_banner_name": self.categories?.productCategories[indexPath.item].name ?? "" ,
                "sub_banner_id": self.categories?.productCategories[indexPath.item].id ?? "",
                "count": "\(1)"
            ]
            Global.addFirebaseEvent(eventName: "home_category_sub_banner_click", param: data)
            //Logging end
            
            let vc = self.iq.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "InnerProductListViewController") as! InnerProductListViewController
            vc.persistance?.categories = self.categories
            vc.persistance?.products = self.getProductsAccordintToCategory(withCatId: "\(self.categories?.productCategories[indexPath.item].id ?? "-2")")
            vc.persistance?.selectedproductCategory = self.categories?.productCategories[indexPath.item]
            self.iq.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
