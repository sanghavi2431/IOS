//
//  LocalizationManager.swift
//  YesFlixTV
//
//  Created by Amzad-Khan on 10/10/19.
//  Copyright © 2019 Jetsynthesys. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


//-------- Global Localized Function ------------------------------------
public func LocalizedString(key:String, value:String) ->String {
    
    if let localized = LanguageManager.shared.localeMap[key] as? String {
        //Value from Localized API response
        return localized
    }
    else if let languageDict:[String:Any] = DELEGATE.rootVC?.languageDict, let localized = languageDict[key] as? String {
        //Value from local data localized string plist.
        return localized
    }
    
    return value
}
//-----------------------------------------------------------------------


public extension NSNotification.Name {
    static let kLanguageDidChange = Notification.Name("com.jet.LanguageDidChangeKey")
}


open class LanguageManager: NSObject {

    static let shared = LanguageManager()
    var localeMap = [String:Any]()
  /*  var feedbacks:[Feedback] {
        if AppLoginManager.shared.isUserLoggedIn() {
            return self.feedback.filter {$0.isOpen == false }
        }else  {
            return self.feedback.filter {$0.isOpen == true }
        }
    }
    
    var helpUrls:HelpUrls?
    var languages:[[String:Any]] = [[:]]
    
    fileprivate var feedback: [Feedback] = [Feedback]()
    fileprivate var languageList:[String:Any]?
    */
    private override init(){
        super.init()
       // self.loadLocalizedList()
    }
    
    class func setAppLanguage(code:LanguageCode) {
        UserDefaults.languageCode = code.rawValue
//        LanguageManager.shared.initializeLocalizedData()
    }
    
    class func setAppLanguage(isoCode:String) {
    
        let languageCode = LanguageCode(rawValue: isoCode)
        UserDefaults.languageCode = languageCode.rawValue
//        LanguageManager.shared.initializeLocalizedData()
       
    }
    
    static var appLanguage:LanguageCode {
        return LanguageCode(rawValue: UserDefaults.languageCode)
    }
    
    func loadLocalizedList() {
//        self.apiLocalizedData()
    }
    
  /*
    func apiLocalizedData() {
    
        API.getAppLocalizedData.apiMappableData(params: [:]) { (result:Result<WrapperModel, APIRestClient.APIServiceError>) in
            switch result {
            case .success(let responsemodel):
                
                if let data = responsemodel.data as? [String:Any], let languageData = data["language_detail_list"] as? [String:Any] {
                    self.languageList = languageData
                    #if os(iOS)
                        UserDefaults.storedLocalizedData = languageData
                    #endif
                    self.initializeLocalizedData()
                    print(responsemodel)
                }
                
            case .failure(let error):
                
                if case .successWithError(let wrapper) = error {
                    let statusCode = wrapper.code ?? 0
                    if statusCode == 602 {
                        //"Content not mapped to provided package"
                        //Not purchased
                    }else if statusCode == 402 {
                        //Expired
                    }
//                    else if let message = wrapper.message {
//                        print("Content status failed : \(message)")
//                    }
                }
//                print("getContentRating status failed : \(error)")
                
                #if os(iOS)
                self.initializeLocalizedData()
                #endif
            }
        }
    }
    public func initializeLocalizedData() {
        
        #if os(iOS)
        if self.languageList == nil {
            self.languageList = UserDefaults.storedLocalizedData
        }
        #endif
    
        guard let languageData = self.languageList else { return }
        
        let userLanguage = UserDefaults.languageCode
        var localDic = languageData["de"] as? [String:Any]
        
        if let dataDic = languageData[userLanguage] as? [String:Any]  {
            localDic = dataDic
        }else {
            localDic = languageData["de"] as? [String:Any]
        }
        
        guard let localDataDic = localDic else { return }
        let languages = localDataDic["storeLanguageList"] as? [[String:Any]] ?? [[String:Any]]()
        
        
       let sortedlLanguages = languages.sorted { (obj1, obj2) -> Bool in
            return (obj1["id"] as! Int) < (obj2["id"] as! Int)
        }
        self.languages = sortedlLanguages
        
        if self.languages.count == 0 {
            if let engData = languageData[LanguageCode.english.rawValue] as? [String:Any]  {
                self.languages =  engData["storeLanguageList"] as? [[String:Any]] ?? [[String:Any]]()
            }
        }
        
        if let helpData = localDataDic["helpUrls"] as? [String:Any] {
            self.helpUrls =  Mapper<HelpUrls>().map(JSON: helpData)
        }else {
            if let helpData = languageData[LanguageCode.english.rawValue] as? [String:Any]  {
                self.helpUrls =  Mapper<HelpUrls>().map(JSON: helpData)
            }
        }
        
        if let feedbacks = localDataDic["feedback"] as? [[String:Any]] {
            self.feedback.removeAll()
            for item in feedbacks {
                if let registered = item["registered"] as? [[String:Any]]  {
                    let feedbacks = Mapper<Feedback>().mapArray(JSONArray: registered)
                    self.feedback.append(contentsOf: feedbacks)
                }else if let open = item["open"] as? [[String:Any]]  {
                    let feedbacks = Mapper<Feedback>().mapArray(JSONArray: open)
                    for var fb in feedbacks {
                        fb.isOpen = true
                    }
                    self.feedback.append(contentsOf: feedbacks)
                }
            }
        }
        var mutableLocalData = localDataDic
        mutableLocalData["feedback"] = nil
        mutableLocalData["helpUrls"] = nil
        mutableLocalData["storeLanguageList"] = nil
        
        let localizedData = LanguageManager.stringMap(mutableLocalData)
        self.localeMap = localizedData
        
    }*/
}

