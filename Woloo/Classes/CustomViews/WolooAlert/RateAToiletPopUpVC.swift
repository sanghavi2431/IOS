//
//  RateAToiletPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 26/08/25.
//

import UIKit
import STPopup

protocol RateAToiletPopUpDelegate: AnyObject {
    func closePopUp()
}


class RateAToiletPopUpVC: UIViewController {

    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnClose: ShadowViewButton!
    
    weak var delegate: RateAToiletPopUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }


    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.popupController?.containerView.layer.cornerRadius = 8.0
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = .clear
        
        let btnBookmarkWidth = UIScreen.main.bounds.width - 32
        let btnBookmarkHeight = UIScreen.main.bounds.height * 0.50
        if btnBookmarkWidth < btnBookmarkHeight{
            
            self.vwBack.layer.cornerRadius = btnBookmarkWidth / 5.7
        }
        else{
            self.vwBack.layer.cornerRadius = btnBookmarkHeight / 5.7
        }
        
        imgView.image = UIImage.gifFromAsset(named: "thanks_rate")
    }

    @IBAction func clickedBtnClose(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.closePopUp()
            //self.dismiss(animated: true)
        }
        self.dismiss(animated: true)
    }
    
    
}
