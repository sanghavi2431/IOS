//
//  APIClient.swift
//
//  Created by Amzad-Khan on 18/04/19.
//  Copyright © 2019 Jetsynthesys. All rights reserved.
//

import Foundation

//extension String {
//    struct UserDefaultKeys {
//        static let userCode = "USER_CODE"
//        static let ipLocale = "IP_LOCAL"
//    }
//}

//-------------------------------------------------------------------------------------------------//
class APIClient: NSObject {
    //--------Shared Client (Singleton) --------------------------------------------------------
    struct SharedKeys {
        static let apiClient = APIClient()
    }
    
    public typealias SuccessHandler = (String, String) -> Void
    public typealias FailureHandler = ([String:Any], String, Int) -> Void
    
    static let shared = SharedKeys.apiClient
    let urlSession = URLSession.shared
    
    
    //----------------------------------------------------------------
    //var listnerMap = [String:JetBaseProxyOperationProtocol]()
    fileprivate var rsaData:RSAResponseModel?
    
    var jwtToken:String {
        return UserDefaults.jwtToken ?? ""
    } //for woloo
    
    let restClient = APIRestClient.shared
    var aIPToLocaleModel:IPToLocaleModel?
    
    
    class var userCode:String {
        return UserDefaults.userCode ?? ""
    }
    
    class var superStoreId:Int? {
        return 0//DELEGATE.rootVC?.appConfigResponse?.superStoreId
    }
    
    var sslKey:String? {
        return rsaData?.data?.cert
    }
    
    var sslData:SecKey? {
        if let keyData = rsaData?.data?.key, let secKey2 = RSA.addPublicKey(keyData) {
            //            let secKey = SOEncrypter.shared.bytesToPublicKey(certData: keyData as NSData)
            return secKey2.takeRetainedValue()
        } else {
            return nil
        }
        
        /*if let key = rsaData?.data?.key {
         return self.validateKeyData(publicKey: key)
         }else {
         return nil
         }*/
    }
    
    private override init() {
        // Get the iOS shared singleton. We're
        // wrapping it here.
    }
}

//-------------------------------------------------------------------------------------------------//

//Encription Helper
extension APIClient {
    
    func loadRSA() {
        SOEncrypter.shared.getRSAPublicKey { (rsaResponseModel) in
            if let rsaResponseModel = rsaResponseModel {
                self.rsaData = rsaResponseModel
            }
        }
    }
    
    var clientLocal:LocaleModel {
        
        // This locale is passed in all apis
        let localeModel = LocaleModel()
        
        if let aIPToLocaleModel = self.aIPToLocaleModel, let countryCode = aIPToLocaleModel.versions?.countryCode, countryCode != "Invalid IP address.",countryCode != "-" {
            localeModel.country = countryCode
            
            #if targetEnvironment(simulator)
            if API.environment == .preProd ||  API.environment == .prod {
                localeModel.country = "IN"
            }
            #endif
        } else {
            localeModel.country = "IN"
        }
        
        //  localeModel.language = LanguageManager.appLanguage.rawValue
        
        return localeModel
    }
    
    func apiEncodedData(inputJsonString:String,completion: @escaping (_ inputHex:String,_ rsaBase64:String,_ hmac:String,_ token:String) -> ()) {
        DispatchQueue.main.async(execute: {
            
            if let rsaResponseModel = self.rsaData {
                
                self.SOEncode(rsaResponseModel, inputJsonString: inputJsonString, completion: completion)
            } else{
                SOEncrypter.shared.getRSAPublicKey { (rsaResponseModel) in
                    if let rsaResponseModel = rsaResponseModel {
                        self.rsaData = rsaResponseModel
                        self.SOEncode(rsaResponseModel, inputJsonString: inputJsonString, completion: completion)
                    }else {
                        
                    }
                }
            }
        })
    }
    
    func SOEncode(_ rsaResponseModel: RSAResponseModel,inputJsonString:String,completion: @escaping (_ inputHex:String,_ rsaBase64:String,_ hmac:String,_ token:String) -> ()) {
        SOEncryptionUtility.shared.getSOEncryptedDataString(dataToEncode: inputJsonString) { (cryptDataString, randomSecret) in
            
            if let rsaKey = rsaResponseModel.data?.key{
                
                if let randomSecret = randomSecret{
                    
                    if let rsaEncString = SOEncrypter.shared.rsaEncryptData(with: rsaKey, message: randomSecret){
                        
                        if let cryptDataString = cryptDataString {
                            
                            let hmac = cryptDataString.hmac(key: "012345678")
                            
                            //                            Logger.shared.showLog("param1 => \(cryptDataString)")
                            //                            Logger.shared.showLog("param2 => \(rsaEncString)")
                            //                            Logger.shared.showLog("param3 => \(hmac)")
                            
                            
                            //specially added for woloo
                            rsaResponseModel.data?.jwt = APIClient.shared.jwtToken
                            
                            if let jwtToken = rsaResponseModel.data?.jwt{
                                completion(cryptDataString,rsaEncString,hmac,jwtToken)
                            }
                        }
                    }
                }
            } else {
                Global.hideIndicatorForcefully()
                Toast.shared.show(message: "There seems to be some issue, Woloo team is working on it. Please come back later")
                print("message: \(rsaResponseModel.message ?? "")")
            }
        }
    }
}

