//
//  EnrouteVC.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 08/06/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class EnrouteVC: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapContainerView: MapContainerView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var destinationTxtLbl: UITextField!
    @IBOutlet weak var searchPlacesTblView: UITableView!
    @IBOutlet weak var searchSourcePlacesTblView: UITableView!
    
    @IBOutlet weak var sourceTxtLbl: UITextField!
    @IBOutlet weak var sourceClearBtn: UIButton!
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var timeLblBottom: UILabel!
    @IBOutlet weak var distanceLblBottom: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var mapDirectionPopUpView: UIView!
    
    @IBOutlet weak var enrouteListTblView: UITableView!
    
    @IBOutlet weak var enrouteListTblHeight: NSLayoutConstraint!
    @IBOutlet weak var onRouteLbl: UILabel!
    @IBOutlet weak var dashButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    var allStoresListv2 = [NearbyResultsModel]()
    var allNearByWolooList = [NearbyResultsModel]()
    var searchList: [Any]?
    var placeResult = [GMSAutocompletePrediction]()
    var googleToken: GMSAutocompleteSessionToken?
    var selectedPlace : GMSPlace?
    var transportMode = TransportMode.car
    var hasStartedRouting : Bool = false
    
    var isDirection: Bool?
    var netCoreEvents = NetcoreEvents()
    let locManager = DELEGATE.locationManager
    var isFetchingPath : Bool = false
    var destinationTxt: String?
    weak var delegate:AnimationProtocol?
    var sourceLat, sourceLong: Double?
    var destLat, destLong: Double?
    var sourceTag = 0
    var destinationTag = 0
    var enrouteTag: Bool?
    var collapseflag = true
    var timeFor60Sec: Timer?
    var remainingTimeForExpand = 60
    fileprivate var isMapExpand:Bool = true
    var transPortMode = TransportMode.car
    var pageCount = 1
    var bottomPopViewPolyline: [String : Any] = [:]
    fileprivate var isPresenting = false
    fileprivate let presentingHeight = UIScreen.main.bounds.height * 0.65
    fileprivate var nearByStoreResponseDOV2: [NearbyResultsModel]? = nil
    
    fileprivate var enrouteWolooStorePopUpVC2: EnrouteWolooStorePopUpVC? {
        
        if let childVC = self.children.first as? EnrouteWolooStorePopUpVC{
            
            childVC.nearByStoreResponseDoV2 = nearByStoreResponseDOV2
            childVC.delegate = self
            childVC.transportMode = transportMode
            return childVC
        }
        return nil
    }
    
    var storeID: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
        registerCells()
        
        self.startBtn.isEnabled = false
        
        if destinationTxt != nil{
            destinationTxtLbl.text = "\(destinationTxt ?? "")"
        }
        
        if isDirection == false{
            self.bottomView.isHidden = true
            
        }else{
            self.timeLbl.isHidden = true
            self.distanceLbl.isHidden = true
            self.bottomView.isHidden = false
            self.enrouteListTblView.isHidden = true
            self.onRouteLbl.isHidden = true
            self.dashButton.isHidden = true
        }
    
        if (destLat != nil) && destLong != nil{
            print("destLat, destLong: ",destLat, destLong)
            let storeloc = CLLocationCoordinate2D(latitude: destLat ?? 0.0, longitude: destLong ?? 0.0)
            if let cpos = self.mapContainerView.currentPosition {
                self.fetchRoute(from: cpos, to: storeloc)
                self.startBtn.isEnabled = true
                
                UserDefaultsManager.storeCurrentLat(value: cpos.latitude)
                UserDefaultsManager.storeCurrentLong(value: cpos.longitude)
                UserDefaultsManager.storeDestinationLat(value: destLat ?? 0.0)
                UserDefaultsManager.storeDestinationLong(value: destLong ?? 0.0)
                UserDefaultsManager.storeWolooID(value: storeID ?? 0)
                print("Store ID: \(storeID)")
                sourceTxtLbl.isEnabled = false
                print("Navigating from directions")
                
            } else if let cpos = DELEGATE.locationManager.location {
                print("destLat, destLong: ",destLat, destLong)
                self.fetchRoute(from: cpos.coordinate, to: storeloc)
                UserDefaultsManager.storeCurrentLat(value: cpos.coordinate.latitude)
                UserDefaultsManager.storeCurrentLong(value: cpos.coordinate.longitude)
                UserDefaultsManager.storeDestinationLat(value: destLat ?? 0.0)
                UserDefaultsManager.storeDestinationLong(value: destLong ?? 0.0)
                UserDefaultsManager.storeWolooID(value: storeID ?? 0)
                print("Store ID: \(storeID)")
                print("Navigating from enroute button")
            }
        }else{
           print("Values are empty")
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        containerView.roundCorners(corners: [.topLeft,.topRight], radius: 16.0)
        //popUp.collectionView.scrollToItem(at: IndexPath(item: Int(marker.zIndex), section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    fileprivate func registerCells(){
        
        enrouteListTblView.register(DashboardDirectionCell.nib, forCellReuseIdentifier: DashboardDirectionCell.identifier)
        
        enrouteListTblView.register(NoWolooDashboardCell.nib, forCellReuseIdentifier: NoWolooDashboardCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getAllNotificationCall(_:)), name: Notification.Name.destinationReached, object: nil)
    }
    
    @objc func getAllNotificationCall(_ notification: NSNotification) {
        var msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationPoints ?? "")"
        
        self.mapDirectionPopUpView.isHidden = true
        if notification.name.rawValue == Notification.Name.destinationReached.rawValue, let dict = notification.userInfo as? [String: Any] {
            
            if let destinationReachedPoint = dict["destinationReached"] as? String {
                
                print("User reached destination enroutevc")
               
                
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "ADD REVIEW", title: "", message: msg, image: nil, controller: self)
                    alert.cancelTappedAction = {
                        alert.removeFromSuperview()
                        let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
//                        vc?.wolooStore = self.wolooStore
                        vc?.wolooStoreID2 = self.storeID
//
//                        vc?.wolooStoreID2 = self.storeId2

                        self.navigationController?.pushViewController(vc!, animated: true)
                        UserDefaults.standard.removeObject(forKey: "Store_Current_Lat")
                        UserDefaults.standard.removeObject(forKey: "Store_Current_Long")
                        UserDefaults.standard.removeObject(forKey: "Store_Destination_Lat")
                        UserDefaults.standard.removeObject(forKey: "Store_Destination_Long")
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                }
            }else if let destinationPointClaimed = dict["destinationPointClaimed"] as? String {
                
                print("points already claimed")
                msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")"
                                    DispatchQueue.main.async {
                                        let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "OK", title: "", message: msg, image: nil, controller: self)
                                        alert.cancelTappedAction = {
                                            alert.removeFromSuperview()
                                            //self.navigationController?.popToRootViewController(animated: true)
                                            UserDefaults.standard.removeObject(forKey: "Store_Current_Lat")
                                            UserDefaults.standard.removeObject(forKey: "Store_Current_Long")
                                            UserDefaults.standard.removeObject(forKey: "Store_Destination_Lat")
                                            UserDefaults.standard.removeObject(forKey: "Store_Destination_Long")
                                        }
                                        self.view.addSubview(alert)
                                        self.view.bringSubviewToFront(alert)
                                    }
            }
            
        }
        print("App entered in foreground")
    }
    
    
    
    func configureUI()  {
        
        self.containerHeightConstraint.constant = 0
        self.enrouteListTblHeight.constant = 0
        destinationTxtLbl.delegate = self
        sourceTxtLbl.delegate = self
        destinationTxtLbl.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        
        sourceTxtLbl.addTarget(self, action: #selector(textDidChangedSource(_:)), for: .editingChanged)
        sourceTxtLbl.isEnabled = true
        searchSourcePlacesTblView.isHidden = true
        searchPlacesTblView.isHidden = true
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 40
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        locManager.delegate = self
        locManager.startUpdatingLocation()
        
        if let currentLocation = DELEGATE.locationManager.location {
            mapContainerView.currentPosition = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            mapContainerView.addCurrentPositionMarker(currentPosition: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
        }
        
        
        mapContainerView.delegate = self
        mapContainerView.configureUI()
        mapContainerView.animate(toZoom: 10)
        mapContainerView.isMyLocationEnabled = true
        mapContainerView.settings.myLocationButton = true
        mapContainerView.settings.compassButton = true
        mapContainerView.padding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        
    }
    
    @objc func textDidChangedSource(_ textField: UITextField) {
        self.searchPlaces(text: textField.text ?? "")
        
        if textField.text?.count == 0 {
            print("Hide the table view")
            searchSourcePlacesTblView.isHidden = true
            searchSourcePlacesTblView.reloadData()
        }
        searchSourcePlacesTblView.isHidden = false
        searchSourcePlacesTblView.reloadData()
    }
    
    @objc func textDidChanged(_ textField: UITextField) {
        self.searchPlaces(text: textField.text ?? "")
       // clearButton.isHidden = (textField.text ?? "").isEmpty
        //storeReponse = nil
        if textField.text?.count == 0 {
            print("Hide the table view")
            searchPlacesTblView.isHidden = true
            searchPlacesTblView.reloadData()
        }
       // clearBtn.isHidden = (textField.text ?? "").isEmpty
        searchPlacesTblView.isHidden = false
        searchPlacesTblView.reloadData()
    }
    
    @objc func pauseTime() {
        self.remainingTimeForExpand = 60
        self.timeFor60Sec?.invalidate()
    }
    
    private func reloadWhenExpandAndCollapse() {
        print("Nearbywoloo model count: \(self.allNearByWolooList.count)")
        if self.self.allNearByWolooList.count > 0 {
//            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
//            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        } else {
           // self.tableView.reloadData()
            self.enrouteListTblView.reloadData()
        }
       // self.tableView.isScrollEnabled = !self.isMapExpand
    }
    
    func popUpContainerView(index: Int) {
        if let currentLocation = DELEGATE.locationManager.location {
            var param = [String:Any]()
            param["location"] = "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))"
            Global.addFirebaseEvent(eventName: "host_near_you_click", param: param)
            
            //Global.addNetcoreEvent(eventname: netCoreEvents.hostNearYouClick, param: param)
        }
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations:{ [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.pauseTime()
            weakSelf.containerView.frame.origin.y = UIScreen.main.bounds.height - 300
            weakSelf.containerHeightConstraint.constant = 500
            weakSelf.updateViewConstraints()
            weakSelf.view.layoutIfNeeded()
            DELEGATE.rootVC?.tabBarVc?.hideTabBar()
            self?.enrouteWolooStorePopUpVC2?.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            
        }, completion: {  [weak self] (finished) in
            guard let weakSelf = self else { return }
            weakSelf.isPresenting = true
            weakSelf.enrouteWolooStorePopUpVC2?.view.transform = .identity
            //weakSelf.mapWolooStorePopUpVC?.view.transform = .identity
        })
        
    }
    
    
    func searchPlaces(text: String) {
        
        //noStoreView.isHidden = true
        let filter = GMSAutocompleteFilter()
        filter.country = "IN"
        GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: self.googleToken) { [weak self] (results, error) -> Void in
            guard let self = self else { return }
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                self.searchList = results.map({ $0.attributedFullText.string })
                self.placeResult = results
            }
            //self.noResultLabel.isHidden = self.searchList?.count != 0
            self.searchPlacesTblView.reloadData()
        }
    }
    
    func dismissContainerView() {
        UIView.animate(withDuration: 0.4, delay: 0, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.timeForExpandAndCollapse()
            weakSelf.containerHeightConstraint.constant = 0
            weakSelf.containerView.frame.origin.y = UIScreen.main.bounds.height
            weakSelf.view.layoutIfNeeded()
           // DELEGATE.rootVC?.tabBarVc?.showTabBar()
        }, completion: { [weak self] (finished) in
            guard let weakSelf = self else { return }
            weakSelf.isPresenting = false
            weakSelf.enrouteWolooStorePopUpVC2?.view.transform = .identity
            //weakSelf.mapWolooStorePopUpVC?.view.transform = .identity
        })
    }
    
    
    @IBAction func closeAndOpenLooList(_ sender: UIButton) {
        
        print("Expand and collapse tableView")
        
        if collapseflag == false{
            self.enrouteListTblHeight.constant = (view.window?.fs_height ?? 0) * 0.4
            self.onRouteLbl.text = "Click here"
            collapseflag = true
        }else{
            self.enrouteListTblHeight.constant = 0
            self.onRouteLbl.text = "Woloo-Hosts On Route"
            collapseflag = false
        }

        
    }
    
    @IBAction func backNavigationbtnPressed(_ sender: UIButton) {
        print("pop up the viewcontroller")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func currentLocationBtnPressed(_ sender: UIButton) {
        
        print("current location btn pressed")
    }
    
    
    @IBAction func clearBtnAction(_ sender: UIButton) {
        searchPlacesTblView.isHidden = true
       // clearBtn.isHidden = true
        destinationTxtLbl.text = ""
        
        searchList?.removeAll()
        searchPlacesTblView.reloadData()
        
    }
    
    
    @IBAction func sourceCityClearBtnPressed(_ sender: UIButton) {
        
        searchSourcePlacesTblView.isHidden = true
        //sourceClearBtn.isHidden = true
        sourceTxtLbl.text = ""
        
        searchList?.removeAll()
        searchSourcePlacesTblView.reloadData()
    }
    
    @IBAction func startDirectionBtnPressed(_ sender: UIButton) {
                    print("Woloo transport mode \(transportMode.name)")
        
        if enrouteTag == true{
            if destinationTxtLbl.text!.isEmpty && sourceTxtLbl.text!.isEmpty {
                self.mapDirectionPopUpView.isHidden = true
            }else{
                self.mapDirectionPopUpView.isHidden = false
            }
            
        }else if isDirection == true{
            self.mapDirectionPopUpView.isHidden = false
        }
        
        
        }
                   
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        
        self.mapDirectionPopUpView.isHidden = true
    }
    
    
    @IBAction func popUpContinueBtnPressed(_ sender: Any) {
        print("Woloo transport mode \(transportMode.name)")
        Global.addNetcoreEvent(eventname: self.netCoreEvents.startWolooClick, param: [
            "woloo_id": storeID
                            ])
        /*
         if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                     UIApplication.sharedApplication().openURL(NSURL(string:
                         "comgooglemaps://?saddr=&daddr=\(place.latitude),\(place.longitude)&directionsmode=driving")!)

                 } else {
                     NSLog("Can't use comgooglemaps://");
                 }
             }
         */
        if enrouteTag == true{
            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                UIApplication.shared.openURL(NSURL(string:
                                                                "comgooglemaps://?saddr=\(sourceLat ?? 0),\(sourceLong ?? 0)&daddr=\(destLat ?? 0),\(destLong ?? 0)&directionsmode=driving")! as URL)

                    } else {
                        NSLog("Can't use comgooglemaps://");
                    }
                }
    
        
                 if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                                       UIApplication.shared.openURL(URL(string:
                                                                         "comgooglemaps://?q=\(destLat ?? 0),\(destLong ?? 0)&sensor=false&directionsmode=driving")!)
                                     } else {
                                       print("Can't use comgooglemaps://");
                                     }
                                     print("Form here we will navigate to google Map SDk")

     }
    
    @objc func updateTimerCount() {
        if remainingTimeForExpand > 0 {
            remainingTimeForExpand -= 1
            return
        }
        isMapExpand = true
        reloadWhenExpandAndCollapse()
        remainingTimeForExpand = 60
        timeFor60Sec?.invalidate()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker location - \(marker.title ?? ""): <\(marker.position.latitude), \(marker.position.longitude)>")
        //delegate?.didTapMarker(marker)
        //marker.title =
        didTapMarker(marker)
        return true
    }
    
    }
    


