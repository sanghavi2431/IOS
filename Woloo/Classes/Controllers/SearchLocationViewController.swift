//
//  SearchLocationViewController.swift
//  Woloo
//
//  Created by ideveloper1 on 23/04/21.
//

import UIKit
import GooglePlaces

protocol SearchLocationDelegate : AnyObject {
    func onCitySelected(cityName: String)
}


//MARK: Newcode from here=================================

class SearchLocationViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    //@IBOutlet weak var nowButton: UIButton!
    @IBOutlet weak var offerButton: UIButton!
    @IBOutlet weak var noStoreView: UIView!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var appreciateLabel: UILabel!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var listWolooLbl: UILabel!
    
    @IBOutlet weak var openNowBtn: UIButton!
    var googleToken: GMSAutocompleteSessionToken?
    var searchList: [Any]?
    var placeResult = [GMSAutocompletePrediction]()
    var storeReponse: NearByStoreResponse?
    
    var allSearchList = [NearbyResultsModel]()
    var nearbyStoreResponse: [NearbyResultsModel]? = nil
    
    var allStoreListv2 = [NearbyResultsModel]()
    
    var netcoreEvents = NetcoreEvents()
    /*{
        didSet {
            tableView.reloadData()
        }
    }*/
    
    var myOfferCount = ""

    var isOffer = false
    var isNow = false
    var allStoresList = [WolooStore]()
    var selectedPlace : GMSPlace?
    var isFromEditProfile = false
    var transportMode = TransportMode.car
    var pageCount = 1
    weak var delegate: SearchLocationDelegate? = nil
    var shouldFetchData = true
    var isMyOffer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        userJourneyAPI()
        listWolooLbl.isHidden = true
        
        if isMyOffer {
            noResultLabel.isHidden = true
            listWolooLbl.isHidden = false
            getNearByOffers()
        }
    }
    
    func setup() {
        offerButton.isSelected = isOffer
        //nowButton.isSelected = isNow
        navigationController?.setNavigationBarHidden(true, animated: false)
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView.prefetchDataSource = self
        self.tableView?.estimatedRowHeight = 64
        self.tableView.register(UINib(nibName: Cell.searchStore, bundle: nil), forCellReuseIdentifier: Cell.searchStore)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.storeDetail,let destination = segue.destination as? DetailsVC {
            destination.wolooStoreDOV2 = sender as? NearbyResultsModel
            destination.tranportMode = transportMode
        }
    }
    @IBAction func openNowBtnPressed(_ sender: UIButton) {
        openNowBtn.isSelected = !openNowBtn.isSelected
        
        print("Open button is selected: \(openNowBtn.isSelected)")
        
        if openNowBtn.isSelected{
            if let openLocation = selectedPlace {
                self.shouldFetchData = true
                self.selectedPlace = openLocation
                let currentLatitude = String(openLocation.coordinate.latitude)
                print(currentLatitude)
                let currentLongitude = String(openLocation.coordinate.longitude)
                print(currentLongitude)
                self.storeReponse = nil
                self.allStoreListv2.removeAll()
                
                self.searchNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 1 : 0)
                self.tableView.reloadData()
                
            }
            //self.searchNearByStoresV2(lat: place.coordinate.latitude, lng: place.coordinate.longitude, mode: 1 , range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1)
            //self.tableView.reloadData()
            
            
        }
        
        if !openNowBtn.isSelected{
            if let openLocation = selectedPlace {
                self.shouldFetchData = true
                self.selectedPlace = openLocation
                let currentLatitude = String(openLocation.coordinate.latitude)
                print(currentLatitude)
                let currentLongitude = String(openLocation.coordinate.longitude)
                print(currentLongitude)
                self.storeReponse = nil
                self.allStoreListv2.removeAll()
                
                self.searchNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 1 : 0)
                self.tableView.reloadData()
            }
            print("Open Now button is not selected")
           
        }
        
    }
}

