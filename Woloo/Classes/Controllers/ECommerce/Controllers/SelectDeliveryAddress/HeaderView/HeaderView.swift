//
//  HeaderView.swift
//  Woloo
//
//  Created by Rahul Patra on 03/08/21.
//

import UIKit

class HeaderView: UIView {
    
    //MARK:- Outlets
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var enterDeliveryCodeLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var selectDeliveryLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var pincodeContainerView: UIView!
    var code: String = ""
    
    var otpView: OTPFieldView = OTPFieldView()
    
    var enterdOTPTCompletion: ((String) -> Void)?
    
    //MARK:- layouts
    override
    func layoutSubviews() {
        setViews()
    }
    
    //MARK:- Custom functions
    func setViews() {
        outerView.roundCorners([.bottomLeft,.bottomRight], radius: Double(outerView.frame.height / 1.5))
        setOTPFieldData()
        pincodeContainerView.backgroundColor = .clear
    }
    
    func setOTPFieldData() {
        
        pincodeContainerView.addSubview(otpView)
        otpView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otpView.leadingAnchor.constraint(equalTo: pincodeContainerView.leadingAnchor) ,
            otpView.trailingAnchor.constraint(equalTo: pincodeContainerView.trailingAnchor) ,
            otpView.topAnchor.constraint(equalTo: pincodeContainerView.topAnchor) ,
            otpView.bottomAnchor.constraint(equalTo: pincodeContainerView.bottomAnchor)
        ])
        
        otpView.defaultBackgroundColor = .clear
        otpView.defaultBorderColor = .white
        otpView.filledBorderColor = .white
        otpView.cursorColor = .green
        otpView.fieldsCount = 6
        otpView.displayType = .underlinedBottom
        otpView.fieldSize = 30
        otpView.separatorSpace = 4
        otpView.shouldAllowIntermediateEditing = false
        otpView.delegate = self
        otpView.initializeUI()
    }
    
    class func loadNib() -> HeaderView? {
        UINib(nibName: "HeaderView", bundle: .main).instantiate(withOwner: self, options: nil).first as? HeaderView
    }
}

//MARK:- OTP text field delegates
extension HeaderView: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        self.code = otp
        enterdOTPTCompletion?(otp)
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        return hasEnteredAll
    }
}


extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: Double) {
//        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        layer.mask = shape
        
        
        let layer1 = CAShapeLayer()
        layer1.fillColor = UIColor.red.cgColor
        layer1.shadowOffset = CGSize(width: 0, height: 2)
        layer1.shadowRadius = 5
        layer1.shadowColor = UIColor.black.cgColor
        layer1.shadowOpacity = 0.5
        layer1.shadowRadius = 2
        
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: frame.maxX, y: 0))
        path.addLine(to: CGPoint(x: frame.maxX, y: self.frame.height - 60))
        path.addQuadCurve(to: CGPoint(x: 0, y: self.frame.height - 60), controlPoint: CGPoint(x: frame.midX, y: self.frame.height + 30))
        path.close()
        
        self.layer.addSublayer(layer1)
        layer1.path = path.cgPath
        layer.mask = layer1
        
    }
}