extension EnrouteVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("allStoresListv2.count \(allStoresListv2.count)")
        var numberOfRow = 1
        switch tableView {
        case enrouteListTblView:
                if allStoresListv2.count == 0{
                    numberOfRow = 1
                }
                else{
                    numberOfRow = allStoresListv2.count
                }

            
        case searchPlacesTblView:
            numberOfRow = self.searchList?.count ?? 0
            
        case searchSourcePlacesTblView:
            numberOfRow = self.searchList?.count ?? 0
        
        default:
            print("Some things Wrong!!")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch tableView{
            
        case searchPlacesTblView:
            print("search destination")
            cell = tableView.dequeueReusableCell(withIdentifier: "EnrouteSearchLocationCell", for: indexPath)
                    cell.textLabel?.text = self.searchList?[indexPath.row] as? String ?? ""
            return cell
            
        case searchSourcePlacesTblView:
            print("search source")
            cell = tableView.dequeueReusableCell(withIdentifier: "EnrouteSearchSourceTblViewCell", for: indexPath)
                    cell.textLabel?.text = self.searchList?[indexPath.row] as? String ?? ""
            
            //cell.textLabel?.text = "Hello source table"
            return cell
            
        case enrouteListTblView:
            if allStoresListv2.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoWolooDashboardCell.identifier, for: indexPath) as? NoWolooDashboardCell ?? NoWolooDashboardCell()
                //cell.searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
                
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: DashboardDirectionCell.identifier, for: indexPath) as? DashboardDirectionCell ?? DashboardDirectionCell()
                ///-------------------------------------------------------------------------------------
                //let customList = getNearbyWoloo.nearbyWolooObserver?[indexPath.row]
                //cell.customStore = allStoresListv2[indexPath.row]
                cell.customStore = allStoresListv2[indexPath.row]
                ///-------------------------------------------------------------------------------------
                //            let store = allStoresList[indexPath.row]
                //
                
                //
                //            cell.store = store
                //cell.imgTravelMode.image = transPortMode.whiteImage
                cell.directionBtnAction = { [self] in
                    //                Global.showAlert(title: "Message", message: "Feature in progress")
                    //                return
                    if cell.lblDistance.text == "-" {
                        //self.showNoDirectionAlert()
                    } else {
                        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnrouteVC") as? EnrouteVC
                        //                    guard let stores = self.nearByStoreResponseDO?.stores else { return }
                        
//                         guard let stores = self.nearByStoreResponseDOV2 else { return }
                        
                        /*
                         let stores = allStoresListv2
                         enrouteVC.destLat = Double(allStoresListv2[indexPath.row].lat ?? "")
                         enrouteVC.destLong = Double(allStoresListv2[indexPath.row].lng ?? "")
                         print("name passed: \(allStoresListv2[indexPath.row].name ?? "")")
                         enrouteVC.destinationTxt = "\(allStoresListv2[indexPath.row].name ?? "")"
                         enrouteVC.storeID = allStoresListv2[indexPath.row].id ?? 0
                         enrouteVC.isDirection = true
                         */
                        
                        //let stores = allStoresListv2
                        //vc?.wolooStoreV2 = stores
                        let stores = allStoresListv2
                        vc?.destLat = Double(allStoresListv2[indexPath.row].lat ?? "")
                        vc?.destLong = Double(allStoresListv2[indexPath.row].lng ?? "")
                        print("name passed: \(allStoresListv2[indexPath.row].name ?? "")")
                        vc?.destinationTxt = "\(allStoresListv2[indexPath.row].name ?? "")"
                        vc?.storeID = allStoresListv2[indexPath.row].id ?? 0
                        vc?.isDirection = true
                        //vc?.wolooStore = stores[indexPath.item]
                        //                    self.wolooStore = stores[indexPath.item]
                        //                    vc?.transportMode = self.transPortMode
                        Global.addFirebaseEvent(eventName: "direction_woloo_click", param: [
                            "woloo_id": allStoresListv2[indexPath.row].id as Any])
                        
                        Global.addNetcoreEvent(eventname: netCoreEvents.directionWolooClick, param:  ["woloo_id": allStoresListv2[indexPath.row].id as Any])
                        
                        var lat = allStoresListv2[indexPath.row].lat
                        var long = allStoresListv2[indexPath.row].lng
                        
                        print("current lat \(lat)")
                        print("current long\(long)")
                        
                        //                    print("Woloo Store Latitude \(self.wolooStore.lat ?? "")")
                        //                    print("Woloo Store Longitude \(self.wolooStore.lng ?? "")")
                      //  print("Selected Transport Mode: \(transportMode.name)")
                        self.navigationController?.pushViewController(vc!, animated: true)
                        
                        
                    }
                }
                return cell
            }
            
        default:
            print("some thing wrong!!")
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
            
        case searchSourcePlacesTblView:
            print("Searched source tableView")
            print("City tapped: \(searchList?[indexPath.row])")
            sourceTag = 1
            getPlaceDetails(result: placeResult[indexPath.row])
        
            
            searchSourcePlacesTblView.isHidden = true
            
            self.sourceTxtLbl.text = "\(searchList?[indexPath.row] ?? "") "
            
        case searchPlacesTblView:
            print("Search destination Tbl view")
            print("City tapped: \(searchList?[indexPath.row])")
            destinationTag = 1
            getPlaceDetails(result: placeResult[indexPath.row])
            
            searchPlacesTblView.isHidden = true
            
            self.destinationTxtLbl.text = "\(searchList?[indexPath.row] ?? "") "
            
            
        case enrouteListTblView:
            print("nearby data loaded")
            if allStoresListv2.count > indexPath.row {
                //self.dismissContainerView()
                //performSegue(withIdentifier: Constant.Segue.details, sender: getNearbyWoloo.nearbyWolooObserver?[indexPath.row])
                if let currentLocation = DELEGATE.locationManager.location {
                   
                   // Global.addNetcoreEvent(eventname: netCoreEvents.wolooDetailClick, param:  ["location": "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))","travel_mode": "", "host_click_id": "\(allStoresListv2[indexPath.row].id ?? 0)","host_click_location": "\(allStoresListv2[indexPath.row].lat ?? ""), \(allStoresListv2[indexPath.row].lng ?? "")"])
                    
                    //Global.addNetcoreEvent(eventname: netCoreEvents.hostNearYouClick, param: param)
                }
                
                
                print("Passed array index: \(allStoresListv2[indexPath.row])")
//                performSegue(withIdentifier: Constant.Segue.details, sender: allStoresListv2[indexPath.row])
                
                
                let vc = UIStoryboard.init(name: "Details", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
                vc?.wolooStoreDOV2 = allStoresListv2[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        default:
            print("table View not found")
        }
        
       
        
//        let storeloc = CLLocationCoordinate2D(latitude: destLat.toDouble() ?? 0.0, longitude: destLong.toDouble() ?? 0.0)
//
//        mapContainerView.addCustomMarker(lat: destLat.toDouble() ?? 0.0, long: destLong.toDouble() ?? 0.0, name: "Destination", index: 0)
//
//        if let cpos = mapContainerView.currentPosition {
//            fetchRoute(from: cpos, to: storeloc)
//        } else if let cpos = DELEGATE.locationManager.location {
//            fetchRoute(from: cpos.coordinate, to: storeloc)
//        }
       
        
        startBtn.isEnabled = true
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
                
                print("Search LAtitude: \(place.coordinate.latitude) Longitude: \(place.coordinate.longitude)")
//                Global.addNetcoreEvent(eventname: self.netCoreEvents.searchWolooClick, param: ["keywords": self.searchByLocationTxtField.text ?? "","location": "(\(place.coordinate.latitude),\(place.coordinate.longitude))"])
                
                
                if self.enrouteTag == true{
                    print("Add custom lat and long")
                    if self.sourceTag == 1{
                        print("change the source location to lat: \(place.coordinate.latitude) & \(place.coordinate.longitude)")
                        self.sourceLat = place.coordinate.latitude
                        self.sourceLong = place.coordinate.longitude
                        self.sourceTag = 0
                    }else if self.destinationTag == 1{
                        print("change the destination location to lat: \(place.coordinate.latitude) & \(place.coordinate.longitude)")
                        self.destLat = place.coordinate.latitude
                        self.destLong = place.coordinate.longitude
                        self.destinationTag = 0
                    }
                    var optionalSourceLat = self.locationManager.location?.coordinate.latitude
                    var optionalSourceLong = self.locationManager.location?.coordinate.longitude
                    
                    
                    self.fetchRoute(from: CLLocationCoordinate2D(latitude: (self.sourceLat ?? optionalSourceLat)!, longitude: (self.sourceLong ?? optionalSourceLong)!), to: CLLocationCoordinate2D(latitude: self.destLat ?? 0, longitude: self.destLong ?? 0))
                }
                
                
                
                let storeloc = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                 
                
                
//                if let cpos = self.mapContainerView.currentPosition {
//                    self.fetchRoute(from: cpos, to: storeloc)
////                    UserDefaultsManager.storeCurrentLat(value: cpos.latitude)
////                    UserDefaultsManager.storeCurrentLong(value: cpos.longitude)
////                    UserDefaultsManager.storeDestinationLat(value: self.destLat ?? 0.0)
////                    UserDefaultsManager.storeDestinationLong(value: self.destLong ?? 0.0)
////                    UserDefaultsManager.storeWolooID(value: self.storeID ?? 0)
////                    print("Store ID: \(self.storeID)")
//
//                } else if let cpos = DELEGATE.locationManager.location {
//                    self.fetchRoute(from: cpos.coordinate, to: storeloc)
//
////                    UserDefaultsManager.storeCurrentLat(value: cpos.coordinate.latitude)
////                    UserDefaultsManager.storeCurrentLong(value: cpos.coordinate.longitude)
////                    UserDefaultsManager.storeDestinationLat(value: self.destLat ?? 0.0)
////                    UserDefaultsManager.storeDestinationLong(value: self.destLong ?? 0.0)
////                    UserDefaultsManager.storeWolooID(value: self.storeID ?? 0)
////                    print("Store ID: \(self.storeID)")
//
//                }
                
               
                
               // self.getNearByStoresV2(lat: place.coordinate.latitude, lng: place.coordinate.longitude, mode: 1, range: "2", is_offer: 0)

//                let camera = GMSCameraPosition(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 14)
//                self.newMapContainerView.camera = camera
                
            }
        })

    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        print("(\(source.latitude),\(source.longitude))->(\(destination.latitude),\(destination.longitude))")
        let session = URLSession.shared
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=\(transportMode.googleAPIValue)&key=\(Constant.ApiKey.googleMap)")!
       
        
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
                        //self.stackDirection1.isHidden = true
                        //self.vwDirection2.isHidden = true
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
                                               // self.wolooNavigationRewardAPI(wolooId: self.storeId2 ?? 0)
                                                
                                                self.wolooNavigationRewardAPIV2(wolooId: self.storeID ?? 0)
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
                                            //self.lblDirection1.text = dist1Val
                                           // self.stackDirection1.isHidden = false
                                            if let maneuver1 = step1["maneuver"] as? String {
                                                if let m1image = UIImage(named:maneuver1) {
                                                   // self.imgDirection1.image = m1image
                                                } else {
                                                    //self.imgDirection1.image = UIImage(named: "straight")
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
                                
                                self.distanceLbl.text = distance["text"] as? String ?? ""
                                self.distanceLblBottom.text = distance["text"] as? String ?? ""
                            }
                            if let distance = leg["duration"] as? [String: Any] {
                                //self.lblMins.text = distance["text"] as? String ?? ""
                                
                                self.timeLbl.text = distance["text"] as? String ?? ""
                                self.timeLblBottom.text = distance["text"] as? String ?? ""
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
                    self.mapContainerView.clear()
                   self.mapContainerView.addDestinationMarker(lat: destination.latitude, long: destination.longitude, name: "Destination", index: 0)
                    self.destLat = destination.latitude
                    self.destLong = destination.longitude
                    
                    self.mapContainerView.addCurrentPositionMarker(currentPosition: source)
                    
                    let sourcePoint = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
                    let destinationPoint = CLLocationCoordinate2D(latitude: source.latitude,longitude: source.longitude)
                let bounds = GMSCoordinateBounds(coordinate: sourcePoint, coordinate: destinationPoint)
                    
                    
                let mapInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
                self.mapContainerView.padding = mapInsets
                self.mapContainerView.animate(toZoom: 10)
                let camera = self.mapContainerView.camera(for: bounds, insets: UIEdgeInsets())!
                self.mapContainerView.camera = camera
                
                self.drawPath(from: polyLineString)
                self.isFetchingPath = false
                    
                    if self.isDirection == false {
                        self.getEnrouteWoloo(src_lat: source.latitude, src_lng: source.longitude, target_lat: destination.latitude, target_lng: destination.longitude, overview_polyline: overview_polyline)
                        
                        self.bottomPopViewPolyline = overview_polyline
                        
                        self.enrouteListTblView.reloadData()
                    }
                    
                }
            }
        })
        task.resume()
        
    }
    
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2.0
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

