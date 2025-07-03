//
//  MapCell.swift
//  Woloo
//
//  Created by Ashish Khobragade on 24/12/20.
//

import UIKit
import GoogleMaps

//protocol AnimationProtocol:class {
//    func didTapExpandContractButton(_ isExpand: Bool)
//    func didTapMarker(_ marker: GMSMarker)
//    func selectedModeforTransport(mode: TransportMode)
//}
//

class MapCell: UITableViewCell {

    @IBOutlet weak var mapContainerView: MapContainerView!
    @IBOutlet weak var expandContractButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var vehicleOpen185Width: NSLayoutConstraint!
    @IBOutlet weak var vehicleOptionButton: UIButton!
    @IBOutlet weak var walkImageView: UIImageView!
    //@IBOutlet weak var bicycleImageView: UIImageView!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var HostLabel: UILabel!
    @IBOutlet weak var dashButton: UIButton!
    
    weak var delegate:AnimationProtocol?
    var vehicleSelected: TransportMode? = .car
    var isExpand = false
    var nearByStoreResponseDO:NearByStoreResponse?{
        didSet {
            if (nearByStoreResponseDO?.stores?.count ?? 0) > 0 {
                dashButton.titleEdgeInsets = !isExpand ? .zero : UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0) 
                dashButton.titleLabel?.numberOfLines = 0
                dashButton.titleLabel?.textAlignment = .center
                dashButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: !isExpand ? 38 : 14)
                dashButton.setTitleColor(UIColor.main, for: .normal)
                dashButton.setTitle(!isExpand ? "-" : "-\n Woloo-Hosts near you", for: .normal)
            }
            mapContainerView.nearByStoreResponseDO = nearByStoreResponseDO
            mapContainerView.addAllMarkers()
        }
    }
    
    var nearByStoreResponseDoV2: [NearbyResultsModel]?{
        
        didSet {
            if (nearByStoreResponseDoV2?.count ?? 0) > 0 {
                dashButton.titleEdgeInsets = !isExpand ? .zero : UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
                dashButton.titleLabel?.numberOfLines = 0
                dashButton.titleLabel?.textAlignment = .center
                dashButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: !isExpand ? 38 : 14)
                dashButton.setTitleColor(UIColor.main, for: .normal)
                dashButton.setTitle(!isExpand ? "-" : "-\n Woloo-Hosts near you", for: .normal)
            }
            mapContainerView.nearByStoreResponseDOV2 = nearByStoreResponseDoV2
            mapContainerView.addAllMarkersV2()
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureUI()  {
    
        fillButton(mode: vehicleSelected ?? .car)
        // make all button round.
        self.optionView.layer.cornerRadius = 25
        self.optionView.clipsToBounds = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        if let currentLocation = DELEGATE.locationManager.location {
            mapContainerView.currentPosition = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        } else {
//            mapContainerView.currentPosition = CLLocationCoordinate2D(latitude: 18.925164, longitude: 72.832225)
        }
        mapContainerView.delegate = self
        mapContainerView.configureUI()
    }
    
    @IBAction func didTapExpandContractButton(sender:UIButton) {
        isExpand = !isExpand
       // delegate?.didTapExpandContractButton(isExpand)
    }
    
    @IBAction func optionSelectAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.vehicleOpen185Width.constant = self.vehicleOpen185Width.constant == 185 ? 0 : 185
            self.layoutIfNeeded()
        } completion: {_ in }

        if let button = sender as? UIButton, button.tag >= 0 && button.tag <= 2 {
            fillButton(mode: TransportMode.init(rawValue: button.tag) ?? .car)
           // delegate?.selectedModeforTransport(mode: TransportMode.init(rawValue: button.tag) ?? .car)
        }
    }
    
    func fillButton(mode: TransportMode) { // Change images for selected mode.
        self.vehicleOptionButton.setImage( mode.fillImage, for: .normal)
        self.carImageView.image = mode == .car ? mode.fillImage: TransportMode.car.unfillImage
        self.walkImageView.image = mode == .walking ? mode.fillImage: TransportMode.walking.unfillImage
        //self.bicycleImageView.image = mode == .bicycle ? mode.fillImage: TransportMode.bicycle.unfillImage
    }
}

// MARK: - GMSMapViewDelegate

extension MapCell:GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    
        print("marker location - \(marker.title ?? ""): <\(marker.position.latitude), \(marker.position.longitude)>")
        delegate?.didTapMarker(marker)
        return true
    }
    
    /// make button title label for shutter with woloo store title
   /* private func addAttributeString(text: String, font: UIFont) -> NSAttributedString {
        let atrString = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.main]
        return atrString
    }*/
}
