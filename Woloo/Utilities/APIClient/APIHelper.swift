//
//  APIHelper.swift
//
//  Created by Amzad-Khan on 19/04/19.
//  Copyright © 2019 Jetsynthesys. All rights reserved.

import Foundation

protocol APIEnvironmentRequirements {
    
    var baseURL:String { get }
    var jetAnalyticsAuthKey:String {get}
    var notificatonTopic:String {get}
    var apiVersion:String {get}
}

enum API: String {
    case getCategories = "getCategories"
    case saveUserCategory = "saveUserCategory"
    case getBlogsForUserByCategory = "getBlogsForUserByCategory"
    case getUserSavedCategories = "getUserSavedCategories"
    case getBlogDetail = "getBlogDetail"
    case ctaFavourite = "ctaFavourite"
    case ctaLikes = "ctaLikes"
    case wolooAndOfferCount = "nearByWolooAndOfferCount"
    case authToken = "authGet"
    case sendOTP = "sendOTP"
    case verifyOTP = "login"
    case userMoreProfile = "userProfile"
    case nearbyWoloo = "nearbyWoloo"
    case searchWoloo = "searchWoloo"
    case editProfile = "editProfile"
    case coinHistory = "coinHistory"
    case appConfigGet  = "appConfigGet"
    case scanWoloo = "scanWoloo"
    case redeemOffer = "redeemOffer"
    case wolooLikeStatus = "wolooLikeStatus"
    case wolooLike = "wolooLike"
    case wolooUnlike = "wolooUnlike"
    case getPlan = "getPlan"
    case invite = "invite"
    case wolooRewardHistory = "wolooRewardHistory"
    case myOffer = "myOffers"
    case fileUpload = "fileUpload"
    case multipleFileUpload = "multipleFileUpload"
    case rescueAPI = "rescue@sendErrorReport"
    case gerReviewList = "getReviewList"
    case wolooNavigationReward = "wolooNavigationReward"
    case wolooGift = "woloo_gift"
    case addWoloo = "addWoloo"
    case recommendWoloo = "recommendWoloo"
    case submitReview = "submitReview"
    case getReviewOptions = "getReviewOptions"
    case userRecommendWoloo = "userRecommendWoloo"
    case voucherSubscription = "voucherSubscription"
    case initSubscription = "initSubscription"
    case initSubscriptionByOrder = "initSubscriptionByOrder"
    case submitSubscriptionPurchase = "submitSubscriptionPurchase"
    case addCoins = "addCoins"
    case mySubscription = "mySubscription"
    case cancelSubscription = "cancelSubscription"
    case wahcertificate = "wahcertificate"
    case setperiodtracker = "periodtracker"
    case applePurchase = "applePurchase"
    case appleTransactionUserCheck = "appleTransactionUserCheck"
    case viewperiodtracker = "viewperiodtracker"
    case updateDeviceToken = "updateDeviceToken"
    case thirstReminder = "thirstReminder"
    case ctaBlogRead = "ctaBlogRead"
    case blogReadPoint = "blogReadPoint"
    case userJourney = "userLog"
}

enum APIEnvironment: APIEnvironmentRequirements {
    
    case alpha   /* ------- Development -----------*/
    case beta    /* ------- STAGING ---------------*/
    case preProd /* ------- PRE PRODUCTION --------*/
    case prod    /* ------- PRODUCTION ------------*/
    case staging /* ------- New staging server ------------*/
    
    var baseURL: String {
        switch self {
        case .alpha :
          return  "https://app.woloo.in/" // live server
//            return "https://woloo.verifinow.com/" // stagging server
        case .beta:     return ""
        case .preProd:  return ""
        case .prod:     return ""
            
        
        case .staging:
            return "https://staging-php.woloo.in/"
        }
    }
    
    var rescueBaseURL: String {
        switch self {
        case .alpha :   return "http://192.168.1.172:82/handler.do"
        case .beta:     return "http://192.168.1.172:82/handler.do"
        case .preProd:  return "http://api.publicam.in/handler.do"
        case .prod:     return "http://api.publicam.in/handler.do"
        case .staging: return "http://192.168.1.172:82/handler.do"
           
        }
    }
    