extension EnrouteVC {
    
    //(18.578773377702344,73.7864723200506)->(19.0595596,72.8295287)
    
    func getEnrouteWoloo(src_lat: Double, src_lng: Double, target_lat: Double, target_lng: Double, overview_polyline: [String : Any]){
        
        Global.showIndicator()
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
        }
        DELEGATE.locationManager.startUpdatingLocation()
        
        let data = ["src_lat": src_lat, "src_lng": src_lng, "target_lat": target_lat, "target_lng": target_lng, "overview_polyline": overview_polyline] as [String : Any]
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
                self.mapContainerView.nearByStoreResponseDOV2 = response.results
//                self.mapContainerView.addAllMarkersV2()
                self.nearByStoreResponseDOV2 = response.results
                self.allStoresListv2 = response.results
                
               
                self.mapContainerView.addEnrouteMarkers()
               // self.enrouteListTblHeight.constant = (self.view.window?.fs_height ?? 0) * 0.4
                self.enrouteListTblView.reloadData()
               // mapContainerView.addEnrouteMarkers
                
            case .failure(let error):
                Global.hideIndicator()
                print("Enroute API failed: ", error)
            }
        }
        
       
    }
    
    func wolooNavigationRewardAPIV2(wolooId: Int) {
        
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
        
        var data = ["wolooId": wolooId ?? 0]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .wolooNavigationRewards, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<StatusSuccessResponseModel>, Error>) in
            switch result {
                
            case .success(let response):
                Global.hideIndicator()
                print("woloo Navigation rewards response: \(response)")
                var msg = ""
                
                msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationPoints ?? "")"
                
                Global.addFirebaseEvent(eventName: "woloo_destination_reached", param: [
                                            "woloo_id": wolooId])
                
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "ADD REVIEW", title: "", message: msg, image: nil, controller: self)
                    alert.cancelTappedAction = {
                        alert.removeFromSuperview()
                        let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
                        vc?.wolooStoreID2 = self.storeID ?? 0

                       // vc?.wolooStoreID2 = self.storeId2

                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                }
                
            case .failure(let error):
                Global.hideIndicator()
                print("woloo navigation error: \(error)")
                
            }
        }
    }
    
}

