//
//  CartTableViewCell.swift
//  Woloo
//
//  Created by Rahul Patra on 08/08/21.
//

import UIKit
import SDWebImage

class CartTableViewCell: UITableViewCell {
    
    enum AddRemove {
        case add
        case minus
        case delete
    }
    
    static let HEIGHT: CGFloat = 210
    
    //MARK:- Outlets
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var toBePaidLabel: UILabel!
    @IBOutlet weak var pointUsedLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var couponsAppliedLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var addRemoveCompletion: ((AddRemove) -> Void)?
    
    var getSuperController: ECartViewController? {
        get {
            (self.iq.viewContainingController() as? ECartViewController)
        }
    }
    
    var prodyct: LocalProducts? {
        didSet {
            productNameLabel.text = prodyct?.name ?? ""
            setCalculationsViews()
            deleteButton.addTarget(self, action: #selector(tappedOnDeleteButton), for: .touchUpInside)
            plusButton.addTarget(self, action: #selector(tappedOnPlusButton), for: .touchUpInside)
            minusButton.addTarget(self, action: #selector(tappedOnMinusButton), for: .touchUpInside)
            if prodyct?.coupon_applied ?? false {
                couponsAppliedLabel.text = "(Saved Rs.\(Int(prodyct?.getCouponAppliedPrice ?? 0.0))) \(Int(prodyct?.coupon_value ?? 0.0))% Coupon Discount"
            } else {
                couponsAppliedLabel.text = ""
            }
            productImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            productImage.sd_setImage(with: URL(string: prodyct?.productImage ?? ""), completed: nil)
            
            if prodyct?.isErrorShown ?? false {
                errorLabel.isHidden = false
                errorLabel.text = prodyct?.errorMessage ?? ""
            } else {
                errorLabel.text = ""
                errorLabel.isHidden = true
            }
        }
    }
    
    func setCalculationsViews() {
        priceLabel.text = "Rs. \(prodyct?.productPrice ?? 0.0) Inclusive of all taxes"
        toBePaidLabel.text = "To be paid Rs.\(prodyct?.getFinalPrice ?? 0.0)"
        pointUsedLabel.text = "Point Used: \(prodyct?.getFinalusedCoins ?? 0.0)"
        quantityLabel.text = "\(prodyct?.qty ?? 0)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

   class func loadNib() -> UINib? {
        UINib(nibName: "CartTableViewCell", bundle: .main)
    }
    
    @objc private
    func tappedOnPlusButton() {
        prodyct?.qty += 1
        quantityLabel.text = "\(prodyct?.qty ?? 0)"
        
        prodyct?.setAddPrice(withPoints: &getSuperController!.persistance!.totalPoints, clientTotalCoins: getSuperController!.persistance!.mainTotalPrice)
        setCalculationsViews()
        addRemoveCompletion?(.add)
        
    }
    
    @objc private
    func tappedOnMinusButton() {
        prodyct?.qty -= 1
        
        if (prodyct?.qty ?? 0) < 1 {
            prodyct?.qty  = 1
            self.iq.viewContainingController()?.showToast(message: "Quantity should not be less then 1.")
            return
        }
        
        prodyct?.setMinusPrice(withPoints: &getSuperController!.persistance!.totalPoints)
        quantityLabel.text = "\(prodyct?.qty ?? 0)"
        addRemoveCompletion?(.minus)
    }
    
    @objc
    func tappedOnDeleteButton() {
        self.iq.viewContainingController()?.showAlertWithActionOkandCancel(Title: "Woloo", Message: "Are you sure?", OkButtonTitle: "YES", CancelButtonTitle: "NO", outputBlock: { [self] in
            EcommerceModelSingleton.instance?.mainContaxt.delete(prodyct!)
            EcommerceModelSingleton.instance?.saveContext()
            
            let logData = ["product_name": prodyct?.name ?? ""]
            Global.addFirebaseEvent(eventName: "delete_product", param: logData)
            addRemoveCompletion?(.delete)
        })
        
    }
}
