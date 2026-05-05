//
//  EnrouteVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 18/11/24.
//

import Foundation
import CoreLocation
import GoogleMaps
import GooglePlaces
import STPopup

extension EnrouteViewController: SearchLocationEnrouteDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DashboardCollectionViewCellDelegate, DetailsVCProtocol, DashboardViewModelDelegate, BlogsPointsPopUpVCDelegate, UIScrollViewDelegate{
   
    
    
    //MARK: - BlogsPointsPopUpVCDelegate
    func didMNavigateToStore() {
        //
    }
    
  
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
        DispatchQueue.main.async{
            
            if self.strIsComeFrom == "Navigation"{
//                let objController = BlogsPointsPopUpVC(nibName: "BlogsPointsPopUpVC", bundle: nil)
//                objController.delegate = self
//                objController.pointCount = UserDefaultsManager.fetchAppConfigData()?.take_me_here ?? ""
//                let popup = STPopupController(rootViewController: objController)
//                popup.style = .bottomSheet
//                popup.present(in: DELEGATE.window?.rootViewController ?? self)
                
                
                Global.addNetcoreEvent(eventname: self.netCoreEvents.takeMeHere, param: [
                    "woloo_id": self.wolooID ?? 0])
                
            }
            else{
                let objController = BlogsPointsPopUpVC(nibName: "BlogsPointsPopUpVC", bundle: nil)
                objController.delegate = self
                objController.pointCount = UserDefaultsManager.fetchAppConfigData()?.no_woloo_found ?? ""
                let popup = STPopupController(rootViewController: objController)
                popup.style = .bottomSheet
                popup.present(in: DELEGATE.window?.rootViewController ?? self)
                
                Global.addNetcoreEvent(eventname: self.netCoreEvents.noWolooFound, param: [:])
            }
        }
    }
    
    func didReceiceCreditUserCoinsError(strError: String) {
        //
    }
    
    
    
    //MARK: - DetailsVCProtocol
    func didChangedBookmarkStatus() {
        
        
        self.fetchRoute(from: CLLocationCoordinate2D(latitude: (self.sourceLat ?? 0.0)!, longitude: (self.sourceLong ?? 0.0)!) , to: CLLocationCoordinate2D(latitude: (self.destLat ?? 0.0)!, longitude: (self.destLong ?? 0.0)!))
        
        if self.delegate != nil{
            self.delegate?.didChangedBookmarkStatus()
        }
    }
    
    
    //MARK: - DashboardCollectionViewCellDelegate
    func didClickedNavigate(obj: NearbyResultsModel) {
        
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.destLat = Double(obj.lat ?? "")
        objController.destLong = Double(obj.lng ?? "")
        objController.objNearbyResultsModel = obj
        objController.isSearch = self.isSearch
        objController.sourceLat = self.sourceLat
        objController.sourceLong = self.sourceLong
//        objController.lblTime.text = obj.duration ?? ""
//        objController.lblDistance.text = obj.distance ?? ""
        objController.vehicleSelected = self.vehicleSelected
        objController.strIsComeFrom = "Navigation"
        objController.strDestination = "\(obj.name ?? "")"
        objController.wolooID = obj.id
        self.navigationController?.pushViewController(objController, animated: true)
        
    }
    

    
    
    //MARK: - SearchLocationEnrouteDelegate
    func didSearchedPlace(lat: Double, long: Double, strPlace: String?,selectedCity: String, strBuildingName: String?, strLocality: String?, strCity: String?, strState: String?, strPincode: String?, strFullAddress: String?) {
        print("searched place: \(strPlace ?? "")")
        
        if self.strSource_Destination == SELCTED_ENROUTE_TYPE.SOURCE.rawValue {
            self.isSearch = true
            self.sourceLat = lat
            self.sourceLong = long
            self.sourceAddress = strPlace
            self.txtFieldCurrentLocation.text = "\(strFullAddress ?? "")"
        }
        else{
            self.destLat = lat
            self.destLong = long
            self.destAddress = strPlace
            self.txtFieldDestinationLocation.text = "\(strFullAddress ?? "")"
            self.vwBottomBack.isHidden = false
        }
        
    

        self.fetchRoute(from: CLLocationCoordinate2D(latitude: (self.sourceLat ?? 0.0)!, longitude: (self.sourceLong ?? 0.0)!) , to: CLLocationCoordinate2D(latitude: (self.destLat ?? 0.0)!, longitude: (self.destLong ?? 0.0)!))
        
    }
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker location - \(marker.title ?? ""): <\(marker.position.latitude), \(marker.position.longitude)>")
        //delegate?.didTapMarker(marker)
        //marker.title =
        showCustomInfoView(for: marker)
        didTapMarker(marker)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // Remove the custom info view if the map is tapped
        customInfoView.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        // Reposition the info view as the map moves
        guard let selectedMarker = selectedMarker else { return }
        let point = self.vwMap.projection.point(for: selectedMarker.position)
        customInfoView.center = CGPoint(x: point.x, y: point.y - 90)
    }
    
    // Show custom info view
    func showCustomInfoView(for marker: GMSMarker) {
        // Remove any existing info view
        customInfoView.removeFromSuperview()
        
        let frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: 135, height: 80)
        customInfoView = UINib(nibName: "CustomInfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CustomInfoView ?? CustomInfoView()
        customInfoView.frame = frame
        
        // Convert marker's position to screen coordinates
        let point = self.vwMap.projection.point(for: marker.position)
        customInfoView.center = CGPoint(x: point.x, y: point.y - 60)
        
        // Ensure marker zIndex is valid before accessing array
        let markerIndex = Int(marker.zIndex)
        if markerIndex >= 0 && markerIndex < allStoresListv2.count {
            if let scoreRange = allStoresListv2[markerIndex].cibil_score, let upperScore = scoreRange.components(separatedBy: "-").last {
                customInfoView.lblWahScore.text = upperScore
            } else {
                customInfoView.lblWahScore.text = ""
            }
        } else {
            customInfoView.lblWahScore.text = ""
        }
        
        // Add the custom info view to the map view
        vwMap.addSubview(customInfoView)
        selectedMarker = marker
    }
    
    func didTapMarker(_ marker: GMSMarker) {

        print("marker z index tapped: \(Int(marker.zIndex))")
//        popUp.collectionView.scrollToItem(at: IndexPath(item: Int(marker.zIndex), section: 0), at: .centeredHorizontally, animated: true)
        
        let vc = UIStoryboard.init(name: "Details", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
        vc?.wolooStoreDOV2 = allStoresListv2[Int(marker.zIndex)]
        self.navigationController?.pushViewController(vc!, animated: true)
     
    }
    
    
    //MARK: - UI collection view and datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allStoresListv2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCollectionViewCell.identifier, for: indexPath) as? DashboardCollectionViewCell ?? DashboardCollectionViewCell()
        cell.delegate = self
        cell.configureDashboardCollectionViewCell(objNearbyResultsModel: self.allStoresListv2[indexPath.item], strTransportType: self.vehicleSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = (UIStoryboard.init(name: "Details", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC)!
        
        vc.delegate = self
        vc.wolooStoreDOV2 = allStoresListv2[indexPath.item]
        vc.tranportMode = transPortMode
        vc.vehicleSelected = self.vehicleSelected
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Use screen width minus 12 for cell width (same as DashboardVC)
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 12
        
        return CGSize(width: itemWidth, height: 184)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        
        let centerPoint = CGPoint(
            x: scrollView.contentOffset.x + scrollView.bounds.width / 2,
            y: scrollView.bounds.height / 2
        )
        
        guard let indexPath = collectionView.indexPathForItem(at: centerPoint),
              indexPath.item < allStoresListv2.count else { return }
        
        let store = allStoresListv2[indexPath.item]
        
        // Update camera position
        if let latString = store.lat, let lngString = store.lng,
           let lat = Double(latString), let lng = Double(lngString) {
            let camera = GMSCameraPosition(
                latitude: lat,
                longitude: lng,
                zoom: 14
            )
            self.vwMap.camera = camera
            
            // Show custom info view for the corresponding marker
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            marker.zIndex = Int32(indexPath.item)
            marker.title = store.name ?? ""
            
            // Show the custom info view for this marker
            showCustomInfoView(for: marker)
        }
    }
}
