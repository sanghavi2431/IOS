//
//  IntroViewController.swift
//  Woloo
//
//  Created on 02/08/21.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bgViewHeightConstraint150: NSLayoutConstraint!
    @IBOutlet weak var pageController: UIPageControl!
    
    var getAppConfig = AppConfigGetObserver()
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? Double
    
    let appBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? Int
   
    
    private let introImages = [UIImage(named: "introImage1"), UIImage(named: "introImage2"), UIImage(named: "introImage3")]
    private let introTitles = ["Locate a Loo Nearby", "Track your Menstrual cycle", "Shopping made Convenient"]
    private let introDescription = ["Do not fear drinking water to avoid going to a loo. Locate nearest clean, safe & hygienic washrooms whenever you are travelling & away from home.", "A companion to not just track, but also manage your Periods cycle month-on-month for a safe, health & better life.", "Purchase with ease your favourite women’s hygiene, personal care & beauty products @ Woloo Store."]
    
    private var indexOfItem = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Intro Screen Loading")
        
       
       
    }
    
    private func intialSetup() {
        UserDefaults.tutorialScreen = true
        bgViewHeightConstraint150.constant = 0
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Cell.introCell, bundle: nil), forCellWithReuseIdentifier: Cell.introCell)
        pageController.numberOfPages = introImages.count
        collectionView.reloadData()
    }
    
}



// MARK: - @IBActions
extension IntroViewController {
    @IBAction func skipAction(_ sender: Any) {

        //indexOfItem = indexOfItem < introTitles.count - 1  ? indexOfItem + 2 : 0
    
        // indexOfItem = introTitles.count - 1

        collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        indexOfItem = indexOfItem < introTitles.count - 1  ? indexOfItem + 1 : 0
        collectionView.scrollToItem(at: IndexPath(item: indexOfItem, section: 0), at: .centeredHorizontally, animated: true)
        collectionScroll()
    }
    
    @IBAction func authenticationAction(_ sender: Any) {
        openLoginScreen()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        introTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.introCell, for: indexPath) as? IntroCell ?? IntroCell()
        cell.introTitleLabel.text = introTitles[indexPath.item]
        cell.introDescLabel.text = introDescription[indexPath.item]
        cell.introImageView.image = introImages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        indexOfItem = indexPath.item
        pageController.currentPage = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if indexOfItem == introTitles.count-1 {
            bgViewHeightConstraint150.constant = 150
        } else {
            bgViewHeightConstraint150.constant = 0
        }
    }
}

// MARK: - Logics
extension IntroViewController {
    private func collectionScroll() {
        guard let indexPath = collectionView.indexPathsForVisibleItems.first.flatMap({
               IndexPath(item: $0.item + 1, section: $0.section)
           }), collectionView.cellForItem(at: indexPath) != nil else {
               return
           }
        indexOfItem = indexPath.item
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

// MARK: - Handle Other Controller
extension IntroViewController {
    private func openLoginScreen() {
        let loginSB = UIStoryboard(name: "Authentication", bundle: nil)
        if let loginVC = loginSB.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
