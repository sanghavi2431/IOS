//
//  OTPView.swift
//  Woloo
//
//  Created by Ashish Khobragade on 18/12/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//


import UIKit

protocol OTPProtocol:class {
    
    func didFinishedFilling()
    func didChangeFilling()
}

@IBDesignable
class OTPView: UIControl, UIKeyInput {
    
    weak var delegate:OTPProtocol?
    
    @IBInspectable var numberOfDigits: Int = 6 {
        didSet{
            self.setupViews()
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var spacing: CGFloat = 12 {
        didSet{
            pinsStack.spacing = spacing
            self.setupViews()
            self.layoutIfNeeded()
        }
    }
    
    // MARK:- UIKeyInput Protocol Methods
    var hasText: Bool {
        
        return nextTag > 1 ? true : false
    }
    
    var pinString: String = ""
    
    func insertText(_ text: String) {
        
        if nextTag < (numberOfDigits + 1) {
            (viewWithTag(nextTag)! as! PINView).key = text
             (viewWithTag(nextTag)! as! PINView).text = text
            nextTag += 1
            
            if nextTag == (numberOfDigits + 1) {
                //        resignFirstResponder()
                self.pinString = ""
                for index in 1..<nextTag {
                    self.pinString += (viewWithTag(index)! as! PINView).key
                }
                self.sendActions(for: .editingDidEnd)
            }
        }
     
        if self.pinString.count == numberOfDigits{
            delegate?.didFinishedFilling()
        }
       
        delegate?.didChangeFilling()
    }
    
    func deleteBackward() {
      
        if nextTag > 1 {
            nextTag -= 1
            (viewWithTag(nextTag)! as! PINView).key = ""
            (viewWithTag(nextTag)! as! PINView).text = ""
        }
        self.pinString = ""
        for index in 1..<(numberOfDigits + 1) {
            self.pinString += (viewWithTag(index)! as! PINView).key
        }
        
        delegate?.didChangeFilling()
    }
    
    func clear() {
        while nextTag > 1 {
            deleteBackward()
        }
    }
    
    // MARK: UITextInputTraits
    
    var keyboardType: UIKeyboardType {
        get{
            return .numberPad
        }
        set{
            
        }
    }
    
    // MARK:- LKPINView Properties and Methods
    private var nextTag = 1
    private lazy var pinsStack: UIStackView = {
        
        let sv = UIStackView.init()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fill
        sv.spacing = spacing
        
        return sv
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViewsToTheControl()
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubViewsToTheControl()
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        addSubViewsToTheControl()
        setupViews()
    }
    
    private func addSubViewsToTheControl() {
        self.backgroundColor = .clear
        addSubview(pinsStack)
    }
    
    private func setupViews() {
        
        for pinView in pinsStack.arrangedSubviews {
            pinView.removeFromSuperview()
        }
        
        for cons in constraints {
            if cons.firstAttribute == .width {
                cons.isActive = false
            }
        }
        layoutIfNeeded()
        
        for tag in 1...numberOfDigits {
            let pin = PINView.init(frame: .zero)
            pin.tag = tag
            pin.translatesAutoresizingMaskIntoConstraints = false
            pinsStack.addArrangedSubview(pin)
        }
        
        addConstraints([
            
            pinsStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pinsStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            pinsStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9, constant: 0),
            pinsStack.widthAnchor.constraint(equalTo: pinsStack.heightAnchor, multiplier: CGFloat(numberOfDigits), constant: (CGFloat(numberOfDigits - 1) * spacing)),
            
        ])
        
        for pinnn in pinsStack.arrangedSubviews {
            
            guard let pin = pinnn as? PINView else {return}
            
            pinsStack.addConstraints([
                
                pin.heightAnchor.constraint(equalTo: pinsStack.heightAnchor, multiplier: 1),
                pin.widthAnchor.constraint(equalTo: pin.heightAnchor, constant: 0)
                
            ])
        }
    }
    
    // MARK:- Helper class to generate pin views
    private class PINView: UILabel {
        
        var key: String = "" {
            didSet{
                setupViews()
            }
        }
        
        var hasText: Bool {
            return key != ""
        }
        
        override var bounds: CGRect {
            didSet{
                setupViews()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
     
        
        private func setupViews() {
            
            self.underlined(color:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),width:self.bounds.width)
//            let neededRadius = min(self.bounds.width, self.bounds.height)
            self.layer.cornerRadius = 3.0 //neededRadius / 2
            self.layer.masksToBounds = true
            self.layer.borderWidth = 1.0
            self.textAlignment = .center
//            self.font = ThemeManager.Font.Montserrat_Regular(size: 18)
            self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            if hasText {
                self.layer.borderColor = #colorLiteral(red: 1, green: 0.9443835616, blue: 0, alpha: 1).cgColor
                self.backgroundColor = .clear
            
            } else {
                self.layer.borderColor = UIColor.clear.cgColor//#colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
                self.backgroundColor = .clear
            }
        }
    }
    
}
