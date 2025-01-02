//
//  NearbyWolooObserver.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation
import UIKit


class NearbyWolooObserver: BaseObservableObject{
    
    var nearbyWolooObserver: [NearbyResultsModel]? = nil
    
    var allCustomList: [NearbyResultsModel]? = nil

    func getNearbyWoloo(lat: Double, lng: Double, mode: Int, range: String,is_offer: Int){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        //MARK: Network Call
        
        let data = ["lat": lat, "lng": lng, "mode": mode, "range": range,"is_offer": is_offer ] as [String : Any]
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .nearByWoloo, method: .post, isJSONRequest: true).executeQuery {(result: Result<BaseResponse<[NearbyResultsModel]>, Error>) in
            switch result{
            case .success(let response):
                self.nearbyWolooObserver = response.results
                print("NearbyWolooV2 Response: ",response)
                
                print("Near By woloo host count: \(self.nearbyWolooObserver?.count ?? 0)")
                
                self.allCustomList?.append(contentsOf: response.results)
              
            case .failure(let error):
                print("NearByWoloo Error",error)
            }
        }
        
    }
    
}