extension LanguageManager {
    
    func localizedCategory(title:String) ->String {
    
        let customKey = title.replace(" ", with: "_").lowercased()
        
        if let localized = LanguageManager.shared.localeMap[customKey] as? String {
            //Value from Localized API response
            return localized
        }
        return title
    }
    
}


public enum LanguageCode:String, CaseIterable  {
    
    case english    = "en"
    case danish     = "da"
    case french     = "fr"
    case swedish    = "sv"
    case norwegian  = "no"
    case german  = "de"
    var name: String {
        
        switch self {
        case .english:  return "English"
        case .danish:   return "Danish"
        case .french:   return "French"
        case .swedish:   return "Swedish"
        case .norwegian:  return "Norwegian"
        case .german:  return "German"
        }
    }
    
    public init(rawValue:String) {
        if let aCase =  LanguageCode.allCases.first(where: { $0.rawValue == rawValue }) {
            self = aCase
        }else {
            self  = .english
        }
    }
    
}


extension UserDefaults {
    
    private struct UserDefaultLanguageKeys {
        static let languageCode = "languageCode"
    }
    
    fileprivate class var languageCode:String {
        get {
            if let rawValue = UserDefaults.standard.value(forKey:UserDefaultLanguageKeys.languageCode) as? String {
                return rawValue
            }else {
                return "de"
            }
        }
        set(newValue){
            UserDefaults.standard.set(newValue , forKey: UserDefaultLanguageKeys.languageCode)
            UserDefaults.standard.synchronize()
        }
    }
}


extension LanguageManager {
    
    private static func stringComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += stringComponents(fromKey: "\(nestedKey)", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                if let valueDic = value as? [String:Any] {
                    for (nestedKey, value) in valueDic {
                        components += stringComponents(fromKey: "\(nestedKey)", value: value)
                    }
                }
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((key, BoolEncoding.numeric.encode(value: value.boolValue)))
            } else {
                components.append((key, "\(value)"))
            }
        } else if let bool = value as? Bool {
            components.append((key, BoolEncoding.numeric.encode(value: bool)))
        } else {
            components.append((key, "\(value)"))
        }

        return components
    }

    static func stringMap(_ parameters: [String: Any]) -> [String:String] {
        var components: [(String, String)] = []
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += stringComponents(fromKey: key, value: value)
        }
        let reduced = components.reduce(into: [:]) { $0[$1.0] = $1.1 }
        
        return reduced

    }
    
    public enum BoolEncoding {
        case numeric
        case literal
        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}


extension UserDefaults {
    
    private struct UserDefaultLocalizationKeys {
        static let localizedData = "localizedData"
    }
    
    class var storedLocalizedData:[String:Any]? {

        get {
            if let rawValue = UserDefaults.standard.value(forKey:UserDefaultLocalizationKeys.localizedData) as? [String:Any] {
                return rawValue
            }else {
                return nil
            }
        }
        set(newValue){
            if let value = newValue {
               UserDefaults.standard.set(value , forKey: UserDefaultLocalizationKeys.localizedData)
            }else {
                UserDefaults.standard.removeObject(forKey: UserDefaultLocalizationKeys.localizedData)
            }
            UserDefaults.standard.synchronize()
        }
    }
}
