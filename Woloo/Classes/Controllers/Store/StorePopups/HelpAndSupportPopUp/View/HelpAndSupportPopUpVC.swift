//
//  HelpAndSupportPopUpVC.swift
//  Woloo
//
//  Created by CEPL on 10/03/25.
//

import UIKit

class HelpAndSupportPopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitialSettings()
    }


    func loadInitialSettings(){
        
        self.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.50)
        self.popupController?.containerView.layer.cornerRadius = 75.0
        self.popupController?.navigationBarHidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}
