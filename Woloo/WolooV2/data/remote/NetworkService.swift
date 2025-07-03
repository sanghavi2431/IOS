//
//  NetworkService.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation

//MARK: Services

enum services: String{
    
    case nearByWoloo = "api/wolooHost/nearBy"
    case sendOtp = "api/wolooGuest/sendOTP"
    case verifyOtp = "api/wolooGuest/verifyOTP"
    case appConifgGet = "api/wolooGuest/appConfig"
    case voucherApply = "api/voucher/apply"
    case wolooGuest = "api/wolooGuest"
    case addCoins = "api/wolooHost/addCoins"
    case initSubscriptionByOrder = "api/subscription/initSubscriptionByOrder"
    case getPlans = "api/subscription/getPlan"
    case mySubscription = "api/subscription/mySubscription"
    case submitSubscription = "api/subscription/submitSubscriptionPurchase"
    case thirstReminder = "api/wolooGuest/thirstReminder"
    case nearByWolooAndOfferCount = "api/wolooHost/nearByWolooAndOfferCount"
    case enroute = "api/wolooHost/enroute"
    case userCoins = "api/wolooHost/user_coins"
    case userProfile = "api/wolooGuest/profile"
    case wolooEngagement = "api/wolooHost/woloo_engagements?user_id&woloo_id&like"
    case getReviewList = "api/wolooGuest/getReviewList"
    case viewperiodtracker = "api/wolooGuest/viewperiodtracker"
    case getReviewOptions = "api/wolooGuest/getReviewOptions"
    case submitReview = "api/wolooHost/submitReview"
    case userRecommendWoloo = "api/wolooHost/userRecommendWoloo"
    case recommendWoloo = "api/wolooHost/recommendWoloo"
    case addWoloo = "api/wolooHost/addWoloo"
    case updateDeviceToken = "api/wolooGuest/updateDeviceToken"
    case ctaLikes = "api/blog/ctaLike"
    case ctaFavourite = "api/blog/ctaFavourite"
    case ctaBlogRead = "api/blog/ctaBlogRead"
    case invite = "api/wolooGuest/invite"
    case wolooNavigationRewards = "api/wolooGuest/wolooNavigationReward"
    case scanWoloo = "api/wolooGuest/scanWoloo"
    case coinHistory = "api/wolooGuest/coinHistory"
    case getBlogs_byId = "api/blog/getBlogs_byId"
    case getBlogsForUserByCategory = "api/blog/getBlogsForUserByCategory"
    case getAllCategories = "api/blog/getAllCategories"
    case blogReadPoint = "api/blog/blogReadPoint"
    case getBlogsForShop = "api/blog/getBlogsForShop"
    case getwahcertificate = "api/wolooGuest/wahcertificate"
    case wolooRewardHistory = "api/wolooHost/wolooRewardHistory"
    case editPeriodTracker = "api/wolooGuest/periodtracker"
    
}

// MARK: baseURL

var baseURL: String {
    switch NetworkManager.networkEnvironment {
    case .dev: return "http://13.127.174.98/"
    case .staging: return "https://staging-api.woloo.in/"
    case .production: return "https://api.woloo.in/"
    case .newStagingDF: return "http://65.0.109.6/"
    case .local: return "http://localhost:4000/"
    }
}

class NetworkService : NSObject{
    
}

