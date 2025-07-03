

//
//  PaymentTypeCell.swift
//  Woloo
//
//  Created by Vivek shinde on 22/12/20.
//

import UIKit

class PaymentTypeCell: UITableViewCell {

    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
