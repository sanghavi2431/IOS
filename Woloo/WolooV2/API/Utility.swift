//
//  Utility.swift
//  FreeGoods
//
//  Created by Pradip Parkhe on 6/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

import AVFoundation
import UserNotifications
import CoreLocation
import Photos

class Utility: NSObject {
    
    class func getCurrentTimeZone() -> String {
        return TimeZone.current.identifier
    }
    
    class func setPaymentMethod(payMethod: Int) -> String? {
        var strPayMethod = ""
        switch payMethod {
        case 0:
            strPayMethod = "None"
        case 1:
            strPayMethod = "Visa"
        case 2:
            strPayMethod = "Mastercard"
        case 3:
            strPayMethod = "Discover"
        case 4:
            strPayMethod = "AmericanExpress"
        case 5:
            strPayMethod = "PersonalChecking"
        case 6:
            strPayMethod = "PersonalSavings"
        case 7:
            strPayMethod = "BusinessChecking"
        case 8:
            strPayMethod = "BusinessSavings"
        case 9:
            strPayMethod = "OtherCard"
            fallthrough
        case 10:
            strPayMethod = "GiftCard"
        case 11:
            strPayMethod = "WEX"
        case 12:
            strPayMethod = "Voyager"
        case 13:
            strPayMethod = "FuelMan"
        case 14:
            strPayMethod = "VisaFleet"
        case 15:
            strPayMethod = "MastercardFleet"
        case 16:
            strPayMethod = "FleetOne"
        case 17:
            strPayMethod = "FleetCor"
        case 18:
            strPayMethod = "OtherFleet"
        default:
            break
        }
        return strPayMethod
    }
    
    class func isEmpty(_ str: String) -> Bool {
        let probablyEmpty: String = str.trimmingCharacters(in: CharacterSet.whitespaces)
        if (probablyEmpty.count ) == 0 {
            return true
        }
        return false
    }
    
   // class func isInternetAvailable() -> Bool
//    {
//        let reachability = try! Reachability()
//        if reachability.connection == .unavailable {
//            return false
//        } else {
//            return true
//        }
//    }
    
//    class func isSystemGreaterThaniOS8() -> Bool {
//        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v: "8.0") {
//            return true
//        }
//        else {
//            return false
//        }
//    }
    
    class func isRequestAccessForCamera() -> Bool {
        var allow: Bool = false
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .authorized {
            allow = true
            // NSLog("AVAuthorizationStatusAuthorized access to %@", AVMediaTypeVideo)
        }
        else if authStatus == .denied {
            // denied
            //NSLog("AVAuthorizationStatusDenied access to %@", AVMediaTypeVideo)
        }
        else if authStatus == .restricted {
            // restricted, normally won't happen
            //NSLog("AVAuthorizationStatusRestricted access to %@", AVMediaTypeVideo)
        }
        else if authStatus == .notDetermined {
            // not determined?!
            //SSLog("AVAuthorizationStatusNotDetermined access to %@", AVMediaTypeVideo)
        }
        
        return allow
    }
    
    class func isEmailValid(_ emailId: String) -> Bool {
//        let emailRegex: String = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
//        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
//        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
//        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
//        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
//        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
//        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,50}"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        let res: Bool = emailTest.evaluate(with: emailId)
        return res
    }
    
