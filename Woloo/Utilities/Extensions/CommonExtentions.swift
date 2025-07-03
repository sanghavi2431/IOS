//
//  CommonExtentions.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import IQKeyboardManagerSwift
import ObjectMapper
import ImageIO

let DELEGATE: AppDelegate = UIApplication.shared.delegate as! AppDelegate

extension NSNotification.Name {
    static var paymentSuccess = NSNotification.Name.init("PaymentSuccess")
    static var deepLinking = NSNotification.Name.init("Deep_linking")
    static var destinationReached = NSNotification.Name.init("Destination_Reached")
   
}

extension String {
    func capitalizingFirstLetter() -> String {
        guard self.count > 0 else { return "" }
        let first = self.prefix(1).capitalized
        let other = self.dropFirst()
        return first + other
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
    
    func getUnderlinedString(textColor:UIColor = .white,underlineColor:UIColor = .white) -> NSAttributedString{
        
        let underlineAttribute:[NSAttributedString.Key : Any] = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.underlineColor:underlineColor,NSAttributedString.Key.foregroundColor:textColor]
        
        let string = NSAttributedString(string: self, attributes: underlineAttribute)
        
        return string
    }
    
    func isValidEmail()->Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    }
    
    func isValidPhoneNumber() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: self)
        return result
    }
    
    func addEmailXXX() -> String {
        
        let delimiter = "@"
        let arr = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: delimiter)
        var resultStr  = ""
        let emailUserCount = arr[0].count
        if emailUserCount > 3 {
            let lastText = arr[0].dropFirst(emailUserCount-3)
            let encriptedText = String(repeating: "x", count: (emailUserCount - 3))
            resultStr = "\(encriptedText)\(lastText)" + "@" + arr[1]
        }else {
            resultStr = "xxxxxx" + "@" + arr[1]
        }
        return resultStr
    }
    
    
    func addMobileXXX() -> String {
        
        let mobileNumber = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var resultStr  = ""
        
        let mobileCount = self.count
        
        if mobileCount > 3 {
            let lastText = mobileNumber.dropFirst(mobileCount-3)
            let encriptedText = String(repeating: "x", count: (mobileCount - 3))
            resultStr = "\(encriptedText)\(lastText)"
        }else {
            resultStr = mobileNumber
        }
        
        return resultStr
    }
    
    func isValidUrl() -> Bool {
        
        if self.count > 0 && self.contains("http://") || self.contains("https://"){
            return true
        }
        return false
    }
    
    public func toDouble() -> Double?
    {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
}

enum StoryboardExtension : String {
    
    case main,tabBar,details,createContent,authentication
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue.capitalizingFirstLetter(), bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(from appStoryboard : StoryboardExtension) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
}

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        //        mask.masksToBounds = true
        layer.mask = mask
    }
    


    // Function to round top left and top right corners of a UIView
    func roundTopCorners(radius: CGFloat) {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }

    

    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    func setGradient() {
        self.setGradient(colors: [.red,.gray])
    }
    
    func removeGradient(){
        if let lastLayer = self.layer.sublayers?.first(where: { (layer) -> Bool in
            return layer.name ?? "" == "Gradient"
        }) {
            lastLayer.removeFromSuperlayer()
        }
    }
    
    func setGradient(colors:[UIColor]) {
        
        removeGradient()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "Gradient"
        gradient.frame = bounds
        gradient.colors = colors.map{$0.cgColor}
        
        let alpha: Float = 90 / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        gradient.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        gradient.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    func getGradientLayer() -> CAGradientLayer{
        
        let colors:[UIColor] = [.red,.gray]
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.name = "Gradient"
        gradient.frame = bounds
        gradient.colors = colors.map{$0.cgColor}
        
        let alpha: Float = 90 / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        gradient.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        gradient.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        
        return gradient
    }
    
    func underlined(color:UIColor,width:CGFloat){
        
        let layer = UIView()
        
        layer.frame = CGRect.init(x:0.0, y: self.frame.size.height - 1, width: width, height: 1.5)
        
        layer.backgroundColor = color
        
        self.addSubview(layer)
    }
    
}

// MARK: - Array
extension Array {
    func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T>{
        var arr = array
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)
        
        return arr
    }
}

// MARK: - Dictionary
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

// MARK: - String
extension String {
    
    var toDate:Date?  {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss"
        return dateFormatter.date(from: self)
    }
    
