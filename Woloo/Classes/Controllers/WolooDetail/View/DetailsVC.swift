//
//  DetailsVC.swift
//  Woloo
//
//  Created by Ashish Khobragade on 29/12/20.
//
import UIKit

protocol DetailsVCProtocol: NSObjectProtocol{
    
    func didChangedBookmarkStatus()
}

class DetailsVC: UIViewController {
    //Details ---> name of segue id
    @IBOutlet weak var storeImage: UIImageView!

    var wolooStoreDOV2 : NearbyResultsModel?
    
    var enrouteStore: EnrouteListModel?
    
    var name: String?
    var id: Int?
    
    var nearByspecificData = NearbyWolooObserver()
    var nearByWoloo : NearbyResultsModel?
    
    var previousLikeStatus = -1
    var updatedLikeStatus = -1
    var delegate: DetailsVCProtocol?
   
    @IBOutlet weak var detailTableView: UITableView!
    
    var reviewList = [ReviewListModel.Review]()
    var tranportMode: TransportMode?
    
    var netCoreEvents = NetcoreEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        previousLikeStatus = wolooStoreDOV2?.is_liked ?? -1
        updatedLikeStatus = wolooStoreDOV2?.is_liked ?? -1
        
        
        getReviewList(woloo_id: wolooStoreDOV2?.id ?? 0, pageNumber: 1)
        print("Woloo Name: \(name), Woloo ID: \(id)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.navigationBar.isHidden = true
       // DELEGATE.rootVC?.tabBarVc?.showTabBar()
//        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
//        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        print("nearbyWoloo result on DetailsVC: \(nearByWoloo?.id ?? 0)")
        print("Image Id Array: \(self.wolooStoreDOV2?.title)")
        print("Selected details of woloo: \(self.wolooStoreDOV2)")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if previousLikeStatus != updatedLikeStatus {
            likeStatusGlobal = updatedLikeStatus
        }
        
        //self.navigationController?.navigationBar.isHidden = false
    }
    
    func configureUI()  {
      
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




// MARK: - ReviewListDelegate
extension DetailsVC: ReviewListDelegate {
    func openReviewDetail(_ review: Review) {
        performSegue(withIdentifier: Segues.reviewDetailSegue, sender: review)
    }
}

// MARK: - API's Calling
extension DetailsVC {

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
               
                    
            case .failure(let error):
                print(" Review list error", error)
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