    var jetAnalyticsAuthKey: String {
        switch self {
        case .alpha:    return "key=staging71bf27f254ea3a3d80db1004cf209719"
        case .beta:     return "key=staging71bf27f254ea3a3d80db1004cf209719"
        //        case .preProd:  return "key=staging71bf27f254ea3a3d80db1004cf209719"
        case .preProd:  return "key=event71bf27f254ea3a3d80db1004cf209719"
        case .prod:     return "key=event71bf27f254ea3a3d80db1004cf209719"
        case .staging: return "key=event71bf27f254ea3a3d80db1004cf209719"
        }
    }
    
    var notificatonTopic: String {
        switch self {
        case .alpha:    return "kinoclubGammaIos"
        case .beta:     return "kinoclubBetaIos"
        case .preProd:  return "kinoclubPreProdIos"
        case .prod:     return "kinoclubProdIos"
        case .staging: return "kinoclubProdIos"
        }
    }
    
    var apiVersion: String {
        switch self {
        case .alpha:    return "v1"
        case .beta:     return "v1"
        case .preProd:  return "v1"
        case .prod:     return "v1"
        case .staging: return "v1"
        }
    }
    
    var shoopingBaseUrl: String {
        switch self {
        case .alpha: return "https://shop.woloo.in/app_api/"//"http://isntmumbai.in/woloo_shopping/app_api/" 
        case .beta: return "https://shop.woloo.in/app_api/"
        case .preProd: return "https://shop.woloo.in/app_api/"
        case .prod: return "https://staging-shop.woloo.in/app_api/"
        case .staging: return "https://staging-shop.woloo.in/app_api/"
        }
    }
    
    var shoopingImageUrl: String {
        switch self {
        case .alpha: return "https://shop.woloo.in/images/"
        case .beta: return "https://shop.woloo.in/images/"
        case .preProd: return "https://shop.woloo.in/images/"
        case .prod: return "https://shop.woloo.in/images/"
        case .staging: return "https://staging-shop.woloo.in/images/"
        }
    }
}

struct APIConstant {
    static let requestNameKey = "request"
    static let contentTypeKey = "Content-Type"
    static let contentTypeValue = "application/json"
    static let contentTypeValueHtml = "application/html"
    static let contentTypeMultipartFormDataValue = "multipart/form-data"
    static let contentTypeValueformurlencoded = "application/x-www-form-urlencoded;charset=UTF-8"
    static let contentTypeValueformurlencodedDefault = "application/x-www-form-urlencoded"
    static let authorization : String = "Authorization"
}

extension API {
    //-------- Environment must be defained in confing not here this for testing -----
    static var environment:APIEnvironment = .alpha    //----------------------------------------------------------------//
}


protocol APICallRequirements {
    var apiRelativePath:String  { get }
    var url:String { get }
    
    var apiHeader: [String:String]! {get}
    func finalParameters(from parameters: [String : Any]) -> [String : Any]
    
    //    func api(paramJson:String, success:@escaping APIClient.SuccessHandler, failure:@escaping APIClient.FailureHandler)
    //    func api(paramModel:Mappable, success:@escaping APIClient.SuccessHandler, failure:@escaping APIClient.FailureHandler)
    //    func api(params:[AnyHashable:Any], success:@escaping APIClient.SuccessHandler, failure:@escaping APIClient.FailureHandler)
    
    func apiMappableData<T: Mappable>(params:Mappable, completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void)
    func apiMappableUpload<T: Mappable>(params:Mappable, files:[String:Any]?, completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void)
    func apiMappableData<T: Mappable>(params:[String:Any], completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void)
    func apiMappableUpload<T: Mappable>(params:[String:String], files:[String:Any]?, completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void)
    
}

import ObjectMapper
extension API : APICallRequirements {
    
    var apiRelativePath:String {
        /*----------  Vesion change for specific API ------------------>
         if self == .setUserLanguage {
         return API.environment.baseURL + API.environment.apiVersion
         } else {
         return API.environment.baseURL + API.environment.apiVersion
         }--------------------------------------------------------------*/
        return API.environment.baseURL + "api/" + API.environment.apiVersion
    }
    
    var rescueApiRelativePath:String {
        return API.environment.rescueBaseURL
    }
    
    var apiHeader: [String : String]! {
        //<---------- Custom Header parameters ------------------------------------
        return [:]
    }
    