extension Dictionary {
    
    func json() -> String {
        var returnValue  = "{}"
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                returnValue =  jsonString
            }
        }
        returnValue = returnValue.trimmingCharacters(in: .whitespacesAndNewlines)
        return returnValue
    }
}

extension String {
    func decodeJson() ->Any? {
        guard let data  = self.data(using: String.Encoding.utf8) else { return nil }
        guard let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) else  { return nil }
        return jsonObj
    }
}

extension Data {
    func decodeJson() ->Any? {
        guard let jsonObj = try? JSONSerialization.jsonObject(with: self, options: []) else  { return nil }
        return jsonObj
    }
    
    func json() -> String? {
        if let jsonString = String.init(data: self, encoding: String.Encoding.utf8) {
            return jsonString
        }else {
            return nil
        }
    }
}

extension Array {
    func json() -> String {
        var returnValue  = "[]"
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) {
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                returnValue =  jsonString
            }
        }
        returnValue = returnValue.trimmingCharacters(in: .whitespacesAndNewlines)
        return returnValue
    }
}


import ObjectMapper
class RSAResponseModel:Mappable {
    var code: Int?
    var data: DataClass?
    var message, status: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
    }
}

class DataClass :Mappable{
    var cert, jwt, key: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cert <- map["cert"]
        jwt <- map["jwt"]
        key <- map["key"]
    }
}


class LocaleModel: Mappable {
    
    //    static var mockModel:LocaleModel {
    //        let local = LocaleModel()
    //        local.version = "1.0"
    //        //local.platform = "ios"
    //        local.country = "IN"
    //        local.language = "en"
    //        local.segment = ""
    //        return local
    //    }
    
    var version : String?
    var platform : String?
    var language : String?
    var country : String?
    var segment : String?
    
    init() {
        version = Bundle.getBundleVersion()
        platform = "ios"
        language = "en"
        country = "in"
        segment = ""
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        version       <- map["version"]
        platform      <- map["platform"]
        language      <- map["language"]
        country       <- map["country"]
        segment       <- map["segment"]
    }
}


class IPToLocaleModel: Mappable {
    
    //    static var mockModel:IPToLocaleModel {
    //        let local = IPToLocaleModel()
    //        local.versions = Versions()
    //        local.versions?.countryCode = "IN"
    //        return local
    //    }
    
    init() {}
    
    var versions : Versions?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        versions  <- map["Versions"]
    }
}

class Versions: Mappable {
    
    var ipAddress : String?
    var countryCode : String?
    var cityName : String?
    var regionName : String?
    var isp : String?
    
    init() {}
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        ipAddress       <- map["ipAddress"]
        countryCode     <- map["countryCode"]
        cityName        <- map["cityName"]
        regionName      <- map["regionName"]
        isp             <- map["isp"]
    }
}

class WrapperModel : Mappable {
    var code : Int?
    var status : String?
    var message : String?
    var data : Any?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}


class RescueRequestModel:Mappable {
    var screenName:String = ""
    var inputRequest:String?
    var outputResponce:String?
    var request:String = API.rescueAPI.rawValue
    var requestName:String?
    var userCode:String = UserDefaults.userCode ?? ""
    var applicationName:String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
    
    #if os(iOS)
    var platform:String = "ios"
    #else
    var platform:String = "iostv"
    #endif
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    convenience init(error: APIRestClient.APIServiceError, api:API, params:[String : Any]) {
        self.init()
        requestName = api.rawValue
        inputRequest = params.json()
        
        if case .successWithError(let result) = error, let code = result.code {
            outputResponce = "\(code)"
        } else {
            outputResponce = error.description
        }
    }
    
    
    func mapping(map: Map) {
        screenName      <- map["screen_name"]
        inputRequest    <- map["input_request"]
        outputResponce  <- map["output_responce"]
        userCode        <- map["user_code"]
        requestName     <- map["request_name"]
        applicationName <- map["application_name"]
        platform        <- map["platform"]
        request         <- map["request"]
    }
    
    func sendRescue() {
        API.rescueAPI.apiBackgroundMappableData(params: self) { (result:Result<(WrapperModel,String?), APIRestClient.APIServiceError>) in
            switch result {
            case .success(_): break
            case .failure(let error):
                print("API status failed : \(error)")
            }
        }
    }
}
