//
//  SearchLocationsViewController.swift
//  Woloo
//
//  Created by Kapil Dongre on 18/11/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

protocol SearchLocationEnrouteDelegate: NSObjectProtocol
{
    
    func didSearchedPlace(lat: Double, long: Double, strPlace: String?, selectedCity: String)
}

class SearchLocationsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtFieldSearchLocation: UITextField!
    
    
    var searchList: [Any]?
    var placeResult = [GMSAutocompletePrediction]()
    var googleToken: GMSAutocompleteSessionToken?
    var selectedPlace : GMSPlace?
    var searchedLat, searchedLong: Double?
    var delegate: SearchLocationEnrouteDelegate?
    var selectedCity: String? = ""
    var selectedLocality: String? = ""
    var postalCode: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }


    func loadInitialSettings(){
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.txtFieldSearchLocation.delegate = self
        
        self.txtFieldSearchLocation.addTarget(self, action: #selector(textDidChangedLocation(_:)), for: .editingChanged)
    }

    
    //MARK: - Buttonm Action methods:
    
    @IBAction func clickedBackbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
    
    @objc func textDidChangedLocation(_ textField: UITextField) {
        self.searchPlaces(text: textField.text ?? "")
        
        if textField.text?.count == 0 {
            
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Search places
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
            self.tableView.reloadData()
        }
    }
}
