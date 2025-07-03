//
//  CartListCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

protocol CartListCellDelegate: NSObjectProtocol{
    
    func didUpdateProductQuantity(objCartItems: CartItems?, strType: String?)
    
    func didDeleteFromCart(objCartItems: CartItems?)
}


class CartListCell: UITableViewCell {

    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lblSizeColor: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    
    var objCartItems = CartItems()
    weak var delegate: CartListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCartListCell(objCartItems: CartItems?){
        
        self.objCartItems = objCartItems ?? CartItems()
        self.imgVw.layer.cornerRadius = 12.1
        self.lblTitle.text = self.objCartItems.product_title ?? ""
        self.lblPrice.text =  String(format: "%@%d/-","\u{20B9}",self.objCartItems.unit_price ?? 0)
        self.lblSizeColor.text = self.objCartItems.variant?.options?[0].value ?? "-"
        self.lblQuantity.text = String(self.objCartItems.quantity ?? 0)
        self.imgVw.sd_setImage(with: URL(string: objCartItems?.thumbnail ?? ""), completed: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func clickedBtnDelete(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didDeleteFromCart(objCartItems: self.objCartItems)
        }
    }
    
    
    @IBAction func clickedBtnAdd(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didUpdateProductQuantity(objCartItems: self.objCartItems, strType: "Add")
        }
        
    }
    
    
    @IBAction func clickedBtnRemove(_ sender: UIButton) {
        
        if self.delegate != nil{
            self.delegate?.didUpdateProductQuantity(objCartItems: self.objCartItems, strType: "Remove")
        }
    }
    
}
/*
 elf.lblPrice.text = String(format: "%@%d/-","\u{20B9}",self.objProduct.variants?[0].calculated_price?.calculated_amount ?? 0)
 let originalAmount = self.objProduct.variants?.first?.calculated_price?.original_amount ?? 0
 self.lblVariant.text = self.objProduct.variants?.first?.options?.first?.value ?? ""
 
 
 let priceText = String(format: "MRP \u{20B9}%d/-", originalAmount)

 let attributedString = NSAttributedString(
     string: priceText,
     attributes: [
         .strikethroughStyle: NSUnderlineStyle.single.rawValue,
     ]
 )

 self.lblOriginalPrice.attributedText = attributedString
 
 */
