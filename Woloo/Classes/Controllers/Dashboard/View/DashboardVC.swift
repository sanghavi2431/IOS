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

class DashboardVC: AbstractVC, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, DashboardBottomSheetDelegate, ShowMoreCellDelegate{
    
    
    
    
    
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
    var isSearch: Bool? = false
    let searchRanges = [2, 4, 5, 6]
    var isCoinPopUpShown: Bool? = false
    var isEnroute: Bool? = false
    
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
    var rangeSelected: Int? = 2
    
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
    
    var isFreetrial = false
    var obj = WahCertificate()
    private var shouldAutoScrollToFirst = false
    private var didAutoScroll = false
    
    
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
        
        handleLocationPermission()
        
        if let layout = collectionViewNearbyCell.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = .zero
        }
        collectionViewNearbyCell.contentInsetAdjustmentBehavior = .never
    }
    
    func setupUI(){
        searchByLocationTxtField.font = UIFont(name: "CenturyGothic", size: 14)
    }
    

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Status*",status.rawValue)
        let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
        self.newMapContainerView.camera = camera
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

           if let scoreRange = self.allStoresListv2[Int(marker.zIndex)].cibil_score, let upperScore = scoreRange.components(separatedBy: "-").last {
               customInfoView.lblWahScore.text = upperScore
           } else {
               customInfoView.lblWahScore.text = ""
           }
           

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
      
        
        
    
        guard let windowScene = UIApplication.shared.connectedScenes
               .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                 let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
               return
           }
           
        overlayView.removeFromSuperview()
        overlayView.translatesAutoresizingMaskIntoConstraints = true
        overlayView.frame = keyWindow.bounds
           keyWindow.addSubview(overlayView)
           keyWindow.bringSubviewToFront(overlayView)
        
        
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
        self.overlayView.isHidden = true
        
        self.handleStoredDeepLinkIfAny()
        
        print("Screen opened")
    }
    
    
    private func handleStoredDeepLinkIfAny() {
        let type = UserDefaultsManager.fetchDeepLinkType()

        switch type {
        case "voucher":
            let voucher = UserDefaultsManager.fetchVoucherCode()
            self.voucherAPIV2(voucher: voucher, forceApply: false)
            UserDefaultsManager.storeDeepLinkType(value: "") // clear after use
          
        default:
            break
        }
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
        //self.searchByLocationTxtField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: false)
       // DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
        //voucherAPIV2(voucher: "Fzz7F", forceApply: false)
        print("Retrieved voucher code: \(UserDefaultsManager.fetchVoucherCode())")
        
        print("Retrieved wah code: \(UserDefaultsManager.fetchWahCode())")
        
        // Handle stored deep link (in case app was launched from deep link)
        self.handleStoredDeepLinkIfAny()
        
        //selectedPlace = nil
        locationManager.delegate = self

        
        //self.fetcUserProfile()
        DispatchQueue.main.async {
            self.getUserProfileAPICall()
        }
        
        self.fetchUserProfileV2()
        self.pageCount = 1
        self.nearByStoreResponseDO = nil
      

        print("Current lat and long on dashboard page Lat:  \(locationManager.location?.coordinate.latitude) Long: \(locationManager.location?.coordinate.longitude)")

        let coordinate = CLLocationCoordinate2D(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829)
        self.wolooSupport = Place(name: "Woloo", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")
        self.wolooSupport?.phone = "02249741750"
        self.isSOSOptionSelected = "Woloo"

        self.fetchNearbyPlaces(coordinate: coordinate)
        
        if self.isCoinPopUpShown == true{
            
            
            
            
            self.isCoinPopUpShown = false
        }
        else{
            if isSearch == true && self.isEnroute == true{
                print("Navigate to user's current location")
                
                self.isSearch = false
                self.isEnroute = false
                searchByLocationTxtField.text = ""
                //clearBtn.isHidden = true
                searchList?.removeAll()
               // searchTblView.reloadData()
                selectedPlace = nil
                searchedlong = nil
                searchedLat = nil
                self.rangeSelected = 2
                self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
                
                let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
                self.newMapContainerView.camera = camera
                
            }
        }
        

        
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
            controller.vehicleSelected = self.vehicleSelected
            controller.wolooStoreDOV2 = wolooStore
            controller.isSearch = self.isSearch
            controller.sourceLat = self.searchedLat ?? 19.055229
            controller.sourceLong = self.searchedlong ?? 72.830829
            
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
        
        
        if searchedLat != nil && searchedlong != nil{
            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
            self.newMapContainerView.camera = camera
            
            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(self.rangeSelected ?? 2)", is_offer: 0, showAll: 2, isSearch: 0)
        }
        else{
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
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
        if searchedLat != nil && searchedlong != nil{
            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
            self.newMapContainerView.camera = camera
            
            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(self.rangeSelected ?? 2)", is_offer: 0, showAll: 2, isSearch: 0)
        }
        else{
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
        }
        self.collectionViewNearbyCell.reloadData()
    }
    
    
    @IBAction func clickedBikeMode(_ sender: UIButton) {
        
        self.btnSelectedMode.setImage(UIImage(named: "icon_bike") , for: .normal)
        self.btnSelectedMode.setImage(UIImage(named: "icon_bike") , for: .selected)
        self.vwBackTransportMode.isHidden = true
        self.vehicleSelected = TransportType.BIKE.rawValue
        
        if searchedLat != nil && searchedlong != nil{
            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
            self.newMapContainerView.camera = camera
            
            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(self.rangeSelected ?? 2)", is_offer: 0, showAll: 2, isSearch: 0)
        }
        else{
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
        }
        self.collectionViewNearbyCell.reloadData()
    }
    
    
    @IBAction func clickedBtnDismissView(_ sender: UIButton) {
        print("Hide the sos view")
        self.vwBackSOSBottomView.isHidden = true
        self.sosBottomCallView.isHidden = true
    }
    
    
    @IBAction func clickedBtnEnroute(_ sender: UIButton) {
        print("Open search screen")
       
        let objController = SearchLocationsViewController.init(nibName: "SearchLocationsViewController", bundle: nil)
        objController.delegate = self
        self.navigationController?.pushViewController(objController, animated: true)
        
    }
    
    
    @IBAction func enrouteAction(_ sender: UIButton) {
        self.isEnroute = true
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.delegate = self
        objController.vehicleSelected = self.vehicleSelected ?? ""
        self.navigationController?.pushViewController(objController, animated: true)
    }
    

    @IBAction func scanAction(_ sender: Any) {
    
        self.performSegue(withIdentifier: Segues.qRCodeScan, sender: nil)
    }
    
    @IBAction func hideOverlay(_ sender: Any) {
        DispatchQueue.main.async {
            self.overlayView.isHidden = true
            Global.addNetcoreEvent(eventname: self.netCoreEvents.menuDescriptionAfterOverlay, param: [:])
        }
        UserDefaults.standard.set(1, forKey:"overlay_shown")
        UserDefaults.standard.synchronize()
    }
   
    
    @IBAction func clickedBookMarkedBtn(_ sender: UIButton) {
        let objController = BookmarkedVC.init(nibName: "BookmarkedVC", bundle: nil)
        objController.listNearByLoos = self.nearByStoreResponseDOV2 ?? [NearbyResultsModel]()
        objController.vehicleSelected = self.vehicleSelected ?? ""
        objController.sourceLat = self.searchedLat ?? 19.055229
        objController.sourceLong = self.searchedlong ?? 72.830829
        objController.isSearch = self.isSearch
        self.navigationController?.pushViewController(objController, animated: true)
    }
    

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
    
    
    
    @IBAction func currentLocationBtnPressed(_ sender: UIButton) {
        print("Navigate to user's current location")
        
        self.isSearch = false
        searchByLocationTxtField.text = ""
        //clearBtn.isHidden = true
        searchList?.removeAll()
       // searchTblView.reloadData()
        selectedPlace = nil
        searchedlong = nil
        searchedLat = nil
        self.rangeSelected = 2
        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
        
        let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
        self.newMapContainerView.camera = camera
        
    }
    
    
    @IBAction func clickedClearBtn(_ sender: UIButton) {
        
        
        if !Utility.isEmpty(searchByLocationTxtField.text){
            self.isSearch = false
            searchByLocationTxtField.text = ""
            //clearBtn.isHidden = true
            searchList?.removeAll()
           // searchTblView.reloadData()
            selectedPlace = nil
            searchedlong = nil
            searchedLat = nil
            self.rangeSelected = 2
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
            
            let camera = GMSCameraPosition(latitude: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, longitude: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, zoom: 14)
            self.newMapContainerView.camera = camera
        }
        
       
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
        UserProfileModel.fetchUserProfileV2 { userInfo in
            guard let userInfo = userInfo else { return }
            DispatchQueue.main.async {
                self.setUerInfoV2(userInfo: userInfo)
            }
        }
    }
    func setUerInfoV2(userInfo: UserProfileModel) {
        let profile = userInfo.profile
        
        // ✅ Username handling
        var name = profile?.name ?? ""
        if name.contains(" ") {
            let result = name.split(separator: " ")
            if let first = result.first {
                name = String(first)
            }
        }
        print("UserName: \(name)")
        
        // ✅ Expiry date handling
        if let expiryDatestr = profile?.expiry_date,
           let expiryDate = expiryDatestr.toDateSubscription(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
            
            print("Expiry Date: \(expiryDate)")
            
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let expiryDay = calendar.startOfDay(for: expiryDate)
            
            // Number of days left
            let days = calendar.dateComponents([.day], from: today, to: expiryDay).day ?? 0
            print("Number of days: set user\(days)")
            
            // ✅ Show voucher/membership expiry status
            if days <= 7 && days > 0 &&
               profile?.isFutureSubcriptionExist == false &&
               profile?.voucher_id != nil {
                
                // Membership is about to expire
                self.voucherExpiryView.isHidden = false
                self.btnCloseVoucherExpiryView.isHidden = false
                
            } else if days < 0 {
                // Membership expired
                self.lblVoucherExpiry.text = "Oops! Membership/Voucher has expired"
                self.voucherExpiryView.isHidden = false
                self.btnCloseVoucherExpiryView.isHidden = true
            } else {
                // Not expiring soon
                self.voucherExpiryView.isHidden = true
                self.btnCloseVoucherExpiryView.isHidden = true
            }
            
            var wolooCode =  UserDefaultsManager.fetchWahCode()
            
            
            var strType = UserDefaultsManager.fetchDeepLinkType()
            
            if !(Utility.isEmpty(wolooCode)){
                self.overlayView.isHidden = true
                if strType == "powderroom"{
                    if self.voucherExpiryView.isHidden == false {
                        
                        print("susbcription is not active")
                        let objController = PowderRoomPassVC.init(nibName: "PowderRoomPassVC", bundle: nil)
                        
                        self.navigationController?.pushViewController(objController, animated: true)
                    }
                    else if days > 0 &&  Utility.isEmpty(userInfo.planData?.name ?? "") {
                        self.isFreetrial = true
                            self.overlayView.isHidden = true
                            print("susbcription is free trial")
                            let objController = PowderRoomPassVC.init(nibName: "PowderRoomPassVC", bundle: nil)
                            
                            self.navigationController?.pushViewController(objController, animated: true)
                        }
                    else{
                        print("susbcription is active")
                        self.wahCertificateAPICall()
                    }
                }
                else{
                    print("calling for host")
                    self.wahCertificateAPICall()
                }
            }
            
            
        } else {
            print("⚠️ Expiry date not found or invalid format")
            // Hide expiry view if date not available
            self.voucherExpiryView.isHidden = true
            self.btnCloseVoucherExpiryView.isHidden = true
        }
        
       
        
    }

       
    func getUserProfileAPICall(){
        self.objDashboardViewModel.getUserProfileAPI()
    }

    func handleLocationPermission(){
        if searchedLat != nil && searchedlong != nil {
            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
            self.newMapContainerView.camera = camera
            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
            return
        }
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
            else if let certificateCode = dict["powderroom"] as? String {
                
                var userObj = UserDefaultsManager.fetchUserData()
                
                if let expiryDatestr = userObj?.profile?.expiry_date,
                   let expiryDate = expiryDatestr.toDateSubscription(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())
                    let expiryDay = calendar.startOfDay(for: expiryDate)
                    
                    // Number of days left
                    let days = calendar.dateComponents([.day], from: today, to: expiryDay).day ?? 0
                    print("Number of days: all notifications\(days)")
                    
                    if days < 0 {
                        let objController = PowderRoomPassVC.init(nibName: "PowderRoomPassVC", bundle: nil)
                        
                        self.navigationController?.pushViewController(objController, animated: true)
                    }else if days > 0 &&  Utility.isEmpty(userObj?.planData?.name ?? ""){
                        let objController = PowderRoomPassVC.init(nibName: "PowderRoomPassVC", bundle: nil)
                        
                        self.navigationController?.pushViewController(objController, animated: true)
                    }
                    else{
                        self.wahCertificateAPICall()
                    }
                }
                
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
    
}
//MARK: --------- Custom Nearby woloo tableView

extension DashboardVC: DetailsVCProtocol, EnrouteViewControllerProtocol, SearchLocationEnrouteDelegate {
    
    //MARK: - SearchLocationEnrouteDelegate
    func didSearchedPlace(lat: Double, long: Double, strPlace: String?, selectedCity: String, strBuildingName: String?, strLocality: String?, strCity: String?, strState: String?, strPincode: String?, strFullAddress: String?) {
        print("call nearby api")
        
        self.searchByLocationTxtField.text = strFullAddress
        self.searchedlong = long
        self.searchedLat = lat
        let camera = GMSCameraPosition(latitude: self.searchedLat ?? 19.055229, longitude: self.searchedlong ?? 72.830829, zoom: 10)
        self.newMapContainerView.camera = camera
        
        self.isSearch = true
        self.getNearByStoresV2(lat: self.searchedLat ?? 19.055229 , lng: self.searchedlong ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(self.rangeSelected ?? 2)", is_offer: 0, showAll: 2, isSearch: 1)
    }
    
    
    //MARK: SearchLocationEnrouteDelegate
    
    
    //MARK: - DetailsVCProtocol
    func didChangedBookmarkStatus() {
        if searchedLat != nil && searchedlong != nil{
            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
            self.newMapContainerView.camera = camera
            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(self.rangeSelected ?? 2)", is_offer: 0, showAll: 2, isSearch: 0)
           
        }else {
            print("load current location")
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(self.rangeSelected ?? 2)", is_offer: 0, showAll: 2, isSearch: 0)
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
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return allStoresListv2.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ShowMoreCell.identifier,
                for: indexPath
            ) as! ShowMoreCell
            cell.delegate = self
            return cell
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DashboardCollectionViewCell.identifier,
            for: indexPath
        ) as! DashboardCollectionViewCell

        cell.delegate = self
        cell.configureDashboardCollectionViewCell(
            objNearbyResultsModel: allStoresListv2[indexPath.item],
            strTransportType: vehicleSelected
        )
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        indexOfItem = indexPath.item
            
            guard pageController.numberOfPages > 0 else { return }
            pageController.currentPage = indexPath.item
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 1 {
            // ShowMore popup
            let objController = DashboardMapBottomSheetVC(
                nibName: "DashboardMapBottomSheetVC",
                bundle: nil
            )

            objController.delegate = self
            objController.rangeSelected = rangeSelected
            objController.vehicleSelected = vehicleSelected

            if let lat = searchedLat, let lng = searchedlong {
                objController.lat = lat
                objController.lng = lng
            } else {
                objController.lat = DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229
                objController.lng = DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829
            }

            objController.allStoresList = allStoresListv2

            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
            return
        }

        // Normal Woloo click
        let item = allStoresListv2[indexPath.item]
        selectedWolooGlobal = item
        performSegue(withIdentifier: Constant.Segue.details, sender: item)
    }

    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionViewNearbyCell else { return }

        let centerPoint = CGPoint(
            x: scrollView.contentOffset.x + scrollView.bounds.width / 2,
            y: scrollView.bounds.height / 2
        )

        guard let indexPath = collectionViewNearbyCell.indexPathForItem(at: centerPoint),
              indexPath.section == 0,
              indexPath.item < allStoresListv2.count else { return }

        let store = allStoresListv2[indexPath.item]

        // Update camera position
        let camera = GMSCameraPosition(
            latitude: Double(store.lat ?? "19.055229") ?? 19.055229,
            longitude: Double(store.lng ?? "72.830829") ?? 72.830829,
            zoom: 14
        )
        newMapContainerView.camera = camera
        
        // Show custom info view for the corresponding marker
        // Create a marker object with the same zIndex to show the info view
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: Double(store.lat ?? "19.055229") ?? 19.055229,
            longitude: Double(store.lng ?? "72.830829") ?? 72.830829
        )
        marker.zIndex = Int32(indexPath.item)
        marker.title = store.name ?? ""
        
        // Show the custom info view for this marker
        showCustomInfoView(for: marker)
    }



    func scrollToCenter(indexPath: IndexPath) {
        if indexPath.item < allStoresListv2.count + 1 { // Ensure index is valid
            collectionViewNearbyCell.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Use screen width minus 12 for cell width
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 12

        if indexPath.section == 1 {
            return CGSize(width: itemWidth, height: 150)
        } else {
            return CGSize(width: itemWidth, height: 184)
        }
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
}

// MARK: - AnimationProtoCol

extension DashboardVC:AnimationProtocol, DashboardCollectionViewCellDelegate {
    
    //MARK: - DashboardCollectionViewCellDelegate
    func didClickedNavigate(obj: NearbyResultsModel) {
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.vehicleSelected = self.vehicleSelected
        objController.destLat = Double(obj.lat ?? "")
        objController.destLong = Double(obj.lng ?? "")
        objController.objNearbyResultsModel = obj
        objController.sourceLat = self.searchedLat ?? 19.055229
        objController.sourceLong = self.searchedlong ?? 72.830829
        objController.isSearch = self.isSearch
      
//        objController.lblTime.text = "\((obj.duration_sec ?? 0)/60) min"
//        objController.lblDistance.text = obj.distance ?? ""
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
extension DashboardVC: DashboardViewModelDelegate, BlogsPointsPopUpVCDelegate{
    
    
    
    //MARK: - BlogsPointsPopUpVCDelegate
    func didMNavigateToStore() {
        //
    }
    
    func didReceiveCreditUserCoinsResponse(objResponse: CoinsWrapper) {
        DispatchQueue.main.async{
            self.isCoinPopUpShown = true
            let objController = BlogsPointsPopUpVC(nibName: "BlogsPointsPopUpVC", bundle: nil)
            objController.pointCount = String(50)
            objController.delegate = self
            let popup = STPopupController(rootViewController: objController)
            popup.style = .bottomSheet
            popup.present(in: DELEGATE.window?.rootViewController ?? self)
        }
    }
    
    func didReceiceCreditUserCoinsError(strError: String) {
        //
    }
    
    
    //Wah Certificate API call
    func didReceiveWahCertificateResponse(objResponse: BaseResponse<WahCertificate>) {
        
        print("get woloo by id API call success")
        
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
           // self.setUerInfoV2(userInfo: objResponse.results)
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
        else if vehicleSelected == TransportType.BIKE.rawValue {
            mode = 3
        }
        else if vehicleSelected == TransportType.WALK.rawValue {
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
                self.shouldAutoScrollToFirst = true
                self.didAutoScroll = false
                self.collectionViewNearbyCell.isHidden = false
                Global.hideIndicator()
                //if let response = response{
                print(response.results.count ?? 0)
               
                self.showNoWoloo = false
                // self.isDataExistInAPI = true
                self.nearByStoreResponseDOV2 = response.results
                self.allStoresListv2 = response.results
                self.pageController.numberOfPages = self.allStoresListv2.count
                self.pageController.currentPage = self.allStoresListv2.isEmpty ? 0 : 0 // safe
                //self.tableView.reloadData()
                // Invalidate layout before reloading to prevent overlapping
                self.collectionViewNearbyCell.collectionViewLayout.invalidateLayout()
                self.collectionViewNearbyCell.reloadData()
                self.pageController.numberOfPages = self.allStoresListv2.count
                self.pageController.currentPage = 0
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
                    Global.addNetcoreEvent(eventname: self.netCoreEvents.noWolooFound, param: [:])
                    
                    // If range is 2 and no washrooms found, automatically try with range 6
                    let currentRange = Int(range) ?? 2
                    let allowedRanges = [2, 4, 5, 6]
                    
                    if let index = allowedRanges.firstIndex(of: currentRange),
                           index < allowedRanges.count - 1 {
                        
                        let nextRange = allowedRanges[index + 1]
                        self.rangeSelected = 6
                        // Automatically call API again with range = 6
                        self.getNearByStoresV2(lat: lat, lng: lng, mode: self.vehicleSelected ?? "", range: "\(nextRange)", is_offer: is_offer, showAll: showAll, isSearch: isSearch)
                        return
                    }
                    
                    // If range is 6 and still no washrooms found, show popup
                    if currentRange == 6 {
                        self.showNoWoloo = true
                       
                            self.objDashboardViewModel.creditUserCoins(blogId: 0, coins: Int(UserDefaultsManager.fetchAppConfigData()?.no_woloo_found ?? "0"), isGift: 0, strRemarks: "No Woloo Found", strType: "Manual Credit", woloo_id: 0, wolooCoins: 0)
                            var param = [String:Any]()
                            param["location"] = "(\(lat),\(lng))"
                            Global.addNetcoreEvent(eventname: self.netCoreEvents.noLocationFound, param: param)
                            Global.addNetcoreEvent(eventname: self.netCoreEvents.noWolooFound, param: [:])
                     
                        
                        self.showNoWoloo = true
                        //self.isDataExistInAPI = false
                        // self.tableView.reloadData()
                        
                        // Show popup when no washrooms found after trying range 6
                        DispatchQueue.main.async {
                            let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "OK", title: "No washroom found nearby", message: "Please choose another location", image: nil, controller: self)
                            
                            // Set background to transparent (overlay area)
                            alert.backgroundColor = UIColor.clear
                            // Make the overlay view (dimmer behind popup) transparent
                            // The XIB structure: alert -> view (from XIB) -> g36-P2-fld (overlay)
                            if alert.subviews.count > 0 {
                                let xibView = alert.subviews[0]
                                if xibView.subviews.count > 0 {
                                    // This is the overlay/dimmer view (g36-P2-fld) that needs to be transparent
                                    xibView.subviews[0].backgroundColor = UIColor.clear
                                }
                            }
                            
                            // Add tap gesture to dismiss when tapping outside popup
                            // Add gesture to the overlay view (transparent background)
                            if alert.subviews.count > 0 {
                                let xibView = alert.subviews[0]
                                if xibView.subviews.count > 0 {
                                    let overlayView = xibView.subviews[0]
                                    overlayView.isUserInteractionEnabled = true
                                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissWolooAlertOnTap(_:)))
                                    tapGesture.cancelsTouchesInView = false
                                    overlayView.addGestureRecognizer(tapGesture)
                                }
                            }
                            
                            alert.cancelTappedAction = { [weak self] in
                                guard let self = self else { return }
                                alert.removeFromSuperview()
                            }
                            self.view.addSubview(alert)
                            self.view.bringSubviewToFront(alert)
                        }
                    }
                    
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
                        // Ensure layout is calculated before scrolling
                        self.collectionViewNearbyCell.layoutIfNeeded()
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
    
    func didSelectRadius(radius: Int) {
        
        self.rangeSelected = radius
        
        if searchedLat != nil && searchedlong != nil{
            let camera = GMSCameraPosition(latitude: searchedLat ?? 19.055229, longitude: searchedlong ?? 72.830829, zoom: 10)
            self.newMapContainerView.camera = camera
            self.getNearByStoresV2(lat: searchedLat ?? 19.055229, lng: searchedlong ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(radius)", is_offer: 0, showAll: 2, isSearch: 0)
        }
        else{
            self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(radius)", is_offer: 0, showAll: 2, isSearch: 1)
        }
        
       
    }
    
    func didSelectRadius(listNearby:[NearbyResultsModel]) {
        
        self.allStoresListv2 = listNearby
        self.collectionViewNearbyCell.reloadData()
//        self.getNearByStoresV2(lat: DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229, lng: DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829, mode: self.vehicleSelected ?? "", range: "\(radius ?? 0)", is_offer: 0, showAll: 2, isSearch: 1)
    }
    
    func didSelectWoloo(objNearbyResultsModel: NearbyResultsModel?) {
        selectedWolooGlobal = objNearbyResultsModel
        performSegue(withIdentifier: Constant.Segue.details, sender: objNearbyResultsModel)
    }
    
    
    func didClickedTakeMeHere(objNearbyResultsModel: NearbyResultsModel?){
        let objController = EnrouteViewController.init(nibName: "EnrouteViewController", bundle: nil)
        objController.vehicleSelected = self.vehicleSelected ?? ""
        objController.destLat = Double(objNearbyResultsModel?.lat ?? "")
        objController.destLong = Double(objNearbyResultsModel?.lng ?? "")
        objController.strIsComeFrom = "Navigation"
        objController.objNearbyResultsModel = objNearbyResultsModel ?? NearbyResultsModel()
        objController.strDestination = "\(objNearbyResultsModel?.name ?? "")"
        objController.sourceLat = self.searchedLat ?? 19.055229
        objController.sourceLong = self.searchedlong ?? 72.830829
        objController.isSearch = self.isSearch
        objController.wolooID = objNearbyResultsModel?.id
        self.navigationController?.pushViewController(objController, animated: true)
        
    }

}


// MARK: - Open other Controllers
extension DashboardVC {
      func openWahCerificateVC(store: WahCertificate) {
          let vc = ScanHostReviewVC(nibName: "ScanHostReviewVC", bundle: nil)
        //vc.store = store
        vc.objWahCertificate = store
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Dismiss WolooAlert
    @objc func dismissWolooAlertOnTap(_ gesture: UITapGestureRecognizer) {
        guard let overlayView = gesture.view else { return }
        let tapLocation = gesture.location(in: overlayView)
        
        // Find which view was actually tapped using hitTest
        let tappedView = overlayView.hitTest(tapLocation, with: nil)
        
        // Find the content popup view (FzQ-hO-6og) - this is the white popup
        guard overlayView.subviews.count > 0 else { return }
        let contentView = overlayView.subviews[0]
        
        // Check if the tapped view is the content view or one of its subviews
        var isContentTapped = false
        var view: UIView? = tappedView
        while view != nil {
            if view == contentView {
                isContentTapped = true
                break
            }
            view = view?.superview
        }
        
        // Only dismiss if tap is outside the content view
        if !isContentTapped {
            // Find the alert view (WolooAlert) by traversing up the view hierarchy
            // overlayView -> xibView -> alert (WolooAlert)
            var currentView: UIView? = overlayView.superview?.superview
            if let alert = currentView as? WolooAlert {
                alert.removeFromSuperview()
            }
        }
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
