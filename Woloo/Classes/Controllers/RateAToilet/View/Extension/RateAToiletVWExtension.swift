//
//  RateAToiletVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 20/01/25.
//

import Foundation
import UIKit
import STPopup

extension RateAToiletVC: UITableViewDelegate, UITableViewDataSource, SearchWolooForRateCellProtocol, SearchLocationEnrouteDelegate, RateAToiletViewModelProtocol, AddReviewSubmitBtnCellProtocol, AddReviewSliderCellDelegate, AddReviewStarCellDelegate, AddReviewDescriptionCellDelegate, WolooAlertPopUpViewDelegate, SearchWolooViewControllerDelegate{
    
    
    
    //MARK: - SearchWolooViewControllerDelegate
    func didSelectSearchedWoloos(objSearchWoloo: SearchWoloo?) {
        print("Add review: ", objSearchWoloo?.id ?? "")
        self.objSearchWoloo = objSearchWoloo ?? SearchWoloo()
        self.rating = Float(self.objSearchWoloo.average_rating ?? "0.0")
        self.strName = self.objSearchWoloo.name ?? ""
        self.sourceAddress = self.objSearchWoloo.address ?? ""
        self.city = self.objSearchWoloo.city ?? ""
        self.sourceLat = Double(self.objSearchWoloo.lat ?? "0.0")
        self.sourceLong = Double(self.objSearchWoloo.lng ?? "0.0")
        self.strPincode = String(self.objSearchWoloo.pincode ?? 0)
        
        self.tableView.reloadData()
        
    }
    
