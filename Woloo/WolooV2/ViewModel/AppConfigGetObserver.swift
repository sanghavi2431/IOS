//
//  AppConfigGetObserver.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation
import UIKit

class AppConfigGetObserver: BaseObservableObject{
    
    var appConfigGetObserver: AppCofigGetModel? = nil
    
    func appConfigGet(){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        //MARK: Network Call
        
       let localeData = [ "language" : "en",
                      "platform" : "ios",
                      "country" : "IN",
                      "segment" : "",
                      "version" : "1",
                      "packageName":"in.woloo.www"] as [String : String]
        
        
        
        
        let data = ["locale": localeData] as [String : Any]
        
        //http://13.127.174.98/api/wolooGuest/appConfig
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data, headers: headers, url: nil, service: .appConifgGet, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<AppCofigGetModel>, Error>) in
            switch result{
                
            case .success(let response):
                self.appConfigGetObserver = response.results
                print("App Config get response: ",response)
                UserDefaultsManager.storeAppConfigData(value: response.results)
            
                
            case .failure(let error):
                print("App config error", error)
                
            }
        }
    }
}

