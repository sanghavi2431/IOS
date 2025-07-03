//
//  OrderSummaryDescCell.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import UIKit

class OrderSummaryDescCell: UITableViewCell {

    @IBOutlet weak var lblItemTotal: UILabel!
    @IBOutlet weak var lblItemDiscount: UILabel!
    @IBOutlet weak var lblTotalAfterdiscount: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblDeliveryCharges: UILabel!
    
   
    var objCreateCartDetails = CreateCartDetails()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCartTotalCell(objcart: CreateCartDetails?){
        self.objCreateCartDetails = objcart ?? CreateCartDetails()
        
        self.lblItemDiscount.text = "Rs. \(self.objCreateCartDetails.discount_total ?? 0)"
        
        self.lblItemTotal.text = "Rs. \(self.objCreateCartDetails.original_total ?? 0)"
        
        self.lblTotalAfterdiscount.text = "Rs. \(self.objCreateCartDetails.total ?? 0)"
        
        self.lblGrandTotal.text = "Rs. \(self.objCreateCartDetails.total ?? 0)"
        
        self.lblDeliveryCharges.text = "Rs. \(self.objCreateCartDetails.deliveryCharges ?? 0.0)"
    }
    
}
