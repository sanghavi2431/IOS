//
//  EnrouteViewController.swift
//  Woloo
//
//  Created by Kapil Dongre on 18/11/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import STPopup


protocol EnrouteViewControllerProtocol: NSObjectProtocol{
    
    func didChangedBookmarkStatus()
}

class EnrouteViewController: UIViewController,GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var vwMap: MapContainerView!
    @IBOutlet weak var vwBackCurrentLocation: UIView!
    @IBOutlet weak var vwBackDestinationLocation: UIView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnHostLocation: UIButton!
    @IBOutlet weak var txtFieldCurrentLocation: UITextField!
    @IBOutlet weak var txtFieldDestinationLocation: UITextField!
    @IBOutlet weak var vwBottomBack: UIView!
    
    @IBOutlet weak var vwBottomStartNavigation: UIView!
    
    //@IBOutlet weak var btnStartNavigation: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var mapDirectionPopUpView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vwBackTransportMode: UIView!
    @IBOutlet weak var btnSelectedMode: UIButton!
    
    
    @IBOutlet weak var vwBackShadow: ShadowView!
    
    
    var vehicleSelected: String? = ""
    var netCoreEvents = NetcoreEvents()
    var strSource_Destination: String? = ""
    var sourceLat, sourceLong : Double?
    var destLat : Double? = 0.0
    var destLong : Double? = 0.0
    var sourceAddress, destAddress : String?
    var strCurrAddress: String = ""
    var hasStartedRouting : Bool = false
    var isFetchingPath : Bool = false
    var nearByStoreResponseDOV2 = [NearbyResultsModel]()
    var allStoresListv2 = [NearbyResultsModel]()
    var objNearbyResultsModel = NearbyResultsModel()
    var bottomPopViewPolyline: [String : Any] = [:]
    var googleToken: GMSAutocompleteSessionToken?
    
    var strIsComeFrom: String? = ""
    var strDestination: String? = ""
    var wolooID: Int?
    var transPortMode = TransportMode.car
    var dashboardScreenTag: Int?
    var objDashboardViewModel = DashboardViewModel()
    var delegate: EnrouteViewControllerProtocol?
    var isDistanceExceedsLimit: Bool = false
    var isSearch: Bool? = false
    var isHistory: Bool? = false
    var customInfoView = CustomInfoView()
    var selectedMarker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }


    func loadInitialSettings(){
       
        self.objDashboardViewModel.delegate = self
        self.vwBackTransportMode.layer.cornerRadius = 25
        self.vwBackTransportMode.isHidden = true
        if self.vehicleSelected == TransportType.WALK.rawValue{
            self.btnSelectedMode.setImage(UIImage(named: "fillWalk") , for: .normal)
            self.btnSelectedMode.setImage(UIImage(named: "fillWalk") , for: .selected)
        }
        else if self.vehicleSelected == TransportType.BIKE.rawValue{
            self.btnSelectedMode.setImage(UIImage(named: "icon_bike") , for: .normal)
            self.btnSelectedMode.setImage(UIImage(named: "icon_bike") , for: .selected)
        }
        else{
            self.btnSelectedMode.setImage(UIImage(named: "fillCar") , for: .normal)
            self.btnSelectedMode.setImage(UIImage(named: "fillCar") , for: .selected)
        }
        
        self.vwBackCurrentLocation.layer.cornerRadius = 10
        self.vwBackDestinationLocation.layer.cornerRadius = 10
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(DashboardCollectionViewCell.nib, forCellWithReuseIdentifier: DashboardCollectionViewCell.identifier)
        
        // Configure collection view layout for horizontal scrolling
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = .zero
        }
        self.collectionView.contentInsetAdjustmentBehavior = .never
        //tabBarController?.tabBar.isHidden = true
        //DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        if self.isSearch == true{
           
            self.reverseGeocodeCoordinate(latitude: self.sourceLat ?? 19.055229, longitude: self.sourceLong ??  72.830829)
               
            
       //     self.btnSelectedMode.isEnabled = false
                self.vwBottomStartNavigation.isHidden = true
                self.vwBottomBack.isHidden = true
                
                let vwBackWidth = UIScreen.main.bounds.width - 32
                let vwackHeight = 457.0
                
                if vwBackWidth < vwackHeight{
                    
                    self.vwBackShadow.layer.cornerRadius = vwBackWidth / 5.7
                }
                else{
                    self.vwBackShadow.layer.cornerRadius = vwackHeight / 5.7
                }
            
        }
        else{
            if let currentLocation = DELEGATE.locationManager.location {
                vwMap.currentPosition = CLLocationCoordinate2D(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829)
                self.reverseGeocodeCoordinate(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                
                
                self.sourceLat = currentLocation.coordinate.latitude
                self.sourceLong = currentLocation.coordinate.longitude
                
                self.vwBottomStartNavigation.isHidden = true
                self.vwBottomBack.isHidden = true
                
                let vwBackWidth = UIScreen.main.bounds.width - 32
                let vwackHeight = 457.0
                
                if vwBackWidth < vwackHeight{
                    
                    self.vwBackShadow.layer.cornerRadius = vwBackWidth / 5.7
                }
                else{
                    self.vwBackShadow.layer.cornerRadius = vwackHeight / 5.7
                }
            }
        }
        

        
        if self.strIsComeFrom == "Navigation" || self.isHistory == true{
            self.btnSelectedMode.isUserInteractionEnabled = false
            self.lblDistance.text = self.objNearbyResultsModel.distance ?? ""
            self.lblTime.text = self.objNearbyResultsModel.duration ?? ""
            self.collectionView.isHidden = true
            self.vwBottomStartNavigation.isHidden = false
            self.vwBottomBack.isHidden = false
            self.txtFieldDestinationLocation.text = self.strDestination
            self.btnHostLocation.isEnabled = false
            self.btnCurrentLocation.isEnabled = false
            self.txtFieldCurrentLocation.isEnabled = false
            self.txtFieldDestinationLocation.isEnabled = false
            
            self.objDashboardViewModel.creditUserCoins(blogId: 0, coins: Int(UserDefaultsManager.fetchAppConfigData()?.take_me_here ?? "0"), isGift: 0, strRemarks: "Take Me Here", strType: "Manual Credit", woloo_id: self.wolooID ?? 0, wolooCoins: 10)
            
            self.fetchRoute(from: CLLocationCoordinate2D(latitude: (self.sourceLat ?? 0.0)!, longitude: (self.sourceLong ?? 0.0)!) , to: CLLocationCoordinate2D(latitude: (self.destLat ?? 0.0)!, longitude: (self.destLong ?? 0.0)!))
        }
        
        vwMap.delegate = self
        vwMap.configureUI()
        vwMap.animate(toZoom: 14)
        vwMap.isMyLocationEnabled = true
        vwMap.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.vwBottomBack.layer.cornerRadius = 8.07
        self.vwBottomStartNavigation.layer.cornerRadius = 8.07
        
        
        let btnBookmarkWidth = UIScreen.main.bounds.width - 32
        let btnBookmarkHeight = 457.0
        
        if btnBookmarkWidth < btnBookmarkHeight{
            
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkWidth / 5.7
        }
        else{
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkHeight / 5.7
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - Button Action Methods
    
    @IBAction func clickedOpenTransportMode(_ sender: UIButton) {
        print("show transport mode")
        self.vwBackTransportMode.isHidden = false
        
    }
    
    @IBAction func clickedCloseModeBtn(_ sender: UIButton) {
        print("close mode")
        self.vwBackTransportMode.isHidden = true
    }
    
    @IBAction func clickedCarMode(_ sender: UIButton) {
        self.btnSelectedMode.setImage(UIImage(named: "fillCar") , for: .normal)
        self.btnSelectedMode.setImage(UIImage(named: "fillCar") , for: .selected)
        self.vwBackTransportMode.isHidden = true
        self.vehicleSelected = TransportType.CAR.rawValue
        if sourceLat == 0.0{
            self.showToast(message: "Please select Location.")
        }
        else if self.destLat == 0.0{
            self.showToast(message: "Please select Location.")
        }
        else{
            self.fetchRoute(from: CLLocationCoordinate2D(latitude: (self.sourceLat ?? 0.0)!, longitude: (self.sourceLong ?? 0.0)!) , to: CLLocationCoordinate2D(latitude: (self.destLat ?? 0.0)!, longitude: (self.destLong ?? 0.0)!))
        }
        //self.collectionViewNearbyCell.reloadData()
        print("select car mode")
    }
    
    @IBAction func clickedWalkMode(_ sender: UIButton) {
        print("select walk mode")
        self.btnSelectedMode.setImage(UIImage(named: "fillWalk") , for: .normal)
        self.btnSelectedMode.setImage(UIImage(named: "fillWalk") , for: .selected)
        self.vwBackTransportMode.isHidden = true
        self.vehicleSelected = TransportType.WALK.rawValue
        
        if sourceLat == 0.0{
            self.showToast(message: "Please select Location.")
        }
        else if self.destLat == 0.0{
            self.showToast(message: "Please select Location.")
        }
        else{
            self.fetchRoute(from: CLLocationCoordinate2D(latitude: (self.sourceLat ?? 0.0)!, longitude: (self.sourceLong ?? 0.0)!) , to: CLLocationCoordinate2D(latitude: (self.destLat ?? 0.0)!, longitude: (self.destLong ?? 0.0)!))
        }
    }
    
    
    @IBAction func clickedBikeMode(_ sender: UIButton) {
        self.btnSelectedMode.setImage(UIImage(named: "icon_bike") , for: .normal)
        self.btnSelectedMode.setImage(UIImage(named: "icon_bike") , for: .selected)
        self.vwBackTransportMode.isHidden = true
        self.vehicleSelected = TransportType.BIKE.rawValue
        
        if sourceLat == 0.0{
            self.showToast(message: "Please select Location.")
        }
        else if self.destLat == 0.0{
            self.showToast(message: "Please select Location.")
        }
        else{
            self.fetchRoute(from: CLLocationCoordinate2D(latitude: (self.sourceLat ?? 0.0)!, longitude: (self.sourceLong ?? 0.0)!) , to: CLLocationCoordinate2D(latitude: (self.destLat ?? 0.0)!, longitude: (self.destLong ?? 0.0)!))
        }
    }
    
    
    @IBAction func clickedBtnSourceLocation(_ sender: UIButton) {
        
        print("search source locations")
        let objController = SearchLocationsViewController.init(nibName: "SearchLocationsViewController", bundle: nil)
        self.strSource_Destination = SELCTED_ENROUTE_TYPE.SOURCE.rawValue
        objController.delegate = self
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    @IBAction func clickedDestinationLocations(_ sender: UIButton) {
        print("search destination locations")
        let objController = SearchLocationsViewController.init(nibName: "SearchLocationsViewController", bundle: nil)
        self.strSource_Destination = SELCTED_ENROUTE_TYPE.DESTINATION.rawValue
        objController.delegate = self
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    @IBAction func popUpContinueBtnPressed(_ sender: Any) {
        guard destLat != 0.0, destLong != 0.0 else {
            self.showToast(message: "Please select Destination.")
            return
        }

        let googleMapsScheme = URL(string: "comgooglemaps://")!
        let urlString = "comgooglemaps://?saddr=\(sourceLat ?? 0),\(sourceLong ?? 0)&daddr=\(destLat ?? 0),\(destLong ?? 0)&directionsmode=driving"

        if UIApplication.shared.canOpenURL(googleMapsScheme),
           let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let directionsURL = URL(string: encoded) {
            UIApplication.shared.open(directionsURL)
        } else {
            // fallback → Safari
            let browserURL = "https://www.google.com/maps/dir/?api=1&origin=\(sourceLat ?? 0),\(sourceLong ?? 0)&destination=\(destLat ?? 0),\(destLong ?? 0)&travelmode=driving"
            if let url = URL(string: browserURL) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        
        self.mapDirectionPopUpView.isHidden = true
    }
    
    
    @IBAction func clickedBackBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickedBtnStartNavigation(_ sender: UIButton) {
        
       
    }
    
    
    func reverseGeocodeCoordinate(latitude: Double, longitude: Double) {
            let geocoder = GMSGeocoder()
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
        geocoder.reverseGeocodeCoordinate(coordinate) { [self] (response, error) in
                if let error = error {
                    print("Error in reverse geocoding: \(error.localizedDescription)")
                    return
                }
                
                if let address = response?.firstResult(), let lines = address.lines {
                    // You can access various parts of the address here
                    let formattedAddress = lines.joined(separator: ", ")
                    print("Address: \(formattedAddress)")
                    strCurrAddress = formattedAddress
                    self.txtFieldCurrentLocation.text = strCurrAddress
                } else {
                    print("No address found")
                }
            }
        }
    
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        print("(\(source.latitude),\(source.longitude))->(\(destination.latitude),\(destination.longitude))")
        let session = URLSession.shared
        
        var mode: String? = ""
        if vehicleSelected == TransportType.CAR.rawValue {
            mode = "driving"
        }
        else if vehicleSelected == TransportType.BIKE.rawValue {
            mode = "driving"
        }
        else if vehicleSelected == TransportType.WALK.rawValue {
            mode = "walking"
        }
        
        let url = URL(string:
            "https://maps.googleapis.com/maps/api/directions/json" +
            "?origin=\(source.latitude),\(source.longitude)" +
            "&destination=\(destination.latitude),\(destination.longitude)" +
            "&mode=\(mode ?? "driving")" +
            "&departure_time=now" +
            "&traffic_model=best_guess" +
            "&key=\(Constant.ApiKey.googleMap)"
        )!
       
        
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
                                                
                                                    print("stepIn 8")
                                                    self.hasStartedRouting = false
                                                self.wolooNavigationRewardAPI(wolooId: self.wolooID ?? 0)
//
                                            }
                                            else {
                                                print("stepOut 7")
                                            }
                                        } else {
                                            print("stepOut 6")
                                        }
                                        DispatchQueue.main.async {
                                            //self.lblDirection1.text = dist1Val
                                           // self.stackDirection1.isHidden = false
                                            if let maneuver1 = step1["maneuver"] as? String {
                                                if let m1image = UIImage(named:maneuver1) {
                                                   
                                                } else {
                                                    
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
                                            //self.lblDirection2.text = dist2Val
                                            //self.vwDirection2.isHidden = false
                                            if let maneuver1 = step2["maneuver"] as? String {
                                                if let m1image = UIImage(named:maneuver1) {
                                                 //   self.imgDirection2.image = m1image
                                                } else {
                                                  //  self.imgDirection2.image = UIImage(named: "straight")
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
                                // self.lblKm.text = distance["text"] as? String ?? ""
                                
                                //self.distanceLbl.text = distance["text"] as? String ?? ""
                                
                                
                                // Check if distance is more than 30 km (30000 meters)
                               
                                
                                if self.strIsComeFrom == "Navigation"{
                                    if self.isHistory == true{
                                        self.lblDistance.text = distance["text"] as? String ?? ""
                                    }
                                }
                                else{
                                    self.lblDistance.text = distance["text"] as? String ?? ""
                                    if let distanceValue = distance["value"] as? Int, distanceValue > 30000 {
                                        // Set flag to true to prevent polyline and API calls
                                        self.isDistanceExceedsLimit = true
                                        
                                        // Show popup for distance more than 30 km
                                        let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "OK", title: "Distance Alert", message: "Entered distance is more than 30 km. Please reduce your destination/source location to under 30 km", image: nil, controller: self)
                                        alert.cancelTappedAction = {
                                            alert.removeFromSuperview()
                                        }
                                        self.view.addSubview(alert)
                                        self.view.bringSubviewToFront(alert)
                                        
                                        print("block is getting called")
                                        self.nearByStoreResponseDOV2 = [NearbyResultsModel]()
                                        self.allStoresListv2 = [NearbyResultsModel]()
                                        self.vwMap.nearByStoreResponseDOV2 = [NearbyResultsModel]()
                                        self.drawPath(from: "")
                                        self.vwMap.addEnrouteMarkers()
                                        self.vwMap.clear()
                                        self.lblTime.text = "[Time]"
                                        self.lblDistance.text = "[Distance]"
                                        self.vwBottomStartNavigation.isHidden = true
                                        self.vwBottomBack.isHidden = true
                                        // Invalidate layout before reloading to prevent overlapping
                                        self.collectionView.collectionViewLayout.invalidateLayout()
                                        self.collectionView.reloadData()
                                        
                                    } else {
                                        // Reset flag if distance is within limit
                                        self.isDistanceExceedsLimit = false
                                    }

                                }
                                
                            }
                            
                            if self.isDistanceExceedsLimit == false {

                                // Prefer traffic time
                                if self.strIsComeFrom == "Navigation"{
                                    
                                    
                                    if self.isHistory == true{
                                        if let traffic = leg["duration_in_traffic"] as? [String: Any] {
                                            self.lblTime.text = traffic["text"] as? String ?? ""
                                        }
                                        // Fallback if Google didn’t return traffic
                                        else if let normal = leg["duration"] as? [String: Any] {
                                            self.lblTime.text = normal["text"] as? String ?? ""
                                        }
                                    }
                                    
                                   
                                }else
                                {
                                    if let traffic = leg["duration_in_traffic"] as? [String: Any] {
                                        self.lblTime.text = traffic["text"] as? String ?? ""
                                    }
                                    // Fallback if Google didn’t return traffic
                                    else if let normal = leg["duration"] as? [String: Any] {
                                        self.lblTime.text = normal["text"] as? String ?? ""
                                    }
                                }

                            }
                            
                        }
                    } else {
                        print("stepOut 1")
                    }
                    
                }
                
                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                    
                    return
                }
                print("OverviewPolyline: \(overview_polyline)")
                guard let polyLineString = overview_polyline["points"] as? String else {
                    return
                }
                
                DispatchQueue.main.async {
                    // Only proceed if distance is within limit
                    guard !self.isDistanceExceedsLimit else {
                        self.isFetchingPath = false
                        return
                    }
                    
                    self.vwMap.clear()
                   self.vwMap.addDestinationMarker(lat: destination.latitude, long: destination.longitude, name: "Destination", index: 0)
                    self.destLat = destination.latitude
                    self.destLong = destination.longitude
                    
                    self.vwMap.addCurrentPositionMarker(currentPosition: source)
                    
                    let sourcePoint = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
                    let destinationPoint = CLLocationCoordinate2D(latitude: source.latitude,longitude: source.longitude)
                let bounds = GMSCoordinateBounds(coordinate: sourcePoint, coordinate: destinationPoint)
                    
                    
                let mapInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
                self.vwMap.padding = mapInsets
                self.vwMap.animate(toZoom: 10)
                let camera = self.vwMap.camera(for: bounds, insets: UIEdgeInsets())!
                self.vwMap.camera = camera
                
                    if self.isDistanceExceedsLimit == false{
                        self.drawPath(from: polyLineString)
                    }
                
                self.isFetchingPath = false
                    
                    if self.strIsComeFrom == "Navigation"{
                        
                    }
                    else{
                        if self.isDistanceExceedsLimit == false{
                            self.getEnrouteWoloo(src_lat: source.latitude, src_lng: source.longitude, target_lat: destination.latitude, target_lng: destination.longitude, overview_polyline: overview_polyline)
                        }
                        
                    }
                       
                        self.bottomPopViewPolyline = overview_polyline
                        
                }
            }
        })
        task.resume()
        
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2.0
        polyline.map = self.vwMap
    }
    
    func getEnrouteWoloo(src_lat: Double, src_lng: Double, target_lat: Double, target_lng: Double,overview_polyline: [String : Any]){
        
        Global.showIndicator()
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        DELEGATE.locationManager.startUpdatingLocation()
        
        var mode: Int = 0
        if vehicleSelected == TransportType.CAR.rawValue {
            mode = 0
        }
        else if vehicleSelected == TransportType.BIKE.rawValue {
            mode = 3
        }
        else if vehicleSelected == TransportType.WALK.rawValue {
            mode = 1
        }
        
        let data = ["src_lat": src_lat, "src_lng": src_lng, "target_lat": target_lat, "target_lng": target_lng, "overview_polyline": overview_polyline,"mode": mode] as [String : Any]
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .enroute, method: .post, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<[NearbyResultsModel]>, Error>) in
            switch result{
                
            case .success(let response):
                Global.hideIndicator()
                print("Enroute API response: ", response.results)
                
                
                //self.mapContainerView.addEnrouteMarkers
                self.vwMap.nearByStoreResponseDOV2 = response.results
                //                self.mapContainerView.addAllMarkersV2()
                
                if response.results.count <= 0 {
                    self.showToast(message: "No Woloos Found")
                    self.objDashboardViewModel.creditUserCoins(blogId: 0, coins: Int(UserDefaultsManager.fetchAppConfigData()?.no_woloo_found ?? "0"), isGift: 0, strRemarks: "No Woloo Found", strType: "Manual Credit", woloo_id: 0, wolooCoins: 0)
                    var param = [String:Any]()
                    param["location"] = "(\(src_lat),\(src_lng))"
                    Global.addNetcoreEvent(eventname: self.netCoreEvents.noWolooFound, param: param)
                    self.nearByStoreResponseDOV2 = response.results
                    self.allStoresListv2 = response.results
                }
                else{
                    self.nearByStoreResponseDOV2 = response.results
                    self.allStoresListv2 = response.results
                    
                    
                    self.vwMap.addEnrouteMarkers()
                }
                DispatchQueue.main.async {
                    // Invalidate layout before reloading to prevent overlapping
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.reloadData()
                    
                    if !self.allStoresListv2.isEmpty { // Check if there are items
                        // Ensure layout is calculated before scrolling
                        self.collectionView.layoutIfNeeded()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Small delay for layout update
                            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                        }
                    }
                }
               
            case .failure(let error):
                Global.hideIndicator()
                print("Enroute API failed: ", error)
            }
        }
    }
    
    
    func wolooNavigationRewardAPI(wolooId: Int) {
        var msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationPoints ?? "")"
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
          
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        var data = ["wolooId": wolooId ?? 0]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .wolooNavigationRewards, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<StatusSuccessResponseModel>, Error>) in
            switch result {
                
            case .success(let response):
                Global.hideIndicator()
                print("User has reached destination App delegate")
                
                
                DispatchQueue.main.async{
                    let objController = BlogsPointsPopUpVC(nibName: "BlogsPointsPopUpVC", bundle: nil)
                   // objController.delegate = self
                    objController.pointCount = String(10)
                    let popup = STPopupController(rootViewController: objController)
                    popup.style = .bottomSheet
                    popup.present(in: DELEGATE.window?.rootViewController ?? self)
                }
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("User arrived at destination appdelegate reward point already claimed")
                NotificationCenter.default.post(name: Notification.Name.destinationReached, object: nil, userInfo: ["destinationPointClaimed": "destinationPointClaimed"])
                print("woloo navigation error: \(error)")
                
            }
        }
    }
    
    @IBAction func clickedStartNavigationBtn(_ sender: UIButton) {
        
        self.mapDirectionPopUpView.isHidden = false
        
       
    }
    
}
