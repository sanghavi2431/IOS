//
//  CartTotalCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

class CartTotalCell: UITableViewCell {

    @IBOutlet weak var lblItemTotal: UILabel!
    @IBOutlet weak var lblItemDiscount: UILabel!
//    @IBOutlet weak var lblTotalAfterdiscount: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var lblDeliveryCharges: UILabel!
    
    
    var objCreateCartDetails = CreateCartDetails()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCartTotalCell(objcart: CreateCartDetails?){
        
        self.objCreateCartDetails = objcart ?? CreateCartDetails()
        
        self.lblItemDiscount.text = "Rs. \(self.objCreateCartDetails.discount_total ?? 0)"
        
        self.lblItemTotal.text = "Rs. \(self.objCreateCartDetails.original_item_total ?? 0)"
        
        self.lblGrandTotal.text = "Rs. \(self.objCreateCartDetails.total ?? 0)"
        
        self.lblDeliveryCharges.text = "Rs. \(self.objCreateCartDetails.shipping_total ?? 0)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
