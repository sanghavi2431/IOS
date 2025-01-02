//
//  AppDelegate.swift
//  Woloo
//
//  Created by Ashish Khobragade on 17/12/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import AppsFlyerLib
import Firebase
import UserNotifications
//import FirebaseMessaging
import netfox
import StoreKit
import Foundation
import FBSDKCoreKit
import Alamofire
import Smartech
import UserNotifications
import UserNotificationsUI
import SmartPush
import SafariServices
import FirebaseCore
import FacebookCore
import AlamofireNetworkActivityLogger




@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, AppsFlyerLibDelegate, SmartechDelegate, HanselEventsListener {
    
    
    var window: UIWindow?
    var rootVC:RootVC?
    var locationManager = CLLocationManager()
    var didChangeLocationAuthorizationStatus: ((_ status: CLAuthorizationStatus) -> Void)?
    var appConfigGet = AppConfigGetObserver()
    var appConfigGetObserverV2: AppCofigGetModel? = nil
    var netcoreEvents = NetcoreEvents()
    var transportMode = TransportMode.car
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //getAppConfig.appConfigGet()
        
        Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
        UNUserNotificationCenter.current().delegate = self
        Smartech.sharedInstance().setDebugLevel(.verbose)
        SmartPush.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
        
        
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        AppEvents.shared.logEvent(AppEvents.Name("Woloo-iOS/Event"))
        // appConfigGet.appConfigGet()
        self.appConfigGetV2()
        FirebaseApp.configure()
        registerForNotification()
        
        //for dev change to staging
        API.environment = .alpha
        
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "https://woloo.page.link"
        configureIQKeyboardManager()
        configureGoogleMapsServices()
        
        
        
        // Something to log your sensitive data here
        
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        print("App Version \(appVersion ?? "")")
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        
        
        
        print("Retrieved Values didFinishLaunchingWithOptions: \(appConfigGet.appConfigGetObserver?.APP_VERSION?.version_code ?? "")")
        
        //        APIManager.shared.getAppConfigData {
        //            if AppConfig.getAppConfigInfo()?.maintenanceSetting?.maintenanceFlag ?? "0" == "1" {
        //                self.maintenancePopUp()
        //            } else if AppConfig.getAppConfigInfo()?.appVersion?.force_update ?? "0" == "1" {
        //                //                self.forceUpdatePopUp()
        //            }
        //        }
        
        
        // initLocationManager()
        
        print(" Current Latitide: \(DELEGATE.locationManager.location?.coordinate.latitude ?? 19.055229),Current Longitude\(DELEGATE.locationManager.location?.coordinate.longitude ?? 72.830829)")
        
        //Used to update location
        let smartechLocation = CLLocationCoordinate2DMake(locationManager.location?.coordinate.latitude ?? 0, locationManager.location?.coordinate.longitude ?? 0)
        Smartech.sharedInstance().setUserLocation(smartechLocation)
        
        //        UserDefaultsManager.storeCurrentLat(value: (locationManager.location?.coordinate.latitude ?? 0))
        //
        //        UserDefaultsManager.storeCurrentLong(value: (locationManager.location?.coordinate.longitude ?? 0))
        
        if (UserDefaults.standard.object(forKey: "FirstOpen") as? Date) != nil {
            
            Global.addNetcoreEvent(eventname: self.netcoreEvents.firstOpen, param: [:])
            Global.addFirebaseEvent(eventName: "first_open", param:[:] )
        } else {
            Global.addNetcoreEvent(eventname: self.netcoreEvents.appOpen, param: [:])
            Global.addFirebaseEvent(eventName: "app_open", param: [:])
            UserDefaults.standard.set(Date(), forKey: "FirstOpen")
        }
        
        fetchRoute(from: CLLocationCoordinate2D(latitude: UserDefaultsManager.fetchCurrentLat(), longitude: UserDefaultsManager.fetchCurrentLong()), to: CLLocationCoordinate2D(latitude: UserDefaultsManager.fetchDestinationLat(), longitude: UserDefaultsManager.fetchDestinationLong()))
        
        UserDefaults.standard.removeObject(forKey: "Store_Current_Lat")
        UserDefaults.standard.removeObject(forKey: "Store_Current_Long")
        UserDefaults.standard.removeObject(forKey: "Store_Destination_Lat")
        UserDefaults.standard.removeObject(forKey: "Store_Destination_Long")
        
#if DEBUG
        NFX.sharedInstance().start()
        NetworkActivityLogger.shared.level = .debug
        NetworkActivityLogger.shared.startLogging()
        
#else
        
#endif
        //UIApplication.shared.registerForRemoteNotifications()
        
        Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
        Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
        
        SmartPush.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        //Register the listener with Hansel SDK by using this code.
        HanselTracker.registerListener(self);
        
#if DEBUG
        Smartech.sharedInstance().setDebugLevel(.verbose)
        Hansel.enableDebugLogs()
#else
        Smartech.sharedInstance().setDebugLevel(.verbose)
#endif
        
        NSLog("didFinishLaunchingWithOptions CALL:")
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
        
        print("applicationDidBecomeActive")
        self.appConfigGetV2()
        
        initLocationManager()
        UserDefaultsManager.storeCurrentLat(value: (locationManager.location?.coordinate.latitude ?? 19.055229))
        UserDefaultsManager.storeCurrentLong(value: (locationManager.location?.coordinate.longitude ?? 72.830829))
        //AppEvents.activateApp()
        //appConfigGet.appConfigGet()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        //initLocationManager()
        self.appConfigGetV2()
        //appConfigGet.appConfigGet()
        //        UserDefaultsManager.storeCurrentLat(value: (locationManager.location?.coordinate.latitude ?? 19.055229))
        //        UserDefaultsManager.storeCurrentLong(value: (locationManager.location?.coordinate.longitude ?? 72.830829))
        //locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground App delegate")
        initLocationManager()
        //        UserDefaultsManager.storeCurrentLat(value: (locationManager.location?.coordinate.latitude ?? 19.055229))
        //
        //        UserDefaultsManager.storeCurrentLong(value: (locationManager.location?.coordinate.longitude ?? 72.830829))
        self.appConfigGetV2()
        //appConfigGet.appConfigGet()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            
            self.fetchRoute(from: CLLocationCoordinate2D(latitude: UserDefaultsManager.fetchCurrentLat(), longitude: UserDefaultsManager.fetchCurrentLong()), to: CLLocationCoordinate2D(latitude: UserDefaultsManager.fetchDestinationLat(), longitude: UserDefaultsManager.fetchDestinationLong()))
        })
        
        
        //        UserDefaults.standard.removeObject(forKey: "Store_Current_Lat")
        //        UserDefaults.standard.removeObject(forKey: "Store_Current_Long")
        //        UserDefaults.standard.removeObject(forKey: "Store_Destination_Lat")
        //        UserDefaults.standard.removeObject(forKey: "Store_Destination_Long")
    }
    
    func configureIQKeyboardManager() {
        
        IQKeyboardManager.shared.enable                         = true
        IQKeyboardManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder   = false
        IQKeyboardManager.shared.enableAutoToolbar              = true
        IQKeyboardManager.shared.toolbarConfiguration.previousNextDisplayMode        = .alwaysHide
        IQKeyboardManager.shared.resignOnTouchOutside     = true
    }
    
    func configureGoogleMapsServices() {
        GMSPlacesClient.provideAPIKey(Constant.ApiKey.googleMap)
        GMSServices.provideAPIKey(Constant.ApiKey.googleMap)
    }
    // Location Manager helper stuff
    func initLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        //locationManager.allowsBackgroundLocationUpdates = true
    }
    
    // Location Manager Delegate stuff
    // If failed
    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            print(error.localizedDescription ?? "")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager = manager
        if let location = locations.last {
            print("Lat :--->> \(location.coordinate.latitude) \n -->>Lng : \(location.coordinate.longitude)")
        }
    }
    
    // authorization status
    private func locationManager(manager: CLLocationManager!,
                                 didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        didChangeLocationAuthorizationStatus?(status)
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            if let link = dynamiclink?.url {
                self.decodeURLForOpenScreen(url: link)
                
                print("Dynamic link URl for voucher apply: \(link)")
            }
        }
        
        return handled
    }
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print("Url: \(url)")
        if let scheme = url.scheme, scheme == "woloo.page.link" {
            decodeURLForOpenScreen(url: url)
            print("Dynamic link URl for voucher apply: \(url)")
        }
        Smartech.sharedInstance().application(app, open: url, options: options)
        
        return true
    }
    
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("url: \(url)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            if let link = dynamicLink.url {
                decodeURLForOpenScreen(url: link)
                print("link: \(link)")
            }
            return true
        }
        return false
    }
    
    func decodeURLForOpenScreen(url: URL) {
        let str = url.absoluteString //
            .replacingOccurrences(of: "woloo.page.link://", with: "")
        print("Dynamic link URl for voucher apply: \(str)")
        let testVoucher = getQueryStringParameter(url: str, param: "voucher")
        
        print("Test Voucher: \(testVoucher ?? "")")
        
        
        UserDefaultsManager.storeVoucherCode(value: testVoucher ?? "")
        
        NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["voucher": testVoucher])
        
        let slashComponenets = str.components(separatedBy: "/")
        print("Dynamic link slash components  URl for voucher apply: \(slashComponenets)")
        DELEGATE.rootVC?.tabBarVc?.selectedIndex = 2
        //Global.shared.launchDashBoard()
        
        if str.contains("voucher") { // Voucher
            
            guard let getIndex = slashComponenets.firstIndex(where: { $0.lowercased() == "voucher"}) else { return }
            let voucher = slashComponenets[getIndex + 1]
            if UserModel.getAuthorizedUserInfo() == nil {
                UserDefaults.voucherCode = testVoucher
                return
            }
            UserDefaults.voucherCode = nil
            NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["voucher": voucher])
        }
        else if str.contains("referral_code") { // https://woloo.page.link/share/?referral_code=6O1MSVK4DE
            //            guard let getIndex = slashComponenets.firstIndex(where: { $0.lowercased().contains("referral_code")}) else { return }
            let referral = url.absoluteString.slice(from: "?referral_code=", to: "?")
            UserDefaults.referralCode = referral
            //            let referral = slashComponenets[getIndex + 1]
            if UserModel.getAuthorizedUserInfo() == nil {
                NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["referral_code": referral])
            }
        }
        else if str.contains("wahcertificate") {// https://woloo.page.link/?link=https://woloo.verifinow.com/wahcertificate/363/51250/?apn=in.woloo.www
            guard let getIndex = slashComponenets.firstIndex(where: { $0.lowercased() == "wahcertificate"}) else { return }
            let code = slashComponenets[getIndex + 1]
            if UserModel.getAuthorizedUserInfo() == nil {
                UserDefaults.certificatCode = code
                return
            }
            NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["wahcertificate": code])
        }
        else if str.contains("giftId") {
            print("Gift Id block executed")
            let giftId = getQueryStringParameter(url: str, param: "giftId")
            
            print("retrieved gift ID: \(giftId ?? "")")
            
            UserDefaultsManager.storeGiftID(value: giftId ?? "")
            NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["giftId": giftId ?? ""])
            
        }
        
    }
    
    func decodeURLForOpenScreenNetcore(url: String) {
        let str = url.replacingOccurrences(of: "woloo.page.link://", with: "")
        // print("Dynamic link URl for voucher apply: \(str)")
        let testVoucher = getQueryStringParameter(url: str, param: "voucher")
        
        print("Test Voucher: \(testVoucher ?? "")")
        
        
        UserDefaultsManager.storeVoucherCode(value: testVoucher ?? "")
        
        NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["voucher": testVoucher])
        
        let slashComponenets = str.components(separatedBy: "/")
        print("Dynamic link slash components  URl for voucher apply: \(slashComponenets)")
        
        if str.contains("voucher") { // Voucher
            
            guard let getIndex = slashComponenets.firstIndex(where: { $0.lowercased() == "voucher"}) else { return }
            let voucher = slashComponenets[getIndex + 1]
            if UserModel.getAuthorizedUserInfo() == nil {
                UserDefaults.voucherCode = testVoucher
                return
            }
            UserDefaults.voucherCode = nil
            NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["voucher": voucher])
        }
        else if str.contains("referral_code") { // https://woloo.page.link/share/?referral_code=6O1MSVK4DE
            //            guard let getIndex = slashComponenets.firstIndex(where: { $0.lowercased().contains("referral_code")}) else { return }
            let referral = url.slice(from: "?referral_code=", to: "?")
            UserDefaults.referralCode = referral
            //            let referral = slashComponenets[getIndex + 1]
            if UserModel.getAuthorizedUserInfo() == nil {
                NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["referral_code": referral])
            }
        }
        else if str.contains("wahcertificate") {// https://woloo.page.link/?link=https://woloo.verifinow.com/wahcertificate/363/51250/?apn=in.woloo.www
            guard let getIndex = slashComponenets.firstIndex(where: { $0.lowercased() == "wahcertificate"}) else { return }
            let code = slashComponenets[getIndex + 1]
            if UserModel.getAuthorizedUserInfo() == nil {
                UserDefaults.certificatCode = code
                return
            }
            NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["wahcertificate": code])
        }
        else if str.contains("giftId") {
            print("Gift Id block executed")
            let giftId = getQueryStringParameter(url: str, param: "giftId")
            
            print("retrieved gift ID: \(giftId ?? "")")
            
            UserDefaultsManager.storeGiftID(value: giftId ?? "")
            NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["giftId": giftId ?? ""])
            
        }
        DELEGATE.rootVC?.tabBarVc?.selectedIndex = 2
        Global.shared.launchDashBoard()
    }
    
    func maintenancePopUp() {
        DispatchQueue.main.async {
            if let view = UIApplication.shared.windows.first?.rootViewController?.view, let controller = UIApplication.shared.windows.first?.rootViewController {
                let alert = WolooAlert(frame: view.frame, cancelButtonText: "", title: nil, message: AppConfig.getAppConfigInfo()?.maintenanceSetting?.maintenanceMessage ?? "Under maintainence", image: #imageLiteral(resourceName: "logo"), controller: controller)
                alert.cancelTappedAction = {
                    
                }
                view.addSubview(alert)
                view.bringSubviewToFront(alert)
            }
        }
    }
    func forceUpdatePopUp() {
        DispatchQueue.main.async {
            if let view = UIApplication.shared.windows.first?.rootViewController?.view, let controller = UIApplication.shared.windows.first?.rootViewController {
                let alert = WolooAlert(frame: view.frame, cancelButtonText: "Update", title: nil, message: AppConfig.getAppConfigInfo()?.appVersion?.update_text ?? "Please update to latest version", image: #imageLiteral(resourceName: "logo"), controller: controller)
                alert.cancelTappedAction = {
                    print("navigate user to app store")
                    
                    let appStoreLink = "https://apps.apple.com/us/app/woloo/id1571476207"
                    
                    guard let url = URL(string: appStoreLink) else { return }
                    UIApplication.shared.open(url)
                }
                view.addSubview(alert)
                view.bringSubviewToFront(alert)
            }
            
        }
    }
    
    //    func softUpdatePopUp(){
    //        DispatchQueue.main.async {
    //
    //            if let view = UIApplication.shared.windows.first?.rootViewController?.view, let controller = UIApplication.shared.windows.first?.rootViewController {
    //
    //
    //                let customTwoButtonAlert = WolooTwoButtonAlert(frame: view.frame, cancelButtonText: "Update", updateButtonText: "Cancel", title: nil, message: "Please update to latest version", image: #imageLiteral(resourceName: "logo"), controller: controller)
    //
    //                customTwoButtonAlert.cancelTappedAction = {
    //                    print("navigate user to app store")
    //
    //
    //                }
    //
    //                customTwoButtonAlert.cancelUpdateAction = {
    //
    //                    print("Dismiss the view")
    //                    customTwoButtonAlert.isHidden
    //                }
    //                view.addSubview(customTwoButtonAlert)
    //                view.bringSubviewToFront(customTwoButtonAlert)
    //            }
    //
    //        }
    //    }
    
    
    
    
    
    // MARK: - Appsflyer Method
    func setUpAppFlyer() {
        AppsFlyerLib.shared().appsFlyerDevKey = "i6aoJbBqs6pWjzSvo5hbtJ"
        AppsFlyerLib.shared().appleAppID = "1571476207"
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        //https://dev.appsflyer.com/hc/docs/integrate-ios-sdk
    }
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        
    }
    
    func onConversionDataFail(_ error: Error) {
        
    }
    
    func appConfigGetV2(){
        
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
                self.appConfigGetObserverV2 = response.results
                print("App Config get response: ",response)
                UserDefaultsManager.storeAppConfigData(value: response.results)
                
                
            case .failure(let error):
                print("App config error", error)
                
            }
        }
    }
    
    
}