    func finalParameters(from parameters: [String : Any]) -> [String : Any] {
        
        
        //<------------- Additional Parameters (Global Parameters) ---------------
        let finalParameters = parameters
        //        if let superStoreID = APIClient.superStoreId {
        //            finalParameters["superStoreId"] = "\(superStoreID)"
        //        }
        return finalParameters
    }
    
    private static var client = APIClient.shared
    var url:String {
        
        switch self {
        //            case .getDashboardCategories:return "http://www.mocky.io/v2/5da5f759340000cb20632e36"
        //             case .getPorletData: return "http://www.mocky.io/v2/5da60626340000221a632e87" //Normal portlet details
        //             case .getCategoryData: return "http://www.mocky.io/v2/5dad7b9c2d00006f42e4ba32"//social data
        
        case API.rescueAPI:
            return self.rescueApiRelativePath //+ "/" + self.rawValue
        
        default:
            return self.apiRelativePath + "/" + self.rawValue
        }
    }
    
    //---------------------------- REST CLIENT CORE API's------------------------------------------------------------------
    
    //    func api(paramJson: String, success: @escaping APIClient.SuccessHandler, failure: @escaping APIClient.FailureHandler) {
    //        API.client.api(paramJson: paramJson, url: URL(string: self.url)!, success: success, failure: failure)
    //    }
    //    func api(paramModel: Mappable, success: @escaping APIClient.SuccessHandler, failure: @escaping APIClient.FailureHandler) {
    //        let jsonString = paramModel.toJSONString() ?? ""
    //        API.client.api(paramJson: jsonString, url: URL(string: self.url)!, success: success, failure: failure)
    //    }
    //    func api(params: [AnyHashable : Any], success: @escaping APIClient.SuccessHandler, failure: @escaping APIClient.FailureHandler) {
    //        let jsonString = params.json()
    //        API.client.api(paramJson: jsonString, url: URL(string: self.url)!, success: success, failure: failure)
    //    }
    
    //--------------------------------- REST CLIENT GENERIC API's-----------------------------------------------------------
    
    //---------------API calls for background calling ------------------------------------
    func apiBackgroundMappableData<T: Mappable>(params:Mappable, completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void) {
        
        if ReachabilityManager.shared.reachabilityStatus != .none {
            let param = params.toJSON()
            let finalParams = self.finalParameters(from: param)
            let requestCompletion: (Result<(T, String?), APIRestClient.APIServiceError>)->Void = { (result) in
                
                completion(result)
                
                switch result {
                case .success(_):break
                case .failure(let error):
                    self.sendRescue(error: error, params: finalParams)
                    break
                }
            }
            API.client.apiMappableRequest(params: finalParams, url: URL(string: self.url)!, completion: requestCompletion, activity: false)
        } else {
            Global.hideIndicatorForcefully()
            completion(.failure(.networkError))
        }
    }
    
