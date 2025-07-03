//
//  ReachabilityManager.swift
//  PublicamPlus
//
//  Created by Ashish.Khobragade on 11/07/18.
//  Copyright © 2018 Ashish.Khobragade. All rights reserved.
//

import UIKit

public protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: Reachability.Connection)
}


class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()
  
    static let sharedNoInternetConnectionView = getNOInternetConnectionView()
 
    let reachability = Reachability()!
 
    
    var reachabilityStatus: Reachability.Connection = Reachability()!.connection

    var listeners = [NetworkStatusListener]()
    
    @objc func reachabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
            
        case .none:
            debugPrint("Network became unreachable")
        case .wifi:
            debugPrint("Network reachable through WiFi")
        case .cellular:
            debugPrint("Network reachable through Cellular Data")
        }
       
        reachabilityStatus  = reachability.connection
        
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
        }
    }
    
    func startMonitoring() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring(){
        
        reachability.stopNotifier()
        
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
    
    func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    
    func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }

  
    private static func getNOInternetConnectionView()  -> UIView {
        
        #if os(iOS)
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("NoInternetConnectionView", owner: self, options: nil)
        
        let myView = allViewsInXibArray?.first as! NoInternetConnectionView
        
        myView.noInternetAvailableLabel.text = "NO internet connection"//LocalizedString(key:StringConstants.networkMessage, value: "")
        
        myView.tapToRetryLabel.text = ""
        
        myView.frame = UIScreen.main.bounds
        
        return myView
        
        #else
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("NoInternetConnectionViewTV", owner: self, options: nil)
        
        let myView = allViewsInXibArray?.first as! NoInternetConnectionView
        
        myView.noInternetAvailableLabel.text = LocalizedString(key: StringConstants.networkMessageTV, value: "")
        
        myView.frame = UIScreen.main.bounds
        
        return myView
        
        #endif
    }
    
 
}