// MARK: - Actions
extension SearchLocationViewController {
    @IBAction func clearButtonAction() {
        clearButton.isHidden = true
        searchTextField.text = ""
        searchList?.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func ShopAction() {
//        let shopeSB = UIStoryboard(name: "Shop", bundle: nil)
//        let shopeVC = shopeSB.instantiateViewController(withIdentifier: "ShopVC")
//        navigationController?.pushViewController(shopeVC, animated: true)
//
        let shopeSB = UIStoryboard(name: "Shop", bundle: nil)
        if let shopeVC = shopeSB.instantiateViewController(withIdentifier: "ECommerceDashboardViewController") as? ECommerceDashboardViewController {
            self.navigationController?.pushViewController(shopeVC, animated: true)
        }
        
    }
    
    @IBAction func OfferAction() {
        offerButton.isSelected = !offerButton.isSelected
//        if let place = selectedPlace {
//            self.shouldFetchData = true
//            self.selectedPlace = place
//            Global.addFirebaseEvent(eventName: "search_woloo_click", param: [
//              //  "name": place.name ?? "",
//                "keywords": self.searchTextField.text ?? "",
//                "location": "(\(place.coordinate.latitude),\(place.coordinate.longitude))"
//            ])
//            var request = NearByWolooStoreRequest()
//            request.lat = String(place.coordinate.latitude)
//            request.long = String(place.coordinate.longitude)
//            request.page = "1"
//            request.range = "6"
//            request.isSearch = "1"
//            request.offers = self.offerButton.isSelected ? "1" : "0"
//            request.mode = "\(self.transportMode.rawValue)"
//            self.storeReponse = nil
//            self.allStoresList.removeAll()
//            //self.getNearByStores(request: request)
//        }
    }
    
    
    
}

// MARK: - UITextFieldDelegate
extension SearchLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func textDidChanged(_ textField: UITextField) {
        self.searchPlaces(text: textField.text ?? "")
        clearButton.isHidden = (textField.text ?? "").isEmpty
        storeReponse = nil
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate & DataSource
extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource,UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if storeReponse == nil {
            return self.searchList?.count ?? 0
        } else {
            return allStoreListv2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if storeReponse == nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.searchLocation) as? SearchLocationCell else { return UITableViewCell() }
            cell.txtLabel.text = self.searchList?[indexPath.row] as? String ?? ""
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.searchStore) as? SearchStoreCell else { return UITableViewCell() }
            //cell.store = allStoresList[indexPath.row]//self.storeReponse?.stores?[indexPath.row]
            
            print("all Store Searched List: \(allStoreListv2[indexPath.row])")
            
            cell.customStore = allStoreListv2[indexPath.row]
            
