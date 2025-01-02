//
//  DashboardVC.swift
//  Woloo
//
//  Created by Ashish Khobragade on 23/12/20.
//

import UIKit
import GoogleMaps
import Foundation
import Smartech
import GooglePlaces


protocol AnimationProtocol:class {
    func didTapExpandContractButton(_ isExpand: Bool)
    func didTapMarker(_ marker: GMSMarker)
    func selectedModeforTransport(mode: TransportMode)
}

var selectedWolooGlobal: NearbyResultsModel?
var likeStatusGlobal = -1

class DashboardVC: AbstractVC, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var wolooStore  = WolooStore ()
    var transportMode = TransportMode.car
    var getNearbyWoloo = NearbyWolooObserver()
    var sendOtp = SendOtpObserver()
    var verifyOtp = VerifyOtpObserver()
    var appConfigGet = AppConfigGetObserver()
    var locationManager = CLLocationManager()
    var dashboardScreenTag: Int?
    
    var netCoreEvents = NetcoreEvents()
    var searchList: [Any]?
    var placeResult = [GMSAutocompletePrediction]()
    var googleToken: GMSAutocompleteSessionToken?
    var selectedPlace : GMSPlace?
    var searchedLat: Double?
    var searchedlong: Double?
    
    var objUser = UserProfileModel()
    var objDashboardViewModel = DashboardViewModel()
    
    var subscription_tag = 0
    // @IBOutlet weak var nearByWolooTblView: UITableView!
    
    var collapseflag = true
    
    var wolooSupport: Place?
    var nearestHospital: Place?
    var nearestPoliceStation: Place?
    var nearestFireStation: Place?
    var isSOSOptionSelected: String? = ""
    
    
    //Search text field
    @IBOutlet weak var searchTblView: UITableView!
    @IBOutlet weak var searchWolooView: UIView!
    @IBOutlet weak var searchByLocationTxtField: UITextField!
    @IBOutlet weak var openNowBtn: UIButton!
    @IBOutlet weak var wolooWithOfferBtn: UIButton!
    @IBOutlet weak var openNowWolooWithOfferBtnView: UIView!
    @IBOutlet weak var currentLocationbtn: UIButton!
    
    @IBOutlet weak var sosCallBtn: UIButton!
    
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var nearByListTblView: UITableView!
    
    @IBOutlet weak var trialStatusLbl: UILabel!
    @IBOutlet weak var nearbyWolooLbl: UILabel!
    @IBOutlet weak var newMapContainerView: MapContainerView!
    weak var delegate:AnimationProtocol?
    
    @IBOutlet weak var nearbyListTblViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bookmarkBtn: UIButton!

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var stackName: UIStackView!
    //voucher
    @IBOutlet weak var voucherView: UIView!
    @IBOutlet weak var freeTrailRemainingLabel: UILabel!
    @IBOutlet weak var imgVwVoucher: UIImageView!
    @IBOutlet weak var lblVoucherMessage: UILabel!
    //voucher expiry
    @IBOutlet weak var voucherExpiryView: UIView!
    @IBOutlet weak var lblVoucherExpiry: UILabel!
    @IBOutlet weak var btnCloseVoucherExpiryView: UIButton!
    //active subscription
    @IBOutlet weak var activeSubscriptionView: UIView!
    //future subscription
    @IBOutlet weak var futureSubscriptionView: UIView!
    //Gift pop up
    @IBOutlet weak var giftReceivedPopUpView:
    UIView!
    
    @IBOutlet weak var giftCardPopUpLbl: UILabel!
    
    //Transport modes outlets
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var vehicleOpen185Width: NSLayoutConstraint!
    @IBOutlet weak var vehicleOptionButton: UIButton!
    //@IBOutlet weak var bicycleImageView: UIImageView!
    @IBOutlet weak var walkImageView: UIImageView!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    
    @IBOutlet weak var sosPlaceTblView: UITableView!
    @IBOutlet weak var sosPlaceTableViewHeight: NSLayoutConstraint!
    var showSOSTblView: Bool? = false
    
    
    @IBOutlet weak var sosBottomVW: UIView!
    @IBOutlet weak var sosBottomVwTitlelbl: UILabel!
    @IBOutlet weak var sosBottomVwContctInfolbl: UILabel!
    
    @IBOutlet weak var btnWolooSupport: UIButton!
    @IBOutlet weak var btnHospital: UIButton!
    @IBOutlet weak var btnPolice: UIButton!
    @IBOutlet weak var btnFire: UIButton!
    
    @IBOutlet weak var sosBottomVWHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var sosBottomCallView: UIView!
    
    var vehicleSelected: TransportMode? = .car
    //variables
    fileprivate var isMapExpand:Bool = true
    fileprivate let presentingHeight = UIScreen.main.bounds.height * 0.65
    fileprivate var isPresenting = false
    
    fileprivate var mapWolooStorePopUpVC: MapWolooStorePopUpVC?{
        
        if let childVC = self.children.first as? MapWolooStorePopUpVC {
            childVC.nearByStoreResponseDO = nearByStoreResponseDO
            childVC.delegate = self
            childVC.transportMode = transPortMode
            return childVC
        }
        return nil
    }
    
     var mapWolooStorePopUpVC2: MapWolooStorePopUpVC? {
        
        if let childVC = self.children.first as? MapWolooStorePopUpVC{
            
            childVC.nearByStoreResponseDoV2 = nearByStoreResponseDOV2
            childVC.delegate = self
            childVC.transportMode = transportMode
            return childVC
        }
        return nil
    }
    
    //NearBy store response is the model which is used to store the data from nearByWoloo observer
    fileprivate var nearByStoreResponseDO:NearByStoreResponse?
    
    var allStoresListv2 = [NearbyResultsModel]()
    var allWolooList = [NearbyResultsModel]()
    var nearByStoreResponseDOV2: [NearbyResultsModel]? = nil
    
    var refreshControl = UIRefreshControl()
    var pageCount = 1
    var transPortMode = TransportMode.car
    var allStoresList = [WolooStore]()
    
    var allNearByWolooList = [NearbyResultsModel]()
    
    var timeFor60Sec: Timer?
    var remainingTimeForExpand = 60
    // var isDataExistInAPI = true
    var showNoWoloo = false
    
    
    var obj = WahCertificate()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        searchTblView.isHidden = true
        Smartech.sharedInstance().trackEvent("page_load_event", andPayload: ["screen_name":"Homepage"])
        
        self.nearbyWolooLbl.text = "Woloo-Hosts near you"
        
        // tableView.isHidden = true
        searchTblView.delegate = self
        searchTblView.dataSource = self
        
        self.searchWolooView.layer.cornerRadius = 10

        NotificationCenter.default.addObserver(self, selector: #selector(pauseTime), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getAllNotificationCall(_:)), name: Notification.Name.deepLinking, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getDirectionNotificationCall(_:)), name: Notification.Name.destinationReached, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        
        configureUI()
        //fetcUserProfile()
        //        self.fetchUserProfileV2()
        //MARK: Calling nearbyWoloo API
        
        self.appConfigGet.appConfigGet()
        
        if let currentLocation = DELEGATE.locationManager.location {
            newMapContainerView.currentPosition = CLLocationCoordinate2D(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829)
        }
        
        newMapContainerView.delegate = self
        newMapContainerView.configureUI()
        newMapContainerView.animate(toZoom: 14)
        newMapContainerView.isMyLocationEnabled = true
        //        newMapContainerView.settings.myLocationButton = true
        //        newMapContainerView.settings.compassButton = true
        newMapContainerView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        print("Value to load custom marker: \(allStoresListv2)")
        
    }
    
    
    
    @IBAction func dashedButtonPressed(_ sender: UIButton) {
        
        print("Expand and collapse tableView")
        
        if collapseflag == false{
            if let currentLocation = DELEGATE.locationManager.location {
                var param = [String:Any]()
                param["location"] = "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))"
                
                Global.addNetcoreEvent(eventname: netCoreEvents.hostNearYouClick, param: param)
            }
            self.nearbyListTblViewHeight.constant = (view.window?.fs_height ?? 0) * 0.4
            self.nearbyWolooLbl.text = "Click here"
            collapseflag = true
        }else{
            self.nearbyListTblViewHeight.constant = 0
            self.nearbyWolooLbl.text = "Woloo-Hosts near you"
            collapseflag = false
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Status*",status.rawValue)
        let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
        self.newMapContainerView.camera = camera
        //        let camera = GMSCameraPosition(latitude: self.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: self.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
        //        self.newMapContainerView.camera = camera
        //self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0)
        
        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker location - \(marker.title ?? ""): <\(marker.position.latitude), \(marker.position.longitude)>")
        //delegate?.didTapMarker(marker)
        didTapMarker(marker)
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        
        
        // tableView.isHidden = true
        
        showNoWoloo = false
        
        setuserInfo()
        if UserDefaults.userTransportMode == nil {
            UserDefaults.userTransportMode = transPortMode
        } else {
            transPortMode = UserDefaults.userTransportMode ?? .car
        }
        // tableView.reloadData()
        self.nearByListTblView.reloadData()
        
        
        
        let overlayShown = UserDefaults.standard.value(forKey:"overlay_shown") as? Int
        DispatchQueue.main.async {
            if UIDevice.current.userInterfaceIdiom == .phone {
                if overlayShown == 1 {
                    self.overlayView.isHidden = true
                } else {
                    self.overlayView.isHidden = false
                }
            }
        }
        
        print("Screen opened")
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timeFor60Sec?.invalidate()
        print("viewWillDisappear")
        //dismissContainerView()
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //        self.searchedLat = 0
        //        self.searchedlong = 0
        
        self.objDashboardViewModel.delegate = self
        self.searchByLocationTxtField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: false)
        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
        //voucherAPIV2(voucher: "Fzz7F", forceApply: false)
        print("Retrieved voucher code: \(UserDefaultsManager.fetchVoucherCode())")
        
        print("Retrieved wah code: \(UserDefaultsManager.fetchWahCode())")
        //selectedPlace = nil
        locationManager.delegate = self
        DELEGATE.rootVC?.tabBarVc?.showTabBar()
        //self.fetcUserProfile()
        DispatchQueue.main.async {
            self.getUserProfileAPICall()
        }
        
        //self.fetchUserProfileV2()
        self.pageCount = 1
        self.nearByStoreResponseDO = nil
        // self.allStoresList.removeAll()
        //self.isDataExistInAPI = true
        self.reloadWhenExpandAndCollapse()
        // handleLocationPermission()
        bookmarkBtn.isSelected = false
        
        if searchedLat != nil && searchedlong != nil{
            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
            self.newMapContainerView.camera = camera
            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
            
            if selectedWolooGlobal != nil && likeStatusGlobal != -1 {
                
                self.allStoresListv2[self.allStoresListv2.firstIndex(where: { $0.id == selectedWolooGlobal?.id}) ?? -1].is_liked = likeStatusGlobal
                
                if bookmarkBtn.isSelected{
                    print("Woloo ist to be filtered\(allStoresListv2)")
                    let resultArray = allStoresListv2.filter{ $0.is_liked == 1 }
                    allStoresListv2.removeAll()
                    nearByStoreResponseDOV2?.removeAll()
                    allStoresListv2.append(contentsOf: resultArray)
                    nearByStoreResponseDOV2?.append(contentsOf: resultArray)
                    self.newMapContainerView.nearByStoreResponseDOV2 = resultArray
                    self.newMapContainerView.addAllMarkersV2()
                    print("bookmarked woloos: \(allStoresListv2)")
                    self.nearByListTblView.reloadData()
                    
                }
                if !bookmarkBtn.isSelected{
                    allStoresListv2.removeAll()
                    nearByStoreResponseDOV2?.removeAll()
                    allStoresListv2.append(contentsOf: allWolooList)
                    nearByStoreResponseDOV2?.append(contentsOf: allWolooList)
                    self.newMapContainerView.nearByStoreResponseDOV2 = allWolooList
                    self.newMapContainerView.addAllMarkersV2()
                    self.nearByListTblView.reloadData()
                }
                
                selectedWolooGlobal = nil
                likeStatusGlobal = -1
            }
            
        }else {
            print("load current location")
            handleLocationPermission()
        }
        
        
        if isPresenting {
            DELEGATE.rootVC?.tabBarVc?.hideTabBar()
        }
        
        print("Current lat and long on dashboard page Lat:  \(locationManager.location?.coordinate.latitude) Long: \(locationManager.location?.coordinate.longitude)")
     
        let coordinate = CLLocationCoordinate2D(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829)
        self.wolooSupport = Place(name: "Woloo", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")
        self.wolooSupport?.phone = "02249741750"
        self.isSOSOptionSelected = "Woloo"
        self.sosBottomVWHeight.constant = 0
        self.sosBottomCallView.isHidden = true
        self.fetchNearbyPlaces(coordinate: coordinate)
    }
    
    override func viewDidLayoutSubviews() {
        containerView.roundCorners(corners: [.topLeft,.topRight], radius: 16.0)
    }
    
    fileprivate func registerCells() {
      
        sosPlaceTblView.register(NearestPlaceTblVWCell.nib, forCellReuseIdentifier: NearestPlaceTblVWCell.identifier)
        
        sosPlaceTblView.register(DismissBtnCell.nib, forCellReuseIdentifier: DismissBtnCell.identifier)
        
        nearByListTblView.register(DashboardDirectionCell.nib, forCellReuseIdentifier: DashboardDirectionCell.identifier)
        
        nearByListTblView.register(NoWolooDashboardCell.nib, forCellReuseIdentifier: NoWolooDashboardCell.identifier)
        
        nearByListTblView.register(ShowMoreButtonCell.nib, forCellReuseIdentifier: ShowMoreButtonCell.identifier)
        
        
    }
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
    
    }
    
    func configureUI()  {
        
        searchByLocationTxtField.delegate = self
        searchByLocationTxtField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        
        self.currentLocationbtn.layer.cornerRadius = 5
        self.sosCallBtn.layer.cornerRadius = 5
        self.optionView.layer.cornerRadius = 25
        self.optionView.clipsToBounds = true
        self.registerCells()
        //  self.tableView.reloadData()
        self.nearByListTblView.reloadData()
        DispatchQueue.main.async {
            self.containerHeightConstraint.constant = 0
         
            self.navigationController?.navigationBar.isHidden = true
            self.refreshControl.tintColor = UIColor.white
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
            if #available(iOS 10.0, *) {
                //self.tableView.refreshControl = self.refreshControl
            } else {
                //self.tableView.addSubview(self.refreshControl)
            }
            self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        }
    }
    
    @objc func textDidChanged(_ textField: UITextField) {
        self.searchPlaces(text: textField.text ?? "")
        // clearButton.isHidden = (textField.text ?? "").isEmpty
        //storeReponse = nil
        if textField.text?.count == 0 {
            print("Hide the table view")
            searchTblView.isHidden = true
            searchTblView.reloadData()
        }
        //clearBtn.isHidden = (textField.text ?? "").isEmpty
        searchTblView.isHidden = false
        searchTblView.reloadData()
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
            self.searchTblView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.details,let wolooStore = sender as? NearbyResultsModel,let controller = segue.destination as? DetailsVC {
            controller.wolooStoreDOV2 = wolooStore
            controller.tranportMode = transPortMode
        } else if segue.identifier == Segues.searchLocation {
            let controller = segue.destination as? SearchLocationViewController
            controller?.transportMode = transPortMode
        }
    }
    //MARK: - Button action methods
    
    @objc
    func clickeDismissBtn() {
        self.sosPlaceTableViewHeight.constant = 0
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
        //        showToast(message: "fghjfk fgfgf fgjfgj fthfghf gf ghfghfghfghf\n bdhjfhgf ghdgfhjdghfjghghjk ghjfghj ghj")
        //self.performSegue(withIdentifier: Segues.searchLocation, sender: nil)
        
        let vc = (UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnrouteVC") as? EnrouteVC)!
        dashboardScreenTag = 1
        vc.isDirection = false
        vc.enrouteTag = true
        self.navigationController?.pushViewController(vc, animated: true)
        //self.performSegue(withIdentifier: Segues.enrouteVC, sender: nil)
    }
    @IBAction func scanAction(_ sender: Any) {
        //        Toast.shared.show(message: "fghjfk fgfgf fgjfgj fthfghf gf ghfghfghfghf\n bdhjfhgf ghdgfhjdghfjghghjk ghjfghj ghj")
        
        self.performSegue(withIdentifier: Segues.qRCodeScan, sender: nil)
    }
    
    @IBAction func hideOverlay(_ sender: Any) {
        DispatchQueue.main.async {
            self.overlayView.isHidden = true
        }
        UserDefaults.standard.set(1, forKey:"overlay_shown")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - @Objc Action's
    @objc func searchButtonAction() {
        //self.performSegue(withIdentifier: Segues.searchLocation, sender: nil)
        
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchWolooVC") as? SearchWolooVC
        
        if self.selectedPlace?.coordinate.latitude ?? 0 == 0 && self.selectedPlace?.coordinate.longitude ?? 0 == 0{
            
            vc?.lat = DELEGATE.locationManager.location?.coordinate.latitude
            vc?.long = DELEGATE.locationManager.location?.coordinate.longitude
            vc?.searchedPlace = selectedPlace?.name ?? ""
            print("Selected place name: \(selectedPlace?.name ?? "")")
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            vc?.lat = self.searchedLat
            vc?.long = self.searchedlong
            vc?.searchedPlace = selectedPlace?.name ?? ""
            print("Selected place name: \(selectedPlace?.name ?? "")")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        //self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func scanButtonAction() {
        self.performSegue(withIdentifier: Segues.qRCodeScan, sender: nil)
    }
    
    //    @IBAction func giftCardOkAction(_ sender: UIButton) {
    //
    //        //Close gift card received pop up
    //        giftCardReceivedView.isHidden = true
    //    }
    
    @IBAction func clickedBtnWolooSupport(_ sender: Any) {
        print("call woloo support")
        self.isSOSOptionSelected = "Woloo"
        self.sosBottomVwTitlelbl.text = wolooSupport?.name ?? ""
        self.sosBottomVwContctInfolbl.text = wolooSupport?.phone ?? ""
    }
    
    
    @IBAction func clickedBtnHospital(_ sender: UIButton) {
        print("call hospital services")
        self.isSOSOptionSelected = "Hospital"
        self.sosBottomVwTitlelbl.text = nearestHospital?.name ?? ""
        self.sosBottomVwContctInfolbl.text = nearestHospital?.phone ?? ""
    }
    
    
    @IBAction func clickedBtnPolice(_ sender: Any) {
        print("call police services")
        self.isSOSOptionSelected = "Police"
        self.sosBottomVwTitlelbl.text = nearestPoliceStation?.name ?? ""
        self.sosBottomVwContctInfolbl.text = nearestPoliceStation?.phone ?? ""
    }
    
    
    
    @IBAction func clickedBtnFire(_ sender: UIButton) {
        print("call fire services")
        self.isSOSOptionSelected = "Fire"
        self.sosBottomVwTitlelbl.text = nearestFireStation?.name ?? ""
        self.sosBottomVwContctInfolbl.text = nearestFireStation?.phone ?? ""
    }
    
    
    @IBAction func clickedCallBtn(_ sender: UIButton) {
    
        if self.isSOSOptionSelected == "Woloo"{
            self.callNumber(phoneNumber: self.wolooSupport?.phone ?? "")
            
        }else if self.isSOSOptionSelected == "Hospital"{
            self.callNumber(phoneNumber: nearestHospital?.phone ?? "102")
        }
        else if self.isSOSOptionSelected == "Police"{
            self.callNumber(phoneNumber: nearestPoliceStation?.phone ?? "100")
            
        }
        else if self.isSOSOptionSelected == "Fire"{
            self.callNumber(phoneNumber: nearestFireStation?.phone ?? "101")
        }
        
    }
    
    
    @IBAction func voucherOkAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.voucherView.isHidden = true
        }
    }
    @IBAction func voucherRenewAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.voucherExpiryView.isHidden = true
        }
        let vc = UIStoryboard.init(name: "Subscription", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuySubscriptionVC") as? BuySubscriptionVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func closeVoucherExpiryAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.voucherExpiryView.isHidden = true
        }
        //check while coming on dashboard, if the subscripton has expired, show popup
    }
    @IBAction func activeSubscrtiptionOkayAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.activeSubscriptionView.isHidden = true
        }
        //if let voucherCode = UserDefaults.voucherCode {
        // print("voucherCode: \(voucherCode)")
        //voucherAPI(code: voucherCode)
        
        self.subscription_tag = 1
        voucherAPIV2(voucher: UserDefaultsManager.fetchVoucherCode() ?? "", forceApply: true)
        //  }
    }
    @IBAction func activeSubscrtiptionCancelAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.activeSubscriptionView.isHidden = true
        }
    }
    @IBAction func futureSubscritptionCloseAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.futureSubscriptionView.isHidden = true
        }
    }
    
    
    @IBAction func giftPopUpCloseAction(_ sender: UIButton) {
        
        self.giftReceivedPopUpView.isHidden = true
    }
    
    //map Dashboard animation action methods:
    
    @IBAction func optionSelectAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.vehicleOpen185Width.constant = self.vehicleOpen185Width.constant == 185 ? 0 : 185
            //self.layoutIfNeeded()
        } completion: {_ in }
        
        if let button = sender as? UIButton, button.tag >= 0 && button.tag <= 2 {
            
            fillButton(mode: TransportMode.init(rawValue: button.tag) ?? .car)
            delegate?.selectedModeforTransport(mode: TransportMode.init(rawValue: button.tag) ?? .car)
        }
    }
    
    @IBAction func openNowBtnPressed(_ sender: UIButton) {
        
        openNowBtn.isSelected = !openNowBtn.isSelected
        //        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
        if openNowBtn.isSelected{
            
            if let openLocation = selectedPlace {
                // self.shouldFetchData = true
                self.selectedPlace = openLocation
                let currentLatitude = String(openLocation.coordinate.latitude)
                print(currentLatitude)
                let currentLongitude = String(openLocation.coordinate.longitude)
                print(currentLongitude)
                //  self.storeReponse = nil
                self.allStoresListv2.removeAll()
                
                //                self.searchNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 1 : 0)
                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                //self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 1 : 0, isSearch: 0)
                self.nearByListTblView.reloadData()
                print("Open Now button is selected")
                
            }
            else{
                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
            }
            
        }
        
        if !openNowBtn.isSelected{
            //            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
            if let openLocation = selectedPlace {
                // self.shouldFetchData = true
                self.selectedPlace = openLocation
                let currentLatitude = String(openLocation.coordinate.latitude)
                print(currentLatitude)
                let currentLongitude = String(openLocation.coordinate.longitude)
                print(currentLongitude)
                //self.storeReponse = nil
                self.allStoresListv2.removeAll()
                
                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                //self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latiude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 1 : 0, isSearch: 0)
                self.nearByListTblView.reloadData()
                print("Open Now button is not selected")
            }else{
                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                
            }
            
            
        }
    }
    
    @IBAction func wolooWithOfferBtnPressed(_ sender: UIButton) {
        
        self.wolooWithOfferBtn.isSelected = !wolooWithOfferBtn.isSelected
        
        if wolooWithOfferBtn.isSelected{
            
            if let openLocation = selectedPlace {
                self.selectedPlace = openLocation
                let currentLatitude = String(openLocation.coordinate.latitude)
                print(currentLatitude)
                let currentLongitude = String(openLocation.coordinate.longitude)
                print(currentLongitude)
                self.allStoresListv2.removeAll()
                // self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
            }else {
                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
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
                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
            }else {
                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
            }
            
            // self.getNearByStoresV2(lat: locationManager.location?.coordinate.latitude ?? 19.055229, lng: locationManager.location?.coordinate.longitude ?? 19.055229, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
        }
        
        
    }
    
    
    @IBAction func bookmarkBtnPressed(_ sender: UIButton) {
        
        self.bookmarkBtn.isSelected = !bookmarkBtn.isSelected
        
        if bookmarkBtn.isSelected{
            
            let resultArray = allStoresListv2.filter{ $0.is_liked == 1 }
            allStoresListv2.removeAll()
            nearByStoreResponseDOV2?.removeAll()
            allStoresListv2.append(contentsOf: resultArray)
            nearByStoreResponseDOV2?.append(contentsOf: resultArray)
            self.newMapContainerView.nearByStoreResponseDOV2 = resultArray
            self.newMapContainerView.addAllMarkersV2()
            print("bookmarked woloos: \(allStoresListv2)")
            self.nearByListTblView.reloadData()
            
        }
        
        if !bookmarkBtn.isSelected{
            allStoresListv2.removeAll()
            nearByStoreResponseDOV2?.removeAll()
            allStoresListv2.append(contentsOf: allWolooList)
            nearByStoreResponseDOV2?.append(contentsOf: allWolooList)
            self.newMapContainerView.nearByStoreResponseDOV2 = allWolooList
            self.newMapContainerView.addAllMarkersV2()
            self.nearByListTblView.reloadData()
            
        }
        
    }
    
    
    @IBAction func currentLocationBtnPressed(_ sender: UIButton) {
        print("Navigate to user's current location")
        
        searchByLocationTxtField.text = ""
        //clearBtn.isHidden = true
        searchList?.removeAll()
        searchTblView.reloadData()
        selectedPlace = nil
        searchedlong = nil
        searchedLat = nil
        
        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
        
        let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
        self.newMapContainerView.camera = camera
        
    }
    
    
    @IBAction func clickedSOSCallBtn(_ sender: UIButton) {
        self.sosBottomVWHeight.constant = 254
       self.sosBottomCallView.isHidden = false
//        self.showSOSTblView = true
//        self.sosPlaceTableViewHeight.constant = (view.window?.fs_height ?? 0) * 0.6
    }
    
    
    
    
    // Function to call emergency services
    func callEmergencyService(serviceName: String) {
        var phoneNumber: String
        
        // Map the service name to the corresponding emergency number
        switch serviceName.lowercased() {
        case "police":
            phoneNumber = "100"
            
        case "Woloo Support":
            phoneNumber = "1234567890"
        case "hospital":
            phoneNumber = "102"
        case "fire":
            phoneNumber = "101"
        default:
            print("Service not available")
            return
        }
        
        // Call the provided number
        callNumber(phoneNumber: phoneNumber)
       
        
    }
    
    // Fetch one place for each type: hospital, police, and fire_station
        func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
            let placeTypes = ["hospital", "police", "fire_station"]
            var places: [String: Place] = [:]

            let group = DispatchGroup() // To manage multiple network requests

            for placeType in placeTypes {
                group.enter()
                let nearbySearchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
                let url = "\(nearbySearchURL)?location=\(coordinate.latitude),\(coordinate.longitude)&radius=5000&type=\(placeType)&key=\(Constant.ApiKey.googleMap)"

                let request = URLRequest(url: URL(string: url)!)

                URLSession.shared.dataTask(with: request) { data, response, error in
                    defer { group.leave() }
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }

                    guard let data = data else {
                        print("No data")
                        return
                    }

                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let results = json["results"] as? [[String: Any]],
                           let firstResult = results.first {  // Get the first nearby place
                            
                            if let name = firstResult["name"] as? String,
                               let placeId = firstResult["place_id"] as? String,
                               let address = firstResult["vicinity"] as? String {
                                
                                // Store the closest place in the places dictionary
                                let place = Place(name: name, address: address, phone: nil, photoReference: nil, placeId: placeId)
                                places[placeType] = place
                            }
                        }
                    } catch let error {
                        print("Failed to decode JSON: \(error)")
                    }
                }.resume()
            }

            // Once all requests finish, fetch details for each place
            group.notify(queue: .main) {
                if let hospital = places["hospital"] {
                    self.nearestHospital = hospital
                    self.fetchPlaceDetails(placeId: hospital.placeId, type: "hospital")
                }
                if let police = places["police"] {
                    self.nearestPoliceStation = police
                    self.fetchPlaceDetails(placeId: police.placeId, type: "police")
                }
                if let fireStation = places["fire_station"] {
                    self.nearestFireStation = fireStation
                    self.fetchPlaceDetails(placeId: fireStation.placeId, type: "fire_station")
                }
            }
        }
    
    // Fetch detailed place info (address, phone, photos) using Place ID
        func fetchPlaceDetails(placeId: String, type: String) {
            let placeDetailsURL = "https://maps.googleapis.com/maps/api/place/details/json"
            let url = "\(placeDetailsURL)?place_id=\(placeId)&fields=name,formatted_address,formatted_phone_number,photos&key=\(Constant.ApiKey.googleMap)"

            let request = URLRequest(url: URL(string: url)!)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error fetching place details: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let result = json["result"] as? [String: Any] {
                        
                        let name = result["name"] as? String ?? "No name available"
                        let address = result["formatted_address"] as? String ?? "No address available"
                        let phone = result["formatted_phone_number"] as? String ?? "No phone available"
                        
                        var photoReference: String? = nil
                        if let photos = result["photos"] as? [[String: Any]], let firstPhoto = photos.first {
                            photoReference = firstPhoto["photo_reference"] as? String
                        }

                        let updatedPlace = Place(name: name, address: address, phone: phone, photoReference: photoReference, placeId: placeId)

                        // Update the corresponding type (hospital, police, fire_station) with details
                        DispatchQueue.main.async {
                            switch type {
                            case "hospital":
                                self.nearestHospital = updatedPlace
                                self.displayPlaceDetails(updatedPlace, type: "Hospital")
                            case "police":
                                self.nearestPoliceStation = updatedPlace
                                self.displayPlaceDetails(updatedPlace, type: "Police Station")
                            case "fire_station":
                                self.nearestFireStation = updatedPlace
                                self.displayPlaceDetails(updatedPlace, type: "Fire Station")
                            default:
                                break
                            }
                        }

                    }
                } catch let error {
                    print("Failed to decode JSON: \(error)")
                }
            }.resume()
        }
    
    // Function to display the details in your app
        func displayPlaceDetails(_ place: Place, type: String) {
            print("\(type) Details:")
            print("Name: \(place.name)")
            print("Address: \(place.address)")
            print("Phone: \(place.phone ?? "No phone available")")

            
        }
    
    // Function to initiate a phone call
    func callNumber(phoneNumber: String) {
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL)
                }
            }
        }
    }
    
    
    
    @IBAction func clearBtnAction(_ sender: UIButton) {
        
        searchTblView.isHidden = true
        // clearBtn.isHidden = true
        searchByLocationTxtField.text = ""
        searchList?.removeAll()
        searchTblView.reloadData()
        
    }
    
    
    
    func fillButton(mode: TransportMode) { // Change images for selected mode.
        self.vehicleOptionButton.setImage( mode.fillImage, for: .normal)
        self.carImageView.image = mode == .car ? mode.fillImage: TransportMode.car.unfillImage
        self.walkImageView.image = mode == .walking ? mode.fillImage: TransportMode.walking.unfillImage
        //self.bicycleImageView.image = mode == .bicycle ? mode.fillImage: TransportMode.bicycle.unfillImage
    }
    
    @objc func refresh(_ sender: AnyObject) {
        // self.isDataExistInAPI = true
        self.pageCount = 1
        self.nearByStoreResponseDO = nil
        self.allNearByWolooList.removeAll()
        // self.tableView.reloadData()
        self.nearByListTblView.reloadData()
        //getNearByStores()
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
    
    @objc func pauseTime() {
        self.remainingTimeForExpand = 60
        self.timeFor60Sec?.invalidate()
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
            print("mapcontainer view shown")
            self?.mapWolooStorePopUpVC?.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            
        }, completion: {  [weak self] (finished) in
            guard let weakSelf = self else { return }
            weakSelf.isPresenting = true
            weakSelf.mapWolooStorePopUpVC2?.view.transform = .identity
            //weakSelf.mapWolooStorePopUpVC?.view.transform = .identity
        })
        
    }
    
    func dismissContainerView() {
        UIView.animate(withDuration: 0.4, delay: 0, animations: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.timeForExpandAndCollapse()
            weakSelf.containerHeightConstraint.constant = 0
            weakSelf.containerView.frame.origin.y = UIScreen.main.bounds.height
            weakSelf.view.layoutIfNeeded()
            DELEGATE.rootVC?.tabBarVc?.showTabBar()
        }, completion: { [weak self] (finished) in
            guard let weakSelf = self else { return }
            weakSelf.isPresenting = false
            weakSelf.mapWolooStorePopUpVC2?.view.transform = .identity
            //weakSelf.mapWolooStorePopUpVC?.view.transform = .identity
        })
    }
    
    private func reloadWhenExpandAndCollapse() {
        print("Nearbywoloo model count: \(self.allNearByWolooList.count)")
        if self.self.allNearByWolooList.count > 0 {
            //            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            //            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        } else {
            // self.tableView.reloadData()
            self.nearByListTblView.reloadData()
        }
    }
 
    
    fileprivate func fetchUserProfileV2(){
        
        UserProfileModel.fetchUserProfileV2 { (userInfo) in
            self.setUerInfoV2()
        }
    }
    
    func setUerInfoV2(){
        
        let userInfo = UserDefaultsManager.fetchUserData()
        DispatchQueue.main.async {
            print("UserName: \(userInfo?.profile?.name ?? "")")
            var name = userInfo?.profile?.name ?? ""
            if name.contains(" ") {
                let result = name.split(separator: " ")
                if result.count > 0 {
                    name = String(result[0])
                }
            }
            
            self.lblName.text = userInfo?.profile?.name ?? "Guest"
            if let avtar = userInfo?.profile?.avatar, avtar.count > 0 {
                let url = "\(userInfo?.profile?.baseUrl ?? "")\(avtar)"
                self.imgProfile.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "user_default"))
            } else {
                self.imgProfile.sd_setImage(with: URL(string: kUserPlaceholderURL), completed: nil)
            }
            //                UserModel.saveAuthorizedUserInfo(userInfo?.userData)
            
            //check if user has active subscription
            
            if let expiryDatestr = userInfo?.profile?.expiry_date {
                // Parse the expiry date string (assuming it's in UTC)
                let expiryDate = expiryDatestr.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                print("Expiry Date: \(String(describing: expiryDate))")
                
                // Remove the time component from both dates (expiry date and current date)
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date()) // Start of the current day
                let expiryDay = calendar.startOfDay(for: expiryDate ?? Date()) // Start of the expiry date
                
                // Calculate the number of days between today and the expiry date
                let days = calendar.dateComponents([.day], from: today, to: expiryDay).day ?? 0
                
                print("Number of days: \(days)")
                
                if days <= 7 && days > 0 && userInfo?.profile?.isFutureSubcriptionExist == false && userInfo?.profile?.voucher_id != nil {
                    // 7 days remaining to expire
                    self.voucherExpiryView.isHidden = false
                    self.btnCloseVoucherExpiryView.isHidden = false
                } else if days < 0 { // Expired
                    self.lblVoucherExpiry.text = "Oops! Membership/Voucher has expired"
                    self.voucherExpiryView.isHidden = false
                    self.btnCloseVoucherExpiryView.isHidden = true
                }
            }
        }
        
    }
    
    fileprivate func fetcUserProfile() {
        UserModel.apiMoreProfileDetails { (userInfo) in
            self.setuserInfo()
        }
    }
    
    
    func getUserProfileAPICall(){
        self.objDashboardViewModel.getUserProfileAPI()
    }
    
    func setuserInfo() {
        let userInfo = UserModel.getAuthorizedUserInfo()
      
    }
    func handleLocationPermission(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted:
            
            DELEGATE.locationManager.requestAlwaysAuthorization()
            DELEGATE.locationManager.requestWhenInUseAuthorization()
            DELEGATE.locationManager.delegate = self
            DELEGATE.didChangeLocationAuthorizationStatus = { [self] (status) in
                
                if status == .authorizedAlways || status == .authorizedWhenInUse {
                    if self.dashboardScreenTag == 1{
              
                    }
                    else {
                        
                        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        
                        let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
                        self.newMapContainerView.camera = camera
                        
                        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                        
                        print("authorized always")
                       
                    }
                }
            }
        case .authorizedAlways, .authorizedWhenInUse:
            //getNearByStores()
            print("authorized always")
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if self.dashboardScreenTag == 1{
   
            }
            else {
                let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
                self.newMapContainerView.camera = camera
                
                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
            }
            //locationManager.allowsBackgroundLocationUpdates = true
        case .denied:
            
            print("User has denied the map permissions settings")
            if self.dashboardScreenTag == 1{
                
            }
            else {
                let camera = GMSCameraPosition(latitude: 19.055229, longitude: 72.830829, zoom: 14)
                self.newMapContainerView.camera = camera
                
                self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
                
            }
            DispatchQueue.main.async {
                let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Retry", title: nil, message: "There was an issue in fetching your location. Please enable location from Settings", image: nil, controller: self)
                alert.cancelTappedAction = {
                    
                    print("open Settings")
                    
                    alert.removeFromSuperview()
                    //                    self.getNearByStores()
                }
                self.view.addSubview(alert)
                self.view.bringSubviewToFront(alert)
            }
        @unknown default:
            print("LocationService: unknown default state")
            let camera = GMSCameraPosition(latitude: 19.055229, longitude: 72.830829, zoom: 14)
            self.newMapContainerView.camera = camera
            let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "OK", title: nil, message: "There was an issue in fetching your location. Please enable location from Settings or Upgrade to latest iOS version", image: nil, controller: self)
            alert.cancelTappedAction = {
                
                alert.removeFromSuperview()
            }
            self.view.addSubview(alert)
            self.view.bringSubviewToFront(alert)
            break
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager = manager
        if let location = locations.last {
            print("Lat didUpdateLocations :--->> \(location.coordinate.latitude) \n -->>Lng didUpdateLocations: \(location.coordinate.longitude)")
        }
    }
    
    func showNoDirectionAlert() {
        DispatchQueue.main.async {
            let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Close", title: "", message: "No route found for this transport mode. Please change mode and try again.", image: nil, controller: self)
            alert.cancelTappedAction = {
                alert.removeFromSuperview()
            }
            self.view.addSubview(alert)
            self.view.bringSubviewToFront(alert)
        }
    }
}

