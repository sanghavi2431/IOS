//
//  UserProfileModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 29/06/23.
//

import Foundation
import Alamofire
import UIKit

struct UserProfileModel: Codable{

    var isFutureSubcriptionExist: Bool?

    var planData: PlanData?
    
    var futureSubcription: FutureSubscription?
    var purchase_by: String?
    var lifetime_free: Int?
    var totalCoins: TotalCoins?
    var profile: Profile?
    enum CodingKeys: String, CodingKey{

        case isFutureSubcriptionExist = "isFutureSubcriptionExist"

        case planData = "planData"
        case lifetime_free = "lifetime_free"
        case purchase_by = "purchase_by"
        case totalCoins = "totalCoins"
        case profile = "profile"
    }

    struct PlanData: Codable, Hashable{

        var is_expired: Int?
        var is_voucher: Int?
        var price_with_gst: String?
        var status: Int?
        var apple_product_id: String?
        var strike_out_price: Int?
        var start_at: String?
        var image: String?
        var days: String?
        var updated_at: String?
        var is_recommended: Int?
        var currency: String?
        var backgroud_color: String?
        var discount: String?
        var end_at: String?
        //var is_cancel: Bool?
        var name: String?
        var shield_color: String?
        var plan_id: String?
        var apple_product_price: String?
        var id: Int?
        var deleted_at: String?
       // var insurance_desc
        var created_at: String?
        var frequency: String?
        var price: String?
        //var is_insurance_available
       // var before_discount_price:
        var description: String?
        
        enum CodingKeys: String, CodingKey{

            case is_expired = "is_expired"
            case is_voucher = "is_voucher"
            case price_with_gst = "price_with_gst"
            case status = "status"
            case apple_product_id = "apple_product_id"
            case strike_out_price = "strike_out_price"
            case start_at = "start_at"
            case image = "image"
            case days = "days"
            case updated_at = "updated_at"
            case is_recommended = "is_recommended"
            case currency = "currency"
            case backgroud_color = "backgroud_color"
            case discount = "discount"
            case end_at = "end_at"
            //case is_cancel = "is_cancel"
            case name = "name"
            case shield_color = "shield_color"
            case plan_id = "plan_id"
            case apple_product_price = "apple_product_price"
            case id = "id"
            case deleted_at = "deleted_at"
            //case insurance_desc = "insurance_desc"
            case created_at = "created_at"
            case frequency = "frequency"
            case price = "price"
            //case is_insurance_available = "is_insurance_available"
            //case before_discount_price = "before_discount_price"
            case description = "description"
        }
    }
    
    struct FutureSubscription: Codable, Hashable{
        
        var is_expired: Int?
        var is_voucher: Int?
        var price_with_gst: String?
        var status: Int?
        var apple_product_id: String?
        var strike_out_price: Int?
        var start_at: String?
        var image: String?
        var days: String?
        var updated_at: String?
        var is_recommended: Int?
        var currency: String?
        var backgroud_color: String?
        var discount: String?
        var end_at: String?
        //var is_cancel: Bool?
        var name: String?
        var shield_color: String?
        var plan_id: String?
        var apple_product_price: String?
        var id: Int?
        var deleted_at: String?
       // var insurance_desc
        var created_at: String?
        var frequency: String?
        var price: String?
        //var is_insurance_available
       // var before_discount_price:
        var description: String?
        
        enum CodingKeys: String, CodingKey{
            case is_expired = "is_expired"
            case is_voucher = "is_voucher"
            case price_with_gst = "price_with_gst"
            case status = "status"
            case apple_product_id = "apple_product_id"
            case strike_out_price = "strike_out_price"
            case start_at = "start_at"
            case image = "image"
            case days = "days"
            case updated_at = "updated_at"
            case is_recommended = "is_recommended"
            case currency = "currency"
            case backgroud_color = "backgroud_color"
            case discount = "discount"
            case end_at = "end_at"
            //case is_cancel = "is_cancel"
            case name = "name"
            case shield_color = "shield_color"
            case plan_id = "plan_id"
            case apple_product_price = "apple_product_price"
            case id = "id"
            case deleted_at = "deleted_at"
            //case insurance_desc = "insurance_desc"
            case created_at = "created_at"
            case frequency = "frequency"
            case price = "price"
            //case is_insurance_available = "is_insurance_available"
            //case before_discount_price = "before_discount_price"
            case description = "description"
        }
        
    }
    
    struct Profile: Codable, Hashable{
        
