//
//  SearchWolooVC.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 12/06/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class SearchWolooVC: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var searchMapContainerView: MapContainerView!
    
    @IBOutlet weak var distanceCollectionView: UICollectionView!
    
    @IBOutlet weak var wolooListTblView: UITableView!
    
    @IBOutlet weak var searchCityListTblview
    : UITableView!
    
    @IBOutlet weak var searchPlaceTxtField: UITextField!
    
    @IBOutlet weak var clearBtn: UIButton!
    
    @IBOutlet weak var openNowBtn: UIButton!
    
    @IBOutlet weak var wolooWithOfferBtn: UIButton!
    
    @IBOutlet weak var searchedWolooListHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    var lat, long: Double?
    var searchedPlace: String?
    var isDataExistInAPI = true
    let locManager = DELEGATE.locationManager
    var searchList: [Any]?
    var placeResult = [GMSAutocompletePrediction]()
    var googleToken: GMSAutocompleteSessionToken?
    var selectedPlace : GMSPlace?
    var transportMode = TransportMode.car
    var selectedIndex = Int ()
    var kms = ["2 km","4 km","6 km","8 km","25 km"]
    var allStoresListv2 = [NearbyResultsModel]()
    var isCollapsed = true
    var netCoreEvents = NetcoreEvents()
    var allWolooList = [NearbyResultsModel]()
    
    fileprivate var nearByStoreResponseDOV2: [NearbyResultsModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        distanceCollectionView.delegate = self
        distanceCollectionView.dataSource = self
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Search vc cleared")
    
    }

    func configureUI()  {
        
        self.searchedWolooListHeight.constant = 0
        clearBtn.isHidden = false
        searchPlaceTxtField.delegate = self
        searchPlaceTxtField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        locManager.delegate = self
        locManager.startUpdatingLocation()
        searchCityListTblview.isHidden = true
        searchPlaceTxtField.text = searchedPlace ?? ""
        self.registerCells()
        
        if let currentLocation = DELEGATE.locationManager.location {
            searchMapContainerView.currentPosition = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            
            searchMapContainerView.delegate = self
            searchMapContainerView.configureUI()
            searchMapContainerView.animate(toZoom: 10)
            searchMapContainerView.isMyLocationEnabled = true
//            searchMapContainerView.settings.myLocationButton = true
//            searchMapContainerView.settings.compassButton = true
            searchMapContainerView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        }
        
        self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
        let camera = GMSCameraPosition(latitude: lat ?? 0, longitude: long ?? 0, zoom: 14)
        searchMapContainerView.addCurrentPositionMarker(currentPosition: CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0))
        self.searchMapContainerView.camera = camera
    }
    
    @objc func textDidChanged(_ textField: UITextField) {
        self.searchPlaces(text: textField.text ?? "")
//        clearButton.isHidden = (textField.text ?? "").isEmpty
//        storeReponse = nil
        if textField.text?.count == 0 {
            print("Hide the table view")
            searchCityListTblview.isHidden = true
            searchCityListTblview.reloadData()
        }
       // clearBtn.isHidden = (textField.text ?? "").isEmpty
        searchCityListTblview.isHidden = false
        searchCityListTblview.reloadData()
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
            self.searchCityListTblview.reloadData()
        }
    }
    
    fileprivate func registerCells() {
        
        wolooListTblView.register(DashboardDirectionCell.nib, forCellReuseIdentifier: DashboardDirectionCell.identifier)
        
        wolooListTblView.register(NoWolooDashboardCell.nib, forCellReuseIdentifier: NoWolooDashboardCell.identifier)
    }
    
    @IBAction func backNavigationBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func clearBtnAction(_ sender: UIButton) {
        
       // clearBtn.isHidden = true
        searchPlaceTxtField.text = ""
        searchList?.removeAll()
        searchCityListTblview.reloadData()
        searchCityListTblview.isHidden = true
    }
    
    
    @IBAction func openNowBtnPressed(_ sender: UIButton) {
        
        self.openNowBtn.isSelected = !openNowBtn.isSelected
        
        if openNowBtn.isSelected{
//            self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 1, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
//
            
            if let openLocation = selectedPlace {
                let currentLatitude = String(openLocation.coordinate.latitude)
                print(currentLatitude)
                let currentLongitude = String(openLocation.coordinate.longitude)
                print(currentLongitude)
                self.allStoresListv2.removeAll()
                
                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
                self.wolooListTblView.reloadData()
                print("Open Now button is selected")
            }else {
                self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
            }
            
            
        }
        if !openNowBtn.isSelected{
            //self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
            if let openLocation = selectedPlace {
                self.selectedPlace = openLocation
                let currentLatitude = String(openLocation.coordinate.latitude)
                print(currentLatitude)
                let currentLongitude = String(openLocation.coordinate.longitude)
                print(currentLongitude)
                self.allStoresListv2.removeAll()
                
                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                self.wolooListTblView.reloadData()
                print("Open Now button is not selected")
            }
            else {
                self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
            }
            
        }
        
    }
    
    @IBAction func bookmarkBtnPressed(_ sender: UIButton) {
        
        self.bookmarkBtn.isSelected = !self.bookmarkBtn.isSelected
        if bookmarkBtn.isSelected{
            let resultArray = allStoresListv2.filter{ $0.is_liked == 1 }
            
            allStoresListv2.removeAll()
            nearByStoreResponseDOV2?.removeAll()
            allStoresListv2.append(contentsOf: resultArray)
            nearByStoreResponseDOV2?.append(contentsOf: resultArray)
            self.searchMapContainerView.nearByStoreResponseDOV2 = resultArray
            self.searchMapContainerView.addAllMarkersV2()
            print("bookmarked woloos: \(allStoresListv2)")
            self.wolooListTblView.reloadData()
        }
        
        if !bookmarkBtn.isSelected{
            allStoresListv2.removeAll()
            nearByStoreResponseDOV2?.removeAll()
            allStoresListv2.append(contentsOf: allWolooList)
            nearByStoreResponseDOV2?.append(contentsOf: allWolooList)
            self.searchMapContainerView.nearByStoreResponseDOV2 = allWolooList
            self.searchMapContainerView.addAllMarkersV2()
            self.wolooListTblView.reloadData()
        }
    }
    
    
    @IBAction func wolooWithOfferPressed(_ sender: UIButton) {
        
        self.wolooWithOfferBtn.isSelected = !wolooWithOfferBtn.isSelected
        
        if wolooWithOfferBtn.isSelected{
            if let openLocation = selectedPlace {
                self.selectedPlace = openLocation
                let currentLatitude = String(openLocation.coordinate.latitude)
                print(currentLatitude)
                let currentLongitude = String(openLocation.coordinate.longitude)
                print(currentLongitude)
                self.allStoresListv2.removeAll()
                
                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                self.wolooListTblView.reloadData()
                print("Open Now button is not selected")
            }else{
                self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
            }
            
        }
        
        if !wolooWithOfferBtn.isSelected{
            if let openLocation = selectedPlace {
                self.selectedPlace = openLocation
                let currentLatitude = String(openLocation.coordinate.latitude)
                print(currentLatitude)
                let currentLongitude = String(openLocation.coordinate.longitude)
                print(currentLongitude)
                self.allStoresListv2.removeAll()
                
                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                self.wolooListTblView.reloadData()
                print("Open Now button is not selected")
            }else{
                self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
            }
            
        }
        
    }
    
    @IBAction func dashedButtonPressed(_ sender: UIButton) {
        print("Expand and Collapsible")
        
        if isCollapsed == false {
            searchedWolooListHeight.constant = 0
            self.isCollapsed = true
        }else if isCollapsed == true{
            self.searchedWolooListHeight.constant = (self.view.window?.fs_height ?? 0) * 0.4
            self.isCollapsed = false
        }
    }
    
}

