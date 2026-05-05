//
//  APIManager.swift
//  JetLive
//
//  Created by Ashish Khobragade on 19/10/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import Foundation
import UIKit

enum Status:String {
    case success = "success"
    case error = "error"
}

enum CategoryProgramId:String {
    case banner_trending_events
    case ongoing_events
    case events_by_artists
    case all_events
    case upcoming_events
    case categories_home
    case trending_events
}

class APIManager {
    static var shared:APIManager{
        let sharedObject = APIManager()
        return sharedObject
    }
    
    func loginCustom(request:Login, showLoading: Bool? = true,completion: @escaping ((Bool,WrapperModel)->Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.sendOTP.apiMappableData(params: request.toJSON()) { (result: Result<(WrapperModel, String?), APIRestClient.APIServiceError>)  in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(true,response.0)
                break
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false,responsemodel)
                } else{
                    print(error)
                }
                break
            }
        }
    }
    
    func verifyOTP(request:Login,  showLoading: Bool? = true, completion: @escaping ((UserModel?,String)->Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.verifyOTP.apiMappableData(params: request.toJSON()) { (result: Result<(VerificationResponse, String?), APIRestClient.APIServiceError>)  in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                if response.0.status == .success{
                    if let jwtToken = response.0.token {
                        UserDefaults.jwtToken = jwtToken
                    }
                    self.callAllAPIAfterLogin()
                    completion(response.0.userData,"")
                } else if response.0.status == .error {
                    completion(nil,response.0.message ?? "")
                }
                break
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil,responsemodel.message ?? "")
                } else{
                    completion(nil,error.localizedDescription)
                }
                break
            }
        }
    }
    
    func getReviewList(request: ReviewListRequest, showLoading: Bool? = true, completion: @escaping ((ReviewModel?,String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.gerReviewList.apiMappableData(params: request.toJSON()) { (result: Result<(ReviewModel, String?), APIRestClient.APIServiceError>)  in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0, "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil,responsemodel.message ?? "")
                } else{
                    completion(nil,error.localizedDescription)
                }
                break
            }
        }
    }
    
    func getNearbyWolooStores(request: NearByWolooStoreRequest, showLoading: Bool? = true, completion: @escaping ((NearByStoreResponse?,String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.nearbyWoloo.apiMappableData(params: request.toJSON()) { (result: Result<(NearByStoreResponse, String?), APIRestClient.APIServiceError>)  in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                if response.0.status == .success{
                    completion(response.0,"")
                } else if response.0.status == .error {
                    completion(nil,response.0.message ?? "")
                } else {
                    completion(nil,response.1 ?? "")
                }
                break
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil,responsemodel.message ?? "")
                } else{
                    completion(nil,error.localizedDescription)
                }
                break
            }
        }
    }
    
    func searchWolooStore(param:[String: Any], showLoading: Bool? = true, completion: @escaping ((NearByStoreResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.searchWoloo.apiMappableData(params: param) { (result: Result<(NearByStoreResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0, "")
                
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func postEditProfileData(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((UserModel?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.editProfile.apiMappableData(params: param) { (result: Result<(UserModel, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                UserModel.saveAuthorizedUserInfo(response.0)
                UserModel.user = response.0
                completion(response.0, "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func getUserCoinsHistory(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((CoinHistoryModel?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.coinHistory.apiMappableData(params: param) { (result: Result<(CoinHistoryModel, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0, "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func scanWolooQR(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.scanWoloo.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(true, response.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "")
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    func redeemOffer(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((RedeemOfferModel?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.redeemOffer.apiMappableData(params: param) { (result: Result<(RedeemOfferModel, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
                case .success(let response):
                    completion(response.0, "")
                case .failure(let error):
                    if case .successWithError(let responsemodel) = error {
                        completion(nil, responsemodel.message ?? "")
                    } else {
                        completion(nil, error.localizedDescription)
                    }
                }
        }
    }
   
    func wolooLikeStatus(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((WolooLikeStatus?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.wolooLikeStatus.apiMappableData(params: param) { (result: Result<(WolooLikeStatus, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0, "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    func wolooLike(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.wolooLike.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(_):
                completion(true, "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "")
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    func wolooUnlike(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.wolooUnlike.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let _):
                completion(true, "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "")
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    
    func inviteFriends(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.invite.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(true, r.0.message ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "")
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    func wolooNavigationReward(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, WolooNavigationReward?,String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.wolooNavigationReward.apiMappableData(params: param) { (result: Result<(WolooNavigationReward, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(true, r.0, r.0.message ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, nil,responsemodel.message ?? "")
                } else {
                    completion(false, nil,error.localizedDescription)
                }
            }
        }
    }
    
    func addWolooAPI(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.addWoloo.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(true, r.0.message ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "")
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    func getWolooPlan(param: [String:Any] , showLoading: Bool? = true, completion: @escaping ((WolooPlanResponse?,String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.getPlan.apiMappableData(params: param) { (result: Result<(WolooPlanResponse, String?), APIRestClient.APIServiceError>)  in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                if response.0.status == .success{
                    completion(response.0,"")
                } else if response.0.status == .error {
                    completion(nil,response.0.message ?? "")
                }
                break
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil,responsemodel.message ?? "")
                } else{
                    completion(nil,error.localizedDescription)
                }
                break
            }
        }
    }
    func getWolooRewardHistory(param: [String:Any] , showLoading: Bool? = true, completion: @escaping ((WolooRewardHistoryResponse?,String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.wolooRewardHistory.apiMappableData(params: param) { (result: Result<(WolooRewardHistoryResponse, String?), APIRestClient.APIServiceError>)  in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0,"")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil,responsemodel.message ?? "")
                } else{
                    completion(nil,error.localizedDescription)
                }
            }
        }
    }
    
    func getMyOffer(param: [String:Any] , showLoading: Bool? = true, completion: @escaping ((NearByStoreResponse?,String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.myOffer.apiMappableData(params: param) { (result: Result<(NearByStoreResponse, String?), APIRestClient.APIServiceError>)  in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0,"")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil,responsemodel.message ?? "")
                } else{
                    completion(nil,error.localizedDescription)
                }
            }
        }
    }
    
   func getWolooGift(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((StatusSuccessResponse?,String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.wolooGift.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?),APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0,"")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil,responsemodel.message ?? "")
                } else{
                    completion(nil,error.localizedDescription)
                }
            }
        }
    }
    
   
    func callAllAPIAfterLogin() {
        getAppConfigData(completion: nil)
    }
    
    func getAppConfigData( showLoading: Bool? = true, completion: (() -> Void)? = nil) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.appConfigGet.apiMappableData(params: [:]) { (result: Result<(AppConfig, String?), APIRestClient.APIServiceError>)  in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                AppConfig.saveAppConfigInfo(response.0)
                completion?()
                
            case .failure:
                break
            }
        }
    }
    
    func imageFileUpload(param:[String:String], showLoading: Bool? = true, image: UIImage, completion: @escaping ((FileUpload?, String) -> Void)){
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.fileUpload.apiMappableUpload(params: param, files: ["filenames": image], completion: { (result: Result<(FileUpload, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0, "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        })
    }
    
    /*func multipleImageFileUpload(param: [String:String], image: [UIImage], completion: @escaping (([FileUpload]?, String) -> Void)) {
        API.multipleFileUpload.apiMappableUpload(params: param, files: ["filenames": image]) { (result: Result<[FileUpload], APIRestClient.APIServiceError>) in
            switch result {
            case .success(let response):
                completion(response, "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }*/
    
    func recommendWolooAPI(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.recommendWoloo.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(true, r.0.message ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "")
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    func recommedWolooListAPI( showLoading: Bool? = true,completion: @escaping ((NearByStoreResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.userRecommendWoloo.apiMappableData(params: [:]) { (result: Result<(NearByStoreResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.0.message ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func submitReviewAPI(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.submitReview.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0.status != nil, r.0.message ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "")
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    func getReviewOptionAPI(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((ReviewOptionList?, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.getReviewOptions.apiMappableData(params: param) { (result: Result<(ReviewOptionList, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0,"")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil,responsemodel.message ?? "")
                } else{
                    completion(nil,error.localizedDescription)
                }
            }
        }
    }
    
    func voucherSubscription(code: String, showLoading: Bool? = true, completion: @escaping ((VoucherModel?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.voucherSubscription.apiBackgroundMappableData(params: ["voucher_code": code]) { (result: Result<(VoucherModel, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let response):
                completion(response.0, response.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil,responsemodel.message ?? "")
                } else{
                    completion(nil,error.localizedDescription)
                }
            }
        }
    }
    
    func initSubscription(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((getVoucherSubscription?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.initSubscriptionByOrder.apiMappableData(params: param) { (result: Result<(getVoucherSubscription, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func submitSubscriptionPurchase(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.submitSubscriptionPurchase.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0.status != nil, r.0.message ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "")
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    func appleTransactionUserCheckAPI(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String, String) -> Void))  {
       
        API.appleTransactionUserCheck.apiMappableData(params: param) { (result: Result<(AppleTransactionUserCheckResponse, String?), APIRestClient.APIServiceError>) in
            switch result {
            case .success(let r):
                completion(r.0.status != nil, r.0.message ?? "", r.0.allowUser ?? "" )
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "", "")
                } else {
                    completion(false, error.localizedDescription, "")
                }
            }
        }
    }
    
    func applePurhcaseAPI(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((Bool, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator(isInteractionEnable: false)
        }
        API.applePurchase.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0.status != nil, r.0.message ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(false, responsemodel.message ?? "")
                } else {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }

    func addCoinsPurchase(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((AddCoins?, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.addCoins.apiMappableData(params: param) { (result: Result<(AddCoins, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.0.message ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func mySubscription(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((MySubscriptionPlan?, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.mySubscription.apiMappableData(params: param) { (result: Result<(MySubscriptionPlan, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func cancelSubscription(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((StatusSuccessResponse?, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.cancelSubscription.apiMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func wahCertificate(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((WolooStore?, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.wahcertificate.apiMappableData(params: param) { (result: Result<(WolooStore, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func setPeriodTracker(param: [String: Any], showLoading: Bool? = true, completion: @escaping ((UserTrackerInfo?, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.setperiodtracker.apiMappableData(params: param) { (result: Result<(UserTrackerInfo, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func getPeriodTracker(showLoading: Bool? = true, completion: @escaping ((UserTrackerInfo?, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.viewperiodtracker.apiMappableData(params: [:]) { (result: Result<(UserTrackerInfo, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func getWolooAndOfferCount(request: [String: Any], showLoading: Bool? = true, completion: @escaping ((OfferReponse?, String) -> Void))  {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.wolooAndOfferCount.apiMappableData(params: request) { (result: Result<(OfferReponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func getCategoryAPI(_ param: [String: Any], showLoading: Bool? = true,_ completion: @escaping ((CategoryResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.getCategories.apiMappableData(params: param) { (result: Result<(CategoryResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func saveUserCategoryAPI(_ param: [String: Any], showLoading: Bool? = true,_ completion: @escaping ((StatusSuccessResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.saveUserCategory.apiBackgroundMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func getBlogsForUserByCategoryAPI(_ param: [String: Any], showLoading: Bool? = true,_ completion: @escaping ((BlogsAndCategoryResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.getBlogsForUserByCategory.apiMappableData(params: param) { (result: Result<(BlogsAndCategoryResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    
    func getUserSavedCategoriesAPI(_ param: [String: Any], showLoading: Bool? = true,_ completion: @escaping ((GetCategoriesResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.getUserSavedCategories.apiMappableData(params: param) { (result: Result<(GetCategoriesResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func likeDislikeBLOGS(_ blogID: Int, showLoading: Bool? = true,_ completion: @escaping ((StatusSuccessResponse?, String) -> Void)) {
        let param: [String: Any] = ["blog_id": blogID]
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.ctaLikes.apiBackgroundMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    
    func FavouriteBLOGS(_ blogID: Int, showLoading: Bool? = true,_ completion: @escaping ((StatusSuccessResponse?, String) -> Void)) {
        let param: [String: Any] = ["blog_id": blogID]
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.ctaFavourite.apiBackgroundMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }

    func updateDeviceToken(_ param: [String: Any], showLoading: Bool? = true,_ completion: @escaping ((StatusSuccessResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.updateDeviceToken.apiBackgroundMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func thirstReminder(_ param: [String: Any], showLoading: Bool? = true,_ completion: @escaping ((StatusSuccessResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.thirstReminder.apiBackgroundMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func ctaBlogRead(_ param: [String: Any], showLoading: Bool? = true,_ completion: @escaping ((StatusSuccessResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.ctaBlogRead.apiBackgroundMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func blogReadPoint(_ param: [String: Any], showLoading: Bool? = true,_ completion: @escaping ((StatusSuccessResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.blogReadPoint.apiBackgroundMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func userJourney(_ param: [String: Any], showLoading: Bool? = true,_ completion: @escaping ((StatusSuccessResponse?, String) -> Void)) {
        if let show = showLoading, show {
            Global.showIndicator()
        }
        API.userJourney.apiBackgroundMappableData(params: param) { (result: Result<(StatusSuccessResponse, String?), APIRestClient.APIServiceError>) in
            if let show = showLoading, show {
                Global.hideIndicator()
            }
            switch result {
            case .success(let r):
                completion(r.0, r.1 ?? "")
            case .failure(let error):
                if case .successWithError(let responsemodel) = error {
                    completion(nil, responsemodel.message ?? "")
                } else {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
}
