//
//  DashboardMapBottomSheetVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 25/01/25.
//

import UIKit


protocol DashboardBottomSheetDelegate: NSObjectProtocol{
    
    func didSelectRadius(radius: Int)
    func didSelectWoloo(objNearbyResultsModel: NearbyResultsModel?)
    func didClickedTakeMeHere(objNearbyResultsModel: NearbyResultsModel?)
    
}

class DashboardMapBottomSheetVC: UIViewController {
    
    
 
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnOpenNow: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnOffer: UIButton!
    
    
    @IBOutlet weak var vwBackOpenNow: ShadowView!
    @IBOutlet weak var vwBackBookMark: ShadowView!
    @IBOutlet weak var vwBackIsOffer: ShadowView!
    
    @IBOutlet weak var distanceCollectionView: UICollectionView!
    
    
    var allStoresList = [NearbyResultsModel]()
    weak var delegate: DashboardBottomSheetDelegate?
    var lat: Double?
    var lng: Double?
    var cpyAllStoresList = [NearbyResultsModel]()
    var vehicleSelected: String? = ""
    var range: String? = ""
    var selectedIndex: Int? = 0
    var kms = ["2 km","4 km","5 km","6 km"]
    var rangeSelected: Int? = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
        print("Selected Range", self.rangeSelected ?? 0)
    }

    func loadInitialSettings(){
        self.cpyAllStoresList = self.allStoresList
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.distanceCollectionView.delegate = self
        self.distanceCollectionView.dataSource = self
        
        self.distanceCollectionView.register(DistannceBottomCollectionViewCell.nib, forCellWithReuseIdentifier: DistannceBottomCollectionViewCell.identifier)
        
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
        
        if let rangeValue = rangeSelected {
            let match = "\(rangeValue) km"
            if let index = kms.firstIndex(of: match) {
                selectedIndex = index
            }
        }

        distanceCollectionView.reloadData()

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    //MARK: -  Button action methods
    @IBAction func clickedbtn2kms(_ sender: UIButton) {
        
        self.getNearByStoresV2(lat: self.lat ?? 0.0, lng: self.lng ?? 0.0, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
        
        
       
        //self.dismiss(animated: true)
    }
    
    @IBAction func clickedBtn4kms(_ sender: UIButton) {
        
       // self.getNearByStoresV2(lat: self.lat ?? 0.0, lng: self.lng ?? 0.0, mode: self.vehicleSelected ?? "", range: "4", is_offer: 0, showAll: 2, isSearch: 0)
        
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 4)
        }
       // self.dismiss(animated: true)
    }
    
    
    @IBAction func clicked8Btnkms(_ sender: UIButton) {
        
        //self.getNearByStoresV2(lat: self.lat ?? 0.0, lng: self.lng ?? 0.0, mode: self.vehicleSelected ?? "", range: "6", is_offer: 0, showAll: 2, isSearch: 0)
        
        
        if (self.delegate != nil){
            self.delegate?.didSelectRadius(radius: 6)
        }
        //self.dismiss(animated: true)
    }
   
    
    
    @IBAction func clickedBtnDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func clickedOpenNow(_ sender: UIButton) {
        
        let filteredList = btnOpenNow.isSelected
               ? cpyAllStoresList.filter { $0.is_open == 0 }
               : cpyAllStoresList.filter { $0.is_open == 1 }

           // Ensure the count is >= 1 before allowing selection
//           if filteredList.count >= 1 {
               btnOpenNow.isSelected.toggle() // Toggle selection state
               allStoresList = filteredList // Update the list
//           } else {
//               btnOpenNow.isSelected = false // Force unselect if no data
//           }

           // Update background color based on the button state
           self.vwBackOpenNow.backgroundColor = btnOpenNow.isSelected ? UIColor(hexString: "D7D7D7") : UIColor(hexString: "FFEB00")

           self.tableView.reloadData()
    }
    
  
    @IBAction func clickedBookmarkBtn(_ sender: UIButton) {
        let filteredList = btnBookmark.isSelected
                ? cpyAllStoresList.filter { $0.is_liked == 0 }
                : cpyAllStoresList.filter { $0.is_liked == 1 }

            // Ensure there is at least one result before toggling selection
//            if filteredList.count >= 1 {
                btnBookmark.isSelected.toggle() // Toggle selection state
                allStoresList = filteredList // Update the list
//            } else {
//                btnBookmark.isSelected = false // Prevent selection if no results
//            }

            // Update background color based on the button state
            self.vwBackBookMark.backgroundColor = btnBookmark.isSelected ? UIColor(hexString: "D7D7D7") : UIColor(hexString: "FFEB00")

            self.tableView.reloadData()
    }
    
    @IBAction func clickedBtnOffer(_ sender: UIButton) {
        let filteredList = btnOffer.isSelected
                ? cpyAllStoresList
                : cpyAllStoresList.filter { $0.is_offer == 1 }

            // Ensure there is at least one result before toggling selection
//            if filteredList.count >= 1 {
                btnOffer.isSelected.toggle() // Toggle selection state
                allStoresList = filteredList // Update the list
//            } else {
//                btnOffer.isSelected = false // Prevent selection if no results
//            }

            // Update background color based on selection
            self.vwBackIsOffer.backgroundColor = btnOffer.isSelected ? UIColor(hexString: "D7D7D7") : UIColor(hexString: "FFEB00")

            self.tableView.reloadData()
    }
    
}

