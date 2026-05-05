//
//  DBSharedUtility.swift
//  ChannelFightMobile
//
//  Created by Ashish.Khobragade on 05/08/19.
//  Copyright © 2019 Jetsynthesys. All rights reserved.
//

import UIKit
import SQLite

class DBUtility: NSObject {
    
    var filePath:String?
    lazy var applicationDocumentsDirectory: NSURL = {
        return FileManager.default.temporaryDirectory  as NSURL
    }()
    
    static var shared: DBUtility = {
        
        let sharedObject = DBUtility()
        
        return sharedObject
    }()
    
    var isDbExist = false
    
    func createDataBase() -> Bool{
        
        do {
            try createDatabaseFile(dbName: "iconocle")
          
            print("DatabaseFile created")
            isDbExist = true
            return isDbExist
        }
        catch {
            print(error)
            return isDbExist
        }
    }
    
    func createDatabaseFile(dbName:String) throws{
        
        do {
           
            #if os(tvOS)
            
            let path = self.applicationDocumentsDirectory.appendingPathComponent(dbName)?.appendingPathExtension("sqlite3")
            
            self.filePath = path?.absoluteString
            
            print(path ?? "DB NOT CREATED")
            
            #else
            
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let path = docDir.appendingPathComponent(dbName).appendingPathExtension("sqlite3")
            
            self.filePath = path.absoluteString
            
            print(path)
            #endif
            
        }
        catch{
            throw error
        }
    }
    
    func getDbConnection() ->Connection? {
        
        if let filePath = filePath{
            
            do {
                let dbConnection = try Connection(filePath)
                return dbConnection
            }
            catch{
                print(error)
            }
        }
        
        return nil
    }
}
