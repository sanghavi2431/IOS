//
//  OrderSummaryItemListCell.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import UIKit

class OrderSummaryItemListCell: UITableViewCell {

    
    @IBOutlet weak var lblPartName: UILabel!
    @IBOutlet weak var lblSizeQuantity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    var objCartItems = CartItems()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgVw.layer.cornerRadius = 12.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureOrderSummaryItemListCell(objCartItems: CartItems?){
        self.objCartItems = objCartItems ?? CartItems()
        self.lblPartName.text = self.objCartItems.product_title ?? ""
        self.lblPrice.text = "Rs. \(self.objCartItems.unit_price ?? 0)"
        self.imgVw.sd_setImage(with: URL(string: objCartItems?.thumbnail ?? ""), completed: nil)
        self.lblSizeQuantity.text = String(format: "%@",
        "Qty: \(self.objCartItems.quantity ?? 0)")
    }
    
}
