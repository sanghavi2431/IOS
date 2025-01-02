//
//  DetailsVC.swift
//  Woloo
//
//  Created by Ashish Khobragade on 29/12/20.
//

import UIKit

class DetailsVC: UIViewController {
    //Details ---> name of segue id
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var storeImage: UIImageView!
    var wolooStoreDO : WolooStore?
    
    @IBOutlet weak var startDirectionBtn: UIButton!
    var wolooStoreDOV2 : NearbyResultsModel?
    
    var enrouteStore: EnrouteListModel?
    
    var name: String?
    var id: Int?
    
    var nearByspecificData = NearbyWolooObserver()
    var nearByWoloo : NearbyResultsModel?
    
    var previousLikeStatus = -1
    var updatedLikeStatus = -1
    
    @IBOutlet weak var directionView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint! //Iphone = 130, ipad = ScreenHeight/3
    
    private var reviewList = [ReviewListModel.Review]()
    var tranportMode: TransportMode?
    
    var netCoreEvents = NetcoreEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        previousLikeStatus = wolooStoreDOV2?.is_liked ?? -1
        updatedLikeStatus = wolooStoreDOV2?.is_liked ?? -1
        
        //getReviewList()
        startDirectionBtn.isHidden = true
        getReviewList(woloo_id: wolooStoreDOV2?.id ?? 0, pageNumber: 1)
        print("Woloo Name: \(name), Woloo ID: \(id)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        print("nearbyWoloo result on DetailsVC: \(nearByWoloo?.id ?? 0)")
        print("Image Id Array: \(self.wolooStoreDOV2?.title)")
        print("Selected details of woloo: \(self.wolooStoreDOV2)")
        
        if wolooStoreDOV2?.is_liked == 1{
            likeButton.layer.borderColor = UIColor(named: "Woloo_Yellow")?.cgColor

            likeButton.setTitleColor(UIColor(named: "Woloo_Yellow") , for: .normal)

            let image = UIImage(systemName: "bookmark")!.withTintColor(UIColor(named: "Woloo_Yellow")!, renderingMode: .alwaysOriginal)
            likeButton.setImage(image, for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if previousLikeStatus != updatedLikeStatus {
            likeStatusGlobal = updatedLikeStatus
        }
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func configureUI()  {
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionViewTopConstraint.constant = UIScreen.main.bounds.height/3
        }
        
        print("Image Id Array: \(self.wolooStoreDOV2?.title)")
        
        if self.wolooStoreDOV2?.image?.count == 0 {
            
            print("No image found of woloo ID: \(wolooStoreDOV2?.name ?? "")")
           // self.storeImage.isHidden = true
        }else{
        
            let url = "\(wolooStoreDOV2?.base_url ?? "")/\(wolooStoreDOV2?.image?[0] ?? "")"
            let trimmedUrl = url.replacingOccurrences(of: " ", with: "")
            print("Image URL: \(wolooStoreDOV2?.base_url ?? "")/\(wolooStoreDOV2?.image?[0] ?? "")")
            self.storeImage.isHidden = false
            self.storeImage.sd_setImage(with: URL(string: trimmedUrl), completed: nil)
            
        }
        
        
        directionView.layer.cornerRadius = 16
        directionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.directionView.clipsToBounds = true
        //   storeImage.sd_setImage(with: wolooStoreDO?.image, completed: nil)
        
        collectionView.register(DetailImageHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailImageHeaderView.identifier)
        collectionView.register(StoreDetailsHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StoreDetailsHeaderView.identifier)
        collectionView.register(HighlightsHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HighlightsHeaderView.identifier)
        collectionView.register(PhotosCollectionView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotosCollectionView.identifier)
        collectionView.register(ReviewListView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewListView.identifier)
        
        collectionView.register(CibilImageView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CibilImageView.identifier)
        
        collectionView.cornerRadius = 16
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.reloadData()
        
    }
    
    private func changeLikeUnlikeUIChange() {
        likeButton.layer.borderColor = likeButton.isSelected ? UIColor(named: "Woloo_Yellow")?.cgColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        likeButton.setTitleColor(likeButton.isSelected ? UIColor(named: "Woloo_Yellow") : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            //let image = #imageLiteral(resourceName: "icons8-bookmark-30").withTintColor(likeButton.isSelected ? UIColor(named: "Woloo_Yellow")! : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) , renderingMode: .alwaysOriginal)
        let image = UIImage(systemName: "bookmark")!.withTintColor(likeButton.isSelected ? UIColor(named: "Woloo_Yellow")! : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) , renderingMode: .alwaysOriginal)
        likeButton.setImage(image, for: .normal)
    }
    
    func showNoDirectionAlert() {
        DispatchQueue.main.async {
            let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Close", title: "", message: "No route found for this transport mode. Please change mode and try again.", image: nil, controller: self)
            alert.cancelTappedAction = {
                alert.removeFromSuperview()
            }
            self.view.addSubview(alert)
            self.view.bringSubviewToFront(alert)
        }
    }
    @IBAction func didTapBackButton(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func directionAction(_ sender: Any) {
        
        if wolooStoreDO?.distance == "-" {
            showNoDirectionAlert()
        } else {
//            let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapDirectionVC") as? MapDirectionVC
            //guard let stores = self.wolooStoreDO else { return }
            
            guard let stores = self.wolooStoreDOV2 else { return }
//            vc?.hasStartedRouting = false
//                vc?.storeId2 = stores.id
//                vc?.cityName = stores.city ?? ""
//                vc?.destLong = stores.lng ?? ""
//                vc?.destLat = stores.lat ?? ""
//
//            self.navigationController?.pushViewController(vc!, animated: true)
//            vc?.wolooStore = stores
//            vc?.hasStartedRouting = false
            Global.addFirebaseEvent(eventName: "direction_woloo_click", param: [
                "woloo_id": stores.id ?? ""
            ])
            
            Global.addNetcoreEvent(eventname: netCoreEvents.directionWolooClick, param:  ["woloo_id": stores.id as Any])
            
            print("Woloo Store Directions Latitude \(stores.lat ?? "0")")
            print("Woloo Store Directions Longitude \(stores.lng ?? "0")")
//            print("Woloo transport mode \(transportMode.name)")
            
//            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//                                  UIApplication.shared.openURL(URL(string:
//                                                                    "comgooglemaps://?q=\(stores.lat ?? ""),\(stores.lng ?? "")&sensor=false&directionsmode=driving")!)
//                                } else {
//                                  print("Can't use comgooglemaps://");
//                                }
//                                print("Form here we will navigate to google Map SDk")

            let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnrouteVC") as? EnrouteVC
            vc?.destLat = Double(stores.lat!)
            
            vc?.destLong = Double(stores.lng!)
            
            vc?.destinationTxt = "\(stores.name ?? "")"
            vc?.storeID = stores.id ?? 0
            vc?.isDirection = true
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
    
    @IBAction func startAction(_ sender: Any) {
        if wolooStoreDO?.distance == "-" {
            showNoDirectionAlert()
        } else {
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapDirectionVC") as? MapDirectionVC
        //guard let stores = self.wolooStoreDO else { return }
          guard let stores = self.wolooStoreDOV2 else { return }
            
            print("Woloo Store Directions Start Latitude \(stores.lat)")
            print("Woloo Store Directions Start Longitude \(stores.lng)")
            
//            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//                                  UIApplication.shared.openURL(URL(string:
//                                                                    "comgooglemaps://?q=\(stores.lat ?? ""),\(stores.lng ?? "")&sensor=false&directionsmode=driving")!)
//                                } else {
//                                  print("Can't use comgooglemaps://");
//                                }
//                                print("Form here we will navigate to google Map SDk")
            
        //vc?.wolooStore = stores
        vc?.hasStartedRouting = true
            vc?.storeId2 = stores.id
            vc?.cityName = stores.city ?? ""
            vc?.destLong = stores.lng ?? ""
            vc?.destLat = stores.lat ?? ""
            
            
        Global.addFirebaseEvent(eventName: "start_woloo_click", param: [
            "woloo_id": stores.id ?? ""
        ])
            
            Global.addNetcoreEvent(eventname: self.netCoreEvents.startWolooClick, param: [
                "woloo_id": stores.id ?? ""
                                ])
            
        self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        guard let stores = self.wolooStoreDOV2 else { return }
        
//        Global.addFirebaseEvent(eventName: "share_woloo_click", param: [
//            "woloo_id": stores.id ?? ""
//        ])
        
        Global.addNetcoreEvent(eventname: self.netCoreEvents.shareWolooClick, param: [
            "woloo_id": stores.id
                            ])
        let text = "\(stores.name ?? "")\n\(stores.address ?? "") \n\(AppConfig.getAppConfigInfo()?.urls?.appShareURL ?? "")"
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceRect = (sender as! UIButton).frame
        }
        self.present(activityViewController, animated: true, completion: nil)
        
        
        /*
         Global.addFirebaseEvent(eventName: "share_woloo_click", param: [
             "woloo_id": wolooStore.storeId ?? ""
         ])
         let text = "\(wolooStore.name ?? "")\n\(wolooStore.city ?? "")"
         let textToShare = [text]
         let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
         activityViewController.popoverPresentationController?.sourceView = self.view
         //            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
         self.present(activityViewController, animated: true, completion: nil)
         */
    }
    
    @IBAction func likeAction(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
        changeLikeUnlikeUIChange()
        //guard let stores = self.wolooStoreDO else { return }
        guard let stores2 = self.wolooStoreDOV2 else { return }
        
        if let wid = stores2.id{
            if likeButton.isSelected {
                updatedLikeStatus = 1
                //Global.addNetcoreEvent(eventname: self.netCoreEvents.likeWolooClick, param: [ "woloo_id": wid])
                self.likeUnlikeWolooAPI(userID: String(UserDefaultsManager.fetchUserID()), wolooID: String(wid), like: 1)
                
                //wolooStoreDOV2?.is_liked = 1
            }else {
                updatedLikeStatus = 0
                self.likeUnlikeWolooAPI(userID: String(UserDefaultsManager.fetchUserID()), wolooID: String(wid), like: 0)
                
                //wolooStoreDOV2?.is_liked = 0
                }

        }
        
    }
    
}

// MARK: - Segue Handler
extension DetailsVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.reviewDetailSegue, let destination = segue.destination as? ReviewDetailViewController {
            if let review = sender as? Review {
                destination.reviewDetail = review
            }
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension DetailsVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "identifire", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 0 {
                let detailImageHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailImageHeaderView.identifier, for: indexPath) as! DetailImageHeaderView
                return detailImageHeaderView
            } else if indexPath.section == 1 {
                let detailsHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StoreDetailsHeaderView.identifier, for: indexPath) as? StoreDetailsHeaderView
                detailsHeaderView?.configureUI()
                
                detailsHeaderView?.setV2(store: wolooStoreDOV2, mode: .car)
                
                print("nearByspecificData.allCustomList: \(nearByspecificData.allCustomList ?? [])")
//                detailsHeaderView?.set(store: wolooStoreDO, mode: tranportMode ?? .car)
                detailsHeaderView?.redeemAction = {
                    self.callRedeemAPI()
                }
                return detailsHeaderView ?? StoreDetailsHeaderView()
            } else if indexPath.section == 2 {
                let highlightsHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HighlightsHeaderView.identifier, for: indexPath) as! HighlightsHeaderView
                
                
                //highlightsHeaderView.setDataV2(tags: ["Clean & Hygienic Toilets","Wheelchair","Convenience Shop","Safe Space"])
                print("Tapped hotel name: \(wolooStoreDOV2?.name ?? "")")
                print("Following are the configurable items : \(wolooStoreDOV2?.getAllOfferNameV2 ?? [])")
                
                highlightsHeaderView.setDataV2(tags: wolooStoreDOV2?.getAllOfferNameV2 ?? [])
                
//                highlightsHeaderView.setData(tags: wolooStoreDO?.getAllOfferName ?? [])
//                highlightsHeaderView.reloadCollection = { [weak self] in
//                    guard let self = self else { return }
//                    self.collectionView.reloadSections(IndexSet(integer: 2))
//                }
                return highlightsHeaderView
            } else if indexPath.section == 3 {
                let photoView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotosCollectionView.identifier, for: indexPath) as! PhotosCollectionView
                photoView.photoList = self.wolooStoreDOV2?.image
                photoView.baseUrlImage = self.wolooStoreDOV2?.base_url ?? ""
                
                print("Image List : \(self.wolooStoreDOV2?.image)")
                print("Base url: \(self.wolooStoreDOV2?.base_url ?? "")")
                
                return photoView
            }else if indexPath.section == 4{
                
                let cibilImg = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CibilImageView.identifier, for: indexPath) as! CibilImageView
                //detailsHeaderView?.setV2(store: wolooStoreDOV2, mode: .car)
                cibilImg.setV2(img: wolooStoreDOV2)
                return cibilImg
                
            } else {
                let reviewListView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReviewListView.identifier, for: indexPath) as! ReviewListView
                
