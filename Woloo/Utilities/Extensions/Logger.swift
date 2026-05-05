//
//  ThemeManager.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit

class Logger: NSObject {
    var enableDebugging = false
    var logPath:String!
  
    static var shared: Logger = {
       
        let soObject = Logger()
        
        let docDirectory: NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        
        soObject.logPath = docDirectory.appendingPathComponent("Logfile_\(Date().timeIntervalSince1970).txt")
        
        return soObject
    }()
    
    
    func showLog(_ logString: Any) {
        
        if Logger.shared.enableDebugging {
            
            print("\n\(logString)")
            
            #if os(iOS) && DEBUG
//            freopen(logPath.cString(using: String.Encoding.ascii)!, "a+", stdout)
           
            #else
//            let docDirectory: NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
//            
//            let logpath = docDirectory.appendingPathComponent("Logfile.txt")
//            
//            freopen(logpath.cString(using: String.Encoding.ascii)!, "a+", stdout)
            
            #endif
        }
    }
    
    
    
    func deleteLogFileForNewLaunch() {
       
        if Logger.shared.enableDebugging {
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                
                for path in fileURLs{
                    
                    if path.absoluteString.lowercased().contains("logfile"){
                        
                         try FileManager.default.removeItem(at:path)
                    }
                }
            }
            catch {
                Logger.shared.showLog("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
        }
    }
}
