//
//  ServicesPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 26/04/25.
//

import UIKit

protocol ServicesPopUpVCDeleate: NSObject{
    
    func didClickedStoreBtn()
    func didClickedHygieneServicesBtn()
}

class ServicesPopUpVC: UIViewController {
    
    @IBOutlet weak var btnStore: UIButton!
    @IBOutlet weak var btnHygieneServices: UIButton!
    
    weak var delegate: ServicesPopUpVCDeleate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings( )
    }


    func loadInitialSettings(){
        
        self.btnStore.layer.cornerRadius = 7.0
        self.btnHygieneServices.layer.cornerRadius = 7.0
        
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width - 32, height: 457)
        //self.popupController?.containerView.layer.cornerRadius = 62.8
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = .clear
        
        let btnBookmarkWidth = UIScreen.main.bounds.width - 32
        let btnBookmarkHeight = 457.0
        
        if btnBookmarkWidth < btnBookmarkHeight{
            
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkWidth / 5.7
        }
        else{
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkHeight / 5.7
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)

    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }

    
    
    @IBAction func clickedStoreBtn(_ sender: UIButton) {
        if self.delegate != nil{
            self.delegate?.didClickedStoreBtn()
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func clickedHygieneServicesBtn(_ sender: UIButton) {
        if self.delegate != nil{
            self.delegate?.didClickedHygieneServicesBtn()
            self.dismiss(animated: true)
        }
    }
    
    
    
    @IBAction func cliickedBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
