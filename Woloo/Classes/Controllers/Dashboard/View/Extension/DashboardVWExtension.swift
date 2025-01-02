//
//  DashboardVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 03/10/24.
//

import Foundation
import UIKit
import GoogleMaps
import Smartech
import GooglePlaces




extension DashboardVC: UITableViewDelegate, UITableViewDataSource, DashboardViewModelDelegate {
    
    //MARK: - DashboardViewModelDelegate and API Calls
    
    //Wah Certificate API call
    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>) {
        openWahCerificateVC(store: objResponse.results)
    }
    
    func didReceiceWahCertificateError(strError: String) {
        self.showToast(message: strError)
    }
    
    
    //MARK: -DashboardViewModelDelegate
    func didReceievGetUserProfile(objResponse: BaseResponse<UserProfileModel>) {
        self.objUser = objResponse.results
        UserDefaultsManager.storeUserData(value: objResponse.results)
        DispatchQueue.main.async {
            self.setUerInfoV2()
        }
        
    }
    
    func didReceievGetUserProfileError(strError: String) {
        //
    }
    
    
    
    
    func voucherAPIV2(voucher: String, forceApply: Bool) {
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        //MARK: Network Call
        
        let data = ["voucher": voucher, "forceApply": forceApply] as [String : Any]
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .voucherApply, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<VoucherApplyModel>, Error>) in
            switch result{
            case .success(let response):
                
                print("Voucher apply succesfully Response: \(response)")
                self.voucherExpiryView.isHidden = true
                DispatchQueue.main.async {
                    if !(response.results.isAlreadyConsumed ?? false){
                        
                        if response.results.isAlreadyApplied == true {
                            print("Force update popup")
                            self.activeSubscriptionView.isHidden = false
                        }
                        else{
                            //remove voucher from defaults
                            UserDefaults.standard.removeObject(forKey: "voucher_Key")
                            UserDefaults.standard.synchronize()
                            //If you already have free trial active, your current applied voucher will get active after free trial ends
                            if response.results.isLifetime == 1 {
                                //infinte trial or lfetime trial
                                self.lblVoucherMessage.text = "\(response.results.message ?? "")\n Note: \(response.results.expiryNote ?? "")"
                                //                             self.lblVoucherMessage.text = "\(response.results.message ?? "")\n If you already have free trial active, your current applied voucher will get active after free trial ends"
                                self.freeTrailRemainingLabel.text = ""
                                self.imgVwVoucher.image = #imageLiteral(resourceName: "VoucherInfinite")
                                
                                self.voucherView.isHidden = false
                                self.voucherExpiryView.isHidden = true
                            }
                            else {
                                //free trial image shown
                                self.activeSubscriptionView.isHidden = true
                                self.lblVoucherExpiry.text = response.results.message ?? ""
                                
                                self.lblVoucherMessage.text = "\(response.results.message ?? "")"
                                
                                //                            self.lblVoucherMessage.text = "\(response.results.message ?? "")\n If you already have free trial active, your current applied voucher will get active after free trial ends"
                                self.voucherView.isHidden = false
                                self.freeTrailRemainingLabel.text = "\(response.results.days ?? 0) Days"
                                self.trialStatusLbl.text = "\(response.results.typeOfVoucher?.uppercased() ?? "")"
                                self.imgVwVoucher.image = #imageLiteral(resourceName: "woloo_empty")
                                self.voucherExpiryView.isHidden = true
                            }
                            
                        }
                        
                        
                    }
                }
                
            case .failure(let error):
                print("Voucher apply failed",error)
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Cancel", title: nil, message: "Link Expired", image: nil, controller: self)
                    alert.cancelTappedAction = {
                        print("open Settings")
                        alert.removeFromSuperview()
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                }
                
            }
        }
    }
    
    func userGiftPopUp(id: String){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        //"https://api.woloo.in/api/voucher/UserGiftPopUp?id=\(id)"
        //'https://staging-api.woloo.in/api/voucher/UserGiftPopUp?id=32707'
        NetworkManager(headers: headers, url: "https://api.woloo.in/api/voucher/UserGiftPopUp?id=\(id)", service: nil, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<UserGiftPopUpModel>, Error>) in
            switch result {
                
            case .success(let response):
                print("Show user gift pop up \(response)")
                self.giftReceivedPopUpView.isHidden = false
                self.giftCardPopUpLbl.text = response.results.message ?? ""
                //show the congratulations pop up UI
                
            case .failure(let error):
                print("User gift popup error: \(error)")
            }
        }
    }
    
    
    
    func getNearByStoresV2(lat: Double, lng: Double, mode: Int, range: String, is_offer: Int, showAll: Int, isSearch: Int){
        
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        
        DELEGATE.locationManager.startUpdatingLocation()
        //        if !isDataExistInAPI {
        //            return
        //        }
        print("GetNearby stores V2")
        let data = ["lat": lat, "lng": lng, "mode": mode, "range": range,"is_offer": is_offer, "showAll": showAll, "isSearch": isSearch ] as [String : Any]
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .nearByWoloo, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<[NearbyResultsModel]>, Error>) in
            
            switch result{
            case .success(let response):
                Global.hideIndicator()

                print(response.results.count ?? 0)

                self.nearbyListTblViewHeight.constant = (self.view.window?.fs_height ?? 0) * 0.4
                self.showNoWoloo = false
                // self.isDataExistInAPI = true
                self.nearByStoreResponseDOV2 = response.results
                self.allStoresListv2 = response.results
                //self.tableView.reloadData()
                self.nearByListTblView.reloadData()
                self.timeForExpandAndCollapse()
                self.allWolooList = response.results
                self.newMapContainerView.nearByStoreResponseDOV2 = response.results
                self.newMapContainerView.addAllMarkersV2()
                // }else{
                if self.allStoresListv2.count == 0{
                    print("no woloos found")
                    var param = [String:Any]()
                    param["location"] = "(\(lat),\(lng))"
                    Global.addNetcoreEvent(eventname: self.netCoreEvents.noLocationFound, param: param)
                    self.showNoWoloo = true
                    self.timeForExpandAndCollapse()
                    //self.isDataExistInAPI = false
                    // self.tableView.reloadData()
                    self.nearByListTblView.reloadData()
                    return
                }
                print("resposne for nearByV2: \(response)")
                // }
                
            case .failure(let error):
                Global.hideIndicator()
                print("reponse results v2 Error",error)
                self.showNoWoloo = true
                // self.tableView.reloadData()
                self.nearByListTblView.reloadData()
            }
        }
        
        
    }
    
    func wahCertificateAPICall(){
        self.objDashboardViewModel.wahCertificateAPI(wolooID: UserDefaultsManager.fetchWahCode())
    }
    
    func wahCertificateAPI(code: String) {
        let param: [String: Any] = ["woloo_id": code]
        APIManager.shared.wahCertificate(param: param) { [weak self] (result, message) in
            guard let self = self else { return }
            if let store = result {
                // self.openWahCerificateVC(store: store)
            }
            print(message)
        }
    }
    
    func getPlaceDetails(result: GMSAutocompletePrediction) {
        Global.showIndicator()
        //let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.addressComponents.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
        
        let fields = GMSPlaceField(rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.placeID.rawValue | GMSPlaceField.addressComponents.rawValue | GMSPlaceField.coordinate.rawValue)
        
        GMSPlacesClient.shared().fetchPlace(fromPlaceID: result.placeID, placeFields: fields, sessionToken: self.googleToken, callback: { (place: GMSPlace?, error: Error?) in
            Global.hideIndicator()
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                // self.shouldFetchData = true
                self.selectedPlace = place
                print("selcted place name: \(self.selectedPlace?.description)")
                
                self.searchedlong = self.selectedPlace?.coordinate.longitude
                self.searchedLat = self.selectedPlace?.coordinate.latitude
                
                print("Search Latitude: \(place.coordinate.latitude) Longitude: \(place.coordinate.longitude)")
                Global.addNetcoreEvent(eventname: self.netCoreEvents.searchWolooClick, param: ["keywords": self.searchByLocationTxtField.text ?? "","location": "(\(place.coordinate.latitude),\(place.coordinate.longitude))"])
                
                let camera = GMSCameraPosition(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 14)
                self.newMapContainerView.camera = camera
                DispatchQueue.main.async {
                    self.getNearByStoresV2(lat: place.coordinate.latitude, lng: place.coordinate.longitude, mode: 1, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                }
                
                
            }
        })
        
    }

    
    
    
    //MARK: - UItableview and UIdatasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case nearByListTblView:
            return 2
            
        case sosPlaceTblView:
            return 2
            
        default:
            print("No table found")
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("allStoresListv2.count \(allStoresListv2.count)")
        var numberOfRow = 1
        switch tableView {
        case nearByListTblView:
            if section == 0{
                if allStoresListv2.count == 0{
                    numberOfRow = 1
                }
                else{
                    numberOfRow = allStoresListv2.count
                }
            } else if section == 1  && allStoresListv2.count > 0{
                numberOfRow = 1
            }
            
            
        case searchTblView:
            numberOfRow = self.searchList?.count ?? 0
            
        case sosPlaceTblView:
            if section == 0{
                return 1
            }
            else{
                return 4
            }
            
            
        default:
            print("Some things Wrong!!")
        }
        
        //        if allStoresListv2.count == 0{
        //            return 1
        //        }
        // return allStoresListv2.count
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch tableView{
            
        case sosPlaceTblView:
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: DismissBtnCell.identifier, for: indexPath) as? DismissBtnCell ?? DismissBtnCell()
                
                cell.btnDismiss.addTarget(self, action: #selector(clickeDismissBtn), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.section == 1{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: NearestPlaceTblVWCell.identifier, for: indexPath) as? NearestPlaceTblVWCell ?? NearestPlaceTblVWCell()
                
                
                
                if indexPath.row == 0{
                    cell.lblTitle.text = "Woloo Support"
                    cell.nearByPlace = wolooSupport
                    
                }
                else if indexPath.row == 1{
                    cell.lblTitle.text = "Hospital"
                    cell.nearByPlace = nearestHospital
                }
                else if indexPath.row == 2{
                    cell.lblTitle.text = "Police Station"
                    cell.nearByPlace = nearestPoliceStation
                    
                }
                else if indexPath.row == 3{
                    cell.lblTitle.text = "Fire Station"
                    cell.nearByPlace = nearestFireStation
                }
                
                cell.selectionStyle = .none
                return cell
            }
        case searchTblView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationCellDashboard", for: indexPath)
            cell.textLabel?.text = self.searchList?[indexPath.row] as? String ?? ""
            //cell.backgroundColor = UIColor.green
            
            
        case nearByListTblView:
            if indexPath.section == 0{
                print("section item to display")
                if allStoresListv2.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NoWolooDashboardCell.identifier, for: indexPath) as? NoWolooDashboardCell ?? NoWolooDashboardCell()
                    cell.searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
                    if openNowBtn.isSelected{
                        self.showToast(message: "No Woloos available at the moment.!")
                    }
                    return cell
                    
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: DashboardDirectionCell.identifier, for: indexPath) as? DashboardDirectionCell ?? DashboardDirectionCell()
                    ///-------------------------------------------------------------------------------------
                    let customList = getNearbyWoloo.nearbyWolooObserver?[indexPath.row]
                    cell.customStore = allStoresListv2[indexPath.row]
                    ///-------------------------------------------------------------------------------------
                    //            let store = allStoresList[indexPath.row]
                    //
                    
                    //
                    //            cell.store = store
                    cell.imgTravelMode.image = transPortMode.whiteImage
                    cell.directionBtnAction = { [self] in
                        //                Global.showAlert(title: "Message", message: "Feature in progress")
                        //                return
                        if cell.lblDistance.text == "-" {
                            self.showNoDirectionAlert()
                        } else {
                            let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnrouteVC") as? EnrouteVC
                            //                    guard let stores = self.nearByStoreResponseDO?.stores else { return }
                            
                            // guard let stores = self.nearByStoreResponseDOV2 else { return }
                            
                            let stores = allStoresListv2
                            vc?.destLat = Double(allStoresListv2[indexPath.row].lat ?? "")
                            vc?.destLong = Double(allStoresListv2[indexPath.row].lng ?? "")
                            print("name passed: \(allStoresListv2[indexPath.row].name ?? "")")
                            vc?.destinationTxt = "\(allStoresListv2[indexPath.row].name ?? "")"
                            vc?.storeID = allStoresListv2[indexPath.row].id ?? 0
                            vc?.isDirection = true
                            //  vc?.destinationTxtLbl.text = "\(allStoresListv2[indexPath.row].name ?? "")"
                            Global.addNetcoreEvent(eventname: self.netCoreEvents.directionWolooClick, param:  ["woloo_id": allStoresListv2[indexPath.row].id ?? "" as Any])
                            self.navigationController?.pushViewController(vc!, animated: true)
                            
                            
                        }
                    }
                    
                    return cell
                }
            } else if indexPath.section == 1 {
                
                cell.backgroundColor = UIColor(hexString: "#414042")
                
                print("show bottom button")
                let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreButtonCell.identifier, for: indexPath) as? ShowMoreButtonCell ?? ShowMoreButtonCell()
                
                cell.showMoreBtn.addTarget(self, action: #selector(loadMoreWoloo(sender:)), for: UIControl.Event.touchUpInside)
                
                
                return cell
            }
            
            
        default:
            print("Some things Wrong!!")
        }
        return cell
    }//end of uitableView cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
            
        case searchTblView:
            print("City tapped: \(searchList?[indexPath.row])")
            getPlaceDetails(result: placeResult[indexPath.row])
            self.searchByLocationTxtField.text = "\(searchList?[indexPath.row] ?? "")"
            self.searchTblView.isHidden = true
            self.bookmarkBtn.isSelected = false
            self.openNowBtn.isSelected = false
            
        case nearByListTblView:
            if allStoresListv2.count > indexPath.row {
                self.dismissContainerView()
                //performSegue(withIdentifier: Constant.Segue.details, sender: getNearbyWoloo.nearbyWolooObserver?[indexPath.row])
                Global.addNetcoreEvent(eventname: self.netCoreEvents.wolooClickedFromSearchedWoloo, param: [
                    "keywords": self.searchByLocationTxtField.text ?? "",
                    "host_click_location": "(\(allStoresListv2[indexPath.row].lat ?? ""),\(allStoresListv2[indexPath.row].lng ?? ""))",
                    "host_click_id": "\(allStoresListv2[indexPath.row].id ?? 0)"])
                
                if let currentLocation = DELEGATE.locationManager.location {
                    
                    Global.addNetcoreEvent(eventname: netCoreEvents.wolooDetailClick, param:  ["location": "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))","travel_mode": "", "host_click_id": "\(allStoresListv2[indexPath.row].id ?? 0)","host_click_location": "\(allStoresListv2[indexPath.row].lat ?? ""), \(allStoresListv2[indexPath.row].lng ?? "")"])
                    
                    //Global.addNetcoreEvent(eventname: netCoreEvents.hostNearYouClick, param: param)
                }
                
                dashboardScreenTag = 1
                print("Passed array index: \(allStoresListv2[indexPath.row])")
                selectedWolooGlobal = allStoresListv2[indexPath.row]
                performSegue(withIdentifier: Constant.Segue.details, sender: allStoresListv2[indexPath.row])
            }
            
        case sosPlaceTblView:
            if indexPath.row == 0{
                self.callNumber(phoneNumber: self.wolooSupport?.phone ?? "")
            }
            else if indexPath.row == 1{
                
                
                self.callNumber(phoneNumber: nearestHospital?.phone ?? "102")
            }
            else if indexPath.row == 2{
                self.callNumber(phoneNumber: nearestPoliceStation?.phone ?? "100")
            }
            else if indexPath.row == 3{
                self.callNumber(phoneNumber: nearestFireStation?.phone ?? "101")
            }
            
        default:
            print("No table found")
            
        }
        
    }
}
