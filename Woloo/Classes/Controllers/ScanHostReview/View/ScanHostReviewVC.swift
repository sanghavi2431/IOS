//
//  ScanHostReviewVC.swift
//  Woloo
//
//  Created by CEPL on 27/09/25.
//

import UIKit
import STPopup

class ScanHostReviewVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var objWahCertificate = WahCertificate()
    var feedBack = ""
    var selectedTags = [RatingOptions]()
    var objRateAToiletViewModel = RateAToiletViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.objRateAToiletViewModel.delegate = self
        
        
        if objWahCertificate.status == 1{
            DispatchQueue.main.async{
                let objController = BlogsPointsPopUpVC(nibName: "BlogsPointsPopUpVC", bundle: nil)
                // objController.delegate = self
                objController.pointCount = "100"
                let popup = STPopupController(rootViewController: objController)
                popup.style = .bottomSheet
                popup.present(in: DELEGATE.window?.rootViewController ?? self)
            }
        }
        
        
    }
    
    @IBAction func clickedBackBtn(_ sender: UIButton) {
        UserDefaultsManager.clearDeepLinkType()
        UserDefaultsManager.clearWahcode()
        self.navigationController?.popViewController(animated: true)
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
        var data = ["woloo_id": self.objWahCertificate.woloo?.id ?? 0,
                    "rating": self.objWahCertificate.woloo?.rating ?? 0,
                    "rating_option": tagsList,
                    "review_description": self.feedBack] as [String : Any]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        print("Feedback submit review : \(self.feedBack)")
        NetworkManager(data: data,headers: headers, url: nil, service: .submitReview, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<SubmitReviewModel>, Error>) in
            switch result{
            case .success(let response):
                Global.hideIndicator()
                //if let response = response{
                print("Submit review response\(response)")
                
                DispatchQueue.main.async {

                    let objController = RateAToiletPopUpVC.init(nibName: "RateAToiletPopUpVC", bundle: nil)
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
    
}
