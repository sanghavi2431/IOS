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
import CoreLocation
import STPopup


protocol AnimationProtocol:class {
    //func didTapExpandContractButton(_ isExpand: Bool)
    func didTapMarker(_ marker: GMSMarker)
    //func selectedModeforTransport(mode: TransportMode)
}

var selectedWolooGlobal: NearbyResultsModel?
var likeStatusGlobal = -1

class DashboardVC: AbstractVC, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, DashboardBottomSheetDelegate{
    
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
    var indexOfItem = 0
    var customInfoView = CustomInfoView()
    var selectedMarker: GMSMarker?
    var debounceTimer: Timer?
    
    //Search text field
  //  @IBOutlet weak var searchTblView: UITableView!
    @IBOutlet weak var searchWolooView: UIView!
    @IBOutlet weak var searchByLocationTxtField: UITextField!
    @IBOutlet weak var currentLocationbtn: UIButton!
    
    @IBOutlet weak var sosCallBtn: UIButton!
    
    @IBOutlet weak var clearBtn: UIButton!
   // @IBOutlet weak var nearByListTblView: UITableView!
    
    @IBOutlet weak var trialStatusLbl: UILabel!
   // @IBOutlet weak var nearbyWolooLbl: UILabel!
    @IBOutlet weak var newMapContainerView: MapContainerView!
    weak var delegate:AnimationProtocol?
    
   // @IBOutlet weak var nearbyListTblViewHeight: NSLayoutConstraint!
    
    //@IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overlayView: UIView!
    //@IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var btnOpenEnroute: UIButton!
    
    //@IBOutlet weak var giftCardReceivedView: UIView!
    //@IBOutlet weak var giftCardReceivedLbl: UILabel!
    //@IBOutlet weak var giftCardOkBtn: UIButton!

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
   
    //@IBOutlet weak var bicycleImageView: UIImageView!
    
    
    @IBOutlet weak var sosBottomVW: UIView!
    @IBOutlet weak var sosBottomVwTitlelbl: UILabel!
    @IBOutlet weak var sosBottomVwContctInfolbl: UILabel!
    @IBOutlet weak var vwBackSOSBottomView: UIView!
    
    @IBOutlet weak var btnWolooSupport: UIButton!
    @IBOutlet weak var btnHospital: UIButton!
    @IBOutlet weak var btnPolice: UIButton!
    @IBOutlet weak var btnFire: UIButton!
    
   // @IBOutlet weak var sosBottomVWHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var sosBottomCallView: UIView!
    
    @IBOutlet weak var collectionViewNearbyCell: UICollectionView!
    
    
    @IBOutlet weak var stackVWBtn: UIStackView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    
    @IBOutlet weak var vwBackTransportMode: UIView!
    
    @IBOutlet weak var btnSelectedMode: UIButton!
    
    var isShowBtn: Bool = false
    
    var vehicleSelected: String? = ""
    //variables
    fileprivate var isMapExpand:Bool = true
    fileprivate let presentingHeight = UIScreen.main.bounds.height * 0.65
    fileprivate var isPresenting = false
    
//    fileprivate var mapWolooStorePopUpVC: MapWolooStorePopUpVC?{
//        
//        if let childVC = self.children.first as? MapWolooStorePopUpVC {
//            childVC.nearByStoreResponseDO = nearByStoreResponseDO
//            childVC.delegate = self
//            childVC.transportMode = transPortMode
//            return childVC
//        }
//        return nil
//    }
    
    
    
    //NearBy store response is the model which is used to store the data from nearByWoloo observer
    fileprivate var nearByStoreResponseDO:NearByStoreResponse?
    
    var allStoresListv2 = [NearbyResultsModel]()
    var allWolooList = [NearbyResultsModel]()
    fileprivate var nearByStoreResponseDOV2: [NearbyResultsModel]? = nil
    
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
        
        //print("API Token Recieved: ", UserDefaultsManager.fetchUserShopToken())
        self.vwBackTransportMode.layer.cornerRadius = 25
        self.vwBackTransportMode.isHidden = true
        self.vehicleSelected = TransportType.CAR.rawValue
        
        for family in UIFont.familyNames {
            print("Font Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print(" - \(name)")
            }
        }
        
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
       // searchTblView.isHidden = true
        Smartech.sharedInstance().trackEvent("page_load_event", andPayload: ["screen_name":"Homepage"])
        
        //self.nearbyWolooLbl.text = "Woloo-Hosts near you"
        
        // tableView.isHidden = true
//        searchTblView.delegate = self
//        searchTblView.dataSource = self
        
        self.collectionViewNearbyCell.delegate = self
        self.collectionViewNearbyCell.dataSource = self
        
        
            self.collectionViewNearbyCell.register(DashboardCollectionViewCell.nib, forCellWithReuseIdentifier: DashboardCollectionViewCell.identifier)
        
