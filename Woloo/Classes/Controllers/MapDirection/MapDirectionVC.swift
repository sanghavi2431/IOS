//
//  MapDirectionVC.swift
//  Woloo
//
//  Created on 07/05/21.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapDirectionVC: UIViewController {
    
    @IBOutlet weak var mapContainerView: MapContainerView!
    var wolooStore  = WolooStore ()
    
    var wolooStoreV2 = [NearbyResultsModel]()
    var wolooStoreDOV2 : NearbyResultsModel?
    
    let locManager = DELEGATE.locationManager
    var isFetchingPath : Bool = false
    var hasStartedRouting : Bool = false
    var transportMode = TransportMode.car
    var netCoreEvents = NetcoreEvents()
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDirection2: UILabel!
    @IBOutlet weak var imgDirection2: UIImageView!
    @IBOutlet weak var lblDirection1: UILabel!
    @IBOutlet weak var imgDirection1: UIImageView!
    @IBOutlet weak var vwDirection2: UIView!
    @IBOutlet weak var stackDirection1: UIStackView!
    @IBOutlet weak var vwbottom: UIView!
    @IBOutlet weak var lblMins: UILabel!
    @IBOutlet weak var lblKm: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var bottomStackHeightConstrains: NSLayoutConstraint!
    @IBOutlet weak var vwScanQr: UIView!
    @IBOutlet weak var stackBottomButtons: UIView!
    
    var destLat = ""
    var destLong = ""
    var cityName = ""
    var storeId2: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        if let currentLocation = DELEGATE.locationManager.location {
            mapContainerView.currentPosition = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        } /*else {
         mapContainerView.currentPosition = CLLocationCoordinate2D(latitude: 18.925164, longitude: 72.832225)
         } */
        lblTitle.text = wolooStore.city
        
        locManager.delegate = self
        locManager.startUpdatingLocation()
        vwDirection2.clipsToBounds = true
        vwDirection2.layer.cornerRadius = 10
        vwDirection2.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        vwDirection2.isHidden = true
        stackDirection1.isHidden = true
        vwbottom.clipsToBounds = true
        vwbottom.layer.cornerRadius = 40
        vwbottom.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btnStart.isHidden = false
        stackBottomButtons.isHidden =  false
        mapContainerView.delegate = self
        mapContainerView.configureUI()
        mapContainerView.animate(toZoom: 15)
        mapContainerView.isMyLocationEnabled = true
        mapContainerView.settings.myLocationButton = true
        mapContainerView.settings.compassButton = true
        mapContainerView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        //        wolooLikeStatus()
        if hasStartedRouting {
            btnStart.isHidden = true
            stackBottomButtons.isHidden = true
        }
        
        self.handleLocationPermission()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        
        if let currentLocation = DELEGATE.locationManager.location {
            mapContainerView.currentPosition = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        }
        mapContainerView.configureUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DELEGATE.rootVC?.tabBarVc?.showTabBar()
    }
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
       
        if let currentLocation = DELEGATE.locationManager.location {
            mapContainerView.currentPosition = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        }
        
        mapContainerView.configureUI()
        
        let storeloc = CLLocationCoordinate2D(latitude: destLat.toDouble() ?? 0.0, longitude: destLong.toDouble() ?? 0.0)
                //mapContainerView.addCurrentPositionMarker(currentPosition: mapContainerView.currentPosition ?? CLLocationCoordinate2D(latitude: 18.925164, longitude: 72.832225))
       // mapContainerView.addCustomMarker(lat: wolooStore.lat?.toDouble() ?? 0.0, long: wolooStore.lng?.toDouble() ?? 0.0, name: "Destination", index: 0)
        mapContainerView.addCustomMarker(lat: destLat.toDouble() ?? 0.0, long: destLong.toDouble() ?? 0.0, name: "Destination", index: 0)
        if let cpos = mapContainerView.currentPosition {
            fetchRoute(from: cpos, to: storeloc)
        } else if let cpos = DELEGATE.locationManager.location {
            fetchRoute(from: cpos.coordinate, to: storeloc)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func scanQRCodeAction(_ sender: Any) {
        //not used now
        vwScanQr.isHidden = true
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "QRCodeScanViewController") as? QRCodeScanViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func closeAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func startAction(_ sender: Any) {
        //self.wolooNavigationRewardAPI(wolooId: Int(wolooStore.storeId ?? 0))
        hasStartedRouting = true
        Global.addFirebaseEvent(eventName: "start_woloo_click", param: [
            "woloo_id": wolooStore.storeId ?? ""
        ])
        
        Global.addNetcoreEvent(eventname: self.netCoreEvents.startWolooClick, param: ["woloo_id" : self.storeId2])
        
        btnStart.isHidden = true
        stackBottomButtons.isHidden = true
        self.view.layoutIfNeeded()
    }
    @IBAction func likeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let wid = self.storeId2 {
            if sender.isSelected {
                Global.addFirebaseEvent(eventName: "like_woloo_click", param: [
                    "woloo_id": wolooStore.storeId ?? ""
                ])
                
                Global.addNetcoreEvent(eventname: self.netCoreEvents.likeWolooClick, param: [ "woloo_id": wolooStore.storeId ?? ""])
                
                self.likeWolooAPI(wolooId: wid)
            } else {
                self.unlikeWolooAPI(wolooId: wid)
            }
        }
    }
    @IBAction func shareAction(_ sender: Any) {
        Global.addFirebaseEvent(eventName: "share_woloo_click", param: [
            "woloo_id": wolooStore.storeId ?? ""
        ])
        
        Global.addNetcoreEvent(eventname: self.netCoreEvents.shareWolooClick, param: [
                                "woloo_id": wolooStore.storeId ?? ""
                            ])
        
        let text = "\(wolooStore.name ?? "")\n\(cityName ?? "")"
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        //            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func refreshMapAction(_ sender: Any) {
        guard let currentPosition = mapContainerView.currentPosition else { return }
        let camera = GMSCameraPosition(latitude:currentPosition.latitude, longitude: currentPosition.longitude, zoom: 15)
        mapContainerView.camera = camera
    }
    @IBAction func dismissBottomAction(_ sender: Any) {
        
    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        print("(\(source.latitude),\(source.longitude))->(\(destination.latitude),\(destination.longitude))")
        let session = URLSession.shared
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=\(transportMode.googleAPIValue)&key=\(Constant.ApiKey.googleMap)")!
        print("\(url)")
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            if let routes = jsonResult["routes"] as? [Any] , routes.count > 0  {
                guard let route = routes[0] as? [String: Any]
                else {
                    return
                }
                if let legs = route["legs"] as? [Any] , legs.count > 0  {
                    DispatchQueue.main.async {
                        self.stackDirection1.isHidden = true
                        self.vwDirection2.isHidden = true
                    }
                    if let leg = legs[0] as? [String: Any] {
                        print("stepIn 1")
                        if let steps = leg ["steps"] as? [Any], steps.count > 0 {
                            print("stepIn 2")
                            if let step1 = steps[0] as? [String:Any] {
                                print("stepIn 3")
                                if let dist1 = step1["distance"] as? [String:Any] {
                                    print("stepIn 4")
                                    if let dist1Val = dist1["text"] as? String {
                                        print("stepIn 5")
                                        if steps.count == 1 {
                                            print("stepIn 6")
                                            if let dist = dist1["value"] as? Int, dist <= 50 {
                                                print("stepIn 7")
                                                //if let wid = self.storeId2! {
                                                    print("stepIn 8")
                                                    self.hasStartedRouting = false
                                                self.wolooNavigationRewardAPI(wolooId: self.storeId2 ?? 0)
//                                                    self.vwScanQr.isHidden = false
                                                //}
                                            }
                                            else {
                                                print("stepOut 7")
                                            }
                                        } else {
                                            print("stepOut 6")
                                        }
                                        DispatchQueue.main.async {
                                            self.lblDirection1.text = dist1Val
                                            self.stackDirection1.isHidden = false
                                            if let maneuver1 = step1["maneuver"] as? String {
                                                if let m1image = UIImage(named:maneuver1) {
                                                    self.imgDirection1.image = m1image
                                                } else {
                                                    self.imgDirection1.image = UIImage(named: "straight")
                                                }
                                            }
                                        }
                                    } else {
                                        print("stepOut 5")
                                    }
                                }  else {
                                    print("stepOut 4")
                                }
                            }  else {
                                print("stepOut 3")
                            }
                            if steps.count > 1, let step2 = steps[1] as? [String:Any] {
                                if let dist2 = step2["distance"] as? [String:Any] {
                                    if let dist2Val = dist2["text"] as? String {
                                        DispatchQueue.main.async {
                                            self.lblDirection2.text = dist2Val
                                            self.vwDirection2.isHidden = false
                                            if let maneuver1 = step2["maneuver"] as? String {
                                                if let m1image = UIImage(named:maneuver1) {
                                                    self.imgDirection2.image = m1image
                                                } else {
                                                    self.imgDirection2.image = UIImage(named: "straight")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            print("stepOut 2")
                        }
                        
                        DispatchQueue.main.async {
                            if let distance = leg["distance"] as? [String: Any] {
                                self.lblKm.text = distance["text"] as? String ?? ""
                            }
                            if let distance = leg["duration"] as? [String: Any] {
                                self.lblMins.text = distance["text"] as? String ?? ""
                            }
                        }
                    } else {
                        print("stepOut 1")
                    }
                    
                }
                
                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                    return
                }
                
                guard let polyLineString = overview_polyline["points"] as? String else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.mapContainerView.clear()
                    self.mapContainerView.addCustomMarker(lat: self.destLat.toDouble() ?? 0.0, long: self.destLong.toDouble() ?? 0.0, name: "Destination", index: 0)
                    self.drawPath(from: polyLineString)
                    self.isFetchingPath = false
                }
            }
        })
        task.resume()
        
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.map = self.mapContainerView
    }
    
    func handleLocationPermission(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted:
            DELEGATE.locationManager.requestAlwaysAuthorization()
            DELEGATE.locationManager.requestWhenInUseAuthorization()
            DELEGATE.locationManager.delegate = self
            DELEGATE.didChangeLocationAuthorizationStatus = { (status) in
                if status == .authorizedAlways || status == .authorizedWhenInUse {

                    print("authorized always")
                }
            }
        case .authorizedAlways, .authorizedWhenInUse:
            //getNearByStores()
            print("authorized always")
           
        case .denied:
            
            print("User has denied the map permissions settings")
            //if let currentLocation = DELEGATE.locationManager.location {
            DispatchQueue.main.async {
                let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Retry", title: nil, message: "There was an issue in fetching your location. Please enable location from Settings", image: nil, controller: self)
                alert.cancelTappedAction = {
                    self.navigationController?.popViewController(animated: true)
                    print("open Settings")
                    
                    alert.removeFromSuperview()
                }
                self.view.addSubview(alert)
                self.view.bringSubviewToFront(alert)
            }
        @unknown default:
            print("LocationService: unknown default state")
            break
        }
    }
    
}