    func apiBackgroundMappableData<T: Mappable>(params:[String:Any], completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void) {
        if ReachabilityManager.shared.reachabilityStatus != .none {
            let finalParams = self.finalParameters(from: params)
            let requestCompletion: (Result<(T,String?), APIRestClient.APIServiceError>)->Void = { (result) in
                
                completion(result)
                
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    self.sendRescue(error: error, params: finalParams)
                    break
                }
            }
            API.client.apiMappableRequest(params: finalParams, url: URL(string: self.url)!, completion: requestCompletion, activity: false)
        } else {
            Global.hideIndicatorForcefully()
            completion(.failure(.networkError))
        }
    }
    //------------------------------ API calls for Mappble params ------------------------------------
    func apiMappableData<T: Mappable>(params:Mappable, completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void) {
        
        if ReachabilityManager.shared.reachabilityStatus != .none {
            let param = params.toJSON()
            let finalParams = self.finalParameters(from: param)
            
            let requestCompletion: (Result<(T,String?), APIRestClient.APIServiceError>)->Void = { (result) in
                
                completion(result)
                
                switch result {
                case .success(let data):
                    print(data.0.toJSON())
                    break
                case .failure(let error):
                    self.sendRescue(error: error, params: finalParams)
                    break
                }
            }
            API.client.apiMappableRequest(params: finalParams, url: URL(string: self.url)!, completion: requestCompletion, activity: true)
        } else {
            Global.hideIndicatorForcefully()
            completion(.failure(.networkError))
        }
    }
    
    func apiMappableUpload<T: Mappable>(params:Mappable, files:[String:Any]?, completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void) {
        
        if ReachabilityManager.shared.reachabilityStatus != .none {
            let param = params.toJSON()
            let finalParams = self.finalParameters(from: param)
            
            let requestCompletion: (Result<(T,String?), APIRestClient.APIServiceError>)->Void = { (result) in
                
                completion(result)
                
                switch result {
                case .success(_):break
                case .failure(let error):
                    self.sendRescue(error: error, params: finalParams)
                    break
                }
            }
            API.client.apiMappableUploadRequest(params: finalParams, files: files, url: URL(string: self.url)!, completion: requestCompletion)
        } else {
            Global.hideIndicatorForcefully()
            completion(.failure(.networkError))
        }
    }
    //------------------------------ API calls for [String:Any] params ------------------------------------
    func apiMappableData<T: Mappable>(params:[String:Any], completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void) {
        
        if ReachabilityManager.shared.reachabilityStatus != .none {
            let finalParams = self.finalParameters(from: params)
            
            let requestCompletion: (Result<(T,String?), APIRestClient.APIServiceError>)->Void = { (result) in
                completion(result)
                switch result {
                case .success(let data):
                    print(data.0.toJSON())
                    break
                case .failure(let error):
                    self.sendRescue(error: error, params: finalParams)
                    break
                }
            }
            
            API.client.apiMappableRequest(params: finalParams, url: URL(string: self.url)!, completion: requestCompletion)
        } else {
            Global.hideIndicatorForcefully()
            completion(.failure(.networkError))
        }
    }
    
    func apiMappableUpload<T: Mappable>(params:[String:String], files:[String:Any]?, completion: @escaping (_ result:Result<(T,String?), APIRestClient.APIServiceError>) -> Void) {
        
        if ReachabilityManager.shared.reachabilityStatus != .none {
            let finalParams = self.finalParameters(from: params)
            let requestCompletion: (Result<(T,String?), APIRestClient.APIServiceError>)->Void = { (result) in
                completion(result)
                switch result {
                case .success(let response):
                    break
                case .failure(let error):
                    self.sendRescue(error: error, params: finalParams)
                    break
                }
            }
            API.client.apiMappableUploadRequest(params: finalParams, files: files, url: URL(string: self.url)!, completion: requestCompletion)
        } else {
            Global.hideIndicatorForcefully()
            completion(.failure(.networkError))
        }
    }
    
    /*
     //----------------------- Test Restclient -----------------------------------------------------------------------------------
     func testMappable() {
     
     API.addBrands.apiMappableData(params: ["":""]) { (result:Result<GetEventRequestModel, APIRestClient.APIServiceError>) in
     switch result {
     case .success(let responsemodel): break
     case .failure(let error): break
     }
     }
     
     API.addBrands.apiMappableData(params: GetEventRequestModel()) { (result:Result<GetEventRequestModel, APIRestClient.APIServiceError>) in
     switch result {
     case .success(let responsemodel): break
     case .failure(let error): break
     }
     }
     
     API.addBrands.apiMappableUpload(params: GetEventRequestModel(), files: ["image":UIImage()]) { (result:Result<GetEventRequestModel, APIRestClient.APIServiceError>) in
     switch result {
     case .success(let responsemodel): break
     case .failure(let error): break
     }
     }
     }
     //-------------------------------------------------------------------------------------------------------------------------
     */
}

extension API  {
    func sendRescue(error:APIRestClient.APIServiceError, params:[String : Any]) {
        if self != .rescueAPI {
            if case .successWithError(let wrapper) = error {
                let statusCode = wrapper.code ?? 0
                if statusCode == 400 || statusCode == 1045{
                    //No Data found
                    //1045 // email not verified
                } else {
                    let rescueData = RescueRequestModel(error: error, api: self, params: params)
                    rescueData.sendRescue()
                }
            } else {
                let rescueData = RescueRequestModel(error: error, api: self, params: params)
                rescueData.sendRescue()
            }
        }
    }
}
