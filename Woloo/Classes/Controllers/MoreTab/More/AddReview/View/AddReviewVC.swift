
//
//  AddReviewVC.swift
//  Woloo
//
//  Created by Vivek shinde on 23/12/20.
//

import UIKit
import STPopup

class AddReviewVC: UIViewController {
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBOutlet weak var tblView: UITableView!
    
    
    var sliderValues: [IndexPath: Float] = [:]
    var rateArray = [RatingOptions]()
    var loveOrImproveArray = [RatingOptions]()
    var noOfSection = 4//1
    var wolooStore: WolooStore?
    var wolooStoreV2: NearbyResultsModel?
    
    var rating: Float?
    var selectedRating: Int?
    var feedBack = ""
    var reviewOptionList: GetReviewOptionsListModel? //is equal to GetReviewOptionsModel
    var selectedTags = [RatingOptions]()
    
    
    var wolooStoreDOV2 : NearbyResultsModel?
    var wolooStoreID2: Int?
    var selectedTagsV2 = [RatingOptions]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //getReviewOptionList()
        //tabBarController?.tabBar.isHidden = true
//        DELEGATE.rootVC?.tabBarVc?.hideFloatingButton()
//        DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        getReviewOptionListV2()
        self.rating = 3
        tblView.delegate = self
        tblView.dataSource = self
        //tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // tabBarController?.tabBar.isHidden = false
//        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
//        DELEGATE.rootVC?.tabBarVc?.showTabBar()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if selectedTags.count > 0 && (self.selectedRating ?? 0) > 0 {
            //submitReviewAPI()
            submitReviewAPIV2()
            return
        }
        self.showToast(message: "Please fill all details.")
    }
}

// MARK: - API Calling
extension AddReviewVC {
    func submitReviewAPI() {
        let tagsList = self.selectedTags.compactMap { (review) in
            return "\(review.id ?? 0)"
        }
        let tagStr = tagsList.joined(separator: ",")
        let param: [String: Any] = ["wolooId": wolooStoreID2 ?? 0,
                                    "userRating": self.selectedRating ?? 0,
                                    "reviewOption": tagStr,
                                    "reviewDescription": self.feedBack]
        print("Woloo Store ID to send : \(wolooStoreID2 ?? 0)")
        print("Feedback submit review : \(self.feedBack)")
        
        Global.showIndicator()
        APIManager.shared.submitReviewAPI(param: param) { (status, message) in
            Global.hideIndicator()
            if status {
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Okay", title: "Thank you\nfor sharing your review", message: "By sharing your feedback you're helping other user like you with a hygienic washroom experience", image: nil, controller: self)
                    alert.cancelTappedAction = {
                        alert.removeFromSuperview()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                }
            }
            print("submit review api: ",message)
        }
    }
    
    func submitReviewAPIV2() {
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        let tagsList = self.selectedTags.compactMap { (review) in
            return "\(review.id ?? 0)"
        }
        print("review option: \(tagsList)")
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        let tagStr = tagsList.joined(separator: ",")
        var data = ["woloo_id": wolooStoreID2 ?? 0,
                    "rating": Int(self.rating ?? 0),
                    "rating_option": tagsList,
                    "review_description": self.feedBack] as [String : Any]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        print("Woloo Store ID to send : \(wolooStoreID2 ?? 0)")
        print("Feedback submit review : \(self.feedBack)")
        NetworkManager(data: data,headers: headers, url: nil, service: .submitReview, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<SubmitReviewModel>, Error>) in
            switch result{
            case .success(let response):
                Global.hideIndicator()
                //if let response = response{
                print("Submit review response\(response)")
                DispatchQueue.main.async {

                    let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                        
                    objController.isComeFrom = "AddReviewVC"
                    objController.delegate = self
                  
                    let popup = STPopupController.init(rootViewController: objController)
                    popup.present(in: self)
                    
                }
                
            case .failure(let error):
                Global.hideIndicator()
                print("Submit review Error",error)
               
            }
        }
        
        
    }
    
    func getReviewOptionList() {
        let param = ["wolooId": wolooStoreID2 ?? 0,
                                    "pageNumber": 1]
        print("woloo Store ID to send: \(wolooStoreID2 ?? 0)")
        APIManager.shared.getReviewOptionAPI(param: param) { [weak self] (reviewList, message) in
            guard let self = self else { return }
            if reviewList != nil {
//                self.reviewOptionList = reviewList
//                self.rateArray = reviewList?.ratingOption ?? []
//                self.rateArray.reverse()
//                self.loveOrImproveArray.removeAll()
//                self.tableView.reloadData()
            }
            print(message)
        }
    }
    
    func getReviewOptionListV2(){
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        var data = ["wolooId": wolooStoreID2 ?? 0]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .getReviewOptions, method: .get, isJSONRequest: false).executeQuery {(result: Result<BaseResponse<GetReviewOptionsListModel>, Error>) in
            switch result{
            case .success(let response):
                Global.hideIndicator()
                //if let response = response{
                print("get review options response\(response)")
                if response != nil {
                    self.reviewOptionList = response.results
                    self.rateArray = response.results.ratingOption ?? []
                    self.rateArray.reverse()
                    self.loveOrImproveArray.removeAll()
                   // self.tableView.reloadData()
                    
                }
                
                

            case .failure(let error):
                Global.hideIndicator()
                print("get review options error Error",error)
               
            }
        }
        
    }
}
