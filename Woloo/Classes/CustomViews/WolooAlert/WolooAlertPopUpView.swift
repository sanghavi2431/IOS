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
    var range: String? = ""
    var errorMessage: String? = ""
    
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
            lblTitle.text = "Awesome, thanks for sharing your review! 🤩"
            lblMessage.text = "You're making it way easier for everyone to find clean washrooms."
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
        if isComeFrom == "OrderNotPlaced"{
            lblTitle.text = "Error..!!"
            lblMessage.text = "There was an issue placing your order"
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
        if isComeFrom == "SAY_IT_WITH_WOLOO"{
            lblTitle.text = "Sent"
            lblMessage.text = "Say it with Woloo has been sent. We will notify the receiver of your thoughtful message!"
        }
        if isComeFrom == "NoWolooFound"{
            lblTitle.text = "Error!"
            lblMessage.text = "Lookout for more radius, there is no near by in \(self.range ?? "2")km, please extend your radius to search woloo"
        }
        if isComeFrom == "SAY_It_With_Woloo"{
            lblTitle.text = "Error!"
            lblMessage.text = "\(self.errorMessage ?? "")"
        }
        
     //   self.vwBack?.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true)
    }

    @IBAction func clickedBtnClodse(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.closePopUp()
            self.dismiss(animated: true)
        }
        self.dismiss(animated: true)
    }
}