    func convertDateFormater(_ date: String, inputFormate: String? = "", outputFormate: String? = "") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormate == "" ? "yyyy-MM-dd HH:mm:ss z" : inputFormate
        if let date1 = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = outputFormate == "" ? "yyyy-MM-dd" : outputFormate
            return  dateFormatter.string(from: date1)
        }
        return ""
    }
    
    public func toDate(format: String = "yyyy-MM-dd") -> Date {
        let formatter = DateFormatter()
//        `formatter.locale = Locale.current
//        formatter.calendar = Calendar.current
//        fo`rmatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
    
    func convertDateToDate(_ date: String, inputFormate: String? = "", outputFormate: String? = "") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormate == "" ? "yyyy-MM-dd HH:mm:ss z" : inputFormate
        return dateFormatter.date(from: date) ?? Date()
        if let date1 = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = outputFormate == "" ? "yyyy-MM-dd" : outputFormate
            return dateFormatter.date(from: date) ?? Date()
        }
        return Date()
    }
}

extension Int {
    
    var toDateFromUTC:String  {
        
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        dateFormatter.dateFormat = "EEEE dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    var toTimeFromUTC:String  {
        
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func durationSplit(style: DateComponentsFormatter.UnitsStyle) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute] //[.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: Double(self * 60)) else { return "" }
        return formattedString
    }
    
    var currentDateFromUTC:Date  {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return date
        
        
    }
}

extension Date {
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    func intervalBetweenDates(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func convertDateToString(_ formate: String? = "YY/MM/dd") -> String {

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = formate

        // Convert Date to String
        return dateFormatter.string(from: self)
        
    }

    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}


@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}

extension UINavigationBar{
    
    func setNavigationCenterImage(image:String) {
        let navImage = UIImageView(frame:CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: self.frame.height - 6)))
        navImage.contentMode = .scaleAspectFit
        navImage.image = UIImage(named: image)?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        self.addSubview(navImage)
    }
}

extension UIViewController {
    func showToast(message : String) {
        if message != ""
        {
            self.view.endEditing(true)
            let bgView : UIView = UIView(frame: CGRect(x: 10,
                                                       y: 100,// self.view.frame.size.height  - 200,
                                                       width: UIScreen.main.bounds.width - 10,
                                                       height: 60))
            bgView.layer.cornerRadius = 30
            bgView.layer.borderColor = UIColor(named: "Woloo_Gray_bg")?.cgColor
            bgView.layer.borderWidth = 2
            bgView.backgroundColor = UIColor(named: "Woloo_Yellow")
            
            guard let keyWindow = UIApplication.shared.windows.first else { return }
            keyWindow.addSubview(bgView)
            
            let toastLabel = UILabel(frame: CGRect(x: 10,
                                                   y: 5,
                                                   width: bgView.frame.size.width - 20,
                                                   height: 60))
            toastLabel.backgroundColor = UIColor.clear
            toastLabel.textColor =  UIColor(named: "Woloo_Gray_bg")
            toastLabel.textAlignment = .center;
            //toastLabel.font = UIFont.systemFont(ofSize: 14)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.numberOfLines = 0
            toastLabel.lineBreakMode = .byWordWrapping
            toastLabel.clipsToBounds  =  true
            bgView.addSubview(toastLabel)
            toastLabel.sizeToFit()
            
            
            let yPosition = UIScreen.main.bounds.height - keyWindow.safeAreaInsets.bottom - 100 - (toastLabel.frame.size.height + 10)
            //(Constants.Device.IS_IPHONE_X ? Constants.Screen.height - 100 - (toastLabel.frame.size.height + 10): Constants.Screen.height - 50 - (toastLabel.frame.size.height + 10) )
            
            //                       if IQKeyboardManager.shared.keyboardShowing{
            //                           yPosition = yPosition - 216
            //                       }
            
            bgView.frame = CGRect(x: 10,
                                  y:yPosition ,
                                  width: bgView.frame.size.width - 10,
                                  height: toastLabel.frame.size.height + 10)
            
            bgView.layer.cornerRadius = bgView.frame.size.height/2
            
            toastLabel.frame = CGRect(x: 10,
                                      y: (bgView.frame.size.height - toastLabel.frame.size.height)/2,
                                      width: bgView.frame.size.width - 20,
                                      height: toastLabel.frame.size.height)
            
            UIView.animate(withDuration: 4.0, delay: 0.9, options: .curveEaseOut, animations: {
                bgView.alpha = 0.0
            }, completion: {(isCompleted) in
                bgView.removeFromSuperview()
            })
        }
    }
}