// MARK: - AnimationProtoCol


extension EnrouteVC:AnimationProtocol {
    
    func didTapExpandContractButton(_ isExpand: Bool) {
        if isExpand {
            pauseTime()
        }
        
        self.isMapExpand = isExpand
        self.reloadWhenExpandAndCollapse()
        if !self.isMapExpand {
            var param = [String:Any]()
            if let currentLocation = DELEGATE.locationManager.location {
                param["location"] = "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))"
            }
            Global.addFirebaseEvent(eventName: "host_near_you_click", param: param)
           // Global.addNetcoreEvent(eventname: netCoreEvents.hostNearYouClick, param: param)
            //getNearByStores()
            //self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0)
        }
        
        self.remainingTimeForExpand = 60
    }
    
    func selectedModeforTransport(mode: TransportMode) {
        var param = [String:Any]()
        if let currentLocation = DELEGATE.locationManager.location {
            param["location"] = "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))"
            param["mode"] = "\(mode.name)"
        }
        Global.addFirebaseEvent(eventName: "travel_mode_click", param: param)
        
//        Global.addNetcoreEvent(eventname: netCoreEvents.travelModeClick, param: param)
        
        transPortMode = mode
        UserDefaults.userTransportMode = mode
        self.pageCount = 1
        //self.nearByStoreResponseDO = nil
        //self.isDataExistInAPI = true
        self.didTapDismissButton()
        self.timeForExpandAndCollapse()
        
        print("Selected Transport Mode: \(mode)")
        //self.getNearByStores()
        
        if mode.name == "walking"{
            //self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 1, range: "2", is_offer: 0)
//            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: 0, isSearch: 0)
            
           
        }
        else{
            //self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0)
            
        }
        
    }
    
