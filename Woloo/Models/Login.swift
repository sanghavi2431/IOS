//
//  Login.swift
//  Woloo
//
//  Created by Ashish Khobragade on 04/01/21.
//

import UIKit
import ObjectMapper

struct Login: Mappable {
    
    var userMobile,userEmail: String?
    var otp: Int?
    var locale: Locale?
    var referralCode: String?
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        otp <- map["password"]
        userMobile <- map["mobileNumber"]
        userEmail <- map["email"]
        locale <- map["locale"]
        referralCode <- map["referral_code"]
    }
}


// MARK: - VerificationResponse
struct VerificationResponse :Mappable{
    
    var userData: UserModel?
    var status : Status?
    var message : String?
    var token : String?
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        userData <- map["user"]
        status <- map["status"]
        message <- map["message"]
        token <- map["token"]
    }
}

struct ProfileResponse :Mappable{
    
    var userData: UserModel?
    var status : Status?
    var message : String?

    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {

        userData <- map["user_data"]
        status <- map["status"]
        message <- map["message"]
    }
}