extension DashboardMapBottomSheetVC: UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate, UITableViewDataSource, ShowMoreTableCellDelegate{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return kms.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DistannceBottomCollectionViewCell.identifier, for: indexPath) as? DistannceBottomCollectionViewCell ?? DistannceBottomCollectionViewCell()
        //background: #D9D9D9;

        //#FAEB2C
        
        cell.backgroundColor = selectedIndex == indexPath.row ? UIColor(hexString: "#FAEB2C") : UIColor(hexString: "#D9D9D9")
        cell.distanceTxtLbl.text = kms[indexPath.item]
        // 🔑 Corner radius
           cell.layer.cornerRadius = 5
           cell.layer.masksToBounds = true  // ensures corners are clipped
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("following tag is selected \(indexPath.item)")
        selectedIndex = indexPath.row
        
        self.distanceCollectionView.reloadData()
        switch indexPath.item {
            
        case 0:
            print("2 kms")
        
            self.getNearByStoresV2(lat: self.lat ?? 0.0, lng: self.lng ?? 0.0, mode: self.vehicleSelected ?? "", range: "2", is_offer: 0, showAll: 2, isSearch: 0)
            if (self.delegate != nil){
                self.delegate?.didSelectRadius(radius: 2)
            }
        case 1:
            print("4 kms")
            self.getNearByStoresV2(lat: self.lat ?? 0.0, lng: self.lng ?? 0.0, mode: self.vehicleSelected ?? "", range: "4", is_offer: 0, showAll: 2, isSearch: 0)
            if (self.delegate != nil){
                self.delegate?.didSelectRadius(radius: 4)
            }
            
        case 2:
            print("5 kms")
            self.getNearByStoresV2(lat: self.lat ?? 0.0, lng: self.lng ?? 0.0, mode: self.vehicleSelected ?? "", range: "5", is_offer: 0, showAll: 2, isSearch: 0)
            if (self.delegate != nil){
                self.delegate?.didSelectRadius(radius: 6)
            }
            
        case 3:
            print("6 kms")
            self.getNearByStoresV2(lat: self.lat ?? 0.0, lng: self.lng ?? 0.0, mode: self.vehicleSelected ?? "", range: "6", is_offer: 0, showAll: 2, isSearch: 0)
            if (self.delegate != nil){
                self.delegate?.didSelectRadius(radius: 8)
            }
            
        case 4:
            print("10 kms")
            self.getNearByStoresV2(lat: self.lat ?? 0.0, lng: self.lng ?? 0.0, mode: self.vehicleSelected ?? "", range: "8", is_offer: 0, showAll: 2, isSearch: 0)
            if (self.delegate != nil){
                self.delegate?.didSelectRadius(radius: 8)
            }
            
        case 5:
            print("25 kms")
            self.getNearByStoresV2(lat: self.lat ?? 0.0, lng: self.lng ?? 0.0, mode: self.vehicleSelected ?? "", range: "25", is_offer: 0, showAll: 2, isSearch: 0)
            if (self.delegate != nil){
                self.delegate?.didSelectRadius(radius: 25)
            }
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
    
    //MARK: - ShowMoreTableCellDelegate
    func didSelectTakeMeHere(objNearbyResultsModel: NearbyResultsModel?) {
        if (self.delegate != nil){
            self.delegate?.didClickedTakeMeHere(objNearbyResultsModel: objNearbyResultsModel)
            self.dismiss(animated: true)
        }
    }
    

    
    //MARK: - UITableViewDelegate & UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.allStoresList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ShowMoreTableCell? = tableView.dequeueReusableCell(withIdentifier: "ShowMoreTableCell") as! ShowMoreTableCell?
        
        if cell == nil {
            cell = (Bundle.main.loadNibNamed("ShowMoreTableCell", owner: self, options: nil)?.last as? ShowMoreTableCell)
        }
        cell?.delegate = self
        cell?.configureShowMoreTableCell(objNearbyResultsModel: self.allStoresList[indexPath.row], strTransportType: self.vehicleSelected)
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       if (self.delegate != nil){
           self.delegate?.didSelectWoloo(objNearbyResultsModel: allStoresList[indexPath.row])
           self.dismiss(animated: true)
        }
    }
    
    //MARK: - API Call
    func getNearByStoresV2(lat: Double, lng: Double, mode: String, range: String, is_offer: Int, showAll: Int, isSearch: Int){
        
      
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
              
                Global.hideIndicator()
                //if let response = response{
                print(response.results.count ?? 0)
             
                self.allStoresList = response.results
                
              
                self.tableView.reloadData()
                
            case .failure(let error):
                Global.hideIndicator()
               
            }
        }
    }
    
}