    class func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex: String = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()-+]).{8,20}$"#
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let res: Bool = passwordTest.evaluate(with: password)
        return res
    }
    
    class func isValidPhoneNumber(_ PhoneNumber : Int) -> Bool{
        let strnumber = String(PhoneNumber)
        let PHONE_REGEX =  #"^\d{10}$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: strnumber)
        return result
    }
    
    class func isValidName(name: String) -> Bool {
        //Declaring the rule of characters to be used. Applying rule to current state. Verifying the result.
        let regex = "^[a-zA-Z'-]{2,30}$"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: name)
        
        return result
    }
    
    class func validateName(_ name: String) -> Bool {
        //"^[a-zA-Z'-]+$"
        let nameRegex = "^[a-zA-Z'-]{3,30}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
    
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    class func dateToString(strDate : NSDate, strFotmat:NSString) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFotmat as String?
        
        var str = dateFormatter.string(from: strDate as Date) as Optional
        
        if let value = str{
            //in value you will get non optional value
            str = ("\(value)" as NSString) as String
        }
        return str!
    }
    
    
    
    class func setCornerRadiusForView(viewCorner:UIView, cornerSize:CGFloat){
        viewCorner.layer.cornerRadius = cornerSize
        viewCorner.layer.masksToBounds = true
    }
    
    class func setPaddingForTextField(txtPadding:UITextField){
        let paddingView = UIView()
        paddingView.frame = CGRect(x: 0, y: 0, width: 5, height: txtPadding.frame.height)
        txtPadding.leftView = paddingView
        txtPadding.leftViewMode = UITextField.ViewMode.always
    }
    
