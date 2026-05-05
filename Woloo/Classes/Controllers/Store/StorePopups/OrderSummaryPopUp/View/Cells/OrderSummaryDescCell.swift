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
        
        self.lblItemDiscount.text =  String(format: "%@%.2f/-","\u{20B9}",self.objCreateCartDetails.discount_total ?? 0)
        
        
        
        self.lblItemTotal.text = String(format: "%@%.2f/-","\u{20B9}",self.objCreateCartDetails.original_item_total ?? 0)
        
        self.lblTotalAfterdiscount.text = String(format: "%@%.2f/-","\u{20B9}",self.objCreateCartDetails.original_item_total ?? 0)
        
        self.lblGrandTotal.text =  String(format: "%@%.2f/-","\u{20B9}",self.objCreateCartDetails.total ?? 0)
        
        self.lblDeliveryCharges.text = String(format: "%@%.2f/-","\u{20B9}",self.objCreateCartDetails.shipping_total ?? 0)
    }
    
}
