//
//  EcommerceCategoriesView.swift
//  Woloo
//
//  Created by Rahul Patra on 02/08/21.
//

import UIKit

class EcommerceCategoriesView: UIView {

    //MARK:- Outlets
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainSectionHeaderView: UIView!
    
    //MARK:- Variables
    var headerView = BannerScrollView.loadNib()
    var categories: HomeCategories? {
        didSet {
            mainCollectionView.reloadData()
        }
    }
    
    //MARK:- life cycles
    override
    func awakeFromNib() {
        setViews()
    }
    
    //MARK:- Custom fucntions
    func setViews() {
        mainCollectionView.register(HeaderCategoriesCollectionViewCell.loadNib(), forCellWithReuseIdentifier: "HeaderCategoriesCollectionViewCell")
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        headerView?.translatesAutoresizingMaskIntoConstraints = false
        mainSectionHeaderView.addSubview(headerView ?? UIView())
        NSLayoutConstraint.activate([
            headerView!.leadingAnchor.constraint(equalTo: mainSectionHeaderView.leadingAnchor),
            headerView!.trailingAnchor.constraint(equalTo: mainSectionHeaderView.trailingAnchor),
            headerView!.topAnchor.constraint(equalTo: mainSectionHeaderView.topAnchor),
            headerView!.bottomAnchor.constraint(equalTo: mainSectionHeaderView.bottomAnchor)
        ])
    }
    
    class func loadNib() -> EcommerceCategoriesView? {
        UINib(nibName: "EcommerceCategoriesView", bundle: .main).instantiate(withOwner: self, options: nil).first as? EcommerceCategoriesView
    }
}

//MARK:- CollectionView Delegates and DataSources
extension EcommerceCategoriesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCategoriesCollectionViewCell", for: indexPath) as? HeaderCategoriesCollectionViewCell else { return UICollectionViewCell() }
        cell.category = categories?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryName = categories?[indexPath.item].name ?? ""
        let superCon = (self.iq.viewContainingController() as? ECommerceDashboardViewController)?.persistance?.profileDetails
        let data = [
            "category_name": categoryName,
            "mobile_number": superCon?.userData?.mobile ?? "",
            "date_time": "\(Date())",
        ]
        
        Global.addFirebaseEvent(eventName: "click_on_top_catrgory", param: data)
        let viewController = UIStoryboard(name: "Shop", bundle: .main).instantiateViewController(withIdentifier: "InnerProductListViewController") as! InnerProductListViewController
        viewController.persistance?.categories = categories?[indexPath.item]
        (self.iq.viewContainingController())?.navigationController?.pushViewController(viewController, animated: true)
        
    }
}
