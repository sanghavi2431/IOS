//
//  Global.swift
//  JetLive
//
//  Created by Ashish Khobragade on 16/10/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase
import Foundation
import SmartPush
import Smartech

class Global: NSObject {
    
    static var showIndicatorCount = 0
    
    static var shared:Global {
        let sharedObject = Global()
        return sharedObject
    }
    
    func launchDashBoard() {
        
        DELEGATE.window?.rootViewController?.dismiss(animated: true) {
            //            AppLoginManager.shared.callGetStoreDataAPI()
        }
    }
    
    func launchAuthBoard() {
        
        let rootNavigationController = RootNavigationController.instantiate(from: .main)
        guard let rootVC = rootNavigationController.viewControllers.first as? RootVC else { return }
        if let boardingStatus = UserDefaults.tutorialScreen, boardingStatus { // For show tutorial screen.
            let authentication: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let loginVC: LoginVC = authentication.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController(rootViewController: loginVC)
            DELEGATE.window?.rootViewController = nav
            DELEGATE.window?.makeKeyAndVisible()
            return
        }
        DELEGATE.window?.rootViewController = rootNavigationController
        rootVC.performSegue(withIdentifier: Constant.Segue.authentication, sender: nil)
    }
    
    
}

extension Global {
    // MARK: - Helpers
    
    func getViewControllerFrom(for identifire:String,storyboard :String) -> UIViewController {
        
        return getStoryboard(storyboard: storyboard).instantiateViewController(withIdentifier: identifire)
    }
    
    func getStoryboard(storyboard :String) -> UIStoryboard {
        
        return UIStoryboard(name: storyboard, bundle:nil)
    }
    
    func getAuthenticationViewController(for identifire:String) -> UIViewController {
        
        return getViewControllerFrom(for: identifire, storyboard: "Authentication")
    }
    
    func getTabBarViewController(for identifire:String) -> UIViewController {
        
        return getViewControllerFrom(for: identifire, storyboard: "TabBar")
    }
    
    
    func getViewController(for identifire:String) -> UIViewController {
        
        return getViewControllerFrom(for: identifire, storyboard: "Main")
    }
    
    
    
