//
//  CartFooterView.swift
//  Woloo
//
//  Created by Rahul Patra on 03/08/21.
//

import UIKit

class CartFooterView: UIView {
    
    @IBOutlet weak var bagTotalLabel: UILabel!
    @IBOutlet weak var shippingChargesLabel: UILabel!
    @IBOutlet weak var bagSubTotalLabel: UILabel!
    @IBOutlet weak var totalPointsusedLabel: UILabel!
    @IBOutlet weak var giftCardusedLabel: UILabel!
    @IBOutlet weak var totalPaybleLabel: UILabel!
    @IBOutlet weak var totalPointsLeftLabel: UILabel!
    
    @IBOutlet weak var applyCoupenCodeButton: UIButton!
    @IBOutlet weak var enterCoupenCodeTextfield: UITextField!
    @IBOutlet weak var couponDiscountLabel: UILabel!
    @IBOutlet weak var minusCouponButton: UIButton!
    @IBOutlet weak var couponAppliedLabel: UILabel!
    
    @IBOutlet weak var coupensBackView: UIView!
    @IBOutlet weak var appliedCouponView: UIView!
    
    
    override func layoutSubviews() {
        coupensBackView.layer.borderWidth = 0.5
        coupensBackView.layer.borderColor = UIColor.lightGray.cgColor
        
        appliedCouponView.layer.borderWidth = 0.5
        appliedCouponView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    class func loadNib() -> CartFooterView? {
        Bundle.main.loadNibNamed("CartFooterView", owner: self, options: nil)?.first as? CartFooterView
    }
}
