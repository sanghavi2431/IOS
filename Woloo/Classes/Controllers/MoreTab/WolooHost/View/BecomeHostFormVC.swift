//
//  BecomeHostFormVC.swift
//  Woloo
//
//  Created on 25/04/21.
//

import UIKit
import CoreLocation
import GoogleMaps
import NVActivityIndicatorView
import Alamofire

class BecomeHostFormVC: UIViewController, SearchLocationEnrouteDelegate {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var successPopUp: UIView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwPhone: UIView!
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var mapView: MapContainerView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitleDesc: UILabel!
    @IBOutlet weak var btnOpenSearchLocation: UIButton!
    
    
    var imageList = [UIImage]()
    var location: CLLocationCoordinate2D?
    var address: String?
    var urlNameImage = [String]()
    var isReferHost = false
    var activityIndicatorView : NVActivityIndicatorView?
    var objWolooHostViewModel = WolooHostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
//        DELEGATE.rootVC?.tabBarVc?.showTabBar()
//        DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
//        DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        successPopUp.isHidden = true
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func removeViewAction(_ sender: UIButton) {
        successPopUp.isHidden = true
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func clickedOpenSearchLocation(_ sender: UIButton) {
        
        let objController = SearchLocationsViewController.init(nibName: "SearchLocationsViewController", bundle: nil)
        objController.delegate = self
        //self.strSource_Destination = SELCTED_ENROUTE_TYPE.SOURCE.rawValue
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    @objc func setupUI() {
        if isReferHost == true {
            self.imgView.image = UIImage(named: "icon_referWolooHost")
            self.lblTitleDesc.text = "Refer a business to become a Woloo Host and earn 50 Points instantly!"
            lblTitle.text = "Refer a Woloo Host"
            lblName.text = "Name"
            vwPhone.isHidden = false
           // vwAddress.isHidden = true
        } else {
            
            self.imgView.image = UIImage(named: "icon_wolooHost")
            lblTitleDesc.text = "Join the Woloo Family and turn your loo into a Woloo today!"
            lblTitle.text = "Become a Woloo Host"
            lblName.text = "Name"
            vwPhone.isHidden = true
            vwAddress.isHidden = false
        }
        self.objWolooHostViewModel.delegate = self
        mapView.delegate = self
        mapView.configureUI()
        
        cityTextField.delegate = self
        addressTextView.delegate = self
        zipCodeTextField.delegate = self
        setupCollection()
        DispatchQueue.main.async {
            if let currentLocation = DELEGATE.locationManager.location {
                self.location = currentLocation.coordinate
                self.mapView.addCustomMarker(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
                self.mapView.animate(toZoom: 20.0)
                self.mapView.animate(toLocation: currentLocation.coordinate)
            }
        }
        
    }
    
    func addWolooAPICall(){
        if isReferHost {
            self.objWolooHostViewModel.recommendWolooForHost(images: imageList, name:  self.nameTextField.text ?? "", address:  self.address ?? "", city: self.cityTextField.text ?? "", lat: self.location?.latitude ?? 0.0, long: self.location?.longitude ?? 0.0, pincode: self.zipCodeTextField.text ?? "", recommendedMobile: self.mobileTextField.text ?? "")
        }
        else{
            self.objWolooHostViewModel.addWolooForHost(images: imageList, name: self.nameTextField.text ?? "", address: self.address ?? "", city: self.cityTextField.text ?? "", lat: self.location?.latitude ?? 0.0, long: self.location?.longitude ?? 0.0, pincode: self.zipCodeTextField.text ?? "")
        }
    }
    
    @objc func showPopUp() {
        DispatchQueue.main.async {
            self.successPopUp.isHidden = false
        }
    }
    func showLoader() {
        var size = CGSize(width: 100, height: 100)
        var color = #colorLiteral(red: 1, green: 0.9407282472, blue: 0, alpha: 1)
        
        #if os(iOS)
        size = CGSize(width: 40, height: 40)
        color = #colorLiteral(red: 1, green: 0.9407282472, blue: 0, alpha: 1)
        #endif
        
        activityIndicatorView = NVActivityIndicatorView(
            frame: CGRect(x: (SCREENWIDTH()/2) - (size.width/2), y: (SCREENHEIGHT()/2) - (size.width/2), width: size.width, height: size.height),
            type: NVActivityIndicatorType.ballSpinFadeLoader,
            color: color,
            padding: 0)
        
        activityIndicatorView?.startAnimating()
        if let av = activityIndicatorView {
            view.addSubview(av)
        }
    }
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicatorView?.removeFromSuperview()
        }
    }
    func showSimpleAlert() {

        DispatchQueue.main.async {
            let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "Close", title: "", message: "Your request has been submitted successfully.", image: nil, controller: self)
            alert.cancelTappedAction = { [self] in
                alert.removeFromSuperview()
                if self.isReferHost {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            self.view.addSubview(alert)
            self.view.bringSubviewToFront(alert)
        }
    }
}

// MARK: - Actions
extension BecomeHostFormVC {
    
    func didSearchedPlace(lat: Double, long: Double, strPlace: String?, selectedCity: String) {
        print("Latitude: \(lat), longitude: \(long)")
        
        DispatchQueue.main.async {
            self.mapView.clear()
            self.mapView.addCustomMarker(lat: lat, long: long)
            let currentLocation = DELEGATE.locationManager.location
            self.location?.latitude = lat
            self.location?.longitude = long
            self.mapView.animate(toZoom: 20.0)
            self.mapView.animate(toLocation: (self.location ?? currentLocation?.coordinate)!)
            
            self.getAddressFromLatLon(latitude: Double(lat), withLongitude: Double(long))
        }
        
    }
    
    
    
    
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        //        Your request has been submitted successfully
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if (self.nameTextField.text?.isEmpty ?? true) {
            self.showToast(message: "Enter woloo name.")
            return
        } else if (self.cityTextField.text?.isEmpty ?? true) {
            self.showToast(message: "Enter city.")
            return
        } else if (self.zipCodeTextField.text?.isEmpty ?? true) {
            self.showToast(message: "Enter zipcode.")
            return
        } else if (address?.isEmpty ?? true) && location != nil {
            self.showToast(message: "Enter address.")
            return
        } 
        else if imageList.count == 0 {
            self.showToast(message: "Add atleast one Image.")
            return
        } 
        else if (mobileTextField.text?.count ?? 0) != 10 && isReferHost {
            self.showToast(message: "Enter valid mobile number.")
            return
        }
       // showLoader()
        var createURlImage = [String]()
        createURlImage.removeAll()
        if self.imageList.count >= 1{
            self.addWolooAPICall()
            
        }
    }
    
    @IBAction func mapLocationAction(_ sender: Any) {
        if let currentLocation =  DELEGATE.locationManager.location {
            self.mapView.clear()
            self.mapView.addCustomMarker(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
            mapView.animate(toLocation: currentLocation.coordinate)
            mapView.animate(toZoom: 20.0)
        }
    }
}


// MARK: - UICollectionViewDelegate/ UICollectionViewDataSource
extension BecomeHostFormVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCollection() {
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        let layOut = UICollectionViewFlowLayout()
        layOut.itemSize = CGSize(width: 100, height: 100)//CGSize(width:width, height: self.photoCollectionView.bounds.size.height)
        layOut.minimumInteritemSpacing = 38
        layOut.scrollDirection = .horizontal
        photoCollectionView.collectionViewLayout = layOut
        self.photoCollectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.photoCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count == 2 ? imageList.count : imageList.count > 1 ? imageList.count + 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        fillImageCell(cell, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.imageList.count == 2 {
            return
        }
        if imageList.count + 1 == indexPath.item || imageList.count == 0 {
            openImagePicker()
        } else if imageList.count < 2 && imageList.count == indexPath.item {
            openImagePicker()
        }
        
    }
}

// MARK: - Logics
extension BecomeHostFormVC {
    func fillImageCell(_ cell: ImageCell,_ indexPath: IndexPath) {
        if indexPath.item < imageList.count && (imageList.count + 1) != indexPath.item {
            cell.imageView.image = imageList[indexPath.item]
            cell.plusPlaceHolderImage.isHidden = true
            cell.buttonView.isHidden = false
            cell.imageView.backgroundColor = .clear
        } else if (imageList.count)+1 == indexPath.item {
            cell.buttonView.isHidden = true
            cell.imageView.image = nil
            cell.plusPlaceHolderImage.isHidden = false
            cell.imageView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        } else {
            cell.imageView.image = nil
            cell.buttonView.isHidden = true
            cell.plusPlaceHolderImage.isHidden = false
            cell.imageView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        }
        
        // Handle deleted image from List.
        cell.deleteImageHandler = { [weak self] (index) in
            guard let self = self else { return }
            self.imageList.remove(at: index ?? 0)
            self.photoCollectionView.reloadData()
        }
    }
    
    /// Open Image picker for select image.
    func openImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    
    /// This method return Location Detail from Coordinates.
    /// - Parameters:
    ///   - name: Define Name of place,street,..etc.
    ///   - completion: CLplacemark,Error
    func latlongFromAddress(name: String,completion:@escaping (_ place: CLLocation?,_ error: Error?) -> Void = {_,_   in }) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(name) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                completion(nil,error)
                return
            }
            completion(location,error)
            // Use your location
        }
    }
    
    
    /// Retrive Address Detail from latitude and longtitude
    /// - Parameters:
    ///   - pdblLatitude: Define Latitude
    ///   - pdblLongitude: Define Longtitude
    ///   - completion: return timezone and Place detail
    func getAddressFromLatLon(latitude: Double, withLongitude longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = latitude
        //21.228124
        let lon: Double = longitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, preferredLocale: Locale.current, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            self.address = ""
                                            self.addressTextView.text = ""
                                            self.cityTextField.text = ""
                                            self.zipCodeTextField.text = ""
                                            print(error?.localizedDescription ?? "")
                                            return
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        if pm.count > 0 {
                                            let pm = placemarks![0] // Add Data on adress Labels.
                                            DispatchQueue.main.async {
                                                self.address = pm.compactAddress
                                                self.addressTextView.text = "\(self.address ?? ""), \(pm.postalAddress?.city ?? ""), \(pm.postalAddress?.postalCode ?? "")"
                                                self.cityTextField.text = pm.postalAddress?.city
                                                self.zipCodeTextField.text = pm.postalAddress?.postalCode
                                            }
                                        }
                                    })
        
    }
    
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension BecomeHostFormVC: UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let resizingImage = pickedImage.resizeImage(targetSize: CGSize(width: 1024, height: 768)) {
                self.imageList.append(resizingImage)                
            }
            self.photoCollectionView.reloadData()
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - GMSMapViewDelegate
extension BecomeHostFormVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        self.mapView.addCustomMarker(lat: coordinate.latitude, long: coordinate.longitude)
        
        self.location = coordinate
        self.getAddressFromLatLon(latitude: Double(coordinate.latitude), withLongitude: Double(coordinate.longitude))
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.mapView.clear()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.mapView.clear()
        self.mapView.addCustomMarker(lat: position.target.latitude, long: position.target.longitude)
        self.location = position.target
        self.getAddressFromLatLon(latitude: Double(location?.latitude ?? 0.0), withLongitude: Double(location?.longitude ?? 0.0))
    }
}

