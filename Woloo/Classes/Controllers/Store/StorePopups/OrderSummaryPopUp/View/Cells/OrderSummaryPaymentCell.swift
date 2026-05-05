//
//  OrderSummaryPaymentCell.swift
//  Woloo
//
//  Created by CEPL on 09/03/25.
//

import UIKit

protocol OrderSummaryPaymentCellDelegate: NSObjectProtocol{
    
    func didChangePaymentMode()
}

class OrderSummaryPaymentCell: UITableViewCell {

    weak var delegate: OrderSummaryPaymentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedEditPaymentMode(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.didChangePaymentMode()
        }
        
    }
}
