//
//  ThirstReminderVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 27/01/25.
//

import UIKit
import STPopup

class ThirstReminderVC: UIViewController {

    @IBOutlet weak var setFrequencyTextField: UITextField!
    @IBOutlet weak var thirstReminderView: UIView!
    @IBOutlet weak var thirstReminderHoursView: UIView!
    
    var isZero: Bool?
    var netCoreEvents = NetcoreEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFrequencyTextField.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
        self.thirstReminderHoursView.isHidden = true
    }


    @IBAction func closeThirstReminderAction(_ sender: Any) {
        self.thirstReminderHoursView.isHidden = true
        self.thirstReminderView.isHidden = false
    }
    
    @IBAction func yesThirstReminderAction(_ sender: Any) {
        thirstReminderHoursView.isHidden = false
        self.thirstReminderView.isHidden = true
    }
    
    @IBAction func noThirstReminderAction(_ sender: Any) {
       // thirstReminderNo()
        thirstReminderNoV2()
        
    }
    
    @IBAction func savethirstReminderHoursAction(_ sender: Any) {
        //thirstReminderYes()
        if isZero == true{
            self.showToast(message: "Can't enter Zero as hours")
            
        }else{
            thirstReminderYesV2()
        }
    }
    
    
    
    @IBAction func clickedBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChanged(_ textField: UITextField) {
        print("Hrs added: \(textField.text)")
        if textField.text == "0"{
            self.isZero = true
            print("can't enter 0 as hours")
        }
        else{
            self.isZero = false
        }
        
    }
    
    fileprivate func thirstReminderYesV2() {
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        let setFrequency = setFrequencyTextField.text
        let param:  [String : Any] =  [ "is_thirst_reminder": "1" ,
                                        "thirst_reminder_hours": setFrequency]
        
        NetworkManager(data: param, headers: headers, url: nil, service: .thirstReminder, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ThirstReminderModel>, Error>) in
            switch result{
            case .success(let response):
                print("Thirst reminder response: \(response)")
                //self.thirstReminderMainView.isHidden = true
                
                
               // self.showToast(message: "THIRST REMINDER SUCCESSFULLY ADDED !")
                self.thirstReminderHoursView.isHidden = true
                self.thirstReminderView.isHidden = false
                // Local Notification
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Thirst reminder", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "It's time to drink water!", arguments: nil)
                content.sound = UNNotificationSound.default // Deliver the notification in five seconds.
                
                
                let setFrequencyTime =  60 * 60 * Int(setFrequency ?? "")!
                //let setFrequencyTime = 60 * Int(setFrequency ?? "")!
                print("Thirst reminder frequency time set: ",setFrequencyTime)
                var setTimeInterval = Int(setFrequencyTime)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(setFrequencyTime), repeats: true)
                let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
                
                let center = UNUserNotificationCenter.current()
                center.add(request)
                param
                
                Global.addNetcoreEvent(eventname: self.netCoreEvents.thirstReminderClick, param: ["is_thirst_reminder": "1", "thirst_reminder_hours": setFrequency, "user_id": UserModel.user?.userId ?? 0, "platform": "iOS"])
                
            case .failure(let error):
                print("Error thirst reminder \(error)")
            }
        }
        
    }
    
    fileprivate func thirstReminderNoV2() {
        
        if !Connectivity.isConnectedToInternet(){
            //Do something if network not found
        }
        
        let AppBuild = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
        var systemVersion = UIDevice.current.systemVersion
        print("System Version : \(systemVersion)")
        
        
        var iOS = "IOS"
        var userAgent = "\(iOS)/\(AppBuild ?? "")/\(systemVersion)"
        
        print("UserAgent: \(userAgent)")
        
        let headers = ["x-woloo-token": UserDefaultsManager.fetchAuthenticationToken(), "user-agent": userAgent]
        let setFrequency = setFrequencyTextField.text
        let param:  [String : Any] =  [ "is_thirst_reminder": "0" ,
                                        "thirst_reminder_hours": "0"]
        
        NetworkManager(data: param, headers: headers, url: nil, service: .thirstReminder, method: .post, isJSONRequest: true).executeQuery { (result: Result<BaseResponse<ThirstReminderModel>, Error>) in
            switch result{
            case .success(let response):
                print("Thirst reminder response: \(response)")
                DispatchQueue.main.async {
                    //self.thirstReminderMainView.isHidden = true
                    
                    let center = UNUserNotificationCenter.current()
                    center.removeDeliveredNotifications(withIdentifiers: ["FiveSecond"])
                    center.removePendingNotificationRequests(withIdentifiers: ["FiveSecond"])
                }
                Global.addNetcoreEvent(eventname: self.netCoreEvents.thirstReminderClick, param: ["is_thirst_reminder": "0", "thirst_reminder_hours": 0, "user_id": UserModel.user?.userId ?? 0, "platform": "iOS"])
               // self.thirstReminderMainView.isHidden = true
                
            case .failure(let error):
                print("Error thirst reminder")
            }
        }
        
        
        
    }
    
}
