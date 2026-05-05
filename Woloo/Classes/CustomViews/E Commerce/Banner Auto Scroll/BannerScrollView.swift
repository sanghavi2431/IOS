//
//  BannerScrollView.swift
//  Woloo
//
//  Created by Rahul Patra on 02/08/21.
//

import UIKit

class BannerScrollView: UIView {
    
    static let HEIGHT: CGFloat = 220
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var homeBanners: HomeBanners? {
        didSet {
            mainCollectionView.reloadData()
        }
    }
    
    override
    func awakeFromNib() {
        setViews()
    }
    
    var mainCollectionViewOffSet: CGFloat = 0.0
    var currentIndex = 0
    var timer: Timer?
    
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
        if homeBanners?.count ?? 0 != 0 {
            moveCollectionViewAutomatically(withCollectionView: mainCollectionView)
        }
    }
    

    class func loadNib() -> BannerScrollView? {
        UINib(nibName: "BannerScrollView", bundle: .main).instantiate(withOwner: self, options: nil).first as? BannerScrollView
    }
}


extension BannerScrollView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        homeBanners?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCollectionViewCell", for: indexPath) as? BannerImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.homeBanner = homeBanners?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
