//
//  ShadowViewBottom.swift
//  Woloo
//
//  Created by Kapil Dongre on 11/12/24.
//

import Foundation

class ShadowViewBottom: UIView {
    /// The corner radius of the ShadowView, inspectable in Interface Builder
    @IBInspectable var viewCornerRadius: CGFloat = 25.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the ShadowView, inspectable in Interface Builder
    @IBInspectable var shadowColor: UIColor = UIColor.gray {
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
     Masks the layer to its bounds and updates the layer properties and shadow path.
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // Bottom-left and bottom-right corners
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
    private func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds,
                                             byRoundingCorners: [.bottomLeft, .bottomRight],
                                             cornerRadii: CGSize(width: viewCornerRadius, height: viewCornerRadius)).cgPath
    }
    /**
     Updates the shadow path every time the view's frame changes.
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateShadowPath()
    }
}