                reviewListView.addReviewBtnAction = {
                    [self] in
                    
                    let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
                    
                    vc?.wolooStoreID2 = wolooStoreDOV2?.id ?? 0
                    
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                /*
                 let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
                 
                 self.navigationController?.pushViewController(vc!, animated: true)
                 */
                if reviewList.count == 0{
                    reviewListView.collectionView.isHidden = true
                }else {
                    reviewListView.reviewList = self.reviewList
                   // reviewListView.reviewRatingLabel.text = "\(self.wolooStoreDOV2?.user_rating ?? 0) Reviews"
                    reviewListView.delegate = self
                }
                
                
                return reviewListView
            }
        default:
            return UICollectionReusableView()
        }
    }
}
        
//// MARK: - UICollectionViewDelegateFlowLayout
extension DetailsVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        if self.wolooStoreDOV2?.image?.count == 0 && section == 3 { //Image section
            return .init(width: 50, height: 50)
        } else if  self.wolooStoreDOV2?.image == nil && section == 3 {
            return .init(width: 50, height: 50)
        }
        
        if section == 4 {
            
            return .init(width: 200, height: 250)
        }
        
        if section == 5 { // Review Section
            return .init(width: 200, height: 320)
        }
        //cg
        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
}


// MARK: - ReviewListDelegate
extension DetailsVC: ReviewListDelegate {
    func openReviewDetail(_ review: Review) {
        performSegue(withIdentifier: Segues.reviewDetailSegue, sender: review)
    }
}

