//
//  User.swift
//  YesFlixTV
//
//  Created by Ashish Khobragade on 19/03/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserModel : Mappable {
    static var user:UserModel?
    var userId:Int?
    var name, mobile, email,url: String?
    var profilePicUrl:String?
    var city: String?
    var pincode: String?
    var address: String?
    var avatar: String?
    var facebookId: String?
    var googleId: String?
    var referanceCode: String?
    var wolooId: Int?
    var subscriptionId: Int?
    var expiryDate: String?
    var token: String?
    var gender: String?
    var dob: String?
    var isFirstSession: Int?
    var sponserId: String?
    var voucherId: String?
    var lifetimeFree: Int? = 0
    var isFutureSubcriptionExist: Bool?
    var giftSubscriptionId: Int?
//    var isCancel: Bool? = false
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.userId  <- map["id"]
        self.name  <- map["name"] // None editable
        self.mobile <- map["mobile"] //name Editable by user //
        self.email  <- map["email"]
        self.city  <- map["city"]
        self.url <- map["avatar"]
        self.profilePicUrl = "\(API.environment.baseURL)public/userProfile/" + (self.url ?? "")
        self.pincode <- map["pincode"]
        self.address <- map["address"]
        self.avatar <- map["avatar"]
        self.facebookId <- map["fb_id"]
        self.googleId <- map["gp_id"]
        self.referanceCode <- map["ref_code"]
        self.wolooId <- map["woloo_id"]
        self.subscriptionId <- map["subscription_id"]
        self.expiryDate <- map["expiry_date"]
        self.token <- map["token"]
        self.gender <- map["gender"]
        self.dob <- map["dob"]
        self.isFirstSession <- map["is_first_session"]
        self.referanceCode <- map["ref_code"]
        self.sponserId <- map["sponsor_id"]
        self.voucherId <- map["voucher_id"]
        self.lifetimeFree <- map["lifetime_free"]
        self.isFutureSubcriptionExist <- map["isFutureSubcriptionExist"]
        self.giftSubscriptionId <- map["gift_subscription_id"]
