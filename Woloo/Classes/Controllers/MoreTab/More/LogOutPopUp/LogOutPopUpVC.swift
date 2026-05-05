//
//  LogOutPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 10/02/25.
//

import UIKit
import STPopup

protocol LogOutPopUpVCDelegate: NSObject{
    
    func didSelectLogOutYes()
}

class LogOutPopUpVC: UIViewController {

    weak var delegate: LogOutPopUpVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }

    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width - 32, height: 153)
        self.popupController?.containerView.layer.cornerRadius = 8.0
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
    }
    
    @IBAction func clickedBtnNo(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedYesBtn(_ sender: UIButton) {
       if (self.delegate != nil){
           self.delegate?.didSelectLogOutYes()
        }
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }

}