// MARK: - API's Calling
extension DetailsVC {
//    func getReviewList() {
//        var request = ReviewListRequest()
//        //request.wolooId = self.wolooStoreDO?.storeId ?? 0
//        request.wolooId = self.wolooStoreDOV2?.id ?? 0
//        request.pageNumber = 1
//        APIManager.shared.getReviewList(request: request) { [weak self] (response, message) in
//            guard let self = self else { return }
//            if let response = response {
////                self.reviewList.append(contentsOf: response.review ?? [])
////                self.collectionView.reloadData()
//                return
//            }
//
//            print(message)
//        }
//    }
    
    func getReviewList(woloo_id: Int, pageNumber: Int){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }

        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        let data = ["woloo_id": woloo_id, "pageNumber": pageNumber] as [String: Any]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": "\(UserDefaultsManager.fetchAuthenticationToken())", "user-agent": userAgent]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .getReviewList, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ReviewListModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("Review list Success: ", response)
                self.reviewList.append(contentsOf: response.results.review ?? [])
                self.collectionView.reloadData()
                    
            case .failure(let error):
                print(" Review list error", error)
            }
        }
        
    }
    
    func callRedeemAPI() {
        if let offer = wolooStoreDO?.offer {
            APIManager.shared.redeemOffer(param: ["offer_id":"\(offer.offerId ?? 0)"]) { [self] (result, message) in
                if result?.userData?["id"] as? Int ?? 0 > 0 {
                    self.showToast(message: "Offer Redeemed!!")
//                    self.userJourneyAPI()
                } else {
                    self.showToast(message: "Some Error, Try again later")
                }
            }
        } else {
            self.showToast(message: "Currently, No offer available at this woloo.")
        }
    }
    
    func likeWolooAPI(wolooId: Int) {
        APIManager.shared.wolooLike(param: ["wolooId": wolooId], completion: { (isSuccess, message) in
            if isSuccess {
                
            } else {
                self.showToast(message: message)
            }
        })
    }
    func unlikeWolooAPI(wolooId: Int) {
        APIManager.shared.wolooUnlike(param: ["wolooId": wolooId], completion: { (isSuccess, message) in
            if isSuccess { } else {
                self.showToast(message: message)
            }
        })
    }
    func wolooLikeStatus(wolooId: Int) {
        APIManager.shared.wolooLikeStatus(param: ["wolooId": wolooId]) { (result, message) in
            if let response = result {
                if response.isLiked == 1 {
                    DispatchQueue.main.async {
                        //                        self.btnLike.isSelected = true
                    }
                }
            }
        }
    }
    
    fileprivate func userJourneyAPI() {
        let param:  [String : Any] =  [ "event_name": "user Login" ,
                                        "event_data": "user"]
        APIManager.shared.userJourney(param) {[weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                
            }
            print(message)
        }
    }
    
    func likeUnlikeWolooAPI(userID: String, wolooID: String, like: Int){
        
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        let data = ["user_id": userID, "woloo_id": wolooID, "like": like] as [String: Any]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")//UserDefaultsManager.fetchAuthenticationToken()
        let headers = ["x-woloo-token": "\(UserDefaultsManager.fetchAuthenticationToken())", "user-agent": userAgent]
        NetworkManager(data: data, headers: headers, url: nil, service: .wolooEngagement, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<WolooEngagementModel>, Error>) in
            switch result{
                
            case .success(let response):
                print("Woloo Engagement Success: ", response)
                            
            case .failure(let error):
                print(" Failed Woloo Engagement ", error)
            }
        }
    }
    
}
