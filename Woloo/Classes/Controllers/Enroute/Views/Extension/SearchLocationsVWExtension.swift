//
//  SearchLocationsVWExtension.swift
//  Woloo
//
//  Created by Kapil Dongre on 18/11/24.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

extension SearchLocationsViewController: UITableViewDelegate, UITableViewDataSource{
   
    
    //MARK: - UITableView Delegate and UITableView data source mthods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            var cell: SearchTxtFieldCell? = tableView.dequeueReusableCell(withIdentifier: "SearchTxtFieldCell") as! SearchTxtFieldCell?
            if cell == nil{
                cell = (Bundle.main.loadNibNamed("SearchTxtFieldCell", owner: self, options: nil)?.last as? SearchTxtFieldCell)
            }
            cell?.configureSearchTxtFieldCell(strTxt: self.searchList?[indexPath.row] as? String ?? "")
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell!
        }
        return UITableViewCell()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCity = "\(searchList?[indexPath.row] ?? "")"
        getPlaceDetails(result: placeResult[indexPath.row])
        
    }
    
    
    func getPlaceDetails(result: GMSAutocompletePrediction) {
        Global.showIndicator()
        //let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.addressComponents.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
        
        let fields = GMSPlaceField(rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.placeID.rawValue | GMSPlaceField.addressComponents.rawValue | GMSPlaceField.coordinate.rawValue | GMSPlaceField.formattedAddress.rawValue )
        
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

                if let addressComponents = place.addressComponents {
                    for component in addressComponents {
                        if component.types.contains("sublocality") || component.types.contains("sublocality_level_1") {
                            self.selectedLocality = component.name
                        }
                        if component.types.contains("locality") {
                            self.selectedCity = component.name
                        }
                        if component.types.contains("administrative_area_level_1") {
                            self.selectedState = component.name
                        }
                        if component.types.contains("postal_code") {
                            self.postalCode = component.name
                        }
                    }
                    let buildingName = place.name ?? ""
                    let fullAddress = place.formattedAddress ?? ""
                    print("Flat / Building Name: \(buildingName)")
                    print("Locality: \(self.selectedLocality ?? "")")
                    print("City: \(self.selectedCity ?? "")")
                    print("State: \(self.selectedState ?? "")")
                    print("Pincode: \(self.postalCode ?? "")")
                    print("Full Address: \(fullAddress)")
                    self.strBuldingName = buildingName
                    self.strFullAddress = fullAddress
                }
                
                
                    
                    print("searched place lat and long \(place.coordinate.latitude) & \(place.coordinate.longitude)")
                        self.searchedLat = place.coordinate.latitude
                self.searchedLong = place.coordinate.longitude
            
                if ((self.delegate) != nil){
                    
                    self.delegate?.didSearchedPlace(lat: self.searchedLat ?? 0, long: self.searchedLong ?? 0, strPlace: self.selectedCity, selectedCity: self.selectedLocality ?? "",strBuildingName: self.strBuldingName ?? "", strLocality: self.selectedLocality, strCity: self.selectedCity, strState: self.selectedState,strPincode: self.postalCode ?? "", strFullAddress: self.strFullAddress)
                    self.navigationController?.popViewController(animated: true)
                }
                else if self.delegateForStoreAddress != nil{
                    self.delegateForStoreAddress?.didSearchedPlace(strBuildingName: self.strBuldingName ?? "", strLocality: self.selectedLocality, strCity: self.selectedCity, strState: self.selectedState,strPincode: self.postalCode ?? "", strFullAddress: self.strFullAddress)
                }
            }
        })
        
        self.navigationController?.popViewController(animated: true)
        
    }
}