// MARK: - UITextFieldDelegate
extension BecomeHostFormVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(cityTextField.text?.isEmpty ?? false) && !(zipCodeTextField.text?.isEmpty ?? false) {
            let completeAddress = "\(cityTextField.text ?? ""),\(addressTextView.text ?? ""),\(zipCodeTextField.text ?? "")"
            self.address = addressTextView.text ?? ""
            self.latlongFromAddress(name: completeAddress) { (location, error) in
                if let currentLocation =  location {
                    self.location = currentLocation.coordinate
                    self.mapView.animate(toZoom: 20.0)
                    self.mapView.animate(toLocation: currentLocation.coordinate)
                }
            }
        }
    }
}
// MARK: - UITextViewDelegate
extension BecomeHostFormVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textField: UITextView) {
        if !(addressTextView.text?.isEmpty ?? false) {
            let completeAddress = "\(cityTextField.text ?? ""),\(addressTextView.text ?? ""),\(zipCodeTextField.text ?? "")"
            self.address = addressTextView.text ?? ""
            self.latlongFromAddress(name: completeAddress) { (location, error) in
                if let currentLocation =  location {
                    self.location = currentLocation.coordinate
                    DispatchQueue.main.async {
                        self.mapView.animate(toLocation: currentLocation.coordinate)
                    }
                }
            }
        }
    }
}

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}

// MARK: - API's
extension BecomeHostFormVC: WolooHostViewModelDelegate {
    
    //MARK: - WolooHostViewModelDelegate
    func didAddWolooResponse(objResponse: BaseResponse<StatusSuccessResponseModel>) {
        print("Add woloo success: ", objResponse.results.message ?? "")
        self.showToast(message: objResponse.results.message ?? "")
        self.navigationController?.popViewController(animated: true)
       // self.showSimpleAlert()
        self.hideLoader()
    }
    
    func didAddWolooError(strError: String) {
        self.showToast(message: strError)
        self.hideLoader()
    }
}
