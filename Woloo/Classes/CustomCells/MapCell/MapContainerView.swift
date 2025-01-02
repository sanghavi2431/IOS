//
//  MapContainerView.swift
//  Woloo
//
//  Created by Ashish Khobragade on 23/12/20.
//

import UIKit
import GoogleMaps

class MapContainerView:GMSMapView  {

    var currentPosition:CLLocationCoordinate2D?//set default position here
    var nearByStoreResponseDO:NearByStoreResponse?
     
    var nearByStoreResponseDOV2: [NearbyResultsModel]?
    
    var enrouteResponse: [EnrouteListModel]?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    public func configureUI()  {
       // guard let currentPosition = currentPosition else { return }
        let currentPosition = currentPosition
        //ijf loacation is off enetr lat and long of mumbai
        
        print("currentPosition.latitude: \(currentPosition?.latitude), currentPosition.longitude: \(currentPosition?.longitude)")
        let camera = GMSCameraPosition(latitude: currentPosition?.latitude ?? 19.055229, longitude: currentPosition?.longitude ?? 72.830829, zoom: 14)
        self.camera = camera
        self.isMyLocationEnabled = true
//        self.settings.myLocationButton = true
//        self.settings.compassButton = true
        self.padding = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }

    
    
    // MARK: - Marker Methods
    
     func addCustomMarker(lat:Double,long:Double,name:String = "",index:Int = 0) {
      // Add a custom 'glow' marker around Sydney.
      let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:lat, longitude: long))
         print("add custom marker title: \(name)")
        marker.title = name
        marker.appearAnimation = .pop
        marker.icon = UIImage(named: "storeMarker")
        marker.rotation = Double.random(in: -10...10)
        marker.map = self
        marker.zIndex = Int32(index)
    }
    
    func addDestinationMarker(lat:Double,long:Double,name:String = "",index:Int = 0) {
     // Add a custom 'glow' marker around Sydney.
     let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:lat, longitude: long))
       marker.title = name
       marker.appearAnimation = .pop
       marker.icon = UIImage(named: "30x30pxdestinationMarker")
       marker.rotation = Double.random(in: -10...10)
       marker.map = self
       marker.zIndex = Int32(index)
   }
    
    
    func addCurrentPositionMarker(currentPosition: CLLocationCoordinate2D) {
      let marker = GMSMarker(position: currentPosition)
        marker.title = "Current Location"
        marker.icon = UIImage(named: "glow-marker")
        marker.rotation = Double.random(in: -10...10)
        marker.map = self
    }
 
    func addAllMarkers() {
        self.clear()
       
        if let currentPosition = currentPosition{
           // self.addCurrentPositionMarker(currentPosition: currentPosition)
        }
        
        guard let stores = nearByStoreResponseDO?.stores else { return }

        for (index,item) in stores.enumerated() {
            
            if let lattitue = item.lat,let lat = Double(lattitue),let longitude = item.lng,let long = Double(longitude){
               
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index + 1) * 0.25, execute: {
                    
                    self.addCustomMarker(lat:lat, long: long, name: item.name ?? "",index: index)
                })
            }
        }
    }
    
    func addAllMarkersV2(){
        self.clear()
       
//        if let currentPosition = currentPosition{
//            self.addCurrentPositionMarker(currentPosition: currentPosition)
//        }
        
        guard let stores = nearByStoreResponseDOV2 else { return }

        for (index,item) in stores.enumerated() {
            
            if let lattitue = item.lat,let lat = Double(lattitue),let longitude = item.lng,let long = Double(longitude){
               
//                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index + 1) * 0.25, execute: {
//
//                    self.addCustomMarker(lat:lat, long: long, name: item.name ?? "",index: index)
//                })
                
                DispatchQueue.main.async {
                    self.addCustomMarker(lat:lat, long: long, name: item.name ?? "",index: index)
                }
            }
        }
    }
    
    
    func addEnrouteMarkers(){
//        self.clear()
       
//        if let currentPosition = currentPosition{
//            self.addCurrentPositionMarker(currentPosition: currentPosition)
//        }
        
        //guard let stores = nearByStoreResponseDOV2 else { return }

        
        print("near by stores response on enroute function: \(nearByStoreResponseDOV2)")
        guard let stores = nearByStoreResponseDOV2 else {return}
        
        for (index,item) in stores.enumerated() {
            
            if let lattitue = item.lat,let lat = Double(lattitue),let longitude = item.lng,let long = Double(longitude){
               
//                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index + 1) * 0.25, execute: {
//
//                    self.addCustomMarker(lat:lat, long: long, name: item.name ?? "",index: index)
//                })
                
                
                DispatchQueue.main.async {
                    print("store Name added on markers: \(item.name ?? "")")
                    self.addCustomMarker(lat:lat, long: long, name: item.name ?? "",index: index)
                }
            }
        }
    }
}

