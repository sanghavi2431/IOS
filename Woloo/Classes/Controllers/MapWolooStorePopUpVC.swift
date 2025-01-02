//
//  WoloosViewController.swift
//  Woloo
//
//  Created by Ashish Khobragade on 13/01/21.
//

import UIKit

protocol MapWolooStorePopUpVCDelegate:class {
    
    func collctionViewDidScrollTo(_ position:Int)
    func didSelectWolooStore(_ store: WolooStore)
    func didTapDismissButton()
}

class MapWolooStorePopUpVC: UIViewController {
    var wolooStore  = WolooStore ()
    var netcoreEvents = NetcoreEvents()
    
    var wolooStoreV2: NearbyResultsModel?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dismissButton: UIButton!
    var transportMode = TransportMode.car
    weak var delegate:MapWolooStorePopUpVCDelegate?
    
    var lastContentOffset = CGPoint()
    var nearByStoreResponseDO:NearByStoreResponse?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var nearByStoreResponseDoV2: [NearbyResultsModel]?{
        didSet{
            self.collectionView.reloadData()
        }
        
    }
    
    var viewTranslation:CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI()  {
        collectionView.register(MapWolooStoreCell.nib, forCellWithReuseIdentifier: MapWolooStoreCell.identifier)
       
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Private Methods
    
    @IBAction func didTapDismissButton(_ sender: Any) {
        
        delegate?.didTapDismissButton()
    }
    
    @IBAction func dismissPanGesture(gesture:UIPanGestureRecognizer)  {
        
        switch gesture.state {
        case .changed:
            
            viewTranslation = gesture.translation(in: view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            
            if viewTranslation.y < (UIScreen.main.bounds.size.height * 0.35)/2 {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                delegate?.didTapDismissButton()
            }
        default:
            break
        }
    }
    
    
}

// MARK: - UICollectionView Delegate & DataSource
extension MapWolooStorePopUpVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("nearByStoreResponseDoV2.count bottom sheet: \(nearByStoreResponseDoV2?.count ?? 0)")
        return nearByStoreResponseDoV2?.count ?? 0
        //return nearByStoreResponseDO?.stores?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapWolooStoreCell.identifier, for: indexPath) as? MapWolooStoreCell ?? MapWolooStoreCell()
        
//        let stores = self.nearByStoreResponseDO?.stores
//        cell.transportMode = transportMode
//        if let isLiked = stores?[indexPath.item].isLiked {
//            cell.likeBtn.isSelected = isLiked == 1 ? true : false
//        }
        
        let stores = self.nearByStoreResponseDoV2
        cell.transportMode = transportMode
        if let isLiked = stores?[indexPath.item].is_liked {
            cell.likeBtn.isSelected = isLiked == 1 ? true : false
        }
        
        cell.imgTravelMode.image = transportMode.whiteImage
        cell.directionBtnAction = {
            if cell.storeDistanceLabel.text == "-" {
                self.showNoDirectionAlert()
            } else {
//                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapDirectionVC") as? MapDirectionVC
//                guard let stores = self.nearByStoreResponseDoV2 else { return }
//                
//                vc?.hasStartedRouting = false
////                guard let stores = self.nearByStoreResponseDO?.stores else { return }
////                self.wolooStore = stores[indexPath.item]
//                self.wolooStoreV2 = stores[indexPath.item]
//                
//                vc?.destLat = self.wolooStoreV2?.lat ?? ""
//                vc?.destLong = self.wolooStoreV2?.lng ?? ""
//                vc?.cityName = self.wolooStoreV2?.city ?? ""
////                vc?.hasStartedRouting = false
////                vc?.transportMode = self.transportMode
//                
//                Global.addFirebaseEvent(eventName: "direction_woloo_click", param: [
//                                            "woloo_id": stores[indexPath.item].id ?? ""])
//                self.navigationController?.pushViewController(vc!, animated: true)
//                print("Woloo Store Latitude \(self.wolooStoreV2?.lat ?? "")")
//                print("Woloo Store Longitude \(self.wolooStoreV2?.lng ?? "")")
//                print("Woloo transport mode \(self.transportMode.name)")
//                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//                                      UIApplication.shared.openURL(URL(string:
//                                        "comgooglemaps://?q=\(self.wolooStoreV2?.lat ?? ""),\(self.wolooStoreV2?.lng ?? "")&sensor=false&directionsmode=driving")!)
//                                    } else {
//                                      print("Can't use comgooglemaps://");
//                                    }
//                                    print("Form here we will navigate to google Map SDk")
                
                Global.addNetcoreEvent(eventname: self.netcoreEvents.directionWolooClick, param:  ["woloo_id": self.nearByStoreResponseDoV2![indexPath.item].lng ?? "" as Any])
                
                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnrouteVC") as? EnrouteVC
                print("navigating from dashboard popup")
                print("destination long: \(self.nearByStoreResponseDoV2![indexPath.item].lat ?? ""), destination latitude: \(self.nearByStoreResponseDoV2![indexPath.item].lng ?? "")")
                
                vc?.destLat = Double(self.nearByStoreResponseDoV2![indexPath.item].lat ?? "")
                
                vc?.destLong = Double(self.nearByStoreResponseDoV2![indexPath.item].lng ?? "")
                
                vc?.destinationTxt = "\(self.nearByStoreResponseDoV2![indexPath.item].name ?? "")"
                vc?.storeID = self.nearByStoreResponseDoV2![indexPath.item].id ?? 0
                vc?.isDirection = true
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        cell.startBtnAction = {
            if cell.storeDistanceLabel.text == "-" {
                self.showNoDirectionAlert()
            } else {
                let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapDirectionVC") as? MapDirectionVC
                //guard let stores = self.nearByStoreResponseDO?.stores else { return }
                guard let stores = self.nearByStoreResponseDoV2 else { return }
                
                //vc?.wolooStore = stores[indexPath.item]
               // self.wolooStore = stores[indexPath.item]
//                vc?.hasStartedRouting = true
//                vc?.transportMode = self.transportMode
                self.wolooStoreV2 = stores[indexPath.item]
                
                vc?.destLat = self.wolooStoreV2?.lat ?? ""
                vc?.destLong = self.wolooStoreV2?.lng ?? ""
                vc?.cityName = self.wolooStoreV2?.city ?? ""
                
                Global.addFirebaseEvent(eventName: "start_woloo_click", param: [
                    "woloo_id": stores[indexPath.item].id ?? ""
                ])
                Global.addNetcoreEvent(eventname: self.netcoreEvents.startWolooClick, param: [
                    "woloo_id": self.wolooStoreV2?.id ?? ""
                                    ])
                self.navigationController?.pushViewController(vc!, animated: true)
                print("Woloo Store Latitude \(self.wolooStoreV2?.lat ?? "")")
                print("Woloo Store Longitude \(self.wolooStoreV2?.lng ?? "")")
                print("Woloo transport mode \(self.transportMode.name)")
//                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//                                      UIApplication.shared.openURL(URL(string:
//                                        "comgooglemaps://?q=\(self.wolooStoreV2?.lat ?? ""),\(self.wolooStoreV2?.lng ?? "")&sensor=false&directionsmode=driving")!)
//                                    } else {
//                                      print("Can't use comgooglemaps://");
//                                    }
//                                    print("Form here we will navigate to google Map SDk")
            }
        }
        cell.likeBtnAction = {
            
            if cell.likeBtn.isSelected{
                Global.addNetcoreEvent(eventname: self.netcoreEvents.likeWolooClick, param: [ "woloo_id": stores?[indexPath.item].id ?? 0])
                self.likeUnlikeWolooAPI(userID: String(UserDefaultsManager.fetchUserID()), wolooID: String(stores?[indexPath.item].id ?? 0), like: 1)
            } else if !cell.likeBtn.isSelected {
                self.likeUnlikeWolooAPI(userID: String(UserDefaultsManager.fetchUserID()), wolooID: String(stores?[indexPath.item].id ?? 0), like: 0)
            }
            //like api
//            cell.likeBtn.isSelected = !cell.likeBtn.isSelected
            guard let stores = self.nearByStoreResponseDO?.stores else { return }
            if let wid = stores[indexPath.item].storeId {
                if cell.likeBtn.isSelected {
                    Global.addFirebaseEvent(eventName: "like_woloo_click", param: [
                        "woloo_id": wid
                    ])
                    
                    Global.addNetcoreEvent(eventname: self.netcoreEvents.likeWolooClick, param: [ "woloo_id": wid])
                    self.likeUnlikeWolooAPI(userID: String(UserDefaultsManager.fetchUserID()), wolooID: String(self.wolooStoreV2?.id ?? 0), like: 1)
                   // self.likeWolooAPI(wolooId: wid)
                } else {
                    //self.unlikeWolooAPI(wolooId: wid)
                    self.likeUnlikeWolooAPI(userID: String(UserDefaultsManager.fetchUserID()), wolooID: String(self.wolooStoreV2?.id ?? 0), like: 0)
                }
            }
        }
        cell.shareBtnAction = {
//            guard let stores = self.nearByStoreResponseDO?.stores else { return }
//            Global.addFirebaseEvent(eventName: "share_woloo_click", param: [
//                "woloo_id": stores[indexPath.item].storeId ?? ""
//            ])
//            let text = "\(stores[indexPath.item].name ?? "")\n\(stores[indexPath.item].address ?? "") \n \(AppConfig.getAppConfigInfo()?.urls?.appShareURL ?? "")"
//            let textToShare = [text]
//            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = self.view
//            //            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
//            self.present(activityViewController, animated: true, completion: nil)
            //--------------------------------------------------------------------------------
            guard let stores = self.nearByStoreResponseDoV2 else {return}
            Global.addFirebaseEvent(eventName: "share_woloo_click", param: [
                "woloo_id": stores[indexPath.item].id ?? ""
            ])
            
            Global.addNetcoreEvent(eventname: self.netcoreEvents.shareWolooClick, param: [
                "woloo_id": stores[indexPath.item].id ?? ""
            ])
            
            let text = "\(stores[indexPath.item].name ?? "")\n\(stores[indexPath.item].address ?? "") \n \(AppConfig.getAppConfigInfo()?.urls?.appShareURL ?? "")"
            
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? MapWolooStoreCell else { print("MapWolooStoreCell not available"); return }
        
       // guard let stores = nearByStoreResponseDO?.stores else { return }
        
        guard let stores = nearByStoreResponseDoV2 else { return }
                
        cell.wolooStoreDoV2 = stores[indexPath.item]
        
        //cell.wolooStoreDO = stores[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let stores = nearByStoreResponseDO?.stores else { return }
        delegate?.didSelectWolooStore(stores[indexPath.item])
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension MapWolooStorePopUpVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size:CGSize = .zero
        size.width = collectionView.bounds.size.width - 20
        size.height = collectionView.bounds.size.height
        
        return size
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension MapWolooStorePopUpVC:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if abs(lastContentOffset.x - scrollView.contentOffset.x) < abs(lastContentOffset.y - scrollView.contentOffset.y) {
            //"Scrolled Vertically
        }
        else {
            //Scrolled Horizontally
            let pageWidth = scrollView.frame.width
            
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            print("scroll to index collectionView: \(currentPage)")
            
            delegate?.collctionViewDidScrollTo(currentPage)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
}
// MARK: - API
extension MapWolooStorePopUpVC {
    func likeWolooAPI(wolooId: Int) {
        APIManager.shared.wolooLike(param: ["wolooId": wolooId], completion: { (isSuccess, message) in
            if isSuccess {
                DispatchQueue.main.async {
                    //                    self.btnLike.isSelected = true
                }
            } else {
                self.showToast(message: message)
            }
        })
    }
    func unlikeWolooAPI(wolooId: Int) {
        APIManager.shared.wolooUnlike(param: ["wolooId": wolooId], completion: { (isSuccess, message) in
            if isSuccess {
                DispatchQueue.main.async {
                    //                    self.btnLike.isSelected = false
                }
            } else {
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