        self.collectionViewNearbyCell.register(ShowMoreCell.nib, forCellWithReuseIdentifier: ShowMoreCell.identifier)
           

        
        self.searchWolooView.layer.cornerRadius = 7.1
//         self.nearByWolooTblView.register(DashboardDirectionCell.nib, forCellReuseIdentifier: DashboardDirectionCell.identifier)
        // self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0)
        //tableView.isHidden = true
//        NotificationCenter.default.addObserver(self, selector: #selector(pauseTime), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getAllNotificationCall(_:)), name: Notification.Name.deepLinking, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getDirectionNotificationCall(_:)), name: Notification.Name.destinationReached, object: nil)
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(applicationWillEnterForeground(_:)),
//            name: UIApplication.willEnterForegroundNotification,
//            object: nil)
//        
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
        self.setupUI()
        
        if searchedLat != nil && searchedlong != nil{
            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
            self.newMapContainerView.camera = camera
            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
        }else {
            print("load current location")
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
            handleLocationPermission()
        }
    }
    
    func setupUI(){
        searchByLocationTxtField.font = UIFont(name: "CenturyGothic", size: 14)
    }
    

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Status*",status.rawValue)
        let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
        self.newMapContainerView.camera = camera
        //        let camera = GMSCameraPosition(latitude: self.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: self.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
        //        self.newMapContainerView.camera = camera
        //self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0)
        
        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker location - \(marker.title ?? ""): <\(marker.position.latitude), \(marker.position.longitude)>")
        //delegate?.didTapMarker(marker)
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
                let point = self.newMapContainerView.projection.point(for: selectedMarker.position)
                customInfoView.center = CGPoint(x: point.x, y: point.y - 90)
        }
    
    
    // Show custom info view
       func showCustomInfoView(for marker: GMSMarker) {
           // Remove any existing info view
           customInfoView.removeFromSuperview()
           
           let frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: 135, height: 80)
           customInfoView = UINib(nibName: "CustomInfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CustomInfoView ?? CustomInfoView()
           customInfoView.frame = frame
          // customInfoView.layer.cornerRadius = 15.0

           // Convert marker's position to screen coordinates
           let point = self.newMapContainerView.projection.point(for: marker.position)
           customInfoView.center = CGPoint(x: point.x, y: point.y - 60)

           customInfoView.lblWahScore.text = self.allStoresListv2[Int(marker.zIndex)].cibil_score ?? "0"
//           customInfoView.lblWolooName.text = marker.title
//           customInfoView.btnOpenMap.addTarget(self, action: #selector(didTappedONInfoMarkerLocation), for: .touchUpInside)
           // Add the custom info view to the map view
           newMapContainerView.addSubview(customInfoView)
           selectedMarker = marker
          // customInfoView = infoView as! CustomInfoView
       }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(applicationWillEnterForeground(_:)),
//            name: UIApplication.willEnterForegroundNotification,
//            object: nil)
        
        
        // tableView.isHidden = true
        
        showNoWoloo = false
        
    //    setuserInfo()
        if UserDefaults.userTransportMode == nil {
            UserDefaults.userTransportMode = transPortMode
        } else {
            transPortMode = UserDefaults.userTransportMode ?? .car
        }
        // tableView.reloadData()
      
        
        
        self.overlayView.isHidden = true
//        let overlayShown = UserDefaults.standard.value(forKey:"overlay_shown") as? Int
//        DispatchQueue.main.async {
//            if UIDevice.current.userInterfaceIdiom == .phone {
//                if overlayShown == 1 {
//                    self.overlayView.isHidden = true
//                } else {
//                    self.overlayView.isHidden = false
//                }
//            }
//        }
//        
        print("Screen opened")
    }
    //MARK: - Open map
    @objc
    func didTappedONInfoMarkerLocation(marker: GMSMarker){
        if let googleMapsURL = URL(string: "comgooglemaps://"),
           UIApplication.shared.canOpenURL(googleMapsURL) {
            if let currentLocation = DELEGATE.locationManager.location {
                
                
                let directionsURLString = "comgooglemaps://?saddr=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving"
                
                 
                 if let directionsURL = URL(string: directionsURLString) {
                     UIApplication.shared.open(directionsURL, options: [:]) { success in
                         if success {
                             print("Google Maps opened successfully.")
                         } else {
                             print("Failed to open Google Maps.")
                         }
                     }
                 }
             } else {
                 NSLog("Can't use comgooglemaps://")
             }
            }
    }
//
//    
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        timeFor60Sec?.invalidate()
//        print("viewWillDisappear")
//        //dismissContainerView()
//        
//        
//    }
    
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
       // DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
        //voucherAPIV2(voucher: "Fzz7F", forceApply: false)
        print("Retrieved voucher code: \(UserDefaultsManager.fetchVoucherCode())")
        
        print("Retrieved wah code: \(UserDefaultsManager.fetchWahCode())")
        //selectedPlace = nil
        locationManager.delegate = self