    //when tapped on marker available on screen
    func didTapMarker(_ marker: GMSMarker) {
        // if self.isMapExpand{
        guard let popUp = enrouteWolooStorePopUpVC2 else { return }
        
        
        if let currentLocation = DELEGATE.locationManager.location {
           
//            Global.addNetcoreEvent(eventname: netCoreEvents.wolooDetailClick, param:  ["location": "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))","travel_mode": "", "host_click_id": "\(popUp.wolooStoreV2?.id ?? 0)","host_click_location": "\(popUp.wolooStoreV2?.lat ?? ""), \(popUp.wolooStoreV2?.lng ?? "")"])
            
            //Global.addNetcoreEvent(eventname: netCoreEvents.hostNearYouClick, param: param)
            Global.addNetcoreEvent(eventname: netCoreEvents.wolooMarkerClick, param:  ["location": "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))","travel_mode": "", "host_click_id": "\(popUp.wolooStoreV2?.id ?? 0)","host_click_location": "\(popUp.wolooStoreV2?.lat ?? ""), \(popUp.wolooStoreV2?.lng ?? "")"])
        }
        
        popUp.delegate = self
        popUp.transportMode = transPortMode
        print("marker z index tapped: \(Int(marker.zIndex))")
        //popUp.collectionView.scrollToItem(at: IndexPath(item: 23, section: 0), at: .centeredHorizontally, animated: true)
        
        popUp.collectionView.reloadData()
        if !isPresenting{
            popUpContainerView(index: Int(marker.zIndex))
        } else {
            dismissContainerView()
        }
        // }
    }
    
