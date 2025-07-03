//
//  VerifyOtpModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation

struct VerifyOtpModel: Codable, Hashable{
    
    let user: UserOtp?
    let token: String?
    let user_id: Int?
    
    enum CodingKeys: String, CodingKey{
        
        case user
        case token
        case user_id
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(UserOtp.self, forKey: .user)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
    }
    
    struct UserOtp: Codable, Hashable{
        let id : Int? //Int
        let role_id: Int? //int
        let name: String? //String
        let email: String? //Varchar
        let shop_password: String? //String
        let remember_token: String? //String
        let mobile: String? //String
        let city: String? //String
        let pincode: String? //String
        let address: String? //String
        let avatar: String? //String
        let fb_id: String? //Varchar
        let gp_id: String? //Varchar
        let ref_code: String? //String
        let sponsor_id: String? //Int ---------//String
        let woloo_id: String? //Int -------------//String
        let subscription_id: String? //Int  -------------//String
        let expiry_date: String? //date
        let voucher_id: String? //Int  -------------//String
        let gift_subscription_id: String? //Int  -------------//String
        let lat: String? //String
        let lng: String? //String
       
        let otp: Int? //Int
        let status: String? //Int?  -------------//String
        let settings: String? //String
        let created_at: String? //String
        let updated_at: String? //String
        let deleted_at: String? //String
        let gender: String? //Varchar
        let is_first_session: Int? //tiny Int bool
        let dob: String? //String
        let is_thirst_reminder: Int? //tiny Int bool
        let thirst_reminder_hours: String? //Int ---------------//String
        let is_blog_content_notification: Int? //tiny Int bool
        let isFreeTrial: Int?
        let isRegister: Int?
        
        enum CodingKeys: String, CodingKey{
            case id
            case role_id
            case name
            case email
            case shop_password
            case remember_token
            case mobile
            case city
            case pincode
            case address
            case avatar
            case fb_id
            case gp_id
            case ref_code
            case sponsor_id
            case woloo_id
            case subscription_id
            case expiry_date
            case voucher_id
            case gift_subscription_id
            case lat
            case lng
            case otp
            case status
            case settings
            case created_at
            case updated_at
            case deleted_at
            case gender
            case is_first_session
            case dob
            case is_thirst_reminder
            case thirst_reminder_hours
            case is_blog_content_notification
            case isFreeTrial
            case isRegister
        }
        
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            role_id = try values.decodeIfPresent(Int.self, forKey: .role_id)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            email = try values.decodeIfPresent(String.self, forKey: .email)
            shop_password = try values.decodeIfPresent(String.self, forKey: .shop_password)
            
            isRegister = try values.decodeIfPresent(Int.self, forKey: .isRegister)
            remember_token = try values.decodeIfPresent(String.self, forKey: .remember_token)
            mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
            city = try values.decodeIfPresent(String.self, forKey: .city)
            pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
            address = try values.decodeIfPresent(String.self, forKey: .address)
            avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
            fb_id = try values.decodeIfPresent(String.self, forKey: .fb_id)
            gp_id = try values.decodeIfPresent(String.self, forKey: .gp_id)
            ref_code = try values.decodeIfPresent(String.self, forKey: .ref_code)
            sponsor_id = try values.decodeIfPresent(String.self, forKey: .sponsor_id)
            woloo_id = try values.decodeIfPresent(String.self, forKey: .woloo_id)
            subscription_id = try values.decodeIfPresent(String.self, forKey: .subscription_id)
            expiry_date = try values.decodeIfPresent(String.self, forKey: .expiry_date)
            voucher_id = try values.decodeIfPresent(String.self, forKey: .voucher_id)
            gift_subscription_id = try values.decodeIfPresent(String.self, forKey: .gift_subscription_id)
            lat = try values.decodeIfPresent(String.self, forKey: .lat)
            lng = try values.decodeIfPresent(String.self, forKey: .lng)
            otp = try values.decodeIfPresent(Int.self, forKey: .otp)
            status = try values.decodeIfPresent(String.self, forKey: .status)
            settings = try values.decodeIfPresent(String.self, forKey: .settings)
            created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
            updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
            deleted_at = try values.decodeIfPresent(String.self, forKey: .deleted_at)
            gender = try values.decodeIfPresent(String.self, forKey: .gender)
            is_first_session = try values.decodeIfPresent(Int.self, forKey: .is_first_session)
            dob = try values.decodeIfPresent(String.self, forKey: .dob)
            is_thirst_reminder = try values.decodeIfPresent(Int.self, forKey: .is_thirst_reminder)
            thirst_reminder_hours = try values.decodeIfPresent(String.self, forKey: .thirst_reminder_hours)
            is_blog_content_notification = try values.decodeIfPresent(Int.self, forKey: .is_blog_content_notification)
            isFreeTrial = try values.decodeIfPresent(Int.self, forKey: .isFreeTrial)
        }
    }
}