extension SearchWolooVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "DistannceCollectionViewCell", for: indexPath) as? DistannceCollectionViewCell)!
        //background: #D9D9D9;

        //#FAEB2C
        cell.backgroundColor = selectedIndex == indexPath.row ? UIColor(hexString: "#FAEB2C") : UIColor(hexString: "#D9D9D9")
        cell.distanceTxtLbl.text = kms[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("following tag is selected \(indexPath.item)")
        selectedIndex = indexPath.row
       
        self.distanceCollectionView.reloadData()
        //self.openNowBtn.isSelected = !openNowBtn.isSelected
        switch indexPath.item {
            
        case 0:
            print("2 kms")
            self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
            
        case 1:
            print("4 kms")
            self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "4", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
            
        case 2:
            print("6 kms")
            self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "6", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
            
        case 3:
            print("8 kms")
            self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "8", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
        case 4:
            print("25 kms")
            self.getNearByStoresV2(lat: lat ?? 0, lng: long ?? 0, mode: 0, range: "25 ", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
            
        default:
            print("No kms selected")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //cell.backgroundColor = .yellow
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}

extension SearchWolooVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRow = 1
        switch tableView {
        case wolooListTblView:
            if allStoresListv2.count == 0{
                numberOfRow = 1
            }
            else{
                numberOfRow = allStoresListv2.count
            }
            
        case searchCityListTblview:
            print("Searched rows: \(self.searchList?.count ?? 0)")
            numberOfRow = self.searchList?.count ?? 0
            
        default:
            print("Some things Wrong!!")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch tableView{
        case searchCityListTblview:
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchedListCell", for: indexPath)
                    cell.textLabel?.text = self.searchList?[indexPath.row] as? String ?? ""
            
            return cell
            
        case wolooListTblView:
            if allStoresListv2.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoWolooDashboardCell.identifier, for: indexPath) as? NoWolooDashboardCell ?? NoWolooDashboardCell()
               
                
                if openNowBtn.isSelected{
                    self.showToast(message: "No Woloos available at the moment.!")
                }
                
                //cell.searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
                
                cell.searchButton.isHidden = true
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: DashboardDirectionCell.identifier, for: indexPath) as? DashboardDirectionCell ?? DashboardDirectionCell()
                ///-------------------------------------------------------------------------------------
                //let customList = getNearbyWoloo.nearbyWolooObserver?[indexPath.row]
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
                        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapDirectionVC") as? MapDirectionVC
                        //                    guard let stores = self.nearByStoreResponseDO?.stores else { return }
                        
                        // guard let stores = self.nearByStoreResponseDOV2 else { return }
                        
                        let stores = allStoresListv2
                        vc?.wolooStoreV2 = stores
                        vc?.destLat = allStoresListv2[indexPath.row].lat ?? ""
                        vc?.destLong = allStoresListv2[indexPath.row].lng ?? ""
                        vc?.cityName = allStoresListv2[indexPath.row].city ?? ""
                        
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
            print("Some things Wrong!!")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchCityListTblview.isHidden = true
        switch tableView {
            
        case searchCityListTblview:
            print("City tapped: \(searchList?[indexPath.row])")
            getPlaceDetails(result: placeResult[indexPath.row])
            self.searchPlaceTxtField.text = "\(searchList?[indexPath.row] ?? "")"
            self.bookmarkBtn.isSelected = false
            self.openNowBtn.isSelected = false
            
        case wolooListTblView:
            print("nearby data loaded")
            if allStoresListv2.count > indexPath.row {
                //self.dismissContainerView()
                //performSegue(withIdentifier: Constant.Segue.details, sender: getNearbyWoloo.nearbyWolooObserver?[indexPath.row])
                if let currentLocation = DELEGATE.locationManager.location {
                   
                   // Global.addNetcoreEvent(eventname: netCoreEvents.wolooDetailClick, param:  ["location": "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))","travel_mode": "", "host_click_id": "\(allStoresListv2[indexPath.row].id ?? 0)","host_click_location": "\(allStoresListv2[indexPath.row].lat ?? ""), \(allStoresListv2[indexPath.row].lng ?? "")"])
                    
                    //Global.addNetcoreEvent(eventname: netCoreEvents.hostNearYouClick, param: param)
                }
                
                
                print("Passed array index: \(allStoresListv2[indexPath.row])")
                //performSegue(withIdentifier: Constant.Segue.details, sender: allStoresListv2[indexPath.row])
                
                let vc = UIStoryboard.init(name: "Details", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
                vc?.wolooStoreDOV2 = allStoresListv2[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        default:
            print("No table found")
            
        }
    }
    
    }


extension SearchWolooVC{
    
    func getNearByStoresV2(lat: Double, lng: Double, mode: Int, range: String, is_offer: Int, showAll: Int, isSearch: Int){
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            showAlertWithActionOkandCancel(Title: "Network Issue", Message: "Please Enable Your Internet", OkButtonTitle: "OK", CancelButtonTitle: "Cancel") {
                print("no network found")
            }
            return
            
        }
        
        if !isDataExistInAPI {
            return
        }
        
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
                //if let response = response{
                Global.hideIndicator()
                print(response.results.count)
//                if response.results.count == 0{
//                    //self.showNoWoloo = true
//                    //self.timeForExpandAndCollapse()
//                    self.searchedWolooListHeight.constant = (self.view.window?.fs_height ?? 0) * 0.4
//                    self.isDataExistInAPI = true
//                    // self.tableView.reloadData()
//                    self.wolooListTblView.reloadData()
//                    return
//                }
                //self.nearbyListTblViewHeight.constant = (self.view.window?.fs_height ?? 0) * 0.4
                //self.showNoWoloo = false
                self.isCollapsed = false
                self.searchedWolooListHeight.constant = (self.view.window?.fs_height ?? 0) * 0.4
                self.isDataExistInAPI = true
                self.nearByStoreResponseDOV2 = response.results
                self.allWolooList = response.results
                self.allStoresListv2 = response.results
                //self.tableView.reloadData()
                self.wolooListTblView.reloadData()
               // self.timeForExpandAndCollapse()
                
               // self.newMapContainerView.nearByStoreResponseDOV2 = response.results
                
                self.searchMapContainerView.nearByStoreResponseDOV2 = response.results
                self.searchMapContainerView.addAllMarkersV2()
                // }else{
                if self.allStoresListv2.count == 0{
                    var param = [String:Any]()
                    param["location"] = "(\(lat),\(lng))"
                    Global.addNetcoreEvent(eventname: self.netCoreEvents.noLocationFound, param: param)
                    //self.showNoWoloo = true
                    //self.timeForExpandAndCollapse()
                    self.isDataExistInAPI = true
                    // self.tableView.reloadData()
                    self.wolooListTblView.reloadData()
                    return
                }
                print("resposne for nearByV2: \(response)")
                // }
                
            case .failure(let error):
                Global.hideIndicator()
                print("reponse results v2 Error",error)
                //self.showNoWoloo = true
                // self.tableView.reloadData()
                self.wolooListTblView.reloadData()
            }
        }
    }
    
    
    func getPlaceDetails(result: GMSAutocompletePrediction) {
        Global.showIndicator()
       // let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.addressComponents.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
        
        /*
         // After.
         let field =  GMSPlaceField(
             rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.photos.rawValue
         )
         */
        
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
                
                self.getNearByStoresV2(lat: place.coordinate.latitude, lng: place.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 1)
                
        
                Global.addNetcoreEvent(eventname: self.netCoreEvents.searchWolooClick, param: ["keywords": self.searchPlaceTxtField.text ?? "","location": "(\(place.coordinate.latitude),\(place.coordinate.longitude))"])
                
                self.lat = place.coordinate.latitude
                self.long = place.coordinate.longitude
                
                self.searchMapContainerView.addCurrentPositionMarker(currentPosition: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                
                let camera = GMSCameraPosition(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 14)
                self.searchMapContainerView.camera = camera
                
            }
        })

    }
    
}

