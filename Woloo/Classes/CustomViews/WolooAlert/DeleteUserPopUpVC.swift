//
//  DeleteUserPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 28/08/25.
//

import UIKit
import STPopup


protocol DeleteUserPopUpVCDelegate: NSObjectProtocol {
    
    func didClickedYes()
    
    func didClickedNo()
    
}

class DeleteUserPopUpVC: UIViewController {

    
    @IBOutlet weak var vwBack: UIView!
    
    weak var delegate: DeleteUserPopUpVCDelegate?
    
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
            
            self.vwBack.layer.cornerRadius = 10.0
        }
        else{
            self.vwBack.layer.cornerRadius = 10.0
        }
    }
    
    @IBAction func clickedBtnNo(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didClickedNo()
            self.dismiss(animated: true)
        }
        
    }
    
    @IBAction func clickedBtnYes(_ sender: UIButton) {
        if self.delegate != nil{
            self.delegate?.didClickedYes()
            self.dismiss(animated: true)
        }
    }
}
