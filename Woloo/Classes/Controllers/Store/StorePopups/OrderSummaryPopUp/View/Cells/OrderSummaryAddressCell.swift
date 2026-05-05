//
//  OrderSummaryAddressCell.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import UIKit

protocol OrderSummaryAddressCellDelegate: NSObjectProtocol{
    func didClickedEditBtn(objAddress: StoreAddress?)
}

class OrderSummaryAddressCell: UITableViewCell {

    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblAddressType: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var objAddress = StoreAddress()
    weak var delegate: OrderSummaryAddressCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureOrderSummaryAddressCell(objAddress: StoreAddress?){
        self.objAddress = objAddress ?? StoreAddress()
        if Utility.isEmpty(self.self.objAddress.address_name ?? ""){
            self.lblAddressType.text = "Select Address"
            self.lblAddress.text = "Address not selected"
        }else{
            
            self.lblAddressType.text = self.objAddress.address_name ?? "Select Address"
            
            self.lblAddress.text = "\(self.objAddress.address_1 ?? "")\(self.objAddress.address_2 ?? ""),\(self.objAddress.city ?? ""),\(self.objAddress.province ?? "")\(self.objAddress.postal_code ?? "")"
        }
    }
    
    
    @IBAction func clickedEditBtn(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didClickedEditBtn(objAddress: self.objAddress)
        }
    }
    
}
