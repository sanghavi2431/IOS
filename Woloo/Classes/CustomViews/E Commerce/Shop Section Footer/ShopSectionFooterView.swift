//
//  BannerScrollView.swift
//  Woloo
//
//  Created by Rahul Patra on 02/08/21.
//

import UIKit

class ShopSectionFooterView: UIView {
    
    //MARK:- Static variables
    static let HEIGHT: CGFloat = 210
    
    //MARK:- Outlets
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    //MARK:- Variables
    var categories: HomeCategory?
    var mainCollectionViewOffSet: CGFloat = 0.0
    var currentIndex = 0
    var timer: Timer?
    
    var mainImage: String? {
        didSet {
            mainCollectionView.reloadData()
        }
    }
    
    //MARK:- Life Cycle fucntion
    override
    func awakeFromNib() {
        setViews()
    }
    
    //MARK:- Custo Functions
    func moveCollectionViewAutomatically(withCollectionView collectionView: UICollectionView) {
        mainCollectionViewOffSet =  collectionView.contentOffset.x
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [self] (_) in
            if 4 == currentIndex  {
                currentIndex = 0
            }
            mainCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
            currentIndex += 1
        }
    }
    
    
    func setViews() {
        mainCollectionView.register(BannerImageCollectionViewCell.self, forCellWithReuseIdentifier: "BannerImageCollectionViewCell")
        mainCollectionView.isPagingEnabled = true
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
//        moveCollectionViewAutomatically(withCollectionView: mainCollectionView)
    }
    
    //MARK:- Class Functions
    class func loadNib() -> ShopSectionFooterView? {
        UINib(nibName: "ShopSectionFooterView", bundle: .main).instantiate(withOwner: self, options: nil).first as? ShopSectionFooterView
    }
}

//MARK:- CollectionView Delegate and DataSource
extension ShopSectionFooterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCollectionViewCell", for: indexPath) as? BannerImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bannerImage = mainImage
        cell.mainImageView.layer.cornerRadius = 4
        cell.mainImageView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = [
            "category_name": categories?.name ?? "",
            "count": "\(1)"
        ]
        Global.addFirebaseEvent(eventName: "home_top_banner_click", param: data)
        
        let vc = self.iq.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "InnerProductListWithCategoriesViewController") as! InnerProductListWithCategoriesViewController
        vc.persistance?.categories = categories
        
        self.iq.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)
        /*let vc = self.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "InnerProductListViewController") as! InnerProductListViewController
        vc.persistance?.categories = categories
        self.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)*/
    }
}
