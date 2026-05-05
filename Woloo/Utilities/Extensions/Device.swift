//
//  Device.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit

struct Device {
    static let IS_TV             = UIDevice.current.userInterfaceIdiom == .tv
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_XMAX : Bool = UIScreen.main.nativeBounds.height == 2688 ? true : false
    static let IS_IPHONE_XR : Bool = UIScreen.main.nativeBounds.height == 1792 ? true : false
    static let IS_IPHONE_6_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  <= 667
    static let IS_IPHONE_ABOVE_6 = IS_IPHONE && SCREEN_MAX_LENGTH  > 667
    
    
    /* //Documentations - Ashish K
     -remove this method if device manager is added
     */
    func getDeviceIdentifierForVendor(completion: @escaping (_ identifier:String) -> ()) {
        
        if let identifier = KeychainWrapper.standard.string(forKey: "Device_Identifier"){
            
            //            Logger.shared.showLog(identifier)
            
            completion(identifier)
        }
        else if let identifier: String = UIDevice.current.identifierForVendor?.uuidString  {
            
            KeychainWrapper.standard.set(identifier, forKey: "Device_Identifier")
            
            //            Logger.shared.showLog(identifier)
            
            completion(identifier)
        }
    }
}
