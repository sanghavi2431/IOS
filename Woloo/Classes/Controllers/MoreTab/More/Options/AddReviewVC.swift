
//
//  AddReviewVC.swift
//  Woloo
//
//  Created by Vivek shinde on 23/12/20.
//

import UIKit

class AddReviewVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    var rateArray = [RatingOptions]()
    var loveOrImproveArray = [RatingOptions]()
    var noOfSection = 4//1
    var wolooStore: WolooStore?
    var wolooStoreV2: NearbyResultsModel?
    
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
        getReviewOptionListV2()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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

extension AddReviewVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return noOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingStarCell", for: indexPath) as! RatingStarCell
            cell.ratingStartCount = self.selectedRating
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
            if let index = self.selectedRating {
                let selectedTags = self.rateArray[self.rateArray.count - index]
                cell.configureUI(rateArray, selectedTags.displayName ?? "", self)
            } else {
                cell.configureUI(rateArray, "", self)
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingWithTextViewCell", for: indexPath) as! RatingWithTextViewCell
            cell.tagsField.removeTags()
            cell.configureUI(loveOrImproveArray, "",self)
            self.selectedTags.removeAll()
            if let constraint = cell.textFieldHeightConstraints {
                constraint.isActive = true
                constraint.constant = 60
            }
            cell.titleForSection.text = "Tell us what you love"//(self.selectedRating ?? 0) > 3 ? "Tell us what you love" : "Tell us where we can improve"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            cell.alpha = 0
            UIView.animate(withDuration: 1, animations: {
                cell.alpha = 0.9
            },completion: { finished in
                cell.alpha = 1
            })
        }
    }
}

// MARK: - FeedBackCellDelegate
extension AddReviewVC: FeedBackCellDelegate, RatingCellDelegate {
    func didEndFeedBack(_ text: String) {
        print("Add review VC didEndFeedBack: \(text)")
        self.feedBack = text
    }
    
    func updateRating(rating: Int) {
        self.selectedRating = rating
        self.loveOrImproveArray = (self.selectedRating ?? 0) > 3 ?  self.reviewOptionList?.ratingReview ?? [] : self.reviewOptionList?.ratingImprovement ?? []
        self.selectedTags.removeAll()
        self.selectedTags = []
        btnSubmit.backgroundColor = UIColor(named: "Woloo_Gray_bg")
        btnSubmit.isSelected = false
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}

// MARK: - TagListViewDelegate
extension AddReviewVC : TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if rateArray.contains(where: {$0.displayName?.lowercased() == title.lowercased()}) {
            sender.tagViews.forEach { (tag) in
                tag.isSelected = false
            }
            if let index = rateArray.firstIndex(where: {$0.displayName?.lowercased() == title.lowercased()}) {
                self.selectedRating = rateArray.count - index
                self.loveOrImproveArray = (self.selectedRating ?? 0) > 3 ?  self.reviewOptionList?.ratingReview ?? [] : self.reviewOptionList?.ratingImprovement ?? []
                self.selectedTags.removeAll()
                self.selectedTags = []
                btnSubmit.backgroundColor = UIColor(named: "Woloo_Gray_bg")
                btnSubmit.isSelected = false
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }
            return
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? RatingWithTextViewCell {
            if self.selectedTags.count == 0 {
                cell.tagsField.removeTags()
            }
            cell.insertTags(title)
            sender.removeTag(title)
            
            if let review = self.loveOrImproveArray.first(where: {$0.displayName?.lowercased() == title.lowercased()}) {
                selectedTags.append(review)
                btnSubmit.backgroundColor = UIColor(named: "Woloo_Yellow")
                btnSubmit.isSelected = true
              
            }
            
            cell.removeTag = { (tag) in // remove tag from selected tags.
                self.selectedTags.removeAll(where: {$0.displayName?.lowercased() == tag.lowercased() })
                   if self.selectedTags.count == 0 {
                    self.btnSubmit.backgroundColor = UIColor(named: "Woloo_Gray_bg")
                    self.btnSubmit.isSelected = false
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .none)
                   }
            }
        }
        
        tagView.isSelected = !tagView.isSelected
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
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Okay", title: "Thank you\nfor sharing your review", message: AppConfig.getAppConfigInfo()?.customMessage?.addReviewSuccessDialogText ?? "", image: nil, controller: self)
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
                    "rating": self.selectedRating ?? 0,
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
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Okay", title: "Thank you\nfor sharing your review", message: AppConfig.getAppConfigInfo()?.customMessage?.addReviewSuccessDialogText ?? "", image: nil, controller: self)
                    alert.cancelTappedAction = {
                        alert.removeFromSuperview()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
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
                    self.tableView.reloadData()
                    
                }
                
                

            case .failure(let error):
                Global.hideIndicator()
                print("get review options error Error",error)
               
            }
        }
        
    }
}
