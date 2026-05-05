//
//  PowderRoomPassVC.swift
//  Woloo
//
//  Created by CEPL on 07/10/25.
//

import UIKit
import Razorpay

class PowderRoomPassVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sosBottomVW: UIView!
    @IBOutlet weak var sosBottomVwTitlelbl: UILabel!
    @IBOutlet weak var sosBottomVwContctInfolbl: UILabel!
    
    @IBOutlet weak var vwBackCall: ShadowView!
    
    
    var objPowderRoomPassViewModel = PowderRoomPassViewModel()
    var razorPay: RazorpayCheckout!
    var objDashboardViewModel = DashboardViewModel()
    var netcoreEvents = NetcoreEvents()
    var wolooSupport: Place?
    var isSOSOptionSelected: String? = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.objPowderRoomPassViewModel.delegate = self
        self.objDashboardViewModel.delegate = self
        razorPay = RazorpayCheckout.initWithKey(UserDefaultsManager.fetchAppConfigData()?.RZ_CRED?.key ?? "", andDelegateWithData: self)
        
        Global.addNetcoreEvent(eventname: self.netcoreEvents.powderRoomOffer, param: ["":""])
        
        self.wolooSupport = Place(name: "Woloo", address: "Shraddhanand Road, Hirachand Desai Rd, Ghatkopar, W, Mumbai, Maharashtra 400086", placeId: "")
        self.wolooSupport?.phone = "02249741750"
        self.isSOSOptionSelected = "Woloo"
        
        let vwBackWidth = UIScreen.main.bounds.width - 48
        let vwackHeight = 132.67
        
        self.vwBackCall.layer.cornerRadius = 20.0
       
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var wolooCode =  UserDefaultsManager.fetchWahCode()
        var strType = UserDefaultsManager.fetchDeepLinkType()
        
        if Utility.isEmpty(wolooCode) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func clickedCallBtn(_ sender: Any) {
        self.sosBottomVW.isHidden = true
        self.callNumber(phoneNumber: self.wolooSupport?.phone ?? "")
        
    }
    
    @IBAction func clickedvwCallDismiss(_ sender: UIButton) {
            self.sosBottomVW.isHidden = true
    }
    
    
    func callNumber(phoneNumber: String) {
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL)
                }
            }
        }
    }
    
    
}
