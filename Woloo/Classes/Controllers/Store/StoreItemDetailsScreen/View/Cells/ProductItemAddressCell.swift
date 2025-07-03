//
//  ProductItemAddressCell.swift
//  Woloo
//
//  Created by CEPL on 06/03/25.
//

import UIKit

class ProductItemAddressCell: UITableViewCell {

    var objAddress = StoreAddress()
    
    @IBOutlet weak var lblAddressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureProductItemAddressCell(objAddress: StoreAddress?){
        
        self.objAddress = objAddress ?? StoreAddress()
        
        self.lblAddressType.text = self.objAddress.address_name ?? ""
        self.lblAddress.text = "\(self.objAddress.address_1 ?? "")\(self.objAddress.address_2 ?? ""),\(self.objAddress.city ?? ""),\(self.objAddress.province ?? "")\(self.objAddress.postal_code ?? "")"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
