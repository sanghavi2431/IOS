//
//  UserDbQueriesUtility.swift
//  ChannelFightMobile
//
//  Created by Ashish.Khobragade on 05/08/19.
//  Copyright © 2019 Jetsynthesys. All rights reserved.
//

import UIKit
import SQLite

class UserDbQueriesUtility: NSObject {
    
    //common connection
    var dbConnection:Connection!
    
    
    //Locale table params
    let localeTable = Table("locale")
    let id = Expression<Int64>("id")
    let ipAddress = Expression<String?>("ipAddress")
    let countryCode = Expression<String?>("countryCode")
    let cityName = Expression<String?>("cityName")
    let regionName = Expression<String?>("regionName")
    let isp = Expression<String?>("isp")
    
    
    //Feedback table params
    let feedbackTable = Table("feedback")
    let topicId = Expression<Int>("topicId")
    let topic = Expression<String>("topic")
    
    
    //Versions table params
    let versionTable = Table("version")
    let version = Expression<String>("version")
    let force_update = Expression<String>("force_update")
    let update_text = Expression<String>("update_text")
    
    
    //Response table params
    let responseTable = Table("response")
    let responseKey = Expression<String>("responseKey")
    let apiResponse = Expression<String>("apiResponse")
    let updateTime = Expression<TimeInterval>("updateTime")
    
    //Response table params
    let storeId = Expression<Int>("storeId")
}

// MARK: - Keys
extension  UserDbQueriesUtility {
    
    static let keyAppConfig = "APP_CONFIG"
    static let keyStores = "STORES"
    static let keyStorePages = "STORE_PAGES"
    static let keyDashboardCategories = "DASHBOARD_CATEGORIES"
    static let keyConnectList = "CONNECT_GET_LIST"
}

// MARK:-  initialization

extension  UserDbQueriesUtility {
    
    static var shared: UserDbQueriesUtility = {
        
        let sharedObject = UserDbQueriesUtility()
        
        return sharedObject
    }()
    
    func initialiseDB() -> Bool{
        
        do {
            let result = DBUtility.shared.createDataBase()
            
            if result{
                //create all tables here
                self.dbConnection = DBUtility.shared.getDbConnection()
                
                try createLocaleTable()
                try createResponseTable()
                
                return true
            }
            else{
                return false
            }
        }
        catch  {
            clearForVersionAtLaunch(appMainVersion: 1, bundleVersion: 8)

            return false
        }
    }
    
    func clearForVersionAtLaunch(appMainVersion appVersion:Double, bundleVersion version:Double) {
        
        DispatchQueue.main.async {
          
            let currentAppVersion = Bundle.getBundleMainVersion()
            let currentBundleVersion = Bundle.getBundleVersion()
            
            if UserDefaults.standard.bool(forKey: "CLEARED_SAVED_RESPONSE_\(appVersion)_\(version)") == false, version < Double(currentBundleVersion)!,appVersion <= Double(currentAppVersion)!{
                
                UserDbQueriesUtility.deleteAllSavedResponses()
                UserDefaults.standard.set(true, forKey: "CLEARED_SAVED_RESPONSE_\(appVersion)_\(version)")
                UserDefaults.standard.synchronize()
            }
        }
    }

}

// MARK:- Locale

extension  UserDbQueriesUtility {
    
    fileprivate func createLocaleTable() throws {
        
        try dbConnection.run(localeTable.create(block: { (table) in
            
            table.column(id,primaryKey:true)
            table.column(ipAddress)
            table.column(countryCode)
            table.column(cityName)
            table.column(regionName)
            table.column(isp)
            table.column(updateTime)
            print("localeTable created")
        }))
    }
    
    fileprivate func updateLocaleTableData(model:Versions) throws {
        
        if isLocaleAvailable(){
            
            let locale = localeTable.filter(id == 1)
            
            let upadteStmt = locale.update(ipAddress <- model.ipAddress,
                                           countryCode <- model.countryCode,
                                           cityName <- model.cityName,
                                           regionName <- model.regionName,
                                           isp <- model.isp,
                                           updateTime <- getCurrentTimeStamp())
            
            
            try dbConnection.run(upadteStmt)
            
            print("locale updated")
        }
        else{
            let insertStmt = localeTable.insert(ipAddress <- model.ipAddress,
                                                countryCode <- model.countryCode,
                                                cityName <- model.cityName,
                                                regionName <- model.regionName,
                                                isp <- model.isp,
                                                updateTime <- getCurrentTimeStamp())
            
            try dbConnection.run(insertStmt)
            
            print("New locale Inserted")
            
        }
    }
    