// MARK: - GMSMapViewDelegate

extension MapDirectionVC: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        print("marker location - \(marker.title ?? ""): <\(marker.position.latitude), \(marker.position.longitude)>")
        //        delegate?.didTapMarker(marker)
        return true
    }
    
}
extension MapDirectionVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if hasStartedRouting {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            //        print ("\(locValue.latitude),\(locValue.longitude)")
            if !isFetchingPath {
                //lat: destLat.toDouble() ?? 0.0, long: destLong.toDouble() ?? 0.0
                let storeloc = CLLocationCoordinate2D(latitude: self.destLat.toDouble() ?? 0.0, longitude: self.destLong.toDouble() ?? 0.0)
                isFetchingPath = true
                fetchRoute(from: locValue, to: storeloc)
            }
        }
    }
}
// MARK: - API
extension MapDirectionVC {
    func wolooNavigationRewardAPI(wolooId: Int) {
        APIManager.shared.wolooNavigationReward(param: ["wolooId":wolooId]) { (isSuccess, result, message) in
//            self.showToast(message: message)
            if isSuccess {
                var msg = ""

                if result?.code == 200 {
                    msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationPoints ?? "")"
                    Global.addFirebaseEvent(eventName: "woloo_destination_reached", param: [
                                                "woloo_id": wolooId])
                    DispatchQueue.main.async {
                        let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "ADD REVIEW", title: "", message: msg, image: nil, controller: self)
                        alert.cancelTappedAction = {
                            alert.removeFromSuperview()
                            let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
                            vc?.wolooStore = self.wolooStore

                            vc?.wolooStoreID2 = self.storeId2

                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                        self.view.addSubview(alert)
                        self.view.bringSubviewToFront(alert)
                    }
                } else {
                    msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")"
                    DispatchQueue.main.async {
                        let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "HOME", title: "", message: msg, image: nil, controller: self)
                        alert.cancelTappedAction = {
                            alert.removeFromSuperview()
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        self.view.addSubview(alert)
                        self.view.bringSubviewToFront(alert)
                    }
                }
            }
        }
    }
    

    
    func likeWolooAPI(wolooId: Int) {
        APIManager.shared.wolooLike(param: ["wolooId": wolooId], completion: { (isSuccess, message) in
            if isSuccess {
                DispatchQueue.main.async {
                    self.btnLike.isSelected = true
                }
            } else {
                self.showToast(message: message)
            }
        })
    }
    func unlikeWolooAPI(wolooId: Int) {
        APIManager.shared.wolooUnlike(param: ["wolooId": wolooId], completion: { (isSuccess, message) in
            if isSuccess {
                DispatchQueue.main.async {
                    self.btnLike.isSelected = false
                }
            } else {
                self.showToast(message: message)
            }
        })
    }
    func wolooLikeStatus() {
        if let wolooId = self.storeId2 {
            APIManager.shared.wolooLikeStatus(param: ["wolooId": wolooId]) { (result, message) in
                if let response = result {
                    if response.isLiked == 1 {
                        DispatchQueue.main.async {
                            self.btnLike.isSelected = true
                        }
                    }
                }
            }
        }
    }
}