            cell.imgTravelMode.image = transportMode.whiteImage
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromEditProfile {
            let city = self.placeResult[indexPath.row].attributedPrimaryText.string
            delegate?.onCitySelected(cityName: city)
            navigationController?.popViewController(animated: true)
        } else if storeReponse == nil {
            getPlaceDetails(result: placeResult[indexPath.row])
        } else {
            let selectedStore = allStoreListv2[indexPath.row]
            var param = [
                "keywords": self.searchTextField.text ?? "",
                "host_click_location": "(\(selectedStore.lat ?? ""),\(selectedStore.lng ?? ""))",
                "host_click_id": "\(selectedStore.id ?? 0)"]
            if let currentLocation = DELEGATE.locationManager.location {
                param["location"] = "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))"
            }
            Global.addFirebaseEvent(eventName: "woloo_clicked_from_searched_woloo", param: param)
            
            Global.addNetcoreEvent(eventname: self.netcoreEvents.wolooClickedFromSearchedWoloo, param: [
                "keywords": self.searchTextField.text ?? "",
                "host_click_location": "(\(selectedStore.lat ?? ""),\(selectedStore.lng ?? ""))",
                "host_click_id": "\(selectedStore.id ?? 0)"])
//            
            print("data Clicked of object: \(selectedStore)")
            
            self.performSegue(withIdentifier: Segues.storeDetail, sender: allStoreListv2[indexPath.row])
        }
    }
   
        
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if storeReponse == nil {
           //city
        } else {
            if indexPaths.contains(where: isLoadingCell) { // Call API
                if shouldFetchData {
                    pageCount += 1
                    if let lat = selectedPlace?.coordinate.latitude, let long = selectedPlace?.coordinate.longitude {
                        var request = NearByWolooStoreRequest()
                        request.lat = String(lat)
                        request.long = String(long)
                        request.page = "\(pageCount)"
                        request.range = "2"
                        request.isSearch = "1"
                        request.mode = "\(self.transportMode)"
                        request.offers = offerButton.isSelected ? "1" : "0"
                        //self.getNearByStores(request: request)
                    }
                }
            }
        }
    }
    
    /// Check for index is last.
    /// - Parameter indexPath: Give indexpath.
    /// - Returns: True or False
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
//        if (self.pageCount == 1 && allStoresList.count == 0) {
//                return false
//        }
        return  indexPath.row == allStoresList.count - 1
    }
}

//MARK: - API
extension SearchLocationViewController {
    
    func searchPlaces(text: String) {
        
        noStoreView.isHidden = true
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
            self.noResultLabel.isHidden = self.searchList?.count != 0
            self.tableView.reloadData()
        }
    }
    
    func getNearByStores(request: NearByWolooStoreRequest) {
        Global.showIndicator()
        print("nearbywollocalled")
        APIManager.shared.getNearbyWolooStores(request: request) { (response, message) in
            Global.hideIndicator()
            DispatchQueue.main.async {
//                onse :👉 {"status":"success","message":"50 Woloo Points","data":[]}
                if response?.stores?.count == 0 {
                    let msg = response?.message ?? ""
                    if msg.contains("Woloo Points") {
                        self.pointsView.isHidden = false
                        self.appreciateLabel.isHidden = false
                        self.shopButton.isHidden = false
                        let arr = msg.split(separator: " ")
                        if arr.count > 0 {
                            self.pointsLabel.text = "\(arr[0])"
                        }
                    } else {
                        self.pointsView.isHidden = true
                        self.appreciateLabel.isHidden = true
                        self.shopButton.isHidden = true
                    }
                   
                    self.noStoreView.isHidden = self.allStoresList.count != 0
                    self.shouldFetchData = false
                    return
                }
                self.storeReponse = response
                self.allStoresList.append(contentsOf: response?.stores ?? [])
                print("page \(self.pageCount) --> \(String(describing: response?.stores?.count))")
                self.noStoreView.isHidden = self.allStoresList.count != 0
                self.tableView.reloadData()
            }
        }
    }
    
    func searchNearByStoresV2(lat: Double, lng: Double, mode: Int, range: String,is_offer: Int, showAll: Int){
        
        //Global.showIndicator()
        print("nearbywoloo Search called")
        
        print("GetNearby stores V2")
        let data = ["lat": lat, "lng": lng, "mode": mode, "range": range,"is_offer": is_offer, "showAll": showAll ] as [String : Any]
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        print("Nearby Woloo data: \(data)")
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .nearByWoloo, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<[NearbyResultsModel]>, Error>) in
            switch result{
            case .success(let response):
                if response.results.count == 0{
                    
                    print("result list is empty \(response)")
                    
                    //self.appreciateLabel.isHidden = false
                    self.shopButton.isHidden = true
                    self.pointsView.isHidden = true
                    self.appreciateLabel.isHidden = true
                    
                    var param = [String:Any]()
                    param["location"] = "(\(lat),\(lng))"
                    Global.addNetcoreEvent(eventname: self.netcoreEvents.noLocationFound, param: param)
                    
                    self.noStoreView.isHidden = self.allStoresList.count != 0
                }else{
                    self.pointsView.isHidden = true
                    self.appreciateLabel.isHidden = true
                    self.shopButton.isHidden = true
                    
                    
                    
                    
                    print("Success response of search near By list \(response)")
                    
                }
                self.allStoreListv2 = response.results
                self.noStoreView.isHidden = self.allStoreListv2.count != 0
                self.listWolooLbl.isHidden = false
                
                self.tableView.reloadData()
                
            case .failure(let error):
                print("reponse results v2 Error",error)
                
            }//Switch
            
        }
    }//function end of API call
    
