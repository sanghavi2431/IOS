//
//  File.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import Foundation

extension Bundle{
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    class func getBundleDisplayName() -> String {
        return  Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
   class func getBundleId() -> String {
        
        //guard let infoDictionary = Bundle.main.infoDictionary else { return "" }
        let infoDictionary = "in.woloo.app"
    
        if API.environment == .preProd{
            
            //return infoDictionary["CFBundleIdentifier"] as! String + "_pp"
            return "in.woloo.app" + "_pp"
        }
        else{
             //return infoDictionary["CFBundleIdentifier"] as! String
            return "in.woloo.app"
        }
    }
    
    class func getBundleMainVersion() -> String {
        
//        guard let infoDictionary = Bundle.main.infoDictionary else { return "" }
//
//        return infoDictionary["CFBundleShortVersionString"] as! String
        
        return "in.woloo.app"
    }
    
    class func getBundleVersion() -> String {
        
//        guard let infoDictionary = Bundle.main.infoDictionary else { return "" }
//
//        return infoDictionary["CFBundleVersion"] as! String
        
        return "in.woloo.app"
    }
   
}