    static func showIndicator(onKeyeboard:Bool = false, isInteractionEnable: Bool = true) {
        
        DispatchQueue.main.async {
            Global.showIndicatorCount = Global.showIndicatorCount + 1
            
            let activity = UIApplication.shared.windows.first { $0.subviews.first { $0.restorationIdentifier == "com.jet.activityIndicator" } != nil }
            guard activity == nil else { /* activity already present in window */  return }
            
            //guard keyWindow.viewWithTag(1010101010) == nil else { return }
            
            var keyWindow:UIWindow!
            if onKeyeboard {
                
                keyWindow = UIApplication.shared.windows.last
            }else {
                keyWindow = UIApplication.shared.windows.last
            }
            
            guard keyWindow != nil else { return }
#if os(tvOS)
            
            UIApplication.topViewController()?.view.isUserInteractionEnabled = false
#endif
            
            var size = CGSize(width: 100, height: 100)
            var color = #colorLiteral(red: 1, green: 0.9407282472, blue: 0, alpha: 1)
            
#if os(iOS)
            size = CGSize(width: 40, height: 40)
            color = #colorLiteral(red: 1, green: 0.9407282472, blue: 0, alpha: 1)
#endif
            
            let containerView = UIView(frame: UIScreen.main.bounds)
            containerView.backgroundColor = .clear // UIColor.black.withAlphaComponent(0.6)
            containerView.restorationIdentifier = "com.jet.activityIndicator"
            containerView.translatesAutoresizingMaskIntoConstraints = false
            DELEGATE.rootVC?.tabBarVc?.view.isUserInteractionEnabled = isInteractionEnable
            let activityIndicatorView = NVActivityIndicatorView(
                frame: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                type: NVActivityIndicatorType.ballSpinFadeLoader,
                color: color,
                padding: 0)
            
            activityIndicatorView.startAnimating()
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(activityIndicatorView)
            
            // Add constraints for `activityIndicatorView`.
            ({
                let xConstraint = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerX, multiplier: 1, constant: 0)
                
#if os(iOS)
                let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: activityIndicatorView, attribute: .bottom, multiplier: 1, constant: 100)
                containerView.addConstraints([xConstraint, bottomConstraint])
#else
                //                let yConstraint = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerY, multiplier: 1, constant: 0)
                //
                //                containerView.addConstraints([xConstraint, yConstraint])
                let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: activityIndicatorView, attribute: .bottom, multiplier: 1, constant: 150)
                containerView.addConstraints([xConstraint, bottomConstraint])
#endif
                
            }())
            
            containerView.tag = 1010101010
            keyWindow.addSubview(containerView)
            keyWindow.bringSubviewToFront(containerView)
            // Add constraints for `containerView`.
            ({
                let leadingConstraint = NSLayoutConstraint(item: keyWindow!, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
                let trailingConstraint = NSLayoutConstraint(item: keyWindow!, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
                let topConstraint = NSLayoutConstraint(item: keyWindow!, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
                let bottomConstraint = NSLayoutConstraint(item: keyWindow!, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
                
                keyWindow.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
            }())
        }
    }
    
    static func addFirebaseEvent(eventName:String, param:[String:Any]) {
#if DEBUG
#else
        var params = param
        let date = Date()
        let dateFormatter = DateFormatter()
        params["date"] = dateFormatter.string(from: date)
        params["platform"] = "ios"
        if let user_id = UserModel.user?.userId {
            params["user_id"] = user_id
        }
        Analytics.logEvent(eventName, parameters: params)
#endif
        
    }
    
    static func addNetcoreEvent(eventname: String, param: [String: Any]) {
        
#if DEBUG
        
        var params = param
        let date = Date()
        let dateFormatter = DateFormatter()
        params["date"] = dateFormatter.string(from: date)
        params["platform"] = "ios"
        if let user_id = UserModel.user?.userId {
            params["user_id"] = user_id
        }
        
        Smartech.sharedInstance().trackEvent(eventname, andPayload:params)
#else
        
        var params = param
        let date = Date()
        let dateFormatter = DateFormatter()
        params["date"] = dateFormatter.string(from: date)
        params["platform"] = "ios"
        if let user_id = UserModel.user?.userId {
            params["user_id"] = user_id
        }
        
        Smartech.sharedInstance().trackEvent(eventname, andPayload:params)
        
#endif
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func hideIndicator()  {
        
        DispatchQueue.main.async {
            DELEGATE.rootVC?.tabBarVc?.view.isUserInteractionEnabled = true
            Global.showIndicatorCount -= 1
            
            if Global.showIndicatorCount <= 0 {
                self.hideCustomIndicator(nil)
            }
        }
    }
    
    class func hideIndicatorForcefully()  {
        
        Global.showIndicatorCount = 1
        Global.hideIndicator()
    }
    
    fileprivate static func hideCustomIndicator(_ fadeOutAnimation: FadeOutAnimation?) {
        
#if os(tvOS)
        UIApplication.topViewController()?.view.isUserInteractionEnabled = true
#endif
        for window in UIApplication.shared.windows {
            
            for item in window.subviews where item.restorationIdentifier == "com.jet.activityIndicator" {
                
                if let fadeOutAnimation = fadeOutAnimation { fadeOutAnimation(item) {
                    item.removeFromSuperview()
                    
                }
                }
                else {
                    item.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - Alerts

extension Global{
    
    public class func showAlert(title:String? = nil, message: String, sender: UIViewController? = DELEGATE.window?.rootViewController, buttonTitle: String? = nil, handler: ((UIAlertAction) -> Void)?) {
        let alertTitle = title ?? ""
        let cancelTitle = buttonTitle ?? LocalizedString(key:StringConstants.okay , value: "Okay")
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler:{ (action) in
            handler!(action)
        }))
        
        DispatchQueue.main.async {
            sender?.present(alert, animated: true, completion: nil)
        }
    }
    
    public class func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            guard let vc = DELEGATE.window?.rootViewController else {return}
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title:LocalizedString(key:StringConstants.okay , value: "Okay") , style: .default) { (action) in
                vc.dismiss(animated: true, completion: nil)
            }
            
            // alert.view.tintColor = .alertTintColor
            //okAction.setValue(UIColor.alertTextColor, forKey: "titleTextColor")
            
            alert.addAction(okAction)
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
    //    public class func showUnderDevelopmentAlert() {
    //        self.showAlert(title: "Message", message: "Component under development!!")
    //    }
    
    public class func showOkCancelAlertMessage(title: String, message: String,completion: @escaping (_ okClicked:Bool,_ cancelClicked:Bool) -> ()){
        DispatchQueue.main.async {
            guard let vc = DELEGATE.window?.rootViewController else {return}
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: LocalizedString(key:StringConstants.okay , value: "Okay") , style: .default) { (action) in
                completion(true,false)
            }
            
            alert.addAction(okAction)
            
            let cancelText = LocalizedString(key: StringConstants.cancel, value: "Cancel")
            
            let cancelAction = UIAlertAction(title:cancelText, style: .default) { (action) in
                completion(false,true)
            }
            
            alert.addAction(cancelAction)
            
            
            vc.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    class func showSignOutAlert(title: String,message:String){
        
        let newTitle = LocalizedString(key: StringConstants.blockBanTitle, value:"") + title
        
        let alert = UIAlertController(title: newTitle, message:message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title:LocalizedString(key: StringConstants.signOut, value: ""), style: .destructive) { (action) in
            
            //            AppLoginManager.shared.logout()
        }
        okAction.setValue(UIColor.black, forKey: "titleTextColor")
#if os(tvOS)
        okAction.setValue(UIColor.white, forKey: "titleTextColor")
#endif
        
        alert.addAction(okAction)
        DELEGATE.rootVC?.present(alert, animated: true, completion: nil)
    }
}