//    func searchWolooStores(param:[String: Any]) {
//        Global.showIndicator()
//        APIManager.shared.searchWolooStore(param: param) { (response, message) in
//            Global.hideIndicator()
//            DispatchQueue.main.async {
//                self.storeReponse = response
//            }
//        }
//    }
    
    func getNearByOffers()  {
        
        if let currentLocation = DELEGATE.locationManager.location {
            let currentLatitude = String(currentLocation.coordinate.latitude)
            print(currentLatitude)
            let currentLongitude = String(currentLocation.coordinate.longitude)
            print(currentLongitude)
            var request = NearByWolooStoreRequest()
            request.lat = currentLatitude
            request.long = currentLongitude
            request.page = "1"
            request.range = "6"
            request.isSearch = "1"
            request.offers = "1"
            request.mode = "\(self.transportMode.rawValue)"
            self.storeReponse = nil
            self.allStoresList.removeAll()
            //self.getNearByStores(request: request)
            
           
            self.searchNearByStoresV2(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 1 : 0)
            self.tableView.reloadData()
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
                self.shouldFetchData = true
                self.selectedPlace = place
                Global.addFirebaseEvent(eventName: "search_woloo_click", param: [
                  //  "name": place.name ?? "",
                    "keywords": self.searchTextField.text ?? "",
                    "location": "(\(place.coordinate.latitude),\(place.coordinate.longitude)"
                ])
                
                Global.addNetcoreEvent(eventname: self.netcoreEvents.searchWolooClick, param: ["keywords": self.searchTextField.text ?? "","location": "(\(place.coordinate.latitude),\(place.coordinate.longitude))"])
                
                var request = NearByWolooStoreRequest()
                request.lat = String(place.coordinate.latitude)
                request.long = String(place.coordinate.longitude)
                request.page = "1"
                request.range = "6"
                request.isSearch = "1"
                request.offers = self.offerButton.isSelected ? "1" : "0"
                
                print("transport mode raw value: \(self.transportMode.rawValue)")
                
                request.mode = "\(self.transportMode.rawValue)"
                self.storeReponse = nil
                
                self.allStoresList.removeAll()
                self.allStoreListv2.removeAll()
                self.getNearByStores(request: request)
                
                print("Search LAtitude: \(place.coordinate.latitude) Longitude: \(place.coordinate.longitude)")
                
            
                
                if self.transportMode.rawValue == 0{
                    self.searchNearByStoresV2(lat: place.coordinate.latitude, lng: place.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1)
                    self.tableView.reloadData()
                }else{
                    self.searchNearByStoresV2(lat: place.coordinate.latitude, lng: place.coordinate.longitude, mode: 1 , range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1)
                    self.tableView.reloadData()
                }
                //self.searchNearByStoresV2(lat: place.coordinate.latitude, lng: place.coordinate.longitude, mode: 0, range: "1", is_offer: 0)
            }
        })
    }
    
    fileprivate func userJourneyAPI() {
        let param:  [String : Any] =  [ "event_name": "user Login" ,
                                        "event_data": "user"]
        APIManager.shared.userJourney(param) {[weak self] response, message in
            guard let weak = self else { return }
            if let `response` = response, response.status == .success {
                
            }
            print(message)
        }
    }
}

//Details is segue id




