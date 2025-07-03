//
//  CardShadowView.swift
//  Woloo
//
//  Created by CEPL on 23/02/25.
//

import Foundation

class CardShadowView: UIView {
    /// The corner radius of the ShadowView, inspectable in Interface Builder
    @IBInspectable  var viewCornerRadius: CGFloat = 25.0{
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the ShadowView, inspectable in Interface Builder
    //@IBInspectable var shadowColor: UIColor = UIColor.init(red: 204.0/255.0, green: 214.0/255.0, blue: 226.0/255.0, alpha: 1.0)
    // {
    //didSet {
    //self.updateProperties()
    //}
    //}
    
    @IBInspectable var shadowColor: UIColor = UIColor.gray
    {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the ShadowView, inspectable in Interface Builder
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the ShadowView, inspectable in Interface Builder
    @IBInspectable var shadowRadius: CGFloat = 3.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the ShadowView, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateProperties()
        }
    }
    /**
     Masks the layer to it's bounds and updates the layer properties and shadow path.
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.updateProperties()
        self.updateShadowPath()
    }
    /**
     Updates all layer properties according to the public properties of the ShadowView.
     */
    private func updateProperties() {
        self.layer.cornerRadius = self.viewCornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }
    /**
     Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
     */
    private func  updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    /**
     Updates the shadow path everytime the views frame changes.
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateShadowPath()
    }
}
