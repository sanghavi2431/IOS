//
//  CoinHistoryModelV2.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 31/08/23.
//

import Foundation

enum HistoryType : String, CaseIterable {
    case WolooNavigationRewardCredits = "Woloo Navigation Reward credits"
    case RegistrationPoint = "Registration Point"
    case GiftReceived = "Gift Received"
    case GiftSent = "Gift Sent"
    case ReferralPoint = "Referral Point"
    case ApproveRecommendWolooCredits = "Approve Recommend woloo credits"
    case NoWolooFoundReward = "No woloo found reward"
    case RecommendWolooCredits = "Recommend woloo credits"
    case AddCoins = "Add Coins"
    case UsingWolooServiceAtParticularHost = "Using Woloo Service at a particular host"
    case GiftPointsDeducted = "Gift points deducted"
    case BlogReadPoint = "Blog Read Point"
    case WAHCertificatePoint = "WAH Certificate Point"

    var historyImage : UIImage {
        switch self {
        case .WolooNavigationRewardCredits:
            return UIImage(named: "WolooNavigationRewardCredits") ?? #imageLiteral(resourceName: "woloo_default")
        case .RegistrationPoint:
            return UIImage(named: "RegistrationPoint") ?? #imageLiteral(resourceName: "woloo_default")
        case .GiftReceived:
            return UIImage(named: "GiftRecieved") ?? #imageLiteral(resourceName: "woloo_default")
        case .GiftSent:
            return UIImage(named: "GiftSent") ?? #imageLiteral(resourceName: "woloo_default")
        case .ReferralPoint:
            return UIImage(named: "ReferralPoint") ?? #imageLiteral(resourceName: "woloo_default")
        case .ApproveRecommendWolooCredits:
            return UIImage(named: "ApproveRecommendWolooCredits") ?? #imageLiteral(resourceName: "woloo_default")
        case .RecommendWolooCredits:
            return UIImage(named: "RecommendWolooCredits") ?? #imageLiteral(resourceName: "woloo_default")
        case .NoWolooFoundReward:
            return UIImage(named: "NoWolooFoundReward") ?? #imageLiteral(resourceName: "woloo_default")
        case .AddCoins:
            return UIImage(named: "AddCoins") ?? #imageLiteral(resourceName: "woloo_default")
        case .UsingWolooServiceAtParticularHost:
            return  #imageLiteral(resourceName: "woloo_default")
        case .GiftPointsDeducted:
            return UIImage(named: "VOUCHER") ?? #imageLiteral(resourceName: "woloo_default")
            
        case .WAHCertificatePoint:
            return UIImage(named: "AddCoins") ?? #imageLiteral(resourceName: "woloo_default")
            
        case .BlogReadPoint:
            return UIImage(named: "AddCoins") ?? #imageLiteral(resourceName: "woloo_default")
            
        default :
            return #imageLiteral(resourceName: "woloo_default")
        }
    }
    
    func setTitleWithEnum(text: String?) -> String {
        switch self {
        case .WolooNavigationRewardCredits:
            return "Woloo Navigation used to reach Woloo Host, \(text ?? "")"
        case .RegistrationPoint:
            return "Completing your registration process"
        case .GiftReceived:
            return "Received Gift \(text ?? "")"
        case .GiftSent:
            return "Purchase of Woloo Gift Card \(text ?? "")"
        case .ReferralPoint:
            return "Successful Referral made \(text ?? "")"
        case .ApproveRecommendWolooCredits:
            return "Recommended Woloo Host \(text ?? "") approved by Woloo"
        case .RecommendWolooCredits:
            return "Recommended \(text ?? "") to be included as Woloo Host"
        case .NoWolooFoundReward:
            return "Enjoy Woloo Points till we get Woloo at your searched location \(text ?? "")"
        case .AddCoins:
            return "Purchase of Coins \(text ?? "")"
        case .UsingWolooServiceAtParticularHost:
            return "Woloo Service used at \(text ?? "")"
        case .GiftPointsDeducted:
            return "Gift Points Deducted \(text ?? "")"
        case .BlogReadPoint:
            return "\(text ?? "")"
        case .WAHCertificatePoint:
            return "\(text ?? "" )"
        }
    }
    
}


struct CoinHistoryModelV2: Codable{
    
    var total_count: Int?
    var historyCount: Int?
    var history: [HistoryModelV2]? = []
    var last_page: Int?
    