    fileprivate func getUpdateTimestamp(_ key: String) throws -> TimeInterval?{
        
        do{
            
            let isResponseExist = try UserDbQueriesUtility.shared.checkForKey(key:key)
            
            if isResponseExist{
                
                let query = responseTable.filter(responseKey == key)
                
                if let row = try dbConnection.pluck(query){
                    
                    let time = try row.get(updateTime)
                    
                    return time
                }
            }
    
            return nil
        }
        catch{
            throw "NO \(key) EXIST"
        }
    }
    
    fileprivate func getLocaleTimestamp() throws -> TimeInterval?{
        
        if isLocaleAvailable(){
            
            var updateDate:TimeInterval?
            
            let rows = try dbConnection.prepare(localeTable)
            
            for locale in rows{
                
                updateDate =  locale[updateTime]
            }
            
            return updateDate
        }
        else{
            throw "NO LOCALE EXIST"
        }
    }

    
    func getLocaleData() throws -> Versions{
        
        if isLocaleAvailable(){
            
            let version = Versions()
            
            let rows = try dbConnection.prepare(localeTable)
            
            for locale in rows{
                
//                print("id = \(locale[id])  name = \(locale[countryCode] ?? "")" )
                
                if let ipAddress = locale[ipAddress]{
                    version.ipAddress = ipAddress
                }
                
                if let countryCode = locale[countryCode]{
                    version.countryCode = countryCode
                }
                
                if let cityName = locale[cityName]{
                    version.cityName = cityName
                }
                
                if let regionName = locale[regionName]{
                    version.regionName = regionName
                }
                
                if let isp = locale[isp]{
                    version.isp = isp
                }
            }
            
            return version
        }
        else{
            throw "NO LOCALE EXIST"
        }
    }
    
    func isLocaleAvailable() -> Bool {
       
       if DBUtility.shared.isDbExist{
          
            if #available(iOS 13.0, *) {
                
                do {
                    let count = try dbConnection.scalar(localeTable.count)
                    
                    if count == 1{
                        
                        return true
                    }
                }
                catch{
                    return false
                }
                
                return false
            }
            else{
                
                return false
            }
        }
        
        return false
    }
    
    func isLocaleValid() -> Bool{
        
        let savedTimestamp = UserDbQueriesUtility.getLocaleSavedTimestamp()
        
        let currentTimeStamp = UserDbQueriesUtility.shared.getCurrentTimeStamp()
        
        Logger.shared.showLog("saved timestamp = \(savedTimestamp) \n currentTimeStamp = \(currentTimeStamp) \n diff timestamp = \(currentTimeStamp - savedTimestamp)")
        
        // let ipLocationCacheDuration = Double(DELEGATE.rootVC?.appConfigResponse?.customConfiguration?.cacheDuration ?? "21600") ?? 21600
        // Adi
        let ipLocationCacheDuration = Double(UserDbQueriesUtility.getAppConfigResponse() ?? "0") ?? 0
        //default value 6hours = 21600seconds
        let condition = currentTimeStamp > 0 && savedTimestamp > 0 && (currentTimeStamp - savedTimestamp) < ipLocationCacheDuration
        
        return condition
    }
    
    static func updateLocale(model:Versions) {
       
        if DBUtility.shared.isDbExist{
            
            DispatchQueue.main.async {
                do{
                    try UserDbQueriesUtility.shared.updateLocaleTableData(model: model)
                }
                catch{
                    print(error)
                }
            }
        }
    }
}

// MARK:-  Response
extension  UserDbQueriesUtility {
    
    fileprivate func createResponseTable() throws {
        
        do{
            try dbConnection.run(responseTable.create(block: { (table) in
                
                table.column(responseKey,unique: true)
                table.column(apiResponse)
                table.column(updateTime)
                
                print("response Table created")
            }))
        }
        catch{
            print(error)
        }
    }
    
