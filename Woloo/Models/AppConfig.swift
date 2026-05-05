//
//  AppConfig.swift
//  Woloo
//
//  Created by ideveloper1 on 27/04/21.
//

import Foundation
import ObjectMapper

struct AppConfigResponse: Mappable {
    var code: Int?
    var status : Status?
    var message : String?
    var data: AppConfig?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }
}

struct AppConfig: Mappable {
    var urls: URLS?
    var customMessage: CUSTOM_MESSAGE?
    var appVersion: APP_VERSION?
    var maintenanceSetting: MAINTENANCE_SETTINGS?
    var blockApp: [String: Any] = [:]
    var credPay: RZ_CRED?
    var googleMap: GOOGLE_MAPS?
    var supportEmail: SUPPORT_EMAIL?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        urls <- map["URLS"]
        customMessage <- map["CUSTOM_MESSAGE"]
        appVersion <- map["APP_VERSION"]
        maintenanceSetting <- map["MAINTENANCE_SETTINGS"]
        blockApp <- map["BLOCK_APP"]
        credPay <- map["RZ_CRED"]
        appVersion <- map["APP_VERSION"]
        googleMap <- map["GOOGLE_MAPS"]
        supportEmail <- map["SUPPORT_EMAIL"]
    }
    
    static func saveAppConfigInfo(_ info: AppConfig?) {
        if let v = info?.toJSONString() {
            UserDefaults.standard.set(v, forKey: "AppConfigInfo")
        }
    }
    
    static func getAppConfigInfo() -> AppConfig? {
        if let data = UserDefaults.standard.object(forKey: "AppConfigInfo") as? String {
            if let returnModel = Mapper<AppConfig>().map(JSONString: data) {
                return returnModel
            }
            return nil
        } else {
            return nil
        }
    }
    
    static func resetConfigData() {
        UserDefaults.standard.removeObject(forKey: "AppConfigInfo")
    }

}

struct URLS: Mappable {
    var aboutURL: String?
    var termsURL: String?
    var appShareURL: String?
    var freeTrialImageURL: String?
    var shopBgImageURL: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        aboutURL <- map["about_url"]
        termsURL <- map["terms_url"]
        appShareURL <- map["app_share_url"]
        freeTrialImageURL <- map["free_trial_image_url"]
        shopBgImageURL <- map["shop_bg_image_url"]
    }
}

struct CUSTOM_MESSAGE: Mappable {
    var logoutDialog: String?
    var isSocialLoginEnable: String?
    var freeTrialDialogText: String?
    var addReviewSuccessDialogText: String?
    var arrivedDestinationDialogText: String? // not used
    var subscribeNowDialogText: String? // not used
    var paymentSuccessDialogText: String?
    var QRCodeScanningSuccessDialog: String?
    var referralRewardMessage: String?
    var arrivedDestinationText: String?
    var arrivedDestinationPoints: String?
    var inviteFriendText: String?
    var wolooReferHostText: String?
    var cancelSubscriptionReasons: String?
    
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        logoutDialog <- map["logoutDialog"]
        isSocialLoginEnable <- map["isSocialLoginEnable"]
        freeTrialDialogText <- map["freeTrialDialogText"]
        addReviewSuccessDialogText <- map["addReviewSuccessDialogText"]
        arrivedDestinationDialogText <- map["arrivedDestinationDialogText"]
        subscribeNowDialogText <- map["subscribeNowDialogText"]
        paymentSuccessDialogText <- map["paymentSuccessDialogText"]
        QRCodeScanningSuccessDialog <- map["QRCodeScanningSuccessDialog"]
        referralRewardMessage <- map["referralRewardMessage"]
        arrivedDestinationText <- map["arrivedDestinationText"]
        arrivedDestinationPoints <- map["arrivedDestinationPoints"]
        inviteFriendText <- map["inviteFriendText"]
        wolooReferHostText <- map["wolooReferHostText"]
        cancelSubscriptionReasons <- map["cancelSubscriptionReasons"]
    }
}

struct APP_VERSION: Mappable {
    
    var version_code: String?
    var force_update: String?
    var update_text: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        version_code <- map["version_code"]
        force_update <- map["force_update"]
        update_text <- map["update_text"]
    }
}

struct MAINTENANCE_SETTINGS: Mappable {
    var maintenanceFlag: String?
    var maintenanceMessage: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        maintenanceFlag <- map["MaintenanceFlag"]
        maintenanceMessage <- map["MaintenanceMessage"]
    }
}

struct RZ_CRED: Mappable {
    var key: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        key <- map["key"]
    }
}

struct GOOGLE_MAPS: Mappable {
    var key: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        key <- map["key"]
    }
}

struct SUPPORT_EMAIL: Mappable {
    var key: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        key <- map["id"]
    }
}