    enum CodingKeys: String, CodingKey{
        case total_count = "total_count"
        case historyCount = "history_count"
        case history = "history"
        case last_page = "last_page"
    }
    

}

struct HistoryModelV2: Codable{
    
    var id: Int?
    var user_id: Int?
    var blog_id: Int?
    var woloo_id: Int?
    var transaction_type: String?
    var remarks: String?
    var value: String?
    var type: String?
    var status: Int?
    var is_expired: Int?
    var is_gift: Int?
    var expired_on: String?
    var created_at: String?
    var updated_at: String?
    var sender_receiver_id: Int?
    var message: String?
    var woloo_details: UserHistory?
    var sender: Sender?
    
    
    enum CodingKeys: String, CodingKey{
        
        case id = "id"
        case user_id = "user_id"
        case blog_id = "blog_id"
        case woloo_id = "woloo_id"
        case transaction_type = "transaction_type"
        case remarks = "remarks"
        case value = "value"
        case type = "type"
        case status = "status"
        case is_expired = "is_expired"
        case is_gift = "is_gift"
        case expired_on = "expired_on"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case sender_receiver_id = "sender_receiver_id"
        case message = "message"
        case woloo_details = "woloo_details"
        case sender = "sender"
        
    }
    
    var historyTypeTitle: String? {
        if let type = HistoryType.init(rawValue: type ?? "") {
            switch type {
            case .WolooNavigationRewardCredits:
                if let hostName = woloo_details?.name?.capitalized {
                    return type.setTitleWithEnum(text: hostName)
                } else {
                    return type.setTitleWithEnum(text: woloo_details?.name?.capitalized ?? "")
                }
            case .RegistrationPoint:
                return type.setTitleWithEnum(text: woloo_details?.name?.capitalized ?? "")
                break
            case .GiftReceived, .GiftSent:
                if let senderMobile = sender?.mobile, let senderName = sender?.name?.capitalized {
                    return type.setTitleWithEnum(text: "\(type == .GiftReceived ? "from" : "for") \(senderName )-\(senderMobile)")
                } else {
                    return type.setTitleWithEnum(text: "\(sender?.name?.capitalized ?? "")")
                }
            case .ReferralPoint:
                let referralMobile = sender?.mobile
                return type.setTitleWithEnum(text: referralMobile ?? "")
            case .ApproveRecommendWolooCredits:
                return type.setTitleWithEnum(text: woloo_details?.name?.capitalized ?? "")
            case .RecommendWolooCredits:
                return type.setTitleWithEnum(text: woloo_details?.name?.capitalized ?? "")
            case .NoWolooFoundReward:
                return type.setTitleWithEnum(text: woloo_details?.address?.capitalized ?? "")
            case .AddCoins:
                return type.setTitleWithEnum(text: value ?? "")
            case .UsingWolooServiceAtParticularHost:
                if let hostName = woloo_details?.name?.capitalized, let location = woloo_details?.address {
                    return type.setTitleWithEnum(text: "\(hostName) - \(location)" )
                } else {
                    return type.setTitleWithEnum(text: "\(woloo_details?.name?.capitalized ?? "") - \(woloo_details?.address ?? "")" )
                }
            case .GiftPointsDeducted:
                return type.setTitleWithEnum(text: "\(woloo_details?.name ?? "")")
            case .BlogReadPoint:
                return type.setTitleWithEnum(text: "\(remarks ?? "")")
            case .WAHCertificatePoint:
                return type.setTitleWithEnum(text: "\(remarks ?? "")")
            }
        }
        
        return self.type
    }
    
    var imageTypeTitle: UIImage? {
        if let type = HistoryType.init(rawValue: type ?? "") {
            return type.historyImage
        }
        return #imageLiteral(resourceName: "woloo_default")
    }
}


 
 
 struct Sender: Codable{
     
     var id: Int?
     var name: String?
     var mobile: String?
     var role_id: String?
     var email: String?
     var password: String?
     var remember_token: String?
     var city: String?
     var pincode: String?
     var avatar: String?
     
     enum CodingKeys: String, CodingKey{
         
         case name = "name"
         case mobile = "mobile"
         case id = "id"
         case role_id = "role_id"
         case email = "email"
         case password = "password"
         case remember_token = "remember_token"
         case city = "city"
         case pincode = "pincode"
         case avatar = "avatar"
     }
 }