/*
 extension API{
 
 func call<T: Mappable>(_ params:[String:Any],completion: @escaping (_ result:Result<T, ErrorResponse>) -> Void) {
 
 var requestUrl:String {
 //"http://192.168.1.169:9099/api/v1/"
 return  API.environment.baseURL + "v1/" + "Category/getData"
 }
 
 guard let url = URL(string:requestUrl) else { return }
 
 var request = URLRequest(url:url)
 request.httpMethod = "POST"
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 
 do{
 let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
 request.httpBody = jsonData
 }
 catch (let error){
 print(error)
 }
 
 URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
 
 if error == nil{
 
 if let data = data, let decoded = data.decodeJson() as? [String:Any]{
 
 var result = Response()
 
 if let code = decoded["code"] as? Int{
 
 result.status = code
 }
 
 if let message = decoded["message"] as? String{
 
 result.message = message
 }
 
 if result.status == 200 {
 
 if let json = decoded["data"] as? [String:Any], let returnModel:T = Mapper<T>().map(JSON: json) {
 
 DispatchQueue.main.async {
 completion(.success(returnModel))
 }
 }
 else {
 
 DispatchQueue.main.async {
 
 var errorResponse = ErrorResponse()
 errorResponse.message = result.message
 completion(.failure(errorResponse))
 }
 }
 }
 else {
 DispatchQueue.main.async {
 var errorResponse = ErrorResponse()
 errorResponse.message = result.message
 completion(.failure(errorResponse))
 }
 }
 }
 }
 else{
 
 DispatchQueue.main.async {
 var errorResponse = ErrorResponse()
 errorResponse.message = error?.localizedDescription ?? "Server error"
 completion(.failure(errorResponse))
 }
 }
 
 }).resume()
 }
 }
 */
struct Response {
    var message:String?
    var status:Int?
    var data:Any?
}

struct ErrorResponse:Error {
    var message:String?
    var status:Int?
}

extension UIImageView{
    
    func setImage(string: String){
        
        if string.count > 0 ,let url = URL(string: string){
            self.sd_setImage(with: url, completed: nil)
        }
    }
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
      }
    
    
    
}

extension UIImageView {
    
    func alphaAtPoint(_ point: CGPoint) -> CGFloat {
        
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: alphaInfo) else {
            return 0
        }
        
        context.translateBy(x: -point.x, y: -point.y);
        
        layer.render(in: context)
        
        let floatAlpha = CGFloat(pixel[3])
        
        return floatAlpha
    }
}


extension UIImage {
    static func gifFromAsset(named name: String) -> UIImage? {
        guard let asset = NSDataAsset(name: name) else {
            print("GIF asset not found: \(name)")
            return nil
        }
        return gif(data: asset.data)
    }

    static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        var images = [UIImage]()
        var duration: TimeInterval = 0

        let count = CGImageSourceGetCount(source)

        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))

            // Duration per frame (simple fallback)
            let delay = 0.1
            duration += delay
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }
}

extension UITextField{
    
    @IBInspectable var textPlaceholderColor: UIColor? {
        get {
            return self.textPlaceholderColor ?? .white
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder ?? "",
                                                            attributes: [NSAttributedString.Key.foregroundColor:newValue ?? .white])
        }
    }
}

extension UIViewController{
    
    func setLogoOnNavigation(logoImage:String) {
        
        if let image = UIImage(named: logoImage) {
            
            let logo = UIImageView(image: image)
            logo.contentMode = UIView.ContentMode.scaleAspectFit
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 44))
            logo.frame = titleView.bounds
            
            titleView.center = CGPoint(x: (self.navigationController?.navigationBar.bounds.width)! / 2.0, y: (self.navigationController?.navigationBar.bounds.height)! / 2.0)
            titleView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            
            titleView.addSubview(logo)
            self.navigationItem.leftBarButtonItem?.customView = titleView
        }
    }
}

