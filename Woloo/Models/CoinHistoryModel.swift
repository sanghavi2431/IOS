//
//  CoinHistoryModel.swift
//  Woloo
//
//  Created on 23/04/21.
//

import Foundation
import ObjectMapper

//enum HistoryType : String, CaseIterable {
//    case WolooNavigationRewardCredits = "Woloo Navigation Reward credits"
//    case RegistrationPoint = "Registration Point"
//    case GiftReceived = "Gift Received"
//    case GiftSent = "Gift Sent"
//    case ReferralPoint = "Referral Point"
//    case ApproveRecommendWolooCredits = "Approve Recommend woloo credits"
//    case NoWolooFoundReward = "No woloo found reward"
//    case RecommendWolooCredits = "Recommend woloo credits"
//    case AddCoins = "Add Coins"
//    case UsingWolooServiceAtParticularHost = "Using Woloo Service at a particular host"
//    case GiftPointsDeducted = "Gift points deducted"
//
//    var historyImage : UIImage {
//        switch self {
//        case .WolooNavigationRewardCredits:
//            return UIImage(named: "WolooNavigationRewardCredits") ?? #imageLiteral(resourceName: "woloo_default")
//        case .RegistrationPoint:
//            return UIImage(named: "RegistrationPoint") ?? #imageLiteral(resourceName: "woloo_default")
//        case .GiftReceived:
//            return UIImage(named: "GiftRecieved") ?? #imageLiteral(resourceName: "woloo_default")
//        case .GiftSent:
//            return UIImage(named: "GiftSent") ?? #imageLiteral(resourceName: "woloo_default")
//        case .ReferralPoint:
//            return UIImage(named: "ReferralPoint") ?? #imageLiteral(resourceName: "woloo_default")
//        case .ApproveRecommendWolooCredits:
//            return UIImage(named: "ApproveRecommendWolooCredits") ?? #imageLiteral(resourceName: "woloo_default")
//        case .RecommendWolooCredits:
//            return UIImage(named: "RecommendWolooCredits") ?? #imageLiteral(resourceName: "woloo_default")
//        case .NoWolooFoundReward:
//            return UIImage(named: "NoWolooFoundReward") ?? #imageLiteral(resourceName: "woloo_default")
//        case .AddCoins:
//            return UIImage(named: "AddCoins") ?? #imageLiteral(resourceName: "woloo_default")
//        case .UsingWolooServiceAtParticularHost:
//            return  #imageLiteral(resourceName: "woloo_default")
//        case .GiftPointsDeducted:
//            return UIImage(named: "VOUCHER") ?? #imageLiteral(resourceName: "woloo_default")
//        default :
//            return #imageLiteral(resourceName: "woloo_default")
//        }
//    }
//    
//    func setTitleWithEnum(text: String?) -> String {
//        switch self {
//        case .WolooNavigationRewardCredits:
//            return "Woloo Navigation used to reach Woloo Host, \(text ?? "")"
//        case .RegistrationPoint:
//            return "Completing your registration process"
//        case .GiftReceived:
//            return "Received Gift \(text ?? "")"
//        case .GiftSent:
//            return "Purchase of Woloo Gift Card \(text ?? "")"
//        case .ReferralPoint:
//            return "Successful Referral made \(text ?? "")"
//        case .ApproveRecommendWolooCredits:
//            return "Recommended Woloo Host \(text ?? "") approved by Woloo"
//        case .RecommendWolooCredits:
//            return "Recommended \(text ?? "") to be included as Woloo Host"
//        case .NoWolooFoundReward:
//            return "Enjoy Woloo Points till we get Woloo at your searched location \(text ?? "")"
//        case .AddCoins:
//            return "Purchase of Coins \(text ?? "")"
//        case .UsingWolooServiceAtParticularHost:
//            return "Woloo Service used at \(text ?? "")"
//        case .GiftPointsDeducted:
//            return "Gift Points Deducted \(text ?? "")"
//        }
//    }
//    
//}

struct CoinHistoryModel : Mappable {
    
    var totalCount:Int?
    var historyCount:Int?
    var history:[HistoryModel]? = []
    
    init() {}
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.totalCount  <- map["total_count"]
        self.historyCount  <- map["history_count"]
        self.history <- map["history"]
    }
    
}

struct HistoryModel : Mappable {
    
    var id:Int?
    var userId:Int?
    var wolooId:Int?
    var type: String? = ""
    var value:String?
    var createdAt:String?
    var remarks:String?
    var isGift: Int?
    var message: String?
    var transactionType: String?
    var sender: UserModel?
    var wolooDetails: WolooStore?
   
    
    var historyTypeTitle: String? {
        if let type = HistoryType.init(rawValue: type ?? "") {
            switch type {
            case .WolooNavigationRewardCredits:
                if let hostName = wolooDetails?.name?.capitalized {
                    return type.setTitleWithEnum(text: hostName)
                } else {
                   return type.setTitleWithEnum(text: wolooDetails?.name?.capitalized ?? "")
                }
            case .RegistrationPoint:
                return type.setTitleWithEnum(text: wolooDetails?.name?.capitalized ?? "")
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
                return type.setTitleWithEnum(text: wolooDetails?.name?.capitalized ?? "")
            case .RecommendWolooCredits:
                return type.setTitleWithEnum(text: wolooDetails?.name?.capitalized ?? "")
            case .NoWolooFoundReward:
                return type.setTitleWithEnum(text: wolooDetails?.address?.capitalized ?? "")
            case .AddCoins:
                return type.setTitleWithEnum(text: value ?? "")
            case .UsingWolooServiceAtParticularHost:
                if let hostName = wolooDetails?.name?.capitalized, let location = wolooDetails?.address {
                    return type.setTitleWithEnum(text: "\(hostName) - \(location)" )
                } else {
                return type.setTitleWithEnum(text: "\(wolooDetails?.name?.capitalized ?? "") - \(wolooDetails?.address ?? "")" )
                }
            case .GiftPointsDeducted:
                return type.setTitleWithEnum(text: "\(wolooDetails?.name ?? "")")
            case .BlogReadPoint:
                return type.setTitleWithEnum(text: wolooDetails?.address?.capitalized ?? "")
            case .WAHCertificatePoint:
                return type.setTitleWithEnum(text: wolooDetails?.address?.capitalized ?? "")
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
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.id  <- map["id"]
        self.userId  <- map["user_id"]
        self.wolooId <- map["woloo_id"]
        self.type  <- map["type"]
        self.value  <- map["value"]
        self.createdAt  <- map["created_at"]
        self.remarks  <- map["remarks"]
        self.isGift <- map["is_gift"]
        self.message <- map["message"]
        self.transactionType <- map["transaction_type"]
        self.sender <- map["sender"]
        self.wolooDetails <- map["woloo_details"]
  }
    
}


struct AddCoins: Mappable {
    var status, message, orderId: String?
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.status  <- map["status"]
        self.message  <- map["message"]
        self.orderId  <- map["order_id"]
    }
}
