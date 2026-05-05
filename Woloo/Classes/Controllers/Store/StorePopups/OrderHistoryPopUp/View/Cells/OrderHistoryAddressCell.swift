//
//  OrderHistoryAddressCell.swift
//  Woloo
//
//  Created by CEPL on 02/07/25.
//

import UIKit

class OrderHistoryAddressCell: UITableViewCell {

    @IBOutlet weak var lblAddressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    
    var objOrderSets = OrderSets()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureOrderHistoryAddressCell(objOrderSets: OrderSets?){
        self.objOrderSets = objOrderSets ?? OrderSets()
        
        self.lblUserName.text = "\(self.objOrderSets.cart?.shipping_address?.first_name ?? "") \(self.objOrderSets.cart?.shipping_address?.last_name ?? "")"
        self.lblAddress.text = self.objOrderSets.cart?.shipping_address?.address_1 ?? ""
    }
    
}
