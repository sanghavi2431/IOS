//
//  WolooAlertPopUpView.swift
//  Woloo
//
//  Created by CEPL on 15/02/25.
//

import UIKit
import STPopup

protocol WolooAlertPopUpViewDelegate: AnyObject {
    func closePopUp()
}

class WolooAlertPopUpView: UIViewController {

    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCloase: UIButton!
    
    var isComeFrom: String? = ""
    weak var delegate: WolooAlertPopUpViewDelegate?
    var setFrequency: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadInitalSettings()
    }


    func loadInitalSettings() {
        self.contentSizeInPopup = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.popupController?.containerView.layer.cornerRadius = 8.0
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.backgroundColor = .clear
       
        if isComeFrom == "AddReviewVC"{
            lblTitle.text = "Thank you for sharing your review."
            lblMessage.text = "By sharing your feedback you're helping other user like you with a hygienic washroom experience"
            btnCloase.titleLabel?.text = "Okay"
        }
        if isComeFrom == "Thirst_Reminder"{
            self.lblTitle.isHidden = true
            lblMessage.text = "Thirst reminder set for every \(setFrequency ?? "5") hours"
            btnCloase.titleLabel?.text = "Okay"
        }
        if isComeFrom == "OrderPlaced"{
            lblTitle.text = "Done"
            lblMessage.text = "Your Order Has Been Placed Successfully"
        }
        if isComeFrom == "CoinsApplied"{
            lblTitle.text = "Done"
            lblMessage.text = "Your Woloo Coins Has Been Applied Successfully"
        }
        if isComeFrom == "AddressUpdated"{
           // lblTitle.text = "Done"
            lblMessage.text = "Your Addresss Has Been Updated Successfully"
        }
        if isComeFrom == "AddressDeleted"{
           // lblTitle.text = "Done"
            lblMessage.text = "Your Addresss Has Been Deleted Successfully"
        }
        if isComeFrom == "EmptyCart"{
           // lblTitle.text = "Done"
            lblMessage.text = "Your Cart is Empty, Please Add Items to Continue"
        }
        
        if isComeFrom == "BlogComments"{
           // lblTitle.text = "Done"
            lblMessage.text = "Comment Added Successfully"
        }
        if isComeFrom == "futureSubscription"{
           // lblTitle.text = "Done"
            lblMessage.text = "You alreay have an Active Future Membership. You can buy new Membership only after the future Membership is active"
        }
        
     //   self.vwBack?.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }

    @IBAction func clickedBtnClodse(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.closePopUp()
            //self.dismiss(animated: true)
        }
        self.dismiss(animated: true)
    }
}
