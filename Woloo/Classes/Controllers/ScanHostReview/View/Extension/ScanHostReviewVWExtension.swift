//
//  ScanHostReviewVWExtension.swift
//  Woloo
//
//  Created by CEPL on 27/09/25.
//

import Foundation
import STPopup


extension ScanHostReviewVC: UITableViewDelegate, UITableViewDataSource, AddReviewSliderCellDelegate, AddReviewStarCellDelegate, AddReviewDescriptionCellDelegate, AddReviewSubmitBtnCellProtocol, WolooAlertPopUpViewDelegate, RateAToiletViewModelProtocol, BlogsPointsPopUpVCDelegate, SkipForNowCellProtocol, RateAToiletPopUpDelegate{
    
    //MARK: - RateAToiletPopUpDelegate
    
    
    //MARK: - SkipForNowCellProtocol
    func clickedBtnSkipForNow() {
        UserDefaultsManager.clearDeepLinkType()
        UserDefaultsManager.clearWahcode()
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    //MARK: - SkipForNowCellProtocol
   

    //MARK: - BlogsPointsPopUpVCDelegate
    func didMNavigateToStore() {
        UserDefaultsManager.clearDeepLinkType()
        UserDefaultsManager.clearWahcode()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - RateAToiletViewModelProtocol
    func didReceievCreateWolooWithRateToiletSuccess(objResponse: BaseResponse<StatusSuccessResponseModel>) {
        //
    }
    
    func didReceivecreteWolooWithRateToiletError(strError: String) {
        //
    }
    
    func didReceiveCreditUserCoinsResponse(objResponse: CoinsWrapper) {
        DispatchQueue.main.async{
            let objController = BlogsPointsPopUpVC(nibName: "BlogsPointsPopUpVC", bundle: nil)
            objController.delegate = self
            objController.strComeFrom = "SCAN"
            objController.pointCount = UserDefaultsManager.fetchAppConfigData()?.rate_a_toilet ?? ""
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
            
           
        }
    }
    
    func didReceiceCreditUserCoinsError(strError: String) {
        //
    }
    
    
    //MARK: - WolooAlertPopUpViewDelegate
    func closePopUp() {
        DispatchQueue.main.async {

            UserDefaultsManager.clearDeepLinkType()
            UserDefaultsManager.clearWahcode()
            
            self.objRateAToiletViewModel.creditUserCoins(blogId: 0, coins: Int(UserDefaultsManager.fetchAppConfigData()?.rate_a_toilet ?? "0"), isGift: 0, strRemarks: "Rate a Toilet", strType: "Manual Credit", woloo_id: self.objWahCertificate.woloo?.id, wolooCoins: 10)
            
        }
    }
    
    //MARK: - AddReviewSubmitBtnCellProtocol
    func didTappedSubmitRequestBtn() {
        print("call add review api")
            submitReviewAPIV2()
    }
    
    
    //MARK: - AddReviewDescriptionCellDelegate
    func didAddReview(feedback: String?) {
        self.feedBack = feedback ?? ""
    }
    
    //MARK: - AddReviewStarCellDelegate
    func didChangedStarValue(value: Float?) {
        self.objWahCertificate.woloo?.rating = value ?? 0.0
        print("Rating: ",  self.objWahCertificate.woloo?.rating ?? 0.0)
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
        
        self.objWahCertificate.woloo?.rating = value ?? 0.0
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
    }
    
    
    //MARK: - AddReviewSliderCellDelegate
    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            var cell: ScanWolooNameCell? = tableView.dequeueReusableCell(withIdentifier: "SearchWolooForRateCell") as! ScanWolooNameCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("ScanWolooNameCell", owner: self, options: nil)?.last as? ScanWolooNameCell)
            }
            
            
            cell?.configureScanWolooNameCell(objWahCertificate: self.objWahCertificate)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else if indexPath.row == 1 {
            
            var cell: AddReviewCibilImgViewCell? = tableView.dequeueReusableCell(withIdentifier: "AddReviewCibilImgViewCell") as! AddReviewCibilImgViewCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("AddReviewCibilImgViewCell", owner: self, options: nil)?.last as? AddReviewCibilImgViewCell)
            }
            
            cell?.configureAddReviewCibilImgViewCell(rating:  self.objWahCertificate.woloo?.rating ?? 0.0)
            
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
            cell?.configureAddReviewSliderCell(value:  self.objWahCertificate.woloo?.rating ?? 0.0)
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
            cell?.configureAddReviewStarCell(rating:  self.objWahCertificate.woloo?.rating ?? 0.0)
            
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
        else  if indexPath.row == 7{
        var cell: SkipForNowCell? = tableView.dequeueReusableCell(withIdentifier: "SkipForNowCell") as! SkipForNowCell?
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("SkipForNowCell", owner: self, options: nil)?.last as? SkipForNowCell)
        }
        cell?.delegate = self
        
        
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
        
        
    }
        return UITableViewCell()
    }
    
}
