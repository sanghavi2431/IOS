//
//  WolooTwoButtonAlert.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 20/02/23.
//

import Foundation
import UIKit

class WolooTwoButtonAlert: UIView {
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    var cancelTappedAction : (() -> Void)?
    
    var cancelUpdateAction : (() -> Void)?
    
    fileprivate var view: UIView!
    
    init(frame: CGRect, cancelButtonText: String?,updateButtonText: String?, title: String?, message: String?, image: UIImage?, controller: UIViewController){
        
        super.init(frame: CGRect(x: 0, y: 0, width: controller.view.frame.width, height: controller.view.frame.height))
        
        setup()
        if var msg = message, msg.count > 0 {
            msg = msg.replacingOccurrences(of: "\\n", with: "\n")
            self.lblMessage.text = msg
            self.lblMessage.isHidden = false
        }else{
            self.lblMessage.isHidden = true
            
        }
        if let btnText = cancelButtonText, btnText.count > 0 {
            self.btnCancel.setTitle(btnText, for: .normal)
            self.btnCancel.isHidden = false
            
            
        }else {
            self.btnCancel.isHidden = true
        }
        if let updateBtnText = updateButtonText, updateButtonText!.count > 0{
            
            self.btnUpdate.setTitle(updateBtnText, for: .normal)
            self.btnUpdate.isHidden = false
        }else{
            self.btnUpdate.isHidden = true
        }
        if (image != nil) {
            self.imgLogo.image = image
            self.imgLogo.isHidden = false
        } else {
            self.imgLogo.isHidden = true
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    fileprivate func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: WolooTwoButtonAlert.self)
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        //guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else { return UIView() }
        return view
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        
        cancelTappedAction?()
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        
        cancelUpdateAction?()
    }
    
}
