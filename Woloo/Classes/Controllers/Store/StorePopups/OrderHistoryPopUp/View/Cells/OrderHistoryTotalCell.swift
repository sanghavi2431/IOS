//
//  OrderHistoryTotalCell.swift
//  Woloo
//
//  Created by CEPL on 02/07/25.
//

import UIKit

class OrderHistoryTotalCell: UITableViewCell {

    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var lblShippingTotal: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    var objOrderSets = OrderSets()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureOrderHistoryTotalCell(objOrderSets: OrderSets?){
        self.objOrderSets = objOrderSets ?? OrderSets()
        
        self.lblProductPrice.text = String(format: "%@%@/-", "\u{20B9}", self.objOrderSets.original_item_total ?? "")
        self.lblDiscountPrice.text =  String(format: "%@%@/-", "\u{20B9}", self.objOrderSets.discount_total ?? "")
        self.lblShippingTotal.text = String(format: "%@%@/-", "\u{20B9}", self.objOrderSets.shipping_total ?? "")
        self.lblGrandTotal.text = String(format: "%@%@/-", "\u{20B9}", self.objOrderSets.total ?? "")
        
    }
    
}
