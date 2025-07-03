//
//  WolooTabPopUp.swift
//  Woloo
//
//  Created on 25/08/21.
//

import UIKit

class WolooTabPopUp: UIView {
    var tapped: Bool = false

    
    override func awakeFromNib() {
//        mainView.backgroundColor = UIColor(white: 1, alpha: 0.5)
      
        if let gender = UserModel.getAuthorizedUserInfo()?.gender, gender.lowercased() == "male" {
        } else {
        }
    }
    var handleButtonAction: ((_ tag: Int) -> Void)?
    var handleDismissAction: ((_ tag: Int) -> Void)?
    

    
    
    class func instanceFromNib() -> WolooTabPopUp {
        return UINib(nibName: "WolooTabPopUp", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WolooTabPopUp
    }
    
    @IBAction func allButtonAction(_ sender: UIButton) { // tag: 0<shop>, 1<locator>, 2<Tracker>, 3<ExpandAndCollapse>,  4<Thirst Reminder>,
        //new tags: 0<home>, shop<1>, loo locator<2>, profile<3>, period tracker<4>, thirst reminder<5> ,community<6>, Blogs<7>
        
//        print("tap button pressed")
//        if tapped == false{
//            tapped = true
//        }else{
            handleButtonAction?(sender.tag)
//            tapped = false
//        }
        
        
    }
    
   
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        print("Dismiss button action triggered!")
        handleDismissAction?(sender.tag)
    }
}
