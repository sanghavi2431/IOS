//
//  DetailsVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 25/10/24.
//

import UIKit
import Foundation

extension DetailsVC: UITableViewDelegate, UITableViewDataSource, DetailHostCellDelegate, DashboardViewModelDelegate {
    
    
    
    //MARK: - DashboardViewModelDelegate
    func didReceievGetUserProfile(objResponse: BaseResponse<UserProfileModel>) {
        //
    }
    
    func didReceievGetUserProfileError(strError: String) {
        //
    }
    
    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>) {
        //
    }
    
    func didReceiceWahCertificateError(strError: String) {
        //
    }
    
    func didReceiveCreditUserCoinsResponse(objResponse: CoinsWrapper) {
        //
    }
    
    func didReceiceCreditUserCoinsError(strError: String) {
        //
    }
   
    //MARK: - DetailHostCellDelegate
    func didSelectNavigationBtn(objNearbyResultsModel: NearbyResultsModel?) {
       
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.vehicleSelected = self.vehicleSelected
        objController.destLat = Double(objNearbyResultsModel?.lat ?? "")
        objController.destLong = Double(objNearbyResultsModel?.lng ?? "")
        objController.isSearch = self.isSearch
        objController.sourceLat = self.sourceLat
        objController.sourceLong = self.sourceLong
        objController.objNearbyResultsModel = objNearbyResultsModel ?? NearbyResultsModel()
        objController.strIsComeFrom = "Navigation"
        objController.strDestination = "\(objNearbyResultsModel?.name ?? "")"
        objController.wolooID = objNearbyResultsModel?.id ?? 0
        self.navigationController?.pushViewController(objController, animated: true)

    }
    
    func didSelectBookmamrkBtn(objNearbyResultsModel: NearbyResultsModel?) {
        
        self.wolooStoreDOV2 = objNearbyResultsModel ?? NearbyResultsModel()
        guard let stores2 = self.wolooStoreDOV2 else { return }
        print("like status: ", self.wolooStoreDOV2?.is_liked ?? 0)
        
        if let wid = stores2.id{
            
            if stores2.is_liked == 1{
                self.likeUnlikeWolooAPI(userID: String(UserDefaultsManager.fetchUserID()), wolooID: String(wid), like: 1)
                
            }
            else if stores2.is_liked == 0{
                self.likeUnlikeWolooAPI(userID: String(UserDefaultsManager.fetchUserID()), wolooID: String(wid), like: 0)
            }
            
            if ((self.delegate) != nil){
                self.delegate?.didChangedBookmarkStatus()
            }
        }
        
        self.detailTableView.reloadData()
    }
    
    func didSelectShareBtn(objNearbyResultsModel: NearbyResultsModel?) {
        guard let stores = self.wolooStoreDOV2 else { return }
        Global.addNetcoreEvent(eventname: self.netCoreEvents.shareWolooClick, param: [
            "woloo_id": stores.id ?? 0
                            ])
        let text = "\(stores.name ?? "")\n\(stores.address ?? "") \n\(UserDefaultsManager.fetchAppConfigData()?.URLS?.app_share_url ?? "")"
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
    
        self.present(activityViewController, animated: true, completion: nil)
    }
    
  
    //MARK: - UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 6
        }
        else if section == 1{
            print("review list count: ", self.reviewList.count)
            return self.reviewList.count
        }
        else{
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            if indexPath.row == 0 {
                //MARK: - Top opaque view
                var cell: DetailHeaderView? = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderView") as! DetailHeaderView?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("DetailHeaderView", owner: self, options: nil)?.last as? DetailHeaderView)
                }
              
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 1{
                //MARK: - Host detail view
                var cell: DetailHostCell? = tableView.dequeueReusableCell(withIdentifier: "DetailHostCell") as! DetailHostCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("DetailHostCell", owner: self, options: nil)?.last as? DetailHostCell)
                }
              
                cell?.delegate = self
                cell?.configureDetailHostCell(objNearbyResultsModel: self.wolooStoreDOV2)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 2{
                //MARK: - Amenities view
                var cell: DetailAmenitiesView? = tableView.dequeueReusableCell(withIdentifier: "DetailAmenitiesView") as! DetailAmenitiesView?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("DetailAmenitiesView", owner: self, options: nil)?.last as? DetailAmenitiesView)
                }
              
                cell?.setDataV2(tags: wolooStoreDOV2?.getAllOfferNameV2 ?? [])
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 3{
                //MARK: - Photos view
                var cell: DetailPhotoView? = tableView.dequeueReusableCell(withIdentifier: "DetailPhotoView") as! DetailPhotoView?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("DetailPhotoView", owner: self, options: nil)?.last as? DetailPhotoView)
                }
              
                cell?.photoList = self.wolooStoreDOV2?.image
                cell?.baseUrlImage = self.wolooStoreDOV2?.base_url ?? ""
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
            }
            else if indexPath.row == 4{
                //MARK: - Cibil image view
                var cell: DetailCibilImageView? = tableView.dequeueReusableCell(withIdentifier: "DetailCibilImageView") as! DetailCibilImageView?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("DetailCibilImageView", owner: self, options: nil)?.last as? DetailCibilImageView)
                }
              
                cell?.setV2(img: self.wolooStoreDOV2)
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
                
            }
            else if indexPath.row == 5{
                //MARK: - Review
                var cell: DetailReviewCell? = tableView.dequeueReusableCell(withIdentifier: "DetailReviewCell") as! DetailReviewCell?
                
                if cell == nil {
                    cell = (Bundle.main.loadNibNamed("DetailReviewCell", owner: self, options: nil)?.last as? DetailReviewCell)
                }
              
               // cell?.reviewList = self.reviewList
                cell?.addReviewBtnAction = {
                    [self] in
                    
                    let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
                    
                    vc?.wolooStoreID2 = wolooStoreDOV2?.id ?? 0
                    
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell!
                
            }
        }
        else if indexPath.section == 1{
            var cell: DetailsReviewTableCell? = tableView.dequeueReusableCell(withIdentifier: "DetailsReviewTableCell") as! DetailsReviewTableCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("DetailsReviewTableCell", owner: self, options: nil)?.last as? DetailsReviewTableCell)
            }
            cell?.configureDetailsReviewTableCell(objReviewDetail: self.reviewList[indexPath.row])
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        else{
            var cell: StoreHomePageHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "StoreHomePageHeaderCell") as! StoreHomePageHeaderCell?
            
            if cell == nil {
                cell = (Bundle.main.loadNibNamed("StoreHomePageHeaderCell", owner: self, options: nil)?.last as? StoreHomePageHeaderCell)
            }
          
            
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // When user reaches near the bottom, load next page
        if offsetY > contentHeight - frameHeight - 100 {
            self.getReviewList(woloo_id: wolooStoreDOV2?.id ?? 0, pageNumber: currentPage)
        }
    }
    
}