//    class func openWhatsApp(whatsapp_no:String){
//        let msg = SSLocalizedString("", "") // here pass your message
//        let strWhatsappNo = whatsapp_no.replacingOccurrences(of: "+", with: "")
//        
//        let urlWhats = "https://api.whatsapp.com/send?phone=\(strWhatsappNo)&text=\(msg)" // Mobile number that include country code and without + sign .
//        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
//            if let whatsappURL = URL(string: urlString) {
//                if UIApplication.shared.canOpenURL(whatsappURL) {
//                    if #available(iOS 10.0, *) {
//                        _ = UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
//                    } else {
//                        // Fallback on earlier versions
//                        UIApplication.shared.canOpenURL(whatsappURL)
//                    }
//                } else {
//                    // Cannot open whatsapp
//                }
//            }
//        }
//    }
    
    class func phonenumberformat(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    
    class func compressImage(image:UIImage) -> Data
    {
        var imageData = Data()
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        /*  let imgRatio:CGFloat = actualWidth/actualHeight
         let maxWidth:CGFloat = 1000.0
         let resizedHeight:CGFloat = maxWidth/imgRatio */
        
        let imgRatio:CGFloat = actualHeight/actualWidth
        let maxHeight:CGFloat = 1000.0
        let resizedWidth:CGFloat = maxHeight/imgRatio
        
        if(actualHeight > 1000.0){
            let rect:CGRect = CGRect(x: 0, y: 0, width: resizedWidth, height: maxHeight)
            UIGraphicsBeginImageContext(rect.size)
            image.draw(in: rect)
            let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            imageData = img.jpegData(compressionQuality: 0.6)!
            UIGraphicsEndImageContext()
        }else{
            imageData = image.jpegData(compressionQuality: 0.7)!
        }
        return imageData
    }
    
    class func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    class func obfuscateEmail(email: String) -> String {
        // Split the email address into username and domain
        let components = email.split(separator: "@")
        
        // Check if the email has a username and domain part
        guard components.count == 2 else {
            return email // Return the original email if it's malformed
        }
        
        let username = components[0]
        let domain = components[1]
        
        // Obfuscate the username
        let obfuscatedUsername: String
        if username.count > 3 {
            let startIndex = username.index(username.startIndex, offsetBy: 1)
            let endIndex = username.index(username.endIndex, offsetBy: -2)
            obfuscatedUsername = String(username[..<startIndex]) + String(repeating: "*", count: username.count - 3) + String(username[endIndex...])
        } else {
            obfuscatedUsername = String(repeating: "*", count: username.count)
        }
        
        // Obfuscate the domain
        let obfuscatedDomain: String
        if domain.count > 3 {
            let startIndex = domain.index(domain.startIndex, offsetBy: 1)
            let endIndex = domain.index(domain.endIndex, offsetBy: -2)
            obfuscatedDomain = String(domain[..<startIndex]) + String(repeating: "*", count: domain.count - 3) + String(domain[endIndex...])
        } else {
            obfuscatedDomain = String(repeating: "*", count: domain.count)
        }
        
        // Combine the obfuscated parts to form the obfuscated email
        return obfuscatedUsername + "@" + obfuscatedDomain
    }
    
    
    class func playSuccessSound(){
        let systemSoundID: SystemSoundID = 1322
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
    // MARK:- getProfileBirthdateDate method
    //    class func getProfileBirthdateDate(strDate:NSString) -> String{
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.locale = NSLocale.current
    //        dateFormatter.dateFormat = kDateFormatTypeWithoutT
    //
    //        let yourDate: Date? = dateFormatter.date(from: strDate as String)
    //        if(LanguageManager.isParsianLanguage()){
    //            dateFormatter.calendar = NSCalendar(identifier: NSCalendar.Identifier.persian)! as Calendar!
    //        }
    //        var updatedString = ""
    //        if(yourDate == nil){
    //            updatedString = "-"
    //        }
    //        else{
    //            dateFormatter.dateFormat = kDateFormatTypeProfileBirthdate
    //            updatedString = dateFormatter.string(from: yourDate!)
    //        }
    //        return updatedString
    //    }
    
    class func commentdateToString(strDate : NSDate, strFotmat:NSString) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone? // UTC conversion
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.dateFormat = strFotmat as String?
        
        var str = dateFormatter.string(from: strDate as Date) as Optional
        
        if let value = str{
            //in value you will get non optional value
            str = ("\(value)" as NSString) as String
        }
        return str!
    }
    
    
    // MARK:- getCreatePostDate method
//    class func getCreatePostDate(strDate:NSString) -> NSDate{
//        let dateFormatter = DateFormatter()
//        //        dateFormatter.locale = NSLocale.current
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone? // UTC conversion
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
//        dateFormatter.dateFormat = kDateFormatTypeGeneric24Hours
//        
//        let yourDate: Date? = dateFormatter.date(from: strDate as String)
//        //         var updatedString = ""
//        //        if(yourDate == nil){
//        //            updatedString = SSLocalizedString("present", "")
//        //        }
//        //        else{
//        //            dateFormatter.dateFormat = kDateFormatTypeWorkExperience
//        //            updatedString = dateFormatter.string(from: yourDate!)
//        //        }
//        return yourDate! as NSDate
//    }
    
    
    class func getTimeStamp() -> String {
        return "\(Date().timeIntervalSince1970 * 1000)"
    }
    
    class func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func convertBase64ToImage(base64String: String) -> UIImage? {
        if let imageData = Data(base64Encoded: base64String) {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    class func imageIsNullOrNot(imageName : UIImage)-> Bool
    {
        
        let size = CGSize(width: 0, height: 0)
        if (imageName.size.width == size.width)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    
//    class func getPetDate(strDate:NSString) -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = kDateFormatTypeWithoutT
//        
//        let yourDate: Date? = dateFormatter.date(from: strDate as String)
//        
//        var updatedString = ""
//        if(yourDate == nil){
//            updatedString = "-"
//        }
//        else{
//            dateFormatter.dateFormat = kDateFormatTypeEvent
//            updatedString = dateFormatter.string(from: yourDate!)
//        }
//        return updatedString
//    }
    
//    class func getNotificationDate(strDate:NSString) -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone? // UTC conversion
//        dateFormatter.dateFormat = kDateFormatTypeGeneric24Hours
//        
//        let yourDate: Date? = dateFormatter.date(from: strDate as String)
//        
//        var updatedString = ""
//        if(yourDate == nil){
//            updatedString = "-"
//        }
//        else{
//            dateFormatter.dateFormat = kDateFormatTypeEvent
//            updatedString = dateFormatter.string(from: yourDate!)
//        }
//        return updatedString
//    }
    
    class func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year ?? 0) years"
        } else if (components.year ?? 0 >= 1){
            if (numericDates){
                return "1 year"
            } else {
                return "Last year"
            }
        } else if (components.month ?? 0 >= 2) {
            return "\(components.month ?? 0) months"
        } else if (components.month ?? 0 >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear ?? 0 >= 2) {
            return "\(components.weekOfYear!) weeks"
        } else if (components.weekOfYear ?? 0 >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day ?? 0 >= 2) {
            return "\(components.day!) days"
        } else if (components.day ?? 0 >= 1){
            if (numericDates){
                return "1 day"
            } else {
                return "Yesterday"
            }
        }
        else if (components.hour ?? 0 <= 24){
            return "today"
        }else {
            return "Just now"
        }
        /* else if (components.hour! >= 2) {
         return "\(components.hour!) hours ago"
         } else if (components.hour! >= 1){
         if (numericDates){
         return "1 hour ago"
         } else {
         return "An hour ago"
         }
         } else if (components.minute! >= 2) {
         return "\(components.minute!) minutes ago"
         } else if (components.minute! >= 1){
         if (numericDates){
         return "1 minute ago"
         } else {
         return "A minute ago"
         }
         } else if (components.second! >= 3) {
         return "\(components.second!) seconds ago"
         } else {
         return "Just now"
         } */
        
    }
    
    
    class func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
            
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }
   // class func setIndicatorColor(btn : RNLoadingButton)
