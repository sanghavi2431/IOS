//
//  Constant.swift
//  JetLiveStream
//
//  Created by Ashish Khobragade on 25/09/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import Foundation
import UIKit

let kUserPlaceholderURL = "https://app.woloo.in/public/userProfile/default.png"

let DEVICE_TYPE = "iOS"
struct Constant {
    
    static let width : CGFloat = UIScreen.main.bounds.width
    static let height : CGFloat = UIScreen.main.bounds.height
   
    #if os(iOS)
    static let safeAreaWidth : CGFloat = UIScreen.main.bounds.width
    static let safeAreaHeight : CGFloat = UIScreen.main.bounds.height
    #elseif os(tvOS)
    static let safeAreaWidth : CGFloat = UIScreen.main.bounds.width - 180
    static let safeAreaHeight : CGFloat = UIScreen.main.bounds.height - 120
    #endif

    static let containerViewTopCornerRadius:CGFloat = 50
    
    // SWIFTY STORE KIT (LATEST)
//    let subscriptionSecretkey = "ed7bba068b8b464381940872053f48e4"
    static let productIdentifierOneMonth = "in.woloo.app.30Days"
    static let inAppPurchaseReceiptValidationKey:String = "b139bd6a853f48bbade3d7a2190c1841"
    static let NCINAPPPURCHASE = "NCINAPPPURCHASE"
    
    struct Segue {
        
        static let details:String = "Details"
        static let launchTabBar:String = "LaunchTabBar"
        static let authentication:String = "AuthenticationSegue"
        static let otpSegue:String = "OPTSegue"
        static let WoloosVCSegue:String = "WoloosVCSegue"
        static let privacyPolicySegue: String = "PrivacyPolicySegue"
        
    }
   
    struct WSTag {
        internal static let TEXT_FIELD_HSPACE: CGFloat = 6.0
        internal static let MINIMUM_TEXTFIELD_WIDTH: CGFloat = 56.0
        internal static let STANDARD_ROW_HEIGHT: CGFloat = 25.0
    }

    struct ApiKey {
        internal static let razorPayId = "rzp_live_A0MkofC7Jj2xXK"
        internal static let razorPaySecret = "C1NtGb49gh1ZbBusYLCo3TfF"
        internal static let googleMap = "AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4"//woloo
        internal static let googlePlace = ""
        
        //SHOP KEYS
        internal static let x_publishable_Shop_key = "pk_03b79693816aae4cb87568dc50b7efaa48e0d51b201040f46ef4528839078f08"
        
        internal static let Cookie_Shop_key = "connect.sid=s%3AdcthEhfUBOPsTjXAKPBWdspA6IlfLFHo.%2FdBejPS40GXEq5MGajotWKEn3wnplq%2FNDXqRjkIMwuU"
    }
}
