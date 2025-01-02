//
//  BecomeHostVC.swift
//  Woloo
//
//  Created on 25/04/21.
//

import UIKit

class BecomeHostVC: UIViewController {
    
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var netcoreEvents = NetcoreEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    func setupCollectionView() {
        collVw.delegate = self
        collVw.dataSource = self
        collVw.isPagingEnabled = true
        self.pageController.numberOfPages = 4
        collVw.showsHorizontalScrollIndicator = false
        collVw.showsVerticalScrollIndicator = false
        collVw.register(UINib(nibName: "WelcomeCell", bundle: nil), forCellWithReuseIdentifier: "WelcomeCell")
        collVw.register(UINib(nibName: "BenifitsCell", bundle: nil), forCellWithReuseIdentifier: "BenifitsCell")
        collVw.register(UINib(nibName: "WahCell", bundle: nil), forCellWithReuseIdentifier: "WahCell")
        collVw.register(UINib(nibName: "CriteriaCell", bundle: nil), forCellWithReuseIdentifier: "CriteriaCell")
        collVw.reloadData()
    }
        
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSkipPressed(_ sender: Any) {
        
        Global.addNetcoreEvent(eventname: self.netcoreEvents.yesInterestedClick, param: [:])
        let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "BecomeHostFormVC") as? BecomeHostFormVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

// MARK: - UICollectionViewDelegate/ UICollectionViewDataSource
extension BecomeHostVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
       }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        switch indexPath.row {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeCell", for: indexPath) as? WelcomeCell ?? WelcomeCell()
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BenifitsCell", for: indexPath) as? BenifitsCell ?? BenifitsCell()
        case 2:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WahCell", for: indexPath) as? WahCell ?? WahCell()
        case 3:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CriteriaCell", for: indexPath) as? CriteriaCell ?? CriteriaCell()
//            if let criteriaCell = cell as? CriteriaCell {
//                criteriaCell.handleInterestedAction = {
//                    let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "BecomeHostFormVC") as? BecomeHostFormVC
//                    self.navigationController?.pushViewController(vc!, animated: true)
//                }
//            }
        default:
            break
        }
        return cell ?? UICollectionViewCell()
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//           return  CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
//       }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageController.currentPage = indexPath.item
    }
}

public func fixedScreenSize() -> CGSize {
    let screenSize = UIScreen.main.bounds.size
    return screenSize
}

public func SCREENWIDTH() -> CGFloat
{
    return fixedScreenSize().width
}

public func SCREENHEIGHT() -> CGFloat
{
    return fixedScreenSize().height
}