// MARK : Firebase Push Notification Method
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func registerForNotification() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                //                print("error Notification Request---\(error)")
                if error != nil {
                    center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                        if granted {
                            DispatchQueue.main.async { // Correct
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                    }
                } else {
                    if granted {
                        DispatchQueue.main.async { // Correct
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
        // Messaging.messaging().delegate = self
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("device token: \(deviceToken)")
        SmartPush.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        SmartPush.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    //    func application(application: UIApplication,
    //                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    ////        Messaging.messaging().apnsToken = deviceToken
    //        print("APNs token retrieved didRegisterForRemoteNotificationsWithDeviceToken: \(deviceToken)")
    //
    //        SmartPush.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    //    }
    //
    //    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    //      SmartPush.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    //
    //        print("APNs token not retrieved: \(error)")
    //
    //    }
    //
    
    
    //    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    //
    //        //        print("Firebase registration token: \(String(describing: fcmToken))")
    //
    //        print("Firebase registration token -> ",fcmToken)
    //        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    //
    //
    //        let dataDict: [String: String] = ["token": fcmToken ?? ""]
    //        NotificationCenter.default.post(
    //            name: Notification.Name("FCMToken"),
    //            object: nil,
    //            userInfo: dataDict
    //        )
    //    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        SmartPush.sharedInstance().didReceiveRemoteNotification(userInfo, withCompletionHandler: completionHandler)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        SmartPush.sharedInstance().willPresentForegroundNotification(notification)
        completionHandler([.alert, .badge, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification in did receive")
        SmartPush.sharedInstance().didReceive(response)
        let userInfo = response.notification.request.content.userInfo
        print("userInfo --> \(userInfo)")
        completionHandler()
    }
    
    @objc func handlePush(userInfo: [AnyHashable : Any]) {
        print("Click")
    }
    //MARK:- SmartechDelegate Method
    
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andNotificationPayload notificationPayload: [AnyHashable : Any]?){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            
            NSLog("SMTLogger DEEPLINK NEW CALL: \(deeplinkURLString ?? "")")
            let url = URL(string: deeplinkURLString ?? "")
            
            print("url part 1: \(url?.host)")
            print("url part 2: \(url?.lastPathComponent)")
            print("url part 3: \(url?.absoluteURL.host)")
            switch url?.host ?? ""{
                
            case "shop":
                print("Navigating to shop page")
                NSLog("SMTLogger shop page NEW CALL: \(deeplinkURLString)")
                NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["shop": "shop"])
                
            case "subscription":
                print("Navigating to subscription page")
                NSLog("SMTLogger subscription Page NEW CALL: \(deeplinkURLString)")
                NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["buySubscription": "buySubscription"])
                
            case "refer":
                print("Navigating to refer page")
                NSLog("SMTLogger refer page NEW CALL: \(deeplinkURLString)")
                DELEGATE.rootVC?.tabBarVc?.selectedIndex = 1
                print("navigate to refer page")
                
                
            default:
                print("No navigation screen defined")
            }
            
            //            let handled = DynamicLinks.dynamicLinks().handleUniversalLink(url!) { (dynamiclink, error) in
            //                if let link = dynamiclink?.url {
            //                    print("Dynamic link URl for voucher apply: \(link)")
            //                    //self.decodeURLForOpenScreenNetcore(url: deeplinkURLString)
            //                    let str = link.absoluteString.replacingOccurrences(of: "app.woloo.in://", with: "")
            //                    if str.contains("voucher") {
            //                        print("voucher loop executed")
            //                    }
            //                }
            //            }
        })
        
        
        
        
        
        /*
         1) woloo://shop
         2) woloo://subscription
         3) woloo://refer
         */
        
        //           if url.host ?? "" == "shop"{
        //               //woloo://shop
        //               //DELEGATE.rootVC?.tabBarVc?.showTabBar()
        //               NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["shop": "shop"])
        //            return
        //           }
        //           else if url.host ?? "" == "subscription"{
        //               //woloo://subscription
        //               NotificationCenter.default.post(name: Notification.Name.deepLinking, object: nil, userInfo: ["buySubscription": "buySubscription"])
        //               return
        //           }
        //           else if url.host ?? "" == "refer"{
        //               //woloo://refer
        //               DELEGATE.rootVC?.tabBarVc?.selectedIndex = 1
        //               print("navigate to refer page")
        //               return
        //
        //           }
        
        
        
        //self.decodeURLForOpenScreenNetcore(url: deeplinkURLString)
        
        //           if customPayload != nil {
        //               print("Custom Payload: \(customPayload!)")
        //           }
    }
    
    // Hansel Events Listener
    func fireHanselEventwithName(eventName: String, properties: [AnyHashable : Any]?) {
        Smartech.sharedInstance().trackEvent(eventName, andPayload: properties)
    }
    
}