    func updateResponseTableData(key:String,response:String,updateTimeValue:TimeInterval) throws {
     
        if DBUtility.shared.isDbExist{
            
            do{
                let isResponseExist = try UserDbQueriesUtility.shared.checkForKey(key:key)
                
                if isResponseExist{
                    
                    let responseRow = responseTable.filter(responseKey == key)
                    
                    let upadteStmt = responseRow.update(apiResponse <- response, updateTime <- updateTimeValue)
                    
                    try dbConnection.run(upadteStmt)
                }
                else{
                    let insertStmt = responseTable.insert(responseKey <- key, apiResponse <- response, updateTime <- updateTimeValue)
                    
                    try dbConnection.run(insertStmt)
                }
                
                print("\(key) reponse updated")
                
            }
            catch{
                print(error)
            }
        }
    }
    
    func getResponseStringForKey(key:String) throws -> String{
        
        let query = responseTable.filter(responseKey == key)
        
        guard let rows = try dbConnection.pluck(query) else{
            throw "NO \(key) EXIST"
        }
        
        return rows[apiResponse]
    }
    
    func getCurrentTimeStamp() -> TimeInterval {
        
        return Date().timeIntervalSince1970
    }
    
    fileprivate func checkForKey(key:String) throws -> Bool{
      
        if DBUtility.shared.isDbExist{
            
            do{
                let query = responseTable.filter(responseKey == key)
                
                guard let _ = try dbConnection.pluck(query) else{
                    return false
                }
                
                return true
            }
            catch{
                
                print(error)
            }
        }
        return false
    }
    
    fileprivate  func deleteAllDataFromResponse() throws {
       
        if DBUtility.shared.isDbExist{
        
            do{
                let result =  try dbConnection.run(responseTable.delete())
                
                print("result => \(result) rows Deleted")
            }
            catch{
                print(error)
            }
        }
    }
}

// MARK:-  User methods
extension UserDbQueriesUtility{
    
    static func updateConfigResponse(_ response: String)  {
      
        if DBUtility.shared.isDbExist{
        
            DispatchQueue.main.async {
                
                do{
                    // Adi
                    // guard let updatedTime = DELEGATE.rootVC?.lmdData?.lmdData?.appConfig else { return }
                     guard let updatedTime = gett else { return }
                    try UserDbQueriesUtility.shared.updateResponseTableData(key:UserDbQueriesUtility.keyAppConfig, response: response, updateTimeValue: updatedTime)
                }
                catch{
                    print(error)
                }
            }
        }
    }
    
    static func getAppConfigResponse() -> String? {
       
        if DBUtility.shared.isDbExist{
        
            do{
                
                let output = try UserDbQueriesUtility.shared.getResponseStringForKey(key:UserDbQueriesUtility.keyAppConfig)
                return output
            }
            catch{
                print(error)
            }
        }
        
        return nil
    }
    
    static func updateStoresResponse(_ response: String)  {
      
        if DBUtility.shared.isDbExist{
        
            DispatchQueue.main.async {
                
                do{
                    guard let updatedTime = DELEGATE.rootVC?.lmdData?.lmdData?.store_group else { return }
                    try UserDbQueriesUtility.shared.updateResponseTableData(key: UserDbQueriesUtility.keyStores, response: response, updateTimeValue: updatedTime)
                }
                catch{
                    print(error)
                }
            }
        }
    }
    
    static func getStoresResponse() -> String? {
       
        if DBUtility.shared.isDbExist{
        
            do{
                let output = try UserDbQueriesUtility.shared.getResponseStringForKey(key: UserDbQueriesUtility.keyStores)
                
                return output
            }
            catch{
                print(error)
            }
        }
        
        return nil
    }
    
    fileprivate static func updateStoresPagesResponse(_ response: String,_ key: String = "")  {
       
        if DBUtility.shared.isDbExist{
        
            DispatchQueue.main.async {
                
                do{
                    guard let updatedTime = DELEGATE.rootVC?.lmdData?.lmdData?.store_tabs else { return }
                    try UserDbQueriesUtility.shared.updateResponseTableData(key: UserDbQueriesUtility.keyStorePages+key, response: response, updateTimeValue: updatedTime)
                }
                catch{
                    print(error)
                }
            }
        }
    }
    
