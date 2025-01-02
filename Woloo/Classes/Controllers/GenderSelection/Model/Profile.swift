//
//  Profile.swift
//  Woloo
//
//  Created by Kapil Dongre on 10/09/24.
//

import Foundation

struct Profile: Codable{
    
    var id: Int?
    var role_id: Int?
    var name: String? = ""
    var email: String? = ""
    //var remember_token:
    var mobile: String? = ""
    var city: String? = ""
    var pincode: String? = ""
    var address: String? = ""
    var avatar: String? = ""
    var fb_id: String? = ""
    var gp_id: String? = ""
    var ref_code: String? = ""
    var sponsor_id: Int?
    var woloo_id: Int?
    var subscription_id: Int?
    var expiry_date: String? = ""
    var voucher_id: Int?
    var gift_subscription_id: Int?
    var lat: String? = ""
    var lng: String? = ""
    var otp: Int?
    var status: Int?
    //var settings
    var created_at: String? = ""
    var updated_at: String? = ""
    var deleted_at: String? = ""
    var gender: String? = ""
    var is_first_session: Int?
    var dob: String? = ""
    var is_thirst_reminder: Int?
    var thirst_reminder_hours: Int?
    var is_blog_content_notification: Int?
    var aadhar_url: String? = ""
    var pan_url: String? = ""
    var state: String? = ""
    var alternate_mob: Int?
   /// var svocid
  //  var isDummyPassword: Int?
    var base_url: String? = ""
    
}