//        DELEGATE.rootVC?.tabBarVc?.showTabBar()
//        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
        //tabBarController?.tabBar.isHidden = false
        
        //self.fetcUserProfile()
        DispatchQueue.main.async {
            self.getUserProfileAPICall()
        }
        
        //self.fetchUserProfileV2()
        self.pageCount = 1
        self.nearByStoreResponseDO = nil
        // self.allStoresList.removeAll()
        //self.isDataExistInAPI = true
        //self.reloadWhenExpandAndCollapse()
        // handleLocationPermission()
    
        
//        if searchedLat != nil && searchedlong != nil{
//            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
//            self.newMapContainerView.camera = camera
//            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: 2, isSearch: 0)
//        }else {
//            print("load current location")
//            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: 2, isSearch: 0)
//            handleLocationPermission()
//        }
        print("Current lat and long on dashboard page Lat:  \(locationManager.location?.coordinate.latitude) Long: \(locationManager.location?.coordinate.longitude)")

        let coordinate = CLLocationCoordinate2D(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829)
        self.wolooSupport = Place(name: "Woloo", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")
        self.wolooSupport?.phone = "02249741750"
        self.isSOSOptionSelected = "Woloo"

        self.fetchNearbyPlaces(coordinate: coordinate)
    }
    
    override func viewDidLayoutSubviews() {
        //containerView.roundCorners(corners: [.topLeft,.topRight], radius: 16.0)
    }
    
    fileprivate func registerCells() {
        //                tableView.register(NearestStoreTableViewCell.nib, forCellReuseIdentifier: NearestStoreTableViewCell.identifier)
        //                tableView.register(ShopCategoryTableViewCell.nib, forCellReuseIdentifier: ShopCategoryTableViewCell.identifier)
        //                tableView.register(NewsTableViewCell.nib, forCellReuseIdentifier: NewsTableViewCell.identifier)
        //MARK: -------------------------------------------
        //        tableView.register(DashboardDirectionCell.nib, forCellReuseIdentifier: DashboardDirectionCell.identifier)
        //        tableView.register(NoWolooDashboardCell.nib, forCellReuseIdentifier: NoWolooDashboardCell.identifier)
        //        tableView.register(MapCell.nib, forCellReuseIdentifier: MapCell.identifier)
        
        
    
        
    }
//    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
//        /*self.pageCount = 1
//         self.nearByStoreResponseDO = nil
//         self.allStoresList.removeAll()
//         timeFor60Sec?.invalidate()
//         remainingTimeForExpand = 60
//         isDataExistInAPI = true
//         self.tableView.reloadData()*/
//        //handleLocationPermission()
//    }
    
    func configureUI()  {
        

        self.currentLocationbtn.layer.cornerRadius = 5
        self.sosCallBtn.layer.cornerRadius = 5
        self.registerCells()
        //  self.tableView.reloadData()
        DispatchQueue.main.async {
            //self.containerHeightConstraint.constant = 0
            
            /* let right = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_search"), style: .done, target: self, action: #selector(searchButtonAction))
             right.tintColor = .white
             
             let qrcode = UIBarButtonItem(image: #imageLiteral(resourceName: "qr-code"), style: .done, target: self, action: #selector(scanButtonAction))
             qrcode.tintColor = .white
             
             navigationItem.rightBarButtonItems = [qrcode, right] */
            self.navigationController?.navigationBar.isHidden = true
            self.refreshControl.tintColor = UIColor.white
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
//            if #available(iOS 10.0, *) {
//                //self.tableView.refreshControl = self.refreshControl
//            } else {
//                //self.tableView.addSubview(self.refreshControl)
//            }
//            self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutside(_:)))
        tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
    }
    
    // Function to handle tap gestures
    @objc func didTapOutside(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: vwBackSOSBottomView)
        
        // Check if the tap is outside the containerView
        if !vwBackSOSBottomView.frame.contains(tapLocation) {
            vwBackSOSBottomView.isHidden = true // Hide the containerView
            
        }
        
    }

    
    
//    func searchPlaces(text: String) {
//        
//        //noStoreView.isHidden = true
//        let filter = GMSAutocompleteFilter()
//        filter.country = "IN"
//        GMSPlacesClient.shared().findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: self.googleToken) { [weak self] (results, error) -> Void in
//            guard let self = self else { return }
//            if let error = error {
//                print("Autocomplete error \(error)")
//                return
//            }
//            if let results = results {
//                self.searchList = results.map({ $0.attributedFullText.string })
//                self.placeResult = results
//            }
//            //self.noResultLabel.isHidden = self.searchList?.count != 0
//            self.searchTblView.reloadData()
//        }
//    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.details,let wolooStore = sender as? NearbyResultsModel,let controller = segue.destination as? DetailsVC {
            controller.delegate = self
            controller.wolooStoreDOV2 = wolooStore
            controller.tranportMode = transPortMode
        } else if segue.identifier == Segues.searchLocation {
            let controller = segue.destination as? SearchLocationViewController
            controller?.transportMode = transPortMode
        }
    }
    //MARK: - Button action methods
        
   