// MARK: - Notification Handling
extension DashboardVC {
    @objc func getAllNotificationCall(_ notification: Notification) {
       
        if notification.name.rawValue == Notification.Name.deepLinking.rawValue, let dict = notification.userInfo as? [String: Any] {
            if let voucher = dict["voucher"] as? String {
                
                //Voucher code implementation
                self.voucherAPIV2(voucher: UserDefaultsManager.fetchVoucherCode(), forceApply: false)
                return
                
            } else if let certificateCode = dict["wahcertificate"] as? String {
                self.wahCertificateAPICall()
                return
            }
            
            else if let giftCode = dict["giftId"] as? String {
                
                print("gift id from dashboard = \(giftCode)")
                
                self.userGiftPopUp(id: giftCode)
                return
                
            }
            else if let shop = dict["shop"] as? String {
                print("Open shop page from here \(shop)")
                let shopeSB = UIStoryboard(name: "Shop", bundle: nil)
                if let shopeVC = shopeSB.instantiateViewController(withIdentifier: "ECommerceDashboardViewController") as? ECommerceDashboardViewController {
                    self.navigationController?.pushViewController(shopeVC, animated: true)
                }
                return
            }
            else if let buySubscription = dict["buySubscription"] as? String{
                print("Open subscription page from here \(buySubscription)")
                let vc = UIStoryboard.init(name: "Subscription", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuySubscriptionVC") as? BuySubscriptionVC
                self.navigationController?.pushViewController(vc!, animated: true)
                
                return
            }
        }
    }
    
    @objc func getDirectionNotificationCall(_ notification: Notification) {
        
        var msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationPoints ?? "")"
        
        //self.mapDirectionPopUpView.isHidden = true
        if notification.name.rawValue == Notification.Name.destinationReached.rawValue, let dict = notification.userInfo as? [String: Any] {
            
            if let destinationReachedPoint = dict["destinationReached"] as? String {
                
                print("User reached destination enroutevc")
                
                
                
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "ADD REVIEW", title: "", message: msg, image: nil, controller: self)
                    alert.cancelTappedAction = {
                        alert.removeFromSuperview()
                        let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
                        
                        vc?.wolooStoreID2 = UserDefaultsManager.fetchWolooID()
                        //                        vc?.wolooStore = self.wolooStore
                        //
                        //                        vc?.wolooStoreID2 = self.storeId2
                        
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                    self.view.addSubview(alert)
                    self.view.bringSubviewToFront(alert)
                }
                UserDefaults.standard.removeObject(forKey: "store_Woloo_ID")
            }else if let destinationPointClaimed = dict["destinationPointClaimed"] as? String {
                
                print("points already claimed")
                msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")"
                DispatchQueue.main.async {
                    let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "OK", title: "", message: msg, image: nil, controller: self)
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
    
    @objc func loadMoreWoloo(sender: UIButton!) {
        
        dashboardScreenTag = 1
        
        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchWolooVC") as? SearchWolooVC
        //self.performSegue(withIdentifier: Segues.searchWolooVC, sender: nil)
        if searchedLat ?? 0 == 0 && self.searchedlong ?? 0 == 0{
            
            vc?.lat = DELEGATE.locationManager.location?.coordinate.latitude
            vc?.long = DELEGATE.locationManager.location?.coordinate.longitude
            //vc?.searchedPlace = selectedPlace?.name ?? ""
            print("Selected place name: \(selectedPlace?.name ?? "")")
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            vc?.lat = self.searchedLat ?? 0
            vc?.long = self.searchedlong ?? 0
            vc?.searchedPlace = selectedPlace?.name ?? ""
            print("Selected place name: \(selectedPlace?.name ?? "")")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
}




// MARK: - AnimationProtoCol

extension DashboardVC:AnimationProtocol {
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
        
        Global.addNetcoreEvent(eventname: netCoreEvents.travelModeClick, param: param)
        
        transPortMode = mode
        UserDefaults.userTransportMode = mode
        self.pageCount = 1
        //self.nearByStoreResponseDO = nil
        //self.isDataExistInAPI = true
        self.didTapDismissButton()
        self.timeForExpandAndCollapse()
        self.allStoresList.removeAll()
        
        print("Selected Transport Mode: \(mode)")
        //self.getNearByStores()
        
        if mode.name == "walking"{
            //self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 1, range: "2", is_offer: 0)
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
        }
        else{
            //self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0)
            
            
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
        }
        
    }
    
    //when tapped on marker available on screen
    func didTapMarker(_ marker: GMSMarker) {
        // if self.isMapExpand{
        guard let popUp = mapWolooStorePopUpVC2 else { return }
        
        if let currentLocation = DELEGATE.locationManager.location {
            
            Global.addNetcoreEvent(eventname: netCoreEvents.wolooMarkerClick, param:  ["location": "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))","travel_mode": "", "host_click_id": "\(popUp.wolooStoreV2?.id ?? 0)","host_click_location": "\(popUp.wolooStoreV2?.lat ?? ""), \(popUp.wolooStoreV2?.lng ?? "")"])
            
            //Global.addNetcoreEvent(eventname: netCoreEvents.hostNearYouClick, param: param)
        }
        print("marker point: \(marker.zIndex)")
        
        popUp.delegate = self
        popUp.transportMode = transPortMode
        //        popUp.collectionView.scrollToItem(at: IndexPath(item: Int(marker.zIndex), section: 0), at: .centeredHorizontally, animated: true)
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

// MARK: - SelectionProtocol
extension DashboardVC:SelectionProtocol{
    func didSelectStore(_ wolooStore: WolooStore) {
        //  performSegue(withIdentifier: Constant.Segue.details, sender: wolooStore)
    }
    
    func didSelectCategory() {
    }
}



// MARK: -  MapWolooStorePopUpVC Delegate
extension DashboardVC:MapWolooStorePopUpVCDelegate{
    func collctionViewDidScrollTo(_ position: Int) {
        //        guard let mapCell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? MapCell else { return }
        //guard let stores = nearByStoreResponseDO?.stores else { return }
        
        guard let popUp = mapWolooStorePopUpVC2 else { return }
        
        guard let storesV2 = nearByStoreResponseDOV2 else { return}
        print("go to position: \(position)")
        let store = storesV2[position]
        print("Store positions: \(store)")
        if let lattitue = store.lat,let lat = Double(lattitue),let longitude = store.lng,let long = Double(longitude){
            let markerLocation = CLLocationCoordinate2D(latitude:lat, longitude: long)
            newMapContainerView.animate(toLocation: markerLocation)
            //            mapCell.mapContainerView.animate(toLocation: markerLocation)
            
            
        }
    }
    
    func didSelectWolooStore(_ store: WolooStore) {
        return;
    }
    
    func didTapDismissButton() {
        dismissContainerView()
        //        mapWolooStorePopUpVC?.collectionView.scrollToItem(at: IndexPath(item: 3, section: 0), at: .centeredHorizontally, animated: true)
        
    }
}

// MARK: - Open other Controllers
extension DashboardVC {
      func openWahCerificateVC(store: WahCertificate) {
        let vc = WahCertificateVC(nibName: "WahCertificateVC", bundle: nil)
        //vc.store = store
        vc.objWahCertificate = store
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
