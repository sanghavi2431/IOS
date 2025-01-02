//
//  UserDefaultsManager.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation
import UIKit

class UserDefaultsManager {
    
    private static let authentication_token = "authentication_token"
    private static let userLoggedInStatus = "logged_In"
    private static let storeCurrentLat = "Store_Current_Lat"
    private static let storeCurrentlong = "Store_Current_Long"
    private static let storeDestinationLat = "Store_Destination_Lat"
    private static let storeDestinationlong = "Store_Destination_Long"
    private static let appConfiGetKey = "app_Confi_Get_Key"
    private static let voucher_Key = "voucher_Key"
    private static let user_id = "user_id"
    private static let mobile_no = "mobile_no"
    private static let free_Trial_Days = "free_Trial_Days"
    private static let gift_ID = "gift_ID"
    private static let storeWolooID = "store_Woloo_ID"
    private static let userData = "user_Data"
    private static let userProfile = "user_Profile"
    private static let wahCertificateCode = "wah_Certificate_Code"
    
    static func storeAuthenticationToken(value: String){
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(value, forKey: authentication_token)
    }
    
    static func fetchAuthenticationToken() -> String{
        return UserDefaults.standard.string(forKey: authentication_token) ?? ""
    }
    
    static func isUserloggedInStatusSave(value: Bool){
        
        //UserDefaults.standard.synchronize()
        UserDefaults.standard.set(value, forKey: userLoggedInStatus)
    }
    
    static func fetchIsUserloggedInStatusSave() -> Bool{
        
        return UserDefaults.standard.bool(forKey: userLoggedInStatus)
    }
    
    static func storeCurrentLat(value: Double){
        
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(value, forKey: storeCurrentLat)
    }
    static func fetchCurrentLat() -> Double{
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.double(forKey: storeCurrentLat)
    }
    
    static func storeCurrentLong(value: Double){
        
        UserDefaults.standard.set(value, forKey: storeCurrentlong)
    }
    static func fetchCurrentLong() -> Double{
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.double(forKey: storeCurrentlong)
    }
    
    static func storeDestinationLat(value: Double){
        
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(value, forKey: storeDestinationLat)
    }
    static func fetchDestinationLat() -> Double{
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.double(forKey: storeDestinationLat)
    }
    
    
    
    static func storeDestinationLong(value: Double){
        
        UserDefaults.standard.set(value, forKey: storeDestinationlong)
    }
    static func fetchDestinationLong() -> Double{
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.double(forKey: storeDestinationlong)
    }
    
    static func storeWolooID(value: Int){
        
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(value, forKey: storeWolooID)
    }
    
    static func fetchWolooID() -> Int{
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.integer(forKey: storeWolooID)
    }
    
    static func storeAppConfigData(value: AppCofigGetModel){
       
        let data = try? JSONEncoder().encode(value)
        UserDefaults.standard.set(data, forKey: appConfiGetKey)
        UserDefaults.standard.synchronize()
    }
    
    
    static func fetchAppConfigData() -> AppCofigGetModel? {
        let data = UserDefaults.standard.data(forKey: appConfiGetKey)
        if data == nil {return nil}
        let value = try? JSONDecoder().decode(AppCofigGetModel.self, from: data!)
        return value ?? nil
    }
    
    static func storeUserData(value: UserProfileModel){
        let data = try? JSONEncoder().encode(value)
        UserDefaults.standard.set(data, forKey: userData)
        UserDefaults.standard.synchronize()
        
    }
    
    static func fetchUserData() -> UserProfileModel? {
        let data = UserDefaults.standard.data(forKey: userData)
        if data == nil {return nil}
        let value = try? JSONDecoder().decode(UserProfileModel.self, from: data!)
        return value ?? nil
    }
    
    static func storeUserProfile(value: Profile?){
        let data = try? JSONEncoder().encode(value)
        UserDefaults.standard.set(data, forKey: userProfile)
        UserDefaults.standard.synchronize()
        
    }
    
    static func fetchUserProfile() -> Profile? {
        let data = UserDefaults.standard.data(forKey: userData)
        if data == nil {return nil}
        let value = try? JSONDecoder().decode(Profile.self, from: data!)
        return value ?? nil
    }
    
    static func storeGiftID(value: String){
        UserDefaults.standard.set(value, forKey: gift_ID)
        UserDefaults.standard.synchronize()
    }
    static func fetchGiftID() -> String{
        
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.string(forKey: gift_ID) ?? ""
    }
    
    static func storeVoucherCode(value: String) {
        
        UserDefaults.standard.set(value, forKey: voucher_Key)
        UserDefaults.standard.synchronize()
    }
    
    static func fetchVoucherCode() -> String {
        
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.string(forKey: voucher_Key) ?? ""
    }
    
    static func storeWahCode(value: String) {
        
        UserDefaults.standard.set(value, forKey: wahCertificateCode)
        UserDefaults.standard.synchronize()
    }
    
    static func fetchWahCode() -> String {
        
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.string(forKey: wahCertificateCode) ?? ""
    }
    
    static func saveUserID(value: Int) {
       
        UserDefaults.standard.set(value, forKey: user_id)
        UserDefaults.standard.synchronize()
    }
    
    static func fetchUserID() -> Int {
        
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.integer(forKey: user_id)
    }
    
    static func storeUserMob(value: String){
        
        UserDefaults.standard.set(value, forKey: mobile_no)
        UserDefaults.standard.synchronize()
    }
    
    static func fetchUserMob() -> String{
        return UserDefaults.standard.string(forKey: mobile_no) ?? "" 
    }
    
    static func storeFreeTrialDays(value: String){
        UserDefaults.standard.set(value, forKey: free_Trial_Days)
        UserDefaults.standard.synchronize()
        
    }
    
    static func fetchFreeTrialDays() -> String{
        
        return UserDefaults.standard.string(forKey: free_Trial_Days) ?? ""
        UserDefaults.standard.synchronize()
    }
}

