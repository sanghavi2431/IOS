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

extension EnrouteViewController: SearchLocationEnrouteDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DashboardCollectionViewCellDelegate, DetailsVCProtocol{
    
    //MARK: - DetailsVCProtocol
    func didChangedBookmarkStatus() {
        //
    }
    
    
    //MARK: - DashboardCollectionViewCellDelegate
    func didClickedNavigate(obj: NearbyResultsModel) {
        
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.destLat = Double(obj.lat ?? "")
        objController.destLong = Double(obj.lng ?? "")
        objController.strIsComeFrom = "Navigation"
        objController.strDestination = "\(obj.name ?? "")"
        objController.wolooID = obj.id
        self.navigationController?.pushViewController(objController, animated: true)
        
    }
    

    
    
    //MARK: - SearchLocationEnrouteDelegate
    func didSearchedPlace(lat: Double, long: Double, strPlace: String?,selectedCity: String) {
        print("searched place: \(strPlace ?? "")")
        
        if self.strSource_Destination == SELCTED_ENROUTE_TYPE.SOURCE.rawValue {
            self.sourceLat = lat
            self.sourceLong = long
            self.sourceAddress = strPlace
            self.txtFieldCurrentLocation.text = strPlace
        }
        else{
            self.destLat = lat
            self.destLong = long
            self.destAddress = strPlace
            self.txtFieldDestinationLocation.text = strPlace
        }
        

        self.fetchRoute(from: CLLocationCoordinate2D(latitude: (self.sourceLat ?? 0.0)!, longitude: (self.sourceLong ?? 0.0)!) , to: CLLocationCoordinate2D(latitude: (self.destLat ?? 0.0)!, longitude: (self.destLong ?? 0.0)!))
        
    }
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker location - \(marker.title ?? ""): <\(marker.position.latitude), \(marker.position.longitude)>")
        //delegate?.didTapMarker(marker)
        //marker.title =
        didTapMarker(marker)
        return true
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
        
        vc.wolooStoreDOV2 = allStoresListv2[indexPath.item]
        vc.tranportMode = transPortMode
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