    //MARK: - WolooAlertPopUpViewDelegate
    func closePopUp() {
        //
    }
    
    
    //MARK: - AddReviewDescriptionCellDelegate
    func didAddReview(feedback: String?) {
        self.feedBack = feedback ?? ""
    }
    
    
    //MARK: - AddReviewStarCellDelegate
    func didChangedStarValue(value: Float?) {
        self.rating = value ?? 0.0
        print("Rating: ", self.rating ?? 0.0)
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
    }
    
    
    //MARK: - AddReviewSliderCellDelegate
    func didChangedSliderValue(value: Float?) {
        print("slider value: ", value ?? 0.0)
        
        if value ?? 0.0 < 1{
            print("poor score")
            
        }
        else if value ?? 0.0 < 2{
            print("fair score")
            
        }
        else if value ?? 0.0 < 3{
            print("Good score")
        }
        else if value ?? 0.0 < 4{
            print("Very Good score")
        }
        else if value ?? 0.0 <= 5{
            print("Excllent score")
        }
        
        self.rating = value ?? 0.0
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
    }
    
    
    //MARK: - AddReviewSubmitBtnCellProtocol
    func didTappedSubmitRequestBtn() {
        //        self.objRateAToiletViewModel.createWolooWithRateToilet(rating: 4, strReviewDescription: "Hello test review", strName: strName, strAddress: sourceAddress, strCity: city, lat: sourceLat, lng: sourceLong, strPincode: strPincode)
        //Global.showLoader()
        if Utility.isEmpty(self.city ?? ""){
            self.objRateAToiletViewModel.createWolooWithRateToilet(rating: Int(self.rating ?? 0.0), strReviewDescription: self.feedBack, strName: strName, strAddress: sourceAddress, strCity: city, lat: sourceLat, lng: sourceLong, strPincode: strPincode)
            self.showToast(message: "Please select place.")
            
        }
        else if Utility.isEmpty(self.feedBack ?? "") {
            self.showToast(message: "Please Enter Review.")
        }
        else{
            self.submitReviewAPIV2()
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
        var data = ["woloo_id": self.objSearchWoloo.id ?? 0,
                    "rating": Int(self.rating ?? 0),
                    "rating_option": tagsList,
                    "review_description": self.feedBack] as [String : Any]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        print("Woloo Store ID to send : \(self.objSearchWoloo.id ?? 0)")
        print("Feedback submit review : \(self.feedBack)")
        NetworkManager(data: data,headers: headers, url: nil, service: .submitReview, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<SubmitReviewModel>, Error>) in
            switch result{
            case .success(let response):
                Global.hideIndicator()
                //if let response = response{
                self.objSearchWoloo = SearchWoloo()
                self.rating = 0.0
                self.strName = ""
                self.sourceAddress = ""
                self.city = ""
                self.sourceLat = 0.0
                self.sourceLong = Double(self.objSearchWoloo.lng ?? "0.0")
                self.strPincode = ""
                print("Submit review response\(response)")
                DispatchQueue.main.async {

                    let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                        
                    objController.isComeFrom = "AddReviewVC"
                    objController.delegate = self
                  
                    let popup = STPopupController.init(rootViewController: objController)
                    popup.present(in: self)
                    
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                Global.hideIndicator()
                print("Submit review Error",error)
               
            }
        }
        
        
    }
    
    
    //MARK: - RateAToiletViewModelProtocol
    func didReceievCreateWolooWithRateToiletSuccess(objResponse: BaseResponse<StatusSuccessResponseModel>) {
       // self.hideLoader()
        DispatchQueue.main.async {

            let objController = WolooAlertPopUpView.init(nibName: "WolooAlertPopUpView", bundle: nil)
                
            objController.isComeFrom = "AddReviewVC"
            objController.delegate = self
          
            let popup = STPopupController.init(rootViewController: objController)
            popup.present(in: self)
            
        }
        
       // self.showToast(message: objResponse.results.message ?? "")
    }
    
    func didReceivecreteWolooWithRateToiletError(strError: String) {
        ///
    }
    
    
    //MARK: - SearchLocationEnrouteDelegate
    func didSearchedPlace(lat: Double, long: Double, strPlace: String?, selectedCity: String) {
        print("searched place: \(strPlace ?? "")")
        self.sourceLat = lat
        self.sourceLong = long
        self.sourceAddress = strPlace
        self.city = selectedCity
        self.tableView.reloadData()
    }
    
    
    //MARK: - SearchWolooForRateCellProtocol
    func didTappedSearchLocation(){
        let objController = SearchWolooViewController.init(nibName: "SearchWolooViewController", bundle: nil)
        objController.delegate = self
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //SearchWolooForRateCell
        if indexPath.row == 0 {
            
            var cell: SearchWolooForRateCell? = tableView.dequeueReusableCell(withIdentifier: "SearchWolooForRateCell") as! SearchWolooForRateCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("SearchWolooForRateCell", owner: self, options: nil)?.last as? SearchWolooForRateCell)
            }
          
            cell?.delegate = self
            cell?.txtFieldLSearchLocation.text = self.objSearchWoloo.name ?? ""
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 1 {
            
            var cell: AddReviewCibilImgViewCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewCibilImgViewCell") as! AddReviewCibilImgViewCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewCibilImgViewCell", owner: self, options: nil)?.last as? AddReviewCibilImgViewCell)
            }
          
            cell?.configureRateAToiletImgViewCell(rating: self.rating, objSearchWoloo: self.objSearchWoloo )
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 2 {
            var cell: AddReviewSliderCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewSliderCell") as! AddReviewSliderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewSliderCell", owner: self, options: nil)?.last as? AddReviewSliderCell)
            }
          
            // Capture slider value changes
            cell?.delegate = self
            cell?.configureAddReviewSliderCell(value: self.rating)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 3 {
            var cell: AddReviewSeparatorCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewSeparatorCell") as! AddReviewSeparatorCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewSeparatorCell", owner: self, options: nil)?.last as? AddReviewSeparatorCell)
            }
          
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 4 {
            var cell: AddReviewStarCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewStarCell") as! AddReviewStarCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewStarCell", owner: self, options: nil)?.last as? AddReviewStarCell)
            }
            cell?.delegate = self
            cell?.configureAddReviewStarCell(rating: self.rating)
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 5 {
            var cell: AddReviewDescriptionCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewDescriptionCell") as! AddReviewDescriptionCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewDescriptionCell", owner: self, options: nil)?.last as? AddReviewDescriptionCell)
            }
            cell?.delegate = self
            
            cell?.configureAddReviewDescriptionCell(feedBack: self.feedBack)
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
            
        }
        else if indexPath.row == 6 {
            var cell: AddReviewSubmitBtnCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewSubmitBtnCell") as! AddReviewSubmitBtnCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewSubmitBtnCell", owner: self, options: nil)?.last as? AddReviewSubmitBtnCell)
            }
            cell?.delegate = self
            
           
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
    
        }
        return UITableViewCell()
    }
}
    

