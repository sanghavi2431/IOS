//
//  Utils.swift
//  Woloo
//
//  Created by Charmi on 29/07/21.
//

import Foundation
import UIKit
import AVFoundation
import SystemConfiguration

class Utils: NSObject {
    static let shared = Utils()
    //    var OrderArray = [ObjOrderInfo]()
}
// MARK: - UserDefault Functions
extension Utils {
    class func saveDataToUserDefault(_ data: Any, _ key: String) {
        let archived = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(archived, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getDataFromUserDefault(_ key: String) -> Any? {
        guard let archived =  UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: archived as? Data ?? Data())
    }
    
    class func removeDataFromUserDefault(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    class func saveData(_ value: Any?, forKey key: String?) {
        UserDefaults.standard.set(value, forKey: key ?? "")
    }
    
    class func getDataForKey(_ key: String?) -> Any? {
        return UserDefaults.standard.object(forKey: key ?? "")
    }
    
//    class func setSortingOrder(_ value: AppSorting) {
//        UserDefaults.standard.set(value.rawValue, forKey: appSortingOrder)
//    }
//    
//    class func getSortingOrder() -> AppSorting {
//        return AppSorting(rawValue: UserDefaults.standard.integer(forKey: appSortingOrder)) ?? .date
//    }
//    
//    class func isByPassed() -> Bool {
//        let isByPassed = Utils.getDataForKey(byPassedSerialNumber)
//        if isByPassed == nil {
//            return false
//        } else {
//            return true
//        }
//    }
}

extension Utils {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}

extension Utils {
    class func alert(message: String, title: String? = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil)
            alert.addAction(action)
            alert.show()
        }
    }
}

// MARK: - Alert Extension
private var kAlertControllerWindow = "kAlertControllerWindow"
extension UIAlertController {
    
    var alertWindow: UIWindow? {
        get {
            return objc_getAssociatedObject(self, &kAlertControllerWindow) as? UIWindow
        }
        set {
            objc_setAssociatedObject(self, &kAlertControllerWindow, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func show() {
        show(animated: true)
    }
    
    func show(animated: Bool) {
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = UIWindow.Level.alert + 1
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.present(self, animated: animated, completion: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertWindow?.isHidden = true
        alertWindow = nil
    }
    
}