extension String {
    var url:URL? {
        return URL(string: self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    }
    // Replace
    func replace(_ search: String, with: String) -> String {
        
        let replaced: String = self.replacingOccurrences(of: search, with: with)
        return replaced.isEmpty ? self : replaced
        
    }
}
extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


// MARK: - UILabel
extension UILabel {
    
    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}

extension Date {
    public func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .weekOfMonth, .minute], from: self, to: Date())
        let yearStr = "year"
        let yearsStr = "years"
        let monthStr = "month"
        let monthsStr = "months"
        let daysStr = "days"
        let weekStr = "week"
        let weeksStr = "weeks"
        let hourStr = "hour"
        let hoursStr = "hours"
        let minStr = "minute"
        let ago = "ago"
        let now = "now"
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + yearStr : "\(year)" + " " + yearsStr
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + monthStr : "\(month)" + " " + monthsStr
        } else if let week = interval.weekOfMonth, week > 0 {
            return week == 1 ? "\(week) \(weekStr) \(ago)" : "\(week) \(weeksStr) \(ago)"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "yesterday" : "\(day)" + " " + daysStr
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour) \(hourStr) \(ago)" : "\(hour) \(hoursStr) \(ago)"
        } else if let minute = interval.minute, minute > 0 {
            return "\(minute) \(minStr) \(ago)"
        } else {
            return now
        }
    }
}

extension UserDefaults {
    private struct UserDefaultUserKeys {
        static let userCode = "userCode"
        static let jwtToken = "jwtToken"
        static let userSelectedStore = "userSelectedStore"
    }
    
    /// Use to save and get UserTransPortmode.
    class var userTransportMode: TransportMode? {
        get {
            if let data = UserDefaults.standard.data(forKey: "user_transport_Mode") {
                do {
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(TransportMode.self, from: data)
                    return value
                } catch {
                    print("Unable to Decode Notes (\(error))")
                }
            }
            return nil
        } set {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: "user_transport_Mode")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var voucherCode: String? {
        get {
            if let rawValue = UserDefaults.standard.value(forKey: "voucher_Code") as? String {
                return rawValue
            }else {
                return nil
            }
        } set {
            UserDefaults.standard.set(newValue , forKey: "voucher_Code")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var tutorialScreen: Bool? {
        get {
            if let rawValue = UserDefaults.standard.value(forKey: "Tutorial") as? Bool {
                return rawValue
            }else {
                return nil
            }
        } set {
            UserDefaults.standard.set(newValue , forKey: "Tutorial")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var certificatCode: String? {
        get {
            if let rawValue = UserDefaults.standard.value(forKey: "wahcertificate") as? String {
                return rawValue
            }else {
                return nil
            }
        } set {
            UserDefaults.standard.set(newValue , forKey: "wahcertificate")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var referralCode: String? {
        get {
            if let rawValue = UserDefaults.standard.value(forKey: "referral_code") as? String {
                return rawValue
            }else {
                return nil
            }
        } set {
            UserDefaults.standard.set(newValue , forKey: "referral_code")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var userCode:String? {
        
        get {
            if let rawValue = UserDefaults.standard.value(forKey:UserDefaultUserKeys.userCode) as? String {
                return rawValue
            }else {
                return nil
            }
        }
        
        set(newValue){
            
            UserDefaults.standard.set(newValue , forKey: UserDefaultUserKeys.userCode)
            UserDefaults.standard.synchronize()
        }
    }
    
    class var jwtToken:String? {
        get {
            if let rawValue = UserDefaults.standard.value(forKey:UserDefaultUserKeys.jwtToken) as? String {
                return rawValue
            } else {
                return nil
            }
        }
        set(newValue) {
            UserDefaults.standard.set(newValue , forKey: UserDefaultUserKeys.jwtToken)
            UserDefaults.standard.synchronize()
        }
    }
    
    class var userSelectedStore:Int? {
        get {
            if let rawValue = UserDefaults.standard.value(forKey:UserDefaultUserKeys.userSelectedStore) as? Int {
                return rawValue
            } else {
                return nil
            }
        }
        
        set(newValue){
            UserDefaults.standard.set(newValue , forKey: UserDefaultUserKeys.userSelectedStore)
            UserDefaults.standard.synchronize()
        }
    }
    
    func resetDefaults() {
        //        let defaults = UserDefaults.standard
        //        let dictionary = defaults.dictionaryRepresentation()
        //        dictionary.keys.forEach { key in
        //            defaults.removeObject(forKey: key)
        //        }
        
        //let domain = Bundle.main.bundleIdentifier!
        let domain = "in.woloo.app"
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    
}
extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