extension AppDelegate {
    
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        print("UserDefaultsManager.fetchWolooID()", UserDefaultsManager.fetchWolooID())
        print("(\(source.latitude),\(source.longitude))->(\(destination.latitude),\(destination.longitude))")
        let session = URLSession.shared
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=\(transportMode.googleAPIValue)&key=\(Constant.ApiKey.googleMap)")!
        print("\(url)")
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            if let routes = jsonResult["routes"] as? [Any] , routes.count > 0  {
                guard let route = routes[0] as? [String: Any]
                else {
                    return
                }
                if let legs = route["legs"] as? [Any] , legs.count > 0  {
                    DispatchQueue.main.async {
                        //self.stackDirection1.isHidden = true
                        //self.vwDirection2.isHidden = true
                    }
                    if let leg = legs[0] as? [String: Any] {
                        print("stepIn 1")
                        if let steps = leg ["steps"] as? [Any], steps.count > 0 {
                            print("stepIn 2")
                            if let step1 = steps[0] as? [String:Any] {
                                print("stepIn 3")
                                if let dist1 = step1["distance"] as? [String:Any] {
                                    print("stepIn 4")
                                    if let dist1Val = dist1["text"] as? String {
                                        print("stepIn 5")
                                        if steps.count == 1 {
                                            print("stepIn 6")
                                            if let dist = dist1["value"] as? Int, dist <= 50 {
                                                print("stepIn 7")
                                                //if let wid = self.storeId2! {
                                                print("stepIn 8")
                                                print("user has reached the destination")
                                                //self.hasStartedRouting = false
                                                self.wolooNavigationRewardAPI(wolooId: UserDefaultsManager.fetchWolooID())
                                                
                                                //                                                    self.vwScanQr.isHidden = false
                                                //}
                                            }
                                            else {
                                                print("stepOut 7")
                                            }
                                        } else {
                                            print("stepOut 6")
                                        }
                                        DispatchQueue.main.async {
                                            //self.lblDirection1.text = dist1Val
                                            // self.stackDirection1.isHidden = false
                                            if let maneuver1 = step1["maneuver"] as? String {
                                                if let m1image = UIImage(named:maneuver1) {
                                                    // self.imgDirection1.image = m1image
                                                } else {
                                                    //self.imgDirection1.image = UIImage(named: "straight")
                                                }
                                            }
                                        }
                                    } else {
                                        print("stepOut 5")
                                    }
                                }  else {
                                    print("stepOut 4")
                                }
                            }  else {
                                print("stepOut 3")
                            }
                            if steps.count > 1, let step2 = steps[1] as? [String:Any] {
                                if let dist2 = step2["distance"] as? [String:Any] {
                                    if let dist2Val = dist2["text"] as? String {
                                        DispatchQueue.main.async {
                                            //self.lblDirection2.text = dist2Val
                                            //self.vwDirection2.isHidden = false
                                            if let maneuver1 = step2["maneuver"] as? String {
                                                if let m1image = UIImage(named:maneuver1) {
                                                    //   self.imgDirection2.image = m1image
                                                } else {
                                                    //  self.imgDirection2.image = UIImage(named: "straight")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            print("stepOut 2")
                        }
                        
                        DispatchQueue.main.async {
                            if let distance = leg["distance"] as? [String: Any] {
                                // self.lblKm.text = distance["text"] as? String ?? ""
                                
                                //self.distanceLbl.text = distance["text"] as? String ?? ""
                            }
                            if let distance = leg["duration"] as? [String: Any] {
                                //self.lblMins.text = distance["text"] as? String ?? ""
                                
                                // self.timeLbl.text = distance["text"] as? String ?? ""
                            }
                        }
                    } else {
                        print("stepOut 1")
                    }
                    
                }
                
                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                    return
                }
                
                guard let polyLineString = overview_polyline["points"] as? String else {
                    return
                }
                
                //                DispatchQueue.main.async {
                //                    self.mapContainerView.clear()
                //                   self.mapContainerView.addDestinationMarker(lat: destination.latitude, long: destination.longitude, name: "Destination", index: 0)
                //                    self.destLat = destination.latitude
                //                    self.destLong = destination.longitude
                //
                //                    self.mapContainerView.addCurrentPositionMarker(currentPosition: source)
                //
                //                    let sourcePoint = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
                //                    let destinationPoint = CLLocationCoordinate2D(latitude: source.latitude,longitude: source.longitude)
                //                let bounds = GMSCoordinateBounds(coordinate: sourcePoint, coordinate: destinationPoint)
                //
                //
                //                let mapInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
                //                self.mapContainerView.padding = mapInsets
                //                self.mapContainerView.animate(toZoom: 10)
                //                let camera = self.mapContainerView.camera(for: bounds, insets: UIEdgeInsets())!
                //                self.mapContainerView.camera = camera
                //
                //                self.drawPath(from: polyLineString)
                //                self.isFetchingPath = false
                //                self.getEnrouteWoloo(src_lat: source.latitude, src_lng: source.longitude, target_lat: destination.latitude, target_lng: destination.longitude)
                //
                //                }
            }
        })
        task.resume()
        
    }
    
    
    func wolooNavigationRewardAPI(wolooId: Int) {
        APIManager.shared.wolooNavigationReward(param: ["wolooId":wolooId]) { (isSuccess, result, message) in
            //            self.showToast(message: message)
            if isSuccess {
                var msg = ""
                
                if result?.code == 200 {
                    msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationPoints ?? "")"
                    Global.addFirebaseEvent(eventName: "woloo_destination_reached", param: [
                        "woloo_id": wolooId])
                    print("User has reached destination App delegate")
                    
                    NotificationCenter.default.post(name: Notification.Name.destinationReached, object: nil, userInfo: ["destinationReached": "destinationReached"])
                    //                    DispatchQueue.main.async {
                    //                       // let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "ADD REVIEW", title: "", message: msg, image: nil, controller: self)
                    //                        alert.cancelTappedAction = {
                    //                            alert.removeFromSuperview()
                    //                            let vc = UIStoryboard.init(name: "More", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddReviewVC") as? AddReviewVC
                    //                            vc?.wolooStore = self.wolooStore
                    //
                    //                            vc?.wolooStoreID2 = self.storeId2
                    //
                    //                            self.navigationController?.pushViewController(vc!, animated: true)
                    //                        }
                    //                        self.view.addSubview(alert)
                    //                        self.view.bringSubviewToFront(alert)
                    //                    }
                } else {
                    
                    print("User arrived at destination appdelegate reward point already claimed")
                    NotificationCenter.default.post(name: Notification.Name.destinationReached, object: nil, userInfo: ["destinationPointClaimed": "destinationPointClaimed"])
                    //                    msg = "\(UserDefaultsManager.fetchAppConfigData()?.CUSTOM_MESSAGE?.arrivedDestinationText ?? "")"
                    //                    DispatchQueue.main.async {
                    //                        let alert = WolooAlert(frame: self.view.frame, cancelButtonText: "HOME", title: "", message: msg, image: nil, controller: self)
                    //                        alert.cancelTappedAction = {
                    //                            alert.removeFromSuperview()
                    //                            self.navigationController?.popToRootViewController(animated: true)
                    //                        }
                    //                        self.view.addSubview(alert)
                    //                        self.view.bringSubviewToFront(alert)
                    //                    }
                }
            }
        }
    }
    
    
    
    func wolooNavigationRewardAPIV2(wolooId: Int) {
        
        Global.showIndicator()
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        print("App Build: \(AppBuild)")
        
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        var data = ["wolooId": wolooId ?? 0]
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(data: data,headers: headers, url: nil, service: .wolooNavigationRewards, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<StatusSuccessResponseModel>, Error>) in
            switch result {
                
            case .success(let response):
                Global.hideIndicator()
                print("User has reached destination App delegate")
                
                NotificationCenter.default.post(name: Notification.Name.destinationReached, object: nil, userInfo: ["destinationReached": "destinationReached"])
                
                
            case .failure(let error):
                Global.hideIndicator()
                print("User arrived at destination appdelegate reward point already claimed")
                NotificationCenter.default.post(name: Notification.Name.destinationReached, object: nil, userInfo: ["destinationPointClaimed": "destinationPointClaimed"])
                print("woloo navigation error: \(error)")
                
            }
        }
    }
}