    /// expand and collapse after 60 sec.
    func timeForExpandAndCollapse() {
        if !isMapExpand {
            if let valid = timeFor60Sec?.isValid, valid && timeFor60Sec != nil {
                remainingTimeForExpand = 60
                return
            }
            remainingTimeForExpand = 60
            timeFor60Sec = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(updateTimerCount), userInfo: nil, repeats: true)
        }
    }

    
    
    
}

extension EnrouteVC: EnrouteWolooStorePopUpVCDelegate{
    
    func collctionViewDidScrollTo(_ position: Int) {
//        guard let mapCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? MapCell else { return }
        //guard let stores = nearByStoreResponseDO?.stores else { return }
        
        print("scroll to position: \(position)")
        
        guard let storesV2 = nearByStoreResponseDOV2 else { return}
        
        let store = storesV2[position]
        print("Store positions: \(store)")
        
        if let lattitue = store.lat,let lat = Double(lattitue),let longitude = store.lng,let long = Double(longitude){
            let markerLocation = CLLocationCoordinate2D(latitude:lat, longitude: long)
            //mapCell.mapContainerView.animate(toLocation: markerLocation)
        }
        enrouteWolooStorePopUpVC2?.collectionView.reloadData()
    }
    
    
    func didSelectWolooStore(_ store: WolooStore) {
        return;
    }
    
    func didTapDismissButton() {
        dismissContainerView()
    }
    
}
