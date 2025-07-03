//
//  SetThirstReminderPopUpVC.swift
//  Woloo
//
//  Created by Kapil Dongre on 08/02/25.
//

import UIKit

protocol SetThirstReminderPopUpDelegate: NSObjectProtocol{
    
    func didSelectMinutes(minutes: String?)
}

class SetThirstReminderPopUpVC: UIViewController {

    @IBOutlet weak var txtfieldMinute: UITextField!
    
    weak var delegate: SetThirstReminderPopUpDelegate?
    var isZero: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadInitialSettings()
    }

    func loadInitialSettings(){
        
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width - 32, height: 380)
        //self.popupController?.containerView.layer.cornerRadius = 62.8
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = .clear
        
        let btnBookmarkWidth = UIScreen.main.bounds.width - 32
        let btnBookmarkHeight = 380.0
        
        if btnBookmarkWidth < btnBookmarkHeight{
            
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkWidth / 5.7
        }
        else{
            self.popupController?.containerView.layer.cornerRadius = btnBookmarkHeight / 5.7
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.popupController?.backgroundView?.addGestureRecognizer(tap)
        
        txtfieldMinute.addTarget(self, action: #selector(textDidChanged(_:)), for: .editingChanged)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }

        @objc func textDidChanged(_ textField: UITextField) {
            print("Hrs added: \(textField.text)")
            
            if textField.text == "0"{
                self.isZero = true
                print("can't enter 0 as hours")
            }
            else{
                self.isZero = false
            }
        }

                                
                                 
                                 
                            
    @IBAction func clickedBtnSave(_ sender: UIButton) {
        
        if isZero == true{
            self.showToast(message: "Can't enter Zero as hours")
            
        }else{
            if self.delegate != nil {
                self.delegate?.didSelectMinutes(minutes: self.txtfieldMinute.text ?? "")
                self.dismiss(animated: true)
            }
        }
        
    }
    
    @IBAction func clickedBtnBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