        var created_at: String?
        var id: Int?
        var pincode: String?
        var pan_url: String?
        var state: String?
        var address: String?
        var woloo_id: Int?
        var deleted_at: String?
        var is_thirst_reminder: Int?
        var lifetime_free: Int?
        var isFutureSubcriptionExist: Bool?
        var subscription_id: Int?
        var dob: String?
        var gp_id: String?
        var expiry_date: String?
        var thirst_reminder_hours: Int?
        var is_blog_content_notification: Int?
        var is_first_session: Int?
        var aadhar_url: String?
        var email: String?
        var otp: Int?
        var name: String?
        var city: String?
        var avatar: String?
        var lng: Double?
        var baseUrl: String? = ""
        var status: Int?
        var mobile: Int?
        var fb_id: String?
        //var settings:
        var sponsor_id: Int?
        var alternate_mob: Int?
        var lat: Double?
        var gift_subscription_id: Int?
        var updated_at: String?
        var gender: String?
        var voucher_id: Int?
        var ref_code: String?
        var role_id: Int?
        
        
        enum CodingKeys: String, CodingKey{
            
            case created_at = "created_at"
            case id = "id"
            case pincode = "pincode"
            case pan_url = "pan_url"
            case state = "state"
            case address = "address"
            case woloo_id = "woloo_id"
            case deleted_at = "deleted_at"
            case is_thirst_reminder = "is_thirst_reminder"
            case lifetime_free = "lifetime_free"
            case isFutureSubcriptionExist = "isFutureSubcriptionExist"
            case subscription_id = "subscription_id"
            case dob = "dob"
            case gp_id = "gp_id"
            case expiry_date = "expiry_date"
            case thirst_reminder_hours = "thirst_reminder_hours"
            case is_blog_content_notification = "is_blog_content_notification"
            case is_first_session = "is_first_session"
            case aadhar_url = "aadhar_url"
            case email = "email"
            case otp = "otp"
            case name = "name"
            case city = "city"
            case avatar = "avatar"
            case lng = "lng"
            case baseUrl = "base_url"
            case status = "status"
            case mobile = "mobile"
            case fb_id = "fb_id"
            //case settings = "settings"
            case sponsor_id = "sponsor_id"
            case alternate_mob = "alternate_mob"
            case lat = "lat"
            case gift_subscription_id = "gift_subscription_id"
            case updated_at = "updated_at"
            case gender = "gender"
            case voucher_id = "voucher_id"
            case ref_code = "ref_code"
            case role_id = "role_id"
         
        }
        
    }
    
    
    struct TotalCoins: Codable, Hashable{
        
        var total_coins: Int?
        var gift_coins: Int?
        
        enum CodingKeys: String, CodingKey{
            
            case total_coins = "total_coins"
            case gift_coins = "gift_coins"
        }
        
    }
    
    static func storeUserData(_ userInfo: UserProfileModel?) {
        
        let data = try? JSONEncoder().encode(userInfo)
        UserDefaults.standard.set(data, forKey: "user_Data")
        UserDefaults.standard.synchronize()
    }
    
    static func fetchUserData() -> UserProfileModel? {
        let data = UserDefaults.standard.data(forKey: "user_Data")
        if data == nil {return nil}
        let value = try? JSONDecoder().decode(UserProfileModel.self, from: data!)
        return value ?? nil
    }
    
    static func fetchUserProfileV2(showLoading: Bool? = true ,completion: @escaping (UserProfileModel?) -> Void){
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
            return
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        
        NetworkManager(headers: headers, url: nil, service: .userProfile, method: .get, isJSONRequest: false).executeQuery { (result: Result<BaseResponse<UserProfileModel>, Error>) in
            switch result {
                
            case .success(let response):
                print("User Profile API response: ", response)
                //UserDefaultsManager.storeUserData(value: response.results)

               //self.setUerInfoV2()
                UserProfileModel.storeUserData(response.results)
                
            case .failure(let error):
                print("User Profile error: ", error)
                
            }
        }
        
    }
    
}
/*
 "status": null,
 "mobile": 8888153610,
 "fb_id": null,
 "settings": null,
 "sponsor_id": null,
 "alternate_mob": 0,
 "lat": 21.1993259,
 "gift_subscription_id": null,
 "updated_at": "2023-05-24 13:13:17",
 "gender": "Male",
 "voucher_id": 173,
 "ref_code": "GM1LISWD0H",
 "role_id": null*/