//    {
//        //		btn.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.white, for: .normal)
//        btn.activityIndicatorColor = UICOLOR_WHITE
//    }
    
    
    
    class func JSONValue(object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    
    
    static func convertToPersian(text : String)-> String {
        return text;
    }
    
    class func formatForAudioPlayer(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        if duration >= 3600 {
            formatter.allowedUnits.insert(.hour)
        }
        
        return formatter.string(from: duration)!
    }
    
    
    
    class func timeFormattedForReminder(totalSeconds: Int) -> String {
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    class func getAppversion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
    
    class func getBuildversion() -> String {
        var strBuildVersion : String = ""
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            strBuildVersion = text
        }
        return strBuildVersion
    }
    
    class func getOrdinalFormatFromNumber(locCount:Int) -> String {
        var first : String = ""
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        first = formatter.string(from: NSNumber(value: locCount)) ?? ""
        return first
    }
    /*
     class func getShopCategoryText(shopType:String, catTypeName:String)-> String{
     var strCategory : String = "-"
     switch shopType {
     case "RESTAURANT":
     strCategory = SSLocalizedString("food", "")
     break
     case "MEDICINE":
     strCategory = SSLocalizedString("medicine", "")
     break
     case "FLOWERS":
     strCategory = SSLocalizedString("flowers", "")
     break
     case "GIFT":
     strCategory = SSLocalizedString("gift", "")
     break
     case "HARDWARE":
     strCategory = SSLocalizedString("hardware", "")
     break
     case "GROCERY":
     strCategory = SSLocalizedString("dry_grocery", "")
     break
     case "WATER_FILTER":
     strCategory = SSLocalizedString("water_filer", "")
     break
     case "BAZAR":
     strCategory = SSLocalizedString("bazar", "")
     break
     case "PARCEL":
     strCategory = SSLocalizedString("parcel", "")
     break
     case "ANY_STORE":
     strCategory = SSLocalizedString("other_store", "")
     break
     case "NONE":
     strCategory = catTypeName
     break
     default:
     strCategory = shopType
     break
     }
     return strCategory
     }
     */
    
    
    
//    class func applyShadowOnView(_ view: UIView) {
//        view.layer.cornerRadius = 4.0
//        view.layer.borderWidth = 0.0
//        view.layer.shadowColor = UICOLOR_BLACK.withAlphaComponent(0.16).cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        view.layer.shadowRadius = 4.0
//        view.layer.shadowOpacity = 1
//        view.layer.masksToBounds = false
//    }
    
    class func isEmptyString(string: String!) ->Bool{
        
        guard let str = string, !str.isEmpty else {
            print("String is nil or empty.")
            return true// or break, continue, throw
        }
        return false
        
        if let str = string, !str.isEmpty {
            /* string is not blank */
            return false
        }
        else{
            return true
        }
        
        
    }
    
    
    
    
//    class func setKeillaLocalNotification(strTime:String,title:String,strBody:String,arrWeekDay:[Int]){
//        let center = UNUserNotificationCenter.current()
//        let content = UNMutableNotificationContent()
//        content.body = strBody
//        content.sound = UNNotificationSound.default
//        content.userInfo = ["type": SSLocalizedString("reminder", "")]
//        content.title = title
//        
//        var arrTime = NSArray()
//        arrTime = strTime.components(separatedBy: ":") as NSArray
//        var strHour:String = ""
//        var strMin:String = ""
//        strHour = arrTime[0] as! String
//        strMin = arrTime[1] as! String
//        
//        let weekdaySet = arrWeekDay
//        
//        
//        for i in weekdaySet {
//            
//            //            var dateInfo = DateComponents()
//            var calendar = NSCalendar.current
//            calendar.timeZone = NSTimeZone.local
//            var dateInfo = calendar.dateComponents([.weekday,.hour, .minute, .second], from: Date().dayBefore)
//            dateInfo.hour = Int(strHour)
//            dateInfo.minute = Int(strMin)
//            dateInfo.weekday = i
//            dateInfo.timeZone = calendar.timeZone
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
//            
//            let request = UNNotificationRequest(
//                identifier: UUID().uuidString,
//                content: content,
//                trigger: trigger
//            )
//            
//            center.add(request, withCompletionHandler: { error in
//                if error != nil {
//                    //handle error
//                    print("error")
//                } else {
//                    //notification set up successfully
//                    print("notification set up successfully")
//                }
//            })
//        }
//    }
    
    class func getHoursAndMinFromMinutes(minutes:Int)  -> (hours:String , minutes:String){
        let h = minutes/60
        let m = minutes%60
        return ("\(h)","\(m)")
    }
    
    
    
    class func secondsFromShopTime(input:String) -> Int {
        let comps = input.components(separatedBy: ":")
        let h = (Int(comps.first!) ?? 0) * 3600
        let m = (Int(comps[1]) ?? 0) * 60
        let s = Int(comps.last!) ?? 0
        return h + m + s
    }
    
    class func shopTimeFormatTimeInSec(totalSeconds: Int) -> String {
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        let strHours = hours > 9 ? String(hours) : "0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        
        if (hours > 0){
            if(minutes > 0){
                return String(format: "%@.%@ Hours", strHours,strMinutes)
            }else{
                return String(format: "%@ Hours", strHours)
            }
        }
        else {
            return "\(strMinutes)"
        }
    }
    
    // Convert from miles to kilometers (Double)
    class func milesToKilometers(speedInMPH:Double) ->Double {
        let speedInKPH = speedInMPH * 1.60934
        return speedInKPH as Double
    }
    
    class func formatMinuteSeconds(_ totalSeconds: Int) -> String {
        print(totalSeconds)
        
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        return String(format:"%02d:%02d", minutes, seconds)
    }
    
    
    
    class func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    class func isPhotoLibraryPermissionAllowed() -> Bool{
        var status = PHPhotoLibrary.authorizationStatus()
        var isPermission:Bool = false
        
        if(status == .notDetermined) {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        isPermission = true
                        
                    } else {
                        isPermission = false
                    }
                }
            }
            return isPermission
        }
        
        status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            isPermission = true
            break
            
        case .denied, .restricted:
            isPermission = false
            break
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        isPermission = true
                    } else {
                        isPermission = false
                    }
                }
            }
        case .limited:
            break
        @unknown default:
            isPermission = false
            break
        }
        return isPermission
    }

    class func isCameraPermissionAllowed() -> Bool {
        var isPermission: Bool = false
        print("Open camera")
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            isPermission = true
        case .denied, .restricted:
            isPermission = false
        case .notDetermined:
            // Request camera access asynchronously
            AVCaptureDevice.requestAccess(for: .video) { granted in
                isPermission = granted
            }
        @unknown default:
            break
        }
        
        return isPermission
    }
    
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

class CustomSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 5)) //this height is the thickness
    }
    
}

extension UIView {
    
    func roundTop(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundBottom(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundTopForNewOrder(radius:CGFloat = 9){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func round(corners: UIRectCorner, cornerRadius: Double) {
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
    
    //func addDashedBorder() {
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()
        
        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = UIColor(named: "vwSeperatorColor")?.cgColor
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        layer.addSublayer(borderLayer)
        return borderLayer
    }
    //}
}

class NSAttributedStringHelper {
    static func createBulletedList(fromStringArray strings: [String], font: UIFont? = nil) -> NSAttributedString {
        
        let fullAttributedString = NSMutableAttributedString()
        let attributesDictionary: [NSAttributedString.Key: Any]
        
        if let font = font {
            attributesDictionary = [NSAttributedString.Key.font: font]
        } else {
            attributesDictionary = [NSAttributedString.Key: Any]()
        }
        
        for index in 0..<strings.count {
            let bulletPoint: String = "\u{2022}"
            var formattedString: String = "\(bulletPoint) \(strings[index])"
            
            if index < strings.count - 1 {
                formattedString = "\(formattedString)\n"
            }
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString, attributes: attributesDictionary)
            let paragraphStyle = NSAttributedStringHelper.createParagraphAttribute()
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
            fullAttributedString.append(attributedString)
        }
        
        return fullAttributedString
    }
    
    private static func createParagraphAttribute() -> NSParagraphStyle {
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 11
        paragraphStyle.headIndent = 11
        return paragraphStyle
    }
}


//func setupLblTitleWithAstrisk(str: String) -> NSMutableAttributedString {
//    let text = NSMutableAttributedString()
//    text.append(NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor(named: "textColor"),NSAttributedString.Key.font:FONT_UbuntuRegular_H14]));
//    text.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font:FONT_UbuntuRegular_H14]))
//    return text
//}

func covertPriceToString(price:Double,strCurrency:String) -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.groupingSize = 3
    formatter.secondaryGroupingSize = 3
    formatter.currencyCode = strCurrency
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    let priceWithCurrency = formatter.string(from: price as NSNumber) ?? ""
    return priceWithCurrency
}


/*
 private fun setObfuscateEmail(email: String) {
 val parts = email.split("@")
 
 
 val username = parts[0]
 val domain = parts[1]
 
 val obfuscatedUsername = obfuscateString(username)
 val obfuscatedDomain = obfuscateString(domain)
 
 binding.lblCheckEmailInstructionsOne.text =
 "${getString(R.string.check_email_instruction)} $obfuscatedUsername@$obfuscatedDomain"
 }
 
 private fun obfuscateString(input: String): String {
 
 val firstChar = input[0]
 val lastChar = input[input.length - 1]
 val obfuscatedPart = "*".repeat(input.length - 2)
 
 return "$firstChar$obfuscatedPart$lastChar"
 }
 
 */

func isPhotoLibraryPermissionAllowed() -> Bool{
    let status = PHPhotoLibrary.authorizationStatus()
    var isPermission:Bool = false
    
    switch status {
    case .authorized:
        isPermission = true
        break
        
    case .denied, .restricted:
        isPermission = false
        break
        
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    isPermission = true
                } else {
                    isPermission = false
                }
            }
        }
    case .limited:
        break
    @unknown default:
        isPermission = false
        break
    }
    return isPermission
}

func isCameraPermissionAllowed() -> Bool {
    var isPermission: Bool = false
    print("Open camera")
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .authorized:
        isPermission = true
    case .denied, .restricted:
        isPermission = false
    case .notDetermined:
        // Request camera access asynchronously
        AVCaptureDevice.requestAccess(for: .video) { granted in
            isPermission = granted
        }
    @unknown default:
        break
    }
    
    return isPermission
}


func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
    let calendar = NSCalendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = NSDate()
    let earliest = now.earlierDate(date as Date)
    let latest = (earliest == now as Date) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    }
    else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
    
}