    fileprivate static func getStoresPagesResponse(_ key: String = "") -> String? {
        
        if DBUtility.shared.isDbExist{
            
            do{
                let output = try UserDbQueriesUtility.shared.getResponseStringForKey(key: UserDbQueriesUtility.keyStorePages+key)
                
                return output
            }
            catch{
                print(error)
            }
        }
        
        return nil
    }
    
    static func updateStoresPagesResponse(_ response: String,_ tabType: TabType)  {
        
        UserDbQueriesUtility.updateStoresPagesResponse(response, tabType.rawValue)
    }
    
    static func getStoresPagesResponse(_ tabType: TabType) -> String? {
        
        return  UserDbQueriesUtility.getStoresPagesResponse(tabType.rawValue)
    }
    
    static func updateConnectGetListResponse(_ response: String)  {
        
        DispatchQueue.main.async {
            
            do{
                try UserDbQueriesUtility.shared.updateResponseTableData(key: UserDbQueriesUtility.keyConnectList, response: response, updateTimeValue: UserDbQueriesUtility.shared.getCurrentTimeStamp())
            }
            catch{
                print(error)
            }
        }
    }
    
    static func getConnectGetListResponse() -> String? {
        
        do{
            let output = try UserDbQueriesUtility.shared.getResponseStringForKey(key: UserDbQueriesUtility.keyConnectList)
            
            return output
        }
        catch{
            print(error)
        }
        
        return nil
    }
    
    static func checkConnectGetListResponse() -> Bool{
        
        do{
            let _ = try UserDbQueriesUtility.shared.checkForKey(key: UserDbQueriesUtility.keyConnectList)
            
            return true
        }
        catch{
            print(error)
        }
        return false
    }
    
    static func updateDashboardCategoriesResponse(_ response: String)  {
        
        DispatchQueue.main.async {
            
            do{
                try UserDbQueriesUtility.shared.updateResponseTableData(key: UserDbQueriesUtility.keyDashboardCategories, response: response, updateTimeValue: UserDbQueriesUtility.shared.getCurrentTimeStamp())
            }
            catch{
                print(error)
            }
        }
    }
    
    static func getDashboardCategoriesResponse() -> String? {
        
        do{
            let output = try UserDbQueriesUtility.shared.getResponseStringForKey(key: UserDbQueriesUtility.keyDashboardCategories)
            
            return output
        }
        catch{
            print(error)
        }
        
        return nil
    }
    
    
    static func getLocaleSavedTimestamp() -> TimeInterval{
       
        if DBUtility.shared.isDbExist{
        
            do{
                let output = try UserDbQueriesUtility.shared.getLocaleTimestamp() ?? 0
                
                return output
            }
            catch{
                print(error)
            }
        }
        
        return 0
    }
    
    static func getStorePagesSavedTimestamp(_ tabType: TabType) -> TimeInterval{
      
        if DBUtility.shared.isDbExist{
            do{
                
                let updateTime = try UserDbQueriesUtility.shared.getUpdateTimestamp(UserDbQueriesUtility.keyStorePages+tabType.rawValue)
                
                return updateTime ?? 0
            }
            catch{
                print("NO STORE PAGES EXIST")
            }
        }
        
        return 0
    }
    
    
    static func getStoreSavedTimestamp() -> TimeInterval{
      
        if DBUtility.shared.isDbExist{
            
            do{
                
                let updateTime = try UserDbQueriesUtility.shared.getUpdateTimestamp(UserDbQueriesUtility.keyStores)
                
                return updateTime ?? 0
            }
            catch{
                print("NO STORE EXIST")
            }
        }
        return 0
    }
    
    static func getAppConfigSavedTimestamp() -> TimeInterval{
     
        if DBUtility.shared.isDbExist{
            
            do{
                
                let updateTime = try UserDbQueriesUtility.shared.getUpdateTimestamp(UserDbQueriesUtility.keyAppConfig)
                
                return updateTime ?? 0
            }
            catch{
                print("NO APP CONFIG EXIST")
            }
        }
        
        return 0
    }
    
    static func deleteAllSavedResponses() {
       
        if DBUtility.shared.isDbExist{
            
            do{
                try UserDbQueriesUtility.shared.deleteAllDataFromResponse()
            }
            catch{
                print(error)
            }
        }
    }
}

extension String:Error{
    
}

