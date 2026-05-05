//
//  AppCofigGetModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation

struct AppCofigGetModel: Codable, Hashable {
    
//    let results: Data1?
//    
//    enum CodingKeys: String, CodingKey{
//        
//        case results
//    }
    
    
   // struct Data1: Codable, Hashable{
        
        let URLS: UrlgetConfig?
        let CUSTOM_MESSAGE: CustomMessage?
        let APP_VERSION: AppVersion?
        let MAINTENANCE_SETTINGS: MaintenanceSettings?
        //let BLOCK_APP: BlockApp?
        let RZ_CRED: RzCred?
        let GOOGLE_MAPS: GoogleMapsAppConfig?
        let free_trial_period_days: String?
        let free_trial_text: String?
    
        let woloo_subscription_points: String?
        let no_woloo_found: String?
        let take_me_here: String?
        let rate_a_toilet: String?
        let view_host_details: String?
        let set_thirst_reminder: String?
        let set_period_tracker: String?
        let powder_room_usage_charge: String?
        let cibil_score_range: CibilScoreRange?
    
    
        enum CodingKeys: String, CodingKey{
            
            case URLS
            case CUSTOM_MESSAGE
            case APP_VERSION
            case MAINTENANCE_SETTINGS
            //case BLOCK_APP
            case RZ_CRED
            case GOOGLE_MAPS
            case free_trial_period_days
            case free_trial_text
            case woloo_subscription_points
            case no_woloo_found
            case take_me_here
            case rate_a_toilet
            case view_host_details
            case set_thirst_reminder
            case set_period_tracker
            case cibil_score_range
            case powder_room_usage_charge
        }
   // }
    
    
    struct CibilScoreRange: Codable, Hashable{
        let three: String?
        let one: String?
        let four: String?
        let two: String?
        let five: String?
        
        enum CodingKeys: String, CodingKey{
            case three = "3"
            case one = "1"
            case four = "4"
            case two = "2"
            case five = "5"
        }
    }
    
    struct UrlgetConfig: Codable, Hashable{
        let about_url: String?
        let terms_url: String?
        let app_share_url: String?
        let free_trial_image_url: String?
        let shop_bg_image_url: String?
        
        enum CodingKeys: String, CodingKey{
            case about_url
            case terms_url
            case app_share_url
            case free_trial_image_url
            case shop_bg_image_url
        }
    }
    
    struct CustomMessage: Codable, Hashable{
        
        let logoutDialog: String?
        let isSocialLoginEnable: String?
        let freeTrialDialogText: String?
        let addReviewSuccessDialogText: String?
        let arrivedDestinationDialogText: String?
        let subscribeNowDialogText: String?
        let paymentSuccessDialogText: String?
        let QRCodeScanningSuccessDialog: String?
        let referralRewardMessage: String?
        let arrivedDestinationText: String?
        let arrivedDestinationPoints: String?
        let inviteFriendText: String?
        let wolooReferHostText: String?
        let cancelSubscriptionReasons: String?
        
        
        enum CodingKeys: String, CodingKey{
            
            case logoutDialog
            case isSocialLoginEnable
            case freeTrialDialogText
            case addReviewSuccessDialogText
            case arrivedDestinationDialogText
            case subscribeNowDialogText
            case paymentSuccessDialogText
            case QRCodeScanningSuccessDialog
            case referralRewardMessage
            case arrivedDestinationText
            case arrivedDestinationPoints
            case inviteFriendText
            case wolooReferHostText
            case cancelSubscriptionReasons
        }
    }
    
    struct AppVersion: Codable, Hashable{
        
        let version_code: String?
        let force_update: String?
        let update_text: String?
        
        enum CodingKeys: String, CodingKey{
            
            case version_code
            case force_update
            case update_text
        }
        
    }
    
    struct MaintenanceSettings: Codable, Hashable{
        let MaintenanceFlag: String?
        let MaintenanceMessage: String?
        
        enum CodingKeys: String, CodingKey{
            
            case MaintenanceFlag
            case MaintenanceMessage
        }
    }
    
//    struct BlockApp: Codable, Hashable{
//
//        let 1: String
//
//        enum CodingKeys: String, CodingKey{
//
//
//            case 1
//
//        }
//    }
    
    struct RzCred: Codable, Hashable{
        let key: String?
        
        enum CodingKeys: String, CodingKey{
            case key
        }
    }
    
    struct GoogleMapsAppConfig: Codable, Hashable{
        
        let key: String?
        
        enum CodingKeys: String, CodingKey{
            
            case key
        }
    }
    
}