//    @objc func clickeDismissBtn() {
//        self.sosPlaceTableViewHeight.constant = 0
//        
//    }
    
    
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
        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
        //self.collectionViewNearbyCell.reloadData()
        print("select car mode")
    }
    
    @IBAction func clickedWalkMode(_ sender: UIButton) {
        print("select walk mode")
        self.btnSelectedMode.setImage(UIImage(named: "fillWalk") , for: .normal)
        self.btnSelectedMode.setImage(UIImage(named: "fillWalk") , for: .selected)
        self.vwBackTransportMode.isHidden = true
        self.vehicleSelected = TransportType.WALK.rawValue
        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
        self.collectionViewNearbyCell.reloadData()
    }
    
    
    
    @IBAction func clickedBtnDismissView(_ sender: UIButton) {
        print("Hide the sos view")
        self.vwBackSOSBottomView.isHidden = true
        self.sosBottomCallView.isHidden = true
    }
    
    
    @IBAction func clickedBtnEnroute(_ sender: UIButton) {
        print("Open enroute screen")
        
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.vehicleSelected = self.vehicleSelected ?? ""
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
//    @IBAction func searchAction(_ sender: Any) {
//       
//        let vc = (UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "EnrouteVC") as? EnrouteVC)!
//        dashboardScreenTag = 1
//        vc.isDirection = false
//        vc.enrouteTag = true
//        self.navigationController?.pushViewController(vc, animated: true)
//   
//    }
    @IBAction func scanAction(_ sender: Any) {
    
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
//    @objc func searchButtonAction() {
////        self.performSegue(withIdentifier: Segues.searchLocation, sender: nil)
//        
//        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchWolooVC") as? SearchWolooVC
//        
//        if self.selectedPlace?.coordinate.latitude ?? 0 == 0 && self.selectedPlace?.coordinate.longitude ?? 0 == 0{
//            
//            vc?.lat = DELEGATE.locationManager.location?.coordinate.latitude
//            vc?.long = DELEGATE.locationManager.location?.coordinate.longitude
//            vc?.searchedPlace = selectedPlace?.name ?? ""
//            print("Selected place name: \(selectedPlace?.name ?? "")")
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }else{
//            vc?.lat = self.searchedLat
//            vc?.long = self.searchedlong
//            vc?.searchedPlace = selectedPlace?.name ?? ""
//            print("Selected place name: \(selectedPlace?.name ?? "")")
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
//        
//        //self.navigationController?.pushViewController(vc!, animated: true)
//    }
    
    
    @IBAction func clickedBookMarkedBtn(_ sender: UIButton) {
        let objController = BookmarkedVC.init(nibName: "BookmarkedVC", bundle: nil)
        objController.listNearByLoos = self.nearByStoreResponseDOV2 ?? [NearbyResultsModel]()
        
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
//    
//    @objc func scanButtonAction() {
//        self.performSegue(withIdentifier: Segues.qRCodeScan, sender: nil)
//    }
    
    //    @IBAction func giftCardOkAction(_ sender: UIButton) {
    //
    //        //Close gift card received pop up
    //        giftCardReceivedView.isHidden = true
    //    }
    
    @IBAction func clickedBtnWolooSupport(_ sender: Any) {
        print("call woloo support")
        self.sosBottomCallView.isHidden = false
        self.sosBottomVW.isHidden = true
       // self.vwBackSOSBottomView.isHidden = true
        
        self.isSOSOptionSelected = "Woloo"
        self.sosBottomVwTitlelbl.text = wolooSupport?.name ?? ""
        self.sosBottomVwContctInfolbl.text = wolooSupport?.phone ?? ""
    }
    
    
    @IBAction func clickedBtnHospital(_ sender: UIButton) {
        print("call hospital services")
        self.sosBottomCallView.isHidden = false
        self.sosBottomVW.isHidden = true
        //self.vwBackSOSBottomView.isHidden = true
        self.isSOSOptionSelected = "Hospital"
        self.sosBottomVwTitlelbl.text = nearestHospital?.name ?? ""
        self.sosBottomVwContctInfolbl.text = nearestHospital?.phone ?? ""
    }
    
    
    @IBAction func clickedBtnPolice(_ sender: Any) {
        print("call police services")
        self.sosBottomCallView.isHidden = false
        self.sosBottomVW.isHidden = true
        //self.vwBackSOSBottomView.isHidden = true
        self.isSOSOptionSelected = "Police"
        self.sosBottomVwTitlelbl.text = nearestPoliceStation?.name ?? ""
        self.sosBottomVwContctInfolbl.text = nearestPoliceStation?.phone ?? ""
    }
    
    
    
    @IBAction func clickedBtnFire(_ sender: UIButton) {
        print("call fire services")
        self.sosBottomCallView.isHidden = false
        self.sosBottomVW.isHidden = true
        //self.vwBackSOSBottomView.isHidden = true
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
    
//    @IBAction func optionSelectAction(_ sender: Any) {
//        
//        UIView.animate(withDuration: 0.5) {
//            self.vehicleOpen185Width.constant = self.vehicleOpen185Width.constant == 185 ? 0 : 185
//            //self.layoutIfNeeded()
//        } completion: {_ in }
//        
//        if let button = sender as? UIButton, button.tag >= 0 && button.tag <= 2 {
//            
//            fillButton(mode: TransportMode.init(rawValue: button.tag) ?? .car)
//            delegate?.selectedModeforTransport(mode: TransportMode.init(rawValue: button.tag) ?? .car)
//        }
//    }
    
//    @IBAction func openNowBtnPressed(_ sender: UIButton) {
//        
//        openNowBtn.isSelected = !openNowBtn.isSelected
//        //        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//        if openNowBtn.isSelected{
//            
//            if let openLocation = selectedPlace {
//                // self.shouldFetchData = true
//                self.selectedPlace = openLocation
//                let currentLatitude = String(openLocation.coordinate.latitude)
//                print(currentLatitude)
//                let currentLongitude = String(openLocation.coordinate.longitude)
//                print(currentLongitude)
//                //  self.storeReponse = nil
//                self.allStoresListv2.removeAll()
//                
//                //                self.searchNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 1 : 0)
//                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//                //self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 1 : 0, isSearch: 0)
//                self.nearByListTblView.reloadData()
//                print("Open Now button is selected")
//                
//            }
//            else{
//                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//            }
//            
//        }
//        
//        if !openNowBtn.isSelected{
//            //            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//            if let openLocation = selectedPlace {
//                // self.shouldFetchData = true
//                self.selectedPlace = openLocation
//                let currentLatitude = String(openLocation.coordinate.latitude)
//                print(currentLatitude)
//                let currentLongitude = String(openLocation.coordinate.longitude)
//                print(currentLongitude)
//                //self.storeReponse = nil
//                self.allStoresListv2.removeAll()
//                
//                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//                //self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latiude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: 0, showAll: self.openNowBtn.isSelected ? 1 : 0, isSearch: 0)
//                self.nearByListTblView.reloadData()
//                print("Open Now button is not selected")
//            }else{
//                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//                
//            }
//            
//            
//        }
//    }
    
//    @IBAction func wolooWithOfferBtnPressed(_ sender: UIButton) {
//        
//        self.wolooWithOfferBtn.isSelected = !wolooWithOfferBtn.isSelected
//        
//        if wolooWithOfferBtn.isSelected{
//            
//            if let openLocation = selectedPlace {
//                self.selectedPlace = openLocation
//                let currentLatitude = String(openLocation.coordinate.latitude)
//                print(currentLatitude)
//                let currentLongitude = String(openLocation.coordinate.longitude)
//                print(currentLongitude)
//                self.allStoresListv2.removeAll()
//                // self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//            }else {
//                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//            }
//        }
//        
//        if !wolooWithOfferBtn.isSelected{
//            if let openLocation = selectedPlace {
//                self.selectedPlace = openLocation
//                let currentLatitude = String(openLocation.coordinate.latitude)
//                print(currentLatitude)
//                let currentLongitude = String(openLocation.coordinate.longitude)
//                print(currentLongitude)
//                self.allStoresListv2.removeAll()
//                self.getNearByStoresV2(lat: openLocation.coordinate.latitude, lng: openLocation.coordinate.longitude, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//            }else {
//                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//            }
//            
//            // self.getNearByStoresV2(lat: locationManager.location?.coordinate.latitude ?? 19.055229, lng: locationManager.location?.coordinate.longitude ?? 19.055229, mode: 0, range: "2", is_offer: self.wolooWithOfferBtn.isSelected ? 1 : 0, showAll: self.openNowBtn.isSelected ? 0 : 1, isSearch: 0)
//        }
//        
//        
//    }
    
    
//    @IBAction func bookmarkBtnPressed(_ sender: UIButton) {
//        
//        self.bookmarkBtn.isSelected = !bookmarkBtn.isSelected
//        
//        if bookmarkBtn.isSelected{
//            
//            let resultArray = allStoresListv2.filter{ $0.is_liked == 1 }
//            allStoresListv2.removeAll()
//            nearByStoreResponseDOV2?.removeAll()
//            allStoresListv2.append(contentsOf: resultArray)
//            nearByStoreResponseDOV2?.append(contentsOf: resultArray)
//            self.newMapContainerView.nearByStoreResponseDOV2 = resultArray
//            self.newMapContainerView.addAllMarkersV2()
//            print("bookmarked woloos: \(allStoresListv2)")
//            self.nearByListTblView.reloadData()
//            
//        }
//        
//        if !bookmarkBtn.isSelected{
//            allStoresListv2.removeAll()
//            nearByStoreResponseDOV2?.removeAll()
//            allStoresListv2.append(contentsOf: allWolooList)
//            nearByStoreResponseDOV2?.append(contentsOf: allWolooList)
//            self.newMapContainerView.nearByStoreResponseDOV2 = allWolooList
//            self.newMapContainerView.addAllMarkersV2()
//            self.nearByListTblView.reloadData()
//            
//        }
//        
//    }
    
    
    @IBAction func currentLocationBtnPressed(_ sender: UIButton) {
        print("Navigate to user's current location")
        
        searchByLocationTxtField.text = ""
        //clearBtn.isHidden = true
        searchList?.removeAll()
       // searchTblView.reloadData()
        selectedPlace = nil
        searchedlong = nil
        searchedLat = nil
        
        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
        
        let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
        self.newMapContainerView.camera = camera
        
    }
    
    
    @IBAction func clickedSOSCallBtn(_ sender: UIButton) {
        self.sosBottomVW.isHidden = false
        self.vwBackSOSBottomView.isHidden = false
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
    

    
    
    
    //    func callNumber(phoneNumber:String) {
    //
    //        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
    //
    //            let application:UIApplication = UIApplication.shared
    //            if (application.canOpenURL(phoneCallURL)) {
    //                if #available(iOS 10.0, *) {
    //                    application.open(phoneCallURL, options: [:], completionHandler: nil)
    //                } else {
    //                    // Fallback on earlier versions
    //                    application.openURL(phoneCallURL as URL)
    //
    //                }
    //            }
    //        }
    //    }
    
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
    
    func fetchUserProfileV2(){
        
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
       
    func getUserProfileAPICall(){
        self.objDashboardViewModel.getUserProfileAPI()
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
                        
                        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
                        
                        print("authorized always")
                        //self.locationManager.allowsBackgroundLocationUpdates = true
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
                
                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
            }
            //locationManager.allowsBackgroundLocationUpdates = true
        case .denied:
            
            print("User has denied the map permissions settings")
            if self.dashboardScreenTag == 1{
                
            }
            else {
                let camera = GMSCameraPosition(latitude: 19.055229, longitude: 72.830829, zoom: 14)
                self.newMapContainerView.camera = camera
                
                self.getNearByStoresV2(lat: self.locationManager.location?.coordinate.latitude ?? 19.055229, lng: self.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
                
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
    
//    @objc func loadMoreWoloo(sender: UIButton!) {
//        
//        dashboardScreenTag = 1
//        
//        let vc = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchWolooVC") as? SearchWolooVC
//        //self.performSegue(withIdentifier: Segues.searchWolooVC, sender: nil)
//        if searchedLat ?? 0 == 0 && self.searchedlong ?? 0 == 0{
//            
//            vc?.lat = DELEGATE.locationManager.location?.coordinate.latitude
//            vc?.long = DELEGATE.locationManager.location?.coordinate.longitude
//            //vc?.searchedPlace = selectedPlace?.name ?? ""
//            print("Selected place name: \(selectedPlace?.name ?? "")")
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }else{
//            vc?.lat = self.searchedLat ?? 0
//            vc?.long = self.searchedlong ?? 0
//            vc?.searchedPlace = selectedPlace?.name ?? ""
//            print("Selected place name: \(selectedPlace?.name ?? "")")
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
//        
//    }
}
//MARK: --------- Custom Nearby woloo tableView

extension DashboardVC: DetailsVCProtocol {
    
    //MARK: - DetailsVCProtocol
    func didChangedBookmarkStatus() {
        if searchedLat != nil && searchedlong != nil{
            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
            self.newMapContainerView.camera = camera
            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
           
        }else {
            print("load current location")
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
            handleLocationPermission()
        }
    }
     //MARK: UItableviewdelegate and datasource methods
    
    
//        case searchTblView:
//            cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationCellDashboard", for: indexPath)
//            cell.textLabel?.text = self.searchList?[indexPath.row] as? String ?? ""
//            //cell.backgroundColor = UIColor.green
//            

}

extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allStoresListv2.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == allStoresListv2.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowMoreCell.identifier, for: indexPath) as? ShowMoreCell ?? ShowMoreCell()
            cell.delegate = self
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCollectionViewCell.identifier, for: indexPath) as? DashboardCollectionViewCell ?? DashboardCollectionViewCell()
            cell.delegate = self
            cell.configureDashboardCollectionViewCell(objNearbyResultsModel: self.allStoresListv2[indexPath.item], strTransportType: self.vehicleSelected)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        indexOfItem = indexPath.item
        pageController.currentPage = indexPath.item
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == allStoresListv2.count {
                // Handle action for the custom view (ShowMoreCell)
                print("Show popup")
//            let objController = DashboardBottomSheet.init(nibName: "DashboardBottomSheet", bundle: nil)
//
//            objController.delegate = self
//            let popup = STPopupController.init(rootViewController: objController)
//            popup.style = .bottomSheet
//            popup.present(in: DELEGATE.window?.rootViewController ?? self)
            
            let objController = DashboardMapBottomSheetVC.init(nibName: "DashboardMapBottomSheetVC", bundle: nil)

            objController.delegate = self
            objController.lat = DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229
            objController.lng = DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829
            objController.allStoresList = self.allStoresListv2
            let popup = STPopupController.init(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
               
            } else {
                if allStoresListv2.count > indexPath.row {
                    Global.addNetcoreEvent(eventname: self.netCoreEvents.wolooClickedFromSearchedWoloo, param: [
                        "keywords": self.searchByLocationTxtField.text ?? "",
                        "host_click_location": "(\(allStoresListv2[indexPath.row].lat ?? ""),\(allStoresListv2[indexPath.row].lng ?? ""))",
                        "host_click_id": "\(allStoresListv2[indexPath.row].id ?? 0)"])
                    
                    if let currentLocation = DELEGATE.locationManager.location {
                        
                        Global.addNetcoreEvent(eventname: netCoreEvents.wolooDetailClick, param:  ["location": "(\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude))","travel_mode": "", "host_click_id": "\(allStoresListv2[indexPath.row].id ?? 0)","host_click_location": "\(allStoresListv2[indexPath.row].lat ?? ""), \(allStoresListv2[indexPath.row].lng ?? "")"])
                    }
                    
                    dashboardScreenTag = 1
                    print("Passed array index: \(allStoresListv2[indexPath.row])")
                    selectedWolooGlobal = allStoresListv2[indexPath.row]
                    performSegue(withIdentifier: Constant.Segue.details, sender: allStoresListv2[indexPath.row])
                }
            }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionViewNearbyCell else { return }

        let visibleRect = CGRect(origin: collectionViewNearbyCell.contentOffset, size: collectionViewNearbyCell.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = collectionViewNearbyCell.indexPathForItem(at: visiblePoint) {
            print("Current index: \(indexPath.row)")

            // Cancel any existing debounce timer
            debounceTimer?.invalidate()

            // Handle ShowMoreCell separately
            if indexPath.item != allStoresListv2.count {
                let camera = GMSCameraPosition(
                    latitude: Double(self.nearByStoreResponseDOV2?[indexPath.item].lat ?? "19.055229") ?? 19.055229,
                    longitude: Double(self.nearByStoreResponseDOV2?[indexPath.item].lng ?? "72.830829") ?? 72.830829,
                    zoom: 14
                )
                self.newMapContainerView.camera = camera

                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(
                    latitude: Double(self.nearByStoreResponseDOV2?[indexPath.item].lat ?? "19.055229") ?? 19.055229,
                    longitude: Double(self.nearByStoreResponseDOV2?[indexPath.item].lng ?? "72.830829") ?? 72.830829
                )
                self.showCustomInfoView(for: marker)
            }
        }
    }


    func scrollToCenter(indexPath: IndexPath) {
        if indexPath.item < allStoresListv2.count + 1 { // Ensure index is valid
            collectionViewNearbyCell.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == allStoresListv2.count {
            .init(width: collectionView.frame.width - 24, height: 150)
        }
        else{
            .init(width: collectionView.frame.width - 24, height: 184)
        }
       
    }
}

// MARK: - AnimationProtoCol

extension DashboardVC:AnimationProtocol, DashboardCollectionViewCellDelegate {
    
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

    //when tapped on marker available on screen
    func didTapMarker(_ marker: GMSMarker) {

        print("marker point: \(marker.zIndex)")

        self.collectionViewNearbyCell.scrollToItem(at: IndexPath(item: Int(marker.zIndex), section: 0), at: .centeredHorizontally, animated: true)
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

// MARK: - API
extension DashboardVC: DashboardViewModelDelegate{
    
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
    
    
    
    func getNearByStoresV2(lat: Double, lng: Double, mode: String, range: String, is_offer: Int, showAll: Int, isSearch: Int){
        
        self.collectionViewNearbyCell.isHidden = true
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
        
        var mode: Int = 0
        if vehicleSelected == TransportType.CAR.rawValue {
            mode = 0
        }
        else{
            mode = 1
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
                self.collectionViewNearbyCell.isHidden = false
                Global.hideIndicator()
                //if let response = response{
                print(response.results.count ?? 0)
                //                if response.results.count == 0{
                //                    print("No woloos found")
                //                    self.showNoWoloo = true
                //                    self.timeForExpandAndCollapse()
                //                    //self.isDataExistInAPI = false
                //                   // self.tableView.reloadData()
                //                    self.nearByListTblView.reloadData()
                //                    return
                //                }
                self.showNoWoloo = false
                // self.isDataExistInAPI = true
                self.nearByStoreResponseDOV2 = response.results
                self.allStoresListv2 = response.results
                self.pageController.numberOfPages = self.allStoresListv2.count
                //self.tableView.reloadData()
                self.collectionViewNearbyCell.reloadData()
                self.allWolooList = response.results
                self.newMapContainerView.nearByStoreResponseDOV2 = response.results
                self.newMapContainerView.addAllMarkersV2()
                // }else{
                
                let validationNoWoloo = self.if_No_Woloo_found(arrNearby: response.results)
                
                if validationNoWoloo.isValid{
                    print("no woloos found")
                    var param = [String:Any]()
                    param["location"] = "(\(lat),\(lng))"
                    Global.addNetcoreEvent(eventname: self.netCoreEvents.noLocationFound, param: param)
                    self.showNoWoloo = true
                    //self.isDataExistInAPI = false
                    // self.tableView.reloadData()
                    
                    return
                }
                else{
                    print("woloo found")
                }
                print("resposne for nearByV2: \(response)")
                //self.collectionViewNearbyCell.reloadData() // Reload the collection view
                DispatchQueue.main.async {
                  //  self.collectionViewNearbyCell.reloadData()
                    
                    if !self.allStoresListv2.isEmpty { // Check if there are items
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Small delay for layout update
                            self.collectionViewNearbyCell.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                        }
                    }
                }
                
                // }
                
            case .failure(let error):
                Global.hideIndicator()
                self.collectionViewNearbyCell.isHidden = false
                print("reponse results v2 Error",error)
                self.showNoWoloo = true
                // self.tableView.reloadData()
             
            }
        }
    }
    
    //MARK: - if_No_Woloo_found
    func if_No_Woloo_found(arrNearby: [NearbyResultsModel]) -> (isValid: Bool, errorMessage: String?){
        
        if arrNearby.count == 0{
            return (true, nil)
        }
        else{
            return (false, nil)
        }
    }
    
    func wahCertificateAPICall(){
        self.objDashboardViewModel.wahCertificateAPI(wolooID: UserDefaultsManager.fetchWahCode())
    }
    
//    func wahCertificateAPI(code: String) {
//        let param: [String: Any] = ["woloo_id": code]
//        APIManager.shared.wahCertificate(param: param) { [weak self] (result, message) in
//            guard let self = self else { return }
//            if let store = result {
//                // self.openWahCerificateVC(store: store)
//            }
//            print(message)
//        }
//    }
    

    
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
                    self.getNearByStoresV2(lat: place.coordinate.latitude, lng: place.coordinate.longitude, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
                }
            }
        })
        
    }
    
    
    func didSelectRadius(radius: Int?) {
        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(radius ?? 0)", is_offer: 0, showAll: 2, isSearch: 1)
    }
    
    func didSelectWoloo(objNearbyResultsModel: NearbyResultsModel?) {
        selectedWolooGlobal = objNearbyResultsModel
        performSegue(withIdentifier: Constant.Segue.details, sender: objNearbyResultsModel)
    }
    
    
    func didClickedTakeMeHere(objNearbyResultsModel: NearbyResultsModel?){
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.destLat = Double(objNearbyResultsModel?.lat ?? "")
        objController.destLong = Double(objNearbyResultsModel?.lng ?? "")
        objController.strIsComeFrom = "Navigation"
        objController.strDestination = "\(objNearbyResultsModel?.name ?? "")"
        objController.wolooID = objNearbyResultsModel?.id
        self.navigationController?.pushViewController(objController, animated: true)
        
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


/*
 
 1) first screen array
 
 2) specific info second screen then i'll change it's status to 0 or 1
 
 3) then while dismissing this screen i'll send this changed object to first screen were i'll compare with my loaded array and list or filter accordingly
 
 */
extension DashboardVC: UIScrollViewDelegate {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        guard scrollView == collectionViewNearbyCell,
//              let layout = collectionViewNearbyCell.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//
//        let cellWidth = layout.itemSize.width
//        let spacing = layout.minimumLineSpacing
//
//        // Total items including ShowMoreCell
//        let totalItems = allStoresListv2.count + 1 // +1 for ShowMoreCell
//
//        // Calculate the estimated index
//        let estimatedIndex = (targetContentOffset.pointee.x + scrollView.contentInset.left) / (cellWidth + spacing)
//
//        // Handle velocity: ensure no skipping of multiple cells
//        let index: Int
//        if velocity.x > 0 {
//            index = min(Int(ceil(estimatedIndex)), totalItems - 1) // Move right
//        } else if velocity.x < 0 {
//            index = max(Int(floor(estimatedIndex)), 0) // Move left
//        } else {
//            index = Int(round(estimatedIndex)) // Normal case
//        }
//
//        // Ensure index stays within bounds
//        let safeIndex = max(0, min(index, totalItems - 1))
//
//        // Calculate the exact X position to snap to
//        let targetX = CGFloat(safeIndex) * (cellWidth + spacing) - scrollView.contentInset.left
//
//        // Smoothly adjust target offset
//        targetContentOffset.pointee = CGPoint(x: targetX, y: 0)
//
//        // Force center locking after scrolling stops (prevents last-item jumping issue)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.scrollToCenter(indexPath: IndexPath(item: safeIndex, section: 0))
//        }
//    }





}
