//
//  NoInternetConnectionView.swift
//  PublicamPlus
//
//  Created by Ashish.Khobragade on 11/07/18.
//  Copyright © 2018 Ashish.Khobragade. All rights reserved.
//

import UIKit

protocol NoInternetConnectionDelegate {

    func retryBtnClicked()
}

class NoInternetConnectionView: UIView {
    
    @IBOutlet weak var contentView: CustomView!
    @IBOutlet weak var noInternetAvailableLabel: UILabel!
    @IBOutlet weak var tapToRetryLabel: UILabel!
    
    @IBOutlet weak var imgRetry: UIImageView!
    @IBOutlet weak var imgNoInternet: UIImageView!
    var delegate:NoInternetConnectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        #if os(iOS)
        self.contentView?.backgroundColor = UIColor.white
        self.imgRetry?.tintColor = UIColor.black
        self.imgNoInternet?.tintColor = UIColor.black
        self.tapToRetryLabel?.textColor = UIColor.black
        self.tapToRetryLabel?.backgroundColor = UIColor.white
        self.noInternetAvailableLabel?.textColor = UIColor.black
        #endif
//        #else
//        let abstract = AbstractViewController ()
//        abstract.hideIndicator()
//        #endif

    }
    
    @IBAction func proceedToSettingsBtnClicked(){
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [: ]) { (isCompleted) in
                
            }
        }
    }
    
    @IBAction func retryBtnClicked(){
         #if os(iOS)
        //Online to offine switching.
//        DELEGATE.rootVC?.loadOfflineNavigation()

         #endif
        if let delegate = delegate{
          
            delegate.retryBtnClicked()
        }
    }
}

