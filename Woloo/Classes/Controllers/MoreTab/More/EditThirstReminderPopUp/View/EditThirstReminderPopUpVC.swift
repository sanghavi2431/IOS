//
//  EditThirstReminderPopUpVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 07/02/25.
//

import UIKit
import STPopup

protocol EditThirstReminderPopUpDelegate: NSObjectProtocol{
    
    func setThirstReminder()
}

class EditThirstReminderPopUpVC: UIViewController {

    weak var delegate: EditThirstReminderPopUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
        
    }

    func loadInitialSettings(){
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width - 32, height: 442.0)
        
        
        let btnBookmarkWidth = UIScreen.main.bounds.width - 32
        let btnBookmarkHeight = 442.0

        if btnBookmarkWidth < btnBookmarkHeight{
            
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkWidth / 5.7
        }
        else{
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkHeight / 5.7
        }
        
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }

   
    @IBAction func yesThirstReminderAction(_ sender: Any) {
      //  self.dismiss(animated: true)
            //                DispatchQueue.main.async {
            //                    let objController = SetThirstReminderPopUpVC(nibName: "SetThirstReminderPopUpVC", bundle: nil)
            //
            //                    let popup = STPopupController(rootViewController: objController)
            //                    popup.present(in: self)
            //                }
            //            self.dismiss(animated: true)
            //            }
        
        if (self.delegate != nil){
            self.dismiss(animated: true)
            self.delegate?.setThirstReminder()
        }
    }
    
    @IBAction func noThirstReminderAction(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
}

