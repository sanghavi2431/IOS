//
//  BlogsPointsPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 20/05/25.
//

import UIKit

protocol BlogsPointsPopUpVCDelegate: NSObject{
    
    func didMNavigateToStore()
}

class BlogsPointsPopUpVC: UIViewController {

    
    @IBOutlet weak var lottieImgView: UIImageView!
    
    @IBOutlet weak var vwBack: UIView!
    
    @IBOutlet weak var lblWolooPoints: UILabel!
    
    
    @IBOutlet weak var btnClose: UIButton!
    
    weak var delegate: BlogsPointsPopUpVCDelegate?
    var pointCount: String? = ""
    var strComeFrom: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }

    
    func loadInitialSettings(){
       // self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height * 0.50)
        
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width - 32, height: 250)
        
        //self.popupController?.containerView.layer.cornerRadius = 62.8
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = .clear
        
        let btnBookmarkWidth = UIScreen.main.bounds.width - 32
        let btnBookmarkHeight = UIScreen.main.bounds.height * 0.50
        
//        if btnBookmarkWidth < btnBookmarkHeight{
//            
//            self.vwBack?.layer.cornerRadius = btnBookmarkWidth / 5.7
//        }
//        else{
//            self.vwBack?.layer.cornerRadius = btnBookmarkHeight / 5.7
//        }
        
        self.vwBack?.layer.cornerRadius  = 10.0
        
        self.btnClose.layer.cornerRadius = 5.0
        lottieImgView.image = UIImage.gifFromAsset(named: "yourgif")
        
        self.lblWolooPoints.text = "Wohoo! You Earned \(self.pointCount ?? "10") Woloo Points!"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }

    
//    @IBAction func clickedShopNowBtn(_ sender: UIButton) {
//        if self.delegate != nil{
//            self.delegate?.didMNavigateToStore()
//            self.dismiss(animated: true)
//        }
//    }
//    
    @IBAction func clickedBtnHome(_ sender: UIButton) {
        
        if self.strComeFrom == "SCAN"{
            if self.delegate != nil{
                self.delegate?.didMNavigateToStore()
                self.dismiss(animated: true)
            }
        }
        else{
            self.dismiss(animated: true)
        }
        
    }
}
