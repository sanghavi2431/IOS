//
//  BannerListCell.swift
//  Woloo
//
//  Created on 29/07/21.
//

import UIKit

class BannerListCell: UITableViewCell {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var myOfferHandler: (() -> Void)?

    
    private var bannerInfo2: [NearbyResultsModel]?
    
    private var bannerInfo: OfferReponse?
    private var bannerInfoV2: NearByLooOfferCountModel?
    
    var bannerSelectionHandler: ((_ index: IndexPath, _ offer: WolooOffer?) -> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollection()
    }
    
    /// Intialize delegate and datasource of collectionview.
    fileprivate func configureCollection() {
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: Cell.bannerCollectionCell, bundle: nil), forCellWithReuseIdentifier: Cell.bannerCollectionCell)
        bannerCollectionView.register(UINib(nibName: Cell.offerWolooCell, bundle: nil), forCellWithReuseIdentifier: Cell.offerWolooCell)
        bannerCollectionView.reloadData()
    }
    func setInfo(info: OfferReponse) {
        bannerInfo = info
        
        
        
        var count: Int = 0
        if info.wolooCount ?? 0 > 0 {
            count = count + 1
        }
        if info.offerCount ?? 0 > 0 {
            count = count + 1
        }
        if info.shopOffer?.count ?? 0 > 0 {
            count = count + (info.shopOffer?.count ?? 0)
        }
        pageController.numberOfPages = count
        bannerCollectionView.reloadData()
    }
    
    func setInfoV2(info: NearByLooOfferCountModel){
        
        bannerInfoV2 = info
        var count: Int = 0
        
        if info.wolooCount ?? 0 > 0 {
            count = count + 1
        }
        
        if info.offerCount ?? 0 > 0 {
            count = count + 1
        }
//        if info.shopOffer?.count ?? 0 > 0 {
//            count = count + (info.shopOffer?.count ?? 0)
//        }
        pageController.numberOfPages = count
        bannerCollectionView.reloadData()
    }
    
   
}

extension BannerListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 || section == 1 {
//            return  1
//        }
//        return bannerInfo?.shopOffer?.count ?? 0

//        if section == 0 {
//            let wolooCount = bannerInfo?.wolooCount ?? 0
//            if wolooCount > 0 {
//                return 1
//            } else {
//                return 0
//            }
//        } else if section == 1 {
//            let offerCount = bannerInfo?.offerCount ?? 0
//            if offerCount > 0 {
//                return 1
//            } else {
//                return 0
//            }
//        } else {
//            return bannerInfo?.shopOffer?.count ?? 0
//        }
        if section == 0 {
            let wolooCount = bannerInfoV2?.wolooCount ?? 0
            if wolooCount > 0 {
                return 1
            } else {
                return 0
            }
        } else if section == 1 {
            let offerCount = bannerInfoV2?.offerCount ?? 0
            if offerCount > 0 {
                return 1
            } else {
                return 0
            }
        } else {
//            return bannerInfo?.shopOffer?.count ?? 0
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.bannerCollectionCell, for: indexPath) as? BannerCollectionCell else { return UICollectionViewCell() }
            cellBannerConfigure(cell,indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.offerWolooCell, for: indexPath) as? OfferWolooCell else { return UICollectionViewCell() }
            cellOfferConfigure(cell,indexPath)
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = self.bannerCollectionView.frame.size.width
        pageController.currentPage = Int(self.bannerCollectionView.contentOffset.x / pageWidth)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        let visibleRect = CGRect(origin: self.bannerCollectionView.contentOffset, size: self.bannerCollectionView.bounds.size)
////        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
////        if let visibleIndexPath = self.bannerCollectionView.indexPathForItem(at: visiblePoint) {
////            if visibleIndexPath.section == 2 {
////                pageController.currentPage = visibleIndexPath.item + 2
//////                pageController.currentPage = visibleIndexPath.section == 0 ? 0 : 1
////            } else {
////                pageController.currentPage = visibleIndexPath.section == 0 ? 0 : 1
////            }
////        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-10, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("Your Location")
            DELEGATE.rootVC?.tabBarVc?.selectedIndex = 2
        } else if indexPath.section == 1 {
            print("My Offer")
            myOfferHandler?()
        } else {
            print("Copy Text")
            let offer = bannerInfo?.shopOffer?[indexPath.row]
            bannerSelectionHandler?(indexPath, offer)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// MARK: - Fill Cell
extension BannerListCell {
    fileprivate func cellBannerConfigure(_ cell: BannerCollectionCell,_ indexPath: IndexPath) {
        if indexPath.section == 0 {
            cell.fillInfo(title: "We have \(bannerInfoV2?.wolooCount ?? 0) Woloo hosts available in your location", description: "We provide the best service to keep your Health and Hygiene intact. Click to know more.", image: #imageLiteral(resourceName: "locationLightWoloo"))
        } else {
            cell.fillInfo(title: "You have \(bannerInfoV2?.offerCount ?? 0) Woloo hosts available with the Offers", description: "We provide the best service to keep your Health and Hygiene intact. Click to know more.", image: #imageLiteral(resourceName: "discountOfferWhite"))
        }
    }
    
    fileprivate func cellOfferConfigure(_ cell: OfferWolooCell,_ indexPath: IndexPath) {
        if let shopList = bannerInfo?.shopOffer {
            cell.setInfo(shopList[indexPath.item])
        }
    }
}
