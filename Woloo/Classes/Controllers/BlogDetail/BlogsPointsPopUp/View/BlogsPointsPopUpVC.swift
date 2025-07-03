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
    
    
    weak var delegate: BlogsPointsPopUpVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }

    
    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height * 0.50)
        //self.popupController?.containerView.layer.cornerRadius = 62.8
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = .clear
        
        let btnBookmarkWidth = UIScreen.main.bounds.width - 32
        let btnBookmarkHeight = UIScreen.main.bounds.height * 0.50
        
        if btnBookmarkWidth < btnBookmarkHeight{
            
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkWidth / 5.7
        } 
        else{
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkHeight / 5.7
        }
        
        lottieImgView.image = UIImage.gifFromAsset(named: "yourgif")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }

    
    @IBAction func clickedShopNowBtn(_ sender: UIButton) {
        if self.delegate != nil{
            self.delegate?.didMNavigateToStore()
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func clickedBtnHome(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