//        self.isCancel <- map["is_cancel"]
    }
    
    /*static func apiProfileDetails(completion: @escaping (UserModel?) -> Void) {
        API.userProfile.apiMappableData(params: [:]) { (result:Result<(ProfileResponse, String?), APIRestClient.APIServiceError>) in
            switch result {
            case .success(let response):
                UserModel.saveAuthorizedUserInfo(response.0.userData)
                UserModel.user = response.0.userData
                completion(response.0.userData)
                
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }*/
    
    static func apiMoreProfileDetails(showLoading: Bool? = true ,completion: @escaping (ProfileMoreResponse?) -> Void) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.userMoreProfile.apiMappableData(params: [:]) { (result:Result<(ProfileMoreResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                UserModel.saveAuthorizedUserInfo(response.0.userData)
                UserModel.user = response.0.userData
                completion(response.0)
                
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    // MARK:-  Private Methods
    
    static func getUserCode() -> String? {
        if let userCode = UserDefaults.standard.value(forKey:"USER_CODE") as? String {
            return userCode
        }
        return nil
    }
    
    static func updateUserCode(userCode:String) {
        UserDefaults.userCode = userCode
        UserDefaults.standard.set(userCode, forKey:"USER_CODE")
        UserDefaults.standard.synchronize()
    }
    
    static func updateUserLocation(location:String) {
        UserDefaults.standard.set(location, forKey:"USER_LOCATION")
        UserDefaults.standard.synchronize()
    }
    
    static func updateUserData (userName:String,userEmail:String, location:String? = nil) {
        UserDefaults.standard.set(userName, forKey:"USER_NAME")
        UserDefaults.standard.set(userEmail, forKey:"USER_EMAIL")
        UserDefaults.standard.synchronize()
    }
    
    static func setUserLoggedInStatus(status:Bool) {
        if !status{
            UserDefaults.userCode = nil
            UserModel.user = nil
            UserDefaults.standard.set("", forKey:"USER_CODE")
            UserDefaults.jwtToken = ""
        }
        UserDefaults.standard.set(status, forKey:"USER_LOGGED_IN")
        UserDefaults.standard.synchronize()
    }
    
    static func isUserLoggedIn() -> Bool {
        if let isUserLoggedIn = UserDefaults.standard.value(forKey:"USER_LOGGED_IN") as? Bool,(UserDefaults.jwtToken?.count ?? 0) > 0{
            return isUserLoggedIn
        }
        return false
    }
    
    static func getUserProfileImageUrl() -> String? {
        
        /*    if let profilePicURL = UserDefaults.standard.value(forKey:"USER_PROFILE") as? String{
         
         if let _ = DELEGATE.rootVC?.loginResponseModelDO{
         
         DELEGATE.rootVC?.loginResponseModelDO?.profilePicURL = profilePicURL
         }
         else{
         DELEGATE.rootVC?.loginResponseModelDO = LoginResponseModel()
         DELEGATE.rootVC?.loginResponseModelDO?.profilePicURL = profilePicURL
         }
         
         return profilePicURL
         }
         else if let loginResponseModelDO = DELEGATE.rootVC?.loginResponseModelDO{
         
         if let profilePicURL = loginResponseModelDO.profilePicURL{
         return profilePicURL
         }
         }
         */
        return nil
    }
    
    static func saveAuthorizedUserInfo(_ userInfo: UserModel?) {
        if let v = userInfo?.toJSONString() {
            UserDefaults.standard.set(v, forKey: "authorizedUserInfo")
        }
        
        if let token = userInfo?.token, !token.isEmpty {
            UserModel.saveAccessToken(token)
        }
    }
    
    static func getAuthorizedUserInfo() -> UserModel? {
        if let data = UserDefaults.standard.object(forKey: "authorizedUserInfo") as? String {
            if let returnModel = Mapper<UserModel>().map(JSONString: data) {
                return returnModel
            }
            return nil
        } else {
            return nil
        }
    }
    
    static func resetUserData() {
        UserDefaults.standard.removeObject(forKey: "authorizedUserInfo")
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }
    
    static func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
    }

    static func getAccessToken() -> String {
        return UserDefaults.standard.object(forKey: "accessToken") as? String ?? ""
    }
    
    static func isAuthorized() -> Bool {
        return getAuthorizedUserInfo() != nil
    }
}

struct FileUpload : Mappable {
//    static var user:UserModel?
    var convertedName:String?
    var path: String?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.convertedName  <- map["converted_name"]
        self.path  <- map["path"]
   }
}

struct SubscriptionDetail: Mappable {
    
    var userCode, platform, productID: String?
    var superStoreID, storeID, parentPackageID, packageID: Int?
    var planID: Int?
    var planType, currency, amount, duration, country: String?
    var channelTag, subscriptionStatusDesc, subscriptionStartDate, subscriptionEndDate: String?
    var quantityAllowed, quantityConsumed, autoRenewal: Int?
    var subscriptionStatus : SubscriptionStatus?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        userCode <- map["user_code"]
        platform <- map["platform"]
        productID <- map["product_id"]
        superStoreID <- map[ "super_store_id"]
        storeID <- map["store_id"]
        parentPackageID <- map["parent_package_id"]
        packageID <- map["package_id"]
        planID <- map["plan_id"]
        planType <- map["plan_type"]
        currency <- map["currency"]
        amount <- map["amount"]
        duration <- map["duration"]
        country <- map["country"]
        channelTag <- map["channel_tag"]
        subscriptionStatusDesc <- map["subscription_status_desc"]
        subscriptionStartDate <- map["subscription_start_date"]
        subscriptionEndDate <- map["subscription_end_date"]
        quantityAllowed <- map["quantity_allowed"]
        quantityConsumed <- map["quantity_consumed"]
        autoRenewal <- map["auto_renewal"]
    }
}


enum SubscriptionStatus {
    case subscribed
    case unsubscribed
    case guest
}
